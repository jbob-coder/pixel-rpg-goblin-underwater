extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _approx(value: float, expected: float, tolerance: float = 0.001) -> bool:
	return absf(value - expected) <= tolerance

func _run() -> void:
	print("Stage 1 sustained-performance telemetry runtime regression")
	var packed := load("res://scenes/probe_world.tscn") as PackedScene
	if packed == null:
		_check("ProbeWorld loads", false, "PackedScene load returned null")
		_finish()
		return

	var world := packed.instantiate()
	root.add_child(world)
	await process_frame
	world.set_process(false)

	var hunter := world.get_node("Hunter") as CharacterBody3D
	var aerial_camera := world.get_node("AerialCamera") as Camera3D
	var first_person_camera := world.get_node("Hunter/FirstPersonCamera") as Camera3D
	var fps_label := world.get_node("HUD/MetricsPanel/Metrics/FPS") as Label
	var memory_label := world.get_node("HUD/MetricsPanel/Metrics/Memory") as Label

	var initial_position := hunter.global_position
	var initial_rotation := hunter.global_rotation
	var initial_first_person := bool(world.get("_first_person"))
	var initial_settings_open := bool(world.get("_settings_open"))
	var initial_look_speed := float(world.get("_look_speed"))
	var initial_aerial_current := aerial_camera.current
	var initial_first_person_current := first_person_camera.current

	world.set("_perf_window_elapsed", 0.0)
	world.set("_perf_window_frames", 0)
	world.set("_perf_window_total_ms", 0.0)
	world.set("_perf_window_max_ms", 0.0)
	world.set("_perf_last_avg_ms", 0.0)
	world.set("_perf_last_max_ms", 0.0)
	world.set("_perf_worst_frame_ms", 0.0)
	world.set("_perf_total_slow_frames", 0)
	world.set("_perf_total_hitch_frames", 0)

	for _frame in range(25):
		world.call("_record_performance_frame", 0.04)

	_check("one-second deterministic sample produces 40 ms rolling average", _approx(float(world.get("_perf_last_avg_ms")), 40.0), str(world.get("_perf_last_avg_ms")))
	_check("one-second deterministic sample produces 40 ms rolling max", _approx(float(world.get("_perf_last_max_ms")), 40.0), str(world.get("_perf_last_max_ms")))
	_check("40 ms frames are counted above 34 ms diagnostic threshold", int(world.get("_perf_total_slow_frames")) == 25, str(world.get("_perf_total_slow_frames")))
	_check("40 ms frames are not counted as 50 ms hitches", int(world.get("_perf_total_hitch_frames")) == 0, str(world.get("_perf_total_hitch_frames")))
	_check("worst frame tracks deterministic 40 ms sample", _approx(float(world.get("_perf_worst_frame_ms")), 40.0), str(world.get("_perf_worst_frame_ms")))

	world.call("_record_performance_frame", 0.06)
	_check("60 ms sample increments slow-frame counter", int(world.get("_perf_total_slow_frames")) == 26, str(world.get("_perf_total_slow_frames")))
	_check("60 ms sample increments hitch counter", int(world.get("_perf_total_hitch_frames")) == 1, str(world.get("_perf_total_hitch_frames")))
	_check("worst frame updates to 60 ms", _approx(float(world.get("_perf_worst_frame_ms")), 60.0), str(world.get("_perf_worst_frame_ms")))

	world.call("_refresh_metrics_display")
	_check("metrics label exposes FPS", fps_label.text.contains("FPS:"), fps_label.text)
	_check("metrics label exposes rolling real-delta average/max", fps_label.text.contains("1s avg/max"), fps_label.text)
	_check("metrics label exposes >34 ms counter", fps_label.text.contains(">34ms:"), fps_label.text)
	_check("metrics label exposes >50 ms hitch counter", fps_label.text.contains(">50ms:"), fps_label.text)
	_check("metrics label exposes worst frame", fps_label.text.contains("worst"), fps_label.text)
	_check("memory label remains available", memory_label.text.contains("Debug static memory:"), memory_label.text)

	_check("telemetry does not move Hunter", hunter.global_position.distance_to(initial_position) < 0.00001, str(hunter.global_position))
	_check("telemetry does not rotate Hunter", hunter.global_rotation.distance_to(initial_rotation) < 0.00001, str(hunter.global_rotation))
	_check("telemetry does not change first-person state", bool(world.get("_first_person")) == initial_first_person)
	_check("telemetry does not change camera ownership", aerial_camera.current == initial_aerial_current and first_person_camera.current == initial_first_person_current)
	_check("telemetry does not change Settings state", bool(world.get("_settings_open")) == initial_settings_open)
	_check("telemetry does not change Look Speed", _approx(float(world.get("_look_speed")), initial_look_speed), str(world.get("_look_speed")))

	_finish()

func _finish() -> void:
	print()
	print("Failures: %d" % failures.size())
	print("Gate: STAGE1_PERFORMANCE_TELEMETRY_RUNTIME_VERIFIED" if failures.is_empty() else "Gate: STAGE1_PERFORMANCE_TELEMETRY_RUNTIME_FAILED")
	print("This headless runtime result verifies telemetry calculation only; it does NOT imply Galaxy A03s sustained-performance verification.")
	quit(0 if failures.is_empty() else 1)
