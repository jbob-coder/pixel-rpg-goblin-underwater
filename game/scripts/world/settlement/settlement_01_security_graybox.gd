class_name PixelRPGSettlement01SecurityGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_security_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "GateBarracksSecurityGraybox"
const BARRACKS_NAME := "Settlement01ArrivalGuardBarracks"
const CANOPY_NAME := "Settlement01SecurityBriefingCanopy"
const DUTY_BOARD_NAME := "Settlement01SecurityDutyBoard"

const SECTION_ID := "SET01_S01"
const AREA_ID := "SET01_A02_GATE_BARRACKS_SECURITY"
const BARRACKS_ID := "SET01_BLD_ARRIVAL_GUARD"

const FOOTPRINT := Vector2(7.0, 6.0)
const WALL_HEIGHT_M := 3.4
const WALL_THICKNESS_M := 0.24
const DOOR_WIDTH_M := 1.8
const DOOR_HEIGHT_M := 2.4
const DOOR_CENTER_Z_M := 0.0

const CANOPY_CENTER := Vector2(-27.0, 17.5)
const CANOPY_FOOTPRINT := Vector2(6.0, 4.0)
const CANOPY_POST_HEIGHT_M := 2.8

const RACK_A_CENTER := Vector2(-27.0, 25.4)
const RACK_B_CENTER := Vector2(-26.8, 22.7)
const DUTY_BOARD_CENTER := Vector2(-14.7, 18.2)
const TRAINING_TARGET_CENTER := Vector2(-25.7, 20.5)

const WOOD_DARK := Color(0.22, 0.15, 0.10)
const WOOD_MID := Color(0.39, 0.27, 0.16)
const WOOD_LIGHT := Color(0.55, 0.40, 0.23)
const STONE := Color(0.34, 0.36, 0.33)
const ROOF := Color(0.18, 0.14, 0.11)
const SECURITY_ACCENT := Color(0.26, 0.36, 0.48)
const BOARD_COLOR := Color(0.48, 0.36, 0.20)
const METAL := Color(0.24, 0.27, 0.29)

static func get_schema() -> String:
	return SCHEMA

