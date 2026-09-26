class_name PixelRPGSettlement01StreamingManager
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_streaming_manager.v1"
const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const SECTION_INSTANCE := preload("res://scripts/world/settlement/settlement_section_instance.gd")

const SHARED_AREA_IDS := ["SET01_A04_MAIN_CENTRAL_SPINE"]

var _instances: Dictionary = {}
var _configured := false
var _current_section_id := ""
var _probable_next_section_id := ""
var _protected_section_ids: Array[String] = []
var _pending_unload_ids: Array[String] = []

func get_schema() -> String:
	return SCHEMA

func configure() -> Dictionary:
	var validation: Dictionary = LAYOUT.validate_contract()
	if not bool(validation.get("success", false)):
		_reset()
		return {
			"success": false,
			"errors": ["G00 layout contract is invalid"],
		}

	_reset()
	var sections: Dictionary = LAYOUT.get_section_specs()
	var ids := sections.keys()
	ids.sort()
	for id_variant in ids:
		var section_id := String(id_variant)
		var instance = SECTION_INSTANCE.new()
		var result: Dictionary = instance.configure(sections[section_id] as Dictionary)
		if not bool(result.get("success", false)):
			_reset()
			return {
				"success": false,
				"errors": ["failed to configure section instance %s" % section_id],
			}
		_instances[section_id] = instance

	_configured = true
	return {
		"success": true,
		"errors": [],
		"section_count": _instances.size(),
		"shared_area_ids": get_always_loaded_area_ids(),
	}

func is_configured() -> bool:
	return _configured

func get_section_ids() -> Array[String]:
	var result: Array[String] = []
	for id_variant in _instances.keys():
		result.append(String(id_variant))
	result.sort()
	return result

func get_instance_count() -> int:
	return _instances.size()

func get_current_section_id() -> String:
	return _current_section_id

func get_probable_next_section_id() -> String:
	return _probable_next_section_id

func get_always_loaded_area_ids() -> Array[String]:
	var result: Array[String] = []
	var areas: Dictionary = LAYOUT.get_area_specs()
	for area_id in SHARED_AREA_IDS:
		if not areas.has(area_id):
			continue
		var area := areas[area_id] as Dictionary
		if String(area.get("kind", "")) == "SHARED_CONNECTOR":
			result.append(area_id)
	return result

func get_loaded_section_ids() -> Array[String]:
	var result: Array[String] = []
	for section_id in get_section_ids():
		var instance = _instances[section_id]
		if instance.is_loaded():
			result.append(section_id)
	return result

func get_pending_unload_ids() -> Array[String]:
	return _pending_unload_ids.duplicate()

func get_protected_section_ids() -> Array[String]:
	return _protected_section_ids.duplicate()

func is_section_loaded(section_id: String) -> bool:
	if not _instances.has(section_id):
		return false
	return _instances[section_id].is_loaded()

func set_protected_section_ids(section_ids: Array) -> Dictionary:
	if not _configured:
		return _error("streaming manager is not configured")

	var normalized := _normalize_section_ids(section_ids)
	if normalized.size() != _unique_requested_count(section_ids):
		for id_variant in section_ids:
			var section_id := String(id_variant)
			if not _instances.has(section_id):
				return _error("unknown protected section: %s" % section_id)

	_protected_section_ids = normalized
	if not _current_section_id.is_empty():
		_apply_desired_state()
	return _state_result(true)

func set_current_section(section_id: String, probable_next_section_id := "") -> Dictionary:
	if not _configured:
		return _error("streaming manager is not configured")
	if not _instances.has(section_id):
		return _error("unknown current section: %s" % section_id)
	if not probable_next_section_id.is_empty():
		if not _instances.has(probable_next_section_id):
			return _error("unknown probable-next section: %s" % probable_next_section_id)
		if not _can_preload_from(section_id, probable_next_section_id):
			return _error("probable-next section is outside conservative two-hop preload range: %s" % probable_next_section_id)

	_current_section_id = section_id
	_probable_next_section_id = probable_next_section_id
	_apply_desired_state()
	return _state_result(true)

func get_desired_loaded_section_ids(
	current_section_id := _current_section_id,
	probable_next_section_id := _probable_next_section_id
) -> Array[String]:
	var result: Array[String] = []
	if not _configured or not _instances.has(current_section_id):
		return result

	_add_unique(result, current_section_id)
	var definition: Dictionary = _instances[current_section_id].get_definition()
	for neighbor_variant in definition.get("neighbors", []):
		_add_unique(result, String(neighbor_variant))

	if (
		not probable_next_section_id.is_empty()
		and _instances.has(probable_next_section_id)
		and _can_preload_from(current_section_id, probable_next_section_id)
	):
		_add_unique(result, probable_next_section_id)

	for protected_id in _protected_section_ids:
		_add_unique(result, protected_id)

	result.sort()
	return result

func commit_pending_unloads() -> Dictionary:
	if not _configured:
		return _error("streaming manager is not configured")

	var desired := get_desired_loaded_section_ids()
	var unloaded: Array[String] = []
	for section_id in _pending_unload_ids:
		if section_id in desired:
			continue
		if not _instances.has(section_id):
			continue
		var instance = _instances[section_id]
		if instance.is_loaded():
			instance.set_loaded(false)
			unloaded.append(section_id)

	_pending_unload_ids.clear()
	unloaded.sort()
	var result := _state_result(true)
	result["unloaded_section_ids"] = unloaded
	return result

