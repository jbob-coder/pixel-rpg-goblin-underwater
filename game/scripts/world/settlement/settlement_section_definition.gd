class_name PixelRPGSettlementSectionDefinition
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_section_definition.v1"

static func get_schema() -> String:
	return SCHEMA

static func make(
	section_id: String,
	bounds: Dictionary,
	neighbors: Array[String],
	connector_ids: Array[String],
	area_ids: Array[String],
	load_policy: String = "STATIC_INITIAL"
) -> Dictionary:
	return {
		"section_id": section_id,
		"bounds": bounds.duplicate(true),
		"neighbors": neighbors.duplicate(),
		"connector_ids": connector_ids.duplicate(),
		"area_ids": area_ids.duplicate(),
		"load_policy": load_policy,
	}

static func validate(definition: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var section_id := String(definition.get("section_id", ""))
	if section_id.is_empty():
		errors.append("section_id is empty")
	elif not section_id.begins_with("SET01_S"):
		errors.append("section_id is not a stable Settlement 01 section ID: %s" % section_id)

	var bounds := definition.get("bounds", {}) as Dictionary
	errors.append_array(_validate_bounds(bounds, "section %s" % section_id))

	var seen_neighbors: Dictionary = {}
	for neighbor_variant in definition.get("neighbors", []):
		var neighbor_id := String(neighbor_variant)
		if neighbor_id.is_empty():
			errors.append("section %s has an empty neighbor ID" % section_id)
		elif seen_neighbors.has(neighbor_id):
			errors.append("section %s repeats neighbor %s" % [section_id, neighbor_id])
		else:
			seen_neighbors[neighbor_id] = true

	var seen_connectors: Dictionary = {}
	for connector_variant in definition.get("connector_ids", []):
		var connector_id := String(connector_variant)
		if connector_id.is_empty():
			errors.append("section %s has an empty connector ID" % section_id)
		elif seen_connectors.has(connector_id):
			errors.append("section %s repeats connector %s" % [section_id, connector_id])
		else:
			seen_connectors[connector_id] = true

	var seen_areas: Dictionary = {}
	for area_variant in definition.get("area_ids", []):
		var area_id := String(area_variant)
		if area_id.is_empty():
			errors.append("section %s has an empty area ID" % section_id)
		elif seen_areas.has(area_id):
			errors.append("section %s repeats area %s" % [section_id, area_id])
		else:
			seen_areas[area_id] = true

	return errors

static func _validate_bounds(bounds: Dictionary, label: String) -> Array[String]:
	var errors: Array[String] = []
	for key in ["min_x", "max_x", "min_z", "max_z"]:
		if not bounds.has(key):
			errors.append("%s bounds missing %s" % [label, key])
	if not errors.is_empty():
		return errors

	var min_x := float(bounds["min_x"])
	var max_x := float(bounds["max_x"])
	var min_z := float(bounds["min_z"])
	var max_z := float(bounds["max_z"])
	if min_x >= max_x:
		errors.append("%s bounds require min_x < max_x" % label)
	if min_z >= max_z:
		errors.append("%s bounds require min_z < max_z" % label)
	return errors
