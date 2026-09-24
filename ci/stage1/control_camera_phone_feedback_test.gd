extends SceneTree

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
	print("Stage 1 shooter-style mobile movement / look regression")
	var packed := load("res://scenes/probe_world.tscn") as PackedScene
	if packed == null:
		_check("ProbeWorld loads", false, "PackedScene load returned null")
		_finish()
		return

	var world := packed.instantiate()
	root.add_child(world)
	await process_frame

	var first_person_camera := world.get_node("Hunter/FirstPersonCamera") as Camera3D

	_check("first-person FOV remains 115 degrees", absf(first_person_camera.fov - 115.0) < 0.001, str(first_person_camera.fov))

	# Direct analog mapping: no time/alignment/latch state is involved.
	world.set("_view_yaw", 0.0)
	world.call("_set_joystick_from_raw_vector", Vector2.RIGHT)
	var east := world.call("_joystick_world_vector") as Vector3
	_check("right stick deflection maps directly east at north view", east.normalized().dot(Vector3.RIGHT) > 0.999, str(east))

	var yaw_before_hold := float(world.get("_view_yaw"))
	for _frame in range(30):
		await physics_frame
	var yaw_after_hold := float(world.get("_view_yaw"))
	var east_after_hold := world.call("_joystick_world_vector") as Vector3
	_check("holding right does not accumulate camera turning", absf(yaw_after_hold - yaw_before_hold) < 0.00001, "before=%.6f after=%.6f" % [yaw_before_hold, yaw_after_hold])
	_check("holding right keeps the same world movement direction", east_after_hold.normalized().dot(Vector3.RIGHT) > 0.999, str(east_after_hold))

	# Stick angle itself is the movement vector. Moving it changes movement
	# continuously and immediately; no release/center/rebase sequence exists.
	world.call("_set_joystick_from_raw_vector", Vector2(0.70, -0.70))
	var northeast := world.call("_joystick_world_vector") as Vector3
	_check("diagonal input maps continuously between right and forward", northeast.x > 0.6 and northeast.z < -0.6, str(northeast))

	world.call("_set_joystick_from_raw_vector", Vector2(0.0, -1.0))
	var north := world.call("_joystick_world_vector") as Vector3
	_check("up maps directly forward at north view", north.normalized().dot(Vector3(0.0, 0.0, -1.0)) > 0.999, str(north))

	# View is independent and belongs to right-side look. Turning the camera
	# changes the basis used by the left stick, like a mobile shooter.
	var look_sensitivity := float(world.call("_look_degrees_per_pixel"))
	_check("look sensitivity is finite and positive", look_sensitivity > 0.0 and look_sensitivity < 1.0, str(look_sensitivity))

	world.call("_apply_look_delta", Vector2(300.0, 0.0))
	var turned_yaw := float(world.get("_view_yaw"))
	_check("right-side drag changes view yaw", turned_yaw < -0.01, str(turned_yaw))

	var forward_after_look := world.call("_joystick_world_vector") as Vector3
	_check("held forward movement follows the updated camera basis", forward_after_look.x > 0.25 and forward_after_look.z < -0.25, str(forward_after_look))

	# The movement stick itself must never change view yaw.
	world.call("_set_joystick_from_raw_vector", Vector2.LEFT)
	var yaw_before_left_hold := float(world.get("_view_yaw"))
	for _frame in range(30):
		await physics_frame
	var yaw_after_left_hold := float(world.get("_view_yaw"))
	_check("left-stick movement never turns the camera by itself", absf(yaw_after_left_hold - yaw_before_left_hold) < 0.00001, "before=%.6f after=%.6f" % [yaw_before_left_hold, yaw_after_left_hold])

	# First-person vertical look is bounded and shares the same direct right-drag input.
	world.set("_first_person", true)
	world.call("_apply_look_delta", Vector2(0.0, -10000.0))
	var pitch_up := float(world.get("_view_pitch"))
	_check("first-person pitch clamps at configured limit", rad_to_deg(pitch_up) <= 80.001 and rad_to_deg(pitch_up) >= -80.001, str(rad_to_deg(pitch_up)))

	# Multi-touch ownership: movement and look may be active at the same time.
	world.set("_joystick_touch_id", 7)
	world.set("_look_touch_id", 9)
	_check("movement and look use independent touch owners", int(world.get("_joystick_touch_id")) == 7 and int(world.get("_look_touch_id")) == 9)

	world.call("_reset_transient_controls")
	var reset_world := world.call("_joystick_world_vector") as Vector3
	_check("transient reset zeros movement", reset_world.length_squared() < 0.00001, str(reset_world))
	_check("transient reset releases movement touch", int(world.get("_joystick_touch_id")) == -1)
	_check("transient reset releases look touch", int(world.get("_look_touch_id")) == -1)

	# User's core acceptance rule: a fixed side deflection means the desired
	# movement direction has been reached; it must stay fixed until the stick or
	# camera actually changes.
	world.set("_view_yaw", 0.0)
	world.call("_set_joystick_from_raw_vector", Vector2.RIGHT)
	var desired_direction := world.call("_joystick_world_vector") as Vector3
	for _frame in range(60):
		await physics_frame
	var still_desired_direction := world.call("_joystick_world_vector") as Vector3
	_check(
		"unchanged side deflection means keep the reached desired direction",
		desired_direction.normalized().dot(still_desired_direction.normalized()) > 0.9999,
		"start=%s end=%s" % [desired_direction, still_desired_direction]
	)

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	print("Gate: STAGE1_SHOOTER_STYLE_CONTROLS_RUNTIME_VERIFIED" if failures.is_empty() else "Gate: STAGE1_SHOOTER_STYLE_CONTROLS_RUNTIME_FAILED")
	print("This headless result does NOT replace the required Galaxy A03s feel test.")
	quit(0 if failures.is_empty() else 1)
