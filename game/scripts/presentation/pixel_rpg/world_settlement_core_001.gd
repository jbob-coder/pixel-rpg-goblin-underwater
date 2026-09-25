class_name PixelRPGWorldSettlementCore001
extends RefCounted

const SCHEMA := "pixel_rpg.world_settlement_core_001.v1"

const GENERIC_BUILDING_A_POSITION := Vector3(-7.0, 1.7, 8.5)
const GENERIC_BUILDING_A_SIZE := Vector3(7.0, 3.4, 7.0)
const GENERIC_BUILDING_A_COLOR := Color(0.34, 0.22, 0.13)

const MARKET_POSITION := Vector3(7.0, 0.0, 6.0)
const MARKET_YAW_DEG := -90.0

const SMITH_POSITION := Vector3(-7.4, 0.0, -1.5)
const SMITH_YAW_DEG := 90.0

const GENERIC_BUILDING_B_POSITION := Vector3(7.5, 1.6, -3.0)
const GENERIC_BUILDING_B_SIZE := Vector3(6.8, 3.2, 6.4)
const GENERIC_BUILDING_B_COLOR := Color(0.36, 0.23, 0.13)

const ROOF_COLOR := Color(0.20, 0.12, 0.08)

const WorldPack001 := preload("res://scripts/presentation/pixel_rpg/world_pack_001.gd")
const WorldPack004EnterableSmith := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")
const SettlementBuildingDetailsScene: PackedScene = preload("res://assets/environment/starting_area/settlement_building_details_01.tscn")

static func get_schema() -> String:
	return SCHEMA

static func add_settlement_core(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Pixel RPG World Settlement Core 001 requires a valid parent.")
		return {}

	var building_a := _add_generic_building(
		parent,
		GENERIC_BUILDING_A_POSITION,
		GENERIC_BUILDING_A_SIZE,
		GENERIC_BUILDING_A_COLOR
	)
	var market := WorldPack001.add_market_stall(parent, MARKET_POSITION, MARKET_YAW_DEG)
	var smith_root := WorldPack004EnterableSmith.add_enterable_smith(parent, SMITH_POSITION, SMITH_YAW_DEG)
	var smith_use_anchor := smith_root.get_node_or_null("UseAnchor") as Node3D if smith_root != null else null
	var building_b := _add_generic_building(
		parent,
		GENERIC_BUILDING_B_POSITION,
		GENERIC_BUILDING_B_SIZE,
		GENERIC_BUILDING_B_COLOR
	)

	return {
		"building_a": building_a,
		"market": market,
		"smith_root": smith_root,
		"smith_use_anchor": smith_use_anchor,
		"building_b": building_b,
	}

static func _add_generic_building(parent: Node3D, position: Vector3, size: Vector3, color: Color) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = "Building"
	body.position = position
	parent.add_child(body)

	var building_mesh := MeshInstance3D.new()
	var building_box := BoxMesh.new()
	building_box.size = size
	building_mesh.mesh = building_box
	building_mesh.material_override = _material(color)
	body.add_child(building_mesh)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)

	var roof := Node3D.new()
	roof.name = "Roof"
	roof.position = position + Vector3(0.0, size.y * 0.5 + 0.45, 0.0)
	parent.add_child(roof)

	var roof_mesh := MeshInstance3D.new()
	var roof_box := BoxMesh.new()
	roof_box.size = Vector3(size.x + 0.6, 0.9, size.z + 0.6)
	roof_mesh.mesh = roof_box
	roof_mesh.material_override = _material(ROOF_COLOR)
	roof.add_child(roof_mesh)

	var details := SettlementBuildingDetailsScene.instantiate() as Node3D
	if details == null:
		push_error("Pixel RPG World Settlement Core 001 failed to instantiate settlement building details.")
		return body
	details.name = "SettlementBuildingDetails"
	details.position = position
	details.scale = Vector3(size.x / 7.0, size.y / 3.4, size.z / 7.0)
	details.set_meta("pixel_rpg_settlement_building_details", true)
	parent.add_child(details)

	return body

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
