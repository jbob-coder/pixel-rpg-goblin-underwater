extends Node3D

const MANIFEST_PATH := "res://content/regions/region_01/hunt01_graybox_build_manifest.json"
const SETTINGS_PATH := "user://unnamed_hunt_settings.cfg"
const PINE_ASSET: PackedScene = preload("res://assets/environment/stylized_pine.tscn")
const ROCK_ASSET: PackedScene = preload("res://assets/environment/stylized_rock_cluster.tscn")
const MONSTER_ASSET: PackedScene = preload("res://assets/creatures/mudcrest_raker_visual.tscn")

const MOVE_SPEED_MPS := 6.25
const GRAVITY_MPS2 := 9.8
const JOYSTICK_DEADZONE := 0.12
const LOOK_SPEED_DEFAULT := 0.35
const LOOK_TOUCH_REGION_START_X_RATIO := 0.45
const LOOK_DEGREES_PER_PIXEL_MIN := 0.04
const LOOK_DEGREES_PER_PIXEL_MAX := 0.20
const FIRST_PERSON_PITCH_LIMIT_DEG := 80.0
const FIRST_PERSON_FOV_DEG := 115.0
const AERIAL_CAMERA_HEIGHT_M := 9.4
const AERIAL_CAMERA_TRAIL_M := 9.2
const AERIAL_CAMERA_LOOK_AHEAD_M := 2.6
const AERIAL_CAMERA_FOLLOW_RESPONSE := 7.0
const FULL_MAP_CENTER := Vector3(-45.0, -0.25, -160.0)
const FULL_MAP_SIZE_M := Vector2(440.0, 440.0)
const FOUNDATION_THICKNESS_M := 0.5
const FLAT_SURFACE_Y := 0.0
const ROUTE_VISUAL_THICKNESS_M := 0.055
const RESPAWN_Y_M := -12.0
const S00_SPAWN := Vector3(0.0, 0.875, -45.0)
const EVIDENCE_TRIGGER_RADIUS_M := 1.45

const EVIDENCE_TEXT := {
	"R01_H01_EV01_OUTER_PRINTS": "Heavy prints • fresh • strong trail toward the River Ford.",
	"R01_H01_EV02_BANK_REEDS": "Bent bank reeds • fresh • a large body entered the ford here.",
	"R01_H01_EV03_FRESH_WALLOW": "Fresh wallow • very strong • recent Mudcrest activity.",
	"R01_H01_EV04_WATER_EXIT": "Water-exit prints • very fresh • trail continues toward Feeding Meadow.",
	"R01_H01_EV05_OLD_ROOT_SCRAPE": "Root scrape • old / weak • valid history, but not the freshest direction.",
	"R01_H01_EV06_FEEDING_REMAINS": "Feeding remains • fresh • the Raker has been feeding nearby.",
	"R01_H01_EV07_FLATTENED_GRASS_AUDIO": "Flattened grass • very fresh • movement continues into the meadow. No audio required.",
}

@onready var world_geometry: Node3D = $WorldGeometry
@onready var debug_geometry: Node3D = $DebugGeometry
@onready var hunter: CharacterBody3D = $Hunter
@onready var hunter_body: Node3D = $Hunter/Visual
@onready var first_person_camera: Camera3D = $Hunter/FirstPersonCamera
@onready var aerial_camera: Camera3D = $AerialCamera
@onready var coordinates_label: Label = $HUD/MetricsPanel/Metrics/Coordinates
@onready var fps_label: Label = $HUD/MetricsPanel/Metrics/FPS
@onready var mode_label: Label = $HUD/MetricsPanel/Metrics/Mode
@onready var evidence_count_label: Label = $HUD/MetricsPanel/Metrics/EvidenceCount
@onready var evidence_status_label: Label = $HUD/EvidencePanel/EvidenceStatus
@onready var joystick_base: Control = $HUD/Touch/MoveJoystick
@onready var joystick_knob: Control = $HUD/Touch/MoveJoystick/Knob
@onready var toggle_view_button: Button = $HUD/Touch/ToggleView
@onready var reset_button: Button = $HUD/Touch/ResetToStart
@onready var settings_button: Button = $HUD/Touch/SettingsButton
@onready var settings_overlay: PanelContainer = $HUD/SettingsOverlay
@onready var look_speed_slider: HSlider = $HUD/SettingsOverlay/Layout/Controls/LookSpeed
@onready var look_speed_value: Label = $HUD/SettingsOverlay/Layout/Controls/LookSpeedValue

