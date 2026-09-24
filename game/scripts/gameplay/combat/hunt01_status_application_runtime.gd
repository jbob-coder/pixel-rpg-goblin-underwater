extends Node

const SCHEMA := "uhr.hunt01.status_application.v1"
const REQUEST_SCHEMA := "uhr.status_application_request.v1"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const CONSUMER_STATUS := "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME"
const TRIGGER_HOOK := "ON_HIT_OR_DAMAGE_CONSEQUENCE"
const STATUS_BLEEDING := "status_bleeding"
const STATUS_STAGGERED := "status_staggered"
const STATUS_OFF_BALANCE := "status_off_balance"
const BLEEDING_MAX_INTENSITY := 3
const AUTHORITY_STATUS := "NO_AUTHORED_FIRST_SLICE_STATUS_IMMUNITY_DATA"

const STATUS_DEFINITIONS := {
	STATUS_BLEEDING: {
		"status_id": STATUS_BLEEDING,
		"category": "PERSISTENT_PHYSICAL_CONDITION",
		"stack_rule": "STACK_INTENSITY_CAPPED",
		"max_intensity": BLEEDING_MAX_INTENSITY,
		"periodic_hook": "ROUND_END",
		"persistence_policy": "PERSISTS_UNTIL_EXPLICIT_REMOVAL_OR_TERMINAL_STATE",
	},
	STATUS_STAGGERED: {
		"status_id": STATUS_STAGGERED,
		"category": "TRANSIENT_PHYSICAL_DISRUPTION",
		"stack_rule": "REFRESH_DURATION",
		"max_intensity": 1,
		"transition_hook": "TURN_START_PRE_RECOVERY",
		"transition_status_id": STATUS_OFF_BALANCE,
		"activation_policy": "CONTINUE_SAME_NORMAL_ACTIVATION",
		"persistence_policy": "UNTIL_NEXT_TARGET_TURN_START_TRANSITION",
	},
	STATUS_OFF_BALANCE: {
		"status_id": STATUS_OFF_BALANCE,
		"category": "TEMPORARY_STABILITY_CONDITION",
		"stack_rule": "REFRESH_DURATION",
		"max_intensity": 1,
		"natural_expiry_hook": "TURN_END",
		"persistence_policy": "UNTIL_COMPLETED_NORMAL_ACTIVATION_OR_EXPLICIT_STABILIZATION",
	},
}

var _shell: Node = null
var _encounter_record: Dictionary = {}
var _initialized := false
var _instances: Dictionary = {}
var _applications: Dictionary = {}
var _timing_transitions: Dictionary = {}
var _trace_sequence := 0
var _trace: Array[Dictionary] = []

func initialize(shell: Node, encounter_record: Dictionary) -> bool:
	if _initialized or shell == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not bool(shell.call("is_initialized")):
		return false
	_shell = shell
	_encounter_record = encounter_record.duplicate(true)
	_initialized = true
	_record_trace("STATUS_APPLICATION_RUNTIME_READY", {
		"schema": SCHEMA,
		"supported_status_ids": STATUS_DEFINITIONS.keys(),
		"authority_status": AUTHORITY_STATUS,
	})
	return true

