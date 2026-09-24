extends SceneTree

const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const ATTACK_ID := "M01_HEAD_SWEEP_GORE"
const REACTION_BLOCK := "POLEBLADE_BLOCK"
const STATUS_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_status_application_runtime.gd")

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

func _bleeding_request(suffix: String) -> Dictionary:
	var resolution_id := "enc_r01_ef02_m01_0001:STATUS_TEST:%s" % suffix
	return {
		"status": "VALID_STATUS_APPLICATION_REQUEST",
		"request_schema": "uhr.status_application_request.v1",
		"application_request_id": "%s:STATUS:status_bleeding" % resolution_id,
		"status_id": "status_bleeding",
		"target_actor_id": HUNTER_ID,
		"source_actor_id": MONSTER_ID,
		"source_action_id": ATTACK_ID,
		"source_resolution_id": resolution_id,
		"trigger_hook": "ON_HIT_OR_DAMAGE_CONSEQUENCE",
		"application_mode": "STACK_INTENSITY_CAPPED",
		"intensity_delta": 1,
		"qualification": "TEST_VALID_HORN_PENETRATION_WOUND",
		"consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME",
	}

func _off_balance_request(suffix: String) -> Dictionary:
	var resolution_id := "enc_r01_ef02_m01_0001:STATUS_TEST:%s" % suffix
	return {
		"status": "VALID_STATUS_APPLICATION_REQUEST",
		"request_schema": "uhr.status_application_request.v1",
		"application_request_id": "%s:STATUS:status_off_balance" % resolution_id,
		"status_id": "status_off_balance",
		"target_actor_id": HUNTER_ID,
		"source_actor_id": MONSTER_ID,
		"source_action_id": ATTACK_ID,
		"source_resolution_id": resolution_id,
		"trigger_hook": "ON_HIT_OR_DAMAGE_CONSEQUENCE",
		"application_mode": "APPLY_OR_REFRESH",
		"qualification": "TEST_VALID_CLEAN_IMPACT_DOMINANT_CONTACT",
		"block_outcome": "BLOCK_PARTIAL",
		"consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME",
	}

func _staggered_request(suffix: String) -> Dictionary:
	var resolution_id := "enc_r01_ef02_m01_0001:STATUS_TEST:%s" % suffix
	return {
		"status": "VALID_STATUS_APPLICATION_REQUEST",
		"request_schema": "uhr.status_application_request.v1",
		"application_request_id": "%s:STATUS:status_staggered" % resolution_id,
		"status_id": "status_staggered",
		"target_actor_id": HUNTER_ID,
		"source_actor_id": MONSTER_ID,
		"source_action_id": ATTACK_ID,
		"source_resolution_id": resolution_id,
		"trigger_hook": "ON_HIT_OR_DAMAGE_CONSEQUENCE",
		"application_mode": "APPLY_OR_REFRESH",
		"qualification": "TEST_VALID_TRANSIENT_DISRUPTION",
		"consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME",
	}

func _count_trace_event(trace: Array, event_name: String) -> int:
	var count := 0
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) == event_name:
			count += 1
	return count

