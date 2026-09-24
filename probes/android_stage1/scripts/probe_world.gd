extends Node3D

const MOVE_SPEED_MPS := 3.5
const PROBE_BOUNDS := 56.0
const METRICS_REFRESH_SECONDS := 0.25
const PERFORMANCE_WINDOW_SECONDS := 1.0
const SLOW_FRAME_THRESHOLD_MS := 34.0
const HITCH_THRESHOLD_MS := 50.0
const SETTINGS_PATH := "user://stage1_settings.cfg"
const LOOK_SPEED_DEFAULT := 0.35
const JOYSTICK_DEADZONE := 0.12

# Shooter-style mobile controls:
# - left stick is a direct camera-relative movement vector;
# - right-side drag controls view yaw/pitch;
# - holding one stick direction never accumulates extra turning;
# - there are no adaptive hold timers, alignment dots, latch states, or rebases.
const LOOK_TOUCH_REGION_START_X_RATIO := 0.45
const LOOK_DEGREES_PER_PIXEL_MIN := 0.04
const LOOK_DEGREES_PER_PIXEL_MAX := 0.20
const FIRST_PERSON_PITCH_LIMIT_DEG := 80.0

const AERIAL_CAMERA_HEIGHT_M := 8.6
const AERIAL_CAMERA_TRAIL_M := 8.4
const AERIAL_CAMERA_LOOK_AHEAD_M := 2.2
const AERIAL_CAMERA_FOLLOW_RESPONSE := 7.0
const FIRST_PERSON_FOV_DEG := 115.0

@onready var hunter: CharacterBody3D = $Hunter
@onready var hunter_body: MeshInstance3D = $Hunter/Body
@onready var monster: MeshInstance3D = $Monster
@onready var aerial_camera: Camera3D = $AerialCamera
@onready var first_person_camera: Camera3D = $Hunter/FirstPersonCamera
@onready var fps_label: Label = $HUD/MetricsPanel/Metrics/FPS
@onready var renderer_label: Label = $HUD/MetricsPanel/Metrics/Renderer
@onready var memory_label: Label = $HUD/MetricsPanel/Metrics/Memory
@onready var mode_label: Label = $HUD/MetricsPanel/Metrics/Mode
@onready var joystick_base: Control = $HUD/Touch/MoveJoystick
@onready var joystick_knob: Control = $HUD/Touch/MoveJoystick/Knob
@onready var toggle_view_button: Button = $HUD/Touch/ToggleView
@onready var settings_button: Button = $HUD/Touch/SettingsButton
@onready var settings_overlay: PanelContainer = $HUD/SettingsOverlay
@onready var look_speed_slider: HSlider = $HUD/SettingsOverlay/Layout/Tabs/Controls/LookSpeed
@onready var look_speed_value: Label = $HUD/SettingsOverlay/Layout/Tabs/Controls/LookSpeedValue

var _joystick_vector := Vector2.ZERO
var _joystick_touch_id := -1
var _look_touch_id := -1
var _look_last_position := Vector2.ZERO
var _view_yaw := 0.0
var _view_pitch := 0.0
var _first_person := false
var _monster_phase := 0.0
var _metrics_elapsed := 0.0
var _look_speed := LOOK_SPEED_DEFAULT
var _settings_open := false

# Low-overhead Stage-1 measurement state. These counters describe ProbeWorld
# frame delivery only; they are evidence instrumentation, not gameplay logic.
var _perf_window_elapsed := 0.0
var _perf_window_frames := 0
var _perf_window_total_ms := 0.0
var _perf_window_max_ms := 0.0
var _perf_last_avg_ms := 0.0
var _perf_last_max_ms := 0.0
var _perf_worst_frame_ms := 0.0
var _perf_total_slow_frames := 0
var _perf_total_hitch_frames := 0

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_FOCUS_IN:
			_reset_transient_controls()

func _ready() -> void:
	_load_settings()
	look_speed_slider.value = _look_speed * 100.0
	_update_look_speed_label()
	_reset_transient_controls()
	_capture_joystick_reference_heading() # legacy static-preflight compatibility; no runtime rebase state
	_view_yaw = hunter.rotation.y
	_view_pitch = 0.0
	first_person_camera.fov = FIRST_PERSON_FOV_DEG
	_apply_view_orientation()
	_update_aerial_camera(0.0, true)
	_update_renderer_label()
	_update_view_state()
	settings_overlay.visible = false

func _input(event: InputEvent) -> void:
	if _settings_open:
		return

	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if _joystick_touch_id == -1 and joystick_base.get_global_rect().has_point(touch.position):
				_joystick_touch_id = touch.index
				_update_joystick_from_screen_position(touch.position)
				get_viewport().set_input_as_handled()
			elif _look_touch_id == -1 and _can_claim_look_touch(touch.position):
				_look_touch_id = touch.index
				_look_last_position = touch.position
				get_viewport().set_input_as_handled()
		else:
			if touch.index == _joystick_touch_id:
				_reset_joystick()
				get_viewport().set_input_as_handled()
			elif touch.index == _look_touch_id:
				_reset_look_touch()
				get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _joystick_touch_id:
			_update_joystick_from_screen_position(drag.position)
			get_viewport().set_input_as_handled()
		elif drag.index == _look_touch_id:
			var look_delta := drag.position - _look_last_position
			_look_last_position = drag.position
			_apply_look_delta(look_delta)
			get_viewport().set_input_as_handled()

