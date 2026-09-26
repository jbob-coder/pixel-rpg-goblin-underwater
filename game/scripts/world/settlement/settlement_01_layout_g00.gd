extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_layout.g00.v1"
const SETTLEMENT_ID := "SETTLEMENT_01"

const OWNERSHIP_SECTION_SUBAREA := "SECTION_SUBAREA"
const OWNERSHIP_SHARED_INFRASTRUCTURE := "SHARED_INFRASTRUCTURE"

const SETTLEMENT_BOUNDS := {
	"x_min": -30.0,
	"x_max": 30.0,
	"z_min": -36.0,
	"z_max": 34.0,
}

const MAIN_SPINE := {
	"id": "SET01_ROAD_MAIN_SPINE",
	"x_min": -4.0,
	"x_max": 4.0,
	"z_min": -35.0,
	"z_max": 33.0,
	"width_m": 8.0,
	"physics_owner": "GROUND",
}

const CENTRAL_CROSS_STREET := {
	"id": "SET01_ROAD_CROSS",
	"x_min": -20.0,
	"x_max": 20.0,
	"z_min": -2.5,
	"z_max": 2.5,
	"width_m": 5.0,
	"physics_owner": "GROUND",
}

const WEST_FRONTAGE_LANE := {
	"id": "SET01_LANE_WEST",
	"center_x": -16.25,
	"width_m": 4.5,
	"z_min": -13.0,
	"z_max": 13.0,
	"physics_owner": "GROUND",
}

const EAST_FRONTAGE_LANE := {
	"id": "SET01_LANE_EAST",
	"center_x": 16.25,
	"width_m": 4.5,
	"z_min": -13.0,
	"z_max": 13.0,
	"physics_owner": "GROUND",
}

const SECTION_SPECS := {
	"SET01_S01": {
		"id": "SET01_S01",
		"name": "South Gate / Arrival",
		"bounds": {"x_min": -30.0, "x_max": 30.0, "z_min": 14.0, "z_max": 34.0},
	},
	"SET01_S02": {
		"id": "SET01_S02",
		"name": "Central Plaza / Market",
		"bounds": {"x_min": -14.0, "x_max": 14.0, "z_min": -14.0, "z_max": 14.0},
	},
	"SET01_S03": {
		"id": "SET01_S03",
		"name": "West Residential / Local",
		"bounds": {"x_min": -30.0, "x_max": -14.0, "z_min": -14.0, "z_max": 14.0},
	},
	"SET01_S04": {
		"id": "SET01_S04",
		"name": "East Work District",
		"bounds": {"x_min": 14.0, "x_max": 30.0, "z_min": -14.0, "z_max": 14.0},
	},
	"SET01_S05": {
		"id": "SET01_S05",
		"name": "North Hunter Exit",
		"bounds": {"x_min": -30.0, "x_max": 30.0, "z_min": -36.0, "z_max": -14.0},
	},
}

