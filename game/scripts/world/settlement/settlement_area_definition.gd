class_name PixelRPGSettlementAreaDefinition
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_area_definition.v1"
const KIND_SECTION_AREA := "SECTION_AREA"
const KIND_SHARED_CONNECTOR := "SHARED_CONNECTOR"

static func get_schema() -> String:
	return SCHEMA

static func make(
	area_id: String,
	parent_section_id: String,
	bounds_parts: Array[Dictionary],
	kind: String = KIND_SECTION_AREA
) -> Dictionary:
	var copied_bounds: Array[Dictionary] = []
	for bounds in bounds_parts:
		copied_bounds.append(bounds.duplicate(true))
	return {
		"area_id": area_id,
		"parent_section_id": parent_section_id,
		"bounds_parts": copied_bounds,
		"kind": kind,
	}

static func validate(definition: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var area_id := String(definition.get("area_id", ""))
	var parent_section_id := String(definition.get("parent_section_id", ""))
	var kind := String(definition.get("kind", ""))

	if area_id.is_empty():
		errors.append("area_id is empty")
	elif not area_id.begins_with("SET01_A"):
		errors.append("area_id is not a stable Settlement 01 area ID: %s" % area_id)

	if kind not in [KIND_SECTION_AREA, KIND_SHARED_CONNECTOR]:
		errors.append("area %s has unsupported kind %s" % [area_id, kind])

	if kind == KIND_SECTION_AREA and parent_section_id.is_empty():
		errors.append("section-owned area %s has no parent section" % area_id)
	if kind == KIND_SHARED_CONNECTOR and not parent_section_id.is_empty():
		errors.append("shared connector area %s must not claim a durable parent section" % area_id)

	var bounds_parts := definition.get("bounds_parts", []) as Array
	if bounds_parts.is_empty():
		errors.append("area %s has no bounds parts" % area_id)
	for index in range(bounds_parts.size()):
		var bounds := bounds_parts[index] as Dictionary
		errors.append_array(_validate_bounds(bounds, "area %s part %d" % [area_id, index]))

	return errors

static func _validate_bounds(bounds: Dictionary, label: String) -> Array[String]:
	var errors: Array[String] = []
	for key in ["min_x", "max_x", "min_z", "max_z"]:
		if not bounds.has(key):
			errors.append("%s bounds missing %s" % [label, key])
	if not errors.is_empty():
		return errors

	if float(bounds["min_x"]) >= float(bounds["max_x"]):
		errors.append("%s bounds require min_x < max_x" % label)
	if float(bounds["min_z"]) >= float(bounds["max_z"]):
		errors.append("%s bounds require min_z < max_z" % label)
	return errors