var _manifest: Dictionary = {}
var _required_route_length_m := 0.0
var _joystick_vector := Vector2.ZERO
var _joystick_touch_id := -1
var _look_touch_id := -1
var _look_last_position := Vector2.ZERO
var _view_yaw := 0.0
var _view_pitch := 0.0
var _first_person := false
var _look_speed := LOOK_SPEED_DEFAULT
var _settings_open := false
var _metrics_elapsed := 0.0
var _world_built := false
var _collected_evidence: Dictionary = {}

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_FOCUS_IN:
			_reset_transient_controls()

func _ready() -> void:
	_manifest = _load_manifest()
	if _manifest.is_empty():
		push_error("Hunt-01 production world cannot start without its runtime manifest projection.")
		return

	_build_hunt01_world()
	_load_settings()
	look_speed_slider.value = _look_speed * 100.0
	_update_look_speed_label()
	_update_evidence_hud()
	_reset_transient_controls()
	_view_yaw = 0.0
	_view_pitch = 0.0
	first_person_camera.fov = FIRST_PERSON_FOV_DEG
	_apply_view_orientation()
	_update_aerial_camera(0.0, true)
	_update_view_state()
	settings_overlay.visible = false
	_world_built = true

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
	if not _world_built:
		return
	var desktop_x := (1.0 if Input.is_key_pressed(KEY_D) else 0.0) - (1.0 if Input.is_key_pressed(KEY_A) else 0.0)
	var desktop_y := (1.0 if Input.is_key_pressed(KEY_S) else 0.0) - (1.0 if Input.is_key_pressed(KEY_W) else 0.0)
	var movement_input := Vector2(desktop_x, desktop_y) + _joystick_vector
	if _settings_open:
		movement_input = Vector2.ZERO
	elif movement_input.length() > 1.0:
		movement_input = movement_input.normalized()

	var movement_world := _camera_relative_movement(movement_input)
	hunter.velocity.x = movement_world.x * MOVE_SPEED_MPS
	hunter.velocity.z = movement_world.z * MOVE_SPEED_MPS
	if not hunter.is_on_floor():
		hunter.velocity.y -= GRAVITY_MPS2 * maxf(delta, 0.0)
	elif hunter.velocity.y < 0.0:
		hunter.velocity.y = -0.1
	hunter.move_and_slide()

	if hunter.global_position.y < RESPAWN_Y_M:
		_reset_hunter_to_s00()
	_update_aerial_camera(delta)

func _process(delta: float) -> void:
	_metrics_elapsed += maxf(delta, 0.0)
	if _metrics_elapsed < 0.20:
		return
	_metrics_elapsed = 0.0
	var pos := hunter.global_position
	coordinates_label.text = "XYZ %.0f / %.1f / %.0f" % [pos.x, pos.y, pos.z]
	fps_label.text = "FPS %d" % Engine.get_frames_per_second()

func _load_manifest() -> Dictionary:
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		push_error("Missing Hunt-01 manifest projection: %s" % MANIFEST_PATH)
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Hunt-01 manifest projection is not a JSON object.")
		return {}
	return parsed as Dictionary

func _build_hunt01_world() -> void:
	_build_full_map_foundation()
	_build_required_route()
	_build_wrong_route_stub()
	_build_landmark_surfaces()
	_build_environment_assets()
	_build_cover()
	_build_evidence_markers()
	_build_tactical_nodes()
	_build_monster_and_clearance()
	_build_escape_corridor()
	_build_camera_debug()
	_build_stream_proxies()

