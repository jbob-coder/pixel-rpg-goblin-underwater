extends SceneTree

const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const ATTACK_ID := "M01_HEAD_SWEEP_GORE"
const REACTION_BLOCK := "POLEBLADE_BLOCK"

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition: failures.append(label)

func _settle_hunter(hunter: CharacterBody3D, position: Vector3) -> void:
	hunter.global_position = position
	hunter.velocity = Vector3.ZERO
	for _frame in range(8):
		await physics_frame
		await process_frame

func _record_tracking(tracking: Node) -> bool:
	for evidence_id in ["R01_H01_EV01_OUTER_PRINTS", "R01_H01_EV02_BANK_REEDS", "R01_H01_EV03_FRESH_WALLOW", "R01_H01_EV05_OLD_ROOT_SCRAPE", "R01_H01_EV04_WATER_EXIT", "R01_H01_EV06_FEEDING_REMAINS", "R01_H01_EV07_FLATTENED_GRASS_AUDIO"]:
		if not bool(tracking.call("record_evidence_for_test", evidence_id)): return false
		await process_frame
	return int(tracking.call("get_collected_count")) == 7

func _off_balance_request() -> Dictionary:
	var resolution_id := "enc_r01_ef02_m01_0001:TIMING_TEST:OFF_BALANCE"
	return {"status": "VALID_STATUS_APPLICATION_REQUEST", "request_schema": "uhr.status_application_request.v1", "application_request_id": "%s:STATUS:status_off_balance" % resolution_id, "status_id": "status_off_balance", "target_actor_id": HUNTER_ID, "source_actor_id": MONSTER_ID, "source_action_id": ATTACK_ID, "source_resolution_id": resolution_id, "trigger_hook": "ON_HIT_OR_DAMAGE_CONSEQUENCE", "application_mode": "APPLY_OR_REFRESH", "qualification": "TIMING_TEST_VALID_IMPACT_DOMINANT_CONTACT", "consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME"}

func _staggered_request() -> Dictionary:
	var resolution_id := "enc_r01_ef02_m01_0001:TIMING_TEST:STAGGERED"
	return {"status": "VALID_STATUS_APPLICATION_REQUEST", "request_schema": "uhr.status_application_request.v1", "application_request_id": "%s:STATUS:status_staggered" % resolution_id, "status_id": "status_staggered", "target_actor_id": HUNTER_ID, "source_actor_id": MONSTER_ID, "source_action_id": ATTACK_ID, "source_resolution_id": resolution_id, "trigger_hook": "ON_HIT_OR_DAMAGE_CONSEQUENCE", "application_mode": "APPLY_OR_REFRESH", "qualification": "TIMING_TEST_VALID_TRANSIENT_DISRUPTION", "consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME"}

func _shell_sequence(trace: Array, event_name: String, round_id: int, actor_id: String = "") -> int:
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) != event_name or int(entry.get("round_id", 0)) != round_id: continue
		if not actor_id.is_empty() and String(entry.get("combatant_id", "")) != actor_id: continue
		return int(entry.get("sequence", 0))
	return 0

