extends Node

const SCHEMA := "uhr.hunt01.hunter_health_injury.v1"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"
const HEAD_SWEEP_ATTACK_ID := "M01_HEAD_SWEEP_GORE"
const TAIL_SWEEP_ATTACK_ID := "M01_TAIL_SWEEP"

const NORMALIZED_MAX_HEALTH := 100
const HEALTH_FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_HUNTER_HEALTH_INJURY_FIXTURE"
const PROTECTION_FIXTURE_STATUS := "PROVISIONAL_NO_AUTHORED_HUNTER_GAMEPLAY_ARMOR_PROFILE_RESIDUAL_FORCE_BASELINE"

const GRAZE_BASE_LOAD := 4
const SOLID_BASE_LOAD := 8
const CLEAN_BASE_LOAD := 12
const BLOCK_STRONG_RESIDUAL_PERCENT := 25
const BLOCK_PARTIAL_RESIDUAL_PERCENT := 60
const BLOCK_BROKEN_RESIDUAL_PERCENT := 90
const NO_ACTIVE_GUARD_RESIDUAL_PERCENT := 100

var _encounter_record: Dictionary = {}
var _initialized := false
var _current_health := NORMALIZED_MAX_HEALTH
var _resolutions: Dictionary = {}
var _last_resolution: Dictionary = {}
var _trace_sequence := 0
var _trace: Array[Dictionary] = []

func initialize(encounter_record: Dictionary) -> bool:
	if _initialized:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	_encounter_record = encounter_record.duplicate(true)
	_current_health = NORMALIZED_MAX_HEALTH
	_initialized = true
	_record_trace("HUNTER_HEALTH_RUNTIME_READY", {
		"max_health": NORMALIZED_MAX_HEALTH,
		"fixture_status": HEALTH_FIXTURE_STATUS,
		"protection_fixture_status": PROTECTION_FIXTURE_STATUS,
		"supported_attack_ids": [HEAD_SWEEP_ATTACK_ID, TAIL_SWEEP_ATTACK_ID],
	})
	return true

func resolve_health_handoff(handoff: Dictionary) -> Dictionary:
	if not _initialized:
		return {"success": false, "reason": "HEALTH_RUNTIME_NOT_INITIALIZED"}
	var resolution_id := String(handoff.get("resolution_id", ""))
	if resolution_id.is_empty():
		return {"success": false, "reason": "MISSING_RESOLUTION_ID"}
	if _resolutions.has(resolution_id):
		return (_resolutions[resolution_id] as Dictionary).duplicate(true)

	var status := String(handoff.get("status", ""))
	var result: Dictionary
	if status == "NO_HUNTER_HEALTH_INJURY_CONSEQUENCE":
		result = _resolve_no_injury(handoff)
	elif status == "PENDING_HUNTER_HEALTH_INJURY_RUNTIME":
		var validation := _validate_pending_handoff(handoff)
		if not bool(validation.get("valid", false)):
			return {
				"success": false,
				"reason": String(validation.get("reason", "INVALID_HEALTH_HANDOFF")),
				"resolution_id": resolution_id,
			}
		result = _resolve_pending_injury(handoff)
	else:
		return {"success": false, "reason": "UNEXPECTED_HEALTH_HANDOFF_STATUS", "resolution_id": resolution_id}

	if not bool(result.get("success", false)):
		return result
	_resolutions[resolution_id] = result.duplicate(true)
	_last_resolution = result.duplicate(true)
	return result.duplicate(true)

