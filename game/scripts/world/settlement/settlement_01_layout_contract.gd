class_name PixelRPGSettlement01LayoutContract
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_layout.v1"

const SectionDefinition := preload("res://scripts/world/settlement/settlement_section_definition.gd")
const AreaDefinition := preload("res://scripts/world/settlement/settlement_area_definition.gd")

const SECTION_SPECS := {
	"SET01_S01": {
		"section_id": "SET01_S01",
		"bounds": {"min_x": -30.0, "max_x": 30.0, "min_z": 14.0, "max_z": 34.0},
		"neighbors": ["SET01_S02"],
		"connector_ids": ["SET01_CON_S01_S02_MAIN"],
		"area_ids": [
			"SET01_A01_SOUTH_ARRIVAL_GATE",
			"SET01_A02_GATE_BARRACKS_SECURITY",
			"SET01_A03_CARAVAN_VISITOR_STAGING",
		],
		"load_policy": "STATIC_INITIAL",
	},
	"SET01_S02": {
		"section_id": "SET01_S02",
		"bounds": {"min_x": -14.0, "max_x": 14.0, "min_z": -14.0, "max_z": 14.0},
		"neighbors": ["SET01_S01", "SET01_S03", "SET01_S04", "SET01_S05"],
		"connector_ids": [
			"SET01_CON_S01_S02_MAIN",
			"SET01_CON_S02_S03",
			"SET01_CON_S02_S04",
			"SET01_CON_S02_S05_MAIN",
		],
		"area_ids": ["SET01_A05_CENTRAL_MARKET_PLAZA"],
		"load_policy": "STATIC_INITIAL",
	},
	"SET01_S03": {
		"section_id": "SET01_S03",
		"bounds": {"min_x": -30.0, "max_x": -14.0, "min_z": -14.0, "max_z": 14.0},
		"neighbors": ["SET01_S02"],
		"connector_ids": ["SET01_CON_S02_S03"],
		"area_ids": [
			"SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
			"SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		],
		"load_policy": "STATIC_INITIAL",
	},
	"SET01_S04": {
		"section_id": "SET01_S04",
		"bounds": {"min_x": 14.0, "max_x": 30.0, "min_z": -14.0, "max_z": 14.0},
		"neighbors": ["SET01_S02"],
		"connector_ids": ["SET01_CON_S02_S04"],
		"area_ids": [
			"SET01_A08_EAST_WORK_FRONTAGE",
			"SET01_A09_SMITHY_CRAFT_QUARTER",
			"SET01_A10_STORAGE_WORKSHOP_YARD",
		],
		"load_policy": "STATIC_INITIAL",
	},
	"SET01_S05": {
		"section_id": "SET01_S05",
		"bounds": {"min_x": -30.0, "max_x": 30.0, "min_z": -36.0, "max_z": -14.0},
		"neighbors": ["SET01_S02"],
		"connector_ids": ["SET01_CON_S02_S05_MAIN"],
		"area_ids": [
			"SET01_A11_NORTH_HUNTER_STAGING",
			"SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		],
		"load_policy": "STATIC_INITIAL",
	},
}

const CONNECTOR_SPECS := {
	"SET01_CON_S01_S02_MAIN": {
		"connector_id": "SET01_CON_S01_S02_MAIN",
		"section_a": "SET01_S01",
		"section_b": "SET01_S02",
		"center_xz": Vector2(0.0, 14.0),
		"clear_width_m": 8.0,
		"role": "MAIN_SPINE",
	},
	"SET01_CON_S02_S03": {
		"connector_id": "SET01_CON_S02_S03",
		"section_a": "SET01_S02",
		"section_b": "SET01_S03",
		"center_xz": Vector2(-14.0, 0.0),
		"clear_width_m": 5.0,
		"role": "CROSS_STREET",
	},
	"SET01_CON_S02_S04": {
		"connector_id": "SET01_CON_S02_S04",
		"section_a": "SET01_S02",
		"section_b": "SET01_S04",
		"center_xz": Vector2(14.0, 0.0),
		"clear_width_m": 5.0,
		"role": "CROSS_STREET",
	},
	"SET01_CON_S02_S05_MAIN": {
		"connector_id": "SET01_CON_S02_S05_MAIN",
		"section_a": "SET01_S02",
		"section_b": "SET01_S05",
		"center_xz": Vector2(0.0, -14.0),
		"clear_width_m": 8.0,
		"role": "MAIN_SPINE",
	},
}

const AREA_SPECS := {
	"SET01_A01_SOUTH_ARRIVAL_GATE": {
		"area_id": "SET01_A01_SOUTH_ARRIVAL_GATE",
		"parent_section_id": "SET01_S01",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": -14.0, "max_x": 14.0, "min_z": 25.0, "max_z": 34.0},
		],
	},
	"SET01_A02_GATE_BARRACKS_SECURITY": {
		"area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
		"parent_section_id": "SET01_S01",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": -30.0, "max_x": -12.0, "min_z": 14.0, "max_z": 29.0},
		],
	},
	"SET01_A03_CARAVAN_VISITOR_STAGING": {
		"area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
		"parent_section_id": "SET01_S01",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": 12.0, "max_x": 30.0, "min_z": 14.0, "max_z": 29.0},
		],
	},
	"SET01_A04_MAIN_CENTRAL_SPINE": {
		"area_id": "SET01_A04_MAIN_CENTRAL_SPINE",
		"parent_section_id": "",
		"kind": "SHARED_CONNECTOR",
		"bounds_parts": [
			{"min_x": -4.0, "max_x": 4.0, "min_z": -35.0, "max_z": 33.0},
		],
	},
	"SET01_A05_CENTRAL_MARKET_PLAZA": {
		"area_id": "SET01_A05_CENTRAL_MARKET_PLAZA",
		"parent_section_id": "SET01_S02",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": -14.0, "max_x": 14.0, "min_z": -14.0, "max_z": 14.0},
		],
	},
	"SET01_A06_COMMUNITY_HALL_CIVIC_CORE": {
		"area_id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
		"parent_section_id": "SET01_S03",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": -30.0, "max_x": -14.0, "min_z": -6.0, "max_z": 6.0},
		],
	},
	"SET01_A07_WEST_RESIDENTIAL_CLUSTER": {
		"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"parent_section_id": "SET01_S03",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": -30.0, "max_x": -18.0, "min_z": -14.0, "max_z": -6.0},
			{"min_x": -30.0, "max_x": -18.0, "min_z": 6.0, "max_z": 14.0},
		],
	},
	"SET01_A08_EAST_WORK_FRONTAGE": {
		"area_id": "SET01_A08_EAST_WORK_FRONTAGE",
		"parent_section_id": "SET01_S04",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": 14.0, "max_x": 20.5, "min_z": -14.0, "max_z": 14.0},
		],
	},
	"SET01_A09_SMITHY_CRAFT_QUARTER": {
		"area_id": "SET01_A09_SMITHY_CRAFT_QUARTER",
		"parent_section_id": "SET01_S04",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": 20.5, "max_x": 30.0, "min_z": -5.0, "max_z": 5.0},
		],
	},
	"SET01_A10_STORAGE_WORKSHOP_YARD": {
		"area_id": "SET01_A10_STORAGE_WORKSHOP_YARD",
		"parent_section_id": "SET01_S04",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": 20.5, "max_x": 30.0, "min_z": -14.0, "max_z": -6.0},
			{"min_x": 20.5, "max_x": 30.0, "min_z": 6.0, "max_z": 14.0},
		],
	},
	"SET01_A11_NORTH_HUNTER_STAGING": {
		"area_id": "SET01_A11_NORTH_HUNTER_STAGING",
		"parent_section_id": "SET01_S05",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": -30.0, "max_x": 30.0, "min_z": -23.0, "max_z": -14.0},
		],
	},
	"SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT": {
		"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"parent_section_id": "SET01_S05",
		"kind": "SECTION_AREA",
		"bounds_parts": [
			{"min_x": -30.0, "max_x": 30.0, "min_z": -36.0, "max_z": -23.0},
		],
	},
}

