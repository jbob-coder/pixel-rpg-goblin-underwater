class_name PixelRPGSettlement01PerimeterStreetscapeGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_perimeter_streetscape_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "PerimeterStreetscapeGraybox"
const SHARED_OWNER := "SET01_SHARED_INFRASTRUCTURE"

const WALL_HEIGHT_M := 4.8
const WALL_THICKNESS_M := 0.50
const SIDE_WALL_X := 30.50
const SIDE_WALL_INNER_EDGE_X := 30.25
const SOUTH_WALL_Z := 33.0
const NORTH_WALL_Z := -35.0

const SIDE_SEGMENT_Z := [
	-33.0, -29.0, -25.0, -21.0, -17.0, -13.0, -9.0, -5.0, -1.0,
	3.0, 7.0, 11.0, 15.0, 19.0, 23.0, 27.0, 31.0,
]
const SOUTH_WEST_SEGMENT_X := [-28.0, -24.0, -20.0, -16.0]
const SOUTH_EAST_SEGMENT_X := [16.0, 20.0, 24.0, 28.0]
const NORTH_WEST_SEGMENT_X := [-28.0, -24.0, -20.0, -16.0, -12.0]
const NORTH_EAST_SEGMENT_X := [12.0, 16.0, 20.0, 24.0, 28.0]

const PLAZA_BENCH_POSITIONS := [
	Vector2(-7.0, 12.0),
	Vector2(7.0, 12.0),
	Vector2(-7.0, -12.0),
	Vector2(7.0, -12.0),
]
const SPINE_LANTERN_POSITIONS := [
	Vector2(-5.5, 22.0), Vector2(5.5, 22.0),
	Vector2(-5.5, 12.0), Vector2(5.5, 12.0),
	Vector2(-5.5, -12.0), Vector2(5.5, -12.0),
	Vector2(-5.5, -22.0), Vector2(5.5, -22.0),
]
const WAYFINDING_POSITIONS := [
	Vector2(6.0, 15.0),
	Vector2(-6.0, -15.0),
]

const WALL_COLOR := Color(0.31, 0.24, 0.16)
const WALL_SUPPORT := Color(0.20, 0.15, 0.11)
const STONE_BASE := Color(0.34, 0.35, 0.32)
const WOOD_LIGHT := Color(0.54, 0.40, 0.24)
const LANTERN_METAL := Color(0.25, 0.27, 0.28)
const LANTERN_GLOW := Color(0.86, 0.58, 0.24)
const SIGN_COLOR := Color(0.47, 0.36, 0.20)

static func get_schema() -> String:
	return SCHEMA