static func add_security(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G09 Security requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G09 Security requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	if not building_specs.has(BARRACKS_ID):
		push_error("Settlement 01 G09 Security barracks building spec is missing.")
		return {}

	var barracks_spec := building_specs[BARRACKS_ID] as Dictionary
	if String(barracks_spec.get("section_id", "")) != SECTION_ID or String(barracks_spec.get("area_id", "")) != AREA_ID:
		push_error("Settlement 01 G09 Security ownership does not match the locked layout contract.")
		return {}

	var footprint: Vector2 = barracks_spec.get("footprint_xz", Vector2.ZERO)
	if not footprint.is_equal_approx(FOOTPRINT):
		push_error("Settlement 01 G09 Security barracks footprint disagrees with the locked layout contract.")
		return {}

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(AREA_ID):
		push_error("Settlement 01 G09 Security area spec is missing.")
		return {}
	var area := area_specs[AREA_ID] as Dictionary
	var bounds_parts := area.get("bounds_parts", []) as Array
	if bounds_parts.size() != 1:
		push_error("Settlement 01 G09 Security expects one locked A02 bounds part.")
		return {}

	var bounds := bounds_parts[0] as Dictionary
	if not _bounds_match(bounds, -30.0, -12.0, 14.0, 29.0):
		push_error("Settlement 01 G09 Security A02 bounds disagree with the spatial lock.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G09")
	root_node.set_meta("pixel_rpg_final_art_locked", false)
	parent.add_child(root_node)

	var barracks := _build_barracks(root_node)
	var center: Vector2 = barracks_spec.get("center_xz", Vector2.ZERO)
	barracks.position = Vector3(center.x, 0.0, center.y)
	_apply_building_metadata(barracks)

	var canopy := _build_canopy(root_node)
	canopy.position = Vector3(CANOPY_CENTER.x, 0.0, CANOPY_CENTER.y)
	canopy.set_meta("pixel_rpg_section_id", SECTION_ID)
	canopy.set_meta("pixel_rpg_area_id", AREA_ID)
	canopy.set_meta("pixel_rpg_graybox_pass", "G09")
	canopy.set_meta("pixel_rpg_final_art_locked", false)

	var racks: Array[Node3D] = []
	racks.append(_build_equipment_rack(root_node, "EquipmentRackA", RACK_A_CENTER, "POLEARM"))
	racks.append(_build_equipment_rack(root_node, "EquipmentRackB", RACK_B_CENTER, "SHIELD"))

	var duty_board := _build_duty_board(root_node)
	duty_board.position = Vector3(DUTY_BOARD_CENTER.x, 0.0, DUTY_BOARD_CENTER.y)

	var training_target := _build_training_target(root_node)
	training_target.position = Vector3(TRAINING_TARGET_CENTER.x, 0.0, TRAINING_TARGET_CENTER.y)

	_anchor(root_node, "A02_GuardDutyAnchor", Vector3(-19.0, 0.90, 22.1))
	_anchor(root_node, "A02_PatrolStartAnchor", Vector3(-17.0, 0.90, 20.0))
	_anchor(root_node, "A02_BriefingAnchor", Vector3(CANOPY_CENTER.x, 0.90, CANOPY_CENTER.y))
	_anchor(root_node, "A02_EquipmentUseAnchor", Vector3(-25.3, 0.90, 24.0))
	_anchor(root_node, "A02_GuardIdleAnchor_01", Vector3(-23.0, 0.90, 18.3))
	_anchor(root_node, "A02_GuardIdleAnchor_02", Vector3(-21.0, 0.90, 18.3))
	_anchor(root_node, "A02_RoadConnector_A01", Vector3(-12.2, 0.90, 23.0))
	_anchor(root_node, "A02_RoadConnector_A03", Vector3(-15.0, 0.90, 14.3))

	return {
		"root": root_node,
		"barracks": barracks,
		"canopy": canopy,
		"equipment_racks": racks,
		"duty_board": duty_board,
		"training_target": training_target,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"building_id": BARRACKS_ID,
		"target_center_xz": center,
		"target_footprint_xz": footprint,
		"door_width_m": DOOR_WIDTH_M,
		"door_height_m": DOOR_HEIGHT_M,
		"canopy_center_xz": CANOPY_CENTER,
		"canopy_footprint_xz": CANOPY_FOOTPRINT,
	}

static func _apply_building_metadata(node: Node3D) -> void:
	node.set_meta("pixel_rpg_building_id", BARRACKS_ID)
	node.set_meta("pixel_rpg_building_family", "ARRIVAL_GUARD_BARRACKS")
	node.set_meta("pixel_rpg_section_id", SECTION_ID)
	node.set_meta("pixel_rpg_area_id", AREA_ID)
	node.set_meta("pixel_rpg_graybox_pass", "G09")
	node.set_meta("pixel_rpg_final_art_locked", false)

static func _build_barracks(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = BARRACKS_NAME
	parent.add_child(root)

	var half_x := FOOTPRINT.x * 0.5
	var half_z := FOOTPRINT.y * 0.5
	var wall_y := WALL_HEIGHT_M * 0.5
	var east_x := half_x - WALL_THICKNESS_M * 0.5
	var west_x := -east_x
	var north_z := -half_z + WALL_THICKNESS_M * 0.5
	var south_z := half_z - WALL_THICKNESS_M * 0.5

	var door_min_z := DOOR_CENTER_Z_M - DOOR_WIDTH_M * 0.5
	var door_max_z := DOOR_CENTER_Z_M + DOOR_WIDTH_M * 0.5
	var east_north_len := door_min_z - (-half_z)
	var east_south_len := half_z - door_max_z
	var east_north_center_z := -half_z + east_north_len * 0.5
	var east_south_center_z := door_max_z + east_south_len * 0.5
	var lintel_height := WALL_HEIGHT_M - DOOR_HEIGHT_M
	var lintel_y := DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5), STONE)
	_box(root, "WestWall", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT.y), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "EastWallNorth", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_north_len), WOOD_MID)
	_box(root, "EastWallSouth", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_south_len), WOOD_MID)
	_box(root, "EastLintel", Vector3(east_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M), WOOD_MID)

	_box(root, "DutyDesk", Vector3(-1.65, 0.52, -1.55), Vector3(1.55, 1.04, 0.72), WOOD_DARK)
	_box(root, "EquipmentStorageWall", Vector3(-3.20, 1.15, 1.35), Vector3(0.18, 2.20, 2.20), WOOD_DARK)
	_box(root, "RestBench", Vector3(0.15, 0.34, 1.75), Vector3(2.20, 0.68, 0.48), WOOD_LIGHT)
	_box(root, "SecuritySign", Vector3(east_x + 0.18, 2.55, -1.65), Vector3(0.12, 0.56, 1.25), SECURITY_ACCENT)

	var roof := Node3D.new()
	roof.name = "RoofVisibilityGroup"
	root.add_child(roof)
	_box(roof, "RoofWest", Vector3(-1.75, 4.02, 0.0), Vector3(4.0, 0.42, 6.7), ROOF, Vector3(0.0, 0.0, -20.0))
	_box(roof, "RoofEast", Vector3(1.75, 4.02, 0.0), Vector3(4.0, 0.42, 6.7), ROOF, Vector3(0.0, 0.0, 20.0))
	_box(roof, "RidgeBeam", Vector3(0.0, 3.78, 0.0), Vector3(0.22, 0.28, 6.2), WOOD_DARK)

	_anchor(root, "EntranceAnchor", Vector3(half_x + 0.55, 0.90, DOOR_CENTER_Z_M))
	_anchor(root, "ExitAnchor", Vector3(half_x - 0.55, 0.90, DOOR_CENTER_Z_M))
	_anchor(root, "GuardDutyAnchor", Vector3(-1.25, 0.90, -0.75))
	_anchor(root, "PatrolStartAnchor", Vector3(2.05, 0.90, -1.55))
	_anchor(root, "EquipmentStorageAnchor", Vector3(-2.35, 0.90, 1.20))
	_anchor(root, "GuardIdleAnchor", Vector3(0.10, 0.90, 1.55))
	_anchor(root, "InteriorCenterAnchor", Vector3.ZERO)

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5))
	_collision_box(collision_root, "WestWallCollision", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT.y))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "EastNorthCollision", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_north_len))
	_collision_box(collision_root, "EastSouthCollision", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, east_south_len))
	_collision_box(collision_root, "EastLintelCollision", Vector3(east_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M))

	return root