func get_runtime_snapshot() -> Dictionary:
	return {
		"schema": SCHEMA,
		"current_section_id": _current_section_id,
		"probable_next_section_id": _probable_next_section_id,
		"protected_section_ids": get_protected_section_ids(),
		"loaded_section_ids": get_loaded_section_ids(),
		"pending_unload_ids": get_pending_unload_ids(),
		"always_loaded_area_ids": get_always_loaded_area_ids(),
	}

func restore_runtime_snapshot(snapshot: Dictionary) -> Dictionary:
	if not _configured:
		return _error("streaming manager is not configured")
	if String(snapshot.get("schema", "")) != SCHEMA:
		return _error("runtime snapshot schema mismatch")

	var current_section_id := String(snapshot.get("current_section_id", ""))
	var probable_next_section_id := String(snapshot.get("probable_next_section_id", ""))
	if current_section_id.is_empty() or not _instances.has(current_section_id):
		return _error("runtime snapshot current section is invalid")
	if not probable_next_section_id.is_empty():
		if not _instances.has(probable_next_section_id):
			return _error("runtime snapshot probable-next section is invalid")
		if not _can_preload_from(current_section_id, probable_next_section_id):
			return _error("runtime snapshot probable-next section violates conservative preload range")

	var protected := _normalize_section_ids(snapshot.get("protected_section_ids", []) as Array)
	var loaded := _normalize_section_ids(snapshot.get("loaded_section_ids", []) as Array)
	var pending := _normalize_section_ids(snapshot.get("pending_unload_ids", []) as Array)

	for id_variant in snapshot.get("protected_section_ids", []):
		if not _instances.has(String(id_variant)):
			return _error("runtime snapshot contains unknown protected section")
	for id_variant in snapshot.get("loaded_section_ids", []):
		if not _instances.has(String(id_variant)):
			return _error("runtime snapshot contains unknown loaded section")
	for id_variant in snapshot.get("pending_unload_ids", []):
		if not _instances.has(String(id_variant)):
			return _error("runtime snapshot contains unknown pending-unload section")

	if current_section_id not in loaded:
		return _error("runtime snapshot current section must be loaded")
	for protected_id in protected:
		if protected_id not in loaded:
			return _error("runtime snapshot protected section must be loaded")
	for pending_id in pending:
		if pending_id not in loaded:
			return _error("runtime snapshot pending-unload section must still be loaded")

	for section_id in get_section_ids():
		_instances[section_id].set_loaded(section_id in loaded)

	_current_section_id = current_section_id
	_probable_next_section_id = probable_next_section_id
	_protected_section_ids = protected
	_pending_unload_ids = pending
	return _state_result(true)

func _apply_desired_state() -> void:
	var desired := get_desired_loaded_section_ids()
	var next_pending: Array[String] = []

	for section_id in get_section_ids():
		var instance = _instances[section_id]
		if section_id in desired:
			instance.set_loaded(true)
		elif instance.is_loaded():
			next_pending.append(section_id)

	_pending_unload_ids = next_pending
	_pending_unload_ids.sort()

func _can_preload_from(current_section_id: String, candidate_section_id: String) -> bool:
	if current_section_id == candidate_section_id:
		return true
	if not _instances.has(current_section_id) or not _instances.has(candidate_section_id):
		return false

	var current: Dictionary = _instances[current_section_id].get_definition()
	var direct_neighbors: Array = current.get("neighbors", []) as Array
	if candidate_section_id in direct_neighbors:
		return true

	for neighbor_variant in direct_neighbors:
		var neighbor_id := String(neighbor_variant)
		if not _instances.has(neighbor_id):
			continue
		var neighbor: Dictionary = _instances[neighbor_id].get_definition()
		if candidate_section_id in (neighbor.get("neighbors", []) as Array):
			return true
	return false

func _normalize_section_ids(values: Array) -> Array[String]:
	var result: Array[String] = []
	for value_variant in values:
		var section_id := String(value_variant)
		if _instances.has(section_id):
			_add_unique(result, section_id)
	result.sort()
	return result

func _unique_requested_count(values: Array) -> int:
	var seen: Dictionary = {}
	for value_variant in values:
		seen[String(value_variant)] = true
	return seen.size()

func _add_unique(values: Array[String], value: String) -> void:
	if value not in values:
		values.append(value)

func _state_result(success: bool) -> Dictionary:
	return {
		"success": success,
		"errors": [],
		"current_section_id": _current_section_id,
		"probable_next_section_id": _probable_next_section_id,
		"desired_loaded_section_ids": get_desired_loaded_section_ids(),
		"loaded_section_ids": get_loaded_section_ids(),
		"pending_unload_ids": get_pending_unload_ids(),
		"protected_section_ids": get_protected_section_ids(),
		"always_loaded_area_ids": get_always_loaded_area_ids(),
	}

func _error(message: String) -> Dictionary:
	return {
		"success": false,
		"errors": [message],
		"current_section_id": _current_section_id,
		"loaded_section_ids": get_loaded_section_ids(),
		"pending_unload_ids": get_pending_unload_ids(),
	}

func _reset() -> void:
	_instances.clear()
	_configured = false
	_current_section_id = ""
	_probable_next_section_id = ""
	_protected_section_ids.clear()
	_pending_unload_ids.clear()
