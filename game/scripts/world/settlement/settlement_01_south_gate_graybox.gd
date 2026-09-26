class_name PixelRPGSettlement01SouthGateGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_south_gate_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "SouthArrivalGateGraybox"
const SECTION_ID := "SET01_S01"
const AREA_ID := "SET01_A01_SOUTH_ARRIVAL_GATE"
const GATEHOUSE_ID := "SET01_BLD_SOUTH_GATEHOUSE_W"
const WATCH_ID := "SET01_BLD_SOUTH_WATCH_E"

const GATEHOUSE_FOOTPRINT := Vector2(8.0, 7.0)
const WATCH_FOOTPRINT := Vector2(6.0, 6.0)

const GATEHOUSE_WALL_HEIGHT_M := 3.6
const WATCH_WALL_HEIGHT_M := 3.3
const WALL_THICKNESS_M := 0.24

const GATEHOUSE_DOOR_WIDTH_M := 1.8
const GATEHOUSE_DOOR_HEIGHT_M := 2.4
const WATCH_DOOR_WIDTH_M := 1.6
const WATCH_DOOR_HEIGHT_M := 2.3

const GATE_CENTER := Vector2(0.0, 33.0)
const GATE_CLEAR_WIDTH_M := 8.0
const GATE_POST_WIDTH_M := 1.0
const GATE_POST_DEPTH_M := 1.0
const GATE_POST_HEIGHT_M := 5.2

const AREA_MIN_X := -14.0
const AREA_MAX_X := 14.0
const AREA_MIN_Z := 25.0
const AREA_MAX_Z := 34.0

const WOOD_DARK := Color(0.24, 0.17, 0.11)
const WOOD_MID := Color(0.40, 0.28, 0.16)
const WOOD_LIGHT := Color(0.54, 0.39, 0.22)
const STONE := Color(0.34, 0.36, 0.33)
const ROOF := Color(0.20, 0.14, 0.10)
const METAL := Color(0.22, 0.24, 0.24)
const GATE_ACCENT := Color(0.24, 0.32, 0.42)

static func get_schema() -> String:
	return SCHEMA

