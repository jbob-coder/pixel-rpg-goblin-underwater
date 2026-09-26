class_name PixelRPGSettlement01GateSecurityGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_gate_security_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "GateBarracksSecurityGraybox"
const SECTION_ID := "SET01_S01"
const AREA_ID := "SET01_A02_GATE_BARRACKS_SECURITY"
const BARRACKS_ID := "SET01_BLD_ARRIVAL_GUARD"

const AREA_MIN_X := -30.0
const AREA_MAX_X := -12.0
const AREA_MIN_Z := 14.0
const AREA_MAX_Z := 29.0

const BARRACKS_FOOTPRINT := Vector2(7.0, 6.0)
const BARRACKS_WALL_HEIGHT_M := 3.4
const WALL_THICKNESS_M := 0.24
const BARRACKS_DOOR_WIDTH_M := 1.8
const BARRACKS_DOOR_HEIGHT_M := 2.3

const CANOPY_CENTER := Vector2(-27.0, 17.5)
const CANOPY_FOOTPRINT := Vector2(6.0, 4.0)
const CANOPY_ROOF_Y := 2.85
const CANOPY_POST_HEIGHT_M := 2.8

const EAST_CONNECTOR_MIN_X := -16.0
const EAST_CONNECTOR_MAX_X := -12.0
const NORTH_CONNECTOR_MIN_X := -24.0
const NORTH_CONNECTOR_MAX_X := -16.0
const NORTH_CONNECTOR_MIN_Z := 14.0
const NORTH_CONNECTOR_MAX_Z := 18.0

const WOOD_DARK := Color(0.24, 0.17, 0.11)
const WOOD_MID := Color(0.40, 0.28, 0.16)
const WOOD_LIGHT := Color(0.54, 0.39, 0.22)
const STONE := Color(0.34, 0.36, 0.33)
const ROOF := Color(0.20, 0.14, 0.10)
const METAL := Color(0.22, 0.24, 0.24)
const SECURITY_ACCENT := Color(0.24, 0.32, 0.42)
const YARD_SURFACE := Color(0.34, 0.27, 0.18)

static func get_schema() -> String:
	return SCHEMA