const BUILDING_SPECS := {
	"SET01_BLD_SOUTH_GATEHOUSE_W": {
		"building_id": "SET01_BLD_SOUTH_GATEHOUSE_W",
		"section_id": "SET01_S01",
		"area_id": "SET01_A01_SOUTH_ARRIVAL_GATE",
		"center_xz": Vector2(-8.0, 29.0),
		"footprint_xz": Vector2(8.0, 7.0),
	},
	"SET01_BLD_SOUTH_WATCH_E": {
		"building_id": "SET01_BLD_SOUTH_WATCH_E",
		"section_id": "SET01_S01",
		"area_id": "SET01_A01_SOUTH_ARRIVAL_GATE",
		"center_xz": Vector2(8.0, 29.0),
		"footprint_xz": Vector2(6.0, 6.0),
	},
	"SET01_BLD_ARRIVAL_GUARD": {
		"building_id": "SET01_BLD_ARRIVAL_GUARD",
		"section_id": "SET01_S01",
		"area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
		"center_xz": Vector2(-20.0, 23.0),
		"footprint_xz": Vector2(7.0, 6.0),
	},
	"SET01_BLD_ARRIVAL_STORAGE": {
		"building_id": "SET01_BLD_ARRIVAL_STORAGE",
		"section_id": "SET01_S01",
		"area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
		"center_xz": Vector2(20.0, 23.0),
		"footprint_xz": Vector2(7.0, 6.0),
	},
	"SET01_BLD_COMMUNITY_HALL": {
		"building_id": "SET01_BLD_COMMUNITY_HALL",
		"section_id": "SET01_S03",
		"area_id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
		"center_xz": Vector2(-24.5, 0.0),
		"footprint_xz": Vector2(8.0, 10.0),
	},
	"SET01_BLD_RES_W02": {
		"building_id": "SET01_BLD_RES_W02",
		"section_id": "SET01_S03",
		"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"center_xz": Vector2(-24.5, -10.0),
		"footprint_xz": Vector2(7.0, 5.5),
	},
	"SET01_BLD_RES_W01": {
		"building_id": "SET01_BLD_RES_W01",
		"section_id": "SET01_S03",
		"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"center_xz": Vector2(-24.5, 10.0),
		"footprint_xz": Vector2(7.0, 5.5),
	},
	"SET01_BLD_SMITH": {
		"building_id": "SET01_BLD_SMITH",
		"section_id": "SET01_S04",
		"area_id": "SET01_A09_SMITHY_CRAFT_QUARTER",
		"center_xz": Vector2(24.5, 0.0),
		"footprint_xz": Vector2(6.6, 6.4),
	},
	"SET01_BLD_WORK_CANOPY": {
		"building_id": "SET01_BLD_WORK_CANOPY",
		"section_id": "SET01_S04",
		"area_id": "SET01_A10_STORAGE_WORKSHOP_YARD",
		"center_xz": Vector2(24.5, -9.5),
		"footprint_xz": Vector2(7.0, 6.0),
	},
	"SET01_BLD_WORK_STORAGE": {
		"building_id": "SET01_BLD_WORK_STORAGE",
		"section_id": "SET01_S04",
		"area_id": "SET01_A10_STORAGE_WORKSHOP_YARD",
		"center_xz": Vector2(24.5, 9.5),
		"footprint_xz": Vector2(7.0, 6.0),
	},
	"SET01_BLD_HUNTER_WATCH": {
		"building_id": "SET01_BLD_HUNTER_WATCH",
		"section_id": "SET01_S05",
		"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"center_xz": Vector2(-19.0, -27.0),
		"footprint_xz": Vector2(7.0, 7.0),
	},
	"SET01_BLD_SUPPLY_CACHE": {
		"building_id": "SET01_BLD_SUPPLY_CACHE",
		"section_id": "SET01_S05",
		"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"center_xz": Vector2(19.0, -27.0),
		"footprint_xz": Vector2(7.0, 6.0),
	},
}

