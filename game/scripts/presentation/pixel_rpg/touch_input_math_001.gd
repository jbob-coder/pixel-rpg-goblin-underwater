class_name PixelRPGTouchInputMath001
extends RefCounted

const SCHEMA := "pixel_rpg.touch_input_math_001.v1"
const JOYSTICK_RADIUS_RATIO := 0.34

static func get_schema() -> String:
	return SCHEMA

static func is_in_look_region(screen_position: Vector2, viewport_size: Vector2, look_region_start_x_ratio: float) -> bool:
	return screen_position.x >= viewport_size.x * look_region_start_x_ratio

static func joystick_sample(
	screen_position: Vector2,
	base_rect: Rect2,
	knob_size: Vector2,
	deadzone: float
) -> Dictionary:
	var center := base_rect.position + base_rect.size * 0.5
	var radius := minf(base_rect.size.x, base_rect.size.y) * JOYSTICK_RADIUS_RATIO
	var offset := screen_position - center
	if offset.length() > radius:
		offset = offset.normalized() * radius

	var normalized := offset / maxf(radius, 1.0)
	if normalized.length() < deadzone:
		normalized = Vector2.ZERO

	return {
		"vector": normalized,
		"offset": offset,
		"radius": radius,
		"knob_position": base_rect.size * 0.5 - knob_size * 0.5 + offset,
	}

static func joystick_center_position(base_size: Vector2, knob_size: Vector2) -> Vector2:
	return base_size * 0.5 - knob_size * 0.5
