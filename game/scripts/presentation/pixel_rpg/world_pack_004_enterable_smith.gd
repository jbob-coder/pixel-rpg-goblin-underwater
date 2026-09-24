class_name PixelRPGWorldPack004EnterableSmith
extends RefCounted

const FOOTPRINT_WIDTH_M := 6.6
const FOOTPRINT_DEPTH_M := 6.4
const WALL_HEIGHT_M := 3.3
const WALL_THICKNESS_M := 0.26
const DOOR_WIDTH_M := 1.8
const DOOR_HEIGHT_M := 2.4
const INTERIOR_HALF_X_M := 3.0
const INTERIOR_HALF_Z_M := 2.9

const WOOD_DARK := Color(0.26, 0.18, 0.11)
const WOOD_MID := Color(0.40, 0.27, 0.15)
const WOOD_LIGHT := Color(0.52, 0.36, 0.20)
const STONE := Color(0.33, 0.35, 0.32)
const STEEL := Color(0.31, 0.33, 0.31)
const ROOF := Color(0.20, 0.12, 0.08)
const EMBER := Color(0.70, 0.24, 0.09)

const SMITH_VISUAL_ASSET_PACK_SCHEMA := "pixel_rpg.starting_area_asset_pack_002_smith_visual.v1"
const SmithForgeDetailScene: PackedScene = preload("res://assets/environment/starting_area/smith_forge_detail_01.tscn")
const SmithAnvilDetailScene: PackedScene = preload("res://assets/environment/starting_area/smith_anvil_detail_01.tscn")
const SmithBenchDetailScene: PackedScene = preload("res://assets/environment/starting_area/smith_bench_detail_01.tscn")
const SmithFrontageDetailScene: PackedScene = preload("res://assets/environment/starting_area/smith_frontage_detail_01.tscn")

