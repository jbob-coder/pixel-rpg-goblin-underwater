extends SceneTree

const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const TAIL_SWEEP_ATTACK_ID := "M01_TAIL_SWEEP"
const REACTION_BLOCK := "POLEBLADE_BLOCK"

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

func _record_tracking(tracking: Node) -> bool:
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
		if not bool(tracking.call("record_evidence_for_test", evidence_id)):
			return false
		await process_frame
	return int(tracking.call("get_collected_count")) == 7

func _has_event(trace: Array, event_name: String) -> bool:
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) == event_name:
			return true
	return false

func _run() -> void:
	print("Hunt-01 Mudcrest Tail Sweep hostile attack runtime")
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
	_check("tracking prerequisite resolves", await _record_tracking(tracking))
	await _settle_hunter(hunter, Vector3(-72.0, 0.875, -236.0))
	_check("physical engagement is available", String(encounter.call("get_state")) == "ENGAGEMENT_AVAILABLE", String(encounter.call("get_state")))
	var monster_before := monster.global_transform
	_check("explicit ENGAGE starts combat stack", bool(encounter.call("engage_for_test")))

	var shell := encounter.call("get_combat_turn_shell") as Node
	var movement := encounter.call("get_tactical_movement_runtime") as Node
	var reaction := encounter.call("get_reaction_window_runtime") as Node
	var anatomy := encounter.call("get_mudcrest_anatomy_runtime") as Node
	var mudcrest_attack := encounter.call("get_mudcrest_attack_runtime") as Node
	_check("production Tail Sweep dependencies exist", shell != null and movement != null and reaction != null and anatomy != null and mudcrest_attack != null)
	if shell == null or movement == null or reaction == null or anatomy == null or mudcrest_attack == null:
		_finish()
		return

	await process_frame
	var wound_contact := mudcrest_attack.call("get_wound_contact_runtime") as Node
	var defense := mudcrest_attack.call("get_hunter_defense_runtime") as Node
	var health: Node = null
	if defense != null:
		health = defense.call("get_hunter_health_runtime") as Node
	var status_application: Node = null
	if wound_contact != null:
		status_application = wound_contact.call("get_status_application_runtime") as Node
	_check("shared defense health and status owners are available", wound_contact != null and health != null and status_application != null)
	if wound_contact == null or health == null or status_application == null:
		_finish()
		return

	_check("Tail Sweep technical identity is stable", String(mudcrest_attack.call("get_tail_sweep_attack_id")) == TAIL_SWEEP_ATTACK_ID)
	_check("real Monster activation driver remains single/registered", bool(mudcrest_attack.call("is_driver_registered")))
	_check("Tail Sweep reach fixture is explicit 6 m from authored N10 flank", is_equal_approx(float(mudcrest_attack.call("get_tail_sweep_reach_fixture_m")), 6.0))
	_check("Tail Sweep rear/flank forward-dot fixture is explicit", is_equal_approx(float(mudcrest_attack.call("get_tail_sweep_bearing_fixture_max_dot")), 0.25))

	# Round 1: N01 is outside both Tail Sweep and Head Sweep working reach.
	_check("ending Round-1 Hunter activation succeeds", bool(shell.call("end_player_turn")))
	var state: Dictionary = shell.call("get_current_state")
	_check("out-of-range Monster activation advances to Round 2 Hunter", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("out-of-range activation commits no hostile attack", int(mudcrest_attack.call("get_attack_sequence")) == 0)

	# Round 2: traverse only authored links to the real N10 flank node.
	_check("N01 -> N02 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N02")))
	_check("N02 -> N05 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N05")))
	_check("N05 -> N08 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N08")))
	_check("N08 -> N10 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N10")))
	_check("Hunter reaches authored N10", String(movement.call("get_current_node_id")) == "R01_EF02_N10" and hunter.global_position.distance_to(Vector3(-22.0, 0.875, -270.0)) < 0.001, str(hunter.global_position))
	await physics_frame
	await process_frame

	_check("ending Round-2 Hunter turn delegates close-flank Monster activation", bool(shell.call("end_player_turn")))
	state = shell.call("get_current_state")
	_check("Monster remains current while Tail Sweep reaction is open", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == MONSTER_ID, str(state))
	var active_attack: Dictionary = mudcrest_attack.call("get_active_attack")
	_check("Tail Sweep wins deterministic rear/flank priority", String(active_attack.get("attack_id", "")) == TAIL_SWEEP_ATTACK_ID and String(active_attack.get("state", "")) == "WAITING_REACTION_DECISION", str(active_attack))
	var monster_resources: Dictionary = shell.call("get_resource_state", MONSTER_ID)
	_check("Tail Sweep spends exactly 3 AP / 18 Stamina", int(monster_resources.get("ap", -1)) == 1 and int(monster_resources.get("stamina", -1)) == 82, str(monster_resources))
	var legality: Dictionary = active_attack.get("legality_snapshot", {}) as Dictionary
	_check("Tail Sweep uses authored N10-derived 6 m body-envelope reach", is_equal_approx(float(legality.get("body_envelope_distance_m", 99.0)), 6.0), str(legality))
	_check("Tail Sweep passes rear/flank bearing gate", float(legality.get("bearing_dot", 99.0)) <= 0.25 and String(legality.get("bearing_class", "")) == "REAR_OR_FLANK_PROVISIONAL_FORWARD_DOT_MAX", str(legality))
	var pivot: Dictionary = legality.get("pivot_clearance", {}) as Dictionary
	_check("Tail Sweep consumes real authored 8 m pivot clearance", bool(pivot.get("clear", false)) and is_equal_approx(float(pivot.get("pivot_radius_m", -1.0)), 8.0) and int(pivot.get("probe_count", 0)) == 4, str(pivot))
	_check("Tail Sweep passes physical line/arc blocker gate", String((legality.get("line_of_effect", {}) as Dictionary).get("reason", "")) == "CLEAR_TO_HUNTER_BODY", str(legality))
	_check("Tail Sweep telegraph asset is visible during reaction", bool(mudcrest_attack.call("is_telegraph_visible")) and get_nodes_in_group("hunt01_monster_attack_telegraph").size() == 1)

	var window: Dictionary = reaction.call("get_active_window")
	var window_id := String(window.get("window_id", ""))
	_check("Tail Sweep opens one stable reaction window", String(window.get("source_action_id", "")) == TAIL_SWEEP_ATTACK_ID and not window_id.is_empty(), str(window))
	var hunter_before_block: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	var committed: Dictionary = reaction.call("commit_reaction", window_id, REACTION_BLOCK)
	_check("Field Poleblade Block commits against Tail Sweep", bool(committed.get("success", false)), str(committed))
	var hunter_after_commit: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("normal Block commitment still costs 1 RP + 6 Stamina", int(hunter_after_commit.get("rp", -1)) == int(hunter_before_block.get("rp", -1)) - 1 and int(hunter_after_commit.get("stamina", -1)) == int(hunter_before_block.get("stamina", -1)) - 6, str(hunter_after_commit))
	await process_frame
	await process_frame

	var first_resolution: Dictionary = mudcrest_attack.call("get_last_resolution")
	var first_defense: Dictionary = first_resolution.get("defense_consequence", {}) as Dictionary
	var first_health: Dictionary = first_defense.get("health_injury_consequence", {}) as Dictionary
	var first_classification: Dictionary = first_resolution.get("wound_contact_classification", {}) as Dictionary
	_check("Tail Sweep resolves one stable hostile transaction", bool(first_resolution.get("success", false)) and String(first_resolution.get("attack_id", "")) == TAIL_SWEEP_ATTACK_ID, str(first_resolution))
	_check("Tail Sweep is pure IMPACT", (first_resolution.get("damage_channels", []) as Array) == ["IMPACT"], str(first_resolution.get("damage_channels", [])))
	_check("first deterministic blocked Tail Sweep is SOLID with variance -1", String(first_resolution.get("hit_quality", "")) == "SOLID" and int(first_resolution.get("variance_sample", 99)) == -1, str(first_resolution))
	_check("Tail Sweep records and applies 14-Stamina Block impact drain", int(first_defense.get("guard_impact_requested_stamina", -1)) == 14 and int(first_defense.get("guard_impact_applied_stamina", -1)) == 14 and bool(first_defense.get("guard_impact_fully_paid", false)), str(first_defense))
	_check("funded SOLID Tail Sweep produces BLOCK_STRONG", String(first_defense.get("block_outcome", "")) == "BLOCK_STRONG", str(first_defense))
	_check("existing provisional health fixture accepts Tail Sweep without new balance", int(first_health.get("applied_injury_load", -1)) == 2 and int(first_health.get("health_before", -1)) == 100 and int(first_health.get("health_after", -1)) == 98, str(first_health))
	_check("strong Block prevents first-slice Tail Sweep Off-Balance request", int(first_classification.get("status_request_count", -1)) == 0 and String(first_classification.get("classification_reason", "")) == "STRONG_BLOCK_PREVENTS_FIRST_SLICE_OFF_BALANCE_REQUEST", str(first_classification))
	_check("reaction closes and Tail telegraph disappears", String(reaction.call("get_state")) == "IDLE" and not bool(mudcrest_attack.call("is_telegraph_visible")))
	_check("first Tail Sweep readback is idempotent", mudcrest_attack.call("get_resolution", String(first_resolution.get("resolution_id", ""))) == first_resolution)

	state = shell.call("get_current_state")
	_check("scheduler advances to Round-3 Hunter", int(state.get("round_id", 0)) == 3 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))

	# Round 3: remain at N10 and explicitly decline. The deterministic SOLID
	# Impact contact is the selected Tail Sweep -> Off-Balance first slice.
	_check("ending Round-3 Hunter turn opens second Tail Sweep", bool(shell.call("end_player_turn")))
	window = reaction.call("get_active_window")
	var second_window_id := String(window.get("window_id", ""))
	_check("second Tail Sweep gets a distinct reaction transaction", not second_window_id.is_empty() and second_window_id != window_id, str(window))
	_check("explicit decline is accepted", bool((reaction.call("decline_reaction", second_window_id) as Dictionary).get("success", false)))
	await process_frame
	await process_frame

	var second_resolution: Dictionary = mudcrest_attack.call("get_last_resolution")
	var second_defense: Dictionary = second_resolution.get("defense_consequence", {}) as Dictionary
	var second_health: Dictionary = second_defense.get("health_injury_consequence", {}) as Dictionary
	var second_classification: Dictionary = second_resolution.get("wound_contact_classification", {}) as Dictionary
	_check("second Tail Sweep is deterministic SOLID with variance -3", String(second_resolution.get("hit_quality", "")) == "SOLID" and int(second_resolution.get("variance_sample", 99)) == -3, str(second_resolution))
	_check("declined Tail Sweep uses no-active-guard body route", String(second_defense.get("block_outcome", "")) == "NOT_APPLICABLE" and String(second_health.get("defense_outcome", "")) == "NO_ACTIVE_GUARD", str(second_defense))
	_check("unguarded SOLID Tail Sweep applies existing provisional 8-load fixture", int(second_health.get("applied_injury_load", -1)) == 8 and int(second_health.get("health_after", -1)) == 90, str(second_health))
	_check("SOLID Tail Sweep emits exactly one Off-Balance request", int(second_classification.get("status_request_count", -1)) == 1 and String(second_classification.get("contact_mode", "")) == "TAIL_SWEEP_SOLID_IMPACT_PROVISIONAL", str(second_classification))
	var requests: Array = second_classification.get("status_application_requests", []) as Array
	var off_balance_request: Dictionary = {}
	if requests.size() == 1:
		off_balance_request = requests[0] as Dictionary
	_check("Tail Sweep request targets generic Off-Balance owner", String(off_balance_request.get("status_id", "")) == "status_off_balance" and String(off_balance_request.get("source_action_id", "")) == TAIL_SWEEP_ATTACK_ID and String(off_balance_request.get("consumer_status", "")) == "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME", str(off_balance_request))
	_check("generic status application commits Off-Balance synchronously", bool(status_application.call("has_status", HUNTER_ID, "status_off_balance")), str(status_application.call("get_status_instance", HUNTER_ID, "status_off_balance")))
	_check("SOLID Tail Sweep does not fabricate Staggered", not second_classification.has("staggered_request_pending_unimplemented") and not str(second_classification).contains("status_staggered"), str(second_classification))

	# Synthetic content-boundary probe: CLEAN is already qualified by the species
	# classifier and must emit exactly one request to the verified generic Staggered owner.
	var clean_damage := {
		"status": "PENDING_HUNTER_DAMAGE_RUNTIME",
		"resolution_id": "enc_r01_ef02_m01_0001:TAIL_SWEEP_CLEAN_STAGGERED_BOUNDARY",
		"encounter_id": "enc_r01_ef02_m01_0001",
		"round_id": 99,
		"action_sequence": 99,
		"attacker_id": MONSTER_ID,
		"defender_id": HUNTER_ID,
		"attack_id": TAIL_SWEEP_ATTACK_ID,
		"attack_profile": "TAIL_SWEEP_IMPACT",
		"damage_channels": ["IMPACT"],
		"reaction_id": "DECLINE_REACTION",
		"contact_class": "HUNTER_BODY_CONTACT",
		"hit_quality": "CLEAN",
		"protection_route": "HUNTER_BODY_PROTECTION_PENDING_RUNTIME",
	}
	var clean_defense := {
		"success": true,
		"block_outcome": "NOT_APPLICABLE",
		"health_injury_consequence": {
			"success": true,
			"resolution_id": String(clean_damage.get("resolution_id", "")),
			"defense_outcome": "NO_ACTIVE_GUARD",
			"applied_injury_load": 12,
		},
	}
	var status_count_before_clean := int(status_application.call("get_application_count"))
	var clean_classification: Dictionary = wound_contact.call("resolve_tail_sweep_consequence", clean_damage, clean_defense)
	var clean_requests: Array = clean_classification.get("status_application_requests", []) as Array
	var clean_results: Array = clean_classification.get("status_application_results", []) as Array
	var staggered_request: Dictionary = {}
	if clean_requests.size() == 1:
		staggered_request = clean_requests[0] as Dictionary
	_check("CLEAN Tail Sweep emits one Staggered producer request", int(clean_classification.get("status_request_count", -1)) == 1 and String(clean_classification.get("contact_mode", "")) == "TAIL_SWEEP_CLEAN_IMPACT_STAGGERED_PROVISIONAL", str(clean_classification))
	_check("CLEAN Tail Sweep request targets verified generic Staggered owner", String(staggered_request.get("status_id", "")) == "status_staggered" and String(staggered_request.get("source_action_id", "")) == TAIL_SWEEP_ATTACK_ID and String(staggered_request.get("application_mode", "")) == "APPLY_OR_REFRESH" and int(staggered_request.get("intensity_delta", -1)) == 0 and String(staggered_request.get("consumer_status", "")) == "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME", str(staggered_request))
	_check("CLEAN Tail Sweep dispatches exactly one successful generic application", clean_results.size() == 1 and bool((clean_results[0] as Dictionary).get("success", false)) and String(clean_classification.get("status_application_dispatch_status", "")) == "DISPATCHED_TO_GENERIC_STATUS_APPLICATION_RUNTIME" and int(status_application.call("get_application_count")) == status_count_before_clean + 1, str(clean_classification))
	_check("generic status application commits Staggered synchronously", bool(status_application.call("has_status", HUNTER_ID, "status_staggered")), str(status_application.call("get_status_instance", HUNTER_ID, "status_staggered")))
	var staggered_before_replay: Dictionary = status_application.call("get_status_instance", HUNTER_ID, "status_staggered") as Dictionary
	var clean_replay: Dictionary = wound_contact.call("resolve_tail_sweep_consequence", clean_damage, clean_defense)
	_check("CLEAN Tail Sweep classification replay is exact/idempotent", clean_replay == clean_classification and int(status_application.call("get_application_count")) == status_count_before_clean + 1, str(clean_replay))
	_check("CLEAN replay does not refresh Staggered twice", status_application.call("get_status_instance", HUNTER_ID, "status_staggered") == staggered_before_replay, str(status_application.call("get_status_instance", HUNTER_ID, "status_staggered")))

	# Tail anatomy remains intact/current-state-only; the Monster attack cannot
	# mutate its own anatomy or infer a sever transition from normalized integrity.
	var tail_state: Dictionary = anatomy.call("get_target_state", "TAIL")
	_check("TAIL_DISTAL capability remains attached without invented sever threshold", String(first_resolution.get("structural_capability_status", "")) == "PROVISIONAL_BASELINE_TAIL_DISTAL_ATTACHED_NO_SEVER_STATE_RUNTIME" and int(tail_state.get("integrity", -1)) == 100, str(tail_state))
	_check("Monster anatomy receives no self-damage handoff", int(anatomy.call("get_applied_resolution_count")) == 0)
	_check("Monster world transform is unchanged by state-only Tail Sweep", monster.global_transform.is_equal_approx(monster_before), str(monster.global_position))
	_check("Hunter remains on authored N10 because Tail Sweep forced displacement is not implemented", hunter.global_position.distance_to(Vector3(-22.0, 0.875, -270.0)) < 0.001, str(hunter.global_position))
	_check("exactly two legal Tail Sweeps were committed", int(mudcrest_attack.call("get_attack_sequence")) == 2)

	var trace: Array = mudcrest_attack.call("get_trace")
	_check("attack trace records rejected out-of-range Tail candidate", _has_event(trace, "MUDCREST_TAIL_SWEEP_CANDIDATE_REJECTED"))
	_check("attack trace records Tail Sweep telegraph", _has_event(trace, "MUDCREST_TAIL_SWEEP_TELEGRAPH_EMITTED"))
	_check("attack trace records Tail Sweep resolution", _has_event(trace, "MUDCREST_TAIL_SWEEP_RESOLUTION_HANDOFF_COMMITTED"))
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME_FAILED")
	print("Final Tail Sweep range/control balance, structural sever thresholds, forced displacement, phone acceptance and performance are not claimed by this gate.")
	quit(0 if failures.is_empty() else 1)