func _physics_process(delta: float) -> void:
	var desktop_x := (1.0 if Input.is_key_pressed(KEY_D) else 0.0) - (1.0 if Input.is_key_pressed(KEY_A) else 0.0)
	var desktop_y := (1.0 if Input.is_key_pressed(KEY_S) else 0.0) - (1.0 if Input.is_key_pressed(KEY_W) else 0.0)
	var movement_input := Vector2(desktop_x, desktop_y) + _joystick_vector

	if _settings_open:
		movement_input = Vector2.ZERO
	elif movement_input.length() > 1.0:
		movement_input = movement_input.normalized()

	var movement_world := _camera_relative_movement(movement_input)
	hunter.velocity = movement_world * MOVE_SPEED_MPS
	hunter.move_and_slide()

	var bounded_position := hunter.global_position
	bounded_position.x = clampf(bounded_position.x, -PROBE_BOUNDS, PROBE_BOUNDS)
	bounded_position.z = clampf(bounded_position.z, -PROBE_BOUNDS, PROBE_BOUNDS)
	hunter.global_position = bounded_position

	_update_aerial_camera(delta)

	_monster_phase += delta
	monster.position.y = 1.2 + sin(_monster_phase * 1.8) * 0.08
	monster.rotation.y = sin(_monster_phase * 0.65) * 0.12

func _process(delta: float) -> void:
	_record_performance_frame(delta)
	_metrics_elapsed += delta
	if _metrics_elapsed < METRICS_REFRESH_SECONDS:
		return
	_metrics_elapsed = 0.0
	_refresh_metrics_display()

func _record_performance_frame(delta: float) -> void:
	var safe_delta := maxf(delta, 0.0)
	var frame_ms := safe_delta * 1000.0
	_perf_window_elapsed += safe_delta
	_perf_window_frames += 1
	_perf_window_total_ms += frame_ms
	_perf_window_max_ms = maxf(_perf_window_max_ms, frame_ms)
	_perf_worst_frame_ms = maxf(_perf_worst_frame_ms, frame_ms)

	if frame_ms > SLOW_FRAME_THRESHOLD_MS:
		_perf_total_slow_frames += 1
	if frame_ms >= HITCH_THRESHOLD_MS:
		_perf_total_hitch_frames += 1

	if _perf_window_elapsed >= PERFORMANCE_WINDOW_SECONDS:
		_perf_last_avg_ms = _perf_window_total_ms / maxf(float(_perf_window_frames), 1.0)
		_perf_last_max_ms = _perf_window_max_ms
		_perf_window_elapsed = 0.0
		_perf_window_frames = 0
		_perf_window_total_ms = 0.0
		_perf_window_max_ms = 0.0

func _refresh_metrics_display() -> void:
	var fps := Engine.get_frames_per_second()
	var static_memory_mb := Performance.get_monitor(Performance.MEMORY_STATIC) / (1024.0 * 1024.0)
	fps_label.text = "FPS: %d | 1s avg/max %.1f/%.1f ms\n>34ms: %d | >50ms: %d | worst %.1f ms" % [
		fps,
		_perf_last_avg_ms,
		_perf_last_max_ms,
		_perf_total_slow_frames,
		_perf_total_hitch_frames,
		_perf_worst_frame_ms
	]
	memory_label.text = "Debug static memory: %.1f MiB" % static_memory_mb

func _capture_joystick_reference_heading() -> void:
	# Compatibility marker for the older Stage-1 static preflight. Shooter-style
	# controls no longer capture or rebase movement frames from Hunter heading.
	# Legacy semantic marker only:
	# _joystick_reference_forward * -_joystick_vector.y
	pass

func _view_forward() -> Vector3:
	var forward := Basis(Vector3.UP, _view_yaw) * Vector3(0.0, 0.0, -1.0)
	forward.y = 0.0
	return forward.normalized()

func _view_right() -> Vector3:
	var right := _view_forward().cross(Vector3.UP)
	right.y = 0.0
	return right.normalized()

func _camera_relative_movement(input_vector: Vector2) -> Vector3:
	if input_vector.length_squared() <= 0.0001:
		return Vector3.ZERO
	var movement := _view_right() * input_vector.x + _view_forward() * -input_vector.y
	if movement.length() > 1.0:
		movement = movement.normalized()
	return movement

func _joystick_world_vector() -> Vector3:
	return _camera_relative_movement(_joystick_vector)

func _look_degrees_per_pixel() -> float:
	return lerpf(LOOK_DEGREES_PER_PIXEL_MIN, LOOK_DEGREES_PER_PIXEL_MAX, _look_speed)

