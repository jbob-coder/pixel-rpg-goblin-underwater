class_name PixelRPGFirstPersonCameraState001
extends RefCounted

const SCHEMA := "pixel_rpg.first_person_camera_state_001.v1"
const CameraMath001 := preload("res://scripts/presentation/pixel_rpg/first_person_camera_math_001.gd")

var _camera_yaw_rad := 0.0
var _camera_pitch_rad := 0.0

func get_schema() -> String:
	return SCHEMA

func set_rotation(yaw_rad: float, pitch_rad: float) -> void:
	_camera_yaw_rad = yaw_rad
	_camera_pitch_rad = pitch_rad

func get_yaw_rad() -> float:
	return _camera_yaw_rad

func get_pitch_rad() -> float:
	return _camera_pitch_rad

func apply_look_delta(
	delta_px: Vector2,
	degrees_per_pixel: float,
	pitch_min_deg: float,
	pitch_max_deg: float
) -> Vector2:
	var next_rotation := CameraMath001.apply_look_delta(
		_camera_yaw_rad,
		_camera_pitch_rad,
		delta_px,
		degrees_per_pixel,
		pitch_min_deg,
		pitch_max_deg
	)
	_camera_yaw_rad = next_rotation.x
	_camera_pitch_rad = next_rotation.y
	return next_rotation

func apply_to_nodes(camera_yaw: Node3D, camera_pitch: Node3D) -> void:
	CameraMath001.apply_camera_rotation(
		camera_yaw,
		camera_pitch,
		_camera_yaw_rad,
		_camera_pitch_rad
	)