static func add_gate_security(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G09 Gate Security requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G09 Gate Security requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(AREA_ID):
		push_error("Settlement 01 G09 missing Area 02 layout spec.")
		return {}

	var area_spec := area_specs[AREA_ID] as Dictionary
	if String(area_spec.get("parent_section_id", "")) != SECTION_ID:
		push_error("Settlement 01 G09 Area 02 ownership mismatch.")
		return {}

	var bounds_parts: Array = area_spec.get("bounds_parts", [])
	if bounds_parts.size() != 1 or not _bounds_match(bounds_parts[0] as Dictionary, AREA_MIN_X, AREA_MAX_X, AREA_MIN_Z, AREA_MAX_Z):
		push_error("Settlement 01 G09 Area 02 bounds drifted from the spatial lock.")
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	if not building_specs.has(BARRACKS_ID):
		push_error("Settlement 01 G09 missing Barracks building spec.")
		return {}

	var barracks_spec := building_specs[BARRACKS_ID] as Dictionary
	if String(barracks_spec.get("section_id", "")) != SECTION_ID or String(barracks_spec.get("area_id", "")) != AREA_ID:
		push_error("Settlement 01 G09 Barracks ownership mismatch.")
		return {}

	var barracks_footprint: Vector2 = barracks_spec.get("footprint_xz", Vector2.ZERO)
	if not barracks_footprint.is_equal_approx(BARRACKS_FOOTPRINT):
		push_error("Settlement 01 G09 Barracks footprint drifted from 7x6 m.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G09")
	root_node.set_meta("pixel_rpg_final_art_locked", false)

	var yard_surface := _build_yard_surface(root_node)

	var barracks := _build_barracks(root_node)
	var barracks_center: Vector2 = barracks_spec.get("center_xz", Vector2.ZERO)
	barracks.position = Vector3(barracks_center.x, 0.0, barracks_center.y)
	_apply_building_metadata(barracks)

	var canopy := _build_briefing_canopy(root_node)
	canopy.position = Vector3(CANOPY_CENTER.x, 0.0, CANOPY_CENTER.y)

	var rack_group := _build_equipment_racks(root_node)
	var duty_board := _build_duty_board(root_node)
	var training_target := _build_training_target(root_node)
	var bench := _build_security_bench(root_node)
	var anchors := _build_area_anchors(root_node)

	return {
		"root": root_node,
		"yard_surface": yard_surface,
		"barracks": barracks,
		"canopy": canopy,
		"rack_group": rack_group,
		"duty_board": duty_board,
		"training_target": training_target,
		"bench": bench,
		"anchors": anchors,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"barracks_id": BARRACKS_ID,
		"barracks_footprint_xz": BARRACKS_FOOTPRINT,
		"barracks_door_width_m": BARRACKS_DOOR_WIDTH_M,
		"barracks_door_height_m": BARRACKS_DOOR_HEIGHT_M,
		"canopy_footprint_xz": CANOPY_FOOTPRINT,
		"east_connector_bounds": {
			"min_x": EAST_CONNECTOR_MIN_X,
			"max_x": EAST_CONNECTOR_MAX_X,
			"min_z": AREA_MIN_Z,
			"max_z": AREA_MAX_Z,
		},
		"north_connector_bounds": {
			"min_x": NORTH_CONNECTOR_MIN_X,
			"max_x": NORTH_CONNECTOR_MAX_X,
			"min_z": NORTH_CONNECTOR_MIN_Z,
			"max_z": NORTH_CONNECTOR_MAX_Z,
		},
	}

static func _apply_building_metadata(node: Node3D) -> void:
	node.set_meta("pixel_rpg_building_id", BARRACKS_ID)
	node.set_meta("pixel_rpg_building_family", "GATE_BARRACKS_DUTY")
	node.set_meta("pixel_rpg_section_id", SECTION_ID)
	node.set_meta("pixel_rpg_area_id", AREA_ID)
	node.set_meta("pixel_rpg_graybox_pass", "G09")
	node.set_meta("pixel_rpg_final_art_locked", false)

static func _build_yard_surface(parent: Node3D) -> MeshInstance3D:
	var yard := MeshInstance3D.new()
	yard.name = "SecurityYardPresentation"
	yard.position = Vector3(-21.0, 0.065, 21.5)
	var mesh := BoxMesh.new()
	mesh.size = Vector3(17.0, 0.05, 14.0)
	yard.mesh = mesh
	yard.material_override = _material(YARD_SURFACE)
	parent.add_child(yard)
	return yard

static func _build_barracks(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01GateBarracks"
	parent.add_child(root)

	var half_x := BARRACKS_FOOTPRINT.x * 0.5
	var half_z := BARRACKS_FOOTPRINT.y * 0.5
	var wall_y := BARRACKS_WALL_HEIGHT_M * 0.5
	var west_x := -half_x + WALL_THICKNESS_M * 0.5
	var east_x := half_x - WALL_THICKNESS_M * 0.5
	var north_z := -half_z + WALL_THICKNESS_M * 0.5
	var south_z := half_z - WALL_THICKNESS_M * 0.5

	var door_min_z := -BARRACKS_DOOR_WIDTH_M * 0.5
	var door_max_z := BARRACKS_DOOR_WIDTH_M * 0.5
	var east_north_len := door_min_z - (-half_z)
	var east_south_len := half_z - door_max_z
	var east_north_center_z := -half_z + east_north_len * 0.5
	var east_south_center_z := door_max_z + east_south_len * 0.5
	var lintel_height := BARRACKS_WALL_HEIGHT_M - BARRACKS_DOOR_HEIGHT_M
	var lintel_y := BARRACKS_DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5), STONE)
	_box(root, "WestWall", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, BARRACKS_WALL_HEIGHT_M, BARRACKS_FOOTPRINT.y), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(BARRACKS_FOOTPRINT.x, BARRACKS_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(BARRACKS_FOOTPRINT.x, BARRACKS_WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "EastWallNorth", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, BARRACKS_WALL_HEIGHT_M, east_north_len), WOOD_MID)
	_box(root, "EastWallSouth", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, BARRACKS_WALL_HEIGHT_M, east_south_len), WOOD_MID)
	_box(root, "EastLintel", Vector3(east_x, lintel_y, 0.0), Vector3(WALL_THICKNESS_M, lintel_height, BARRACKS_DOOR_WIDTH_M), WOOD_MID)

	_box(root, "DutyDesk", Vector3(-0.8, 0.55, -1.35), Vector3(1.9, 1.1, 0.7), WOOD_DARK)
	_box(root, "EquipmentStorage", Vector3(-2.6, 1.0, 1.55), Vector3(0.7, 2.0, 1.7), WOOD_DARK)
	_box(root, "GuardRestBench", Vector3(0.6, 0.42, 1.9), Vector3(2.0, 0.84, 0.65), WOOD_LIGHT)

	var roof_group := Node3D.new()
	roof_group.name = "RoofVisibilityGroup"
	root.add_child(roof_group)
	_box(roof_group, "RoofWest", Vector3(-1.75, 3.9, 0.0), Vector3(4.0, 0.38, 6.4), ROOF, Vector3(0.0, 0.0, -18.0))
	_box(roof_group, "RoofEast", Vector3(1.75, 3.9, 0.0), Vector3(4.0, 0.38, 6.4), ROOF, Vector3(0.0, 0.0, 18.0))
	_box(roof_group, "RidgeBeam", Vector3(0.0, 3.72, 0.0), Vector3(0.20, 0.24, 5.9), WOOD_DARK)

	_anchor(root, "EntranceAnchor", Vector3(half_x + 0.50, 0.90, 0.0))
	_anchor(root, "ExitAnchor", Vector3(half_x - 0.50, 0.90, 0.0))
	_anchor(root, "GuardDutyAnchor", Vector3(-0.7, 0.90, -1.0))
	_anchor(root, "PatrolStartAnchor", Vector3(half_x + 1.20, 0.90, -1.4))
	_anchor(root, "EquipmentStorageAnchor", Vector3(-2.1, 0.90, 1.55))
	_anchor(root, "GuardIdleAnchor", Vector3(0.5, 0.90, 1.35))
	_anchor(root, "InteriorCenterAnchor", Vector3.ZERO)

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5))
	_collision_box(collision_root, "WestWallCollision", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, BARRACKS_WALL_HEIGHT_M, BARRACKS_FOOTPRINT.y))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(BARRACKS_FOOTPRINT.x, BARRACKS_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(BARRACKS_FOOTPRINT.x, BARRACKS_WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "EastNorthCollision", Vector3(east_x, wall_y, east_north_center_z), Vector3(WALL_THICKNESS_M, BARRACKS_WALL_HEIGHT_M, east_north_len))
	_collision_box(collision_root, "EastSouthCollision", Vector3(east_x, wall_y, east_south_center_z), Vector3(WALL_THICKNESS_M, BARRACKS_WALL_HEIGHT_M, east_south_len))
	_collision_box(collision_root, "EastLintelCollision", Vector3(east_x, lintel_y, 0.0), Vector3(WALL_THICKNESS_M, lintel_height, BARRACKS_DOOR_WIDTH_M))

	return root

static func _build_briefing_canopy(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01SecurityBriefingCanopy"
	parent.add_child(root)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	root.set_meta("pixel_rpg_graybox_pass", "G09")
	root.set_meta("pixel_rpg_asset_role", "BRIEFING_CANOPY")

	var half_x := CANOPY_FOOTPRINT.x * 0.5
	var half_z := CANOPY_FOOTPRINT.y * 0.5
	var post_x := half_x - 0.30
	var post_z := half_z - 0.30

	_box(root, "CanopyRoof", Vector3(0.0, CANOPY_ROOF_Y, 0.0), Vector3(6.2, 0.30, 4.2), ROOF)
	_box(root, "BriefingTable", Vector3(0.0, 0.65, 0.0), Vector3(2.4, 1.30, 0.85), WOOD_DARK)

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	var post_positions: Array[Vector3] = [
		Vector3(-post_x, CANOPY_POST_HEIGHT_M * 0.5, -post_z),
		Vector3(post_x, CANOPY_POST_HEIGHT_M * 0.5, -post_z),
		Vector3(-post_x, CANOPY_POST_HEIGHT_M * 0.5, post_z),
		Vector3(post_x, CANOPY_POST_HEIGHT_M * 0.5, post_z),
	]
	for i in range(post_positions.size()):
		var post_position := post_positions[i]
		_box(root, "Post%02d" % (i + 1), post_position, Vector3(0.30, CANOPY_POST_HEIGHT_M, 0.30), WOOD_DARK)
		_collision_box(collision_root, "PostCollision%02d" % (i + 1), post_position, Vector3(0.30, CANOPY_POST_HEIGHT_M, 0.30))
	_collision_box(collision_root, "BriefingTableCollision", Vector3(0.0, 0.65, 0.0), Vector3(2.4, 1.30, 0.85))

	_anchor(root, "BriefingAnchor", Vector3(0.0, 0.90, 1.15))
	_anchor(root, "GuardIdleAnchor_01", Vector3(-1.3, 0.90, 1.15))
	_anchor(root, "GuardIdleAnchor_02", Vector3(1.3, 0.90, 1.15))
	_anchor(root, "TableSocket", Vector3(0.0, 0.90, 0.0))
	_anchor(root, "LanternSocket", Vector3(2.45, 2.20, -1.45))
	return root

static func _build_equipment_racks(parent: Node3D) -> Node3D:
	var group := Node3D.new()
	group.name = "SecurityEquipmentRackGroup"
	parent.add_child(group)
	group.set_meta("pixel_rpg_section_id", SECTION_ID)
	group.set_meta("pixel_rpg_area_id", AREA_ID)
	group.set_meta("pixel_rpg_graybox_pass", "G09")

	_add_rack(group, "PolearmRack", Vector3(-28.2, 0.0, 22.8), SECURITY_ACCENT)
	_add_rack(group, "ShieldRack", Vector3(-28.2, 0.0, 25.5), METAL)
	return group

static func _add_rack(parent: Node3D, name: String, world_position: Vector3, accent: Color) -> StaticBody3D:
	var body := _solid_box(parent, name, world_position, Vector3(1.8, 1.9, 0.50), WOOD_DARK)
	var display := MeshInstance3D.new()
	display.name = "DisplayPresentation"
	display.position = Vector3(0.0, 0.25, -0.30)
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.45, 1.25, 0.08)
	display.mesh = mesh
	display.material_override = _material(accent)
	body.add_child(display)
	return body

static func _build_duty_board(parent: Node3D) -> MeshInstance3D:
	var board := _box(parent, "SecurityDutyBoard", Vector3(-25.6, 1.25, 27.6), Vector3(1.8, 1.6, 0.16), SECURITY_ACCENT)
	board.set_meta("pixel_rpg_collision_class", "NONE")
	return board

static func _build_training_target(parent: Node3D) -> StaticBody3D:
	var target := _solid_box(parent, "SecurityTrainingTarget", Vector3(-28.2, 1.0, 27.4), Vector3(0.55, 2.0, 0.55), WOOD_MID)
	var face := MeshInstance3D.new()
	face.name = "TargetFacePresentation"
	face.position = Vector3(0.0, 0.35, -0.35)
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.25, 1.25, 0.12)
	face.mesh = mesh
	face.material_override = _material(WOOD_LIGHT)
	target.add_child(face)
	return target

