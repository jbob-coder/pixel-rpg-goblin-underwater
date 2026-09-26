class_name PixelRPGSettlement01NorthGateGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_north_gate_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "NorthWatchGateTrailExitGraybox"
const SECTION_ID := "SET01_S05"
const AREA_ID := "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT"

const WATCH_ID := "SET01_BLD_HUNTER_WATCH"
const CACHE_ID := "SET01_BLD_SUPPLY_CACHE"

const WATCH_FOOTPRINT := Vector2(7.0, 7.0)
const CACHE_FOOTPRINT := Vector2(7.0, 6.0)

const WALL_HEIGHT_M := 3.4
const WALL_THICKNESS_M := 0.24
const DOOR_WIDTH_M := 1.8
const DOOR_HEIGHT_M := 2.4

const GATE_CENTER := Vector2(0.0, -35.0)
const GATE_CLEAR_WIDTH_M := 8.0
const GATE_POST_SIZE := Vector3(2.0, 4.8, 1.6)
const GATE_POST_X := 5.0
const GATE_CONNECTOR_SIZE := Vector3(4.0, 4.0, 0.65)
const GATE_CONNECTOR_X := 8.0

const TRAIL_VISUAL_CENTER := Vector2(0.0, -40.0)
const TRAIL_VISUAL_SIZE := Vector3(4.2, 0.08, 10.0)

const WOOD_DARK := Color(0.20, 0.14, 0.10)
const WOOD_MID := Color(0.36, 0.25, 0.16)
const WOOD_LIGHT := Color(0.52, 0.38, 0.23)
const STONE := Color(0.32, 0.34, 0.32)
const ROOF := Color(0.17, 0.15, 0.13)
const WARNING := Color(0.49, 0.22, 0.17)
const TRAIL := Color(0.31, 0.25, 0.17)
const FOLIAGE := Color(0.18, 0.31, 0.20)

static func get_schema() -> String:
	return SCHEMA