static func add_perimeter_streetscape(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G13 Perimeter/Streetscape requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G13 Perimeter/Streetscape requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var infrastructure: Dictionary = LayoutContract.get_infrastructure_specs()
	if not _infrastructure_matches(infrastructure):
		push_error("Settlement 01 G13 Perimeter/Streetscape infrastructure disagrees with the locked layout.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	root_node.set_meta("pixel_rpg_shared_owner", SHARED_OWNER)
	root_node.set_meta("pixel_rpg_graybox_pass", "G13")
	root_node.set_meta("pixel_rpg_final_art_locked", false)
	root_node.set_meta("pixel_rpg_side_wall_inner_edge_abs_x", SIDE_WALL_INNER_EDGE_X)
	parent.add_child(root_node)

	var wall_holder := Node3D.new()
	wall_holder.name = "ModularPerimeter"
	root_node.add_child(wall_holder)

	var wall_modules: Array[StaticBody3D] = []
	_add_side_modules(wall_holder, wall_modules, -SIDE_WALL_X, "West")
	_add_side_modules(wall_holder, wall_modules, SIDE_WALL_X, "East")
	_add_horizontal_modules(wall_holder, wall_modules, SOUTH_WEST_SEGMENT_X, SOUTH_WALL_Z, "SouthWest")
	_add_horizontal_modules(wall_holder, wall_modules, SOUTH_EAST_SEGMENT_X, SOUTH_WALL_Z, "SouthEast")
	_add_horizontal_modules(wall_holder, wall_modules, NORTH_WEST_SEGMENT_X, NORTH_WALL_Z, "NorthWest")
	_add_horizontal_modules(wall_holder, wall_modules, NORTH_EAST_SEGMENT_X, NORTH_WALL_Z, "NorthEast")

	_add_corner_module(wall_holder, wall_modules, Vector3(-30.25, WALL_HEIGHT_M * 0.5, SOUTH_WALL_Z), "CornerSW")
	_add_corner_module(wall_holder, wall_modules, Vector3(30.25, WALL_HEIGHT_M * 0.5, SOUTH_WALL_Z), "CornerSE")
	_add_corner_module(wall_holder, wall_modules, Vector3(-30.25, WALL_HEIGHT_M * 0.5, NORTH_WALL_Z), "CornerNW")
	_add_corner_module(wall_holder, wall_modules, Vector3(30.25, WALL_HEIGHT_M * 0.5, NORTH_WALL_Z), "CornerNE")

	var streetscape := Node3D.new()
	streetscape.name = "Streetscape"
	root_node.add_child(streetscape)

	var benches: Array[StaticBody3D] = []
	for index in range(PLAZA_BENCH_POSITIONS.size()):
		var position: Vector2 = PLAZA_BENCH_POSITIONS[index]
		benches.append(_build_bench(streetscape, "PlazaBench%02d" % (index + 1), position))

	var lanterns: Array[Node3D] = []
	for index in range(SPINE_LANTERN_POSITIONS.size()):
		var position: Vector2 = SPINE_LANTERN_POSITIONS[index]
		lanterns.append(_build_lantern(streetscape, "SpineLantern%02d" % (index + 1), position))

	var wayfinding: Array[Node3D] = []
	for index in range(WAYFINDING_POSITIONS.size()):
		var position: Vector2 = WAYFINDING_POSITIONS[index]
		wayfinding.append(_build_wayfinding(streetscape, "Wayfinding%02d" % (index + 1), position))

	_anchor(root_node, "G13_SouthGateApproachAnchor", Vector3(0.0, 0.90, 31.0))
	_anchor(root_node, "G13_PlazaSouthAnchor", Vector3(0.0, 0.90, 13.0))
	_anchor(root_node, "G13_PlazaNorthAnchor", Vector3(0.0, 0.90, -13.0))
	_anchor(root_node, "G13_NorthGateApproachAnchor", Vector3(0.0, 0.90, -31.0))

	return {
		"root": root_node,
		"wall_holder": wall_holder,
		"wall_modules": wall_modules,
		"streetscape": streetscape,
		"benches": benches,
		"lanterns": lanterns,
		"wayfinding": wayfinding,
		"wall_module_count": wall_modules.size(),
		"side_wall_x": SIDE_WALL_X,
		"side_wall_inner_edge_abs_x": SIDE_WALL_INNER_EDGE_X,
	}

static func _infrastructure_matches(infrastructure: Dictionary) -> bool:
	if not infrastructure.has("settlement_envelope"):
		return false
	if not infrastructure.has("main_spine"):
		return false
	if not infrastructure.has("central_cross_street"):
		return false
	if not infrastructure.has("south_gate") or not infrastructure.has("north_gate"):
		return false

	var envelope := (infrastructure["settlement_envelope"] as Dictionary).get("bounds", {}) as Dictionary
	if not _bounds_match(envelope, -30.0, 30.0, -36.0, 34.0):
		return false

	var main_spine := infrastructure["main_spine"] as Dictionary
	var spine_bounds := main_spine.get("bounds", {}) as Dictionary
	if not _bounds_match(spine_bounds, -4.0, 4.0, -35.0, 33.0):
		return false
	if not is_equal_approx(float(main_spine.get("width_m", 0.0)), 8.0):
		return false

	var cross := infrastructure["central_cross_street"] as Dictionary
	var cross_bounds := cross.get("bounds", {}) as Dictionary
	if not _bounds_match(cross_bounds, -20.0, 20.0, -2.5, 2.5):
		return false

	var south_gate := infrastructure["south_gate"] as Dictionary
	var north_gate := infrastructure["north_gate"] as Dictionary
	return (
		(south_gate.get("center_xz", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(0.0, 33.0))
		and is_equal_approx(float(south_gate.get("clear_width_m", 0.0)), 8.0)
		and (north_gate.get("center_xz", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(0.0, -35.0))
		and is_equal_approx(float(north_gate.get("clear_width_m", 0.0)), 8.0)
	)

static func _add_side_modules(parent: Node3D, modules: Array[StaticBody3D], x: float, prefix: String) -> void:
	for index in range(SIDE_SEGMENT_Z.size()):
		var z := float(SIDE_SEGMENT_Z[index])
		var body := _wall_module(
			parent,
			"%sWall%02d" % [prefix, index + 1],
			Vector3(x, WALL_HEIGHT_M * 0.5, z),
			Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, 4.0),
			"SET01_WALL_STRAIGHT_A"
		)
		modules.append(body)

static func _add_horizontal_modules(
	parent: Node3D,
	modules: Array[StaticBody3D],
	x_positions: Array,
	z: float,
	prefix: String
) -> void:
	for index in range(x_positions.size()):
		var x := float(x_positions[index])
		var body := _wall_module(
			parent,
			"%sWall%02d" % [prefix, index + 1],
			Vector3(x, WALL_HEIGHT_M * 0.5, z),
			Vector3(4.0, WALL_HEIGHT_M, WALL_THICKNESS_M),
			"SET01_WALL_STRAIGHT_A"
		)
		modules.append(body)

static func _add_corner_module(
	parent: Node3D,
	modules: Array[StaticBody3D],
	position: Vector3,
	name: String
) -> void:
	modules.append(_wall_module(
		parent,
		name,
		position,
		Vector3(1.0, WALL_HEIGHT_M, 1.0),
		"SET01_WALL_CORNER_OUT"
	))

static func _wall_module(
	parent: Node3D,
	name: String,
	position: Vector3,
	size: Vector3,
	family: String
) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name
	body.position = position
	body.set_meta("pixel_rpg_wall_family", family)
	body.set_meta("pixel_rpg_shared_owner", SHARED_OWNER)
	body.set_meta("pixel_rpg_graybox_pass", "G13")
	body.set_meta("pixel_rpg_module_size", size)
	parent.add_child(body)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = size
	visual.mesh = mesh
	visual.material_override = _material(WALL_COLOR)
	body.add_child(visual)

	var base := MeshInstance3D.new()
	base.name = "StoneBaseVisual"
	var base_mesh := BoxMesh.new()
	base_mesh.size = Vector3(size.x, minf(0.70, size.y), size.z)
	base.mesh = base_mesh
	base.position.y = -size.y * 0.5 + minf(0.70, size.y) * 0.5
	base.material_override = _material(STONE_BASE)
	body.add_child(base)

	var shape_node := CollisionShape3D.new()
	shape_node.name = "Shape"
	var shape := BoxShape3D.new()
	shape.size = size
	shape_node.shape = shape
	body.add_child(shape_node)
	return body

static func _build_bench(parent: Node3D, name: String, center: Vector2) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name
	body.position = Vector3(center.x, 0.42, center.y)
	body.set_meta("pixel_rpg_prop_family", "SET01_PROP_BENCH_A")
	body.set_meta("pixel_rpg_shared_owner", SHARED_OWNER)
	body.set_meta("pixel_rpg_graybox_pass", "G13")
	parent.add_child(body)

	var visual := MeshInstance3D.new()
	visual.name = "Visual"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.8, 0.84, 0.52)
	visual.mesh = mesh
	visual.material_override = _material(WOOD_LIGHT)
	body.add_child(visual)

	var shape_node := CollisionShape3D.new()
	shape_node.name = "Shape"
	var shape := BoxShape3D.new()
	shape.size = Vector3(1.8, 0.84, 0.52)
	shape_node.shape = shape
	body.add_child(shape_node)

	_anchor(body, "SeatAnchor", Vector3(0.0, 0.50, 0.0))
	return body

static func _build_lantern(parent: Node3D, name: String, center: Vector2) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_presentation_only", true)
	root.set_meta("pixel_rpg_shared_owner", SHARED_OWNER)
	parent.add_child(root)

	_box(root, "Post", Vector3(0.0, 1.30, 0.0), Vector3(0.12, 2.60, 0.12), LANTERN_METAL)
	_box(root, "LanternHousing", Vector3(0.0, 2.45, 0.0), Vector3(0.42, 0.52, 0.42), LANTERN_METAL)
	_box(root, "GlowMarker", Vector3(0.0, 2.45, 0.0), Vector3(0.22, 0.30, 0.22), LANTERN_GLOW)
	_anchor(root, "LightSocket", Vector3(0.0, 2.45, 0.0))
	return root

static func _build_wayfinding(parent: Node3D, name: String, center: Vector2) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_presentation_only", true)
	root.set_meta("pixel_rpg_shared_owner", SHARED_OWNER)
	parent.add_child(root)

	_box(root, "Post", Vector3(0.0, 1.10, 0.0), Vector3(0.14, 2.20, 0.14), WALL_SUPPORT)
	_box(root, "SignA", Vector3(0.38, 1.65, 0.0), Vector3(0.90, 0.30, 0.10), SIGN_COLOR)
	_box(root, "SignB", Vector3(-0.34, 1.33, 0.0), Vector3(0.80, 0.28, 0.10), SIGN_COLOR)
	_anchor(root, "WayfindingAnchor", Vector3(0.0, 1.10, 0.0))
	return root

static func _bounds_match(bounds: Dictionary, min_x: float, max_x: float, min_z: float, max_z: float) -> bool:
	return (
		is_equal_approx(float(bounds.get("min_x", 0.0)), min_x)
		and is_equal_approx(float(bounds.get("max_x", 0.0)), max_x)
		and is_equal_approx(float(bounds.get("min_z", 0.0)), min_z)
		and is_equal_approx(float(bounds.get("max_z", 0.0)), max_z)
	)

static func _anchor(parent: Node3D, name: String, position: Vector3) -> Marker3D:
	var anchor := Marker3D.new()
	anchor.name = name
	anchor.position = position
	parent.add_child(anchor)
	return anchor

static func _box(parent: Node3D, name: String, position: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	node.position = position
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.material_override = _material(color)
	parent.add_child(node)
	return node

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
