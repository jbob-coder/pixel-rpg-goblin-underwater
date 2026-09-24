extends SceneTree

const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _settle_hunter(hunter: CharacterBody3D, position: Vector3) -> void:
	hunter.global_position = position
	hunter.velocity = Vector3.ZERO
	for _frame in range(8):
		await physics_frame
		await process_frame

func _run() -> void:
	print("Hunt-01 first Hunter attack / selected-part contact + anatomy integrity")
	var packed := load("res://scenes/regions/region_01_hunt01_graybox.tscn") as PackedScene
	if packed == null:
		_check("production Region-01 scene loads", false)
		_finish()
		return

	var world := packed.instantiate() as Node3D
	root.add_child(world)
	for _frame in range(4):
		await process_frame
		await physics_frame

	var hunter := world.get_node("Hunter") as CharacterBody3D
	var monster := world.get_node("WorldGeometry/monster_r01_m01_0001") as Node3D
	var tracking := world.get_node("TrackingRuntime")
	var encounter := world.get_node("EncounterRuntime")
	var evidence_ids := [
		"R01_H01_EV01_OUTER_PRINTS",
		"R01_H01_EV02_BANK_REEDS",
		"R01_H01_EV03_FRESH_WALLOW",
		"R01_H01_EV05_OLD_ROOT_SCRAPE",
		"R01_H01_EV04_WATER_EXIT",
		"R01_H01_EV06_FEEDING_REMAINS",
		"R01_H01_EV07_FLATTENED_GRASS_AUDIO",
	]
	for evidence_id in evidence_ids:
		_check("tracking accepts %s" % evidence_id, bool(tracking.call("record_evidence_for_test", evidence_id)))
		await process_frame
	var inference: Dictionary = tracking.call("get_current_inference")
	_check("tracking reaches observation-ready", String(inference.get("phase", "")) == "OBSERVATION_READY", str(inference))

	await _settle_hunter(hunter, Vector3(-72.0, 0.875, -236.0))
	_check("engagement becomes available", String(encounter.call("get_state")) == "ENGAGEMENT_AVAILABLE", String(encounter.call("get_state")))
	var monster_before := monster.global_transform
	_check("explicit ENGAGE succeeds", bool(encounter.call("engage_for_test")))
	_check("Mudcrest anatomy runtime reports started", bool(encounter.call("has_mudcrest_anatomy_started")))
	_check("Hunter attack runtime reports started", bool(encounter.call("has_hunter_attack_started")))

	var shell := world.get_node_or_null("CombatTurnShellRuntime")
	var movement := world.get_node_or_null("CombatTurnShellRuntime/TacticalMovementRuntime")
	var anatomy := world.get_node_or_null("CombatTurnShellRuntime/MudcrestAnatomyRuntime")
	var attack := world.get_node_or_null("CombatTurnShellRuntime/HunterAttackRuntime")
	_check("combat shell exists", shell != null)
	_check("movement runtime exists", movement != null)
	_check("Mudcrest anatomy runtime exists", anatomy != null)
	_check("Hunter attack runtime exists", attack != null)
	if shell == null or movement == null or anatomy == null or attack == null:
		_finish()
		return

	_check("Hunter attack schema v1", String(attack.call("get_schema")) == "uhr.hunt01.hunter_attack.v1")
	_check("Mudcrest anatomy schema v1", String(anatomy.call("get_schema")) == "uhr.hunt01.mudcrest_anatomy.v1")
	_check("attack HUD exists", world.get_node_or_null("HUD/HunterAttackPanel") != null)
	var target_groups: Array = attack.call("get_target_groups")
	_check("exact eight authoritative Mudcrest target groups exposed", target_groups == ["HEAD", "HORN_CREST", "FORELEG_L", "FORELEG_R", "HINDLEG_L", "HINDLEG_R", "DORSAL_PLATES", "TAIL"], str(target_groups))
	_check("working-melee body-envelope prototype is 3.5 m", is_equal_approx(float(attack.call("get_working_melee_limit_m")), 3.5))

	var resources_before_range: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	var out_of_range: Dictionary = attack.call("get_measured_cut_legality", "DORSAL_PLATES")
	_check("Measured Cut is hard-illegal from N01", not bool(out_of_range.get("legal", false)) and String(out_of_range.get("reason", "")) == "OUT_OF_WORKING_MELEE", str(out_of_range))
	var rejected_range: Dictionary = attack.call("commit_measured_cut_for_test", "DORSAL_PLATES")
	_check("out-of-range attack commit is rejected", not bool(rejected_range.get("success", true)) and String(rejected_range.get("reason", "")) == "OUT_OF_WORKING_MELEE", str(rejected_range))
	_check("out-of-range rejection spends nothing", shell.call("get_resource_state", HUNTER_ID) == resources_before_range)

	_check("N01 -> N04 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N04")))
	_check("N04 -> N07 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N07")))
	_check("N07 -> N09 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N09")))
	_check("Hunter reaches working-melee N09", String(movement.call("get_current_node_id")) == "R01_EF02_N09" and hunter.global_position.distance_to(Vector3(-22.0, 0.875, -238.0)) < 0.001, str(hunter.global_position))
	var n09_legality: Dictionary = attack.call("get_measured_cut_legality", "DORSAL_PLATES")
	_check("N09 passes the working-melee range gate before the AP gate", String(n09_legality.get("reason", "")) != "OUT_OF_WORKING_MELEE", str(n09_legality))
	_check("Round-1 three-step approach leaves insufficient AP for Measured Cut", not bool(n09_legality.get("legal", true)) and String(n09_legality.get("reason", "")) == "INSUFFICIENT_AP", str(n09_legality))
	var resources_before_ap_reject: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	var ap_reject: Dictionary = attack.call("commit_measured_cut_for_test", "DORSAL_PLATES")
	_check("insufficient-AP attack is rejected without commitment", not bool(ap_reject.get("success", true)) and String(ap_reject.get("reason", "")) == "INSUFFICIENT_AP", str(ap_reject))
	_check("insufficient-AP rejection spends nothing", shell.call("get_resource_state", HUNTER_ID) == resources_before_ap_reject)

	_check("end Round 1 to recover attack opportunity", bool(shell.call("end_player_turn")))
	var state: Dictionary = shell.call("get_current_state")
	var resources: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("Round 2 returns to Hunter at persistent N09", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == HUNTER_ID and String(movement.call("get_current_node_id")) == "R01_EF02_N09", str(state))
	_check("Round 2 Hunter has 4 AP / 100 Stamina", int(resources.get("ap", -1)) == 4 and int(resources.get("stamina", -1)) == 100, str(resources))

	var ready: Dictionary = attack.call("get_measured_cut_legality", "DORSAL_PLATES")
	_check("Dorsal-plate Measured Cut is legal at N09", bool(ready.get("legal", false)) and String(ready.get("line_of_effect", {}).get("reason", "")) == "CLEAR_TO_MONSTER_BODY", str(ready))
	var first_resolution: Dictionary = attack.call("commit_measured_cut_for_test", "DORSAL_PLATES")
	_check("first real Measured Cut commits", bool(first_resolution.get("success", false)), str(first_resolution))
	_check("first attack spends exactly 2 AP / 12 Stamina", int(shell.call("get_resource_state", HUNTER_ID).get("ap", -1)) == 2 and int(shell.call("get_resource_state", HUNTER_ID).get("stamina", -1)) == 88, str(shell.call("get_resource_state", HUNTER_ID)))
	_check("Dorsal target acquires selected-part contact", String(first_resolution.get("contact_class", "")) == "SELECTED_PART_CONTACT" and String(first_resolution.get("resolved_target_group", "")) == "DORSAL_PLATES", str(first_resolution))
	_check("deterministic first hit is CLEAN within Measured Cut ceiling", String(first_resolution.get("hit_quality", "")) == "CLEAN" and String(first_resolution.get("hit_quality_ceiling", "")) == "CLEAN", str(first_resolution))
	_check("local dorsal protection routes before anatomy", String(first_resolution.get("protection_profile", "")) == "MINERALIZED_DORSAL_PLATE", str(first_resolution))
	_check("one bounded variance sample is explicit", int(first_resolution.get("variance_sample", 99)) == 1 and first_resolution.get("variance_bounds") == [-6, 6], str(first_resolution))
	_check("control fixture is explicitly provisional", String(first_resolution.get("fixture_status", "")) == "PROVISIONAL_FIRST_SLICE_CONTROL_FIXTURE", str(first_resolution))
	var handoff: Dictionary = first_resolution.get("damage_handoff", {})
	var first_anatomy: Dictionary = first_resolution.get("anatomy_result", {})
	_check("committed attack carries stable anatomy resolution identity", not String(handoff.get("resolution_id", "")).is_empty() and int(handoff.get("round_id", -1)) == 2 and int(handoff.get("action_sequence", -1)) == 1, str(handoff))
	_check("Dorsal handoff is consumed by anatomy runtime", String(handoff.get("status", "")) == "ANATOMY_INTEGRITY_APPLIED" and bool(first_anatomy.get("success", false)), str(first_anatomy))
	_check("Dorsal provisional integrity changes 100 -> 95", int(first_anatomy.get("integrity_before", -1)) == 100 and int(first_anatomy.get("integrity_loss", -1)) == 5 and int(first_anatomy.get("integrity_after", -1)) == 95, str(first_anatomy))
	_check("Dorsal runtime state matches committed result", int(anatomy.call("get_target_state", "DORSAL_PLATES").get("integrity", -1)) == 95, str(anatomy.call("get_target_state", "DORSAL_PLATES")))
	var readback := attack.call("get_last_resolution") as Dictionary
	_check("readback does not reroll committed attack/anatomy", readback == first_resolution)
	var duplicate_first: Dictionary = anatomy.call("apply_damage_handoff_for_test", handoff)
	_check("replaying committed Dorsal handoff does not apply twice", bool(duplicate_first.get("duplicate", false)) and not bool(duplicate_first.get("applied", true)) and int(anatomy.call("get_target_state", "DORSAL_PLATES").get("integrity", -1)) == 95, str(duplicate_first))

	var second_resolution: Dictionary = attack.call("commit_measured_cut_for_test", "TAIL")
	_check("second Measured Cut in same 4-AP activation is legal", bool(second_resolution.get("success", false)), str(second_resolution))
	resources = shell.call("get_resource_state", HUNTER_ID)
	_check("two Measured Cuts consume all AP and 24 total Stamina", int(resources.get("ap", -1)) == 0 and int(resources.get("stamina", -1)) == 76, str(resources))
	_check("difficult Tail acquisition demonstrates body fallback", String(second_resolution.get("contact_class", "")) == "BODY_CONTACT_OFF_TARGET" and String(second_resolution.get("resolved_target_group", "")) == "GENERAL_TORSO", str(second_resolution))
	_check("body fallback keeps one traceable GRAZE rather than rerolling", String(second_resolution.get("hit_quality", "")) == "GRAZE" and int(second_resolution.get("variance_sample", 99)) == -3, str(second_resolution))
	_check("fallback routes through torso protection", String(second_resolution.get("protection_profile", "")) == "HIDE_TORSO", str(second_resolution))
	var second_anatomy: Dictionary = second_resolution.get("anatomy_result", {})
	_check("torso body fallback applies provisional integrity 100 -> 97", String(second_anatomy.get("target_group", "")) == "GENERAL_TORSO" and int(second_anatomy.get("integrity_loss", -1)) == 3 and int(second_anatomy.get("integrity_after", -1)) == 97, str(second_anatomy))
	_check("two attacks create exactly two applied anatomy transactions", int(anatomy.call("get_applied_resolution_count")) == 2)
	_check("attack sequence increments exactly once per committed attack", int(attack.call("get_attack_sequence")) == 2)

	var attack_trace: Array = attack.call("get_trace")
	var resolved_events := 0
	var rejected_events := 0
	for entry_variant in attack_trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) == "HUNTER_ATTACK_RESOLVED":
			resolved_events += 1
		elif String(entry.get("event", "")) == "HUNTER_ATTACK_REJECTED":
			rejected_events += 1
	_check("two committed attacks have exactly two resolution traces", resolved_events == 2, str(attack_trace))
	_check("range/AP failures remain separately traceable", rejected_events == 2, str(attack_trace))
	_check("Monster transform is unchanged because anatomy integrity is state-only", monster.global_transform.is_equal_approx(monster_before), str(monster.global_position))

	_check("end attack turn advances through explicit Monster wait", bool(shell.call("end_player_turn")))
	state = shell.call("get_current_state")
	resources = shell.call("get_resource_state", HUNTER_ID)
	_check("Round 3 returns to Hunter", int(state.get("round_id", 0)) == 3 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("persistent Stamina recovers only +10 after two cuts", int(resources.get("stamina", -1)) == 86, str(resources))
	_check("attack node position persists across round transition", String(movement.call("get_current_node_id")) == "R01_EF02_N09")

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_FIRST_HUNTER_ATTACK_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_FIRST_HUNTER_ATTACK_RUNTIME_FAILED")
	print("Final damage balance, break/sever/status, Monster behavior, phone/user acceptance and performance are not claimed by this gate.")
	quit(0 if failures.is_empty() else 1)
