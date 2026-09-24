extends Node

const SCHEMA := "uhr.hunt01.mudcrest_wound_contact.v1"
const REQUEST_SCHEMA := "uhr.status_application_request.v1"
const STATUS_APPLICATION_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_status_application_runtime.gd")
const STATUS_TIMING_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_status_timing_runtime.gd")
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const HEAD_SWEEP_ATTACK_ID := "M01_HEAD_SWEEP_GORE"
const TAIL_SWEEP_ATTACK_ID := "M01_TAIL_SWEEP"
const GORE_SWEEP_PROFILE := "GORE_SWEEP"
const TAIL_SWEEP_PROFILE := "TAIL_SWEEP_IMPACT"
const STATUS_BLEEDING := "status_bleeding"
const STATUS_STAGGERED := "status_staggered"
const STATUS_OFF_BALANCE := "status_off_balance"
const TRIGGER_HOOK := "ON_HIT_OR_DAMAGE_CONSEQUENCE"
const FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_HEAD_SWEEP_WOUND_CONTACT_CLASSIFICATION_FIXTURE"
const TAIL_SWEEP_FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_TAIL_SWEEP_WOUND_CONTACT_CLASSIFICATION_FIXTURE"

var _encounter_record: Dictionary = {}
var _status_application: Node = null
var _status_timing: Node = null
var _initialized := false
var _resolutions: Dictionary = {}
var _last_resolution: Dictionary = {}
var _trace_sequence := 0
var _trace: Array[Dictionary] = []

func initialize(encounter_record: Dictionary) -> bool:
	if _initialized or String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	_encounter_record = encounter_record.duplicate(true)
	if not _bind_status_runtimes():
		return false
	_initialized = true
	_record_trace("MUDCREST_WOUND_CONTACT_RUNTIME_READY", {"fixture_status": FIXTURE_STATUS, "tail_sweep_fixture_status": TAIL_SWEEP_FIXTURE_STATUS, "request_schema": REQUEST_SCHEMA, "status_application_schema": String(_status_application.call("get_schema")), "status_timing_schema": String(_status_timing.call("get_schema"))})
	return true

func _bind_status_runtimes() -> bool:
	var attack_owner := get_parent()
	if attack_owner == null:
		return false
	var shell := attack_owner.get_parent()
	if shell == null:
		return false
	var status_runtime := shell.get_node_or_null("StatusApplicationRuntime")
	if status_runtime == null:
		status_runtime = STATUS_APPLICATION_SCRIPT.new() as Node
		if status_runtime == null:
			return false
		status_runtime.name = "StatusApplicationRuntime"
		shell.add_child(status_runtime)
		if not bool(status_runtime.call("initialize", shell, _encounter_record)):
			status_runtime.queue_free()
			return false
	elif not bool(status_runtime.call("is_initialized")) and not bool(status_runtime.call("initialize", shell, _encounter_record)):
		return false
	if String(status_runtime.call("get_schema")) != "uhr.hunt01.status_application.v1":
		return false
	_status_application = status_runtime

	var timing_runtime := shell.get_node_or_null("StatusTimingRuntime")
	if timing_runtime == null:
		timing_runtime = STATUS_TIMING_SCRIPT.new() as Node
		if timing_runtime == null:
			return false
		timing_runtime.name = "StatusTimingRuntime"
		shell.add_child(timing_runtime)
		if not bool(timing_runtime.call("initialize", shell, status_runtime, _encounter_record)):
			timing_runtime.queue_free()
			return false
	elif not bool(timing_runtime.call("is_initialized")) and not bool(timing_runtime.call("initialize", shell, status_runtime, _encounter_record)):
		return false
	if String(timing_runtime.call("get_schema")) != "uhr.hunt01.status_timing.v1":
		return false
	_status_timing = timing_runtime
	return true