static func add_south_gate(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G08 South Gate requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G08 South Gate requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(AREA_ID):
		push_error("Settlement 01 G08 missing Area 01 layout spec.")
		return {}
	var area_spec := area_specs[AREA_ID] as Dictionary
	if String(area_spec.get("parent_section_id", "")) != SECTION_ID:
		push_error("Settlement 01 G08 Area 01 ownership mismatch.")
		return {}
	var bounds_parts: Array = area_spec.get("bounds_parts", [])
	if bounds_parts.size() != 1 or not _bounds_match(bounds_parts[0] as Dictionary, AREA_MIN_X, AREA_MAX_X, AREA_MIN_Z, AREA_MAX_Z):
		push_error("Settlement 01 G08 Area 01 bounds drifted from the spatial lock.")
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	for building_id: String in [GATEHOUSE_ID, WATCH_ID]:
		if not building_specs.has(building_id):
			push_error("Settlement 01 G08 missing building spec %s." % building_id)
			return {}
		var spec := building_specs[building_id] as Dictionary
		if String(spec.get("section_id", "")) != SECTION_ID or String(spec.get("area_id", "")) != AREA_ID:
			push_error("Settlement 01 G08 ownership mismatch for %s." % building_id)
			return {}

	var gatehouse_spec := building_specs[GATEHOUSE_ID] as Dictionary
	var watch_spec := building_specs[WATCH_ID] as Dictionary
	if not (gatehouse_spec.get("footprint_xz", Vector2.ZERO) as Vector2).is_equal_approx(GATEHOUSE_FOOTPRINT):
		push_error("Settlement 01 G08 Gatehouse footprint drifted from 8x7 m.")
		return {}
	if not (watch_spec.get("footprint_xz", Vector2.ZERO) as Vector2).is_equal_approx(WATCH_FOOTPRINT):
		push_error("Settlement 01 G08 Watch footprint drifted from 6x6 m.")
		return {}

	var infrastructure := LayoutContract.get_infrastructure_specs()
	var south_gate := infrastructure.get("south_gate", {}) as Dictionary
	var gate_center: Vector2 = south_gate.get("center_xz", Vector2.ZERO)
	var gate_width := float(south_gate.get("clear_width_m", 0.0))
	if not gate_center.is_equal_approx(GATE_CENTER) or not is_equal_approx(gate_width, GATE_CLEAR_WIDTH_M):
		push_error("Settlement 01 G08 South Gate center/width drifted from the layout contract.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G08")
	root_node.set_meta("pixel_rpg_final_art_locked", false)

	var gatehouse := _build_gatehouse(root_node)
	var gatehouse_center: Vector2 = gatehouse_spec.get("center_xz", Vector2.ZERO)
	gatehouse.position = Vector3(gatehouse_center.x, 0.0, gatehouse_center.y)
	_apply_building_metadata(gatehouse, GATEHOUSE_ID, "SOUTH_GATEHOUSE")

	var watch := _build_watch(root_node)
	var watch_center: Vector2 = watch_spec.get("center_xz", Vector2.ZERO)
	watch.position = Vector3(watch_center.x, 0.0, watch_center.y)
	_apply_building_metadata(watch, WATCH_ID, "SOUTH_WATCH")

	var gate_frame := _build_gate_frame(root_node)
	var wall_connectors := _build_wall_connectors(root_node)

	return {
		"root": root_node,
		"gatehouse": gatehouse,
		"watch": watch,
		"gate_frame": gate_frame,
		"wall_connectors": wall_connectors,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"gate_center_xz": GATE_CENTER,
		"gate_clear_width_m": GATE_CLEAR_WIDTH_M,
		"gatehouse_door_width_m": GATEHOUSE_DOOR_WIDTH_M,
		"gatehouse_door_height_m": GATEHOUSE_DOOR_HEIGHT_M,
		"watch_door_width_m": WATCH_DOOR_WIDTH_M,
		"watch_door_height_m": WATCH_DOOR_HEIGHT_M,
	}

static func _apply_building_metadata(node: Node3D, building_id: String, family: String) -> void:
	node.set_meta("pixel_rpg_building_id", building_id)
	node.set_meta("pixel_rpg_building_family", family)
	node.set_meta("pixel_rpg_section_id", SECTION_ID)
	node.set_meta("pixel_rpg_area_id", AREA_ID)
	node.set_meta("pixel_rpg_graybox_pass", "G08")
	node.set_meta("pixel_rpg_final_art_locked", false)

static func _build_gatehouse(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01SouthGatehouseW"
	parent.add_child(root)

	var half_x := GATEHOUSE_FOOTPRINT.x * 0.5
	var half_z := GATEHOUSE_FOOTPRINT.y * 0.5
	var wall_y := GATEHOUSE_WALL_HEIGHT_M * 0.5
	var west_x := -half_x + WALL_THICKNESS_M * 0.5
	var east_x := half_x - WALL_THICKNESS_M * 0.5
	var north_z := -half_z + WALL_THICKNESS_M * 0.5
	var south_z := half_z - WALL_THICKNESS_M * 0.5

	var door_min_z := -GATEHOUSE_DOOR_WIDTH_M * 0.5
	var door_max_z := GATEHOUSE_DOOR_WIDTH_M * 0.5
	var east_north_len := door_min_z - (-half_z)
	var east_south_len := half_z - door_max_z
	var east_north_center_z := -half_z + east_north_len * 0.5
	var east_south_center_z := door_max_z + east_south_len * 0.5
	var lintel_height := GATEHOUSE_WALL_HEIGHT_M - GATEHOUSE_DOOR_HEIGHT_M
	var lintel_y := GATEHOUSE_DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(7.5, 0.12, 6.5), STONE)
	_box(root, "WestWall", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, GATEHOUSE_WALL_HEIGHT_M, GATEHOUSE_FOOTPRINT.y), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(GATEHOUSE_FOOTPRINT.x, GATEHOUSE_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(GATEHOUSE_FOOTPRINT.x, GATEHOUSE_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "EastWallNorth", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, GATEHOUSE_WALL_HEIGHT_M, east_north_len), WOOD_MID)
	_box(root, "EastWallSouth", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, GATEHOUSE_WALL_HEIGHT_M, east_south_len), WOOD_MID)
	_box(root, "EastLintel", Vector3(east_x, lintel_y, 0.0), Vector3(WALL_THICKNESS_M, lintel_height, GATEHOUSE_DOOR_WIDTH_M), WOOD_MID)

	_box(root, "GuardDesk", Vector3(-0.9, 0.55, -1.5), Vector3(2.0, 1.1, 0.7), WOOD_DARK)
	_box(root, "WallStorage", Vector3(-2.8, 1.0, 1.9), Vector3(0.7, 2.0, 1.7), WOOD_DARK)
	_box(root, "NoticePanel", Vector3(2.85, 1.45, -2.3), Vector3(0.12, 1.3, 1.7), GATE_ACCENT)

	var roof_group := Node3D.new()
	roof_group.name = "RoofVisibilityGroup"
	root.add_child(roof_group)
	_box(roof_group, "RoofWest", Vector3(-2.0, 4.15, 0.0), Vector3(4.6, 0.40, 7.4), ROOF, Vector3(0.0, 0.0, -18.0))
	_box(roof_group, "RoofEast", Vector3(2.0, 4.15, 0.0), Vector3(4.6, 0.40, 7.4), ROOF, Vector3(0.0, 0.0, 18.0))
	_box(roof_group, "RidgeBeam", Vector3(0.0, 3.95, 0.0), Vector3(0.22, 0.28, 6.9), WOOD_DARK)

	_anchor(root, "EntranceAnchor", Vector3(half_x + 0.50, 0.90, 0.0))
	_anchor(root, "ExitAnchor", Vector3(half_x - 0.50, 0.90, 0.0))
	_anchor(root, "ArrivalGuardWorkAnchor", Vector3(-0.8, 0.90, -1.2))
	_anchor(root, "VisitorConversationAnchor", Vector3(1.25, 0.90, 0.0))
	_anchor(root, "GateControlAnchor", Vector3(2.5, 0.90, 1.8))
	_anchor(root, "NoticeAnchor", Vector3(2.45, 1.10, -2.2))
	_anchor(root, "GuardIdleAnchor", Vector3(-1.8, 0.90, 1.3))

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(7.5, 0.12, 6.5))
	_collision_box(collision_root, "WestWallCollision", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, GATEHOUSE_WALL_HEIGHT_M, GATEHOUSE_FOOTPRINT.y))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(GATEHOUSE_FOOTPRINT.x, GATEHOUSE_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(GATEHOUSE_FOOTPRINT.x, GATEHOUSE_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "EastNorthCollision", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, GATEHOUSE_WALL_HEIGHT_M, east_north_len))
	_collision_box(collision_root, "EastSouthCollision", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, GATEHOUSE_WALL_HEIGHT_M, east_south_len))
	_collision_box(collision_root, "EastLintelCollision", Vector3(east_x, lintel_y, 0.0), Vector3(WALL_THICKNESS_M, lintel_height, GATEHOUSE_DOOR_WIDTH_M))

	return root

