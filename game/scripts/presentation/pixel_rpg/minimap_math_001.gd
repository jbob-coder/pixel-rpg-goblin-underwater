class_name PixelRPGMinimapMath001
extends RefCounted

const SCHEMA := "pixel_rpg.minimap_math_001.v1"

const WORLD_MIN_X := -23.0
const WORLD_MAX_X := 23.0
const WORLD_MIN_Z := -57.0
const WORLD_MAX_Z := 20.0

static func get_schema() -> String:
	return SCHEMA

static func marker_position(
	world_position: Vector3,
	map_size: Vector2,
	marker_size: Vector2
) -> Vector2:
	return marker_position_in_bounds(
		world_position,
		{
			"min_x": WORLD_MIN_X,
			"max_x": WORLD_MAX_X,
			"min_z": WORLD_MIN_Z,
			"max_z": WORLD_MAX_Z,
		},
		map_size,
		marker_size
	)

static func marker_position_in_bounds(
	world_position: Vector3,
	world_bounds: Dictionary,
	map_size: Vector2,
	marker_size: Vector2
) -> Vector2:
	var min_x := float(world_bounds.get("min_x", WORLD_MIN_X))
	var max_x := float(world_bounds.get("max_x", WORLD_MAX_X))
	var min_z := float(world_bounds.get("min_z", WORLD_MIN_Z))
	var max_z := float(world_bounds.get("max_z", WORLD_MAX_Z))

	var normalized_x := clampf(
		inverse_lerp(min_x, max_x, world_position.x),
		0.0,
		1.0
	)
	var normalized_z := clampf(
		inverse_lerp(min_z, max_z, world_position.z),
		0.0,
		1.0
	)
	return Vector2(
		normalized_x * maxf(map_size.x - marker_size.x, 0.0),
		normalized_z * maxf(map_size.y - marker_size.y, 0.0)
	)