func _build_full_map_foundation() -> void:
	var body := StaticBody3D.new()
	body.name = "H01_WORLD_FOUNDATION"
	body.position = FULL_MAP_CENTER
	body.add_to_group("hunt01_foundation")
	body.set_meta("foundation_size_m", FULL_MAP_SIZE_M)
	world_geometry.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "GroundVisual"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(FULL_MAP_SIZE_M.x, FOUNDATION_THICKNESS_M, FULL_MAP_SIZE_M.y)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(Color(0.20, 0.27, 0.16, 1.0), 0.96)
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = mesh.size
	collision.shape = shape
	body.add_child(collision)

func _build_required_route() -> void:
	var anchors: Array = _manifest["route"]["anchors"]
	_required_route_length_m = 0.0
	for index in range(anchors.size() - 1):
		var source_a := _array_to_v3(anchors[index])
		var source_b := _array_to_v3(anchors[index + 1])
		_required_route_length_m += source_a.distance_to(source_b)
		var width := 9.0
		if index == 10:
			width = 7.0
		elif index >= 11:
			width = 3.5
		_create_flat_visual_lane(
			"H01_REQUIRED_ROUTE_%02d" % (index + 1),
			_flat(source_a, 0.045),
			_flat(source_b, 0.045),
			width,
			Color(0.30, 0.27, 0.16, 1.0),
			"hunt01_required_route"
		)

func _build_wrong_route_stub() -> void:
	_create_flat_visual_lane(
		"BUILD_ONLY_S02_WRONG_ROUTE_STUB",
		Vector3(0.0, 0.045, -65.0),
		Vector3(18.0, 0.045, -83.0),
		6.0,
		Color(0.25, 0.24, 0.15, 1.0),
		"hunt01_build_only"
	)

func _build_landmark_surfaces() -> void:
	_create_visual_box("H01_GB_S00_DEPART_PAD", Vector3(0, 0.035, -45), Vector3(18, 0.05, 14), Color(0.27, 0.33, 0.18, 1), world_geometry, "hunt01_surface")
	_create_visual_box("H01_GB_S00_CHOICE_CLEARING", Vector3(0, 0.032, -65), Vector3(24, 0.045, 20), Color(0.24, 0.30, 0.17, 1), world_geometry, "hunt01_surface")

	_create_visual_box("H01_GB_S01_FORD_BASIN", Vector3(-90, 0.028, -145), Vector3(58, 0.04, 54), Color(0.23, 0.22, 0.16, 1), world_geometry, "hunt01_ford_visual")
	_create_visual_box("H01_GB_S01_SHALLOW_WATER_MAIN", Vector3(-92, 0.075, -149), Vector3(34, 0.035, 18), Color(0.16, 0.42, 0.47, 0.78), world_geometry, "hunt01_water")
	var water_visual := world_geometry.get_node_or_null("H01_GB_S01_SHALLOW_WATER_MAIN") as Node3D
	if water_visual != null:
		water_visual.rotation.y = deg_to_rad(25.0)
	_create_visual_box("H01_GB_S01_WALLOW_MUD", Vector3(-100, 0.07, -142), Vector3(16, 0.035, 12), Color(0.26, 0.15, 0.08, 1), world_geometry, "hunt01_mud")
	_create_visual_box("H01_GB_S01_EXIT_MUD", Vector3(-79, 0.07, -165), Vector3(20, 0.035, 12), Color(0.28, 0.17, 0.09, 1), world_geometry, "hunt01_mud")

	_create_visual_box("H01_GB_VIS01_BANK_RISE", Vector3(-68, 0.12, -190), Vector3(22, 0.16, 8), Color(0.23, 0.31, 0.17, 1), world_geometry, "hunt01_visibility_break")
	_create_visual_box("H01_GB_EF02_MEADOW_FLOOR", Vector3(-45, 0.03, -250), Vector3(70, 0.045, 54), Color(0.30, 0.40, 0.20, 1), world_geometry, "hunt01_meadow")
	_create_visual_box("H01_GB_EF02_OPEN_CORE", Vector3(-37, 0.065, -252), Vector3(48, 0.03, 34), Color(0.38, 0.45, 0.22, 1), world_geometry, "hunt01_open_core")
	_create_visual_box("H01_GB_EF02_FEED_SITE", Vector3(-20, 0.075, -258), Vector3(14, 0.035, 12), Color(0.35, 0.30, 0.16, 1), world_geometry, "hunt01_feed_site")
	_create_visual_box("H01_GB_OBSERVATION_SHELF_W", Vector3(-72, 0.07, -236), Vector3(16, 0.05, 12), Color(0.25, 0.34, 0.18, 1), world_geometry, "hunt01_observation")

	_create_reed_patch("FORD_REEDS_A", Vector3(-76, 0, -139), 1.0)
	_create_reed_patch("FORD_REEDS_B", Vector3(-108, 0, -151), 1.2)
	_create_reed_patch("MEADOW_BRUSH_A", Vector3(-75, 0, -246), 1.25)
	_create_reed_patch("MEADOW_BRUSH_B", Vector3(-73, 0, -265), 1.15)

