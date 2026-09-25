class_name PixelRPGPlayerMotionMath001
extends RefCounted

const SCHEMA := "pixel_rpg.player_motion_math_001.v1"
const FLOOR_STICK_VELOCITY_Y := -0.1
const VISUAL_TURN_RATE := 12.0
const VISUAL_MOVE_EPSILON_SQ := 0.002

static func get_schema() -> String:
	return SCHEMA

static func apply_horizontal_velocity(current_velocity: Vector3, move_world: Vector3, move_speed_mps: float) -> Vector3:
	var next_velocity := current_velocity
	next_velocity.x = move_world.x * move_speed_mps
	next_velocity.z = move_world.z * move_speed_mps
	return next_velocity

static func apply_vertical_velocity(
	current_velocity_y: float,
	is_on_floor: bool,
	delta: float,
	gravity_mps2: float
) -> float:
	if not is_on_floor:
		return current_velocity_y - gravity_mps2 * maxf(delta, 0.0)
	if current_velocity_y < 0.0:
		return FLOOR_STICK_VELOCITY_Y
	return current_velocity_y

static func visual_yaw(
	current_yaw: float,
	move_world: Vector3,
	delta: float
) -> float:
	if move_world.length_squared() <= VISUAL_MOVE_EPSILON_SQ:
		return current_yaw
	var target_yaw := atan2(move_world.x, move_world.z)
	return lerp_angle(current_yaw, target_yaw, clampf(delta * VISUAL_TURN_RATE, 0.0, 1.0))

static func should_respawn(current_y: float, respawn_y_m: float) -> bool:
	return current_y < respawn_y_m