func _run() -> void:
	print("Hunt-01 generic status application runtime")
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
	_check("production dependencies exist", shell != null and movement != null and reaction != null and anatomy != null and attack != null)
	if shell == null or movement == null or reaction == null or anatomy == null or attack == null:
		_finish()
		return
	await process_frame

	var classifier := attack.call("get_wound_contact_runtime") as Node
	var defense := attack.call("get_hunter_defense_runtime") as Node
	var health: Node = null
	if defense != null:
		health = defense.call("get_hunter_health_runtime") as Node
	var status_runtime: Node = null
	if classifier != null:
		status_runtime = classifier.call("get_status_application_runtime") as Node
	_check("generic status owner is integrated once under combat shell", status_runtime != null and status_runtime.get_parent() == shell and status_runtime.name == "StatusApplicationRuntime")
	_check("generic status schema v1", status_runtime != null and String(status_runtime.call("get_schema")) == "uhr.hunt01.status_application.v1")
	_check("Bleeding definition lookup stable", status_runtime != null and String((status_runtime.call("get_definition", "status_bleeding") as Dictionary).get("stack_rule", "")) == "STACK_INTENSITY_CAPPED")
	_check("Staggered definition is refreshable transient disruption", status_runtime != null and String((status_runtime.call("get_definition", "status_staggered") as Dictionary).get("category", "")) == "TRANSIENT_PHYSICAL_DISRUPTION" and String((status_runtime.call("get_definition", "status_staggered") as Dictionary).get("stack_rule", "")) == "REFRESH_DURATION")
	_check("Off-Balance definition lookup stable", status_runtime != null and String((status_runtime.call("get_definition", "status_off_balance") as Dictionary).get("stack_rule", "")) == "REFRESH_DURATION")
	if status_runtime == null or health == null:
		_finish()
		return

	_check("Round-1 Hunter turn can end", bool(shell.call("end_player_turn")))
	var state: Dictionary = shell.call("get_current_state")
	_check("out-of-range Monster advances to Round 2 Hunter", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("N01 -> N04", bool(movement.call("move_for_test", "R01_EF02_N04")))
	_check("N04 -> N07", bool(movement.call("move_for_test", "R01_EF02_N07")))
	_check("N07 -> N09", bool(movement.call("move_for_test", "R01_EF02_N09")))
	await physics_frame
	await process_frame

	_check("Round-2 Hunter end opens Head Sweep", bool(shell.call("end_player_turn")))
	var window: Dictionary = reaction.call("get_active_window")
	var window_id := String(window.get("window_id", ""))
	_check("first reaction window opens", not window_id.is_empty())
	_check("Poleblade Block commits", bool((reaction.call("commit_reaction", window_id, REACTION_BLOCK) as Dictionary).get("success", false)))
	await process_frame
	await process_frame
	_check("Strong Block creates no active status", int(status_runtime.call("get_active_status_count")) == 0)
	_check("Strong Block creates no status application transaction", int(status_runtime.call("get_application_count")) == 0)

	_check("Round-3 Hunter turn opens second Head Sweep", bool(shell.call("end_player_turn")))
	window = reaction.call("get_active_window")
	var second_window_id := String(window.get("window_id", ""))
	_check("second reaction window opens", not second_window_id.is_empty())
	_check("explicit decline commits", bool((reaction.call("decline_reaction", second_window_id) as Dictionary).get("success", false)))
	await process_frame
	await process_frame
	var resolution: Dictionary = attack.call("get_last_resolution")
	var classification: Dictionary = resolution.get("wound_contact_classification", {}) as Dictionary
	var requests: Array = classification.get("status_application_requests", []) as Array
	var application_results: Array = classification.get("status_application_results", []) as Array
	_check("real Head Sweep dispatches one status request to generic owner", requests.size() == 1 and application_results.size() == 1 and String(classification.get("status_application_dispatch_status", "")) == "DISPATCHED_TO_GENERIC_STATUS_APPLICATION_RUNTIME", str(classification))
	_check("real status application succeeds", application_results.size() == 1 and bool((application_results[0] as Dictionary).get("success", false)), str(application_results))
	var bleeding: Dictionary = status_runtime.call("get_status_instance", HUNTER_ID, "status_bleeding")
	_check("Bleeding actor-level instance is active at intensity 1", int(bleeding.get("intensity", 0)) == 1 and int(bleeding.get("max_intensity", 0)) == 3, str(bleeding))
	_check("Bleeding first tick is application round plus one", int(bleeding.get("first_application_round", 0)) == 3 and int(bleeding.get("first_tick_round", 0)) == 4, str(bleeding))
	_check("Bleeding timing is metadata-only pending scheduler", String(bleeding.get("periodic_hook", "")) == "ROUND_END" and String(bleeding.get("periodic_status", "")) == "PENDING_STATUS_TIMING_RUNTIME", str(bleeding))

	var health_after_real := health.call("get_health_state") as Dictionary
	var hunter_resources_before := shell.call("get_resource_state", HUNTER_ID) as Dictionary
	var monster_resources_before := shell.call("get_resource_state", MONSTER_ID) as Dictionary
	var anatomy_before := anatomy.call("get_target_state", "HEAD") as Dictionary
	var real_request := requests[0] as Dictionary
	var real_request_id := String(real_request.get("application_request_id", ""))
	var trace_apply_count_before := _count_trace_event(status_runtime.call("get_trace") as Array, "STATUS_ON_APPLY_COMMITTED")
	var replay: Dictionary = status_runtime.call("consume_application_request", real_request, 3)
	_check("replayed application request is idempotent readback", bool(replay.get("success", false)) and bool(replay.get("duplicate", false)) and String(replay.get("status", "")) == "STATUS_APPLICATION_READBACK_IDEMPOTENT", str(replay))
	_check("replay does not increment Bleeding", int((status_runtime.call("get_status_instance", HUNTER_ID, "status_bleeding") as Dictionary).get("intensity", 0)) == 1)
	_check("replay does not add application transaction", int(status_runtime.call("get_application_count")) == 1)
	_check("replay does not rerun ON_APPLY trace", _count_trace_event(status_runtime.call("get_trace") as Array, "STATUS_ON_APPLY_COMMITTED") == trace_apply_count_before)
	_check("stable application result remains queryable", not (status_runtime.call("get_application_result", real_request_id) as Dictionary).is_empty())

	_check("second Bleeding application succeeds", bool((status_runtime.call("consume_application_request", _bleeding_request("B2"), 3) as Dictionary).get("success", false)))
	_check("third Bleeding application succeeds", bool((status_runtime.call("consume_application_request", _bleeding_request("B3"), 4) as Dictionary).get("success", false)))
	_check("fourth Bleeding application succeeds but remains capped", bool((status_runtime.call("consume_application_request", _bleeding_request("B4"), 5) as Dictionary).get("success", false)))
	bleeding = status_runtime.call("get_status_instance", HUNTER_ID, "status_bleeding")
	_check("Bleeding intensity caps at 3", int(bleeding.get("intensity", 0)) == 3, str(bleeding))
	_check("Bleeding reapplications do not move first eligible tick", int(bleeding.get("first_tick_round", 0)) == 4, str(bleeding))

	var off1: Dictionary = status_runtime.call("consume_application_request", _off_balance_request("OB1"), 4)
	var off2: Dictionary = status_runtime.call("consume_application_request", _off_balance_request("OB2"), 5)
	_check("Off-Balance apply and refresh succeed", bool(off1.get("success", false)) and bool(off2.get("success", false)))
	var off_balance: Dictionary = status_runtime.call("get_status_instance", HUNTER_ID, "status_off_balance")
	_check("Off-Balance remains one refreshed instance", int(off_balance.get("application_count", 0)) == 2 and int(off_balance.get("first_application_round", 0)) == 4 and int(off_balance.get("last_application_round", 0)) == 5, str(off_balance))
	_check("Off-Balance records pending completed-activation expiry", String(off_balance.get("pending_expiry_hook", "")) == "TURN_END" and String(off_balance.get("expiry_condition", "")) == "AFTER_TARGET_COMPLETES_NEXT_NORMAL_ACTIVATION" and String(off_balance.get("expiry_status", "")) == "PENDING_STATUS_TIMING_RUNTIME", str(off_balance))

	var staggered_request := _staggered_request("ST1")
	var staggered_first: Dictionary = status_runtime.call("consume_application_request", staggered_request, 4)
	var staggered_second: Dictionary = status_runtime.call("consume_application_request", _staggered_request("ST2"), 5)
	_check("Staggered apply and refresh succeed", bool(staggered_first.get("success", false)) and bool(staggered_second.get("success", false)))
	var staggered: Dictionary = status_runtime.call("get_status_instance", HUNTER_ID, "status_staggered")
	_check("Staggered remains one refreshed non-stacking instance", int(staggered.get("intensity", 0)) == 1 and int(staggered.get("max_intensity", 0)) == 1 and int(staggered.get("application_count", 0)) == 2 and int(staggered.get("first_application_round", 0)) == 4 and int(staggered.get("last_application_round", 0)) == 5, str(staggered))
	_check("Staggered records next-turn conversion without hidden skip", String(staggered.get("pending_transition_hook", "")) == "TURN_START_PRE_RECOVERY" and String(staggered.get("transition_status_id", "")) == "status_off_balance" and String(staggered.get("activation_policy", "")) == "CONTINUE_SAME_NORMAL_ACTIVATION", str(staggered))
	var staggered_replay: Dictionary = status_runtime.call("consume_application_request", staggered_request, 4)
	_check("Staggered replay is idempotent without extra refresh", bool(staggered_replay.get("duplicate", false)) and int((status_runtime.call("get_status_instance", HUNTER_ID, "status_staggered") as Dictionary).get("application_count", 0)) == 2)
	var invalid_staggered := _staggered_request("ST_INVALID_INTENSITY")
	invalid_staggered["intensity_delta"] = 1
	var invalid_staggered_result: Dictionary = status_runtime.call("consume_application_request", invalid_staggered, 5)
	_check("Staggered rejects intensity stacking", not bool(invalid_staggered_result.get("success", true)) and String(invalid_staggered_result.get("reason", "")) == "STAGGERED_INTENSITY_STACKING_NOT_SUPPORTED", str(invalid_staggered_result))
	_check("only Bleeding + Staggered + Off-Balance instances exist", int(status_runtime.call("get_active_status_count")) == 3)

	var invalid := _bleeding_request("INVALID")
	invalid["consumer_status"] = "WRONG_OWNER"
	var invalid_result: Dictionary = status_runtime.call("consume_application_request", invalid, 5)
	_check("misrouted request is rejected", not bool(invalid_result.get("success", true)) and String(invalid_result.get("reason", "")) == "REQUEST_NOT_ROUTED_TO_GENERIC_STATUS_RUNTIME", str(invalid_result))

	_check("synthetic status applications do not mutate Hunter health", health.call("get_health_state") == health_after_real)
	_check("synthetic status applications do not spend Hunter resources", shell.call("get_resource_state", HUNTER_ID) == hunter_resources_before)
	_check("synthetic status applications do not spend Monster resources", shell.call("get_resource_state", MONSTER_ID) == monster_resources_before)
	_check("synthetic status applications do not mutate anatomy", anatomy.call("get_target_state", "HEAD") == anatomy_before)

	var snapshot: Dictionary = status_runtime.call("get_persistence_snapshot")
	var restored := STATUS_SCRIPT.new() as Node
	restored.name = "StatusApplicationRuntimeRestoreProbe"
	shell.add_child(restored)
	_check("fresh restore probe initializes", bool(restored.call("initialize", shell, encounter.call("get_encounter_record") as Dictionary)))
	_check("status snapshot restores", bool(restored.call("restore_persistence_snapshot", snapshot)))
	_check("restored Bleeding intensity matches", int((restored.call("get_status_instance", HUNTER_ID, "status_bleeding") as Dictionary).get("intensity", 0)) == 3)
	_check("restored Staggered refresh state matches", int((restored.call("get_status_instance", HUNTER_ID, "status_staggered") as Dictionary).get("application_count", 0)) == 2 and String((restored.call("get_status_instance", HUNTER_ID, "status_staggered") as Dictionary).get("transition_status_id", "")) == "status_off_balance")
	_check("rehydration runs no ON_APPLY trace", _count_trace_event(restored.call("get_trace") as Array, "STATUS_ON_APPLY_COMMITTED") == 0)
	var restored_replay: Dictionary = restored.call("consume_application_request", real_request, 3)
	_check("restored consumed request remains idempotent", bool(restored_replay.get("duplicate", false)) and int(restored.call("get_application_count")) == int(status_runtime.call("get_application_count")))
	_check("restored replay still runs no ON_APPLY trace", _count_trace_event(restored.call("get_trace") as Array, "STATUS_ON_APPLY_COMMITTED") == 0)

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_GENERIC_STATUS_APPLICATION_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_GENERIC_STATUS_APPLICATION_RUNTIME_FAILED")
	print("This gate verifies Bleeding/Off-Balance/Staggered application state but does not execute Bleeding periodic damage, Tail Sweep Staggered producer wiring, resource refresh/spend, Initiative edits, structural damage, defeat, phone acceptance or performance verification.")
	quit(0 if failures.is_empty() else 1)
