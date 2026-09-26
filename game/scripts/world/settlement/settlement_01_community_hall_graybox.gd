class_name PixelRPGSettlement01CommunityHallGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_community_hall_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "CommunityHallCivicCoreGraybox"
const HALL_NAME := "Settlement01CommunityHall"
const BUILDING_ID := "SET01_BLD_COMMUNITY_HALL"
const SECTION_ID := "SET01_S03"
const AREA_ID := "SET01_A06_COMMUNITY_HALL_CIVIC_CORE"

const FOOTPRINT_WIDTH_M := 8.0
const FOOTPRINT_DEPTH_M := 10.0
const WALL_HEIGHT_M := 3.8
const WALL_THICKNESS_M := 0.26
const DOOR_WIDTH_M := 1.8
const DOOR_HEIGHT_M := 2.4
const DOOR_CENTER_Z_M := 1.5
const INTERIOR_HALF_X_M := 3.72
const INTERIOR_HALF_Z_M := 4.72

const WOOD_DARK := Color(0.24, 0.17, 0.11)
const WOOD_MID := Color(0.38, 0.27, 0.17)
const WOOD_LIGHT := Color(0.53, 0.39, 0.23)
const STONE := Color(0.34, 0.36, 0.33)
const ROOF := Color(0.19, 0.14, 0.11)
const CIVIC := Color(0.28, 0.38, 0.46)
const NOTICE := Color(0.50, 0.38, 0.21)

static func get_schema() -> String:
	return SCHEMA