const AREA_SPECS := {
	"SET01_A01_SOUTH_ARRIVAL_GATE": {
		"id": "SET01_A01_SOUTH_ARRIVAL_GATE",
		"name": "South Arrival Gate",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S01",
		"placement_bounds": [
			{"x_min": -14.0, "x_max": 14.0, "z_min": 25.0, "z_max": 34.0},
		],
	},
	"SET01_A02_GATE_BARRACKS_SECURITY": {
		"id": "SET01_A02_GATE_BARRACKS_SECURITY",
		"name": "Gate Barracks & Security",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S01",
		"placement_bounds": [
			{"x_min": -30.0, "x_max": -12.0, "z_min": 14.0, "z_max": 29.0},
		],
	},
	"SET01_A03_CARAVAN_VISITOR_STAGING": {
		"id": "SET01_A03_CARAVAN_VISITOR_STAGING",
		"name": "Caravan Yard / Visitor Staging",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S01",
		"placement_bounds": [
			{"x_min": 12.0, "x_max": 30.0, "z_min": 14.0, "z_max": 29.0},
		],
	},
	"SET01_A04_MAIN_CENTRAL_SPINE": {
		"id": "SET01_A04_MAIN_CENTRAL_SPINE",
		"name": "Main Central Spine Road",
		"ownership": OWNERSHIP_SHARED_INFRASTRUCTURE,
		"parent_section_id": "",
		"traversed_section_ids": ["SET01_S01", "SET01_S02", "SET01_S05"],
		"placement_bounds": [
			{"x_min": -4.0, "x_max": 4.0, "z_min": -35.0, "z_max": 33.0},
		],
	},
	"SET01_A05_CENTRAL_MARKET_PLAZA": {
		"id": "SET01_A05_CENTRAL_MARKET_PLAZA",
		"name": "Central Market Plaza",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S02",
		"placement_bounds": [
			{"x_min": -14.0, "x_max": 14.0, "z_min": -14.0, "z_max": 14.0},
		],
	},
	"SET01_A06_COMMUNITY_HALL_CIVIC_CORE": {
		"id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
		"name": "Community Hall / Civic Core",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S03",
		"placement_bounds": [
			{"x_min": -30.0, "x_max": -14.0, "z_min": -6.0, "z_max": 6.0},
		],
	},
	"SET01_A07_WEST_RESIDENTIAL_CLUSTER": {
		"id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"name": "West Residential Cluster",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S03",
		"placement_bounds": [
			{"x_min": -30.0, "x_max": -18.0, "z_min": -14.0, "z_max": -6.0},
			{"x_min": -30.0, "x_max": -18.0, "z_min": 6.0, "z_max": 14.0},
		],
	},
	"SET01_A08_EAST_WORK_FRONTAGE": {
		"id": "SET01_A08_EAST_WORK_FRONTAGE",
		"name": "East Work Frontage / Worker Passage",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S04",
		"placement_bounds": [
			{"x_min": 14.0, "x_max": 20.5, "z_min": -14.0, "z_max": 14.0},
		],
	},
	"SET01_A09_SMITHY_CRAFT_QUARTER": {
		"id": "SET01_A09_SMITHY_CRAFT_QUARTER",
		"name": "Smithy & Craft Quarter",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S04",
		"placement_bounds": [
			{"x_min": 20.5, "x_max": 30.0, "z_min": -5.0, "z_max": 5.0},
		],
	},
	"SET01_A10_STORAGE_WORKSHOP_YARD": {
		"id": "SET01_A10_STORAGE_WORKSHOP_YARD",
		"name": "Storage / Workshop Yard",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S04",
		"placement_bounds": [
			{"x_min": 20.5, "x_max": 30.0, "z_min": -14.0, "z_max": -6.0},
			{"x_min": 20.5, "x_max": 30.0, "z_min": 6.0, "z_max": 14.0},
		],
	},
	"SET01_A11_NORTH_HUNTER_STAGING": {
		"id": "SET01_A11_NORTH_HUNTER_STAGING",
		"name": "North Hunter Staging Ground",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S05",
		"placement_bounds": [
			{"x_min": -30.0, "x_max": 30.0, "z_min": -23.0, "z_max": -14.0},
		],
	},
	"SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT": {
		"id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"name": "North Watch Gate & Trail Exit",
		"ownership": OWNERSHIP_SECTION_SUBAREA,
		"parent_section_id": "SET01_S05",
		"placement_bounds": [
			{"x_min": -30.0, "x_max": 30.0, "z_min": -36.0, "z_max": -23.0},
		],
	},
}

const CONNECTOR_SPECS := {
	"SET01_CON_S01_S02_MAIN": {
		"id": "SET01_CON_S01_S02_MAIN",
		"section_a": "SET01_S01",
		"section_b": "SET01_S02",
		"center_x": 0.0,
		"center_z": 14.0,
		"clear_width_m": 8.0,
	},
	"SET01_CON_S02_S05_MAIN": {
		"id": "SET01_CON_S02_S05_MAIN",
		"section_a": "SET01_S02",
		"section_b": "SET01_S05",
		"center_x": 0.0,
		"center_z": -14.0,
		"clear_width_m": 8.0,
	},
	"SET01_CON_S02_S03": {
		"id": "SET01_CON_S02_S03",
		"section_a": "SET01_S02",
		"section_b": "SET01_S03",
		"center_x": -14.0,
		"center_z": 0.0,
		"clear_width_m": 5.0,
	},
	"SET01_CON_S02_S04": {
		"id": "SET01_CON_S02_S04",
		"section_a": "SET01_S02",
		"section_b": "SET01_S04",
		"center_x": 14.0,
		"center_z": 0.0,
		"clear_width_m": 5.0,
	},
}