func _build_environment_assets() -> void:
	var tree_positions: Array[Vector3] = [
		Vector3(-18,0,-54), Vector3(20,0,-58), Vector3(-30,0,-82), Vector3(25,0,-91),
		Vector3(-47,0,-101), Vector3(-18,0,-112), Vector3(-118,0,-117), Vector3(-125,0,-145),
		Vector3(-116,0,-174), Vector3(-102,0,-184), Vector3(-91,0,-198), Vector3(-83,0,-212),
		Vector3(-90,0,-232), Vector3(-86,0,-259), Vector3(-85,0,-282), Vector3(-69,0,-291),
		Vector3(-46,0,-290), Vector3(-24,0,-288), Vector3(-5,0,-283), Vector3(15,0,-278),
		Vector3(35,0,-282), Vector3(56,0,-288), Vector3(74,0,-278), Vector3(72,0,-246),
		Vector3(58,0,-224), Vector3(37,0,-214), Vector3(10,0,-205), Vector3(-10,0,-198),
		Vector3(-112,0,-214), Vector3(-128,0,-232), Vector3(-129,0,-265), Vector3(-110,0,-286)
	]
	for index in range(tree_positions.size()):
		var scale_value := 0.82 + float(index % 5) * 0.08
		_place_environment_asset(PINE_ASSET, "PINE_%02d" % index, tree_positions[index], Vector3.ONE * scale_value, float((index * 47) % 360))

	var rock_positions: Array[Vector3] = [
		Vector3(-16,0,-72), Vector3(-54,0,-122), Vector3(-112,0,-131), Vector3(-106,0,-162),
		Vector3(-72,0,-178), Vector3(-84,0,-225), Vector3(-77,0,-274), Vector3(-42,0,-281),
		Vector3(-8,0,-272), Vector3(18,0,-269), Vector3(47,0,-271), Vector3(67,0,-258)
	]
	for index in range(rock_positions.size()):
		var scale_value := 0.55 + float(index % 4) * 0.12
		_place_environment_asset(ROCK_ASSET, "ROCK_%02d" % index, rock_positions[index], Vector3.ONE * scale_value, float((index * 71) % 360))

