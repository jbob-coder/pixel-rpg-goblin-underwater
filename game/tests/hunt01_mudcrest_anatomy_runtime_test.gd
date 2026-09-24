extends SceneTree

const ANATOMY_SCRIPT: Script = preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd")
const ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const TECHNIQUE_ID := "POLEBLADE_MEASURED_CUT"

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _handoff(resolution_id: String, action_sequence: int, target_group: String, hit_quality: String, protection_profile: String) -> Dictionary:
	return {
		"status": "PENDING_ANATOMY_DAMAGE_RUNTIME",
		"resolution_id": resolution_id,
		"encounter_id": ENCOUNTER_ID,
		"round_id": 2,
		"action_sequence": action_sequence,
		"attacker_id": HUNTER_ID,
		"defender_id": MONSTER_ID,
		"technique_id": TECHNIQUE_ID,
		"resolved_target_group": target_group,
		"hit_quality": hit_quality,
		"damage_channel": "CUTTING",
		"protection_profile": protection_profile,
	}

func _run() -> void:
	print("Hunt-01 Mudcrest anatomy integrity runtime")
	var world := Node3D.new()
	world.name = "World"
	root.add_child(world)
	var geometry := Node3D.new()
	geometry.name = "WorldGeometry"
	world.add_child(geometry)
	var monster := Node3D.new()
	monster.name = MONSTER_ID
	geometry.add_child(monster)

	var anatomy := ANATOMY_SCRIPT.new() as Node
	anatomy.name = "MudcrestAnatomyRuntime"
	world.add_child(anatomy)
	var encounter_record := {
		"encounter_id": ENCOUNTER_ID,
		"monster_id": MONSTER_ID,
	}
	_check("anatomy runtime initializes against stable encounter/Monster identity", bool(anatomy.call("initialize", world, encounter_record)))
	_check("anatomy schema v1", String(anatomy.call("get_schema")) == "uhr.hunt01.mudcrest_anatomy.v1")
	var target_groups: Array = anatomy.call("get_target_groups")
	_check("eight authoritative groups plus internal torso fallback are present", target_groups == ["HEAD", "HORN_CREST", "FORELEG_L", "FORELEG_R", "HINDLEG_L", "HINDLEG_R", "DORSAL_PLATES", "TAIL", "GENERAL_TORSO"], str(target_groups))
	var dorsal_before: Dictionary = anatomy.call("get_target_state", "DORSAL_PLATES")
	_check("normalized Dorsal integrity fixture starts at 100", int(dorsal_before.get("integrity", -1)) == 100 and String(dorsal_before.get("fixture_status", "")) == "PROVISIONAL_FIRST_SLICE_ANATOMY_INTEGRITY_FIXTURE", str(dorsal_before))

	var dorsal_handoff := _handoff("enc_r01_ef02_m01_0001:2:1:POLEBLADE_MEASURED_CUT", 1, "DORSAL_PLATES", "CLEAN", "MINERALIZED_DORSAL_PLATE")
	var dorsal_result: Dictionary = anatomy.call("apply_damage_handoff_for_test", dorsal_handoff)
	_check("clean cutting contact on Dorsal Plates applies provisional integrity loss", bool(dorsal_result.get("success", false)) and bool(dorsal_result.get("applied", false)) and String(dorsal_result.get("status", "")) == "ANATOMY_INTEGRITY_APPLIED", str(dorsal_result))
	_check("Dorsal fixture routes 12 load through 7 plate reduction", int(dorsal_result.get("base_integrity_load", -1)) == 12 and int(dorsal_result.get("protection_reduction", -1)) == 7 and int(dorsal_result.get("integrity_loss", -1)) == 5, str(dorsal_result))
	_check("Dorsal integrity becomes 95 only", int(anatomy.call("get_target_state", "DORSAL_PLATES").get("integrity", -1)) == 95 and int(anatomy.call("get_target_state", "TAIL").get("integrity", -1)) == 100, str(anatomy.call("get_all_target_states")))
	_check("no break/sever threshold is evaluated", String(dorsal_result.get("structural_threshold_status", "")) == "NOT_EVALUATED_BREAK_SEVER_DEFERRED", str(dorsal_result))

	var duplicate_result: Dictionary = anatomy.call("apply_damage_handoff_for_test", dorsal_handoff)
	_check("duplicate resolution is idempotent", bool(duplicate_result.get("success", false)) and not bool(duplicate_result.get("applied", true)) and bool(duplicate_result.get("duplicate", false)) and String(duplicate_result.get("status", "")) == "DUPLICATE_RESOLUTION_NO_REAPPLY", str(duplicate_result))
	_check("duplicate does not reduce Dorsal integrity twice", int(anatomy.call("get_target_state", "DORSAL_PLATES").get("integrity", -1)) == 95)
	_check("duplicate does not increase applied-resolution count", int(anatomy.call("get_applied_resolution_count")) == 1)

	var collision_handoff := dorsal_handoff.duplicate(true)
	collision_handoff["resolved_target_group"] = "TAIL"
	collision_handoff["protection_profile"] = "MUSCULAR_TAIL_DISTAL_RIDGE"
	var collision_result: Dictionary = anatomy.call("apply_damage_handoff_for_test", collision_handoff)
	_check("same resolution ID with changed source fingerprint is rejected", not bool(collision_result.get("success", true)) and String(collision_result.get("reason", "")) == "RESOLUTION_ID_COLLISION", str(collision_result))

	var torso_handoff := _handoff("enc_r01_ef02_m01_0001:2:2:POLEBLADE_MEASURED_CUT", 2, "GENERAL_TORSO", "GRAZE", "HIDE_TORSO")
	var torso_result: Dictionary = anatomy.call("apply_damage_handoff_for_test", torso_handoff)
	_check("body-fallback torso contact is a first-class integrity target", bool(torso_result.get("applied", false)) and String(torso_result.get("target_group", "")) == "GENERAL_TORSO", str(torso_result))
	_check("torso GRAZE fixture routes 4 load through 1 hide reduction", int(torso_result.get("integrity_loss", -1)) == 3 and int(torso_result.get("integrity_after", -1)) == 97, str(torso_result))
	_check("uncontacted Head remains baseline", int(anatomy.call("get_target_state", "HEAD").get("integrity", -1)) == 100)

	var bad_protection := _handoff("enc_r01_ef02_m01_0001:2:3:POLEBLADE_MEASURED_CUT", 3, "DORSAL_PLATES", "CLEAN", "HIDE_TORSO")
	var bad_result: Dictionary = anatomy.call("apply_damage_handoff_for_test", bad_protection)
	_check("mismatched local protection is rejected", not bool(bad_result.get("success", true)) and String(bad_result.get("reason", "")) == "PROTECTION_PROFILE_MISMATCH", str(bad_result))
	_check("rejected handoff does not mutate Dorsal integrity", int(anatomy.call("get_target_state", "DORSAL_PLATES").get("integrity", -1)) == 95)

	var miss_handoff := _handoff("enc_r01_ef02_m01_0001:2:4:POLEBLADE_MEASURED_CUT", 4, "", "MISS", "NONE_NO_CONTACT")
	var miss_result: Dictionary = anatomy.call("apply_damage_handoff_for_test", miss_handoff)
	_check("MISS is consumed once with no integrity change", bool(miss_result.get("success", false)) and not bool(miss_result.get("applied", true)) and String(miss_result.get("status", "")) == "NO_CONTACT_NO_INTEGRITY_CHANGE", str(miss_result))
	_check("three valid resolution IDs are recorded exactly once", int(anatomy.call("get_applied_resolution_count")) == 3)

	var trace: Array = anatomy.call("get_trace")
	var resolved_events := 0
	var duplicate_events := 0
	var rejected_events := 0
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		match String(entry.get("event", "")):
			"ANATOMY_INTEGRITY_RESOLVED":
				resolved_events += 1
			"ANATOMY_HANDOFF_DUPLICATE":
				duplicate_events += 1
			"ANATOMY_HANDOFF_REJECTED":
				rejected_events += 1
	_check("trace records two integrity resolutions, one duplicate and two rejections", resolved_events == 2 and duplicate_events == 1 and rejected_events == 2, str(trace))

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_MUDCREST_ANATOMY_INTEGRITY_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_MUDCREST_ANATOMY_INTEGRITY_RUNTIME_FAILED")
	print("Final damage balance, break/sever/status, Monster behavior, phone acceptance and performance are not claimed by this gate.")
	quit(0 if failures.is_empty() else 1)
