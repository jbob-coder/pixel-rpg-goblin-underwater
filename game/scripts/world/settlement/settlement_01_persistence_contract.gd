class_name PixelRPGSettlement01PersistenceContract
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_persistence_contract.v1"
const SNAPSHOT_SCHEMA_ID := "PIXEL_RPG_SETTLEMENT_01_WORLD_STATE"
const SNAPSHOT_VERSION := 1
const SETTLEMENT_ID := "SETTLEMENT_01"
const TARGET_OWNER_ID := "durable.world_state"

const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const STATE_OWNERSHIP := preload("res://scripts/state/pixel_rpg_state_ownership_contract.gd")

const TOP_LEVEL_KEYS := [
	"schema_id",
	"schema_version",
	"settlement_id",
	"layout_schema",
	"target_owner_id",
	"payload",
]
const PAYLOAD_KEYS := [
	"settlement_flags",
	"section_records",
	"building_records",
]
const RECORD_KEYS := ["flags"]

static func get_schema() -> String:
	return SCHEMA

static func get_snapshot_schema_id() -> String:
	return SNAPSHOT_SCHEMA_ID

static func get_snapshot_version() -> int:
	return SNAPSHOT_VERSION

static func get_target_owner_id() -> String:
	return TARGET_OWNER_ID

static func build_snapshot(
	settlement_flags: Dictionary = {},
	section_flags: Dictionary = {},
	building_flags: Dictionary = {}
) -> Dictionary:
	var errors: Array[String] = []
	_validate_known_record_input(section_flags, LAYOUT.get_section_specs(), "section", errors)
	_validate_known_record_input(building_flags, LAYOUT.get_building_specs(), "building", errors)
	_validate_json_value(settlement_flags, "payload.settlement_flags", errors)
	if not errors.is_empty():
		return {
			"success": false,
			"errors": errors,
			"snapshot": {},
		}

	var section_records: Dictionary = {}
	var section_ids := LAYOUT.get_section_specs().keys()
	section_ids.sort()
	for id_variant in section_ids:
		var section_id := String(id_variant)
		var flags := section_flags.get(section_id, {}) as Dictionary
		section_records[section_id] = {"flags": flags.duplicate(true)}

	var building_records: Dictionary = {}
	var building_ids := LAYOUT.get_building_specs().keys()
	building_ids.sort()
	for id_variant in building_ids:
		var building_id := String(id_variant)
		var flags := building_flags.get(building_id, {}) as Dictionary
		building_records[building_id] = {"flags": flags.duplicate(true)}

	var snapshot := {
		"schema_id": SNAPSHOT_SCHEMA_ID,
		"schema_version": SNAPSHOT_VERSION,
		"settlement_id": SETTLEMENT_ID,
		"layout_schema": LAYOUT.get_schema(),
		"target_owner_id": TARGET_OWNER_ID,
		"payload": {
			"settlement_flags": settlement_flags.duplicate(true),
			"section_records": section_records,
			"building_records": building_records,
		},
	}
	var validation := validate_snapshot(snapshot)
	return {
		"success": bool(validation.get("success", false)),
		"errors": validation.get("errors", []),
		"snapshot": snapshot if bool(validation.get("success", false)) else {},
	}