static func _build_watch(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01SouthWatchE"
	parent.add_child(root)

	var half_x := WATCH_FOOTPRINT.x * 0.5
	var half_z := WATCH_FOOTPRINT.y * 0.5
	var wall_y := WATCH_WALL_HEIGHT_M * 0.5
	var west_x := -half_x + WALL_THICKNESS_M * 0.5
	var east_x := half_x - WALL_THICKNESS_M * 0.5
	var north_z := -half_z + WALL_THICKNESS_M * 0.5
	var south_z := half_z - WALL_THICKNESS_M * 0.5

	var door_min_z := -WATCH_DOOR_WIDTH_M * 0.5
	var door_max_z := WATCH_DOOR_WIDTH_M * 0.5
	var west_north_len := door_min_z - (-half_z)
	var west_south_len := half_z - door_max_z
	var west_north_center_z := -half_z + west_north_len * 0.5
	var west_south_center_z := door_max_z + west_south_len * 0.5
	var lintel_height := WATCH_WALL_HEIGHT_M - WATCH_DOOR_HEIGHT_M
	var lintel_y := WATCH_DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(5.5, 0.12, 5.5), STONE)
	_box(root, "EastWall", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WATCH_WALL_HEIGHT_M, WATCH_FOOTPRINT.y), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(WATCH_FOOTPRINT.x, WATCH_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(WATCH_FOOTPRINT.x, WATCH_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "WestWallNorth", Vector3(west_x, wall_y, west_north_center_z), Vector3(WALL_THICKNESS_M, WATCH_WALL_HEIGHT_M, west_north_len), WOOD_MID)
	_box(root, "WestWallSouth", Vector3(west_x, wall_y, west_south_center_z), Vector3(WALL_THICKNESS_M, WATCH_WALL_HEIGHT_M, west_south_len), WOOD_MID)
	_box(root, "WestLintel", Vector3(west_x, lintel_y, 0.0), Vector3(WALL_THICKNESS_M, lintel_height, WATCH_DOOR_WIDTH_M), WOOD_MID)

	var upper := Node3D.new()
	upper.name = "UpperWatchPresentation"
	root.add_child(upper)
	_box(upper, "UpperPlatform", Vector3(0.0, 4.10, 0.0), Vector3(5.3, 0.28, 5.3), WOOD_DARK)
	for pos in [
		Vector3(-2.25, 4.85, -2.25),
		Vector3(2.25, 4.85, -2.25),
		Vector3(-2.25, 4.85, 2.25),
		Vector3(2.25, 4.85, 2.25),
	]:
		_box(upper, "UpperPost%02d" % upper.get_child_count(), pos, Vector3(0.22, 1.55, 0.22), WOOD_DARK)
	_box(upper, "WatchCap", Vector3(0.0, 5.75, 0.0), Vector3(5.8, 0.35, 5.8), ROOF)

	_anchor(root, "GroundEntranceAnchor", Vector3(-half_x - 0.50, 0.90, 0.0))
	_anchor(root, "WatchGuardAnchor", Vector3(-0.8, 0.90, 0.6))
	_anchor(root, "LookoutAnchor", Vector3(0.0, 4.45, 0.0))
	_anchor(root, "LanternSocket", Vector3(-2.65, 2.2, 1.7))
	_anchor(root, "BannerSocket", Vector3(-2.65, 2.4, -1.6))

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(5.5, 0.12, 5.5))
	_collision_box(collision_root, "EastWallCollision", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WATCH_WALL_HEIGHT_M, WATCH_FOOTPRINT.y))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(WATCH_FOOTPRINT.x, WATCH_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(WATCH_FOOTPRINT.x, WATCH_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "WestNorthCollision", Vector3(west_x, wall_y, west_north_center_z), Vector3(WALL_THICKNESS_M, WATCH_WALL_HEIGHT_M, west_north_len))
	_collision_box(collision_root, "WestSouthCollision", Vector3(west_x, wall_y, west_south_center_z), Vector3(WALL_THICKNESS_M, WATCH_WALL_HEIGHT_M, west_south_len))
	_collision_box(collision_root, "WestLintelCollision", Vector3(west_x, lintel_y, 0.0), Vector3(WALL_THICKNESS_M, lintel_height, WATCH_DOOR_WIDTH_M))

	return root

static func _build_gate_frame(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01SouthGateFrame"
	root.position = Vector3(GATE_CENTER.x, 0.0, GATE_CENTER.y)
	parent.add_child(root)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	root.set_meta("pixel_rpg_graybox_pass", "G08")
	root.set_meta("pixel_rpg_gate_clear_width_m", GATE_CLEAR_WIDTH_M)

	var half_clear := GATE_CLEAR_WIDTH_M * 0.5
	var post_center_offset := half_clear + GATE_POST_WIDTH_M * 0.5

	_box(root, "GatePostLVisual", Vector3(-post_center_offset, GATE_POST_HEIGHT_M * 0.5, 0.0), Vector3(GATE_POST_WIDTH_M, GATE_POST_HEIGHT_M, GATE_POST_DEPTH_M), STONE)
	_box(root, "GatePostRVisual", Vector3(post_center_offset, GATE_POST_HEIGHT_M * 0.5, 0.0), Vector3(GATE_POST_WIDTH_M, GATE_POST_HEIGHT_M, GATE_POST_DEPTH_M), STONE)
	_box(root, "GateHeaderVisual", Vector3(0.0, 5.35, 0.0), Vector3(10.0, 0.40, 0.65), WOOD_DARK)

	var left_leaf := _box(root, "GateLeafL_OpenPresentation", Vector3(-5.55, 1.75, -0.80), Vector3(0.18, 3.5, 3.4), WOOD_MID)
	left_leaf.rotation_degrees.y = 0.0
	var right_leaf := _box(root, "GateLeafR_OpenPresentation", Vector3(5.55, 1.75, -0.80), Vector3(0.18, 3.5, 3.4), WOOD_MID)
	right_leaf.rotation_degrees.y = 0.0

	_anchor(root, "SouthGateCenterAnchor", Vector3.ZERO)
	_anchor(root, "SouthGateInnerArrivalAnchor", Vector3(0.0, 0.90, -1.8))
	_anchor(root, "SouthGateOuterArrivalAnchor", Vector3(0.0, 0.90, 1.8))

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "GatePostLCollision", Vector3(-post_center_offset, GATE_POST_HEIGHT_M * 0.5, 0.0), Vector3(GATE_POST_WIDTH_M, GATE_POST_HEIGHT_M, GATE_POST_DEPTH_M))
	_collision_box(collision_root, "GatePostRCollision", Vector3(post_center_offset, GATE_POST_HEIGHT_M * 0.5, 0.0), Vector3(GATE_POST_WIDTH_M, GATE_POST_HEIGHT_M, GATE_POST_DEPTH_M))

	return root

static func _build_wall_connectors(parent: Node3D) -> Array[StaticBody3D]:
	var connectors: Array[StaticBody3D] = []

	var left := _solid_box(
		parent,
		"SouthWallConnectorL",
		Vector3(-13.0, 2.4, 33.0),
		Vector3(2.0, 4.8, 1.0),
		STONE
	)
	left.set_meta("pixel_rpg_section_id", SECTION_ID)
	left.set_meta("pixel_rpg_area_id", AREA_ID)
	left.set_meta("pixel_rpg_graybox_pass", "G08")
	connectors.append(left)

	var right := _solid_box(
		parent,
		"SouthWallConnectorR",
		Vector3(12.5, 2.4, 33.0),
		Vector3(3.0, 4.8, 2.0),
		STONE
	)
	right.set_meta("pixel_rpg_section_id", SECTION_ID)
	right.set_meta("pixel_rpg_area_id", AREA_ID)
	right.set_meta("pixel_rpg_graybox_pass", "G08")
	connectors.append(right)

	return connectors

static func _bounds_match(bounds: Dictionary, min_x: float, max_x: float, min_z: float, max_z: float) -> bool:
	return (
		is_equal_approx(float(bounds.get("min_x", 0.0)), min_x)
		and is_equal_approx(float(bounds.get("max_x", 0.0)), max_x)
		and is_equal_approx(float(bounds.get("min_z", 0.0)), min_z)
		and is_equal_approx(float(bounds.get("max_z", 0.0)), max_z)
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
	node.position = position
	node.rotation_degrees = rotation_deg
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
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

static func _solid_box(parent: Node3D, name: String, position: Vector3, size: Vector3, color: Color) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name
	body.position = position
	parent.add_child(body)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color)
	body.add_child(mesh_instance)

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