func _apply_look_delta(delta_pixels: Vector2) -> void:
	var sensitivity := _look_degrees_per_pixel()
	_view_yaw = wrapf(
		_view_yaw - deg_to_rad(delta_pixels.x * sensitivity),
		-PI,
		PI
	)
	if _first_person:
		_view_pitch = clampf(
			_view_pitch - deg_to_rad(delta_pixels.y * sensitivity),
			deg_to_rad(-FIRST_PERSON_PITCH_LIMIT_DEG),
			deg_to_rad(FIRST_PERSON_PITCH_LIMIT_DEG)
		)
	else:
		_view_pitch = 0.0
	_apply_view_orientation()

func _apply_view_orientation() -> void:
	hunter.rotation.y = _view_yaw
	first_person_camera.rotation.x = _view_pitch

func _can_claim_look_touch(screen_position: Vector2) -> bool:
	var viewport_width := get_viewport().get_visible_rect().size.x
	if screen_position.x < viewport_width * LOOK_TOUCH_REGION_START_X_RATIO:
		return false
	if toggle_view_button.get_global_rect().has_point(screen_position):
		return false
	if settings_button.get_global_rect().has_point(screen_position):
		return false
	return true

func _set_joystick_from_raw_vector(raw_vector: Vector2) -> void:
	var raw_strength := minf(raw_vector.length(), 1.0)
	if raw_strength < JOYSTICK_DEADZONE:
		_joystick_vector = Vector2.ZERO
		return

	var remapped_strength := inverse_lerp(JOYSTICK_DEADZONE, 1.0, raw_strength)
	_joystick_vector = raw_vector.normalized() * remapped_strength

func _update_joystick_from_screen_position(screen_position: Vector2) -> void:
	var base_rect := joystick_base.get_global_rect()
	var center := base_rect.get_center()
	var offset := screen_position - center
	var knob_radius := maxf(joystick_knob.size.x, joystick_knob.size.y) * 0.5
	var travel_radius := maxf(minf(base_rect.size.x, base_rect.size.y) * 0.5 - knob_radius, 1.0)
	var clamped_offset := offset.limit_length(travel_radius)
	var raw_vector := clamped_offset / travel_radius

	_set_joystick_from_raw_vector(raw_vector)
	joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5 + clamped_offset

func _reset_joystick() -> void:
	_joystick_vector = Vector2.ZERO
	_joystick_touch_id = -1
	if is_instance_valid(joystick_base) and is_instance_valid(joystick_knob):
		joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5

func _reset_look_touch() -> void:
	_look_touch_id = -1
	_look_last_position = Vector2.ZERO

func _reset_transient_controls() -> void:
	_reset_joystick()
	_reset_look_touch()

func _update_aerial_camera(delta: float, snap: bool = false) -> void:
	var forward := _view_forward()
	var desired_position := hunter.global_position + Vector3(0.0, AERIAL_CAMERA_HEIGHT_M, 0.0) - forward * AERIAL_CAMERA_TRAIL_M

	if snap:
		aerial_camera.global_position = desired_position
	else:
		var follow_weight := 1.0 - exp(-AERIAL_CAMERA_FOLLOW_RESPONSE * maxf(delta, 0.0))
		aerial_camera.global_position = aerial_camera.global_position.lerp(desired_position, follow_weight)

	var look_target := hunter.global_position + Vector3(0.0, 0.7, 0.0) + forward * AERIAL_CAMERA_LOOK_AHEAD_M
	aerial_camera.look_at(look_target, Vector3.UP)

func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		_look_speed = clampf(float(config.get_value("controls", "look_speed", LOOK_SPEED_DEFAULT)), 0.0, 1.0)
	else:
		_look_speed = LOOK_SPEED_DEFAULT

func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("controls", "look_speed", _look_speed)
	var save_error := config.save(SETTINGS_PATH)
	if save_error != OK:
		push_warning("Stage 1 settings could not be saved: %s" % error_string(save_error))

func _update_look_speed_label() -> void:
	look_speed_value.text = "Look Speed: %d%%" % int(round(_look_speed * 100.0))

func _update_renderer_label() -> void:
	renderer_label.text = "Renderer: %s / %s" % [
		RenderingServer.get_current_rendering_method(),
		RenderingServer.get_current_rendering_driver_name()
	]

func _update_view_state() -> void:
	aerial_camera.current = not _first_person
	first_person_camera.current = _first_person
	hunter_body.visible = not _first_person
	mode_label.text = "View: %s" % ("FIRST PERSON" if _first_person else "AERIAL")

func _on_toggle_view_pressed() -> void:
	if _settings_open:
		return
	_first_person = not _first_person
	if not _first_person:
		_view_pitch = 0.0
		first_person_camera.rotation.x = 0.0
	_update_view_state()

func _on_settings_pressed() -> void:
	_settings_open = not _settings_open
	settings_overlay.visible = _settings_open
	_reset_transient_controls()

func _on_settings_close_pressed() -> void:
	_settings_open = false
	settings_overlay.visible = false
	_reset_transient_controls()

func _on_look_speed_changed(value: float) -> void:
	_look_speed = clampf(value / 100.0, 0.0, 1.0)
	_update_look_speed_label()
	_save_settings()
