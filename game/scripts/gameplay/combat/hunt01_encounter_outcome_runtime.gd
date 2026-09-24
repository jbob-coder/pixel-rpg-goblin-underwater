extends Node

const SCHEMA := "uhr.hunt01.encounter_outcome.v1"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"
const OUTCOME_HUNTERS_DEFEATED := "HUNTERS_DEFEATED"
const PARTICIPATION_ACTIVE := "ACTIVE"
const PARTICIPATION_DOWNED := "DOWNED"

var _shell: Node = null
var _encounter_record: Dictionary = {}
var _initialized := false
var _participation_states: Dictionary = {}
var _resolutions: Dictionary = {}
var _last_resolution: Dictionary = {}
var _trace_sequence := 0
var _trace: Array[Dictionary] = []

func initialize(shell: Node, encounter_record: Dictionary) -> bool:
	if _initialized or shell == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not bool(shell.call("is_initialized")) or not shell.has_method("commit_terminal_outcome"):
		return false
	_shell = shell
	_encounter_record = encounter_record.duplicate(true)
	_participation_states = {
		HUNTER_COMBATANT_ID: PARTICIPATION_ACTIVE,
		MONSTER_COMBATANT_ID: PARTICIPATION_ACTIVE,
	}
	_initialized = true
	_record_trace("ENCOUNTER_OUTCOME_RUNTIME_READY", {
		"hunter_state": PARTICIPATION_ACTIVE,
		"monster_state": PARTICIPATION_ACTIVE,
	})
	return true

func resolve_hunter_defeat_handoff(handoff: Dictionary) -> Dictionary:
	if not _initialized:
		return {"success": false, "reason": "OUTCOME_RUNTIME_NOT_INITIALIZED"}
	var resolution_id := String(handoff.get("resolution_id", ""))
	if resolution_id.is_empty():
		return {"success": false, "reason": "MISSING_RESOLUTION_ID"}
	if _resolutions.has(resolution_id):
		return (_resolutions[resolution_id] as Dictionary).duplicate(true)
	var validation := _validate_hunter_defeat_handoff(handoff)
	if not bool(validation.get("valid", false)):
		return {
			"success": false,
			"reason": String(validation.get("reason", "INVALID_HUNTER_DEFEAT_HANDOFF")),
			"resolution_id": resolution_id,
		}

	var shell_terminal: Dictionary = _shell.call(
		"commit_terminal_outcome",
		OUTCOME_HUNTERS_DEFEATED,
		resolution_id,
		HUNTER_COMBATANT_ID
	)
	if not bool(shell_terminal.get("success", false)):
		return {
			"success": false,
			"reason": "SHELL_TERMINAL_COMMIT_REJECTED",
			"resolution_id": resolution_id,
			"shell_terminal": shell_terminal.duplicate(true),
		}

	_participation_states[HUNTER_COMBATANT_ID] = PARTICIPATION_DOWNED
	# The defeat contract explicitly preserves the living Monster. This owner
	# does not reset anatomy, statuses, world position, or persistent identity.
	_participation_states[MONSTER_COMBATANT_ID] = PARTICIPATION_ACTIVE
	var result := {
		"success": true,
		"status": "HUNTER_DEFEAT_OUTCOME_COMMITTED",
		"schema": SCHEMA,
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"actor_id": HUNTER_COMBATANT_ID,
		"health": 0,
		"hunter_participation_state": PARTICIPATION_DOWNED,
		"monster_id": MONSTER_COMBATANT_ID,
		"monster_participation_state": PARTICIPATION_ACTIVE,
		"outcome": OUTCOME_HUNTERS_DEFEATED,
		"encounter_terminal": true,
		"shell_terminal": shell_terminal.duplicate(true),
		"living_monster_persistence_status": "LIVING_MONSTER_INSTANCE_PRESERVED",
		"recovery_status": "PENDING_FUTURE_FORCED_RECOVERY_RUNTIME",
	}
	_resolutions[resolution_id] = result.duplicate(true)
	_last_resolution = result.duplicate(true)
	_record_trace("HUNTER_DOWNED_OUTCOME_COMMITTED", result)
	return result.duplicate(true)

func _validate_hunter_defeat_handoff(handoff: Dictionary) -> Dictionary:
	if String(handoff.get("status", "")) != "PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME":
		return {"valid": false, "reason": "UNEXPECTED_HANDOFF_STATUS"}
	if String(handoff.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return {"valid": false, "reason": "UNEXPECTED_ENCOUNTER_ID"}
	if String(handoff.get("actor_id", "")) != HUNTER_COMBATANT_ID:
		return {"valid": false, "reason": "UNEXPECTED_ACTOR_ID"}
	if int(handoff.get("health", 1)) > 0:
		return {"valid": false, "reason": "HUNTER_HEALTH_ABOVE_ZERO"}
	return {"valid": true, "reason": "VALID_HUNTER_DEFEAT_HANDOFF"}

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

func get_participation_state(actor_id: String) -> String:
	return String(_participation_states.get(actor_id, ""))

func get_last_resolution() -> Dictionary:
	return _last_resolution.duplicate(true)

func get_resolution(resolution_id: String) -> Dictionary:
	if not _resolutions.has(resolution_id):
		return {}
	return (_resolutions[resolution_id] as Dictionary).duplicate(true)

func get_resolution_count() -> int:
	return _resolutions.size()

func get_trace() -> Array[Dictionary]:
	return _trace.duplicate(true)