func resolve_head_sweep_consequence(damage_handoff: Dictionary, defense_consequence: Dictionary) -> Dictionary:
	if not _initialized:
		return {"success": false, "reason": "WOUND_CONTACT_RUNTIME_NOT_INITIALIZED"}
	var resolution_id := String(damage_handoff.get("resolution_id", ""))
	if resolution_id.is_empty():
		return {"success": false, "reason": "MISSING_RESOLUTION_ID"}
	if _resolutions.has(resolution_id):
		return (_resolutions[resolution_id] as Dictionary).duplicate(true)
	var validation := _validate_input(damage_handoff, defense_consequence)
	if not bool(validation.get("valid", false)):
		return {"success": false, "reason": String(validation.get("reason", "INVALID_WOUND_CONTACT_INPUT")), "resolution_id": resolution_id}
	var health: Dictionary = defense_consequence.get("health_injury_consequence", {}) as Dictionary
	var hit_quality := String(damage_handoff.get("hit_quality", ""))
	var block_outcome := String(defense_consequence.get("block_outcome", "NOT_APPLICABLE"))
	var defense_outcome := String(health.get("defense_outcome", ""))
	var applied_injury := int(health.get("applied_injury_load", 0))
	var damage_channels: Array = (damage_handoff.get("damage_channels", []) as Array).duplicate(true)
	var attack_profile := String(damage_handoff.get("attack_profile", ""))
	var contact_class := String(damage_handoff.get("contact_class", ""))
	var contact_mode := "NO_QUALIFYING_STATUS_CONTACT"
	var classification_reason := "NO_STATUS_PREREQUISITE_ESTABLISHED"
	var horn_penetration := false
	var impact_dominant := false
	var requests: Array[Dictionary] = []
	if contact_class == "NO_CONTACT" or hit_quality == "MISS" or applied_injury <= 0:
		classification_reason = "NO_RESOLVED_WOUND_OR_CONTACT"
	elif attack_profile == GORE_SWEEP_PROFILE and damage_channels.has("PIERCING") and defense_outcome == "NO_ACTIVE_GUARD" and (hit_quality == "SOLID" or hit_quality == "CLEAN"):
		# Reversible first-slice content fixture: unguarded solid/clean GORE_SWEEP
		# with resolved injury is treated as horn penetration. CLEAN no-guard is
		# deliberately assigned to penetration rather than also claiming impact
		# dominance so mixed channels cannot silently request two statuses.
		contact_mode = "HORN_PENETRATION_PROVISIONAL"
		classification_reason = "UNGUARDED_GORE_SWEEP_SOLID_OR_CLEAN_WITH_RESOLVED_INJURY"
		horn_penetration = true
		requests.append(_build_bleeding_request(resolution_id, hit_quality, applied_injury))
	elif damage_channels.has("IMPACT") and hit_quality == "CLEAN" and (block_outcome == "BLOCK_PARTIAL" or block_outcome == "BLOCK_BROKEN") and applied_injury > 0:
		contact_mode = "IMPACT_DOMINANT_GUARD_FAILURE_PROVISIONAL"
		classification_reason = "CLEAN_CONTACT_WITH_PARTIAL_OR_BROKEN_GUARD_AND_RESOLVED_INJURY"
		impact_dominant = true
		requests.append(_build_off_balance_request(resolution_id, block_outcome, applied_injury))
	elif block_outcome == "BLOCK_STRONG":
		contact_mode = "GUARD_ABSORBED_NO_QUALIFYING_STATUS_CONTACT"
		classification_reason = "STRONG_BLOCK_PREVENTS_FIRST_SLICE_PENETRATION_OR_IMPACT_DOMINANCE_CLAIM"
	elif hit_quality == "GRAZE":
		classification_reason = "GRAZE_DOES_NOT_MEET_HEAD_SWEEP_STATUS_REQUEST_THRESHOLD"
	var application_results := _dispatch_requests(requests, int(damage_handoff.get("round_id", 0)))
	var application_dispatch_status := _dispatch_status(requests, application_results, int(damage_handoff.get("round_id", 0)))
	var result := {
		"success": true, "status": "MUDCREST_HEAD_SWEEP_WOUND_CONTACT_CLASSIFIED", "schema": SCHEMA,
		"resolution_id": resolution_id, "classification_id": "%s:WOUND_CONTACT" % resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID, "attacker_id": MONSTER_COMBATANT_ID, "defender_id": HUNTER_COMBATANT_ID,
		"attack_id": HEAD_SWEEP_ATTACK_ID, "attack_profile": attack_profile, "damage_channels": damage_channels,
		"contact_class": contact_class, "hit_quality": hit_quality, "block_outcome": block_outcome, "defense_outcome": defense_outcome,
		"applied_injury_load": applied_injury, "contact_mode": contact_mode, "classification_reason": classification_reason,
		"horn_penetration_established": horn_penetration, "impact_dominant_established": impact_dominant,
		"status_application_requests": requests.duplicate(true), "status_request_count": requests.size(),
		"status_application_results": application_results.duplicate(true), "status_application_dispatch_status": application_dispatch_status,
		"fixture_status": FIXTURE_STATUS, "final_classification_balance_status": "PROVISIONAL_REPLACEABLE_WITH_AUTHORED_CONTACT_WOUND_DATA",
	}
	_store_resolution(resolution_id, result, "MUDCREST_HEAD_SWEEP_WOUND_CONTACT_CLASSIFIED")
	return result.duplicate(true)

