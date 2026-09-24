extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")

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
	print("Pixel RPG Visual Pack 003 HUD runtime gate")

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
	print("This gate verifies HUD zoning, Settings behavior, minimap mapping, Bag deferral and touch exclusion; phone visual acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
