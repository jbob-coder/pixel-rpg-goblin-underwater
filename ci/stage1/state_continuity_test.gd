extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _run() -> void:
	print("Stage 1 aerial/first-person state continuity runtime regression")
	var packed := load("res://scenes/probe_world.tscn") as PackedScene
	if packed == null:
		_check("ProbeWorld loads", false, "PackedScene load returned null")
		_finish()
		return

	var world := packed.instantiate()
	root.add_child(world)
	await process_frame

	var hunter := world.get_node("Hunter") as CharacterBody3D
	var hunter_body := world.get_node("Hunter/Body") as MeshInstance3D
	var aerial_camera := world.get_node("AerialCamera") as Camera3D
	var first_person_camera := world.get_node("Hunter/FirstPersonCamera") as Camera3D
	var mode_label := world.get_node("HUD/MetricsPanel/Metrics/Mode") as Label

	_check("initial mode is aerial", aerial_camera.current and not first_person_camera.current, mode_label.text)
	_check("Hunter body visible in aerial", hunter_body.visible)

	var initial_position := hunter.global_position
	var initial_rotation := hunter.global_rotation
	var initial_aerial_position := aerial_camera.global_position

	world.call("_on_toggle_view_pressed")
	_check("toggle enters first person", first_person_camera.current and not aerial_camera.current, mode_label.text)
	_check("Hunter body hidden in first person", not hunter_body.visible)
	_check("entering first person preserves Hunter position", hunter.global_position.distance_to(initial_position) < 0.00001, str(hunter.global_position))
	_check("entering first person preserves Hunter rotation", hunter.global_rotation.distance_to(initial_rotation) < 0.00001, str(hunter.global_rotation))

	var moved_position := Vector3(2.0, initial_position.y, 0.0)
	var moved_yaw := 0.75
	hunter.global_position = moved_position
	hunter.rotation.y = moved_yaw

	for _frame in range(10):
		await physics_frame

	_check("Hunter remains at authoritative moved position while first person is active", hunter.global_position.distance_to(moved_position) < 0.001, str(hunter.global_position))
	_check("Hunter heading remains authoritative while first person is active", absf(hunter.rotation.y - moved_yaw) < 0.001, str(hunter.rotation.y))
	_check("hidden aerial camera continues synchronizing during first person", aerial_camera.global_position.distance_to(initial_aerial_position) > 0.25, str(aerial_camera.global_position))

	var synchronized_aerial_position := aerial_camera.global_position
	var before_return_position := hunter.global_position
	var before_return_rotation := hunter.global_rotation

	world.call("_on_toggle_view_pressed")
	_check("toggle returns to aerial", aerial_camera.current and not first_person_camera.current, mode_label.text)
	_check("Hunter body restored in aerial", hunter_body.visible)
	_check("returning to aerial preserves Hunter position", hunter.global_position.distance_to(before_return_position) < 0.00001, str(hunter.global_position))
	_check("returning to aerial preserves Hunter rotation", hunter.global_rotation.distance_to(before_return_rotation) < 0.00001, str(hunter.global_rotation))
	_check("returning to aerial does not revive stale camera position", aerial_camera.global_position.distance_to(synchronized_aerial_position) < 0.00001, str(aerial_camera.global_position))

	var repeat_position := hunter.global_position
	var repeat_rotation := hunter.global_rotation
	for _toggle in range(20):
		world.call("_on_toggle_view_pressed")

	_check("20 repeated toggles end in aerial mode", aerial_camera.current and not first_person_camera.current, mode_label.text)
	_check("20 repeated toggles do not drift Hunter position", hunter.global_position.distance_to(repeat_position) < 0.00001, str(hunter.global_position))
	_check("20 repeated toggles do not drift Hunter rotation", hunter.global_rotation.distance_to(repeat_rotation) < 0.00001, str(hunter.global_rotation))

	_finish()

func _finish() -> void:
	print()
	print("Failures: %d" % failures.size())
	print("Gate: AERIAL_FIRST_PERSON_STATE_CONTINUITY_RUNTIME_VERIFIED" if failures.is_empty() else "Gate: AERIAL_FIRST_PERSON_STATE_CONTINUITY_RUNTIME_FAILED")
	print("This headless runtime result does NOT imply Galaxy A03s touch/visual verification.")
	quit(0 if failures.is_empty() else 1)
