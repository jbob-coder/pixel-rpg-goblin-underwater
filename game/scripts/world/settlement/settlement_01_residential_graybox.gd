class_name PixelRPGSettlement01ResidentialGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_residential_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "WestResidentialClusterGraybox"
const SECTION_ID := "SET01_S03"
const AREA_ID := "SET01_A07_WEST_RESIDENTIAL_CLUSTER"
const FAMILY_ID := "SET01_BLD_RESIDENCE_A"
const BUILDING_W02 := "SET01_BLD_RES_W02"
const BUILDING_W01 := "SET01_BLD_RES_W01"

const FOOTPRINT_WIDTH_M := 7.0
const FOOTPRINT_DEPTH_M := 5.5
const WALL_HEIGHT_M := 3.2
const WALL_THICKNESS_M := 0.24
const DOOR_WIDTH_M := 1.6
const DOOR_HEIGHT_M := 2.3
const DOOR_CENTER_Z_M := 0.8
const INTERIOR_HALF_X_M := 3.20
const INTERIOR_HALF_Z_M := 2.45

const WOOD_DARK := Color(0.24, 0.17, 0.11)
const WOOD_MID := Color(0.42, 0.30, 0.18)
const WOOD_LIGHT := Color(0.54, 0.39, 0.23)
const STONE := Color(0.34, 0.36, 0.33)
const ROOF_A := Color(0.22, 0.14, 0.10)
const ROOF_B := Color(0.24, 0.16, 0.11)
const BED_A := Color(0.34, 0.39, 0.42)
const BED_B := Color(0.38, 0.34, 0.28)

static func get_schema() -> String:
	return SCHEMA

static func get_family_id() -> String:
	return FAMILY_ID

static func get_building_ids() -> Array[String]:
	return [BUILDING_W02, BUILDING_W01]

static func add_residences(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G05 Residences require a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G05 Residences require a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	for building_id in get_building_ids():
		if not building_specs.has(building_id):
			push_error("Settlement 01 G05 missing building spec %s." % building_id)
			return {}
		var spec := building_specs[building_id] as Dictionary
		if String(spec.get("section_id", "")) != SECTION_ID or String(spec.get("area_id", "")) != AREA_ID:
			push_error("Settlement 01 G05 ownership mismatch for %s." % building_id)
			return {}
		var footprint: Vector2 = spec.get("footprint_xz", Vector2.ZERO)
		if not footprint.is_equal_approx(Vector2(FOOTPRINT_WIDTH_M, FOOTPRINT_DEPTH_M)):
			push_error("Settlement 01 G05 footprint mismatch for %s." % building_id)
			return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)

	var w02 := _add_residence(root_node, BUILDING_W02, "Settlement01ResidenceW02", "A_NORTH", ROOF_A, BED_A, building_specs[BUILDING_W02] as Dictionary)
	var w01 := _add_residence(root_node, BUILDING_W01, "Settlement01ResidenceW01", "A_SOUTH", ROOF_B, BED_B, building_specs[BUILDING_W01] as Dictionary)

	return {
		"root": root_node,
		"residence_w02": w02,
		"residence_w01": w01,
		"family_id": FAMILY_ID,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"building_ids": get_building_ids(),
	}

static func _add_residence(
	parent: Node3D,
	building_id: String,
	node_name: String,
	variant_id: String,
	roof_color: Color,
	bed_color: Color,
	spec: Dictionary
) -> Node3D:
	var center: Vector2 = spec.get("center_xz", Vector2.ZERO)
	var residence := _build_residence(parent, node_name, roof_color, bed_color)
	residence.position = Vector3(center.x, 0.0, center.y)
	residence.set_meta("pixel_rpg_building_id", building_id)
	residence.set_meta("pixel_rpg_building_family", FAMILY_ID)
	residence.set_meta("pixel_rpg_section_id", SECTION_ID)
	residence.set_meta("pixel_rpg_area_id", AREA_ID)
	residence.set_meta("pixel_rpg_residence_variant", variant_id)
	residence.set_meta("pixel_rpg_graybox_pass", "G05")
	residence.set_meta("pixel_rpg_final_art_locked", false)
	return residence

