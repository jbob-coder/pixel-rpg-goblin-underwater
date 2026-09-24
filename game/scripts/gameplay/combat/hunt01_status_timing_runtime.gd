extends Node

const SCHEMA := "uhr.hunt01.status_timing.v1"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const STATUS_BLEEDING := "status_bleeding"
const STATUS_STAGGERED := "status_staggered"
const STATUS_OFF_BALANCE := "status_off_balance"
const PENDING_BLEEDING_CONSEQUENCE := "PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE"

var _shell: Node = null
var _status_application: Node = null
var _encounter_record: Dictionary = {}
var _initialized := false
var _turn_start_hooks: Dictionary = {}
var _turn_end_hooks: Dictionary = {}
var _round_end_hooks: Dictionary = {}
var _periodic_events: Dictionary = {}
var _removal_events: Dictionary = {}
var _trace_sequence := 0
var _trace: Array[Dictionary] = []

func initialize(shell: Node, status_application: Node, encounter_record: Dictionary) -> bool:
	if _initialized or shell == null or status_application == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not bool(shell.call("is_initialized")) or not bool(status_application.call("is_initialized")):
		return false
	_shell = shell
	_status_application = status_application
	_encounter_record = encounter_record.duplicate(true)
	if not bool(_shell.call("register_status_timing_driver", self)):
		return false
	_initialized = true
	_record_trace("STATUS_TIMING_RUNTIME_READY", {"schema": SCHEMA})
	return true

func on_turn_start_pre_recovery(combatant_id: String, round_id: int) -> Dictionary:
	if not _initialized or combatant_id.is_empty() or round_id <= 0:
		return {"success": false, "reason": "INVALID_TURN_START_HOOK"}
	var hook_id := "%d|%s|TURN_START_PRE_RECOVERY" % [round_id, combatant_id]
	if _turn_start_hooks.has(hook_id):
		var duplicate := (_turn_start_hooks[hook_id] as Dictionary).duplicate(true)
		duplicate["duplicate"] = true
		return duplicate

	var staggered_transition: Dictionary = {}
	if bool(_status_application.call("has_status", combatant_id, STATUS_STAGGERED)):
		staggered_transition = _status_application.call("transition_staggered_to_off_balance_for_timing", combatant_id, round_id)
		if not bool(staggered_transition.get("success", false)):
			return {"success": false, "reason": "STAGGERED_TIMING_TRANSITION_REJECTED", "transition_result": staggered_transition}

	var armed_result: Dictionary = {}
	if bool(_status_application.call("has_status", combatant_id, STATUS_OFF_BALANCE)):
		armed_result = _status_application.call("arm_off_balance_expiry", combatant_id, round_id)
		if not bool(armed_result.get("success", false)):
			return {"success": false, "reason": "OFF_BALANCE_EXPIRY_ARM_REJECTED", "arm_result": armed_result}
	var result := {
		"success": true,
		"status": "TURN_START_PRE_RECOVERY_STATUS_TIMING_PROCESSED",
		"hook_id": hook_id,
		"round_id": round_id,
		"combatant_id": combatant_id,
		"staggered_transition": staggered_transition.duplicate(true),
		"off_balance_expiry_arm": armed_result.duplicate(true),
		"activation_policy": "CONTINUE_SAME_NORMAL_ACTIVATION",
		"duplicate": false,
	}
	_turn_start_hooks[hook_id] = result.duplicate(true)
	_record_trace("TURN_START_PRE_RECOVERY_STATUS_TIMING_PROCESSED", result)
	return result

func on_turn_end(combatant_id: String, round_id: int) -> Dictionary:
	if not _initialized or combatant_id.is_empty() or round_id <= 0:
		return {"success": false, "reason": "INVALID_TURN_END_HOOK"}
	var hook_id := "%d|%s|TURN_END" % [round_id, combatant_id]
	if _turn_end_hooks.has(hook_id):
		var duplicate := (_turn_end_hooks[hook_id] as Dictionary).duplicate(true)
		duplicate["duplicate"] = true
		return duplicate

	var removal_result: Dictionary = {}
	var off_balance: Dictionary = _status_application.call("get_status_instance", combatant_id, STATUS_OFF_BALANCE)
	if not off_balance.is_empty() and int(off_balance.get("expiry_armed_round", 0)) == round_id:
		removal_result = _status_application.call("remove_off_balance_for_timing", combatant_id, round_id)
		if bool(removal_result.get("success", false)) and not bool(removal_result.get("duplicate", false)):
			var removal_id := String(removal_result.get("removal_id", ""))
			if not removal_id.is_empty():
				_removal_events[removal_id] = removal_result.duplicate(true)
	var result := {
		"success": true,
		"status": "TURN_END_STATUS_TIMING_PROCESSED",
		"hook_id": hook_id,
		"round_id": round_id,
		"combatant_id": combatant_id,
		"off_balance_removal": removal_result.duplicate(true),
		"duplicate": false,
	}
	_turn_end_hooks[hook_id] = result.duplicate(true)
	_record_trace("TURN_END_STATUS_TIMING_PROCESSED", result)
	return result