func resolve_tail_sweep_consequence(damage_handoff: Dictionary, defense_consequence: Dictionary) -> Dictionary:
	if not _initialized:
		return {"success": false, "reason": "WOUND_CONTACT_RUNTIME_NOT_INITIALIZED"}
	var resolution_id := String(damage_handoff.get("resolution_id", ""))
	if resolution_id.is_empty():
		return {"success": false, "reason": "MISSING_RESOLUTION_ID"}
	if _resolutions.has(resolution_id):
		return (_resolutions[resolution_id] as Dictionary).duplicate(true)
	var validation := _validate_tail_input(damage_handoff, defense_consequence)
	if not bool(validation.get("valid", false)):
		return {"success": false, "reason": String(validation.get("reason", "INVALID_TAIL_SWEEP_WOUND_CONTACT_INPUT")), "resolution_id": resolution_id}

	var health: Dictionary = defense_consequence.get("health_injury_consequence", {}) as Dictionary
	var hit_quality := String(damage_handoff.get("hit_quality", ""))
	var block_outcome := String(defense_consequence.get("block_outcome", "NOT_APPLICABLE"))
	var defense_outcome := String(health.get("defense_outcome", ""))
	var applied_injury := int(health.get("applied_injury_load", 0))
	var contact_class := String(damage_handoff.get("contact_class", ""))
	var requests: Array[Dictionary] = []
	var contact_mode := "NO_QUALIFYING_STATUS_CONTACT"
	var classification_reason := "NO_STATUS_PREREQUISITE_ESTABLISHED"

	if contact_class == "NO_CONTACT" or hit_quality == "MISS" or applied_injury <= 0:
		classification_reason = "NO_RESOLVED_IMPACT_CONTACT"
	elif block_outcome == "BLOCK_STRONG":
		contact_mode = "GUARD_ABSORBED_TAIL_SWEEP_IMPACT"
		classification_reason = "STRONG_BLOCK_PREVENTS_FIRST_SLICE_OFF_BALANCE_REQUEST"
	elif hit_quality == "SOLID":
		contact_mode = "TAIL_SWEEP_SOLID_IMPACT_PROVISIONAL"
		classification_reason = "SOLID_IMPACT_WITH_RESOLVED_INJURY_AND_NO_STRONG_BLOCK"
		requests.append(_build_tail_off_balance_request(resolution_id, block_outcome, applied_injury))
	elif hit_quality == "CLEAN":
		contact_mode = "TAIL_SWEEP_CLEAN_IMPACT_STAGGERED_PROVISIONAL"
		classification_reason = "CLEAN_IMPACT_WITH_RESOLVED_INJURY_AND_NO_STRONG_BLOCK"
		requests.append(_build_tail_staggered_request(resolution_id, block_outcome, applied_injury))
	elif hit_quality == "GRAZE":
		classification_reason = "GRAZE_DOES_NOT_MEET_TAIL_SWEEP_STATUS_REQUEST_THRESHOLD"

	var application_round := int(damage_handoff.get("round_id", 0))
	var application_results := _dispatch_requests(requests, application_round)
	var application_dispatch_status := _dispatch_status(requests, application_results, application_round)
	var result := {
		"success": true,
		"status": "MUDCREST_TAIL_SWEEP_WOUND_CONTACT_CLASSIFIED",
		"schema": SCHEMA,
		"resolution_id": resolution_id,
		"classification_id": "%s:TAIL_SWEEP_WOUND_CONTACT" % resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"attacker_id": MONSTER_COMBATANT_ID,
		"defender_id": HUNTER_COMBATANT_ID,
		"attack_id": TAIL_SWEEP_ATTACK_ID,
		"attack_profile": TAIL_SWEEP_PROFILE,
		"damage_channels": ["IMPACT"],
		"contact_class": contact_class,
		"hit_quality": hit_quality,
		"block_outcome": block_outcome,
		"defense_outcome": defense_outcome,
		"applied_injury_load": applied_injury,
		"contact_mode": contact_mode,
		"classification_reason": classification_reason,
		"status_application_requests": requests.duplicate(true),
		"status_request_count": requests.size(),
		"status_application_results": application_results.duplicate(true),
		"status_application_dispatch_status": application_dispatch_status,
		"fixture_status": TAIL_SWEEP_FIXTURE_STATUS,
		"final_classification_balance_status": "PROVISIONAL_TAIL_SWEEP_CONTACT_CLASSIFICATION",
	}
	_store_resolution(resolution_id, result, "MUDCREST_TAIL_SWEEP_WOUND_CONTACT_CLASSIFIED")
	return result.duplicate(true)