const INFRASTRUCTURE_SPECS := {
	"settlement_envelope": {
		"bounds": {"min_x": -30.0, "max_x": 30.0, "min_z": -36.0, "max_z": 34.0},
	},
	"main_spine": {
		"bounds": {"min_x": -4.0, "max_x": 4.0, "min_z": -35.0, "max_z": 33.0},
		"width_m": 8.0,
	},
	"central_cross_street": {
		"bounds": {"min_x": -20.0, "max_x": 20.0, "min_z": -2.5, "max_z": 2.5},
		"width_m": 5.0,
	},
	"west_frontage_lane": {
		"center_x": -16.25,
		"width_m": 4.5,
		"min_z": -13.0,
		"max_z": 13.0,
	},
	"east_frontage_lane": {
		"center_x": 16.25,
		"width_m": 4.5,
		"min_z": -13.0,
		"max_z": 13.0,
	},
	"south_gate": {
		"center_xz": Vector2(0.0, 33.0),
		"clear_width_m": 8.0,
	},
	"north_gate": {
		"center_xz": Vector2(0.0, -35.0),
		"clear_width_m": 8.0,
	},
}

static func get_schema() -> String:
	return SCHEMA

static func get_section_specs() -> Dictionary:
	return SECTION_SPECS.duplicate(true)

static func get_area_specs() -> Dictionary:
	return AREA_SPECS.duplicate(true)

static func get_connector_specs() -> Dictionary:
	return CONNECTOR_SPECS.duplicate(true)

static func get_building_specs() -> Dictionary:
	return BUILDING_SPECS.duplicate(true)