static func validate_snapshot(snapshot: Dictionary) -> Dictionary:
	var errors: Array[String] = []

	var layout_validation: Dictionary = LAYOUT.validate_contract()
	if not bool(layout_validation.get("success", false)):
		errors.append("G00 layout contract is invalid")

	var ownership_validation: Dictionary = STATE_OWNERSHIP.validate_contract()
	if not bool(ownership_validation.get("success", false)):
		errors.append("state ownership contract is invalid")

	var durable_owner: Dictionary = STATE_OWNERSHIP.get_owner_spec(TARGET_OWNER_ID)
	if durable_owner.is_empty():
		errors.append("target durable world owner is not reserved by state ownership contract")

	var section_datum: Dictionary = STATE_OWNERSHIP.get_datum_spec("world.section_state")
	if String(section_datum.get("owner_id", "")) != TARGET_OWNER_ID:
		errors.append("world.section_state does not target durable.world_state")

	_validate_exact_keys(snapshot, TOP_LEVEL_KEYS, "snapshot", errors)

	if String(snapshot.get("schema_id", "")) != SNAPSHOT_SCHEMA_ID:
		errors.append("snapshot schema_id mismatch")
	if int(snapshot.get("schema_version", -1)) != SNAPSHOT_VERSION:
		errors.append("snapshot schema_version is unsupported")
	if String(snapshot.get("settlement_id", "")) != SETTLEMENT_ID:
		errors.append("snapshot settlement_id mismatch")
	if String(snapshot.get("layout_schema", "")) != LAYOUT.get_schema():
		errors.append("snapshot layout_schema mismatch")
	if String(snapshot.get("target_owner_id", "")) != TARGET_OWNER_ID:
		errors.append("snapshot target_owner_id mismatch")

	var payload_variant = snapshot.get("payload", null)
	if typeof(payload_variant) != TYPE_DICTIONARY:
		errors.append("snapshot payload must be a Dictionary")
		return _validation_result(errors, 0, 0)

	var payload := payload_variant as Dictionary
	_validate_exact_keys(payload, PAYLOAD_KEYS, "payload", errors)

	var settlement_flags_variant = payload.get("settlement_flags", null)
	if typeof(settlement_flags_variant) != TYPE_DICTIONARY:
		errors.append("payload.settlement_flags must be a Dictionary")
	else:
		_validate_json_value(settlement_flags_variant, "payload.settlement_flags", errors)

	var section_records_variant = payload.get("section_records", null)
	if typeof(section_records_variant) != TYPE_DICTIONARY:
		errors.append("payload.section_records must be a Dictionary")
	else:
		_validate_record_registry(
			section_records_variant as Dictionary,
			LAYOUT.get_section_specs(),
			"section",
			errors
		)

	var building_records_variant = payload.get("building_records", null)
	if typeof(building_records_variant) != TYPE_DICTIONARY:
		errors.append("payload.building_records must be a Dictionary")
	else:
		_validate_record_registry(
			building_records_variant as Dictionary,
			LAYOUT.get_building_specs(),
			"building",
			errors
		)

	_validate_json_value(snapshot, "snapshot", errors)

	return _validation_result(
		errors,
		(section_records_variant as Dictionary).size() if typeof(section_records_variant) == TYPE_DICTIONARY else 0,
		(building_records_variant as Dictionary).size() if typeof(building_records_variant) == TYPE_DICTIONARY else 0
	)

static func migrate_snapshot(snapshot: Dictionary) -> Dictionary:
	if String(snapshot.get("schema_id", "")) != SNAPSHOT_SCHEMA_ID:
		return {
			"success": false,
			"errors": ["cannot migrate unknown Settlement 01 snapshot schema"],
			"snapshot": {},
		}
	var version := int(snapshot.get("schema_version", -1))
	if version != SNAPSHOT_VERSION:
		return {
			"success": false,
			"errors": ["unsupported Settlement 01 snapshot version: %d" % version],
			"snapshot": {},
		}
	var validation := validate_snapshot(snapshot)
	return {
		"success": bool(validation.get("success", false)),
		"errors": validation.get("errors", []),
		"snapshot": snapshot.duplicate(true) if bool(validation.get("success", false)) else {},
	}

static func extract_durable_world_payload(snapshot: Dictionary) -> Dictionary:
	var validation := validate_snapshot(snapshot)
	if not bool(validation.get("success", false)):
		return {
			"success": false,
			"errors": validation.get("errors", []),
			"payload": {},
		}
	return {
		"success": true,
		"errors": [],
		"payload": (snapshot.get("payload", {}) as Dictionary).duplicate(true),
	}

static func canonical_json(snapshot: Dictionary) -> String:
	var validation := validate_snapshot(snapshot)
	if not bool(validation.get("success", false)):
		return ""
	return JSON.stringify(_canonicalize(snapshot))

