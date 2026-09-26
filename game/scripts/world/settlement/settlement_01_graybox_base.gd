class_name PixelRPGSettlement01GrayboxBase
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_graybox_base.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "Settlement01GrayboxBase"
const FLOOR_NAME := "SettlementFloor"
const MAIN_SPINE_NAME := "MainHunterSpine"
const CROSS_STREET_NAME := "CentralCrossStreet"
const DEBUG_BOUNDARIES_NAME := "SectionBoundaryDebug"

const FLOOR_HEIGHT := 0.7
const FLOOR_CENTER_Y := -0.35
const SURFACE_HEIGHT := 0.08
const SURFACE_CENTER_Y := 0.04
const DEBUG_MARKER_HEIGHT := 0.025
const DEBUG_MARKER_CENTER_Y := 0.075

const FLOOR_COLOR := Color(0.18, 0.28, 0.16)
const MAIN_SPINE_COLOR := Color(0.39, 0.31, 0.20)
const CROSS_STREET_COLOR := Color(0.36, 0.29, 0.19)
const DEBUG_MARKER_COLOR := Color(0.72, 0.24, 0.20, 0.75)

static func get_schema() -> String:
	return SCHEMA

static func add_graybox_base(parent: Node3D, include_debug_boundaries := false) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 graybox base requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 graybox base requires a valid layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var infrastructure: Dictionary = LayoutContract.get_infrastructure_specs()
	var envelope := (infrastructure["settlement_envelope"] as Dictionary).get("bounds", {}) as Dictionary
	var main_spine := (infrastructure["main_spine"] as Dictionary).get("bounds", {}) as Dictionary
	var cross_street := (infrastructure["central_cross_street"] as Dictionary).get("bounds", {}) as Dictionary

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)

	var floor := _add_floor(root_node, envelope)
	var spine := _add_surface(root_node, MAIN_SPINE_NAME, main_spine, MAIN_SPINE_COLOR)
	var cross := _add_surface(root_node, CROSS_STREET_NAME, cross_street, CROSS_STREET_COLOR)
	var debug_boundaries: Node3D = null
	if include_debug_boundaries:
		debug_boundaries = _add_debug_boundaries(root_node)

	return {
		"root": root_node,
		"floor": floor,
		"main_spine": spine,
		"cross_street": cross,
		"debug_boundaries": debug_boundaries,
	}

static func _add_floor(parent: Node3D, bounds: Dictionary) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = FLOOR_NAME
	body.position = _center_for_bounds(bounds, FLOOR_CENTER_Y)
	parent.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = _size_for_bounds(bounds, FLOOR_HEIGHT)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(FLOOR_COLOR)
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	collision.name = "Collision"
	var shape := BoxShape3D.new()
	shape.size = _size_for_bounds(bounds, FLOOR_HEIGHT)
	collision.shape = shape
	body.add_child(collision)
	return body

static func _add_surface(parent: Node3D, node_name: String, bounds: Dictionary, color: Color) -> Node3D:
	var holder := Node3D.new()
	holder.name = node_name
	holder.position = _center_for_bounds(bounds, SURFACE_CENTER_Y)
	parent.add_child(holder)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = _size_for_bounds(bounds, SURFACE_HEIGHT)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color)
	holder.add_child(mesh_instance)
	return holder

static func _add_debug_boundaries(parent: Node3D) -> Node3D:
	var holder := Node3D.new()
	holder.name = DEBUG_BOUNDARIES_NAME
	parent.add_child(holder)

	_add_debug_marker(holder, "BoundaryS01S02", Vector3(0.0, DEBUG_MARKER_CENTER_Y, 14.0), Vector3(60.0, DEBUG_MARKER_HEIGHT, 0.08))
	_add_debug_marker(holder, "BoundaryS02S05", Vector3(0.0, DEBUG_MARKER_CENTER_Y, -14.0), Vector3(60.0, DEBUG_MARKER_HEIGHT, 0.08))
	_add_debug_marker(holder, "BoundaryS02S03", Vector3(-14.0, DEBUG_MARKER_CENTER_Y, 0.0), Vector3(0.08, DEBUG_MARKER_HEIGHT, 28.0))
	_add_debug_marker(holder, "BoundaryS02S04", Vector3(14.0, DEBUG_MARKER_CENTER_Y, 0.0), Vector3(0.08, DEBUG_MARKER_HEIGHT, 28.0))
	return holder

static func _add_debug_marker(parent: Node3D, marker_name: String, position: Vector3, size: Vector3) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = marker_name
	mesh_instance.position = position
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(DEBUG_MARKER_COLOR)
	parent.add_child(mesh_instance)

static func _center_for_bounds(bounds: Dictionary, y: float) -> Vector3:
	return Vector3(
		(float(bounds.get("min_x", 0.0)) + float(bounds.get("max_x", 0.0))) * 0.5,
		y,
		(float(bounds.get("min_z", 0.0)) + float(bounds.get("max_z", 0.0))) * 0.5
	)

static func _size_for_bounds(bounds: Dictionary, y_size: float) -> Vector3:
	return Vector3(
		float(bounds.get("max_x", 0.0)) - float(bounds.get("min_x", 0.0)),
		y_size,
		float(bounds.get("max_z", 0.0)) - float(bounds.get("min_z", 0.0))
	)

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	if color.a < 1.0:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return material