static func get_infrastructure_specs() -> Dictionary:
	return INFRASTRUCTURE_SPECS.duplicate(true)

static func validate_contract() -> Dictionary:
	var errors: Array[String] = []

	for section_variant in SECTION_SPECS.keys():
		var section_id := String(section_variant)
		var section := SECTION_SPECS[section_id] as Dictionary
		if String(section.get("section_id", "")) != section_id:
			errors.append("section registry key mismatch for %s" % section_id)
		errors.append_array(SectionDefinition.validate(section))

		for neighbor_variant in section.get("neighbors", []):
			var neighbor_id := String(neighbor_variant)
			if not SECTION_SPECS.has(neighbor_id):
				errors.append("section %s references unknown neighbor %s" % [section_id, neighbor_id])
				continue
			var neighbor := SECTION_SPECS[neighbor_id] as Dictionary
			if section_id not in neighbor.get("neighbors", []):
				errors.append("section neighbor relationship is not symmetric: %s <-> %s" % [section_id, neighbor_id])

		for connector_variant in section.get("connector_ids", []):
			var connector_id := String(connector_variant)
			if not CONNECTOR_SPECS.has(connector_id):
				errors.append("section %s references unknown connector %s" % [section_id, connector_id])

		for area_variant in section.get("area_ids", []):
			var area_id := String(area_variant)
			if not AREA_SPECS.has(area_id):
				errors.append("section %s references unknown area %s" % [section_id, area_id])
				continue
			var area := AREA_SPECS[area_id] as Dictionary
			if String(area.get("parent_section_id", "")) != section_id:
				errors.append("section %s lists area %s owned by %s" % [section_id, area_id, area.get("parent_section_id", "")])

	for connector_variant in CONNECTOR_SPECS.keys():
		var connector_id := String(connector_variant)
		var connector := CONNECTOR_SPECS[connector_id] as Dictionary
		if String(connector.get("connector_id", "")) != connector_id:
			errors.append("connector registry key mismatch for %s" % connector_id)
		var section_a := String(connector.get("section_a", ""))
		var section_b := String(connector.get("section_b", ""))
		if not SECTION_SPECS.has(section_a) or not SECTION_SPECS.has(section_b):
			errors.append("connector %s references unknown section endpoint" % connector_id)
			continue
		if section_a == section_b:
			errors.append("connector %s connects a section to itself" % connector_id)
		if float(connector.get("clear_width_m", 0.0)) <= 0.0:
			errors.append("connector %s has non-positive clear width" % connector_id)
		for endpoint in [section_a, section_b]:
			var section := SECTION_SPECS[endpoint] as Dictionary
			if connector_id not in section.get("connector_ids", []):
				errors.append("connector %s missing from section %s connector list" % [connector_id, endpoint])

	for area_variant in AREA_SPECS.keys():
		var area_id := String(area_variant)
		var area := AREA_SPECS[area_id] as Dictionary
		if String(area.get("area_id", "")) != area_id:
			errors.append("area registry key mismatch for %s" % area_id)
		errors.append_array(AreaDefinition.validate(area))

		var kind := String(area.get("kind", ""))
		var parent_section_id := String(area.get("parent_section_id", ""))
		if kind == AreaDefinition.KIND_SECTION_AREA:
			if not SECTION_SPECS.has(parent_section_id):
				errors.append("area %s references unknown parent %s" % [area_id, parent_section_id])
				continue
			var parent_bounds := (SECTION_SPECS[parent_section_id] as Dictionary).get("bounds", {}) as Dictionary
			for bounds_variant in area.get("bounds_parts", []):
				var area_bounds := bounds_variant as Dictionary
				if not _bounds_inside(parent_bounds, area_bounds):
					errors.append("area %s bounds escape parent section %s" % [area_id, parent_section_id])

	var connected_sections := _connected_section_ids("SET01_S01")
	if connected_sections.size() != SECTION_SPECS.size():
		errors.append("section graph is disconnected: reached %d of %d" % [connected_sections.size(), SECTION_SPECS.size()])

	for building_variant in BUILDING_SPECS.keys():
		var building_id := String(building_variant)
		var building := BUILDING_SPECS[building_id] as Dictionary
		if String(building.get("building_id", "")) != building_id:
			errors.append("building registry key mismatch for %s" % building_id)
		if not building_id.begins_with("SET01_BLD_"):
			errors.append("building ID is not stable Settlement 01 format: %s" % building_id)

		var section_id := String(building.get("section_id", ""))
		var area_id := String(building.get("area_id", ""))
		if not SECTION_SPECS.has(section_id):
			errors.append("building %s references unknown section %s" % [building_id, section_id])
			continue
		if not AREA_SPECS.has(area_id):
			errors.append("building %s references unknown area %s" % [building_id, area_id])
			continue

		var area := AREA_SPECS[area_id] as Dictionary
		if String(area.get("parent_section_id", "")) != section_id:
			errors.append("building %s section/area ownership disagrees" % building_id)

		var center: Vector2 = building.get("center_xz", Vector2.ZERO)
		var footprint: Vector2 = building.get("footprint_xz", Vector2.ZERO)
		if footprint.x <= 0.0 or footprint.y <= 0.0:
			errors.append("building %s has non-positive footprint" % building_id)
			continue
		var building_bounds := _building_bounds(center, footprint)
		var section_bounds := (SECTION_SPECS[section_id] as Dictionary).get("bounds", {}) as Dictionary
		if not _bounds_inside(section_bounds, building_bounds):
			errors.append("building %s escapes section %s" % [building_id, section_id])

		var inside_area := false
		for bounds_variant in area.get("bounds_parts", []):
			if _bounds_inside(bounds_variant as Dictionary, building_bounds):
				inside_area = true
				break
		if not inside_area:
			errors.append("building %s escapes all bounds parts for area %s" % [building_id, area_id])

	var envelope := (INFRASTRUCTURE_SPECS["settlement_envelope"] as Dictionary).get("bounds", {}) as Dictionary
	var main_spine := (INFRASTRUCTURE_SPECS["main_spine"] as Dictionary).get("bounds", {}) as Dictionary
	var cross_street := (INFRASTRUCTURE_SPECS["central_cross_street"] as Dictionary).get("bounds", {}) as Dictionary
	if not _bounds_inside(envelope, main_spine):
		errors.append("main spine escapes settlement envelope")
	if not _bounds_inside(envelope, cross_street):
		errors.append("central cross street escapes settlement envelope")
	if not is_equal_approx(float((INFRASTRUCTURE_SPECS["main_spine"] as Dictionary).get("width_m", 0.0)), 8.0):
		errors.append("main spine width is not 8 m")
	if not is_equal_approx(float((INFRASTRUCTURE_SPECS["central_cross_street"] as Dictionary).get("width_m", 0.0)), 5.0):
		errors.append("central cross street width is not 5 m")
	if not is_equal_approx(float((INFRASTRUCTURE_SPECS["south_gate"] as Dictionary).get("clear_width_m", 0.0)), 8.0):
		errors.append("south gate clear width is not 8 m")
	if not is_equal_approx(float((INFRASTRUCTURE_SPECS["north_gate"] as Dictionary).get("clear_width_m", 0.0)), 8.0):
		errors.append("north gate clear width is not 8 m")

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"schema": SCHEMA,
		"section_count": SECTION_SPECS.size(),
		"area_count": AREA_SPECS.size(),
		"connector_count": CONNECTOR_SPECS.size(),
		"building_count": BUILDING_SPECS.size(),
		"connected_section_count": connected_sections.size(),
	}

