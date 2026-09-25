class_name PixelRPGFirstPersonCameraMath001
extends RefCounted

const SCHEMA := "pixel_rpg.first_person_camera_math_001.v1"

static func get_schema() -> String:
	return SCHEMA

static func camera_relative_movement(camera_basis: Basis, input_vector: Vector2) -> Vector3:
	if input_vector.length_squared() <= 0.0001:
		return Vector3.ZERO

	var right := camera_basis.x
	right.y = 0.0
	right = right.normalized()

	var forward := -camera_basis.z
	forward.y = 0.0
	forward = forward.normalized()

	return (right * input_vector.x + forward * -input_vector.y).normalized()

static func apply_look_delta(
	current_yaw_rad: float,
	current_pitch_rad: float,
	delta_px: Vector2,
	degrees_per_pixel: float,
	pitch_min_deg: float,
	pitch_max_deg: float
) -> Vector2:
	var next_yaw := current_yaw_rad - deg_to_rad(delta_px.x * degrees_per_pixel)
	var next_pitch := current_pitch_rad - deg_to_rad(delta_px.y * degrees_per_pixel)
	next_pitch = clampf(next_pitch, deg_to_rad(pitch_min_deg), deg_to_rad(pitch_max_deg))
	return Vector2(next_yaw, next_pitch)

static func apply_camera_rotation(
	camera_yaw: Node3D,
	camera_pitch: Node3D,
	yaw_rad: float,
	pitch_rad: float
) -> void:
	if camera_yaw != null:
		camera_yaw.rotation.y = yaw_rad
	if camera_pitch != null:
		camera_pitch.rotation.x = pitch_rad