const BUILDING_SPECS := {
	"SET01_BLD_SOUTH_GATEHOUSE_W": {
		"id": "SET01_BLD_SOUTH_GATEHOUSE_W",
		"section_id": "SET01_S01",
		"area_id": "SET01_A01_SOUTH_ARRIVAL_GATE",
		"center_x": -8.0,
		"center_z": 29.0,
		"width_m": 8.0,
		"depth_m": 7.0,
	},
	"SET01_BLD_SOUTH_WATCH_E": {
		"id": "SET01_BLD_SOUTH_WATCH_E",
		"section_id": "SET01_S01",
		"area_id": "SET01_A01_SOUTH_ARRIVAL_GATE",
		"center_x": 8.0,
		"center_z": 29.0,
		"width_m": 6.0,
		"depth_m": 6.0,
	},
	"SET01_BLD_ARRIVAL_GUARD": {
		"id": "SET01_BLD_ARRIVAL_GUARD",
		"section_id": "SET01_S01",
		"area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
		"center_x": -20.0,
		"center_z": 23.0,
		"width_m": 7.0,
		"depth_m": 6.0,
	},
	"SET01_BLD_ARRIVAL_STORAGE": {
		"id": "SET01_BLD_ARRIVAL_STORAGE",
		"section_id": "SET01_S01",
		"area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
		"center_x": 20.0,
		"center_z": 23.0,
		"width_m": 7.0,
		"depth_m": 6.0,
	},
	"SET01_BLD_COMMUNITY_HALL": {
		"id": "SET01_BLD_COMMUNITY_HALL",
		"section_id": "SET01_S03",
		"area_id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
		"center_x": -24.5,
		"center_z": 0.0,
		"width_m": 8.0,
		"depth_m": 10.0,
	},
	"SET01_BLD_RES_W01": {
		"id": "SET01_BLD_RES_W01",
		"section_id": "SET01_S03",
		"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"center_x": -24.5,
		"center_z": 10.0,
		"width_m": 7.0,
		"depth_m": 5.5,
	},
	"SET01_BLD_RES_W02": {
		"id": "SET01_BLD_RES_W02",
		"section_id": "SET01_S03",
		"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"center_x": -24.5,
		"center_z": -10.0,
		"width_m": 7.0,
		"depth_m": 5.5,
	},
	"SET01_BLD_SMITH": {
		"id": "SET01_BLD_SMITH",
		"section_id": "SET01_S04",
		"area_id": "SET01_A09_SMITHY_CRAFT_QUARTER",
		"center_x": 24.5,
		"center_z": 0.0,
		"width_m": 6.6,
		"depth_m": 6.4,
	},
	"SET01_BLD_WORK_STORAGE": {
		"id": "SET01_BLD_WORK_STORAGE",
		"section_id": "SET01_S04",
		"area_id": "SET01_A10_STORAGE_WORKSHOP_YARD",
		"center_x": 24.5,
		"center_z": 9.5,
		"width_m": 7.0,
		"depth_m": 6.0,
	},
	"SET01_BLD_WORK_CANOPY": {
		"id": "SET01_BLD_WORK_CANOPY",
		"section_id": "SET01_S04",
		"area_id": "SET01_A10_STORAGE_WORKSHOP_YARD",
		"center_x": 24.5,
		"center_z": -9.5,
		"width_m": 7.0,
		"depth_m": 6.0,
	},
	"SET01_BLD_HUNTER_WATCH": {
		"id": "SET01_BLD_HUNTER_WATCH",
		"section_id": "SET01_S05",
		"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"center_x": -19.0,
		"center_z": -27.0,
		"width_m": 7.0,
		"depth_m": 7.0,
	},
	"SET01_BLD_SUPPLY_CACHE": {
		"id": "SET01_BLD_SUPPLY_CACHE",
		"section_id": "SET01_S05",
		"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"center_x": 19.0,
		"center_z": -27.0,
		"width_m": 7.0,
		"depth_m": 6.0,
	},
}

