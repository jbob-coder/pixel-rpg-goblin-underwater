class_name PixelRPGSettlement01MinimapContract
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_minimap_contract.v1"

const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const MINIMAP_MATH := preload("res://scripts/presentation/pixel_rpg/minimap_math_001.gd")

static func get_schema() -> String:
	return SCHEMA

static func get_world_bounds() -> Dictionary:
	var infrastructure: Dictionary = LAYOUT.get_infrastructure_specs()
	return ((infrastructure.get("settlement_envelope", {}) as Dictionary).get("bounds", {}) as Dictionary).duplicate(true)

static func get_section_shapes() -> Array[Dictionary]:
	var sections: Dictionary = LAYOUT.get_section_specs()
	var ids := sections.keys()
	ids.sort()
	var result: Array[Dictionary] = []
	for id_variant in ids:
		var section_id := String(id_variant)
		var section := sections[section_id] as Dictionary
		result.append({
			"section_id": section_id,
			"bounds": (section.get("bounds", {}) as Dictionary).duplicate(true),
		})
	return result

static func get_area_landmarks() -> Array[Dictionary]:
	var areas: Dictionary = LAYOUT.get_area_specs()
	var ids := areas.keys()
	ids.sort()
	var result: Array[Dictionary] = []
	for id_variant in ids:
		var area_id := String(id_variant)
		var area := areas[area_id] as Dictionary
		result.append({
			"area_id": area_id,
			"parent_section_id": String(area.get("parent_section_id", "")),
			"kind": String(area.get("kind", "")),
			"center_xz": _bounds_parts_center(area.get("bounds_parts", []) as Array),
		})
	return result

static func get_building_markers() -> Array[Dictionary]:
	var buildings: Dictionary = LAYOUT.get_building_specs()
	var ids := buildings.keys()
	ids.sort()
	var result: Array[Dictionary] = []
	for id_variant in ids:
		var building_id := String(id_variant)
		var building := buildings[building_id] as Dictionary
		result.append({
			"building_id": building_id,
			"section_id": String(building.get("section_id", "")),
			"area_id": String(building.get("area_id", "")),
			"center_xz": building.get("center_xz", Vector2.ZERO),
			"footprint_xz": building.get("footprint_xz", Vector2.ZERO),
		})
	return result

static func get_gate_markers() -> Array[Dictionary]:
	var infrastructure: Dictionary = LAYOUT.get_infrastructure_specs()
	return [
		{
			"gate_id": "SET01_GATE_SOUTH",
			"center_xz": (infrastructure.get("south_gate", {}) as Dictionary).get("center_xz", Vector2.ZERO),
			"clear_width_m": float((infrastructure.get("south_gate", {}) as Dictionary).get("clear_width_m", 0.0)),
		},
		{
			"gate_id": "SET01_GATE_NORTH",
			"center_xz": (infrastructure.get("north_gate", {}) as Dictionary).get("center_xz", Vector2.ZERO),
			"clear_width_m": float((infrastructure.get("north_gate", {}) as Dictionary).get("clear_width_m", 0.0)),
		},
	]

static func get_road_shapes() -> Array[Dictionary]:
	var infrastructure: Dictionary = LAYOUT.get_infrastructure_specs()
	var main_spine := infrastructure.get("main_spine", {}) as Dictionary
	var cross_street := infrastructure.get("central_cross_street", {}) as Dictionary
	var west_frontage := infrastructure.get("west_frontage_lane", {}) as Dictionary
	var east_frontage := infrastructure.get("east_frontage_lane", {}) as Dictionary
	return [
		{
			"road_id": "SET01_ROAD_MAIN_SPINE",
			"bounds": (main_spine.get("bounds", {}) as Dictionary).duplicate(true),
			"width_m": float(main_spine.get("width_m", 0.0)),
		},
		{
			"road_id": "SET01_ROAD_CENTRAL_CROSS",
			"bounds": (cross_street.get("bounds", {}) as Dictionary).duplicate(true),
			"width_m": float(cross_street.get("width_m", 0.0)),
		},
		{
			"road_id": "SET01_ROAD_WEST_FRONTAGE",
			"bounds": _frontage_bounds(west_frontage),
			"width_m": float(west_frontage.get("width_m", 0.0)),
		},
		{
			"road_id": "SET01_ROAD_EAST_FRONTAGE",
			"bounds": _frontage_bounds(east_frontage),
			"width_m": float(east_frontage.get("width_m", 0.0)),
		},
	]

static func normalized_position(world_xz: Vector2) -> Vector2:
	var bounds := get_world_bounds()
	return Vector2(
		clampf(inverse_lerp(float(bounds.get("min_x", 0.0)), float(bounds.get("max_x", 0.0)), world_xz.x), 0.0, 1.0),
		clampf(inverse_lerp(float(bounds.get("min_z", 0.0)), float(bounds.get("max_z", 0.0)), world_xz.y), 0.0, 1.0)
	)