static func _validate_known_record_input(
	input: Dictionary,
	known_specs: Dictionary,
	kind: String,
	errors: Array[String]
) -> void:
	for id_variant in input.keys():
		var stable_id := String(id_variant)
		if not known_specs.has(stable_id):
			errors.append("unknown %s stable ID: %s" % [kind, stable_id])
			continue
		var flags_variant = input[id_variant]
		if typeof(flags_variant) != TYPE_DICTIONARY:
			errors.append("%s %s flags must be a Dictionary" % [kind, stable_id])
			continue
		_validate_json_value(flags_variant, "%s_flags.%s" % [kind, stable_id], errors)

static func _validate_record_registry(
	records: Dictionary,
	known_specs: Dictionary,
	kind: String,
	errors: Array[String]
) -> void:
	var known_ids := known_specs.keys()
	known_ids.sort()
	var record_ids := records.keys()
	record_ids.sort()
	if record_ids != known_ids:
		errors.append("%s record stable-ID set does not match current layout contract" % kind)

	for id_variant in records.keys():
		var stable_id := String(id_variant)
		if not known_specs.has(stable_id):
			continue
		var record_variant = records[id_variant]
		if typeof(record_variant) != TYPE_DICTIONARY:
			errors.append("%s record %s must be a Dictionary" % [kind, stable_id])
			continue
		var record := record_variant as Dictionary
		_validate_exact_keys(record, RECORD_KEYS, "%s record %s" % [kind, stable_id], errors)
		var flags_variant = record.get("flags", null)
		if typeof(flags_variant) != TYPE_DICTIONARY:
			errors.append("%s record %s flags must be a Dictionary" % [kind, stable_id])
			continue
		_validate_json_value(flags_variant, "%s record %s flags" % [kind, stable_id], errors)

static func _validate_exact_keys(
	value: Dictionary,
	expected_keys: Array,
	path: String,
	errors: Array[String]
) -> void:
	var actual := value.keys()
	actual.sort()
	var expected := expected_keys.duplicate()
	expected.sort()
	if actual != expected:
		errors.append("%s keys do not match the persistence contract" % path)

static func _validate_json_value(value: Variant, path: String, errors: Array[String]) -> void:
	match typeof(value):
		TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_STRING:
			return
		TYPE_FLOAT:
			var number := float(value)
			if is_nan(number) or is_inf(number):
				errors.append("%s contains non-finite float" % path)
		TYPE_ARRAY:
			var items := value as Array
			for index in range(items.size()):
				_validate_json_value(items[index], "%s[%d]" % [path, index], errors)
		TYPE_DICTIONARY:
			var dictionary := value as Dictionary
			for key_variant in dictionary.keys():
				if typeof(key_variant) != TYPE_STRING:
					errors.append("%s contains non-string Dictionary key" % path)
					continue
				var key := String(key_variant)
				_validate_json_value(dictionary[key_variant], "%s.%s" % [path, key], errors)
		_:
			errors.append("%s contains non-serializable runtime value type %d" % [path, typeof(value)])

static func _canonicalize(value: Variant) -> Variant:
	match typeof(value):
		TYPE_ARRAY:
			var source_array := value as Array
			var result_array: Array = []
			for item in source_array:
				result_array.append(_canonicalize(item))
			return result_array
		TYPE_DICTIONARY:
			var source := value as Dictionary
			var keys := source.keys()
			keys.sort()
			var result_dict: Dictionary = {}
			for key_variant in keys:
				var key := String(key_variant)
				result_dict[key] = _canonicalize(source[key_variant])
			return result_dict
		TYPE_FLOAT:
			var number := float(value)
			# Godot JSON parsing represents JSON numbers as floats. Normalize exact
			# integral values so build -> JSON -> parse -> canonical JSON is stable.
			if is_equal_approx(number, round(number)):
				return int(round(number))
			return number
		_:
			return value

static func _validation_result(errors: Array[String], section_count: int, building_count: int) -> Dictionary:
	return {
		"success": errors.is_empty(),
		"errors": errors,
		"schema": SCHEMA,
		"snapshot_schema_id": SNAPSHOT_SCHEMA_ID,
		"snapshot_version": SNAPSHOT_VERSION,
		"target_owner_id": TARGET_OWNER_ID,
		"section_record_count": section_count,
		"building_record_count": building_count,
	}