func consume_application_request(request: Dictionary, application_round: int) -> Dictionary:
	if not _initialized:
		return {"success": false, "reason": "STATUS_APPLICATION_RUNTIME_NOT_INITIALIZED"}
	var validation := _validate_request(request, application_round)
	if not bool(validation.get("valid", false)):
		return {"success": false, "reason": String(validation.get("reason", "INVALID_STATUS_APPLICATION_REQUEST"))}
	var request_id := String(request.get("application_request_id", ""))
	if _applications.has(request_id):
		var replay := (_applications[request_id] as Dictionary).duplicate(true)
		replay["duplicate"] = true
		replay["status"] = "STATUS_APPLICATION_READBACK_IDEMPOTENT"
		return replay
	var status_id := String(request.get("status_id", ""))
	var target_actor_id := String(request.get("target_actor_id", ""))
	var instance_key := _instance_key(target_actor_id, status_id)
	var before: Dictionary = {}
	if _instances.has(instance_key):
		before = (_instances[instance_key] as Dictionary).duplicate(true)
	var instance: Dictionary = {}
	if status_id == STATUS_BLEEDING:
		instance = _apply_bleeding(request, application_round, before)
	elif status_id == STATUS_STAGGERED:
		instance = _apply_staggered(request, application_round, before)
	elif status_id == STATUS_OFF_BALANCE:
		instance = _apply_off_balance(request, application_round, before)
	else:
		return {"success": false, "reason": "UNSUPPORTED_STATUS_ID"}
	_instances[instance_key] = instance.duplicate(true)
	var result := {
		"success": true,
		"status": "STATUS_APPLICATION_COMMITTED",
		"schema": SCHEMA,
		"application_request_id": request_id,
		"source_resolution_id": String(request.get("source_resolution_id", "")),
		"source_actor_id": String(request.get("source_actor_id", "")),
		"source_action_id": String(request.get("source_action_id", "")),
		"target_actor_id": target_actor_id,
		"status_id": status_id,
		"application_round": application_round,
		"trigger_hook": String(request.get("trigger_hook", "")),
		"stack_rule": String((STATUS_DEFINITIONS[status_id] as Dictionary).get("stack_rule", "")),
		"instance_before": before.duplicate(true),
		"instance_after": instance.duplicate(true),
		"on_apply_committed": true,
		"duplicate": false,
		"authority_status": AUTHORITY_STATUS,
	}
	_applications[request_id] = result.duplicate(true)
	_record_trace("STATUS_ON_APPLY_COMMITTED", result)
	return result.duplicate(true)

func _validate_request(request: Dictionary, application_round: int) -> Dictionary:
	if application_round <= 0:
		return {"valid": false, "reason": "INVALID_APPLICATION_ROUND"}
	if String(request.get("status", "")) != "VALID_STATUS_APPLICATION_REQUEST":
		return {"valid": false, "reason": "REQUEST_NOT_MARKED_VALID"}
	if String(request.get("request_schema", "")) != REQUEST_SCHEMA:
		return {"valid": false, "reason": "UNSUPPORTED_REQUEST_SCHEMA"}
	if String(request.get("consumer_status", "")) != CONSUMER_STATUS:
		return {"valid": false, "reason": "REQUEST_NOT_ROUTED_TO_GENERIC_STATUS_RUNTIME"}
	if String(request.get("trigger_hook", "")) != TRIGGER_HOOK:
		return {"valid": false, "reason": "UNSUPPORTED_APPLICATION_TRIGGER"}
	var request_id := String(request.get("application_request_id", ""))
	var status_id := String(request.get("status_id", ""))
	var target_actor_id := String(request.get("target_actor_id", ""))
	if request_id.is_empty() or status_id.is_empty() or target_actor_id.is_empty():
		return {"valid": false, "reason": "MISSING_STABLE_APPLICATION_IDENTITY"}
	if String(request.get("source_resolution_id", "")).is_empty() or String(request.get("source_actor_id", "")).is_empty() or String(request.get("source_action_id", "")).is_empty():
		return {"valid": false, "reason": "MISSING_SOURCE_IDENTITY"}
	if not STATUS_DEFINITIONS.has(status_id):
		return {"valid": false, "reason": "UNSUPPORTED_STATUS_ID"}
	if status_id == STATUS_BLEEDING:
		if String(request.get("application_mode", "")) != "STACK_INTENSITY_CAPPED":
			return {"valid": false, "reason": "BLEEDING_STACK_MODE_MISMATCH"}
		if int(request.get("intensity_delta", 0)) <= 0:
			return {"valid": false, "reason": "BLEEDING_INTENSITY_DELTA_INVALID"}
	elif status_id == STATUS_STAGGERED:
		if String(request.get("application_mode", "")) != "APPLY_OR_REFRESH":
			return {"valid": false, "reason": "STAGGERED_APPLICATION_MODE_MISMATCH"}
		if int(request.get("intensity_delta", 0)) != 0:
			return {"valid": false, "reason": "STAGGERED_INTENSITY_STACKING_NOT_SUPPORTED"}
	elif status_id == STATUS_OFF_BALANCE and String(request.get("application_mode", "")) != "APPLY_OR_REFRESH":
		return {"valid": false, "reason": "OFF_BALANCE_APPLICATION_MODE_MISMATCH"}
	return {"valid": true, "reason": "VALID_GENERIC_STATUS_APPLICATION_REQUEST"}