static func marker_position(world_position: Vector3, map_size: Vector2, marker_size: Vector2) -> Vector2:
	return MINIMAP_MATH.marker_position_in_bounds(
		world_position,
		get_world_bounds(),
		map_size,
		marker_size
	)

static func validate_contract() -> Dictionary:
	var errors: Array[String] = []
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	if not bool(layout_validation.get("success", false)):
		errors.append("G00 layout contract is invalid")

	var bounds := get_world_bounds()
	if not _valid_bounds(bounds):
		errors.append("settlement minimap world bounds are invalid")

	var section_shapes := get_section_shapes()
	var area_landmarks := get_area_landmarks()
	var building_markers := get_building_markers()
	var gate_markers := get_gate_markers()
	var road_shapes := get_road_shapes()

	if section_shapes.size() != 5:
		errors.append("expected 5 settlement section shapes")
	if area_landmarks.size() != 12:
		errors.append("expected 12 settlement area landmarks")
	if building_markers.size() != 12:
		errors.append("expected 12 settlement building markers")
	if gate_markers.size() != 2:
		errors.append("expected 2 settlement gate markers")
	if road_shapes.size() != 4:
		errors.append("expected 4 settlement road shapes")

	for marker in area_landmarks:
		var center := marker.get("center_xz", Vector2.ZERO) as Vector2
		if not _point_inside(bounds, center):
			errors.append("area landmark escapes settlement minimap bounds: %s" % String(marker.get("area_id", "")))

	for marker in building_markers:
		var center := marker.get("center_xz", Vector2.ZERO) as Vector2
		if not _point_inside(bounds, center):
			errors.append("building marker escapes settlement minimap bounds: %s" % String(marker.get("building_id", "")))

	for marker in gate_markers:
		var center := marker.get("center_xz", Vector2.ZERO) as Vector2
		if not _point_inside(bounds, center):
			errors.append("gate marker escapes settlement minimap bounds: %s" % String(marker.get("gate_id", "")))

	for road in road_shapes:
		var road_bounds := road.get("bounds", {}) as Dictionary
		if not _bounds_inside(bounds, road_bounds):
			errors.append("road escapes settlement minimap bounds: %s" % String(road.get("road_id", "")))

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"schema": SCHEMA,
		"section_count": section_shapes.size(),
		"area_count": area_landmarks.size(),
		"building_count": building_markers.size(),
		"gate_count": gate_markers.size(),
		"road_count": road_shapes.size(),
		"world_bounds": bounds,
	}

static func _bounds_parts_center(parts: Array) -> Vector2:
	if parts.is_empty():
		return Vector2.ZERO
	var min_x := INF
	var max_x := -INF
	var min_z := INF
	var max_z := -INF
	for part_variant in parts:
		var part := part_variant as Dictionary
		min_x = minf(min_x, float(part.get("min_x", 0.0)))
		max_x = maxf(max_x, float(part.get("max_x", 0.0)))
		min_z = minf(min_z, float(part.get("min_z", 0.0)))
		max_z = maxf(max_z, float(part.get("max_z", 0.0)))
	return Vector2((min_x + max_x) * 0.5, (min_z + max_z) * 0.5)

static func _frontage_bounds(spec: Dictionary) -> Dictionary:
	var center_x := float(spec.get("center_x", 0.0))
	var width_m := float(spec.get("width_m", 0.0))
	var half_width := width_m * 0.5
	return {
		"min_x": center_x - half_width,
		"max_x": center_x + half_width,
		"min_z": float(spec.get("min_z", 0.0)),
		"max_z": float(spec.get("max_z", 0.0)),
	}

static func _valid_bounds(bounds: Dictionary) -> bool:
	return (
		float(bounds.get("max_x", 0.0)) > float(bounds.get("min_x", 0.0))
		and float(bounds.get("max_z", 0.0)) > float(bounds.get("min_z", 0.0))
	)

static func _point_inside(bounds: Dictionary, point: Vector2, epsilon := 0.001) -> bool:
	return (
		point.x >= float(bounds.get("min_x", 0.0)) - epsilon
		and point.x <= float(bounds.get("max_x", 0.0)) + epsilon
		and point.y >= float(bounds.get("min_z", 0.0)) - epsilon
		and point.y <= float(bounds.get("max_z", 0.0)) + epsilon
	)

static func _bounds_inside(outer: Dictionary, inner: Dictionary, epsilon := 0.001) -> bool:
	return (
		float(inner.get("min_x", 0.0)) >= float(outer.get("min_x", 0.0)) - epsilon
		and float(inner.get("max_x", 0.0)) <= float(outer.get("max_x", 0.0)) + epsilon
		and float(inner.get("min_z", 0.0)) >= float(outer.get("min_z", 0.0)) - epsilon
		and float(inner.get("max_z", 0.0)) <= float(outer.get("max_z", 0.0)) + epsilon
	)
