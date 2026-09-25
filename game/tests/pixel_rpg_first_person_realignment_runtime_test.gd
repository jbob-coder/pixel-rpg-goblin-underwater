extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const CAMERA_MATH := preload("res://scripts/presentation/pixel_rpg/first_person_camera_math_001.gd")
const PLAYER_MOTION := preload("res://scripts/presentation/pixel_rpg/player_motion_math_001.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _run() -> void:
	print("Pixel RPG first-person realignment + extracted camera-math parity gate")

	_check("camera-math owner schema is stable", String(CAMERA_MATH.get_schema()) == "pixel_rpg.first_person_camera_math_001.v1")
	_check("camera-math zero input remains zero", CAMERA_MATH.camera_relative_movement(Basis.IDENTITY, Vector2.ZERO).is_equal_approx(Vector3.ZERO))
	var pure_forward: Vector3 = CAMERA_MATH.camera_relative_movement(Basis.IDENTITY, Vector2(0.0, -1.0))
	_check("camera-math identity forward remains normalized -Z", pure_forward.is_equal_approx(Vector3(0.0, 0.0, -1.0)), str(pure_forward))
	var pure_look: Vector2 = CAMERA_MATH.apply_look_delta(0.0, 0.0, Vector2(24.0, -18.0), 0.105, -78.0, 78.0)
	_check("camera-math horizontal look sign remains exact", is_equal_approx(pure_look.x, -deg_to_rad(2.52)), str(pure_look.x))
	_check("camera-math vertical look sign remains exact", is_equal_approx(pure_look.y, deg_to_rad(1.89)), str(pure_look.y))
	var clamped_look: Vector2 = CAMERA_MATH.apply_look_delta(0.0, 0.0, Vector2(0.0, -5000.0), 0.105, -78.0, 78.0)
	_check("camera-math pitch clamp remains exact", is_equal_approx(clamped_look.y, deg_to_rad(78.0)), str(rad_to_deg(clamped_look.y)))

	_check("player-motion owner schema is stable", String(PLAYER_MOTION.get_schema()) == "pixel_rpg.player_motion_math_001.v1")
	var horizontal_velocity: Vector3 = PLAYER_MOTION.apply_horizontal_velocity(Vector3(9.0, 3.25, 8.0), Vector3(0.6, 0.0, -0.8), 5.2)
	_check("player-motion horizontal velocity preserves Y", is_equal_approx(horizontal_velocity.y, 3.25), str(horizontal_velocity))
	_check("player-motion horizontal speed mapping stays exact", is_equal_approx(horizontal_velocity.x, 3.12) and is_equal_approx(horizontal_velocity.z, -4.16), str(horizontal_velocity))
	var airborne_y: float = PLAYER_MOTION.apply_vertical_velocity(2.0, false, 0.1, 9.8)
	_check("player-motion airborne gravity stays exact", is_equal_approx(airborne_y, 1.02), str(airborne_y))
	var floor_y: float = PLAYER_MOTION.apply_vertical_velocity(-3.0, true, 0.1, 9.8)
	_check("player-motion grounded downward velocity keeps floor-stick contract", is_equal_approx(floor_y, -0.1), str(floor_y))
	_check("player-motion respawn threshold remains strict", PLAYER_MOTION.should_respawn(-8.01, -8.0) and not PLAYER_MOTION.should_respawn(-8.0, -8.0))
	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype scene instantiates", prototype != null)
	if prototype == null:
		_finish()
		return

	var pre_tree_hunter := prototype.get_node("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
	var hunter_before := pre_tree_hunter.transform
	root.add_child(prototype)

	# _ready() is presentation initialization. Capture immediately after enter-tree,
	# before a physics tick can legitimately apply gravity/floor settling.
	var hunter_after_presentation_init := pre_tree_hunter.transform
	await process_frame
	await physics_frame
	await process_frame

	var hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
	var hunter_visual := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/Visual") as Node3D
	var yaw := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw") as Node3D
	var pitch := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch") as Node3D
	var spring_arm := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/SpringArm3D") as SpringArm3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D

	_check("existing Hunter controller remains authoritative", hunter != null)
	_check("presentation init preserves Hunter logical transform", hunter_after_presentation_init.is_equal_approx(hunter_before), str(hunter_after_presentation_init))
	_check("direct first-person camera exists and is current", camera != null and camera.current)
	_check("third-person hunter visual does not obstruct first-person view", hunter_visual != null and not hunter_visual.visible)
	_check("SpringArm is retained only as inactive legacy node", spring_arm != null and spring_arm.get_node_or_null("Camera3D") == null)
	_check("eye pivot is at believable player height", pitch != null and pitch.position.y >= 0.55 and pitch.position.y <= 0.80, str(pitch.position if pitch != null else Vector3.ZERO))
	_check("first-person FOV stays bounded", camera != null and camera.fov >= 65.0 and camera.fov <= 80.0, str(camera.fov if camera != null else -1.0))

	if camera != null and spring_arm != null and pitch != null:
		var camera_local_before := camera.transform
		var camera_parent_before := camera.get_parent()
		spring_arm.spring_length = 0.5
		await process_frame
		_check(
			"camera no longer depends on chase-camera spring length",
			camera.get_parent() == camera_parent_before
				and camera.get_parent() == pitch
				and camera.transform.is_equal_approx(camera_local_before),
			"parent=%s local=%s -> %s" % [camera.get_parent().name, camera_local_before, camera.transform]
		)

	if yaw != null and pitch != null:
		var yaw_before := yaw.rotation.y
		prototype.call("_apply_look_delta", Vector2(24.0, -18.0))
		_check("right-look changes first-person yaw", not is_equal_approx(yaw.rotation.y, yaw_before))
		_check("pitch remains inside first-person clamp", rad_to_deg(pitch.rotation.x) >= -78.1 and rad_to_deg(pitch.rotation.x) <= 78.1, "%.2f" % rad_to_deg(pitch.rotation.x))

	var move: Vector3 = prototype.call("_camera_relative_movement", Vector2(0.0, -1.0))
	_check("existing movement remains camera-relative and normalized", absf(move.length() - 1.0) <= 0.01 and absf(move.y) <= 0.001, str(move))

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_FIRST_PERSON_REALIGNMENT_RUNTIME_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_FIRST_PERSON_REALIGNMENT_RUNTIME_FAILED")
	print("This gate verifies extracted first-person camera and player-motion math plus host wrapper/runtime parity; input ownership, CharacterBody3D move_and_slide authority, physical Android feel, obstruction and final visual acceptance remain separate gates.")
	quit(0 if failures.is_empty() else 1)