static func add_enterable_smith(parent: Node3D, position: Vector3, yaw_deg := 0.0) -> Node3D:
	var root := Node3D.new()
	root.name = "WorldPack004EnterableSmith"
	root.position = position
	root.rotation_degrees.y = yaw_deg
	parent.add_child(root)

	var half_width := FOOTPRINT_WIDTH_M * 0.5
	var half_depth := FOOTPRINT_DEPTH_M * 0.5
	var wall_y := WALL_HEIGHT_M * 0.5
	var front_z := half_depth - WALL_THICKNESS_M * 0.5
	var back_z := -front_z
	var side_x := half_width - WALL_THICKNESS_M * 0.5
	var front_side_width := (FOOTPRINT_WIDTH_M - DOOR_WIDTH_M) * 0.5
	var front_side_x := DOOR_WIDTH_M * 0.5 + front_side_width * 0.5
	var lintel_height := WALL_HEIGHT_M - DOOR_HEIGHT_M
	var lintel_y := DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(6.25, 0.12, 6.05), STONE)
	_box(root, "BackWall", Vector3(0.0, wall_y, back_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "LeftWall", Vector3(-side_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M), WOOD_MID)
	_box(root, "RightWall", Vector3(side_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M), WOOD_MID)
	_box(root, "FrontWallLeft", Vector3(-front_side_x, wall_y, front_z), Vector3(front_side_width, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "FrontWallRight", Vector3(front_side_x, wall_y, front_z), Vector3(front_side_width, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "FrontLintel", Vector3(0.0, lintel_y, front_z), Vector3(DOOR_WIDTH_M, lintel_height, WALL_THICKNESS_M), WOOD_MID)

	_box(root, "DoorFrameLeft", Vector3(-DOOR_WIDTH_M * 0.5 - 0.07, DOOR_HEIGHT_M * 0.5, front_z + 0.04), Vector3(0.14, DOOR_HEIGHT_M, 0.18), WOOD_DARK)
	_box(root, "DoorFrameRight", Vector3(DOOR_WIDTH_M * 0.5 + 0.07, DOOR_HEIGHT_M * 0.5, front_z + 0.04), Vector3(0.14, DOOR_HEIGHT_M, 0.18), WOOD_DARK)
	_box(root, "DoorFrameTop", Vector3(0.0, DOOR_HEIGHT_M + 0.07, front_z + 0.04), Vector3(DOOR_WIDTH_M + 0.28, 0.14, 0.18), WOOD_DARK)
	_box(root, "Threshold", Vector3(0.0, 0.06, front_z + 0.10), Vector3(DOOR_WIDTH_M, 0.12, 0.46), STONE)

	_box(root, "RoofA", Vector3(-1.65, 3.75, 0.0), Vector3(3.8, 0.45, 7.2), ROOF, Vector3(0.0, 0.0, -18.0))
	_box(root, "RoofB", Vector3(1.65, 3.75, 0.0), Vector3(3.8, 0.45, 7.2), ROOF, Vector3(0.0, 0.0, 18.0))
	_box(root, "RidgeBeam", Vector3(0.0, 3.58, 0.0), Vector3(0.22, 0.28, 6.7), WOOD_DARK)

	_box(root, "ForgeHearth", Vector3(1.95, 0.48, -1.48), Vector3(1.65, 0.96, 1.25), STONE)
	_box(root, "ForgeEmber", Vector3(1.95, 1.02, -1.48), Vector3(1.08, 0.12, 0.72), EMBER)
	_box(root, "SmithBench", Vector3(-1.85, 0.72, -1.55), Vector3(1.75, 1.44, 0.72), WOOD_DARK)
	_box(root, "AnvilBase", Vector3(1.35, 0.42, 0.42), Vector3(0.52, 0.84, 0.52), WOOD_DARK)
	_box(root, "AnvilTop", Vector3(1.35, 0.92, 0.42), Vector3(1.05, 0.22, 0.48), STEEL)
	_box(root, "ToolRack", Vector3(-3.00, 1.55, -0.35), Vector3(0.14, 1.65, 1.85), WOOD_DARK)
	_box(root, "SmithSign", Vector3(2.25, 2.25, front_z + 0.18), Vector3(1.25, 0.55, 0.12), WOOD_LIGHT)

	var visual_details := Node3D.new()
	visual_details.name = "SmithVisualDetails"
	root.add_child(visual_details)
	_instance_visual_detail(visual_details, SmithForgeDetailScene, "SmithForgeDetail01")
	_instance_visual_detail(visual_details, SmithAnvilDetailScene, "SmithAnvilDetail01")
	_instance_visual_detail(visual_details, SmithBenchDetailScene, "SmithBenchDetail01")
	_instance_visual_detail(visual_details, SmithFrontageDetailScene, "SmithFrontageDetail01")

	var entrance_anchor := Node3D.new()
	entrance_anchor.name = "EntranceAnchor"
	entrance_anchor.position = Vector3(0.0, 0.9, half_depth + 0.55)
	root.add_child(entrance_anchor)

	var use_anchor := Node3D.new()
	use_anchor.name = "UseAnchor"
	use_anchor.position = Vector3(0.85, 0.9, 0.55)
	root.add_child(use_anchor)

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(6.25, 0.12, 6.05))
	_collision_box(collision_root, "BackWallCollision", Vector3(0.0, wall_y, back_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "LeftWallCollision", Vector3(-side_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M))
	_collision_box(collision_root, "RightWallCollision", Vector3(side_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M))
	_collision_box(collision_root, "FrontLeftCollision", Vector3(-front_side_x, wall_y, front_z), Vector3(front_side_width, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "FrontRightCollision", Vector3(front_side_x, wall_y, front_z), Vector3(front_side_width, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "FrontLintelCollision", Vector3(0.0, lintel_y, front_z), Vector3(DOOR_WIDTH_M, lintel_height, WALL_THICKNESS_M))

	return root

static func _instance_visual_detail(parent: Node3D, scene: PackedScene, expected_name: String) -> Node3D:
	if parent == null or scene == null:
		push_error("Pixel RPG smith visual detail requires a valid parent and PackedScene.")
		return null
	var instance := scene.instantiate() as Node3D
	if instance == null:
		push_error("Pixel RPG smith visual detail failed to instantiate " + expected_name)
		return null
	instance.name = expected_name
	parent.add_child(instance)
	return instance

static func is_inside(local_position: Vector3) -> bool:
	return (
		absf(local_position.x) <= INTERIOR_HALF_X_M
		and absf(local_position.z) <= INTERIOR_HALF_Z_M
		and local_position.y >= -0.25
		and local_position.y <= WALL_HEIGHT_M + 0.25
	)

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

static func _collision_box(parent: Node3D, name: String, position: Vector3, size: Vector3) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name
	body.position = position
	parent.add_child(body)
	var collision := CollisionShape3D.new()
	collision.name = "Shape"
	var shape := BoxShape3D.new()
	shape.size = size
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
