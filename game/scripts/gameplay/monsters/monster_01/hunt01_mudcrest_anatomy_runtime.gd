extends Node

const SCHEMA := "uhr.hunt01.mudcrest_anatomy.v1"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const HUNTER_ID := "hunter_player_0001"
const TECHNIQUE_ID := "POLEBLADE_MEASURED_CUT"
const DAMAGE_CHANNEL := "CUTTING"
const NORMALIZED_MAX_INTEGRITY := 100
const FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_ANATOMY_INTEGRITY_FIXTURE"

const TARGET_GROUPS := [
	"HEAD",
	"HORN_CREST",
	"FORELEG_L",
	"FORELEG_R",
	"HINDLEG_L",
	"HINDLEG_R",
	"DORSAL_PLATES",
	"TAIL",
	"GENERAL_TORSO",
]

const EXPECTED_PROTECTION := {
	"HEAD": "REINFORCED_HEAD_SKULL",
	"HORN_CREST": "HARD_HORN_STRUCTURE",
	"FORELEG_L": "HIDE_LIMB_STRUCTURE",
	"FORELEG_R": "HIDE_LIMB_STRUCTURE",
	"HINDLEG_L": "HIDE_LIMB_STRUCTURE",
	"HINDLEG_R": "HIDE_LIMB_STRUCTURE",
	"DORSAL_PLATES": "MINERALIZED_DORSAL_PLATE",
	"TAIL": "MUSCULAR_TAIL_DISTAL_RIDGE",
	"GENERAL_TORSO": "HIDE_TORSO",
}

# These normalized values exist only to exercise deterministic integrity state.
# They are not final health/damage balance and must not be reused as final tuning.
const HIT_QUALITY_LOAD_FIXTURE := {
	"MISS": 0,
	"GRAZE": 4,
	"SOLID": 8,
	"CLEAN": 12,
}

# Cutting is deliberately reduced more by hard horn/plate protection than hide.
# Exact final armor/damage arithmetic remains design-open.
const CUTTING_PROTECTION_REDUCTION_FIXTURE := {
	"REINFORCED_HEAD_SKULL": 5,
	"HARD_HORN_STRUCTURE": 8,
	"HIDE_LIMB_STRUCTURE": 2,
	"MINERALIZED_DORSAL_PLATE": 7,
	"MUSCULAR_TAIL_DISTAL_RIDGE": 1,
	"HIDE_TORSO": 1,
}

var _world: Node3D = null
var _monster: Node3D = null
var _encounter_record: Dictionary = {}
var _initialized := false
var _target_state: Dictionary = {}
var _applied_results: Dictionary = {}
var _trace_sequence := 0
var _trace: Array[Dictionary] = []

func initialize(world: Node3D, encounter_record: Dictionary) -> bool:
	if _initialized or world == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if String(encounter_record.get("monster_id", "")) != MONSTER_ID:
		return false
	_world = world
	_encounter_record = encounter_record.duplicate(true)
	_monster = _world.get_node_or_null("WorldGeometry/%s" % MONSTER_ID) as Node3D
	if _monster == null:
		return false
	for target_variant in TARGET_GROUPS:
		var target := String(target_variant)
		_target_state[target] = {
			"target_group": target,
			"max_integrity": NORMALIZED_MAX_INTEGRITY,
			"integrity": NORMALIZED_MAX_INTEGRITY,
			"integrity_state": "BASELINE_INTEGRITY_FIXTURE",
			"fixture_status": FIXTURE_STATUS,
		}
	_initialized = true
	_record_trace("MUDCREST_ANATOMY_RUNTIME_READY", {
		"monster_id": MONSTER_ID,
		"target_count": TARGET_GROUPS.size(),
		"fixture_status": FIXTURE_STATUS,
	})
	return true