func _build_cover() -> void:
	var boulder := StaticBody3D.new()
	boulder.name = "R01_EF02_COV01_BOULDER_W"
	boulder.position = Vector3(-61, 0, -253)
	boulder.add_to_group("hunt01_cover")
	world_geometry.add_child(boulder)
	var boulder_collision := CollisionShape3D.new()
	var boulder_shape := BoxShape3D.new()
	boulder_shape.size = Vector3(5, 3, 4)
	boulder_collision.shape = boulder_shape
	boulder_collision.position.y = 1.5
	boulder.add_child(boulder_collision)
	var boulder_visual := ROCK_ASSET.instantiate() as Node3D
	boulder_visual.position = Vector3(0, 0, 0)
	boulder_visual.scale = Vector3(1.8, 1.7, 1.55)
	boulder_visual.rotation.y = deg_to_rad(20)
	boulder.add_child(boulder_visual)

	var tree_body := StaticBody3D.new()
	tree_body.name = "R01_EF02_COV02_SCARRED_TREE_NW"
	tree_body.position = Vector3(-61, 0, -270)
	tree_body.add_to_group("hunt01_cover")
	world_geometry.add_child(tree_body)
	var tree_collision := CollisionShape3D.new()
	var tree_shape := CylinderShape3D.new()
	tree_shape.radius = 0.7
	tree_shape.height = 8.0
	tree_collision.shape = tree_shape
	tree_collision.position.y = 4.0
	tree_body.add_child(tree_collision)
	var tree_visual := PINE_ASSET.instantiate() as Node3D
	tree_visual.scale = Vector3(1.35, 1.45, 1.35)
	tree_body.add_child(tree_visual)

func _build_evidence_markers() -> void:
	var entries: Array = _manifest["evidence"]
	for index in range(entries.size()):
		var entry: Array = entries[index]
		_create_evidence_area(String(entry[0]), _flat(_array_to_v3(entry[1]), 0.0), index)

func _create_evidence_area(build_id: String, position: Vector3, visual_index: int) -> Area3D:
	var area := Area3D.new()
	area.name = build_id
	area.position = position
	area.collision_layer = 0
	area.collision_mask = 1
	area.monitoring = true
	area.monitorable = true
	area.set_meta("build_id", build_id)
	area.add_to_group("hunt01_evidence")
	world_geometry.add_child(area)

	var collision := CollisionShape3D.new()
	collision.position.y = 0.85
	var shape := SphereShape3D.new()
	shape.radius = EVIDENCE_TRIGGER_RADIUS_M
	collision.shape = shape
	area.add_child(collision)

	_create_evidence_visual(area, build_id, visual_index)
	area.body_entered.connect(_on_evidence_body_entered.bind(build_id))
	return area

func _create_evidence_visual(parent: Node3D, build_id: String, visual_index: int) -> void:
	var accent := Color(0.62, 0.43, 0.16, 1.0)
	var dark := Color(0.24, 0.16, 0.09, 1.0)
	if build_id.contains("WALLOW"):
		var disk := MeshInstance3D.new()
		var disk_mesh := CylinderMesh.new()
		disk_mesh.top_radius = 0.85
		disk_mesh.bottom_radius = 0.92
		disk_mesh.height = 0.045
		disk_mesh.radial_segments = 20
		disk.mesh = disk_mesh
		disk.position.y = 0.04
		disk.scale = Vector3(1.4, 1, 0.9)
		disk.material_override = _material(Color(0.23, 0.13, 0.07, 1.0), 1.0)
		parent.add_child(disk)
	elif build_id.contains("REEDS") or build_id.contains("GRASS"):
		for offset in [-0.45, 0.0, 0.45]:
			var stem := MeshInstance3D.new()
			var stem_mesh := BoxMesh.new()
			stem_mesh.size = Vector3(0.09, 0.045, 0.9)
			stem.mesh = stem_mesh
			stem.position = Vector3(offset, 0.04, 0)
			stem.rotation.y = deg_to_rad(float(visual_index * 13) + offset * 18.0)
			stem.material_override = _material(accent, 0.95)
			parent.add_child(stem)
	else:
		for foot in [-1, 1]:
			var print_mesh := MeshInstance3D.new()
			var print_box := BoxMesh.new()
			print_box.size = Vector3(0.28, 0.045, 0.72)
			print_mesh.mesh = print_box
			print_mesh.position = Vector3(float(foot) * 0.24, 0.04, float(foot) * 0.26)
			print_mesh.rotation.y = deg_to_rad(float(visual_index * 17 + foot * 8))
			print_mesh.material_override = _material(dark, 1.0)
			parent.add_child(print_mesh)

	var trace := MeshInstance3D.new()
	var trace_mesh := CylinderMesh.new()
	trace_mesh.top_radius = 0.58
	trace_mesh.bottom_radius = 0.58
	trace_mesh.height = 0.025
	trace_mesh.radial_segments = 24
	trace.mesh = trace_mesh
	trace.position.y = 0.018
	trace.material_override = _material(Color(0.72, 0.52, 0.20, 0.45), 0.9)
	parent.add_child(trace)