static func get_schema() -> String:
	return SCHEMA

static func get_settlement_bounds() -> Dictionary:
	return SETTLEMENT_BOUNDS.duplicate(true)

static func get_section_specs() -> Dictionary:
	return SECTION_SPECS.duplicate(true)

static func get_area_specs() -> Dictionary:
	return AREA_SPECS.duplicate(true)

static func get_connector_specs() -> Dictionary:
	return CONNECTOR_SPECS.duplicate(true)

static func get_building_specs() -> Dictionary:
	return BUILDING_SPECS.duplicate(true)

static func get_shared_infrastructure_specs() -> Dictionary:
	return {
		"main_spine": MAIN_SPINE.duplicate(true),
		"central_cross_street": CENTRAL_CROSS_STREET.duplicate(true),
		"west_frontage_lane": WEST_FRONTAGE_LANE.duplicate(true),
		"east_frontage_lane": EAST_FRONTAGE_LANE.duplicate(true),
	}

static func _bounds_valid(bounds: Dictionary) -> bool:
	return (
		float(bounds.get("x_min", 0.0)) < float(bounds.get("x_max", 0.0))
		and float(bounds.get("z_min", 0.0)) < float(bounds.get("z_max", 0.0))
	)

static func _bounds_inside(inner: Dictionary, outer: Dictionary) -> bool:
	return (
		float(inner.get("x_min", 0.0)) >= float(outer.get("x_min", 0.0))
		and float(inner.get("x_max", 0.0)) <= float(outer.get("x_max", 0.0))
		and float(inner.get("z_min", 0.0)) >= float(outer.get("z_min", 0.0))
		and float(inner.get("z_max", 0.0)) <= float(outer.get("z_max", 0.0))
	)

static func _building_bounds(spec: Dictionary) -> Dictionary:
	var half_width := float(spec.get("width_m", 0.0)) * 0.5
	var half_depth := float(spec.get("depth_m", 0.0)) * 0.5
	var center_x := float(spec.get("center_x", 0.0))
	var center_z := float(spec.get("center_z", 0.0))
	return {
		"x_min": center_x - half_width,
		"x_max": center_x + half_width,
		"z_min": center_z - half_depth,
		"z_max": center_z + half_depth,
	}

