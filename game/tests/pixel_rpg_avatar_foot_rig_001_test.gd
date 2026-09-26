extends SceneTree

const FOOT_RIG := preload("res://scripts/presentation/pixel_rpg/avatar_foot_rig_001.gd")

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
	print("Pixel RPG Avatar Foot Rig 001 — articulated foot contract")

	_check("schema is stable", FOOT_RIG.get_schema() == "pixel_rpg.avatar_foot_rig_001.v1")
	_check("five foot control joints are defined", FOOT_RIG.get_joint_order().size() == 5)
	_check("heel contact is helper, not deform joint", not FOOT_RIG.get_joint_order().has(FOOT_RIG.HELPER_HEEL_CONTACT))

	var specs: Dictionary = FOOT_RIG.get_joint_specs()
	_check("ankle maps to talocrural role", String(specs[FOOT_RIG.JOINT_ANKLE]["anatomy"]) == "talocrural")
	_check("subtalar control exists", specs.has(FOOT_RIG.JOINT_SUBTALAR))
	_check("midfoot proxy exists", specs.has(FOOT_RIG.JOINT_MIDFOOT))
	_check("ball/MTP proxy exists", specs.has(FOOT_RIG.JOINT_BALL))
	_check("toe/IP proxy exists", specs.has(FOOT_RIG.JOINT_TOE))

	var contract: Dictionary = FOOT_RIG.validate_contract()
	_check("all authored gait samples remain inside production limits", bool(contract.get("success", false)), str(contract.get("errors", [])))
	_check("all three locomotion modes are exposed", int(contract.get("mode_count", 0)) == 3)

	var left_skeleton := Skeleton3D.new()
	var left_ankle_index := left_skeleton.add_bone("ankle_l")
	_check("test ankle bone can be created", left_ankle_index == 0)

	var first_build: Dictionary = FOOT_RIG.ensure_joint_chain(
		left_skeleton,
		FOOT_RIG.SIDE_LEFT,
		"ankle_l",
		0.27,
		0.09
	)
	_check("left support chain builds", bool(first_build.get("success", false)), str(first_build))
	_check("four auxiliary bones are created under existing ankle", (first_build.get("created", []) as Array).size() == 4)
	_check("left skeleton now has ankle plus four support bones", left_skeleton.get_bone_count() == 5)

	var indices := first_build.get("indices", {}) as Dictionary
	_check(
		"subtalar is parented to ankle",
		left_skeleton.get_bone_parent(int(indices[FOOT_RIG.JOINT_SUBTALAR])) == int(indices[FOOT_RIG.JOINT_ANKLE])
	)
	_check(
		"midfoot is parented to subtalar",
		left_skeleton.get_bone_parent(int(indices[FOOT_RIG.JOINT_MIDFOOT])) == int(indices[FOOT_RIG.JOINT_SUBTALAR])
	)
	_check(
		"ball is parented to midfoot",
		left_skeleton.get_bone_parent(int(indices[FOOT_RIG.JOINT_BALL])) == int(indices[FOOT_RIG.JOINT_MIDFOOT])
	)
	_check(
		"toe is parented to ball",
		left_skeleton.get_bone_parent(int(indices[FOOT_RIG.JOINT_TOE])) == int(indices[FOOT_RIG.JOINT_BALL])
	)

	var second_build: Dictionary = FOOT_RIG.ensure_joint_chain(left_skeleton, FOOT_RIG.SIDE_LEFT, "ankle_l")
	_check("joint-chain creation is idempotent", bool(second_build.get("success", false)))
	_check("second build creates no duplicates", (second_build.get("created", []) as Array).is_empty())
	_check("bone count stays stable on second build", left_skeleton.get_bone_count() == 5)

	var walk_mid: Dictionary = FOOT_RIG.sample_cycle(FOOT_RIG.MODE_WALK, 0.45)
	var walk_push: Dictionary = FOOT_RIG.sample_cycle(FOOT_RIG.MODE_WALK, 0.58)
	var walk_swing: Dictionary = FOOT_RIG.sample_cycle(FOOT_RIG.MODE_WALK, 0.78)
	_check("walk mid-stance uses ankle dorsiflexion", float(walk_mid["ankle_pitch_deg"]) > 0.0, str(walk_mid))
	_check("walk forefoot rocker flexes ball/MTP control", float(walk_push["ball_pitch_deg"]) >= 35.0, str(walk_push))
	_check("walk swing clears the ground", not bool(walk_swing["is_grounded"]) and float(walk_swing["lift_m"]) > 0.0, str(walk_swing))

	var run_flight: Dictionary = FOOT_RIG.sample_cycle(FOOT_RIG.MODE_RUN, 0.62)
	_check("run includes a flight phase", String(run_flight["phase_name"]) == "flight" and not bool(run_flight["is_grounded"]))
	_check("run flight has greater authored clearance than walk swing", float(run_flight["lift_m"]) > float(walk_swing["lift_m"]))

	var crouch_support: Dictionary = FOOT_RIG.sample_cycle(FOOT_RIG.MODE_CROUCH_WALK, 0.52)
	var crouch_swing: Dictionary = FOOT_RIG.sample_cycle(FOOT_RIG.MODE_CROUCH_WALK, 0.86)
	_check("crouch support keeps ankle dorsiflexed", float(crouch_support["ankle_pitch_deg"]) >= 12.0, str(crouch_support))
	_check("crouch swing remains lower than normal walk swing", float(crouch_swing["lift_m"]) < float(walk_swing["lift_m"]))
	_check("crouch gait uses a shorter authored stride", absf(float(crouch_swing["stride_norm"])) < absf(float(walk_swing["stride_norm"])))

	var pose_result: Dictionary = FOOT_RIG.apply_sample(
		left_skeleton,
		FOOT_RIG.SIDE_LEFT,
		"ankle_l",
		walk_push
	)
	_check("sample can be applied to the constructed Skeleton3D chain", bool(pose_result.get("success", false)), str(pose_result))

	var bad_side: Dictionary = FOOT_RIG.ensure_joint_chain(left_skeleton, "middle", "ankle_l")
	_check("invalid side is rejected", not bool(bad_side.get("success", true)))

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_AVATAR_FOOT_RIG_001_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_AVATAR_FOOT_RIG_001_FAILED")
	print("This gate verifies the isolated five-control foot rig contract, gait sampling, limits, parent chain and idempotent Skeleton3D support-bone creation. It does not prove mesh skin weights, final avatar topology, AnimationTree integration, or physical-device behavior.")
	quit(0 if failures.is_empty() else 1)
