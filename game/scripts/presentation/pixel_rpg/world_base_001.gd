class_name PixelRPGWorldBase001
extends RefCounted

const SCHEMA := "pixel_rpg.world_base_001.v1"
const GROUND_NAME := "Ground"
const GROUND_POSITION := Vector3(0.0, -0.35, -18.0)
const GROUND_SIZE := Vector3(46.0, 0.7, 78.0)
const GROUND_COLOR := Color(0.19, 0.29, 0.16)

static func get_schema() -> String:
	return SCHEMA

static func add_world_base(parent: Node3D) -> StaticBody3D:
	if parent == null:
		push_error("Pixel RPG World Base 001 requires a valid parent.")
		return null

	var body := StaticBody3D.new()
	body.name = GROUND_NAME
	body.position = GROUND_POSITION
	parent.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = GROUND_SIZE
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(GROUND_COLOR)
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = GROUND_SIZE
	collision.shape = shape
	body.add_child(collision)

	return body

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
