class_name PixelRPGSettlement01WorkSupportGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_work_support_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "StorageWorkshopYardGraybox"
const SECTION_ID := "SET01_S04"
const AREA_ID := "SET01_A10_STORAGE_WORKSHOP_YARD"
const STORAGE_ID := "SET01_BLD_WORK_STORAGE"
const CANOPY_ID := "SET01_BLD_WORK_CANOPY"

const FOOTPRINT := Vector2(7.0, 6.0)
const STORAGE_WALL_HEIGHT_M := 3.2
const WALL_THICKNESS_M := 0.24
const STORAGE_DOOR_WIDTH_M := 1.8
const STORAGE_DOOR_HEIGHT_M := 2.3
const STORAGE_DOOR_CENTER_Z_M := 0.8

const WOOD_DARK := Color(0.24, 0.17, 0.11)
const WOOD_MID := Color(0.40, 0.28, 0.16)
const WOOD_LIGHT := Color(0.54, 0.39, 0.22)
const STONE := Color(0.34, 0.36, 0.33)
const ROOF := Color(0.20, 0.14, 0.10)
const WORK_ACCENT := Color(0.43, 0.32, 0.18)

static func get_schema() -> String:
	return SCHEMA

static func add_work_support(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G06 Work Support requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G06 Work Support requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	for building_id: String in [CANOPY_ID, STORAGE_ID]:
		if not building_specs.has(building_id):
			push_error("Settlement 01 G06 missing building spec %s." % building_id)
			return {}
		var spec: Dictionary = building_specs[building_id] as Dictionary
		if String(spec.get("section_id", "")) != SECTION_ID or String(spec.get("area_id", "")) != AREA_ID:
			push_error("Settlement 01 G06 ownership mismatch for %s." % building_id)
			return {}
		var footprint: Vector2 = spec.get("footprint_xz", Vector2.ZERO)
		if not footprint.is_equal_approx(FOOTPRINT):
			push_error("Settlement 01 G06 footprint mismatch for %s." % building_id)
			return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)

	var canopy_spec: Dictionary = building_specs[CANOPY_ID] as Dictionary
	var storage_spec: Dictionary = building_specs[STORAGE_ID] as Dictionary

	var canopy := _build_canopy(root_node)
	var canopy_center: Vector2 = canopy_spec.get("center_xz", Vector2.ZERO)
	canopy.position = Vector3(canopy_center.x, 0.0, canopy_center.y)
	_apply_metadata(canopy, CANOPY_ID, "WORK_CANOPY")

	var storage := _build_storage(root_node)
	var storage_center: Vector2 = storage_spec.get("center_xz", Vector2.ZERO)
	storage.position = Vector3(storage_center.x, 0.0, storage_center.y)
	_apply_metadata(storage, STORAGE_ID, "WORK_STORAGE")

	return {
		"root": root_node,
		"canopy": canopy,
		"storage": storage,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"canopy_id": CANOPY_ID,
		"storage_id": STORAGE_ID,
		"footprint_xz": FOOTPRINT,
		"storage_door_width_m": STORAGE_DOOR_WIDTH_M,
		"storage_door_height_m": STORAGE_DOOR_HEIGHT_M,
	}

static func _apply_metadata(node: Node3D, building_id: String, family: String) -> void:
	node.set_meta("pixel_rpg_building_id", building_id)
	node.set_meta("pixel_rpg_building_family", family)
	node.set_meta("pixel_rpg_section_id", SECTION_ID)
	node.set_meta("pixel_rpg_area_id", AREA_ID)
	node.set_meta("pixel_rpg_graybox_pass", "G06")
	node.set_meta("pixel_rpg_final_art_locked", false)

