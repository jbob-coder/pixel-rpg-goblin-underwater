extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const TOUCH_INPUT := preload("res://scripts/presentation/pixel_rpg/touch_input_math_001.gd")
const TOUCH_STATE := preload("res://scripts/presentation/pixel_rpg/touch_input_state_001.gd")
const HUD_LAYOUT := preload("res://scripts/presentation/pixel_rpg/hud_layout_001.gd")
const MINIMAP_MATH := preload("res://scripts/presentation/pixel_rpg/minimap_math_001.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _run() -> void:
	print("Pixel RPG Visual Pack 003 HUD + extracted touch-input math gate")

	_check("touch-input owner schema is stable", String(TOUCH_INPUT.get_schema()) == "pixel_rpg.touch_input_math_001.v1")
	_check("look region threshold keeps left side excluded", not TOUCH_INPUT.is_in_look_region(Vector2(400.0, 200.0), Vector2(1000.0, 600.0), 0.44))
	_check("look region threshold keeps right side eligible", TOUCH_INPUT.is_in_look_region(Vector2(440.0, 200.0), Vector2(1000.0, 600.0), 0.44))
	var center_sample: Dictionary = TOUCH_INPUT.joystick_sample(Vector2(200.0, 300.0), Rect2(100.0, 200.0, 200.0, 200.0), Vector2(40.0, 40.0), 0.12)
	_check("joystick center sample remains zero", (center_sample.get("vector", Vector2.ONE) as Vector2).is_zero_approx(), str(center_sample))
	_check("joystick center knob placement remains exact", (center_sample.get("knob_position", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(80.0, 80.0)), str(center_sample))
	var edge_sample: Dictionary = TOUCH_INPUT.joystick_sample(Vector2(400.0, 300.0), Rect2(100.0, 200.0, 200.0, 200.0), Vector2(40.0, 40.0), 0.12)
	_check("joystick edge sample clamps to unit vector", is_equal_approx((edge_sample.get("vector", Vector2.ZERO) as Vector2).length(), 1.0), str(edge_sample))
	_check("joystick radius contract remains 34 percent", is_equal_approx(float(edge_sample.get("radius", -1.0)), 68.0), str(edge_sample))

	var touch_state := TOUCH_STATE.new()
	_check("touch-state owner schema is stable", String(touch_state.get_schema()) == "pixel_rpg.touch_input_state_001.v1")
	_check("touch-state starts with both channels free", touch_state.is_joystick_free() and touch_state.is_look_free())
	_check("touch-state claims exactly one joystick touch", touch_state.claim_joystick(3) and not touch_state.claim_joystick(4) and touch_state.is_joystick_touch(3))
	touch_state.set_joystick_vector(Vector2(0.5, -0.25))
	_check("touch-state owns joystick vector", touch_state.get_joystick_vector().is_equal_approx(Vector2(0.5, -0.25)))
	touch_state.reset_joystick()
	_check("touch-state joystick reset clears id and vector", touch_state.is_joystick_free() and touch_state.get_joystick_vector().is_zero_approx())
	_check("touch-state claims look touch with initial position", touch_state.claim_look(7, Vector2(100.0, 80.0)) and touch_state.is_look_touch(7))
	var look_drag: Dictionary = touch_state.update_look_drag(7, Vector2(112.0, 74.0))
	_check("touch-state look drag delta is exact", bool(look_drag.get("handled", false)) and (look_drag.get("delta", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(12.0, -6.0)), str(look_drag))
	touch_state.reset_all()
	_check("touch-state full reset clears both channels", touch_state.is_joystick_free() and touch_state.is_look_free() and touch_state.get_joystick_vector().is_zero_approx())

	_check("HUD layout owner schema is stable", String(HUD_LAYOUT.get_schema()) == "pixel_rpg.hud_layout_001.v1")
	var baseline_layout: Dictionary = HUD_LAYOUT.calculate(
		Vector2(1280.0, 720.0),
		Vector2i(1280, 720),
		Rect2i(0, 0, 1280, 720),
		18.0
	)
	_check("baseline HUD margins preserve authored minimums", (baseline_layout.get("margins", Vector4.ZERO) as Vector4).is_equal_approx(Vector4(24.0, 22.0, 24.0, 24.0)), str(baseline_layout))
	_check("baseline status offsets preserve exact contract", (baseline_layout.get("status_offsets", Rect2()) as Rect2).is_equal_approx(Rect2(24.0, 22.0, 250.0, 82.0)))
	_check("baseline settings offsets preserve top-center contract", (baseline_layout.get("settings_button_offsets", Rect2()) as Rect2).is_equal_approx(Rect2(-86.0, 22.0, 172.0, 60.0)))
	_check("baseline minimap offsets preserve upper-right contract", (baseline_layout.get("minimap_offsets", Rect2()) as Rect2).is_equal_approx(Rect2(-246.0, 22.0, 222.0, 166.0)))
	_check("baseline joystick offsets preserve lower-left contract", (baseline_layout.get("joystick_offsets", Rect2()) as Rect2).is_equal_approx(Rect2(34.0, -228.0, 204.0, 204.0)))
	var inset_layout: Dictionary = HUD_LAYOUT.calculate(
		Vector2(1280.0, 720.0),
		Vector2i(2560, 1440),
		Rect2i(80, 40, 2400, 1360),
		18.0
	)
	_check("safe-area scaling remains exact", (inset_layout.get("margins", Vector4.ZERO) as Vector4).is_equal_approx(Vector4(58.0, 38.0, 58.0, 38.0)), str(inset_layout))

	_check("minimap owner schema is stable", String(MINIMAP_MATH.get_schema()) == "pixel_rpg.minimap_math_001.v1")
	_check("minimap world bounds remain exact", is_equal_approx(MINIMAP_MATH.WORLD_MIN_X, -23.0) and is_equal_approx(MINIMAP_MATH.WORLD_MAX_X, 23.0) and is_equal_approx(MINIMAP_MATH.WORLD_MIN_Z, -57.0) and is_equal_approx(MINIMAP_MATH.WORLD_MAX_Z, 20.0))
	var map_size := Vector2(200.0, 140.0)
	var marker_size := Vector2(8.0, 8.0)
	var min_corner := MINIMAP_MATH.marker_position(Vector3(-23.0, 0.0, -57.0), map_size, marker_size)
	var max_corner := MINIMAP_MATH.marker_position(Vector3(23.0, 0.0, 20.0), map_size, marker_size)
	var clamped_corner := MINIMAP_MATH.marker_position(Vector3(999.0, 0.0, -999.0), map_size, marker_size)
	_check("minimap minimum world corner maps to origin", min_corner.is_equal_approx(Vector2.ZERO), str(min_corner))
	_check("minimap maximum world corner maps inside marker-adjusted bounds", max_corner.is_equal_approx(Vector2(192.0, 132.0)), str(max_corner))
	_check("minimap mapping clamps out-of-range world positions", clamped_corner.is_equal_approx(Vector2(192.0, 0.0)), str(clamped_corner))

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype scene instantiates", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await process_frame

	var settings_button := prototype.get_node_or_null("HUD/Touch/SettingsButton") as Button
	var settings_panel := prototype.get_node_or_null("HUD/SettingsPanel") as PanelContainer
	var sensitivity_label := prototype.get_node_or_null("HUD/SettingsPanel/Layout/SensitivityLabel") as Label
	var sensitivity_slider := prototype.get_node_or_null("HUD/SettingsPanel/Layout/CameraSensitivity") as HSlider
	var minimap_panel := prototype.get_node_or_null("HUD/MinimapPanel") as PanelContainer
	var minimap_canvas := prototype.get_node_or_null("HUD/MinimapPanel/Map") as Control
	var player_marker := prototype.get_node_or_null("HUD/MinimapPanel/Map/PlayerMarker") as ColorRect
	var status_panel := prototype.get_node_or_null("HUD/TopLeft") as Control
	var objective_panel := prototype.get_node_or_null("HUD/ObjectivePanel") as Control
	var joystick := prototype.get_node_or_null("HUD/Touch/MoveJoystick") as Control
	var action_button := prototype.get_node_or_null("HUD/Touch/ActionButton") as Button
	var watch_panel := prototype.get_node_or_null("HUD/WatchPanel") as PanelContainer
	var hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D

	_check("Settings control exists", settings_button != null and settings_button.text == "SETTINGS")
	_check("Settings panel and sensitivity control exist", settings_panel != null and sensitivity_label != null and sensitivity_slider != null)
	_check("upper-right minimap nodes exist", minimap_panel != null and minimap_canvas != null and player_marker != null)
	_check("core HUD zones remain present", status_panel != null and objective_panel != null and joystick != null and action_button != null)
	_check("Bag control remains deferred and absent", prototype.find_child("*Bag*", true, false) == null and prototype.find_child("*Inventory*", true, false) == null)

	if settings_panel != null and watch_panel != null:
		_check("Settings panel starts closed", not settings_panel.visible)
		prototype.call("_on_settings_button_pressed")
		_check("Settings button opens panel and excludes Watch overlap", settings_panel.visible and not watch_panel.visible)
		prototype.call("_on_camera_sensitivity_changed", 0.15)
		_check("camera sensitivity label reflects runtime value", "0.150" in sensitivity_label.text, sensitivity_label.text)
		prototype.call("_on_settings_close_pressed")
		_check("Settings close action hides panel", not settings_panel.visible)

	prototype.call("_apply_safe_area_layout")
	await process_frame

	var viewport_size := root.get_visible_rect().size
	if settings_button != null:
		var settings_rect := settings_button.get_global_rect()
		_check("Settings control is top-center", absf(settings_rect.get_center().x - viewport_size.x * 0.5) <= 4.0 and settings_rect.position.y < viewport_size.y * 0.25, str(settings_rect))
		_check("Settings touch is excluded from camera look", not bool(prototype.call("_can_claim_look_touch", settings_rect.get_center())))
	if minimap_panel != null:
		var minimap_rect := minimap_panel.get_global_rect()
		_check("minimap is in upper-right HUD zone", minimap_rect.position.x > viewport_size.x * 0.5 and minimap_rect.position.y < viewport_size.y * 0.35 and minimap_rect.end.x <= viewport_size.x + 1.0, str(minimap_rect))
		_check("minimap touch is excluded from camera look", not bool(prototype.call("_can_claim_look_touch", minimap_rect.get_center())))
	if status_panel != null and objective_panel != null:
		_check("status/objective remain upper-left", status_panel.get_global_rect().position.x < viewport_size.x * 0.5 and objective_panel.get_global_rect().position.x < viewport_size.x * 0.5)
	if joystick != null:
		var joystick_rect := joystick.get_global_rect()
		_check("movement joystick remains lower-left", joystick_rect.position.x < viewport_size.x * 0.5 and joystick_rect.position.y > viewport_size.y * 0.5, str(joystick_rect))
	if action_button != null:
		_check("contextual action remains on right", action_button.get_global_rect().position.x > viewport_size.x * 0.5, str(action_button.get_global_rect()))

	if hunter != null and minimap_canvas != null and player_marker != null:
		prototype.call("_update_minimap")
		var marker_before := player_marker.position
		hunter.global_position = Vector3(10.0, 0.9, -40.0)
		prototype.call("_update_minimap")
		var marker_after := player_marker.position
		var max_marker := minimap_canvas.size - player_marker.size
		_check("minimap player marker follows hunter world position", marker_after.distance_to(marker_before) > 1.0, "%s -> %s" % [marker_before, marker_after])
		_check("minimap player marker remains inside map bounds", marker_after.x >= 0.0 and marker_after.y >= 0.0 and marker_after.x <= max_marker.x + 0.1 and marker_after.y <= max_marker.y + 0.1, str(marker_after))

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_VISUAL_PACK_003_HUD_RUNTIME_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_VISUAL_PACK_003_HUD_RUNTIME_FAILED")
	print("This gate verifies extracted transient touch-state ownership, HUD layout, minimap mapping and touch math plus live HUD behavior; event routing remains in the host and phone visual acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