static func add_community_hall(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G04 Community Hall requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G04 Community Hall requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	if not building_specs.has(BUILDING_ID):
		push_error("Settlement 01 G04 Community Hall building spec is missing.")
		return {}

	var building := building_specs[BUILDING_ID] as Dictionary
	if String(building.get("section_id", "")) != SECTION_ID or String(building.get("area_id", "")) != AREA_ID:
		push_error("Settlement 01 G04 Community Hall ownership does not match the locked layout contract.")
		return {}

	var center: Vector2 = building.get("center_xz", Vector2.ZERO)
	var footprint: Vector2 = building.get("footprint_xz", Vector2.ZERO)
	if not footprint.is_equal_approx(Vector2(FOOTPRINT_WIDTH_M, FOOTPRINT_DEPTH_M)):
		push_error("Settlement 01 G04 Community Hall footprint disagrees with the locked layout contract.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)

	var hall := _build_hall(root_node)
	hall.position = Vector3(center.x, 0.0, center.y)
	hall.set_meta("pixel_rpg_building_id", BUILDING_ID)
	hall.set_meta("pixel_rpg_section_id", SECTION_ID)
	hall.set_meta("pixel_rpg_area_id", AREA_ID)
	hall.set_meta("pixel_rpg_building_family", "COMMUNITY_HALL")
	hall.set_meta("pixel_rpg_graybox_pass", "G04")
	hall.set_meta("pixel_rpg_final_art_locked", false)

	return {
		"root": root_node,
		"hall": hall,
		"building_id": BUILDING_ID,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"target_center_xz": center,
		"target_footprint_xz": footprint,
		"door_width_m": DOOR_WIDTH_M,
		"door_height_m": DOOR_HEIGHT_M,
		"door_center_z_m": DOOR_CENTER_Z_M,
	}

static func _build_hall(parent: Node3D) -> Node3D:
	var hall := Node3D.new()
	hall.name = HALL_NAME
	parent.add_child(hall)

	var half_width := FOOTPRINT_WIDTH_M * 0.5
	var half_depth := FOOTPRINT_DEPTH_M * 0.5
	var wall_y := WALL_HEIGHT_M * 0.5
	var east_x := half_width - WALL_THICKNESS_M * 0.5
	var west_x := -east_x
	var north_z := -half_depth + WALL_THICKNESS_M * 0.5
	var south_z := half_depth - WALL_THICKNESS_M * 0.5

	var door_min_z := DOOR_CENTER_Z_M - DOOR_WIDTH_M * 0.5
	var door_max_z := DOOR_CENTER_Z_M + DOOR_WIDTH_M * 0.5
	var east_north_len := door_min_z - (-half_depth)
	var east_south_len := half_depth - door_max_z
	var east_north_center_z := -half_depth + east_north_len * 0.5
	var east_south_center_z := door_max_z + east_south_len * 0.5
	var lintel_height := WALL_HEIGHT_M - DOOR_HEIGHT_M
	var lintel_y := DOOR_HEIGHT_M + lintel_height * 0.5

	_box(hall, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(7.5, 0.12, 9.5), STONE)
	_box(hall, "WestWall", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M), WOOD_MID)
	_box(hall, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(hall, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(hall, "EastWallNorth", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_north_len), WOOD_MID)
	_box(hall, "EastWallSouth", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_south_len), WOOD_MID)
	_box(hall, "EastLintel", Vector3(east_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M), WOOD_MID)

	_box(hall, "DoorFrameNorth", Vector3(east_x + 0.04, DOOR_HEIGHT_M * 0.5, door_min_z - 0.07), Vector3(0.18, DOOR_HEIGHT_M, 0.14), WOOD_DARK)
	_box(hall, "DoorFrameSouth", Vector3(east_x + 0.04, DOOR_HEIGHT_M * 0.5, door_max_z + 0.07), Vector3(0.18, DOOR_HEIGHT_M, 0.14), WOOD_DARK)
	_box(hall, "DoorFrameTop", Vector3(east_x + 0.04, DOOR_HEIGHT_M + 0.07, DOOR_CENTER_Z_M), Vector3(0.18, 0.14, DOOR_WIDTH_M + 0.28), WOOD_DARK)
	_box(hall, "Threshold", Vector3(east_x + 0.10, 0.06, DOOR_CENTER_Z_M), Vector3(0.46, 0.12, DOOR_WIDTH_M), STONE)

	_box(hall, "KeeperDesk", Vector3(2.25, 0.55, -2.55), Vector3(1.55, 1.10, 0.72), WOOD_DARK)
	_box(hall, "NoticeBoard", Vector3(west_x + 0.10, 1.45, -1.80), Vector3(0.12, 1.20, 1.65), NOTICE)
	_box(hall, "CivicSign", Vector3(east_x + 0.18, 2.60, -1.00), Vector3(0.12, 0.58, 1.45), CIVIC)
	_box(hall, "BenchNorth", Vector3(-1.65, 0.34, -1.75), Vector3(1.80, 0.68, 0.48), WOOD_LIGHT)
	_box(hall, "BenchSouth", Vector3(-1.65, 0.34, 2.35), Vector3(1.80, 0.68, 0.48), WOOD_LIGHT)

	var roof_group := Node3D.new()
	roof_group.name = "RoofVisibilityGroup"
	hall.add_child(roof_group)
	_box(roof_group, "RoofWest", Vector3(-2.0, 4.48, 0.0), Vector3(4.6, 0.45, 10.8), ROOF, Vector3(0.0, 0.0, -20.0))
	_box(roof_group, "RoofEast", Vector3(2.0, 4.48, 0.0), Vector3(4.6, 0.45, 10.8), ROOF, Vector3(0.0, 0.0, 20.0))
	_box(roof_group, "RidgeBeam", Vector3(0.0, 4.18, 0.0), Vector3(0.24, 0.30, 10.2), WOOD_DARK)

	_anchor(hall, "EntranceAnchor", Vector3(half_width + 0.55, 0.90, DOOR_CENTER_Z_M))
	_anchor(hall, "ExitAnchor", Vector3(half_width - 0.55, 0.90, DOOR_CENTER_Z_M))
	_anchor(hall, "UseAnchor", Vector3(2.20, 0.90, -1.65))
	_anchor(hall, "HallCenterAnchor", Vector3(0.0, 0.90, 0.0))
	_anchor(hall, "KeeperWorkAnchor", Vector3(2.40, 0.90, -2.50))
	_anchor(hall, "NoticeBoardAnchor", Vector3(-3.40, 1.40, -1.80))
	_anchor(hall, "NPCIdleAnchor_01", Vector3(-1.75, 0.90, -1.05))
	_anchor(hall, "NPCIdleAnchor_02", Vector3(0.60, 0.90, -1.05))
	_anchor(hall, "NPCIdleAnchor_03", Vector3(-1.75, 0.90, 2.10))
	_anchor(hall, "NPCIdleAnchor_04", Vector3(0.60, 0.90, 2.10))
	_anchor(hall, "EventGatherAnchor_01", Vector3(-0.85, 0.90, 0.45))
	_anchor(hall, "EventGatherAnchor_02", Vector3(0.85, 0.90, 0.45))

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	hall.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(7.5, 0.12, 9.5))
	_collision_box(collision_root, "WestWallCollision", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "EastNorthCollision", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_north_len))
	_collision_box(collision_root, "EastSouthCollision", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_south_len))
	_collision_box(collision_root, "EastLintelCollision", Vector3(east_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M))

	return hall

static func is_inside(local_position: Vector3) -> bool:
	return (
		absf(local_position.x) <= INTERIOR_HALF_X_M
		and absf(local_position.z) <= INTERIOR_HALF_Z_M
		and local_position.y >= -0.25
		and local_position.y <= WALL_HEIGHT_M + 0.25
	)

static func _anchor(parent: Node3D, name: String, position: Vector3) -> Marker3D:
	var anchor := Marker3D.new()
	anchor.name = name
	anchor.position = position
	parent.add_child(anchor)
	return anchor

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