func _run() -> void:
	print("Hunt-01 generic status timing runtime")
	var packed := load("res://scenes/regions/region_01_hunt01_graybox.tscn") as PackedScene
	if packed == null:
		_check("production Region-01 scene loads", false)
		_finish(); return
	var world := packed.instantiate() as Node3D
	root.add_child(world)
	for _frame in range(4): await process_frame; await physics_frame
	var hunter := world.get_node("Hunter") as CharacterBody3D
	var tracking := world.get_node("TrackingRuntime")
	var encounter := world.get_node("EncounterRuntime")
	_check("tracking prerequisite resolves", await _record_tracking(tracking))
	await _settle_hunter(hunter, Vector3(-72.0, 0.875, -236.0))
	_check("ENGAGE starts production combat stack", bool(encounter.call("engage_for_test")))
	var shell := encounter.call("get_combat_turn_shell") as Node
	var movement := encounter.call("get_tactical_movement_runtime") as Node
	var reaction := encounter.call("get_reaction_window_runtime") as Node
	var anatomy := encounter.call("get_mudcrest_anatomy_runtime") as Node
	var attack := encounter.call("get_mudcrest_attack_runtime") as Node
	if shell == null or movement == null or reaction == null or anatomy == null or attack == null:
		_check("production dependencies exist", false); _finish(); return
	await process_frame
	var classifier := attack.call("get_wound_contact_runtime") as Node
	var defense := attack.call("get_hunter_defense_runtime") as Node
	var health: Node = defense.call("get_hunter_health_runtime") as Node
	var status_application := classifier.call("get_status_application_runtime") as Node
	var timing := classifier.call("get_status_timing_runtime") as Node
	_check("status timing owner is one combat-shell child", timing != null and timing.get_parent() == shell and timing.name == "StatusTimingRuntime")
	_check("status timing schema v1", timing != null and String(timing.call("get_schema")) == "uhr.hunt01.status_timing.v1")
	if timing == null: _finish(); return

	_check("Round-1 Hunter end", bool(shell.call("end_player_turn")))
	_check("N01 -> N04", bool(movement.call("move_for_test", "R01_EF02_N04")))
	_check("N04 -> N07", bool(movement.call("move_for_test", "R01_EF02_N07")))
	_check("N07 -> N09", bool(movement.call("move_for_test", "R01_EF02_N09")))
	await physics_frame; await process_frame

	# Round 2 Strong Block: no status.
	_check("Round-2 Hunter end opens Head Sweep", bool(shell.call("end_player_turn")))
	var window: Dictionary = reaction.call("get_active_window")
	_check("Round-2 Block commits", bool((reaction.call("commit_reaction", String(window.get("window_id", "")), REACTION_BLOCK) as Dictionary).get("success", false)))
	await process_frame; await process_frame

	# Round 3 decline: real Bleeding is applied, first eligible tick Round 4.
	_check("Round-3 Hunter end opens Head Sweep", bool(shell.call("end_player_turn")))
	window = reaction.call("get_active_window")
	_check("Round-3 decline commits", bool((reaction.call("decline_reaction", String(window.get("window_id", ""))) as Dictionary).get("success", false)))
	await process_frame; await process_frame
	var bleeding: Dictionary = status_application.call("get_status_instance", HUNTER_ID, "status_bleeding")
	_check("real Bleeding exists with first tick Round 4", int(bleeding.get("first_tick_round", 0)) == 4, str(bleeding))

	# Apply Off-Balance and Staggered during the already-started Round-4 Hunter activation.
	# Neither may retroactively consume this activation's TURN_START hook.
	var off_apply: Dictionary = status_application.call("consume_application_request", _off_balance_request(), 4)
	_check("synthetic valid Off-Balance applies during Round 4 Hunter activation", bool(off_apply.get("success", false)))
	var staggered_apply: Dictionary = status_application.call("consume_application_request", _staggered_request(), 4)
	_check("synthetic valid Staggered applies during Round 4 Hunter activation", bool(staggered_apply.get("success", false)))
	var off_balance: Dictionary = status_application.call("get_status_instance", HUNTER_ID, "status_off_balance")
	_check("mid-activation Off-Balance is not retroactively armed", int(off_balance.get("expiry_armed_round", 0)) == 0, str(off_balance))
	_check("mid-activation Staggered waits for next target TURN_START", bool(status_application.call("has_status", HUNTER_ID, "status_staggered")) and int(status_application.call("get_timing_transition_count")) == 0)
	_check("Round-4 Hunter end succeeds", bool(shell.call("end_player_turn")))
	_check("Off-Balance survives same activation end", bool(status_application.call("has_status", HUNTER_ID, "status_off_balance")))
	_check("Staggered survives same activation end", bool(status_application.call("has_status", HUNTER_ID, "status_staggered")))

	# Finish Round 4 Monster activation with Strong Block, triggering Round 4 ROUND_END and Round 5 start.
	window = reaction.call("get_active_window")
	_check("Round-4 Block commits", bool((reaction.call("commit_reaction", String(window.get("window_id", "")), REACTION_BLOCK) as Dictionary).get("success", false)))
	await process_frame; await process_frame
	var round4_attack: Dictionary = attack.call("get_last_resolution") as Dictionary
	var round4_defense: Dictionary = round4_attack.get("defense_consequence", {}) as Dictionary
	var round4_health_consequence: Dictionary = round4_defense.get("health_injury_consequence", {}) as Dictionary
	var state: Dictionary = shell.call("get_current_state")
	_check("Round 5 Hunter activation starts instead of being skipped", int(state.get("round_id", 0)) == 5 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	var round5_resources: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("normal Round-5 AP/RP refresh still occurs after Staggered transition", int(round5_resources.get("ap", -1)) == 4 and int(round5_resources.get("rp", -1)) == 1, str(round5_resources))
	_check("Round-5 TURN_START removes Staggered exactly once", not bool(status_application.call("has_status", HUNTER_ID, "status_staggered")) and int(status_application.call("get_timing_transition_count")) == 1)
	off_balance = status_application.call("get_status_instance", HUNTER_ID, "status_off_balance")
	_check("Staggered transition refreshes the one Off-Balance instance", int(off_balance.get("application_count", 0)) == 2 and int(off_balance.get("last_application_round", 0)) == 5 and int(off_balance.get("intensity", 0)) == 1, str(off_balance))
	_check("converted Off-Balance is armed for this same activation TURN_END", int(off_balance.get("expiry_armed_round", 0)) == 5 and String(off_balance.get("expiry_status", "")) == "ARMED_FOR_TARGET_TURN_END", str(off_balance))

	var events: Array = timing.call("get_periodic_events") as Array
	_check("Round-4 emits exactly one pending Bleeding periodic consequence", events.size() == 1 and String((events[0] as Dictionary).get("status", "")) == "PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE" and int((events[0] as Dictionary).get("round_id", 0)) == 4, str(events))
	_check("pending Bleeding event carries no selected Health magnitude", String((events[0] as Dictionary).get("health_magnitude_status", "")) == "NOT_SELECTED_PENDING_AUTHORITY" and not (events[0] as Dictionary).has("damage_amount"), str(events[0]))
	var health_after_round4 := health.call("get_health_state") as Dictionary
	_check("timing event does not mutate Hunter Health", bool(round4_health_consequence.get("success", false)) and int(health_after_round4.get("health", -1)) == int(round4_health_consequence.get("health_after", -2)), str(round4_health_consequence))
	var event_count_before := int(timing.call("get_periodic_event_count"))
	var hunter_resources_before := shell.call("get_resource_state", HUNTER_ID) as Dictionary
	var health_before_duplicate := health.call("get_health_state") as Dictionary
	var duplicate_round_end: Dictionary = timing.call("on_round_end", 4)
	_check("duplicate Round-4 hook is idempotent", bool(duplicate_round_end.get("duplicate", false)) and int(timing.call("get_periodic_event_count")) == event_count_before)
	_check("duplicate timing hook spends no resources", shell.call("get_resource_state", HUNTER_ID) == hunter_resources_before)
	_check("duplicate timing hook still cannot mutate Health", health.call("get_health_state") == health_before_duplicate)

	var off_count_before_duplicate_start := int((status_application.call("get_status_instance", HUNTER_ID, "status_off_balance") as Dictionary).get("application_count", 0))
	var duplicate_turn_start: Dictionary = timing.call("on_turn_start_pre_recovery", HUNTER_ID, 5)
	_check("duplicate Round-5 TURN_START is idempotent", bool(duplicate_turn_start.get("duplicate", false)) and int(status_application.call("get_timing_transition_count")) == 1)
	_check("duplicate TURN_START does not refresh Off-Balance twice", int((status_application.call("get_status_instance", HUNTER_ID, "status_off_balance") as Dictionary).get("application_count", 0)) == off_count_before_duplicate_start)

	# Converted/refreshed Off-Balance expires after this same normal Hunter activation.
	_check("Round-5 Hunter end succeeds", bool(shell.call("end_player_turn")))
	_check("Off-Balance removed at armed TURN_END", not bool(status_application.call("has_status", HUNTER_ID, "status_off_balance")) and int(timing.call("get_removal_event_count")) == 1)

	var shell_trace: Array = shell.call("get_trace") as Array
	var ts_start := _shell_sequence(shell_trace, "STATUS_TIMING_TURN_START_PRE_RECOVERY", 5, HUNTER_ID)
	var activation_start := _shell_sequence(shell_trace, "ACTIVATION_START", 5, HUNTER_ID)
	_check("TURN_START_PRE_RECOVERY timing precedes activation resource refresh trace", ts_start > 0 and activation_start > 0 and ts_start < activation_start, "%d < %d" % [ts_start, activation_start])
	var ts_end := _shell_sequence(shell_trace, "STATUS_TIMING_TURN_END", 5, HUNTER_ID)
	var activation_end := _shell_sequence(shell_trace, "ACTIVATION_END", 5, HUNTER_ID)
	_check("TURN_END timing precedes activation terminal trace", ts_end > 0 and activation_end > 0 and ts_end < activation_end, "%d < %d" % [ts_end, activation_end])
	var round4_end := _shell_sequence(shell_trace, "STATUS_TIMING_ROUND_END", 4)
	var round5_start := _shell_sequence(shell_trace, "ROUND_START", 5)
	_check("ROUND_END timing precedes next ROUND_START", round4_end > 0 and round5_start > 0 and round4_end < round5_start, "%d < %d" % [round4_end, round5_start])
	_check("timing does not mutate Mudcrest anatomy", int((anatomy.call("get_target_state", "HEAD") as Dictionary).get("integrity", 0)) == 100)
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	print("Gate: %s" % ["HUNT01_GENERIC_STATUS_TIMING_RUNTIME_VERIFIED" if failures.is_empty() else "HUNT01_GENERIC_STATUS_TIMING_RUNTIME_FAILED"])
	print("This gate verifies generic Staggered next-turn conversion to Off-Balance plus existing Bleeding/Off-Balance timing; it does not wire Tail Sweep CLEAN as a Staggered producer, select Bleeding HP magnitude, implement Braced/Guarded, verify phone acceptance or verify performance.")
	quit(0 if failures.is_empty() else 1)
