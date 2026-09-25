class_name PixelRPGHudLayout001
extends RefCounted

const SCHEMA := "pixel_rpg.hud_layout_001.v1"

static func get_schema() -> String:
	return SCHEMA

static func calculate(
	viewport_size: Vector2,
	window_size: Vector2i,
	safe_rect: Rect2i,
	edge_margin: float
) -> Dictionary:
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return {}

	var left_safe := 0.0
	var top_safe := 0.0
	var right_safe := 0.0
	var bottom_safe := 0.0

	if window_size.x > 0 and window_size.y > 0 and safe_rect.size.x > 0 and safe_rect.size.y > 0:
		var scale := Vector2(
			viewport_size.x / float(window_size.x),
			viewport_size.y / float(window_size.y)
		)
		left_safe = maxf(0.0, float(safe_rect.position.x) * scale.x)
		top_safe = maxf(0.0, float(safe_rect.position.y) * scale.y)
		right_safe = maxf(0.0, float(window_size.x - safe_rect.end.x) * scale.x)
		bottom_safe = maxf(0.0, float(window_size.y - safe_rect.end.y) * scale.y)

	var left := maxf(24.0, left_safe + edge_margin)
	var top := maxf(22.0, top_safe + edge_margin)
	var right := maxf(24.0, right_safe + edge_margin)
	var bottom := maxf(24.0, bottom_safe + edge_margin)

	var available_width := maxf(320.0, viewport_size.x - left - right)
	var available_height := maxf(240.0, viewport_size.y - top - bottom)

	var status_width := minf(250.0, available_width * 0.34)
	var objective_width := minf(470.0, available_width * 0.48)
	var panel_width := minf(660.0, available_width - 32.0)
	var panel_height := minf(460.0, available_height - 28.0)
	var settings_width := minf(520.0, available_width - 40.0)
	var settings_height := minf(340.0, available_height - 36.0)
	var targeting_width := minf(380.0, available_width * 0.44)
	var targeting_height := minf(470.0, available_height - 36.0)

	return {
		"margins": Vector4(left, top, right, bottom),
		"available_size": Vector2(available_width, available_height),
		"status_offsets": Rect2(left, top, status_width, 82.0),
		"objective_offsets": Rect2(left, top + 96.0, objective_width, 78.0),
		"settings_button_offsets": Rect2(-86.0, top, 172.0, 60.0),
		"minimap_offsets": Rect2(-right - 222.0, top, 222.0, 166.0),
		"watch_button_offsets": Rect2(-right - 180.0, top + 178.0, 180.0, 64.0),
		"joystick_offsets": Rect2(left + 10.0, -bottom - 204.0, 204.0, 204.0),
		"action_button_offsets": Rect2(-right - 218.0, -bottom - 150.0, 218.0, 94.0),
		"prompt_offsets": Rect2(0.0, -bottom - 118.0, 0.0, 46.0),
		"watch_panel_offsets": Rect2(-panel_width * 0.5, -panel_height * 0.5, panel_width, panel_height),
		"settings_panel_offsets": Rect2(-settings_width * 0.5, -settings_height * 0.5, settings_width, settings_height),
		"targeting_panel_offsets": Rect2(
			-right - targeting_width,
			-targeting_height * 0.5,
			targeting_width,
			targeting_height
		),
	}

static func apply_offsets(control: Control, offsets: Rect2) -> void:
	if control == null:
		return
	control.offset_left = offsets.position.x
	control.offset_top = offsets.position.y
	control.offset_right = offsets.position.x + offsets.size.x
	control.offset_bottom = offsets.position.y + offsets.size.y