func _apply_bleeding(request: Dictionary, application_round: int, before: Dictionary) -> Dictionary:
	var request_id := String(request.get("application_request_id", ""))
	var target_actor_id := String(request.get("target_actor_id", ""))
	var previous_intensity := int(before.get("intensity", 0))
	var next_intensity := mini(previous_intensity + int(request.get("intensity_delta", 0)), BLEEDING_MAX_INTENSITY)
	var source_requests: Array = (before.get("source_application_request_ids", []) as Array).duplicate(true)
	if not source_requests.has(request_id):
		source_requests.append(request_id)
	return {
		"instance_id": _instance_key(target_actor_id, STATUS_BLEEDING),
		"status_id": STATUS_BLEEDING,
		"target_actor_id": target_actor_id,
		"category": "PERSISTENT_PHYSICAL_CONDITION",
		"stack_rule": "STACK_INTENSITY_CAPPED",
		"intensity": next_intensity,
		"max_intensity": BLEEDING_MAX_INTENSITY,
		"first_application_round": int(before.get("first_application_round", application_round)),
		"last_application_round": application_round,
		"first_tick_round": int(before.get("first_tick_round", application_round + 1)),
		"last_periodic_event_round": int(before.get("last_periodic_event_round", 0)),
		"last_periodic_event_id": String(before.get("last_periodic_event_id", "")),
		"periodic_hook": "ROUND_END",
		"periodic_status": "PENDING_STATUS_TIMING_RUNTIME",
		"source_application_request_ids": source_requests,
		"source_resolution_id": String(request.get("source_resolution_id", "")),
		"source_actor_id": String(request.get("source_actor_id", "")),
		"source_action_id": String(request.get("source_action_id", "")),
		"source_metadata": _source_metadata(request),
		"persistence_status": "ACTIVE_PERSISTENT_CONDITION",
	}

func _apply_staggered(request: Dictionary, application_round: int, before: Dictionary) -> Dictionary:
	var request_id := String(request.get("application_request_id", ""))
	var target_actor_id := String(request.get("target_actor_id", ""))
	var source_requests: Array = (before.get("source_application_request_ids", []) as Array).duplicate(true)
	if not source_requests.has(request_id):
		source_requests.append(request_id)
	return {
		"instance_id": _instance_key(target_actor_id, STATUS_STAGGERED),
		"status_id": STATUS_STAGGERED,
		"target_actor_id": target_actor_id,
		"category": "TRANSIENT_PHYSICAL_DISRUPTION",
		"stack_rule": "REFRESH_DURATION",
		"intensity": 1,
		"max_intensity": 1,
		"first_application_round": int(before.get("first_application_round", application_round)),
		"last_application_round": application_round,
		"application_count": int(before.get("application_count", 0)) + 1,
		"pending_transition_hook": "TURN_START_PRE_RECOVERY",
		"transition_status_id": STATUS_OFF_BALANCE,
		"transition_status": "PENDING_STATUS_TIMING_RUNTIME",
		"activation_policy": "CONTINUE_SAME_NORMAL_ACTIVATION",
		"normal_parry_legal": false,
		"normal_dodge_legal": false,
		"block_reactive_brace_policy": "MAY_REMAIN_LEGAL_IF_OTHER_OWNERS_ALLOW",
		"source_application_request_ids": source_requests,
		"source_resolution_id": String(request.get("source_resolution_id", "")),
		"source_actor_id": String(request.get("source_actor_id", "")),
		"source_action_id": String(request.get("source_action_id", "")),
		"source_metadata": _source_metadata(request),
		"persistence_status": "ACTIVE_TRANSIENT_DISRUPTION",
	}

