class_name PixelRPGWorldPaths001
extends RefCounted

const SCHEMA := "pixel_rpg.world_paths_001.v1"

const STREET_NAME := "Street"
const STREET_POSITION := Vector3(0.0, 0.03, 2.0)
const STREET_SIZE := Vector3(6.2, 0.10, 34.0)
const STREET_COLOR := Color(0.38, 0.30, 0.20)
const STREET_DETAILS_NAME := "StreetSurfaceDetails"

const TRAIL_NAME := "Trail"
const TRAIL_POSITION := Vector3(0.0, 0.04, -31.0)
const TRAIL_SIZE := Vector3(4.2, 0.11, 34.0)
const TRAIL_COLOR := Color(0.29, 0.24, 0.16)
const TRAIL_DETAILS_NAME := "TrailSurfaceDetails"

const StreetSurfaceDetailsScene: PackedScene = preload("res://assets/environment/starting_area/street_surface_details_01.tscn")
const TrailSurfaceDetailsScene: PackedScene = preload("res://assets/environment/starting_area/trail_surface_details_01.tscn")

static func get_schema() -> String:
	return SCHEMA

static func add_paths(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Pixel RPG World Paths 001 requires a valid parent.")
		return {}

	var street := _add_surface(parent, STREET_NAME, STREET_POSITION, STREET_SIZE, STREET_COLOR)
	var trail := _add_surface(parent, TRAIL_NAME, TRAIL_POSITION, TRAIL_SIZE, TRAIL_COLOR)
	var street_details := _add_detail(parent, StreetSurfaceDetailsScene, STREET_DETAILS_NAME, STREET_POSITION)
	var trail_details := _add_detail(parent, TrailSurfaceDetailsScene, TRAIL_DETAILS_NAME, TRAIL_POSITION)

	return {
		"street": street,
		"trail": trail,
		"street_details": street_details,
		"trail_details": trail_details,
	}

static func _add_surface(parent: Node3D, node_name: String, position: Vector3, size: Vector3, color: Color) -> Node3D:
	var holder := Node3D.new()
	holder.name = node_name
	holder.position = position
	parent.add_child(holder)

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color)
	holder.add_child(mesh_instance)
	return holder

static func _add_detail(parent: Node3D, scene: PackedScene, node_name: String, position: Vector3) -> Node3D:
	var detail := scene.instantiate() as Node3D
	if detail == null:
		push_error("Pixel RPG World Paths 001 failed to instantiate " + node_name)
		return null
	detail.name = node_name
	detail.position = position
	parent.add_child(detail)
	return detail

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
