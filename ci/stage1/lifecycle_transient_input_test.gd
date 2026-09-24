extends SceneTree

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _probe_world_count() -> int:
	var count := 0
	for child in root.get_children():
		if child.name == &"ProbeWorld":
			count += 1
	return count

func _run() -> void:
	print("Stage 1 Android lifecycle transient-input runtime regression")
	var packed := load("res://scenes/probe_world.tscn") as PackedScene
	if packed == null:
		_check("ProbeWorld loads", false, "PackedScene load returned null")
		_finish()
		return

	var world := packed.instantiate()
	root.add_child(world)
	await process_frame

	var hunter := world.get_node("Hunter") as CharacterBody3D
	var aerial_camera := world.get_node("AerialCamera") as Camera3D
	var first_person_camera := world.get_node("Hunter/FirstPersonCamera") as Camera3D
	var settings_overlay := world.get_node("HUD/SettingsOverlay") as PanelContainer

	_check("single ProbeWorld exists after instantiation", _probe_world_count() == 1, "count=%d" % _probe_world_count())

	# Put presentation/UI state into a non-default configuration so the lifecycle
	# reset cannot accidentally pass by normalizing the whole probe back to boot.
	world.call("_on_toggle_view_pressed")
	world.call("_on_settings_pressed")

	var initial_position := hunter.global_position
	var initial_rotation := hunter.global_rotation
	var initial_first_person := bool(world.get("_first_person"))
	var initial_settings_open := bool(world.get("_settings_open"))
	var initial_look_speed := float(world.get("_look_speed"))
	var initial_overlay_visible := settings_overlay.visible

	_check("test fixture is first person", initial_first_person and first_person_camera.current and not aerial_camera.current)
	_check("test fixture keeps Settings open", initial_settings_open and initial_overlay_visible)

	var lifecycle_notifications := [
		["application paused", Node.NOTIFICATION_APPLICATION_PAUSED],
		["application resumed", Node.NOTIFICATION_APPLICATION_RESUMED],
		["application focus out", Node.NOTIFICATION_APPLICATION_FOCUS_OUT],
		["application focus in", Node.NOTIFICATION_APPLICATION_FOCUS_IN],
	]

	for entry in lifecycle_notifications:
		var label := String(entry[0])
		var notification_id := int(entry[1])

		world.set("_joystick_touch_id", 37)
		world.set("_joystick_vector", Vector2(0.75, -0.5))
		world.notification(notification_id)

		var joystick_touch_id := int(world.get("_joystick_touch_id"))
		var joystick_vector: Vector2 = world.get("_joystick_vector")

		_check(label + " clears touch owner", joystick_touch_id == -1, "touch_id=%d" % joystick_touch_id)
		_check(label + " clears movement vector", joystick_vector.is_zero_approx(), str(joystick_vector))
		_check(label + " preserves Hunter position", hunter.global_position.distance_to(initial_position) < 0.00001, str(hunter.global_position))
		_check(label + " preserves Hunter rotation", hunter.global_rotation.distance_to(initial_rotation) < 0.00001, str(hunter.global_rotation))
		_check(label + " preserves first-person state", bool(world.get("_first_person")) == initial_first_person)
		_check(label + " preserves camera ownership", first_person_camera.current and not aerial_camera.current)
		_check(label + " preserves Settings state", bool(world.get("_settings_open")) == initial_settings_open and settings_overlay.visible == initial_overlay_visible)
		_check(label + " preserves Look Speed", is_equal_approx(float(world.get("_look_speed")), initial_look_speed), str(world.get("_look_speed")))
		_check(label + " does not duplicate ProbeWorld", _probe_world_count() == 1, "count=%d" % _probe_world_count())

		# Repeated delivery must stay harmless because Android/desktop focus and
		# lifecycle event ordering can vary.
		world.notification(notification_id)
		var repeat_vector: Vector2 = world.get("_joystick_vector")
		_check(label + " repeated notification stays idempotent", int(world.get("_joystick_touch_id")) == -1 and repeat_vector.is_zero_approx())
		_check(
			label + " repeated notification preserves non-transient state",
			hunter.global_position.distance_to(initial_position) < 0.00001
			and hunter.global_rotation.distance_to(initial_rotation) < 0.00001
			and bool(world.get("_first_person")) == initial_first_person
			and bool(world.get("_settings_open")) == initial_settings_open
			and is_equal_approx(float(world.get("_look_speed")), initial_look_speed)
			and _probe_world_count() == 1
		)

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	print("Gate: ANDROID_LIFECYCLE_TRANSIENT_INPUT_RUNTIME_VERIFIED" if failures.is_empty() else "Gate: ANDROID_LIFECYCLE_TRANSIENT_INPUT_RUNTIME_FAILED")
	print("This headless notification-injection result does NOT prove Android OS background/resume, lock/unlock, crash/ANR, or touch delivery behavior.")
	quit(0 if failures.is_empty() else 1)