static func _build_residence(parent: Node3D, node_name: String, roof_color: Color, bed_color: Color) -> Node3D:
	var root := Node3D.new()
	root.name = node_name
	parent.add_child(root)

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

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.0), STONE)
	_box(root, "WestWall", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "EastWallNorth", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_north_len), WOOD_MID)
	_box(root, "EastWallSouth", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_south_len), WOOD_MID)
	_box(root, "EastLintel", Vector3(east_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M), WOOD_MID)

	_box(root, "DoorFrameNorth", Vector3(east_x + 0.04, DOOR_HEIGHT_M * 0.5, door_min_z - 0.07), Vector3(0.18, DOOR_HEIGHT_M, 0.14), WOOD_DARK)
	_box(root, "DoorFrameSouth", Vector3(east_x + 0.04, DOOR_HEIGHT_M * 0.5, door_max_z + 0.07), Vector3(0.18, DOOR_HEIGHT_M, 0.14), WOOD_DARK)
	_box(root, "DoorFrameTop", Vector3(east_x + 0.04, DOOR_HEIGHT_M + 0.07, DOOR_CENTER_Z_M), Vector3(0.18, 0.14, DOOR_WIDTH_M + 0.28), WOOD_DARK)
	_box(root, "Threshold", Vector3(east_x + 0.10, 0.06, DOOR_CENTER_Z_M), Vector3(0.46, 0.12, DOOR_WIDTH_M), STONE)

	_box(root, "LivingTable", Vector3(0.35, 0.42, 0.0), Vector3(1.35, 0.84, 0.80), WOOD_LIGHT)
	_box(root, "RestBed", Vector3(-2.10, 0.38, -1.35), Vector3(1.45, 0.76, 1.85), bed_color)
	_box(root, "StorageChest", Vector3(-2.25, 0.36, 1.55), Vector3(1.25, 0.72, 0.72), WOOD_DARK)

	var roof_group := Node3D.new()
	roof_group.name = "RoofVisibilityGroup"
	root.add_child(roof_group)
	_box(roof_group, "RoofWest", Vector3(-1.75, 3.78, 0.0), Vector3(4.0, 0.40, 6.20), roof_color, Vector3(0.0, 0.0, -18.0))
	_box(roof_group, "RoofEast", Vector3(1.75, 3.78, 0.0), Vector3(4.0, 0.40, 6.20), roof_color, Vector3(0.0, 0.0, 18.0))
	_box(roof_group, "RidgeBeam", Vector3(0.0, 3.62, 0.0), Vector3(0.20, 0.26, 5.80), WOOD_DARK)

	_anchor(root, "EntranceAnchor", Vector3(half_width + 0.50, 0.90, DOOR_CENTER_Z_M))
	_anchor(root, "ExitAnchor", Vector3(half_width - 0.50, 0.90, DOOR_CENTER_Z_M))
	_anchor(root, "InteriorCenterAnchor", Vector3(0.0, 0.90, 0.0))
	_anchor(root, "ResidentIdleAnchor", Vector3(-0.40, 0.90, 0.45))
	_anchor(root, "ResidentRestAnchor", Vector3(-2.00, 0.90, -1.20))
	_anchor(root, "YardAnchor", Vector3(half_width + 1.30, 0.0, 0.0))

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.0))
	_collision_box(collision_root, "WestWallCollision", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT_DEPTH_M))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT_WIDTH_M, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "EastNorthCollision", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_north_len))
	_collision_box(collision_root, "EastSouthCollision", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_south_len))
	_collision_box(collision_root, "EastLintelCollision", Vector3(east_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M))

	return root

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
