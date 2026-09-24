extends Node

const SCHEMA := "uhr.hunt01.hunter_defense_consequence.v1"
const HUNTER_HEALTH_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_hunter_health_injury_runtime.gd")
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"
const REACTION_POLEBLADE_BLOCK := "POLEBLADE_BLOCK"
const GUARD_ROUTE := "FIELD_POLEBLADE_DIRECTIONAL_GUARD"
const BODY_ROUTE := "HUNTER_BODY_PROTECTION_PENDING_RUNTIME"
const IMPACT_TRANSACTION_ID := "POLEBLADE_BLOCK_IMPACT_DRAIN"
const BLOCK_FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_POLEBLADE_BLOCK_OUTCOME_FIXTURE"

var _shell: Node = null
var _hunter_health: Node = null
var _encounter_record: Dictionary = {}
var _initialized := false
var _resolutions: Dictionary = {}
var _last_resolution: Dictionary = {}
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

	var health := HUNTER_HEALTH_SCRIPT.new() as Node
	if health == null:
		return false
	health.name = "HunterHealthInjuryRuntime"
	add_child(health)
	if not bool(health.call("initialize", _encounter_record)):
		health.queue_free()
		return false
	_hunter_health = health

	_initialized = true
	_record_trace("HUNTER_DEFENSE_RUNTIME_READY", {
		"fixture_status": BLOCK_FIXTURE_STATUS,
		"hunter_health_schema": String(_hunter_health.call("get_schema")),
	})
	return true

func resolve_hostile_handoff(handoff: Dictionary) -> Dictionary:
	if not _initialized or _hunter_health == null:
		return {"success": false, "reason": "DEFENSE_RUNTIME_NOT_INITIALIZED"}
	var resolution_id := String(handoff.get("resolution_id", ""))
	if resolution_id.is_empty():
		return {"success": false, "reason": "MISSING_RESOLUTION_ID"}
	if _resolutions.has(resolution_id):
		return (_resolutions[resolution_id] as Dictionary).duplicate(true)
	var validation := _validate_handoff(handoff)
	if not bool(validation.get("valid", false)):
		return {
			"success": false,
			"reason": String(validation.get("reason", "INVALID_HOSTILE_HANDOFF")),
			"resolution_id": resolution_id,
		}

	var contact_class := String(handoff.get("contact_class", ""))
	var hit_quality := String(handoff.get("hit_quality", ""))
	var protection_route := String(handoff.get("protection_route", ""))
	var reaction_id := String(handoff.get("reaction_id", ""))
	var result: Dictionary = {}

	if contact_class == "NO_CONTACT" or hit_quality == "MISS":
		result = _build_no_contact_result(handoff)
	elif protection_route == GUARD_ROUTE:
		if reaction_id != REACTION_POLEBLADE_BLOCK:
			return {"success": false, "reason": "GUARD_ROUTE_WITHOUT_POLEBLADE_BLOCK", "resolution_id": resolution_id}
		result = _resolve_poleblade_block(handoff)
	elif protection_route == BODY_ROUTE:
		result = _build_no_guard_contact_result(handoff)
	else:
		return {"success": false, "reason": "UNSUPPORTED_PROTECTION_ROUTE", "resolution_id": resolution_id, "protection_route": protection_route}

	if not bool(result.get("success", false)):
		return result
	var health_handoff: Dictionary = result.get("health_handoff", {}) as Dictionary
	var health_result: Dictionary = _hunter_health.call("resolve_health_handoff", health_handoff)
	if not bool(health_result.get("success", false)):
		return {
			"success": false,
			"reason": "HUNTER_HEALTH_INJURY_TRANSACTION_REJECTED",
			"resolution_id": resolution_id,
			"health_result": health_result.duplicate(true),
		}
	result["health_injury_consequence"] = health_result.duplicate(true)
	result["hunter_health_schema"] = String(_hunter_health.call("get_schema"))
	_resolutions[resolution_id] = result.duplicate(true)
	_last_resolution = result.duplicate(true)
	return result.duplicate(true)

