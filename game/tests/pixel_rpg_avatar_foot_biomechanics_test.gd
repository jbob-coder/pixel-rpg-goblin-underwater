extends SceneTree

const FOOT := preload("res://scripts/presentation/pixel_rpg/avatar/pixel_rpg_foot_biomechanics.gd")

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
	print("Pixel RPG avatar foot biomechanics v1 gate")

	_check("schema is stable", FOOT.get_schema() == "pixel_rpg.avatar_foot_biomechanics.v1")
	_check("left side supported", FOOT.is_supported_side(FOOT.SIDE_LEFT))
	_check("right side supported", FOOT.is_supported_side(FOOT.SIDE_RIGHT))
	_check("walk mode supported", FOOT.is_supported_mode(FOOT.MODE_WALK))
	_check("run mode supported", FOOT.is_supported_mode(FOOT.MODE_RUN))
	_check("crouch mode supported", FOOT.is_supported_mode(FOOT.MODE_CROUCH))

	var order := FOOT.get_joint_order()
	_check("functional rig exposes seven controlled pivots", order.size() == 7, str(order))
	_check("ankle is first controlled pivot", order[0] == FOOT.JOINT_ANKLE)
	_check("MTP pivot exists for forefoot rocker", FOOT.JOINT_MTP in order)
	_check("big toe and lesser-toe controls are separate", FOOT.JOINT_BIG_TOE in order and FOOT.JOINT_LESSER_TOES in order)

	var host := Node3D.new()
	root.add_child(host)
	var left := FOOT.create_joint_chain(host, FOOT.SIDE_LEFT)
	var right := FOOT.create_joint_chain(host, FOOT.SIDE_RIGHT)

	_check("left rig root created", left.get("root") is Node3D)
	_check("right rig root created", right.get("root") is Node3D)
	_check("left rig stores presentation-only contract", bool((left.get("root") as Node3D).get_meta("pixel_rpg_presentation_only", false)))
	_check("right rig stores stable schema metadata", String((right.get("root") as Node3D).get_meta("pixel_rpg_schema", "")) == FOOT.get_schema())

	for key in FOOT.get_joint_order():
		_check("left joint exists: %s" % key, left.get(key) is Node3D)
		_check("right joint exists: %s" % key, right.get(key) is Node3D)

	var walk_contact := FOOT.sample_pose(FOOT.MODE_WALK, 0.00)
	var walk_mid := FOOT.sample_pose(FOOT.MODE_WALK, 0.34)
	var walk_toe_off := FOOT.sample_pose(FOOT.MODE_WALK, 0.60)
	var walk_swing := FOOT.sample_pose(FOOT.MODE_WALK, 0.76)

	_check("walk starts with slight plantarflexion", float(walk_contact["ankle_pitch_deg"]) < 0.0, str(walk_contact))
	_check("walk ankle rocker reaches dorsiflexion", float(walk_mid["ankle_pitch_deg"]) >= 8.0, str(walk_mid))
	_check("walk forefoot rocker reaches about 40+ deg MTP extension", float(walk_toe_off["mtp_pitch_deg"]) >= 40.0, str(walk_toe_off))
	_check("walk toe-off uses plantarflexion", float(walk_toe_off["ankle_pitch_deg"]) <= -12.0, str(walk_toe_off))
	_check("walk swing restores dorsiflexion for clearance", float(walk_swing["ankle_pitch_deg"]) > 0.0, str(walk_swing))

	var run_contact := FOOT.sample_pose(FOOT.MODE_RUN, 0.00)
	var run_push := FOOT.sample_pose(FOOT.MODE_RUN, 0.38)
	var run_swing := FOOT.sample_pose(FOOT.MODE_RUN, 0.74)
	_check("run suppresses heel-rocker plantarflexed landing", float(run_contact["ankle_pitch_deg"]) >= 0.0, str(run_contact))
	_check("run push-off has stronger plantarflexion than walk", float(run_push["ankle_pitch_deg"]) < float(walk_toe_off["ankle_pitch_deg"]), str(run_push))
	_check("run push-off uses high MTP extension", float(run_push["mtp_pitch_deg"]) >= 50.0, str(run_push))
	_check("run swing maintains toe clearance", float(run_swing["ankle_pitch_deg"]) >= 8.0, str(run_swing))

	var crouch_mid := FOOT.sample_pose(FOOT.MODE_CROUCH, 0.38)
	var crouch_toe_off := FOOT.sample_pose(FOOT.MODE_CROUCH, 0.68)
	_check("crouch loaded stance uses more dorsiflexion than walk", float(crouch_mid["ankle_pitch_deg"]) > float(walk_mid["ankle_pitch_deg"]), str(crouch_mid))
	_check("crouch keeps a forefoot rocker", float(crouch_toe_off["mtp_pitch_deg"]) >= 40.0, str(crouch_toe_off))

	for mode in [FOOT.MODE_WALK, FOOT.MODE_RUN, FOOT.MODE_CROUCH]:
		for sample_index in range(41):
			var phase := float(sample_index) / 40.0
			var pose := FOOT.sample_pose(mode, phase)
			var validation: Dictionary = FOOT.validate_pose(pose)
			_check("%s pose %.3f stays inside rig limits" % [mode, phase], bool(validation["success"]), str(validation["errors"]))

	FOOT.apply_pose(left, walk_toe_off)
	var left_ankle := left[FOOT.JOINT_ANKLE] as Node3D
	var left_subtalar := left[FOOT.JOINT_SUBTALAR] as Node3D
	_check("apply_pose writes ankle pitch", absf(left_ankle.rotation_degrees.x - float(walk_toe_off["ankle_pitch_deg"])) <= 0.001)
	_check("left subtalar roll is mirrored for anatomical symmetry", absf(left_subtalar.rotation_degrees.z + float(walk_toe_off["subtalar_roll_deg"])) <= 0.001)

	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_AVATAR_FOOT_BIOMECHANICS_V1_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_AVATAR_FOOT_BIOMECHANICS_V1_FAILED")
	print("This gate verifies the presentation-only joint chain and bounded walk/run/crouch foot motion curves. It does not yet replace the current HunterVisual, bind a production skinned mesh, or prove physical-device animation quality.")
	quit(0 if failures.is_empty() else 1)