static func validate_contract() -> Dictionary:
	var errors: Array[String] = []

	if not _bounds_valid(SETTLEMENT_BOUNDS):
		errors.append("settlement bounds are invalid")

	for section_variant in SECTION_SPECS.keys():
		var section_id := String(section_variant)
		var section := SECTION_SPECS[section_id] as Dictionary
		if String(section.get("id", "")) != section_id:
			errors.append("section key/id mismatch: %s" % section_id)
		var bounds := section.get("bounds", {}) as Dictionary
		if not _bounds_valid(bounds):
			errors.append("section has invalid bounds: %s" % section_id)
		elif not _bounds_inside(bounds, SETTLEMENT_BOUNDS):
			errors.append("section escapes settlement bounds: %s" % section_id)

	for area_variant in AREA_SPECS.keys():
		var area_id := String(area_variant)
		var area := AREA_SPECS[area_id] as Dictionary
		if String(area.get("id", "")) != area_id:
			errors.append("area key/id mismatch: %s" % area_id)

		var ownership := String(area.get("ownership", ""))
		var parent_section_id := String(area.get("parent_section_id", ""))
		if ownership == OWNERSHIP_SECTION_SUBAREA:
			if parent_section_id.is_empty():
				errors.append("section-owned area has empty parent: %s" % area_id)
			elif not SECTION_SPECS.has(parent_section_id):
				errors.append("area references unknown parent section: %s -> %s" % [area_id, parent_section_id])
			elif area.has("traversed_section_ids"):
				errors.append("section-owned area declares shared traversal: %s" % area_id)
			elif area.get("placement_bounds", []).is_empty():
				errors.append("area has no placement bounds: %s" % area_id)
			else:
				var parent_bounds := (SECTION_SPECS[parent_section_id] as Dictionary).get("bounds", {}) as Dictionary
				for bounds_variant in area.get("placement_bounds", []):
					var bounds := bounds_variant as Dictionary
					if not _bounds_valid(bounds):
						errors.append("area has invalid placement bounds: %s" % area_id)
					elif not _bounds_inside(bounds, parent_bounds):
						errors.append("area placement escapes parent section: %s" % area_id)
		elif ownership == OWNERSHIP_SHARED_INFRASTRUCTURE:
			if not parent_section_id.is_empty():
				errors.append("shared area must not claim one parent section: %s" % area_id)
			if area.get("placement_bounds", []).is_empty():
				errors.append("shared area has no placement bounds: %s" % area_id)
			for traversed_variant in area.get("traversed_section_ids", []):
				var traversed_id := String(traversed_variant)
				if not SECTION_SPECS.has(traversed_id):
					errors.append("shared area references unknown traversed section: %s -> %s" % [area_id, traversed_id])
			for bounds_variant in area.get("placement_bounds", []):
				var bounds := bounds_variant as Dictionary
				if not _bounds_valid(bounds) or not _bounds_inside(bounds, SETTLEMENT_BOUNDS):
					errors.append("shared area has invalid settlement placement: %s" % area_id)
		else:
			errors.append("area has unknown ownership: %s" % area_id)

	for connector_variant in CONNECTOR_SPECS.keys():
		var connector_id := String(connector_variant)
		var connector := CONNECTOR_SPECS[connector_id] as Dictionary
		if String(connector.get("id", "")) != connector_id:
			errors.append("connector key/id mismatch: %s" % connector_id)
		var section_a := String(connector.get("section_a", ""))
		var section_b := String(connector.get("section_b", ""))
		if not SECTION_SPECS.has(section_a) or not SECTION_SPECS.has(section_b):
			errors.append("connector references unknown section: %s" % connector_id)
		if section_a == section_b:
			errors.append("connector loops to same section: %s" % connector_id)
		if float(connector.get("clear_width_m", 0.0)) <= 0.0:
			errors.append("connector has non-positive width: %s" % connector_id)

	for building_variant in BUILDING_SPECS.keys():
		var building_id := String(building_variant)
		var building := BUILDING_SPECS[building_id] as Dictionary
		if String(building.get("id", "")) != building_id:
			errors.append("building key/id mismatch: %s" % building_id)
		var section_id := String(building.get("section_id", ""))
		var area_id := String(building.get("area_id", ""))
		if not SECTION_SPECS.has(section_id):
			errors.append("building references unknown section: %s" % building_id)
			continue
		if not AREA_SPECS.has(area_id):
			errors.append("building references unknown area: %s" % building_id)
			continue
		var area := AREA_SPECS[area_id] as Dictionary
		if String(area.get("ownership", "")) == OWNERSHIP_SECTION_SUBAREA and String(area.get("parent_section_id", "")) != section_id:
			errors.append("building section disagrees with area parent: %s" % building_id)
		var building_bounds := _building_bounds(building)
		var section_bounds := (SECTION_SPECS[section_id] as Dictionary).get("bounds", {}) as Dictionary
		if not _bounds_valid(building_bounds) or not _bounds_inside(building_bounds, section_bounds):
			errors.append("building escapes section bounds: %s" % building_id)

	var banned_tokens := ["worldlife", "shooter_rpg", "monster_choice"]
	for id_variant in SECTION_SPECS.keys() + AREA_SPECS.keys() + CONNECTOR_SPECS.keys() + BUILDING_SPECS.keys():
		var stable_id := String(id_variant).to_lower()
		for banned in banned_tokens:
			if banned in stable_id:
				errors.append("settlement contract imports abandoned-project identity: %s" % id_variant)

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"schema": SCHEMA,
		"settlement_id": SETTLEMENT_ID,
		"section_count": SECTION_SPECS.size(),
		"area_count": AREA_SPECS.size(),
		"connector_count": CONNECTOR_SPECS.size(),
		"building_count": BUILDING_SPECS.size(),
	}
