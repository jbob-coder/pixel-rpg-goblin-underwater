class_name PixelRPGWorldPack001
extends RefCounted

const WOOD_DARK := Color(0.26, 0.18, 0.11)
const WOOD_MID := Color(0.40, 0.27, 0.15)
const WOOD_LIGHT := Color(0.52, 0.36, 0.20)
const STONE := Color(0.33, 0.35, 0.32)
const ROOF := Color(0.20, 0.12, 0.08)
const CLOTH_RED := Color(0.48, 0.18, 0.15)
const CLOTH_BLUE := Color(0.18, 0.28, 0.42)
const FOLIAGE_DARK := Color(0.12, 0.28, 0.15)
const FOLIAGE_MID := Color(0.20, 0.38, 0.18)
const LANTERN_GLOW := Color(0.95, 0.62, 0.20)

const STARTING_AREA_ASSET_PACK_SCHEMA := "pixel_rpg.starting_area_asset_pack_001.v1"
const SettlementGateScene: PackedScene = preload("res://assets/environment/starting_area/settlement_gate_01.tscn")
const MarketStallScene: PackedScene = preload("res://assets/environment/starting_area/market_stall_01.tscn")
const ServiceClutterScene: PackedScene = preload("res://assets/environment/starting_area/service_clutter_01.tscn")
const SignpostScene: PackedScene = preload("res://assets/environment/starting_area/signpost_01.tscn")
const LanternPostScene: PackedScene = preload("res://assets/environment/starting_area/lantern_post_01.tscn")
const ENVIRONMENT_DRESSING_SCHEMA := "pixel_rpg.starting_area_asset_pack_003_environment_dressing.v1"
const FenceScene: PackedScene = preload("res://assets/environment/starting_area/fence_01.tscn")
const BannerPostScene: PackedScene = preload("res://assets/environment/starting_area/banner_post_01.tscn")
const VegetationClusterScene: PackedScene = preload("res://assets/environment/starting_area/vegetation_cluster_01.tscn")
const RockClusterScene: PackedScene = preload("res://assets/environment/starting_area/rock_cluster_01.tscn")

static func add_settlement_gate(parent: Node3D, position: Vector3) -> Node3D:
	return _instance_asset(parent, SettlementGateScene, "WorldPack001Gate", position)

static func add_service_smith(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	var root := _root(parent, "WorldPack001Smith", position, yaw_deg)
	_box(root, "MainShell", Vector3(0.0, 1.65, 0.0), Vector3(6.6, 3.3, 6.4), WOOD_MID)
	_box(root, "StoneBase", Vector3(0.0, 0.45, 0.0), Vector3(6.9, 0.9, 6.7), STONE)
	_box(root, "RoofA", Vector3(-1.65, 3.75, 0.0), Vector3(3.8, 0.45, 7.2), ROOF, Vector3(0.0, 0.0, -18.0))
	_box(root, "RoofB", Vector3(1.65, 3.75, 0.0), Vector3(3.8, 0.45, 7.2), ROOF, Vector3(0.0, 0.0, 18.0))
	_box(root, "Door", Vector3(0.0, 1.15, 3.25), Vector3(1.5, 2.3, 0.16), WOOD_DARK)
	_box(root, "ForgeCanopy", Vector3(2.5, 2.45, 3.55), Vector3(2.2, 0.25, 1.5), CLOTH_RED)
	_box(root, "ForgeTable", Vector3(2.5, 0.75, 3.55), Vector3(2.0, 1.5, 1.1), WOOD_DARK)
	return root

static func add_market_stall(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, MarketStallScene, "WorldPack001Market", position, yaw_deg)

static func add_service_clutter(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, ServiceClutterScene, "WorldPack001Clutter", position, yaw_deg)

static func add_signpost(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, SignpostScene, "WorldPack001Signpost", position, yaw_deg)

static func add_lantern_post(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, LanternPostScene, "WorldPack001Lantern", position, yaw_deg)

static func add_fence(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, FenceScene, "WorldPack001Fence", position, yaw_deg)

static func add_banner_post(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, BannerPostScene, "WorldPack001Banner", position, yaw_deg)

static func add_vegetation_cluster(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, VegetationClusterScene, "WorldPack001Vegetation", position, yaw_deg)

static func add_rock_cluster(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	return _instance_asset(parent, RockClusterScene, "WorldPack001Rocks", position, yaw_deg)

static func _tree(parent: Node3D, name: String, position: Vector3, radius: float, height: float, crown_radius: float) -> void:
	_cylinder(parent, name + "Trunk", position + Vector3(0.0, height * 0.5, 0.0), radius, height, WOOD_DARK, 6)
	_sphere(parent, name + "Canopy", position + Vector3(0.0, height + crown_radius * 0.55, 0.0), crown_radius, FOLIAGE_DARK)

static func _instance_asset(parent: Node3D, scene: PackedScene, expected_name: String, position: Vector3, yaw_deg := 0.0) -> Node3D:
	if parent == null or scene == null:
		push_error("Pixel RPG Starting Area Asset Pack 001 requires a valid parent and PackedScene.")
		return null
	var instance := scene.instantiate() as Node3D
	if instance == null:
		push_error("Pixel RPG Starting Area Asset Pack 001 failed to instantiate " + expected_name)
		return null
	instance.name = expected_name
	instance.position = position
	instance.rotation_degrees.y = yaw_deg
	parent.add_child(instance)
	return instance

static func _root(parent: Node3D, name: String, position: Vector3, yaw_deg := 0.0) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = position
	root.rotation_degrees.y = yaw_deg
	parent.add_child(root)
	return root

static func _box(parent: Node3D, name: String, position: Vector3, size: Vector3, color: Color, rotation_deg := Vector3.ZERO) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.position = position
	node.rotation_degrees = rotation_deg
	node.material_override = _material(color)
	parent.add_child(node)
	return node

static func _cylinder(parent: Node3D, name: String, position: Vector3, radius: float, height: float, color: Color, segments: int) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius * 0.86
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = segments
	node.mesh = mesh
	node.position = position
	node.material_override = _material(color)
	parent.add_child(node)
	return node

static func _sphere(parent: Node3D, name: String, position: Vector3, radius: float, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 8
	mesh.rings = 4
	node.mesh = mesh
	node.position = position
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