static func _build_storage(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01WorkStorage"
	parent.add_child(root)

	var half_x: float = FOOTPRINT.x * 0.5
	var half_z: float = FOOTPRINT.y * 0.5
	var wall_y: float = STORAGE_WALL_HEIGHT_M * 0.5
	var west_x: float = -half_x + WALL_THICKNESS_M * 0.5
	var east_x: float = half_x - WALL_THICKNESS_M * 0.5
	var north_z: float = -half_z + WALL_THICKNESS_M * 0.5
	var south_z: float = half_z - WALL_THICKNESS_M * 0.5

	var door_min_z: float = STORAGE_DOOR_CENTER_Z_M - STORAGE_DOOR_WIDTH_M * 0.5
	var door_max_z: float = STORAGE_DOOR_CENTER_Z_M + STORAGE_DOOR_WIDTH_M * 0.5
	var west_north_len: float = door_min_z - (-half_z)
	var west_south_len: float = half_z - door_max_z
	var west_north_center_z: float = -half_z + west_north_len * 0.5
	var west_south_center_z: float = door_max_z + west_south_len * 0.5
	var lintel_height: float = STORAGE_WALL_HEIGHT_M - STORAGE_DOOR_HEIGHT_M
	var lintel_y: float = STORAGE_DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5), STONE)
	_box(root, "EastWall", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, STORAGE_WALL_HEIGHT_M, FOOTPRINT.y), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT.x, STORAGE_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT.x, STORAGE_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "WestWallNorth", Vector3(west_x, wall_y, west_north_center_z), Vector3(WALL_THICKNESS_M, STORAGE_WALL_HEIGHT_M, west_north_len), WOOD_MID)
	_box(root, "WestWallSouth", Vector3(west_x, wall_y, west_south_center_z), Vector3(WALL_THICKNESS_M, STORAGE_WALL_HEIGHT_M, west_south_len), WOOD_MID)
	_box(root, "WestLintel", Vector3(west_x, lintel_y, STORAGE_DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, STORAGE_DOOR_WIDTH_M), WOOD_MID)

	_box(root, "StorageRackNorth", Vector3(1.95, 1.05, -1.85), Vector3(1.10, 2.10, 0.55), WOOD_DARK)
	_box(root, "StorageRackSouth", Vector3(1.95, 1.05, 1.60), Vector3(1.10, 2.10, 0.55), WOOD_DARK)
	_box(root, "StorageCrate", Vector3(0.30, 0.42, -1.85), Vector3(1.15, 0.84, 0.90), WORK_ACCENT)

	var roof_group := Node3D.new()
	roof_group.name = "RoofVisibilityGroup"
	root.add_child(roof_group)
	_box(roof_group, "RoofWest", Vector3(-1.75, 3.78, 0.0), Vector3(4.0, 0.40, 6.7), ROOF, Vector3(0.0, 0.0, -18.0))
	_box(roof_group, "RoofEast", Vector3(1.75, 3.78, 0.0), Vector3(4.0, 0.40, 6.7), ROOF, Vector3(0.0, 0.0, 18.0))
	_box(roof_group, "RidgeBeam", Vector3(0.0, 3.62, 0.0), Vector3(0.20, 0.26, 6.2), WOOD_DARK)

	_anchor(root, "EntranceAnchor", Vector3(-half_x - 0.50, 0.90, STORAGE_DOOR_CENTER_Z_M))
	_anchor(root, "ExitAnchor", Vector3(-half_x + 0.50, 0.90, STORAGE_DOOR_CENTER_Z_M))
	_anchor(root, "StorageUseAnchor", Vector3(0.90, 0.90, 0.0))
	_anchor(root, "WorkerIdleAnchor", Vector3(-0.80, 0.90, -0.70))
	_anchor(root, "LoadingAnchor", Vector3(-half_x - 1.20, 0.0, -0.80))
	for i in range(4):
		_anchor(root, "RackSocket_%02d" % (i + 1), Vector3(1.85, 0.90, -2.0 + float(i) * 1.25))

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5))
	_collision_box(collision_root, "EastWallCollision", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, STORAGE_WALL_HEIGHT_M, FOOTPRINT.y))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT.x, STORAGE_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT.x, STORAGE_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "WestNorthCollision", Vector3(west_x, wall_y, west_north_center_z), Vector3(WALL_THICKNESS_M, STORAGE_WALL_HEIGHT_M, west_north_len))
	_collision_box(collision_root, "WestSouthCollision", Vector3(west_x, wall_y, west_south_center_z), Vector3(WALL_THICKNESS_M, STORAGE_WALL_HEIGHT_M, west_south_len))
	_collision_box(collision_root, "WestLintelCollision", Vector3(west_x, lintel_y, STORAGE_DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, STORAGE_DOOR_WIDTH_M))

	return root

static func _build_canopy(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01WorkCanopy"
	parent.add_child(root)

	var half_x: float = FOOTPRINT.x * 0.5
	var half_z: float = FOOTPRINT.y * 0.5
	var post_x: float = half_x - 0.35
	var post_z: float = half_z - 0.35

	_box(root, "CanopyRoof", Vector3(0.0, 3.05, 0.0), Vector3(7.4, 0.35, 6.4), ROOF)
	_box(root, "WorkBench", Vector3(1.20, 0.65, -1.65), Vector3(2.20, 1.30, 0.70), WOOD_DARK)
	_box(root, "MaterialRack", Vector3(2.60, 1.00, 1.45), Vector3(0.70, 2.00, 1.90), WOOD_MID)

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)

	var post_positions: Array[Vector3] = [
		Vector3(-post_x, 1.45, -post_z),
		Vector3(post_x, 1.45, -post_z),
		Vector3(-post_x, 1.45, post_z),
		Vector3(post_x, 1.45, post_z),
	]
	for i in range(post_positions.size()):
		var post_position: Vector3 = post_positions[i]
		_box(root, "Post%02d" % (i + 1), post_position, Vector3(0.32, 2.90, 0.32), WOOD_DARK)
		_collision_box(collision_root, "PostCollision%02d" % (i + 1), post_position, Vector3(0.32, 2.90, 0.32))

	_collision_box(collision_root, "WorkBenchCollision", Vector3(1.20, 0.65, -1.65), Vector3(2.20, 1.30, 0.70))
	_collision_box(collision_root, "MaterialRackCollision", Vector3(2.60, 1.00, 1.45), Vector3(0.70, 2.00, 1.90))

	_anchor(root, "WorkAnchor_01", Vector3(-0.80, 0.90, -1.20))
	_anchor(root, "WorkAnchor_02", Vector3(0.10, 0.90, 1.25))
	_anchor(root, "MaterialRackAnchor", Vector3(2.15, 0.90, 1.45))
	_anchor(root, "CartAnchor", Vector3(-half_x - 1.10, 0.0, 0.80))
	_anchor(root, "WorkerIdleAnchor", Vector3(-1.20, 0.90, 0.20))
	_anchor(root, "ServiceLaneAnchor", Vector3(-half_x - 0.70, 0.0, 0.0))

	return root

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