func _apply_off_balance(request: Dictionary, application_round: int, before: Dictionary) -> Dictionary:
	var request_id := String(request.get("application_request_id", ""))
	var target_actor_id := String(request.get("target_actor_id", ""))
	var source_requests: Array = (before.get("source_application_request_ids", []) as Array).duplicate(true)
	if not source_requests.has(request_id):
		source_requests.append(request_id)
	return {
		"instance_id": _instance_key(target_actor_id, STATUS_OFF_BALANCE),
		"status_id": STATUS_OFF_BALANCE,
		"target_actor_id": target_actor_id,
		"category": "TEMPORARY_STABILITY_CONDITION",
		"stack_rule": "REFRESH_DURATION",
		"intensity": 1,
		"max_intensity": 1,
		"first_application_round": int(before.get("first_application_round", application_round)),
		"last_application_round": application_round,
		"application_count": int(before.get("application_count", 0)) + 1,
		"pending_expiry_hook": "TURN_END",
		"expiry_condition": "AFTER_TARGET_COMPLETES_NEXT_NORMAL_ACTIVATION",
		"expiry_status": "PENDING_STATUS_TIMING_RUNTIME",
		"deliberate_stabilization_status": "PENDING_BRACE_ACTION_INTEGRATION",
		"source_application_request_ids": source_requests,
		"source_resolution_id": String(request.get("source_resolution_id", "")),
		"source_actor_id": String(request.get("source_actor_id", "")),
		"source_action_id": String(request.get("source_action_id", "")),
		"source_metadata": _source_metadata(request),
		"persistence_status": "ACTIVE_TEMPORARY_CONDITION",
	}

func _source_metadata(request: Dictionary) -> Dictionary:
	var metadata := {}
	for key in ["qualification", "hit_quality", "applied_injury_load", "block_outcome"]:
		if request.has(key):
			metadata[key] = request[key]
	return metadata

func _instance_key(target_actor_id: String, status_id: String) -> String:
	return "%s|%s" % [target_actor_id, status_id]

func get_definition(status_id: String) -> Dictionary:
	if not STATUS_DEFINITIONS.has(status_id):
		return {}
	return (STATUS_DEFINITIONS[status_id] as Dictionary).duplicate(true)

func get_status_instance(target_actor_id: String, status_id: String) -> Dictionary:
	var key := _instance_key(target_actor_id, status_id)
	if not _instances.has(key):
		return {}
	return (_instances[key] as Dictionary).duplicate(true)

func get_active_instances_snapshot() -> Dictionary:
	return _instances.duplicate(true)

func has_status(target_actor_id: String, status_id: String) -> bool:
	return _instances.has(_instance_key(target_actor_id, status_id))