static func _build_canopy(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = CANOPY_NAME
	parent.add_child(root)

	var half_x := CANOPY_FOOTPRINT.x * 0.5
	var half_z := CANOPY_FOOTPRINT.y * 0.5
	var post_y := CANOPY_POST_HEIGHT_M * 0.5
	var post_positions := [
		Vector3(-half_x + 0.22, post_y, -half_z + 0.22),
		Vector3(half_x - 0.22, post_y, -half_z + 0.22),
		Vector3(-half_x + 0.22, post_y, half_z - 0.22),
		Vector3(half_x - 0.22, post_y, half_z - 0.22),
	]
	for index in range(post_positions.size()):
		var position: Vector3 = post_positions[index]
		_box(root, "PostVisual%02d" % (index + 1), position, Vector3(0.22, CANOPY_POST_HEIGHT_M, 0.22), WOOD_DARK)
		_collision_box(root, "PostCollision%02d" % (index + 1), position, Vector3(0.22, CANOPY_POST_HEIGHT_M, 0.22))

	_box(root, "CanopyRoof", Vector3(0.0, 2.98, 0.0), Vector3(6.2, 0.24, 4.2), ROOF)
	_box(root, "BriefingTable", Vector3(0.0, 0.48, 0.0), Vector3(2.6, 0.96, 0.82), WOOD_MID)

	_anchor(root, "BriefingAnchor", Vector3(0.0, 0.90, 0.95))
	_anchor(root, "GuardIdleAnchor_01", Vector3(-1.45, 0.90, 0.95))
	_anchor(root, "GuardIdleAnchor_02", Vector3(1.45, 0.90, 0.95))
	_anchor(root, "TableSocket", Vector3.ZERO)
	_anchor(root, "LanternSocket", Vector3(0.0, 2.45, -1.45))
	return root

static func _build_equipment_rack(parent: Node3D, name: String, center: Vector2, variant: String) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_equipment_rack_family", "SET01_PROP_EQUIPMENT_RACK_A")
	root.set_meta("pixel_rpg_variant_tag", variant)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "FrameTop", Vector3(0.0, 1.82, 0.0), Vector3(1.90, 0.14, 0.48), WOOD_DARK)
	_box(root, "FrameL", Vector3(-0.88, 0.95, 0.0), Vector3(0.14, 1.90, 0.48), WOOD_DARK)
	_box(root, "FrameR", Vector3(0.88, 0.95, 0.0), Vector3(0.14, 1.90, 0.48), WOOD_DARK)
	_collision_box(root, "RackCollision", Vector3(0.0, 0.95, 0.0), Vector3(1.90, 1.90, 0.48))

	for index in range(6):
		var x := -0.72 + float(index) * 0.29
		_anchor(root, "DisplaySocket_%02d" % (index + 1), Vector3(x, 1.25, 0.0))
	_anchor(root, "InteractionAnchor", Vector3(0.0, 0.90, -0.75))
	return root

static func _build_duty_board(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = DUTY_BOARD_NAME
	parent.add_child(root)

	_box(root, "Board", Vector3(0.0, 1.45, 0.0), Vector3(1.8, 1.15, 0.12), BOARD_COLOR)
	_box(root, "PostL", Vector3(-0.70, 0.70, 0.0), Vector3(0.12, 1.40, 0.12), WOOD_DARK)
	_box(root, "PostR", Vector3(0.70, 0.70, 0.0), Vector3(0.12, 1.40, 0.12), WOOD_DARK)
	_anchor(root, "DutyBoardAnchor", Vector3(0.0, 1.20, -0.55))
	return root

static func _build_training_target(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01SecurityTrainingTarget"
	parent.add_child(root)

	_box(root, "TargetPost", Vector3(0.0, 0.90, 0.0), Vector3(0.16, 1.80, 0.16), WOOD_DARK)
	_box(root, "TargetFace", Vector3(0.0, 1.55, 0.0), Vector3(1.05, 1.05, 0.18), SECURITY_ACCENT)
	_collision_box(root, "TargetCollision", Vector3(0.0, 1.10, 0.0), Vector3(1.10, 2.20, 0.32))
	return root

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

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