func _validate_pending_handoff(handoff: Dictionary) -> Dictionary:
	if String(handoff.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return {"valid": false, "reason": "UNEXPECTED_ENCOUNTER_ID"}
	if String(handoff.get("attacker_id", "")) != MONSTER_COMBATANT_ID:
		return {"valid": false, "reason": "UNEXPECTED_ATTACKER_ID"}
	if String(handoff.get("defender_id", "")) != HUNTER_COMBATANT_ID:
		return {"valid": false, "reason": "UNEXPECTED_DEFENDER_ID"}
	var attack_id := String(handoff.get("attack_id", ""))
	if attack_id != HEAD_SWEEP_ATTACK_ID and attack_id != TAIL_SWEEP_ATTACK_ID:
		return {"valid": false, "reason": "UNSUPPORTED_ATTACK_ID"}
	var hit_quality := String(handoff.get("hit_quality", ""))
	if hit_quality != "GRAZE" and hit_quality != "SOLID" and hit_quality != "CLEAN":
		return {"valid": false, "reason": "UNSUPPORTED_HIT_QUALITY"}
	var defense_outcome := String(handoff.get("defense_outcome", ""))
	if defense_outcome not in ["BLOCK_STRONG", "BLOCK_PARTIAL", "BLOCK_BROKEN", "NO_ACTIVE_GUARD"]:
		return {"valid": false, "reason": "UNSUPPORTED_DEFENSE_OUTCOME"}
	return {"valid": true, "reason": "VALID_HUNTER_HEALTH_HANDOFF"}

func _resolve_no_injury(handoff: Dictionary) -> Dictionary:
	if String(handoff.get("defender_id", "")) != HUNTER_COMBATANT_ID:
		return {"success": false, "reason": "UNEXPECTED_DEFENDER_ID", "resolution_id": String(handoff.get("resolution_id", ""))}
	var result := {
		"success": true,
		"status": "HUNTER_HEALTH_NO_INJURY_RESOLVED",
		"schema": SCHEMA,
		"resolution_id": String(handoff.get("resolution_id", "")),
		"defender_id": HUNTER_COMBATANT_ID,
		"health_before": _current_health,
		"health_after": _current_health,
		"applied_injury_load": 0,
		"injury_load_band": "NONE",
		"health_fixture_status": HEALTH_FIXTURE_STATUS,
		"protection_fixture_status": PROTECTION_FIXTURE_STATUS,
		"status_requests": [],
		"status_request_candidates": [],
		"defeat_handoff": {"status": "NOT_APPLICABLE_HEALTH_ABOVE_ZERO"},
	}
	_record_trace("HUNTER_HEALTH_NO_INJURY_RESOLVED", result)
	return result

func _resolve_pending_injury(handoff: Dictionary) -> Dictionary:
	var hit_quality := String(handoff.get("hit_quality", ""))
	var defense_outcome := String(handoff.get("defense_outcome", ""))
	var base_load := _base_load_for_quality(hit_quality)
	var residual_percent := _residual_percent_for_defense(defense_outcome)
	var requested_load := ceili(float(base_load * residual_percent) / 100.0)
	var health_before := _current_health
	var applied_load := mini(health_before, requested_load)
	_current_health = maxi(0, health_before - applied_load)
	var damage_channels: Array = (handoff.get("damage_channels", []) as Array).duplicate(true)
	var status_candidates := _build_status_candidates(hit_quality, damage_channels)
	var defeat_handoff := _build_defeat_handoff(String(handoff.get("resolution_id", "")))
	var result := {
		"success": true,
		"status": "HUNTER_HEALTH_INJURY_RESOLVED",
		"schema": SCHEMA,
		"resolution_id": String(handoff.get("resolution_id", "")),
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"attacker_id": MONSTER_COMBATANT_ID,
		"defender_id": HUNTER_COMBATANT_ID,
		"attack_id": String(handoff.get("attack_id", "")),
		"attack_profile": String(handoff.get("attack_profile", "")),
		"damage_channels": damage_channels,
		"contact_class": String(handoff.get("contact_class", "")),
		"hit_quality": hit_quality,
		"defense_outcome": defense_outcome,
		"residual_force_status": String(handoff.get("residual_force_status", "")),
		"base_injury_load": base_load,
		"defense_residual_percent": residual_percent,
		"requested_injury_load": requested_load,
		"applied_injury_load": applied_load,
		"health_before": health_before,
		"health_after": _current_health,
		"max_health": NORMALIZED_MAX_HEALTH,
		"injury_load_band": _injury_band(applied_load),
		"health_fixture_status": HEALTH_FIXTURE_STATUS,
		"protection_fixture_status": PROTECTION_FIXTURE_STATUS,
		"status_requests": [],
		"status_request_candidates": status_candidates,
		"status_request_boundary": "DEFERRED_PENDING_DOMINANT_CHANNEL_AND_WOUND_CLASSIFICATION",
		"defeat_handoff": defeat_handoff,
		"final_balance_status": "PROVISIONAL_NOT_FINAL_HEALTH_DAMAGE_OR_ARMOR_BALANCE",
	}
	_record_trace("HUNTER_HEALTH_INJURY_RESOLVED", result)
	if _current_health == 0:
		_record_trace("HUNTER_HEALTH_ZERO_REACHED", {
			"resolution_id": String(handoff.get("resolution_id", "")),
			"defeat_handoff": defeat_handoff.duplicate(true),
		})
	return result

func _base_load_for_quality(hit_quality: String) -> int:
	if hit_quality == "GRAZE":
		return GRAZE_BASE_LOAD
	if hit_quality == "SOLID":
		return SOLID_BASE_LOAD
	if hit_quality == "CLEAN":
		return CLEAN_BASE_LOAD
	return 0

func _residual_percent_for_defense(defense_outcome: String) -> int:
	if defense_outcome == "BLOCK_STRONG":
		return BLOCK_STRONG_RESIDUAL_PERCENT
	if defense_outcome == "BLOCK_PARTIAL":
		return BLOCK_PARTIAL_RESIDUAL_PERCENT
	if defense_outcome == "BLOCK_BROKEN":
		return BLOCK_BROKEN_RESIDUAL_PERCENT
	if defense_outcome == "NO_ACTIVE_GUARD":
		return NO_ACTIVE_GUARD_RESIDUAL_PERCENT
	return 100

func _injury_band(applied_load: int) -> String:
	if applied_load <= 0:
		return "NONE"
	if applied_load <= 4:
		return "LIGHT_PROVISIONAL"
	if applied_load <= 8:
		return "MODERATE_PROVISIONAL"
	return "HEAVY_PROVISIONAL"

func _build_status_candidates(hit_quality: String, damage_channels: Array) -> Array[Dictionary]:
	var candidates: Array[Dictionary] = []
	if damage_channels.has("PIERCING") and (hit_quality == "SOLID" or hit_quality == "CLEAN"):
		candidates.append({
			"status_id": "status_bleeding",
			"candidate_status": "BLOCKED_PENDING_HORN_PENETRATION_WOUND_CLASSIFICATION",
		})
	if damage_channels.has("IMPACT") and hit_quality == "CLEAN":
		candidates.append({
			"status_id": "status_off_balance",
			"candidate_status": "BLOCKED_PENDING_IMPACT_DOMINANCE_CLASSIFICATION",
		})
	return candidates

func _build_defeat_handoff(resolution_id: String) -> Dictionary:
	if _current_health > 0:
		return {"status": "NOT_APPLICABLE_HEALTH_ABOVE_ZERO"}
	return {
		"status": "PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME",
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"actor_id": HUNTER_COMBATANT_ID,
		"health": 0,
	}

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {
		"sequence": _trace_sequence,
		"event": event_name,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"hunter_id": HUNTER_COMBATANT_ID,
	}
	for key in details.keys():
		entry[key] = details[key]
	_trace.append(entry)

func get_schema() -> String:
	return SCHEMA

func is_initialized() -> bool:
	return _initialized

func get_fixture_status() -> String:
	return HEALTH_FIXTURE_STATUS

func get_protection_fixture_status() -> String:
	return PROTECTION_FIXTURE_STATUS

func get_health_state() -> Dictionary:
	return {
		"actor_id": HUNTER_COMBATANT_ID,
		"health": _current_health,
		"max_health": NORMALIZED_MAX_HEALTH,
		"fixture_status": HEALTH_FIXTURE_STATUS,
		"protection_fixture_status": PROTECTION_FIXTURE_STATUS,
	}

func get_last_resolution() -> Dictionary:
	return _last_resolution.duplicate(true)

func get_resolution(resolution_id: String) -> Dictionary:
	if not _resolutions.has(resolution_id):
		return {}
	return (_resolutions[resolution_id] as Dictionary).duplicate(true)

func get_applied_resolution_count() -> int:
	return _resolutions.size()

func get_trace() -> Array[Dictionary]:
	return _trace.duplicate(true)