func _dispatch_requests(requests: Array[Dictionary], application_round: int) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	if requests.is_empty() or application_round <= 0:
		return results
	for request in requests:
		results.append(_status_application.call("consume_application_request", request, application_round) as Dictionary)
	return results

func _dispatch_status(requests: Array[Dictionary], results: Array[Dictionary], application_round: int) -> String:
	if requests.is_empty():
		return "NO_APPLICATION_REQUESTS"
	if application_round <= 0:
		return "NOT_DISPATCHED_MISSING_AUTHORITATIVE_ROUND"
	for result in results:
		if not bool(result.get("success", false)):
			return "GENERIC_STATUS_APPLICATION_REJECTED"
	return "DISPATCHED_TO_GENERIC_STATUS_APPLICATION_RUNTIME"

func _store_resolution(resolution_id: String, result: Dictionary, event_name: String) -> void:
	_resolutions[resolution_id] = result.duplicate(true)
	_last_resolution = result.duplicate(true)
	_record_trace(event_name, result)

func _validate_input(damage_handoff: Dictionary, defense_consequence: Dictionary) -> Dictionary:
	if String(damage_handoff.get("status", "")) != "PENDING_HUNTER_DAMAGE_RUNTIME": return {"valid": false, "reason": "UNEXPECTED_DAMAGE_HANDOFF_STATUS"}
	if String(damage_handoff.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID: return {"valid": false, "reason": "UNEXPECTED_ENCOUNTER_ID"}
	if String(damage_handoff.get("attacker_id", "")) != MONSTER_COMBATANT_ID or String(damage_handoff.get("defender_id", "")) != HUNTER_COMBATANT_ID: return {"valid": false, "reason": "UNEXPECTED_COMBATANT_ID"}
	if String(damage_handoff.get("attack_id", "")) != HEAD_SWEEP_ATTACK_ID: return {"valid": false, "reason": "UNSUPPORTED_ATTACK_ID"}
	if not bool(defense_consequence.get("success", false)): return {"valid": false, "reason": "DEFENSE_CONSEQUENCE_NOT_RESOLVED"}
	var health: Dictionary = defense_consequence.get("health_injury_consequence", {}) as Dictionary
	if not bool(health.get("success", false)): return {"valid": false, "reason": "HEALTH_INJURY_CONSEQUENCE_NOT_RESOLVED"}
	if String(health.get("resolution_id", "")) != String(damage_handoff.get("resolution_id", "")): return {"valid": false, "reason": "RESOLUTION_ID_MISMATCH"}
	return {"valid": true, "reason": "VALID_HEAD_SWEEP_WOUND_CONTACT_INPUT"}

func _validate_tail_input(damage_handoff: Dictionary, defense_consequence: Dictionary) -> Dictionary:
	if String(damage_handoff.get("status", "")) != "PENDING_HUNTER_DAMAGE_RUNTIME": return {"valid": false, "reason": "UNEXPECTED_DAMAGE_HANDOFF_STATUS"}
	if String(damage_handoff.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID: return {"valid": false, "reason": "UNEXPECTED_ENCOUNTER_ID"}
	if String(damage_handoff.get("attacker_id", "")) != MONSTER_COMBATANT_ID or String(damage_handoff.get("defender_id", "")) != HUNTER_COMBATANT_ID: return {"valid": false, "reason": "UNEXPECTED_COMBATANT_ID"}
	if String(damage_handoff.get("attack_id", "")) != TAIL_SWEEP_ATTACK_ID: return {"valid": false, "reason": "UNSUPPORTED_ATTACK_ID"}
	if String(damage_handoff.get("attack_profile", "")) != TAIL_SWEEP_PROFILE: return {"valid": false, "reason": "TAIL_SWEEP_PROFILE_MISMATCH"}
	var channels: Array = damage_handoff.get("damage_channels", []) as Array
	if channels.size() != 1 or String(channels[0]) != "IMPACT": return {"valid": false, "reason": "TAIL_SWEEP_DAMAGE_CHANNEL_MISMATCH"}
	if not bool(defense_consequence.get("success", false)): return {"valid": false, "reason": "DEFENSE_CONSEQUENCE_NOT_RESOLVED"}
	var health: Dictionary = defense_consequence.get("health_injury_consequence", {}) as Dictionary
	if not bool(health.get("success", false)): return {"valid": false, "reason": "HEALTH_INJURY_CONSEQUENCE_NOT_RESOLVED"}
	if String(health.get("resolution_id", "")) != String(damage_handoff.get("resolution_id", "")): return {"valid": false, "reason": "RESOLUTION_ID_MISMATCH"}
	return {"valid": true, "reason": "VALID_TAIL_SWEEP_WOUND_CONTACT_INPUT"}

func _build_bleeding_request(resolution_id: String, hit_quality: String, applied_injury: int) -> Dictionary:
	return {"status": "VALID_STATUS_APPLICATION_REQUEST", "request_schema": REQUEST_SCHEMA, "application_request_id": "%s:STATUS:%s" % [resolution_id, STATUS_BLEEDING], "status_id": STATUS_BLEEDING, "target_actor_id": HUNTER_COMBATANT_ID, "source_actor_id": MONSTER_COMBATANT_ID, "source_action_id": HEAD_SWEEP_ATTACK_ID, "source_resolution_id": resolution_id, "trigger_hook": TRIGGER_HOOK, "application_mode": "STACK_INTENSITY_CAPPED", "intensity_delta": 1, "qualification": "HEAD_SWEEP_HORN_PENETRATION_WOUND_ESTABLISHED", "hit_quality": hit_quality, "applied_injury_load": applied_injury, "consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME"}

func _build_off_balance_request(resolution_id: String, block_outcome: String, applied_injury: int) -> Dictionary:
	return {"status": "VALID_STATUS_APPLICATION_REQUEST", "request_schema": REQUEST_SCHEMA, "application_request_id": "%s:STATUS:%s" % [resolution_id, STATUS_OFF_BALANCE], "status_id": STATUS_OFF_BALANCE, "target_actor_id": HUNTER_COMBATANT_ID, "source_actor_id": MONSTER_COMBATANT_ID, "source_action_id": HEAD_SWEEP_ATTACK_ID, "source_resolution_id": resolution_id, "trigger_hook": TRIGGER_HOOK, "application_mode": "APPLY_OR_REFRESH", "qualification": "HEAD_SWEEP_CLEAN_IMPACT_DOMINANT_CONTACT_ESTABLISHED", "block_outcome": block_outcome, "applied_injury_load": applied_injury, "consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME"}

func _build_tail_off_balance_request(resolution_id: String, block_outcome: String, applied_injury: int) -> Dictionary:
	return {
		"status": "VALID_STATUS_APPLICATION_REQUEST",
		"request_schema": REQUEST_SCHEMA,
		"application_request_id": "%s:STATUS:%s" % [resolution_id, STATUS_OFF_BALANCE],
		"status_id": STATUS_OFF_BALANCE,
		"target_actor_id": HUNTER_COMBATANT_ID,
		"source_actor_id": MONSTER_COMBATANT_ID,
		"source_action_id": TAIL_SWEEP_ATTACK_ID,
		"source_resolution_id": resolution_id,
		"trigger_hook": TRIGGER_HOOK,
		"application_mode": "APPLY_OR_REFRESH",
		"qualification": "TAIL_SWEEP_SOLID_IMPACT_WITH_RESOLVED_INJURY",
		"block_outcome": block_outcome,
		"applied_injury_load": applied_injury,
		"consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME",
	}

func _build_tail_staggered_request(resolution_id: String, block_outcome: String, applied_injury: int) -> Dictionary:
	return {
		"status": "VALID_STATUS_APPLICATION_REQUEST",
		"request_schema": REQUEST_SCHEMA,
		"application_request_id": "%s:STATUS:%s" % [resolution_id, STATUS_STAGGERED],
		"status_id": STATUS_STAGGERED,
		"target_actor_id": HUNTER_COMBATANT_ID,
		"source_actor_id": MONSTER_COMBATANT_ID,
		"source_action_id": TAIL_SWEEP_ATTACK_ID,
		"source_resolution_id": resolution_id,
		"trigger_hook": TRIGGER_HOOK,
		"application_mode": "APPLY_OR_REFRESH",
		"intensity_delta": 0,
		"qualification": "TAIL_SWEEP_CLEAN_IMPACT_WITH_RESOLVED_INJURY",
		"block_outcome": block_outcome,
		"applied_injury_load": applied_injury,
		"consumer_status": "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME",
	}

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {"sequence": _trace_sequence, "event": event_name, "encounter_id": EXPECTED_ENCOUNTER_ID, "monster_id": MONSTER_COMBATANT_ID}
	for key in details.keys(): entry[key] = details[key]
	_trace.append(entry)

func get_schema() -> String: return SCHEMA
func is_initialized() -> bool: return _initialized
func get_fixture_status() -> String: return FIXTURE_STATUS
func get_tail_sweep_fixture_status() -> String: return TAIL_SWEEP_FIXTURE_STATUS
func get_status_application_runtime() -> Node: return _status_application
func get_status_timing_runtime() -> Node: return _status_timing
func get_last_resolution() -> Dictionary: return _last_resolution.duplicate(true)
func get_resolution(resolution_id: String) -> Dictionary:
	if not _resolutions.has(resolution_id): return {}
	return (_resolutions[resolution_id] as Dictionary).duplicate(true)
func get_applied_resolution_count() -> int: return _resolutions.size()
func get_trace() -> Array[Dictionary]: return _trace.duplicate(true)