static func add_north_gate(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G12 North Gate requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G12 North Gate requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(AREA_ID):
		push_error("Settlement 01 G12 North Gate area spec is missing.")
		return {}
	var area := area_specs[AREA_ID] as Dictionary
	if String(area.get("parent_section_id", "")) != SECTION_ID:
		push_error("Settlement 01 G12 North Gate parent section disagrees with the layout contract.")
		return {}
	var bounds_parts := area.get("bounds_parts", []) as Array
	if bounds_parts.size() != 1:
		push_error("Settlement 01 G12 North Gate expects one locked A12 bounds part.")
		return {}
	if not _bounds_match(bounds_parts[0] as Dictionary, -30.0, 30.0, -36.0, -23.0):
		push_error("Settlement 01 G12 North Gate bounds disagree with the spatial lock.")
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	if not building_specs.has(WATCH_ID) or not building_specs.has(CACHE_ID):
		push_error("Settlement 01 G12 North Gate support-building specs are missing.")
		return {}

	var watch_spec := building_specs[WATCH_ID] as Dictionary
	var cache_spec := building_specs[CACHE_ID] as Dictionary
	if not _building_spec_matches(watch_spec, WATCH_ID, WATCH_FOOTPRINT):
		push_error("Settlement 01 G12 Hunter Watch spec disagrees with the locked layout.")
		return {}
	if not _building_spec_matches(cache_spec, CACHE_ID, CACHE_FOOTPRINT):
		push_error("Settlement 01 G12 Supply Cache spec disagrees with the locked layout.")
		return {}

	var infrastructure: Dictionary = LayoutContract.get_infrastructure_specs()
	if not infrastructure.has("north_gate"):
		push_error("Settlement 01 G12 North Gate infrastructure spec is missing.")
		return {}
	var gate_spec := infrastructure["north_gate"] as Dictionary
	var gate_center: Vector2 = gate_spec.get("center_xz", Vector2.ZERO)
	var gate_width := float(gate_spec.get("clear_width_m", 0.0))
	if not gate_center.is_equal_approx(GATE_CENTER) or not is_equal_approx(gate_width, GATE_CLEAR_WIDTH_M):
		push_error("Settlement 01 G12 North Gate geometry disagrees with the infrastructure lock.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G12")
	root_node.set_meta("pixel_rpg_final_art_locked", false)
	root_node.set_meta("pixel_rpg_gate_clear_width_m", GATE_CLEAR_WIDTH_M)
	parent.add_child(root_node)

	var watch_center: Vector2 = watch_spec.get("center_xz", Vector2.ZERO)
	var watch := _build_support_building(root_node, "Settlement01HunterWatch", WATCH_ID, "HUNTER_WATCH", WATCH_FOOTPRINT, watch_center)
	_add_watch_anchors(watch)

	var cache_center: Vector2 = cache_spec.get("center_xz", Vector2.ZERO)
	var cache := _build_support_building(root_node, "Settlement01SupplyCache", CACHE_ID, "HUNTER_SUPPLY_CACHE", CACHE_FOOTPRINT, cache_center)
	_add_cache_anchors(cache)

	var gate := _build_gate(root_node)
	gate.position = Vector3(GATE_CENTER.x, 0.0, GATE_CENTER.y)

	var trail_transition := _build_trail_transition(root_node)

	_anchor(root_node, "A12_NorthGateCenterAnchor", Vector3(GATE_CENTER.x, 0.90, GATE_CENTER.y))
	_anchor(root_node, "A12_WardenAnchor", Vector3(-6.7, 0.90, -33.0))
	_anchor(root_node, "A12_WatchAnchor", Vector3(watch_center.x, 0.90, watch_center.y + 2.0))
	_anchor(root_node, "A12_WarningAnchor", Vector3(6.5, 0.90, -33.1))
	_anchor(root_node, "A12_TrailConnectorAnchor", Vector3(0.0, 0.90, -38.5))
	_anchor(root_node, "A12_ReturnAnchor", Vector3(0.0, 0.90, -31.8))
	_anchor(root_node, "A12_Connector_A11", Vector3(0.0, 0.90, -23.3))

	return {
		"root": root_node,
		"watch": watch,
		"cache": cache,
		"gate": gate,
		"trail_transition": trail_transition,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"watch_id": WATCH_ID,
		"cache_id": CACHE_ID,
		"gate_center_xz": GATE_CENTER,
		"gate_clear_width_m": GATE_CLEAR_WIDTH_M,
	}

static func _building_spec_matches(spec: Dictionary, building_id: String, footprint: Vector2) -> bool:
	return (
		String(spec.get("building_id", "")) == building_id
		and String(spec.get("section_id", "")) == SECTION_ID
		and String(spec.get("area_id", "")) == AREA_ID
		and (spec.get("footprint_xz", Vector2.ZERO) as Vector2).is_equal_approx(footprint)
	)

static func _build_support_building(
	parent: Node3D,
	name: String,
	building_id: String,
	family: String,
	footprint: Vector2,
	center: Vector2
) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_building_id", building_id)
	root.set_meta("pixel_rpg_building_family", family)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	root.set_meta("pixel_rpg_graybox_pass", "G12")
	root.set_meta("pixel_rpg_final_art_locked", false)
	root.set_meta("pixel_rpg_footprint_xz", footprint)
	parent.add_child(root)

	var half_x := footprint.x * 0.5
	var half_z := footprint.y * 0.5
	var wall_y := WALL_HEIGHT_M * 0.5
	var west_x := -half_x + WALL_THICKNESS_M * 0.5
	var east_x := half_x - WALL_THICKNESS_M * 0.5
	var north_z := -half_z + WALL_THICKNESS_M * 0.5
	var south_z := half_z - WALL_THICKNESS_M * 0.5

	var door_min_x := -DOOR_WIDTH_M * 0.5
	var door_max_x := DOOR_WIDTH_M * 0.5
	var south_left_len := door_min_x - (-half_x)
	var south_right_len := half_x - door_max_x
	var south_left_center_x := -half_x + south_left_len * 0.5
	var south_right_center_x := door_max_x + south_right_len * 0.5
	var lintel_height := WALL_HEIGHT_M - DOOR_HEIGHT_M
	var lintel_y := DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(footprint.x - 0.5, 0.12, footprint.y - 0.5), STONE)
	_box(root, "WestWall", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, footprint.y), WOOD_MID)
	_box(root, "EastWall", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, footprint.y), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(footprint.x, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWallLeft", Vector3(south_left_center_x, wall_y, south_z), Vector3(south_left_len, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWallRight", Vector3(south_right_center_x, wall_y, south_z), Vector3(south_right_len, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthLintel", Vector3(0.0, lintel_y, south_z), Vector3(DOOR_WIDTH_M, lintel_height, WALL_THICKNESS_M), WOOD_MID)

	_box(root, "InteriorBench", Vector3(-1.55, 0.34, -1.4), Vector3(2.0, 0.68, 0.48), WOOD_LIGHT)
	_box(root, "StorageRack", Vector3(1.85, 1.05, -1.6), Vector3(1.7, 2.10, 0.42), WOOD_DARK)

	var roof := Node3D.new()
	roof.name = "RoofVisibilityGroup"
	root.add_child(roof)
	_box(roof, "RoofWest", Vector3(-1.75, 4.02, 0.0), Vector3(4.0, 0.42, footprint.y + 0.7), ROOF, Vector3(0.0, 0.0, -20.0))
	_box(roof, "RoofEast", Vector3(1.75, 4.02, 0.0), Vector3(4.0, 0.42, footprint.y + 0.7), ROOF, Vector3(0.0, 0.0, 20.0))
	_box(roof, "RidgeBeam", Vector3(0.0, 3.78, 0.0), Vector3(0.22, 0.28, footprint.y + 0.2), WOOD_DARK)

	_anchor(root, "EntranceAnchor", Vector3(0.0, 0.90, half_z + 0.55))
	_anchor(root, "ExitAnchor", Vector3(0.0, 0.90, half_z - 0.55))
	_anchor(root, "InteriorCenterAnchor", Vector3.ZERO)

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(footprint.x - 0.5, 0.12, footprint.y - 0.5))
	_collision_box(collision_root, "WestWallCollision", Vector3(west_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, footprint.y))
	_collision_box(collision_root, "EastWallCollision", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, footprint.y))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(footprint.x, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthLeftCollision", Vector3(south_left_center_x, wall_y, south_z), Vector3(south_left_len, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthRightCollision", Vector3(south_right_center_x, wall_y, south_z), Vector3(south_right_len, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthLintelCollision", Vector3(0.0, lintel_y, south_z), Vector3(DOOR_WIDTH_M, lintel_height, WALL_THICKNESS_M))
	return root

static func _add_watch_anchors(watch: Node3D) -> void:
	_anchor(watch, "WardenWorkAnchor", Vector3(-1.2, 0.90, -0.5))
	_anchor(watch, "LookoutAnchor", Vector3(0.0, 3.25, -1.8))
	_anchor(watch, "BountyBoardAnchor", Vector3(2.4, 0.90, 1.0))
	_anchor(watch, "PrepAnchor", Vector3(-2.2, 0.90, 1.0))
	_anchor(watch, "ReturnContextAnchor", Vector3(0.0, 0.90, 2.2))
	_box(watch, "LookoutCap", Vector3(0.0, 4.65, -1.4), Vector3(3.0, 1.20, 2.4), WOOD_DARK)

static func _add_cache_anchors(cache: Node3D) -> void:
	_anchor(cache, "SupplyUseAnchor", Vector3(-1.0, 0.90, -0.4))
	_anchor(cache, "QuartermasterAnchor", Vector3(1.0, 0.90, -0.4))
	_anchor(cache, "EmergencyCacheAnchor", Vector3(0.0, 0.90, 1.6))
	for index in range(4):
		_anchor(cache, "RackSocket_%02d" % (index + 1), Vector3(2.0, 0.90, -1.8 + float(index) * 1.2))

static func _build_gate(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01NorthGate"
	root.set_meta("pixel_rpg_gate_id", "SET01_NORTH_GATE")
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	root.set_meta("pixel_rpg_clear_width_m", GATE_CLEAR_WIDTH_M)
	root.set_meta("pixel_rpg_gate_state", "OPEN_GRAYBOX")
	parent.add_child(root)

	_box(root, "GatePostL", Vector3(-GATE_POST_X, GATE_POST_SIZE.y * 0.5, 0.0), GATE_POST_SIZE, WOOD_DARK)
	_box(root, "GatePostR", Vector3(GATE_POST_X, GATE_POST_SIZE.y * 0.5, 0.0), GATE_POST_SIZE, WOOD_DARK)
	_collision_box(root, "GatePostLCollision", Vector3(-GATE_POST_X, GATE_POST_SIZE.y * 0.5, 0.0), GATE_POST_SIZE)
	_collision_box(root, "GatePostRCollision", Vector3(GATE_POST_X, GATE_POST_SIZE.y * 0.5, 0.0), GATE_POST_SIZE)

	_box(root, "WallConnectorL", Vector3(-GATE_CONNECTOR_X, GATE_CONNECTOR_SIZE.y * 0.5, 0.0), GATE_CONNECTOR_SIZE, WOOD_MID)
	_box(root, "WallConnectorR", Vector3(GATE_CONNECTOR_X, GATE_CONNECTOR_SIZE.y * 0.5, 0.0), GATE_CONNECTOR_SIZE, WOOD_MID)
	_collision_box(root, "WallConnectorLCollision", Vector3(-GATE_CONNECTOR_X, GATE_CONNECTOR_SIZE.y * 0.5, 0.0), GATE_CONNECTOR_SIZE)
	_collision_box(root, "WallConnectorRCollision", Vector3(GATE_CONNECTOR_X, GATE_CONNECTOR_SIZE.y * 0.5, 0.0), GATE_CONNECTOR_SIZE)

	# Open-state leaves are presentation-only and parked outside the 8 m passage.
	_box(root, "GateLeafL", Vector3(-6.0, 2.0, -0.65), Vector3(0.16, 3.8, 3.2), WOOD_MID)
	_box(root, "GateLeafR", Vector3(6.0, 2.0, -0.65), Vector3(0.16, 3.8, 3.2), WOOD_MID)
	_box(root, "WarningBannerL", Vector3(-5.0, 3.65, -0.90), Vector3(0.75, 1.20, 0.08), WARNING)
	_box(root, "WarningBannerR", Vector3(5.0, 3.65, -0.90), Vector3(0.75, 1.20, 0.08), WARNING)

	_anchor(root, "GateCenterAnchor", Vector3(0.0, 0.90, 0.0))
	_anchor(root, "GateInnerAnchor", Vector3(0.0, 0.90, 2.0))
	_anchor(root, "GateOuterAnchor", Vector3(0.0, 0.90, -2.0))
	return root

static func _build_trail_transition(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01NorthTrailTransition"
	root.position = Vector3(TRAIL_VISUAL_CENTER.x, 0.0, TRAIL_VISUAL_CENTER.y)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	root.set_meta("pixel_rpg_collision_owner", "GROUND")
	root.set_meta("pixel_rpg_presentation_only", true)
	parent.add_child(root)

	_box(root, "TrailSurfaceVisual", Vector3(0.0, 0.04, 0.0), TRAIL_VISUAL_SIZE, TRAIL)
	_box(root, "VegetationCueL", Vector3(-4.8, 0.65, -1.2), Vector3(2.0, 1.3, 2.0), FOLIAGE)
	_box(root, "VegetationCueR", Vector3(4.8, 0.65, -2.6), Vector3(2.0, 1.3, 2.0), FOLIAGE)
	_box(root, "RockCueL", Vector3(-6.0, 0.45, -3.6), Vector3(1.4, 0.90, 1.2), STONE)
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
