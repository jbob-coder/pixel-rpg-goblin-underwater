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
	var normalized_x := clampf(
		inverse_lerp(WORLD_MIN_X, WORLD_MAX_X, world_position.x),
		0.0,
		1.0
	)
	var normalized_z := clampf(
		inverse_lerp(WORLD_MIN_Z, WORLD_MAX_Z, world_position.z),
		0.0,
		1.0
	)
	return Vector2(
		normalized_x * maxf(map_size.x - marker_size.x, 0.0),
		normalized_z * maxf(map_size.y - marker_size.y, 0.0)
	)