func _on_evidence_body_entered(body: Node3D, build_id: String) -> void:
	if body == hunter:
		_collect_evidence(build_id)

func _collect_evidence(build_id: String) -> bool:
	if _collected_evidence.has(build_id):
		return false
	var node := world_geometry.get_node_or_null(build_id)
	if node == null:
		return false
	_collected_evidence[build_id] = true
	node.remove_from_group("hunt01_evidence")
	node.queue_free()
	evidence_status_label.text = String(EVIDENCE_TEXT.get(build_id, "Evidence investigated."))
	_update_evidence_hud()
	return true

func _update_evidence_hud() -> void:
	if is_instance_valid(evidence_count_label):
		evidence_count_label.text = "Trail Evidence %d / 7" % _collected_evidence.size()

func _build_tactical_nodes() -> void:
	for entry_variant in _manifest["nodes"]:
		var entry: Array = entry_variant
		_create_tactical_marker(String(entry[0]), _flat(_array_to_v3(entry[1]), 0.065))

func _create_tactical_marker(build_id: String, position: Vector3) -> MeshInstance3D:
	var marker := MeshInstance3D.new()
	marker.name = build_id
	marker.position = position
	marker.set_meta("build_id", build_id)
	marker.add_to_group("hunt01_tactical_nodes")
	var ring := CylinderMesh.new()
	ring.top_radius = 0.46
	ring.bottom_radius = 0.46
	ring.height = 0.035
	ring.radial_segments = 24
	marker.mesh = ring
	marker.material_override = _material(Color(0.20, 0.53, 0.53, 0.68), 0.82)
	world_geometry.add_child(marker)
	return marker

func _build_monster_and_clearance() -> void:
	var pivot: Dictionary = _manifest["monster_clearance"]["pivot"]
	var pivot_center := _flat(_array_to_v3(pivot["center"]), 0.0)
	var body := StaticBody3D.new()
	body.name = "monster_r01_m01_0001"
	body.position = pivot_center
	body.add_to_group("hunt01_monster")
	body.set_meta("species", "species_r01_mudcrest_raker")
	world_geometry.add_child(body)

	var collision := CollisionShape3D.new()
	collision.position = Vector3(0, 1.5, 0)
	var shape := BoxShape3D.new()
	shape.size = Vector3(3.2, 3.0, 6.6)
	collision.shape = shape
	body.add_child(collision)

	var visual := MONSTER_ASSET.instantiate() as Node3D
	visual.name = "MudcrestRakerVisual"
	visual.scale = Vector3.ONE * 0.78
	body.add_child(visual)

	var pivot_debug := Node3D.new()
	pivot_debug.name = "R01_EF02_MA01_PIVOT_CLEARANCE"
	pivot_debug.position = pivot_center
	pivot_debug.add_to_group("hunt01_monster_clearance_debug")
	pivot_debug.visible = false
	debug_geometry.add_child(pivot_debug)

	var charge_debug := Node3D.new()
	charge_debug.name = "R01_EF02_CHARGE_LANE_W"
	charge_debug.add_to_group("hunt01_monster_clearance_debug")
	charge_debug.visible = false
	debug_geometry.add_child(charge_debug)