static func _bounds_inside(outer: Dictionary, inner: Dictionary, epsilon := 0.001) -> bool:
	return (
		float(inner.get("min_x", 0.0)) >= float(outer.get("min_x", 0.0)) - epsilon
		and float(inner.get("max_x", 0.0)) <= float(outer.get("max_x", 0.0)) + epsilon
		and float(inner.get("min_z", 0.0)) >= float(outer.get("min_z", 0.0)) - epsilon
		and float(inner.get("max_z", 0.0)) <= float(outer.get("max_z", 0.0)) + epsilon
	)

static func _building_bounds(center: Vector2, footprint: Vector2) -> Dictionary:
	var half := footprint * 0.5
	return {
		"min_x": center.x - half.x,
		"max_x": center.x + half.x,
		"min_z": center.y - half.y,
		"max_z": center.y + half.y,
	}

static func _connected_section_ids(start_id: String) -> Dictionary:
	var seen: Dictionary = {}
	if not SECTION_SPECS.has(start_id):
		return seen

	var pending: Array[String] = [start_id]
	while not pending.is_empty():
		var current_id := String(pending.pop_front())
		if seen.has(current_id):
			continue
		seen[current_id] = true
		var current := SECTION_SPECS[current_id] as Dictionary
		for neighbor_variant in current.get("neighbors", []):
			var neighbor_id := String(neighbor_variant)
			if not seen.has(neighbor_id):
				pending.append(neighbor_id)
	return seen
