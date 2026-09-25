class_name PixelRPGPlayerMotor001
extends RefCounted

const SCHEMA := "pixel_rpg.player_motor_001.v1"

const PlayerMotionMath001 := preload("res://scripts/presentation/pixel_rpg/player_motion_math_001.gd")

static func get_schema() -> String:
	return SCHEMA

static func step(
	hunter: CharacterBody3D,
	hunter_visual: Node3D,
	move_world: Vector3,
	delta: float,
	move_speed_mps: float,
	gravity_mps2: float,
	respawn_y_m: float,
	player_start: Vector3
) -> Dictionary:
	if hunter == null:
		return {
			"applied": false,
			"respawned": false,
		}

	hunter.velocity = PlayerMotionMath001.apply_horizontal_velocity(
		hunter.velocity,
		move_world,
		move_speed_mps
	)
	hunter.velocity.y = PlayerMotionMath001.apply_vertical_velocity(
		hunter.velocity.y,
		hunter.is_on_floor(),
		delta,
		gravity_mps2
	)

	hunter.move_and_slide()

	if hunter_visual != null:
		hunter_visual.rotation.y = PlayerMotionMath001.visual_yaw(
			hunter_visual.rotation.y,
			move_world,
			delta
		)

	var respawned := PlayerMotionMath001.should_respawn(
		hunter.global_position.y,
		respawn_y_m
	)
	if respawned:
		hunter.global_position = player_start
		hunter.velocity = Vector3.ZERO

	return {
		"applied": true,
		"respawned": respawned,
		"position": hunter.global_position,
		"velocity": hunter.velocity,
	}