func _build_escape_corridor() -> void:
	var points: Array = _manifest["escape"]["polyline"]
	for index in range(points.size() - 1):
		_create_flat_visual_lane(
			"H01_ESCAPE_ROUTE_%02d" % (index + 1),
			_flat(_array_to_v3(points[index]), 0.043),
			_flat(_array_to_v3(points[index + 1]), 0.043),
			float(_manifest["escape"]["monster_w_min"]),
			Color(0.27, 0.25, 0.15, 1.0),
			"hunt01_escape_route"
		)

func _build_camera_debug() -> void:
	var holder := Node3D.new()
	holder.name = "H01_CAMERA_DESCENT_CLEARANCE"
	holder.add_to_group("hunt01_camera_debug")
	holder.visible = false
	debug_geometry.add_child(holder)

func _build_stream_proxies() -> void:
	for entry_variant in _manifest["stream"]:
		var entry: Array = entry_variant
		var holder := Node3D.new()
		holder.name = String(entry[0])
		holder.position = _flat(_array_to_v3(entry[1]), 0.0)
		holder.set_meta("source_size", _array_to_v3(entry[2]))
		holder.add_to_group("hunt01_stream_proxy")
		holder.visible = false
		debug_geometry.add_child(holder)

func _place_environment_asset(scene: PackedScene, node_name: String, position: Vector3, scale_value: Vector3, yaw_deg: float) -> Node3D:
	var instance := scene.instantiate() as Node3D
	instance.name = node_name
	instance.position = position
	instance.scale = scale_value
	instance.rotation.y = deg_to_rad(yaw_deg)
	instance.add_to_group("hunt01_environment_asset")
	world_geometry.add_child(instance)
	return instance

func _create_reed_patch(node_name: String, position: Vector3, scale_value: float) -> Node3D:
	var holder := Node3D.new()
	holder.name = node_name
	holder.position = position
	holder.add_to_group("hunt01_environment_asset")
	world_geometry.add_child(holder)
	var reed_material := _material(Color(0.30, 0.39, 0.16, 1.0), 0.92)
	for index in range(7):
		var reed := MeshInstance3D.new()
		var mesh := CylinderMesh.new()
		mesh.top_radius = 0.025
		mesh.bottom_radius = 0.04
		mesh.height = (0.8 + float(index % 3) * 0.22) * scale_value
		mesh.radial_segments = 8
		reed.mesh = mesh
		reed.position = Vector3(float((index % 4) - 2) * 0.28, mesh.height * 0.5, float(index / 4) * 0.38)
		reed.rotation.z = deg_to_rad(float((index % 3) - 1) * 7.0)
		reed.material_override = reed_material
		holder.add_child(reed)
	return holder

func _create_flat_visual_lane(build_id: String, a: Vector3, b: Vector3, width: float, color: Color, group_name: String) -> Node3D:
	var delta := b - a
	var length := delta.length()
	var holder := Node3D.new()
	holder.name = build_id
	holder.position = (a + b) * 0.5
	holder.set_meta("build_id", build_id)
	holder.add_to_group(group_name)
	world_geometry.add_child(holder)
	if length > 0.001:
		holder.look_at(b, Vector3.UP)
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(width, ROUTE_VISUAL_THICKNESS_M, maxf(length, 0.01))
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color, 0.98)
	holder.add_child(mesh_instance)
	return holder

func _create_visual_box(build_id: String, center: Vector3, size: Vector3, color: Color, parent: Node3D, group_name: String) -> Node3D:
	var holder := Node3D.new()
	holder.name = build_id
	holder.position = center
	holder.set_meta("build_id", build_id)
	holder.add_to_group(group_name)
	parent.add_child(holder)
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color, 0.95)
	holder.add_child(mesh_instance)
	return holder

func _material(color: Color, roughness_value: float = 0.9) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness_value
	if color.a < 0.999:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return material