func transition_staggered_to_off_balance_for_timing(target_actor_id: String, round_id: int) -> Dictionary:
	if not _initialized or target_actor_id.is_empty() or round_id <= 0:
		return {"success": false, "reason": "INVALID_STAGGERED_TIMING_TRANSITION"}
	var transition_id := "%s|R%d|%s|STAGGERED_TO_OFF_BALANCE" % [EXPECTED_ENCOUNTER_ID, round_id, target_actor_id]
	if _timing_transitions.has(transition_id):
		var replay := (_timing_transitions[transition_id] as Dictionary).duplicate(true)
		replay["duplicate"] = true
		return replay
	var staggered_key := _instance_key(target_actor_id, STATUS_STAGGERED)
	if not _instances.has(staggered_key):
		return {"success": false, "reason": "STAGGERED_INSTANCE_NOT_AVAILABLE", "transition_id": transition_id}
	var staggered := (_instances[staggered_key] as Dictionary).duplicate(true)
	_instances.erase(staggered_key)
	var off_balance_key := _instance_key(target_actor_id, STATUS_OFF_BALANCE)
	var off_balance_before: Dictionary = {}
	if _instances.has(off_balance_key):
		off_balance_before = (_instances[off_balance_key] as Dictionary).duplicate(true)
	var transition_request := {
		"application_request_id": transition_id,
		"target_actor_id": target_actor_id,
		"source_actor_id": String(staggered.get("source_actor_id", "")),
		"source_action_id": String(staggered.get("source_action_id", "")),
		"source_resolution_id": String(staggered.get("source_resolution_id", "")),
		"qualification": "STAGGERED_NATURAL_RECOVERY_TO_OFF_BALANCE",
	}
	var off_balance_after := _apply_off_balance(transition_request, round_id, off_balance_before)
	_instances[off_balance_key] = off_balance_after.duplicate(true)
	var result := {
		"success": true,
		"status": "STAGGERED_TRANSITIONED_TO_OFF_BALANCE",
		"transition_id": transition_id,
		"round_id": round_id,
		"target_actor_id": target_actor_id,
		"removed_staggered_instance": staggered.duplicate(true),
		"off_balance_before": off_balance_before.duplicate(true),
		"off_balance_after": off_balance_after.duplicate(true),
		"activation_policy": "CONTINUE_SAME_NORMAL_ACTIVATION",
		"duplicate": false,
	}
	_timing_transitions[transition_id] = result.duplicate(true)
	_record_trace("STAGGERED_TO_OFF_BALANCE_TIMING_TRANSITION_COMMITTED", result)
	return result.duplicate(true)

func arm_off_balance_expiry(target_actor_id: String, round_id: int) -> Dictionary:
	var key := _instance_key(target_actor_id, STATUS_OFF_BALANCE)
	if round_id <= 0 or not _instances.has(key):
		return {"success": false, "reason": "OFF_BALANCE_INSTANCE_NOT_AVAILABLE"}
	var instance := (_instances[key] as Dictionary).duplicate(true)
	if int(instance.get("expiry_armed_round", 0)) == round_id:
		return {"success": true, "status": "OFF_BALANCE_EXPIRY_ALREADY_ARMED", "duplicate": true, "round_id": round_id}
	instance["expiry_armed_round"] = round_id
	instance["expiry_status"] = "ARMED_FOR_TARGET_TURN_END"
	_instances[key] = instance.duplicate(true)
	var result := {"success": true, "status": "OFF_BALANCE_EXPIRY_ARMED", "duplicate": false, "round_id": round_id, "target_actor_id": target_actor_id}
	_record_trace("OFF_BALANCE_EXPIRY_ARMED", result)
	return result

func remove_off_balance_for_timing(target_actor_id: String, round_id: int) -> Dictionary:
	var key := _instance_key(target_actor_id, STATUS_OFF_BALANCE)
	var removal_id := "%s|R%d|%s|OFF_BALANCE_REMOVAL" % [EXPECTED_ENCOUNTER_ID, round_id, target_actor_id]
	if not _instances.has(key):
		return {"success": true, "status": "OFF_BALANCE_ALREADY_ABSENT", "duplicate": true, "removal_id": removal_id}
	var instance := (_instances[key] as Dictionary).duplicate(true)
	if int(instance.get("expiry_armed_round", 0)) != round_id:
		return {"success": false, "reason": "OFF_BALANCE_EXPIRY_NOT_ARMED_FOR_ROUND", "removal_id": removal_id}
	_instances.erase(key)
	var result := {
		"success": true,
		"status": "OFF_BALANCE_NATURAL_RECOVERY_REMOVED",
		"duplicate": false,
		"removal_id": removal_id,
		"round_id": round_id,
		"target_actor_id": target_actor_id,
		"removed_instance": instance,
	}
	_record_trace("OFF_BALANCE_NATURAL_RECOVERY_REMOVED", result)
	return result