func apply_damage_handoff(handoff: Dictionary) -> Dictionary:
	if not _initialized:
		return _reject("NOT_INITIALIZED", handoff)
	if String(handoff.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return _reject("ENCOUNTER_ID_MISMATCH", handoff)
	if String(handoff.get("attacker_id", "")) != HUNTER_ID:
		return _reject("ATTACKER_ID_MISMATCH", handoff)
	if String(handoff.get("defender_id", "")) != MONSTER_ID:
		return _reject("DEFENDER_ID_MISMATCH", handoff)
	if String(handoff.get("technique_id", "")) != TECHNIQUE_ID:
		return _reject("TECHNIQUE_ID_MISMATCH", handoff)

	var resolution_id := String(handoff.get("resolution_id", ""))
	if resolution_id.is_empty():
		return _reject("MISSING_RESOLUTION_ID", handoff)
	var fingerprint := _handoff_fingerprint(handoff)
	if _applied_results.has(resolution_id):
		var original := (_applied_results[resolution_id] as Dictionary).duplicate(true)
		if String(original.get("source_fingerprint", "")) != fingerprint:
			return _reject("RESOLUTION_ID_COLLISION", handoff)
		var replay := original.duplicate(true)
		replay["applied"] = false
		replay["duplicate"] = true
		replay["status"] = "DUPLICATE_RESOLUTION_NO_REAPPLY"
		_record_trace("ANATOMY_HANDOFF_DUPLICATE", {
			"resolution_id": resolution_id,
			"target_group": String(original.get("target_group", "")),
		})
		return replay

	if String(handoff.get("status", "")) != "PENDING_ANATOMY_DAMAGE_RUNTIME":
		return _reject("HANDOFF_STATUS_NOT_PENDING", handoff)
	if String(handoff.get("damage_channel", "")) != DAMAGE_CHANNEL:
		return _reject("UNSUPPORTED_DAMAGE_CHANNEL", handoff)

	var hit_quality := String(handoff.get("hit_quality", ""))
	if not HIT_QUALITY_LOAD_FIXTURE.has(hit_quality):
		return _reject("UNKNOWN_HIT_QUALITY", handoff)
	var target_group := String(handoff.get("resolved_target_group", ""))
	if hit_quality == "MISS":
		if not target_group.is_empty():
			return _reject("MISS_WITH_TARGET_CONTACT", handoff)
		var no_contact := {
			"success": true,
			"applied": false,
			"duplicate": false,
			"status": "NO_CONTACT_NO_INTEGRITY_CHANGE",
			"resolution_id": resolution_id,
			"target_group": "",
			"integrity_before": -1,
			"integrity_loss": 0,
			"integrity_after": -1,
			"fixture_status": FIXTURE_STATUS,
			"structural_threshold_status": "NOT_EVALUATED_BREAK_SEVER_DEFERRED",
			"source_fingerprint": fingerprint,
		}
		_applied_results[resolution_id] = no_contact.duplicate(true)
		_record_trace("ANATOMY_NO_CONTACT_CONSUMED", no_contact)
		return no_contact.duplicate(true)

	if not TARGET_GROUPS.has(target_group):
		return _reject("UNKNOWN_TARGET_GROUP", handoff)
	var protection_profile := String(handoff.get("protection_profile", ""))
	if protection_profile != String(EXPECTED_PROTECTION.get(target_group, "")):
		return _reject("PROTECTION_PROFILE_MISMATCH", handoff)

	var state := (_target_state[target_group] as Dictionary).duplicate(true)
	var integrity_before := int(state.get("integrity", NORMALIZED_MAX_INTEGRITY))
	var base_load := int(HIT_QUALITY_LOAD_FIXTURE[hit_quality])
	var protection_reduction := int(CUTTING_PROTECTION_REDUCTION_FIXTURE.get(protection_profile, 0))
	var integrity_loss := maxi(base_load - protection_reduction, 0)
	var integrity_after := maxi(integrity_before - integrity_loss, 0)
	state["integrity"] = integrity_after
	state["integrity_state"] = "INTEGRITY_REDUCED_NO_STRUCTURAL_THRESHOLD" if integrity_after < NORMALIZED_MAX_INTEGRITY else "BASELINE_INTEGRITY_FIXTURE"
	_target_state[target_group] = state

	var result := {
		"success": true,
		"applied": integrity_loss > 0,
		"duplicate": false,
		"status": "ANATOMY_INTEGRITY_APPLIED" if integrity_loss > 0 else "CONTACT_ABSORBED_NO_INTEGRITY_LOSS",
		"resolution_id": resolution_id,
		"target_group": target_group,
		"hit_quality": hit_quality,
		"damage_channel": DAMAGE_CHANNEL,
		"protection_profile": protection_profile,
		"base_integrity_load": base_load,
		"protection_reduction": protection_reduction,
		"integrity_before": integrity_before,
		"integrity_loss": integrity_loss,
		"integrity_after": integrity_after,
		"max_integrity": NORMALIZED_MAX_INTEGRITY,
		"fixture_status": FIXTURE_STATUS,
		"structural_threshold_status": "NOT_EVALUATED_BREAK_SEVER_DEFERRED",
		"source_fingerprint": fingerprint,
	}
	_applied_results[resolution_id] = result.duplicate(true)
	_record_trace("ANATOMY_INTEGRITY_RESOLVED", result)
	return result.duplicate(true)

func _handoff_fingerprint(handoff: Dictionary) -> String:
	return "%s|%d|%d|%s|%s|%s|%s|%s|%s|%s" % [
		String(handoff.get("encounter_id", "")),
		int(handoff.get("round_id", 0)),
		int(handoff.get("action_sequence", 0)),
		String(handoff.get("attacker_id", "")),
		String(handoff.get("defender_id", "")),
		String(handoff.get("technique_id", "")),
		String(handoff.get("resolved_target_group", "")),
		String(handoff.get("hit_quality", "")),
		String(handoff.get("damage_channel", "")),
		String(handoff.get("protection_profile", "")),
	]

func _reject(reason: String, handoff: Dictionary) -> Dictionary:
	var result := {
		"success": false,
		"applied": false,
		"duplicate": false,
		"status": "ANATOMY_HANDOFF_REJECTED",
		"reason": reason,
		"resolution_id": String(handoff.get("resolution_id", "")),
		"fixture_status": FIXTURE_STATUS,
	}
	_record_trace("ANATOMY_HANDOFF_REJECTED", result)
	return result

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {
		"sequence": _trace_sequence,
		"event": event_name,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"monster_id": MONSTER_ID,
	}
	for key in details.keys():
		entry[key] = details[key]
	_trace.append(entry)

func get_schema() -> String:
	return SCHEMA

func is_initialized() -> bool:
	return _initialized

func get_target_groups() -> Array:
	return TARGET_GROUPS.duplicate()

func get_target_state(target_group: String) -> Dictionary:
	if not _target_state.has(target_group):
		return {}
	return (_target_state[target_group] as Dictionary).duplicate(true)

func get_all_target_states() -> Dictionary:
	return _target_state.duplicate(true)

func get_applied_resolution_count() -> int:
	return _applied_results.size()

func get_trace() -> Array:
	return _trace.duplicate(true)

func apply_damage_handoff_for_test(handoff: Dictionary) -> Dictionary:
	return apply_damage_handoff(handoff)