func _array_to_v3(values: Array) -> Vector3:
	return Vector3(float(values[0]), float(values[1]), float(values[2]))

func _flat(source: Vector3, y: float = FLAT_SURFACE_Y) -> Vector3:
	return Vector3(source.x, y, source.z)

func _view_forward() -> Vector3:
	var forward := Basis(Vector3.UP, _view_yaw) * Vector3(0, 0, -1)
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

func _look_degrees_per_pixel() -> float:
	return lerpf(LOOK_DEGREES_PER_PIXEL_MIN, LOOK_DEGREES_PER_PIXEL_MAX, _look_speed)

func _apply_look_delta(delta_pixels: Vector2) -> void:
	var sensitivity := _look_degrees_per_pixel()
	_view_yaw = wrapf(_view_yaw - deg_to_rad(delta_pixels.x * sensitivity), -PI, PI)
	if _first_person:
		_view_pitch = clampf(_view_pitch - deg_to_rad(delta_pixels.y * sensitivity), deg_to_rad(-FIRST_PERSON_PITCH_LIMIT_DEG), deg_to_rad(FIRST_PERSON_PITCH_LIMIT_DEG))
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
	if reset_button.get_global_rect().has_point(screen_position):
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
	_set_joystick_from_raw_vector(clamped_offset / travel_radius)
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
	var desired_position := hunter.global_position + Vector3(0, AERIAL_CAMERA_HEIGHT_M, 0) - forward * AERIAL_CAMERA_TRAIL_M
	if snap:
		aerial_camera.global_position = desired_position
	else:
		var follow_weight := 1.0 - exp(-AERIAL_CAMERA_FOLLOW_RESPONSE * maxf(delta, 0.0))
		aerial_camera.global_position = aerial_camera.global_position.lerp(desired_position, follow_weight)
	var look_target := hunter.global_position + Vector3(0, 0.7, 0) + forward * AERIAL_CAMERA_LOOK_AHEAD_M
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
	var error := config.save(SETTINGS_PATH)
	if error != OK:
		push_warning("Production settings could not be saved: %s" % error_string(error))

func _update_look_speed_label() -> void:
	look_speed_value.text = "Look Speed: %d%%" % int(round(_look_speed * 100.0))

func _update_view_state() -> void:
	aerial_camera.current = not _first_person
	first_person_camera.current = _first_person
	hunter_body.visible = not _first_person
	mode_label.text = "View %s" % ("FIRST PERSON" if _first_person else "AERIAL")

func _reset_hunter_to_s00() -> void:
	hunter.global_position = S00_SPAWN
	hunter.velocity = Vector3.ZERO
	_view_yaw = 0.0
	_view_pitch = 0.0
	_apply_view_orientation()
	_update_aerial_camera(0.0, true)
	_reset_transient_controls()

func _on_toggle_view_pressed() -> void:
	if _settings_open:
		return
	_first_person = not _first_person
	if not _first_person:
		_view_pitch = 0.0
		first_person_camera.rotation.x = 0.0
	_update_view_state()

func _on_reset_to_start_pressed() -> void:
	_reset_hunter_to_s00()

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

func get_manifest_identity() -> Dictionary:
	return {
		"schema": _manifest.get("schema", ""),
		"scenario": _manifest.get("scenario", ""),
		"hunt": _manifest.get("hunt", ""),
		"monster": _manifest.get("monster", ""),
		"encounter": _manifest.get("encounter", ""),
	}

func get_required_route_length_m() -> float:
	return _required_route_length_m

func get_move_speed_mps() -> float:
	return MOVE_SPEED_MPS

func get_foundation_size_m() -> Vector2:
	return FULL_MAP_SIZE_M

func get_collected_evidence_count() -> int:
	return _collected_evidence.size()

func collect_evidence_for_test(build_id: String) -> bool:
	return _collect_evidence(build_id)

func is_world_built() -> bool:
	return _world_built