func on_round_end(round_id: int) -> Dictionary:
	if not _initialized or round_id <= 0:
		return {"success": false, "reason": "INVALID_ROUND_END_HOOK"}
	var hook_id := "%d|ROUND_END" % round_id
	if _round_end_hooks.has(hook_id):
		var duplicate := (_round_end_hooks[hook_id] as Dictionary).duplicate(true)
		duplicate["duplicate"] = true
		return duplicate

	var emitted: Array[Dictionary] = []
	var instances: Dictionary = _status_application.call("get_active_instances_snapshot")
	var instance_keys: Array = instances.keys()
	instance_keys.sort()
	for key_variant in instance_keys:
		var instance := (instances[key_variant] as Dictionary).duplicate(true)
		if String(instance.get("status_id", "")) != STATUS_BLEEDING:
			continue
		var first_tick_round := int(instance.get("first_tick_round", 0))
		if first_tick_round <= 0 or round_id < first_tick_round:
			continue
		if int(instance.get("last_periodic_event_round", 0)) == round_id:
			continue
		var target_actor_id := String(instance.get("target_actor_id", ""))
		var event_id := "%s|R%d|%s|%s|PERIODIC" % [EXPECTED_ENCOUNTER_ID, round_id, target_actor_id, STATUS_BLEEDING]
		if _periodic_events.has(event_id):
			continue
		var event := {
			"success": true,
			"status": PENDING_BLEEDING_CONSEQUENCE,
			"event_id": event_id,
			"encounter_id": EXPECTED_ENCOUNTER_ID,
			"round_id": round_id,
			"target_actor_id": target_actor_id,
			"status_id": STATUS_BLEEDING,
			"intensity": int(instance.get("intensity", 0)),
			"first_tick_round": first_tick_round,
			"source_actor_id": String(instance.get("source_actor_id", "")),
			"source_action_id": String(instance.get("source_action_id", "")),
			"source_resolution_id": String(instance.get("source_resolution_id", "")),
			"health_magnitude_status": "NOT_SELECTED_PENDING_AUTHORITY",
			"consumer_status": "PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE_OWNER",
		}
		var mark: Dictionary = _status_application.call("mark_bleeding_periodic_event_emitted", target_actor_id, round_id, event_id)
		if not bool(mark.get("success", false)):
			return {"success": false, "reason": "BLEEDING_PERIODIC_MARK_REJECTED", "mark_result": mark}
		_periodic_events[event_id] = event.duplicate(true)
		emitted.append(event.duplicate(true))
		_record_trace("BLEEDING_PERIODIC_CONSEQUENCE_PENDING", event)

	var result := {
		"success": true,
		"status": "ROUND_END_STATUS_TIMING_PROCESSED",
		"hook_id": hook_id,
		"round_id": round_id,
		"periodic_events_emitted": emitted,
		"periodic_event_count": emitted.size(),
		"duplicate": false,
	}
	_round_end_hooks[hook_id] = result.duplicate(true)
	_record_trace("ROUND_END_STATUS_TIMING_PROCESSED", result)
	return result

func get_periodic_event(event_id: String) -> Dictionary:
	if not _periodic_events.has(event_id):
		return {}
	return (_periodic_events[event_id] as Dictionary).duplicate(true)

func get_periodic_events() -> Array[Dictionary]:
	var keys: Array = _periodic_events.keys()
	keys.sort()
	var result: Array[Dictionary] = []
	for key_variant in keys:
		result.append((_periodic_events[key_variant] as Dictionary).duplicate(true))
	return result

func get_periodic_event_count() -> int:
	return _periodic_events.size()

func get_removal_event_count() -> int:
	return _removal_events.size()

func get_trace() -> Array[Dictionary]:
	return _trace.duplicate(true)

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {
		"sequence": _trace_sequence,
		"event": event_name,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
	}
	for key in details.keys():
		entry[key] = details[key]
	_trace.append(entry)

func get_schema() -> String:
	return SCHEMA

func is_initialized() -> bool:
	return _initialized