func _validate_handoff(handoff: Dictionary) -> Dictionary:
	if String(handoff.get("status", "")) != "PENDING_HUNTER_DAMAGE_RUNTIME":
		return {"valid": false, "reason": "UNEXPECTED_HANDOFF_STATUS"}
	if String(handoff.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return {"valid": false, "reason": "UNEXPECTED_ENCOUNTER_ID"}
	if String(handoff.get("attacker_id", "")) != MONSTER_COMBATANT_ID:
		return {"valid": false, "reason": "UNEXPECTED_ATTACKER_ID"}
	if String(handoff.get("defender_id", "")) != HUNTER_COMBATANT_ID:
		return {"valid": false, "reason": "UNEXPECTED_DEFENDER_ID"}
	var contact_class := String(handoff.get("contact_class", ""))
	if contact_class != "NO_CONTACT" and contact_class != "HUNTER_BODY_CONTACT":
		return {"valid": false, "reason": "UNSUPPORTED_CONTACT_CLASS"}
	return {"valid": true, "reason": "VALID_HOSTILE_HANDOFF"}

func _resolve_poleblade_block(handoff: Dictionary) -> Dictionary:
	var resolution_id := String(handoff.get("resolution_id", ""))
	var requested_drain := maxi(0, int(handoff.get("standard_block_impact_drain_stamina", 0)))
	var hunter_resources: Dictionary = _shell.call("get_resource_state", HUNTER_COMBATANT_ID)
	if hunter_resources.is_empty():
		return {"success": false, "reason": "HUNTER_RESOURCE_STATE_MISSING", "resolution_id": resolution_id}
	var stamina_before := int(hunter_resources.get("stamina", 0))
	var applied_drain := mini(stamina_before, requested_drain)
	var impact_window_id := "GUARD_IMPACT:%s" % resolution_id
	var shell_commit: Dictionary = _shell.call(
		"try_commit_reaction_cost",
		HUNTER_COMBATANT_ID,
		MONSTER_COMBATANT_ID,
		IMPACT_TRANSACTION_ID,
		impact_window_id,
		0,
		applied_drain
	)
	if not bool(shell_commit.get("success", false)):
		return {
			"success": false,
			"reason": "GUARD_IMPACT_STAMINA_TRANSACTION_REJECTED",
			"resolution_id": resolution_id,
			"shell_result": shell_commit.duplicate(true),
		}
	var stamina_after := int((_shell.call("get_resource_state", HUNTER_COMBATANT_ID) as Dictionary).get("stamina", 0))
	var fully_paid := applied_drain == requested_drain
	var hit_quality := String(handoff.get("hit_quality", ""))
	var block_outcome := _classify_block_outcome(hit_quality, fully_paid)
	var health_handoff := _build_health_handoff(handoff, block_outcome, "GUARD_INTERPOSED")
	var result := {
		"success": true,
		"status": "HUNTER_DEFENSE_CONSEQUENCE_RESOLVED_HEALTH_PENDING",
		"schema": SCHEMA,
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"attack_id": String(handoff.get("attack_id", "")),
		"reaction_id": REACTION_POLEBLADE_BLOCK,
		"contact_class": String(handoff.get("contact_class", "")),
		"hit_quality": hit_quality,
		"protection_route": GUARD_ROUTE,
		"defense_outcome": "FIELD_POLEBLADE_BLOCK",
		"block_outcome": block_outcome,
		"block_fixture_status": BLOCK_FIXTURE_STATUS,
		"guard_impact_requested_stamina": requested_drain,
		"guard_impact_applied_stamina": applied_drain,
		"guard_impact_fully_paid": fully_paid,
		"hunter_stamina_before_impact": stamina_before,
		"hunter_stamina_after_impact": stamina_after,
		"impact_transaction_id": IMPACT_TRANSACTION_ID,
		"impact_transaction_window_id": impact_window_id,
		"impact_shell_commit": shell_commit.duplicate(true),
		"health_handoff": health_handoff.duplicate(true),
		"final_health_damage_status": "NOT_SELECTED_PENDING_HUNTER_HEALTH_INJURY_RUNTIME",
	}
	_record_trace("HUNTER_DEFENSE_BLOCK_RESOLVED", result)
	return result

func _build_no_contact_result(handoff: Dictionary) -> Dictionary:
	var resolution_id := String(handoff.get("resolution_id", ""))
	var health_handoff := {
		"status": "NO_HUNTER_HEALTH_INJURY_CONSEQUENCE",
		"resolution_id": resolution_id,
		"defender_id": HUNTER_COMBATANT_ID,
		"reason": "NO_CONTACT",
	}
	var result := {
		"success": true,
		"status": "HUNTER_DEFENSE_NO_CONTACT_RESOLVED",
		"schema": SCHEMA,
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"attack_id": String(handoff.get("attack_id", "")),
		"reaction_id": String(handoff.get("reaction_id", "")),
		"contact_class": "NO_CONTACT",
		"hit_quality": "MISS",
		"protection_route": String(handoff.get("protection_route", "NONE_NO_CONTACT")),
		"defense_outcome": "NO_CONTACT",
		"block_outcome": "NOT_APPLICABLE",
		"block_fixture_status": BLOCK_FIXTURE_STATUS,
		"guard_impact_requested_stamina": 0,
		"guard_impact_applied_stamina": 0,
		"guard_impact_fully_paid": true,
		"health_handoff": health_handoff.duplicate(true),
		"final_health_damage_status": "NO_CONTACT_NO_HEALTH_DAMAGE",
	}
	_record_trace("HUNTER_DEFENSE_NO_CONTACT_RESOLVED", result)
	return result

func _build_no_guard_contact_result(handoff: Dictionary) -> Dictionary:
	var resolution_id := String(handoff.get("resolution_id", ""))
	var health_handoff := _build_health_handoff(handoff, "NO_ACTIVE_GUARD", "HUNTER_BODY_CONTACT")
	var result := {
		"success": true,
		"status": "HUNTER_DEFENSE_CONSEQUENCE_RESOLVED_HEALTH_PENDING",
		"schema": SCHEMA,
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"attack_id": String(handoff.get("attack_id", "")),
		"reaction_id": String(handoff.get("reaction_id", "")),
		"contact_class": String(handoff.get("contact_class", "")),
		"hit_quality": String(handoff.get("hit_quality", "")),
		"protection_route": BODY_ROUTE,
		"defense_outcome": "NO_ACTIVE_GUARD",
		"block_outcome": "NOT_APPLICABLE",
		"block_fixture_status": BLOCK_FIXTURE_STATUS,
		"guard_impact_requested_stamina": 0,
		"guard_impact_applied_stamina": 0,
		"guard_impact_fully_paid": true,
		"health_handoff": health_handoff.duplicate(true),
		"final_health_damage_status": "NOT_SELECTED_PENDING_HUNTER_HEALTH_INJURY_RUNTIME",
	}
	_record_trace("HUNTER_DEFENSE_NO_GUARD_CONTACT_RESOLVED", result)
	return result

func _build_health_handoff(handoff: Dictionary, defense_outcome: String, residual_force_status: String) -> Dictionary:
	return {
		"status": "PENDING_HUNTER_HEALTH_INJURY_RUNTIME",
		"resolution_id": String(handoff.get("resolution_id", "")),
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"attacker_id": MONSTER_COMBATANT_ID,
		"defender_id": HUNTER_COMBATANT_ID,
		"attack_id": String(handoff.get("attack_id", "")),
		"attack_profile": String(handoff.get("attack_profile", "")),
		"damage_channels": (handoff.get("damage_channels", []) as Array).duplicate(true),
		"contact_class": String(handoff.get("contact_class", "")),
		"hit_quality": String(handoff.get("hit_quality", "")),
		"defense_outcome": defense_outcome,
		"residual_force_status": residual_force_status,
		"final_damage_amount_status": "NOT_SELECTED",
	}

func _classify_block_outcome(hit_quality: String, impact_fully_paid: bool) -> String:
	# Explicitly reversible first-slice fixture. Final Guard Stability/Might/
	# equipment formulas remain balance-open in the owning design contracts.
	if not impact_fully_paid:
		return "BLOCK_BROKEN"
	if hit_quality == "CLEAN":
		return "BLOCK_PARTIAL"
	if hit_quality == "GRAZE" or hit_quality == "SOLID":
		return "BLOCK_STRONG"
	return "BLOCK_BROKEN"

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

func get_fixture_status() -> String:
	return BLOCK_FIXTURE_STATUS

func get_hunter_health_runtime() -> Node:
	return _hunter_health

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