func mark_bleeding_periodic_event_emitted(target_actor_id: String, round_id: int, event_id: String) -> Dictionary:
	var key := _instance_key(target_actor_id, STATUS_BLEEDING)
	if round_id <= 0 or event_id.is_empty() or not _instances.has(key):
		return {"success": false, "reason": "BLEEDING_INSTANCE_OR_EVENT_INVALID"}
	var instance := (_instances[key] as Dictionary).duplicate(true)
	if int(instance.get("last_periodic_event_round", 0)) == round_id:
		return {"success": true, "status": "BLEEDING_PERIODIC_EVENT_ALREADY_MARKED", "duplicate": true, "event_id": String(instance.get("last_periodic_event_id", ""))}
	instance["last_periodic_event_round"] = round_id
	instance["last_periodic_event_id"] = event_id
	instance["periodic_status"] = "PERIODIC_CONSEQUENCE_PENDING_DOWNSTREAM"
	_instances[key] = instance.duplicate(true)
	var result := {"success": true, "status": "BLEEDING_PERIODIC_EVENT_MARKED", "duplicate": false, "round_id": round_id, "event_id": event_id, "target_actor_id": target_actor_id}
	_record_trace("BLEEDING_PERIODIC_EVENT_MARKED", result)
	return result

func get_active_status_count() -> int:
	return _instances.size()

func get_application_result(application_request_id: String) -> Dictionary:
	if not _applications.has(application_request_id):
		return {}
	return (_applications[application_request_id] as Dictionary).duplicate(true)

func get_application_count() -> int:
	return _applications.size()

func get_timing_transition_count() -> int:
	return _timing_transitions.size()

func get_persistence_snapshot() -> Dictionary:
	return {"schema": SCHEMA, "encounter_id": EXPECTED_ENCOUNTER_ID, "instances": _instances.duplicate(true), "applications": _applications.duplicate(true), "timing_transitions": _timing_transitions.duplicate(true)}

func restore_persistence_snapshot(snapshot: Dictionary) -> bool:
	if not _initialized or not _instances.is_empty() or not _applications.is_empty() or not _timing_transitions.is_empty():
		return false
	if String(snapshot.get("schema", "")) != SCHEMA or String(snapshot.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	var instances_variant: Variant = snapshot.get("instances", {})
	var applications_variant: Variant = snapshot.get("applications", {})
	var transitions_variant: Variant = snapshot.get("timing_transitions", {})
	if typeof(instances_variant) != TYPE_DICTIONARY or typeof(applications_variant) != TYPE_DICTIONARY or typeof(transitions_variant) != TYPE_DICTIONARY:
		return false
	_instances = (instances_variant as Dictionary).duplicate(true)
	_applications = (applications_variant as Dictionary).duplicate(true)
	_timing_transitions = (transitions_variant as Dictionary).duplicate(true)
	_record_trace("STATUS_STATE_REHYDRATED_WITHOUT_ON_APPLY_REPLAY", {"instance_count": _instances.size(), "application_count": _applications.size(), "timing_transition_count": _timing_transitions.size()})
	return true

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {"sequence": _trace_sequence, "event": event_name, "encounter_id": EXPECTED_ENCOUNTER_ID}
	for key in details.keys():
		entry[key] = details[key]
	_trace.append(entry)

func get_trace() -> Array[Dictionary]:
	return _trace.duplicate(true)

func get_schema() -> String:
	return SCHEMA

func get_authority_status() -> String:
	return AUTHORITY_STATUS

func is_initialized() -> bool:
	return _initialized
