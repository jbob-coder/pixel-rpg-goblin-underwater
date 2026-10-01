extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_graybox.g01.v1"

const Layout := preload("res://scripts/world/settlement/settlement_01_layout_g00.gd")

const ROOT_NAME := "Settlement01GrayboxG01"
const FLOOR_NAME := "SettlementFloor"
const MAIN_SPINE_NAME := "MainHunterSpine"
const CROSS_STREET_NAME := "CentralCrossStreet"
const DEBUG_MARKERS_NAME := "DebugSectionBoundaries"

const FLOOR_THICKNESS_M := 0.7
const ROAD_VISUAL_THICKNESS_M := 0.08
const FLOOR_COLOR := Color(0.19, 0.29, 0.16)
const MAIN_SPINE_COLOR := Color(0.38, 0.30, 0.20)
const CROSS_STREET_COLOR := Color(0.42, 0.34, 0.24)
const DEBUG_MARKER_COLOR := Color(0.86, 0.60, 0.12)

static func get_schema() -> String:
	return SCHEMA

static func build(parent: Node3D, include_debug_markers := false) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G01 graybox requires a valid parent.")
		return {}

	var root := Node3D.new()
	root.name = ROOT_NAME
	root.set_meta("settlement_id", Layout.SETTLEMENT_ID)
	root.set_meta("schema", SCHEMA)
	parent.add_child(root)

	var settlement_bounds := Layout.get_settlement_bounds()
	var floor := _add_floor(root, settlement_bounds)

	var shared := Layout.get_shared_infrastructure_specs()
	var main_spine := _add_visual_surface(
		root,
		MAIN_SPINE_NAME,
		shared["main_spine"] as Dictionary,
		0.03,
		MAIN_SPINE_COLOR
	)
	var cross_street := _add_visual_surface(
		root,
		CROSS_STREET_NAME,
		shared["central_cross_street"] as Dictionary,
		0.031,
		CROSS_STREET_COLOR
	)

	var debug_markers: Node3D = null
	if include_debug_markers:
		debug_markers = _add_debug_section_boundaries(root)

	return {
		"root": root,
		"floor": floor,
		"main_spine": main_spine,
		"cross_street": cross_street,
		"debug_markers": debug_markers,
	}

static func _add_floor(parent: Node3D, bounds: Dictionary) -> StaticBody3D:
	var x_min := float(bounds.get("x_min", 0.0))
	var x_max := float(bounds.get("x_max", 0.0))
	var z_min := float(bounds.get("z_min", 0.0))
	var z_max := float(bounds.get("z_max", 0.0))
	var width := x_max - x_min
	var depth := z_max - z_min

	var body := StaticBody3D.new()
	body.name = FLOOR_NAME
	body.position = Vector3((x_min + x_max) * 0.5, -FLOOR_THICKNESS_M * 0.5, (z_min + z_max) * 0.5)
	body.set_meta("physics_owner", "SETTLEMENT_GROUND")
	parent.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(width, FLOOR_THICKNESS_M, depth)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(FLOOR_COLOR)
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	collision.name = "Collision"
	var shape := BoxShape3D.new()
	shape.size = Vector3(width, FLOOR_THICKNESS_M, depth)
	collision.shape = shape
	body.add_child(collision)

	return body

static func _add_visual_surface(
	parent: Node3D,
	node_name: String,
	spec: Dictionary,
	y: float,
	color: Color
) -> Node3D:
	var x_min := float(spec.get("x_min", 0.0))
	var x_max := float(spec.get("x_max", 0.0))
	var z_min := float(spec.get("z_min", 0.0))
	var z_max := float(spec.get("z_max", 0.0))

	var holder := Node3D.new()
	holder.name = node_name
	holder.position = Vector3((x_min + x_max) * 0.5, y, (z_min + z_max) * 0.5)
	holder.set_meta("physics_owner", String(spec.get("physics_owner", "")))
	holder.set_meta("presentation_only", true)
	parent.add_child(holder)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(x_max - x_min, ROAD_VISUAL_THICKNESS_M, z_max - z_min)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color)
	holder.add_child(mesh_instance)

	return holder

static func _add_debug_section_boundaries(parent: Node3D) -> Node3D:
	var debug_root := Node3D.new()
	debug_root.name = DEBUG_MARKERS_NAME
	debug_root.set_meta("debug_only", true)
	parent.add_child(debug_root)

	_add_debug_marker(debug_root, "Boundary_S01_SouthBand", Vector3(0.0, 0.05, 14.0), Vector3(60.0, 0.04, 0.10))
	_add_debug_marker(debug_root, "Boundary_S05_NorthBand", Vector3(0.0, 0.05, -14.0), Vector3(60.0, 0.04, 0.10))
	_add_debug_marker(debug_root, "Boundary_S03_WestLocal", Vector3(-14.0, 0.05, 0.0), Vector3(0.10, 0.04, 28.0))
	_add_debug_marker(debug_root, "Boundary_S04_EastWork", Vector3(14.0, 0.05, 0.0), Vector3(0.10, 0.04, 28.0))

	return debug_root

static func _add_debug_marker(parent: Node3D, marker_name: String, position: Vector3, size: Vector3) -> MeshInstance3D:
	var marker := MeshInstance3D.new()
	marker.name = marker_name
	marker.position = position
	marker.set_meta("debug_only", true)
	var mesh := BoxMesh.new()
	mesh.size = size
	marker.mesh = mesh
	marker.material_override = _material(DEBUG_MARKER_COLOR)
	parent.add_child(marker)
	return marker

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