static func _build_security_bench(parent: Node3D) -> StaticBody3D:
	return _solid_box(parent, "SecurityBench", Vector3(-24.8, 0.42, 27.6), Vector3(2.2, 0.84, 0.65), WOOD_MID)

static func _build_area_anchors(parent: Node3D) -> Array[Marker3D]:
	var anchors: Array[Marker3D] = []
	anchors.append(_anchor(parent, "A02_GuardDutyAnchor", Vector3(-19.4, 0.90, 22.0)))
	anchors.append(_anchor(parent, "A02_PatrolStartAnchor", Vector3(-16.0, 0.90, 23.0)))
	anchors.append(_anchor(parent, "A02_BriefingAnchor", Vector3(CANOPY_CENTER.x, 0.90, CANOPY_CENTER.y + 1.15)))
	anchors.append(_anchor(parent, "A02_EquipmentUseAnchor", Vector3(-27.0, 0.90, 24.2)))
	anchors.append(_anchor(parent, "A02_GuardIdleAnchor_01", Vector3(-22.8, 0.90, 18.9)))
	anchors.append(_anchor(parent, "A02_GuardIdleAnchor_02", Vector3(-24.0, 0.90, 26.5)))
	anchors.append(_anchor(parent, "A02_RoadConnector_A01", Vector3(EAST_CONNECTOR_MIN_X, 0.90, 23.0)))
	anchors.append(_anchor(parent, "A02_RoadConnector_A03", Vector3(-20.0, 0.90, NORTH_CONNECTOR_MIN_Z)))
	return anchors

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
