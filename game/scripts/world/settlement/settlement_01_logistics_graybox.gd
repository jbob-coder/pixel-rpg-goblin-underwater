class_name PixelRPGSettlement01LogisticsGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_logistics_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "CaravanVisitorLogisticsGraybox"
const STORAGE_NAME := "Settlement01ArrivalStorage"
const AWNING_NAME := "Settlement01LogisticsAwning"

const SECTION_ID := "SET01_S01"
const AREA_ID := "SET01_A03_CARAVAN_VISITOR_STAGING"
const STORAGE_ID := "SET01_BLD_ARRIVAL_STORAGE"

const FOOTPRINT := Vector2(7.0, 6.0)
const WALL_HEIGHT_M := 3.2
const WALL_THICKNESS_M := 0.24
const DOOR_WIDTH_M := 1.8
const DOOR_HEIGHT_M := 2.3
const DOOR_CENTER_Z_M := 0.0

const AWNING_CENTER := Vector2(27.0, 17.5)
const AWNING_FOOTPRINT := Vector2(6.0, 5.0)
const AWNING_POST_HEIGHT_M := 2.8

const CART_A_CENTER := Vector2(26.8, 26.8)
const CART_B_CENTER := Vector2(27.0, 22.8)
const CART_SIZE := Vector3(3.2, 1.15, 1.6)

const HITCHING_CENTER := Vector2(21.0, 15.2)
const TROUGH_CENTER := Vector2(27.0, 14.6)
const BENCH_CENTER := Vector2(18.6, 17.4)
const WAYFINDING_CENTER := Vector2(15.6, 16.2)

const WOOD_DARK := Color(0.22, 0.15, 0.10)
const WOOD_MID := Color(0.39, 0.27, 0.16)
const WOOD_LIGHT := Color(0.55, 0.40, 0.23)
const STONE := Color(0.34, 0.36, 0.33)
const ROOF := Color(0.24, 0.18, 0.12)
const CLOTH := Color(0.44, 0.38, 0.24)
const WATER := Color(0.20, 0.38, 0.43)
const SIGN := Color(0.49, 0.38, 0.21)

static func get_schema() -> String:
	return SCHEMA

static func add_logistics(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G10 Logistics requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G10 Logistics requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	if not building_specs.has(STORAGE_ID):
		push_error("Settlement 01 G10 Arrival Storage building spec is missing.")
		return {}

	var storage_spec := building_specs[STORAGE_ID] as Dictionary
	if String(storage_spec.get("section_id", "")) != SECTION_ID or String(storage_spec.get("area_id", "")) != AREA_ID:
		push_error("Settlement 01 G10 Logistics ownership does not match the locked layout contract.")
		return {}

	var footprint: Vector2 = storage_spec.get("footprint_xz", Vector2.ZERO)
	if not footprint.is_equal_approx(FOOTPRINT):
		push_error("Settlement 01 G10 Arrival Storage footprint disagrees with the locked layout contract.")
		return {}

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(AREA_ID):
		push_error("Settlement 01 G10 Logistics area spec is missing.")
		return {}
	var area := area_specs[AREA_ID] as Dictionary
	var bounds_parts := area.get("bounds_parts", []) as Array
	if bounds_parts.size() != 1:
		push_error("Settlement 01 G10 Logistics expects one locked A03 bounds part.")
		return {}
	var bounds := bounds_parts[0] as Dictionary
	if not _bounds_match(bounds, 12.0, 30.0, 14.0, 29.0):
		push_error("Settlement 01 G10 Logistics A03 bounds disagree with the spatial lock.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G10")
	root_node.set_meta("pixel_rpg_final_art_locked", false)
	parent.add_child(root_node)

	var storage := _build_storage(root_node)
	var center: Vector2 = storage_spec.get("center_xz", Vector2.ZERO)
	storage.position = Vector3(center.x, 0.0, center.y)
	_apply_storage_metadata(storage)

	var awning := _build_awning(root_node)
	awning.position = Vector3(AWNING_CENTER.x, 0.0, AWNING_CENTER.y)
	awning.set_meta("pixel_rpg_asset_id", "SET01_A03_LOGISTICS_AWNING")
	awning.set_meta("pixel_rpg_section_id", SECTION_ID)
	awning.set_meta("pixel_rpg_area_id", AREA_ID)
	awning.set_meta("pixel_rpg_graybox_pass", "G10")
	awning.set_meta("pixel_rpg_final_art_locked", false)

	var carts: Array[Node3D] = []
	carts.append(_build_cart(root_node, "CargoCartA", CART_A_CENTER, "OPEN_CARGO"))
	carts.append(_build_cart(root_node, "CargoCartB", CART_B_CENTER, "SUPPLY"))

	var hitching := _build_hitching(root_node)
	hitching.position = Vector3(HITCHING_CENTER.x, 0.0, HITCHING_CENTER.y)

	var trough := _build_trough(root_node)
	trough.position = Vector3(TROUGH_CENTER.x, 0.0, TROUGH_CENTER.y)

	var bench := _build_bench(root_node)
	bench.position = Vector3(BENCH_CENTER.x, 0.0, BENCH_CENTER.y)

	var wayfinding := _build_wayfinding(root_node)
	wayfinding.position = Vector3(WAYFINDING_CENTER.x, 0.0, WAYFINDING_CENTER.y)

	_add_supply_bundle(root_node, "SupplyBundle01", Vector3(24.8, 0.35, 18.9))
	_add_supply_bundle(root_node, "SupplyBundle02", Vector3(25.8, 0.35, 19.0))
	_add_supply_bundle(root_node, "SupplyBundle03", Vector3(29.0, 0.35, 18.7))

	_anchor(root_node, "A03_RoadConnector_A02", Vector3(12.2, 0.90, 23.0))
	_anchor(root_node, "A03_RoadConnector_A04", Vector3(14.4, 0.90, 14.3))
	_anchor(root_node, "A03_CartAnchor_01", Vector3(CART_A_CENTER.x, 0.90, CART_A_CENTER.y))
	_anchor(root_node, "A03_CartAnchor_02", Vector3(CART_B_CENTER.x, 0.90, CART_B_CENTER.y))
	_anchor(root_node, "A03_LoadingAnchor", Vector3(AWNING_CENTER.x, 0.90, AWNING_CENTER.y + 1.0))
	_anchor(root_node, "A03_WaterAnchor", Vector3(TROUGH_CENTER.x, 0.90, TROUGH_CENTER.y))
	_anchor(root_node, "A03_VisitorIdleAnchor_01", Vector3(19.0, 0.90, 17.0))
	_anchor(root_node, "A03_VisitorIdleAnchor_02", Vector3(22.0, 0.90, 17.0))
	_anchor(root_node, "A03_WayfindingAnchor", Vector3(WAYFINDING_CENTER.x, 0.90, WAYFINDING_CENTER.y))

	return {
		"root": root_node,
		"storage": storage,
		"awning": awning,
		"carts": carts,
		"hitching": hitching,
		"trough": trough,
		"bench": bench,
		"wayfinding": wayfinding,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"building_id": STORAGE_ID,
		"target_center_xz": center,
		"target_footprint_xz": footprint,
		"door_width_m": DOOR_WIDTH_M,
		"door_height_m": DOOR_HEIGHT_M,
		"awning_center_xz": AWNING_CENTER,
		"awning_footprint_xz": AWNING_FOOTPRINT,
	}

static func _apply_storage_metadata(node: Node3D) -> void:
	node.set_meta("pixel_rpg_building_id", STORAGE_ID)
	node.set_meta("pixel_rpg_building_family", "ARRIVAL_STORAGE")
	node.set_meta("pixel_rpg_section_id", SECTION_ID)
	node.set_meta("pixel_rpg_area_id", AREA_ID)
	node.set_meta("pixel_rpg_graybox_pass", "G10")
	node.set_meta("pixel_rpg_final_art_locked", false)

static func _build_storage(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = STORAGE_NAME
	parent.add_child(root)

	var half_x := FOOTPRINT.x * 0.5
	var half_z := FOOTPRINT.y * 0.5
	var wall_y := WALL_HEIGHT_M * 0.5
	var west_x := -half_x + WALL_THICKNESS_M * 0.5
	var east_x := half_x - WALL_THICKNESS_M * 0.5
	var north_z := -half_z + WALL_THICKNESS_M * 0.5
	var south_z := half_z - WALL_THICKNESS_M * 0.5

	var door_min_z := DOOR_CENTER_Z_M - DOOR_WIDTH_M * 0.5
	var door_max_z := DOOR_CENTER_Z_M + DOOR_WIDTH_M * 0.5
	var west_north_len := door_min_z - (-half_z)
	var west_south_len := half_z - door_max_z
	var west_north_center_z := -half_z + west_north_len * 0.5
	var west_south_center_z := door_max_z + west_south_len * 0.5
	var lintel_height := WALL_HEIGHT_M - DOOR_HEIGHT_M
	var lintel_y := DOOR_HEIGHT_M + lintel_height * 0.5

	_box(root, "InteriorFloor", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5), STONE)
	_box(root, "EastWall", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT.y), WOOD_MID)
	_box(root, "NorthWall", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "SouthWall", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M), WOOD_MID)
	_box(root, "WestWallNorth", Vector3(west_x, wall_y, west_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, west_north_len), WOOD_MID)
	_box(root, "WestWallSouth", Vector3(west_x, wall_y, west_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, west_south_len), WOOD_MID)
	_box(root, "WestLintel", Vector3(west_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M), WOOD_MID)

	_box(root, "StorageRackNorth", Vector3(1.8, 1.05, -2.30), Vector3(2.0, 2.10, 0.42), WOOD_DARK)
	_box(root, "StorageRackSouth", Vector3(1.8, 1.05, 2.30), Vector3(2.0, 2.10, 0.42), WOOD_DARK)
	_box(root, "CheckInTable", Vector3(-0.7, 0.48, -1.35), Vector3(1.8, 0.96, 0.72), WOOD_LIGHT)

	var roof := Node3D.new()
	roof.name = "RoofVisibilityGroup"
	root.add_child(roof)
	_box(roof, "RoofWest", Vector3(-1.75, 3.85, 0.0), Vector3(4.0, 0.42, 6.7), ROOF, Vector3(0.0, 0.0, -20.0))
	_box(roof, "RoofEast", Vector3(1.75, 3.85, 0.0), Vector3(4.0, 0.42, 6.7), ROOF, Vector3(0.0, 0.0, 20.0))
	_box(roof, "RidgeBeam", Vector3(0.0, 3.62, 0.0), Vector3(0.22, 0.28, 6.2), WOOD_DARK)

	_anchor(root, "EntranceAnchor", Vector3(-half_x - 0.55, 0.90, DOOR_CENTER_Z_M))
	_anchor(root, "ExitAnchor", Vector3(-half_x + 0.55, 0.90, DOOR_CENTER_Z_M))
	_anchor(root, "StorageUseAnchor", Vector3(-1.25, 0.90, -1.10))
	_anchor(root, "ClerkAnchor", Vector3(0.0, 0.90, -1.20))
	_anchor(root, "LoadingAnchor", Vector3(-2.3, 0.90, 1.25))
	_anchor(root, "InteriorCenterAnchor", Vector3.ZERO)
	for index in range(4):
		_anchor(root, "RackSocket_%02d" % (index + 1), Vector3(2.1, 0.90, -1.8 + float(index) * 1.2))

	var collision_root := Node3D.new()
	collision_root.name = "Collision"
	root.add_child(collision_root)
	_collision_box(collision_root, "FloorCollision", Vector3(0.0, 0.06, 0.0), Vector3(6.5, 0.12, 5.5))
	_collision_box(collision_root, "EastWallCollision", Vector3(east_x, wall_y, 0.0), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, FOOTPRINT.y))
	_collision_box(collision_root, "NorthWallCollision", Vector3(0.0, wall_y, north_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "SouthWallCollision", Vector3(0.0, wall_y, south_z), Vector3(FOOTPRINT.x, WALL_HEIGHT_M, WALL_THICKNESS_M))
	_collision_box(collision_root, "WestNorthCollision", Vector3(west_x, wall_y, west_north_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, west_north_len))
	_collision_box(collision_root, "WestSouthCollision", Vector3(west_x, wall_y, west_south_center_z), Vector3(WALL_THICKNESS_M, WALL_HEIGHT_M, west_south_len))
	_collision_box(collision_root, "WestLintelCollision", Vector3(west_x, lintel_y, DOOR_CENTER_Z_M), Vector3(WALL_THICKNESS_M, lintel_height, DOOR_WIDTH_M))
	return root

static func _build_awning(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = AWNING_NAME
	parent.add_child(root)

	var half_x := AWNING_FOOTPRINT.x * 0.5
	var half_z := AWNING_FOOTPRINT.y * 0.5
	var post_y := AWNING_POST_HEIGHT_M * 0.5
	var posts := [
		Vector3(-half_x + 0.22, post_y, -half_z + 0.22),
		Vector3(half_x - 0.22, post_y, -half_z + 0.22),
		Vector3(-half_x + 0.22, post_y, half_z - 0.22),
		Vector3(half_x - 0.22, post_y, half_z - 0.22),
	]
	for index in range(posts.size()):
		var position: Vector3 = posts[index]
		_box(root, "PostVisual%02d" % (index + 1), position, Vector3(0.22, AWNING_POST_HEIGHT_M, 0.22), WOOD_DARK)
		_collision_box(root, "PostCollision%02d" % (index + 1), position, Vector3(0.22, AWNING_POST_HEIGHT_M, 0.22))

	_box(root, "AwningRoof", Vector3(0.0, 2.96, 0.0), Vector3(6.2, 0.20, 5.2), CLOTH)
	_box(root, "LoadingTable", Vector3(0.0, 0.48, 0.55), Vector3(2.6, 0.96, 0.80), WOOD_MID)

	_anchor(root, "LoadingAnchor", Vector3(0.0, 0.90, 1.35))
	_anchor(root, "ClerkAnchor", Vector3(0.0, 0.90, -0.25))
	for index in range(6):
		var x := -2.0 + float(index % 3) * 2.0
		var z := -1.45 + float(index / 3) * 2.9
		_anchor(root, "CargoSocket_%02d" % (index + 1), Vector3(x, 0.45, z))
	_anchor(root, "LanternSocket", Vector3(0.0, 2.35, -1.85))
	return root

static func _build_cart(parent: Node3D, name: String, center: Vector2, variant: String) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_cart_family", "SET01_PROP_CARGO_CART_A")
	root.set_meta("pixel_rpg_variant_tag", variant)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "CargoBed", Vector3(0.0, 0.78, 0.0), Vector3(2.7, 0.55, 1.45), WOOD_MID)
	_box(root, "RailL", Vector3(0.0, 1.15, -0.67), Vector3(2.8, 0.42, 0.12), WOOD_DARK)
	_box(root, "RailR", Vector3(0.0, 1.15, 0.67), Vector3(2.8, 0.42, 0.12), WOOD_DARK)
	_box(root, "TowShaftL", Vector3(-2.05, 0.45, -0.38), Vector3(1.6, 0.10, 0.10), WOOD_DARK)
	_box(root, "TowShaftR", Vector3(-2.05, 0.45, 0.38), Vector3(1.6, 0.10, 0.10), WOOD_DARK)
	_collision_box(root, "CartCollision", Vector3(0.0, 0.65, 0.0), CART_SIZE)

	for index in range(4):
		_anchor(root, "LoadSocket_%02d" % (index + 1), Vector3(-0.75 + float(index % 2) * 1.5, 1.12, -0.35 + float(index / 2) * 0.7))
	_anchor(root, "TowAnchor", Vector3(-2.85, 0.50, 0.0))
	_anchor(root, "ParkAnchor", Vector3.ZERO)
	return root

static func _build_hitching(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01HitchingRail"
	root.set_meta("pixel_rpg_prop_family", "SET01_PROP_HITCHING_RAIL_A")
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)
	_box(root, "PostL", Vector3(-1.85, 0.70, 0.0), Vector3(0.18, 1.40, 0.18), WOOD_DARK)
	_box(root, "PostR", Vector3(1.85, 0.70, 0.0), Vector3(0.18, 1.40, 0.18), WOOD_DARK)
	_box(root, "Rail", Vector3(0.0, 1.05, 0.0), Vector3(4.0, 0.16, 0.16), WOOD_MID)
	_collision_box(root, "RailCollision", Vector3(0.0, 0.75, 0.0), Vector3(4.0, 1.50, 0.26))
	return root

static func _build_trough(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01WaterTrough"
	root.set_meta("pixel_rpg_prop_id", "SET01_PROP_WATER_TROUGH_A")
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)
	_box(root, "TroughBody", Vector3(0.0, 0.45, 0.0), Vector3(2.4, 0.90, 0.85), WOOD_DARK)
	_box(root, "WaterSurface", Vector3(0.0, 0.84, 0.0), Vector3(2.0, 0.04, 0.52), WATER)
	_collision_box(root, "TroughCollision", Vector3(0.0, 0.45, 0.0), Vector3(2.4, 0.90, 0.85))
	_anchor(root, "WaterUseAnchor", Vector3(0.0, 0.90, -1.05))
	return root

static func _build_bench(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01VisitorBench"
	root.set_meta("pixel_rpg_prop_family", "SET01_PROP_BENCH_A")
	parent.add_child(root)
	_box(root, "Seat", Vector3(0.0, 0.48, 0.0), Vector3(1.8, 0.18, 0.48), WOOD_LIGHT)
	_box(root, "LegL", Vector3(-0.65, 0.24, 0.0), Vector3(0.16, 0.48, 0.38), WOOD_DARK)
	_box(root, "LegR", Vector3(0.65, 0.24, 0.0), Vector3(0.16, 0.48, 0.38), WOOD_DARK)
	_collision_box(root, "BenchCollision", Vector3(0.0, 0.42, 0.0), Vector3(1.8, 0.84, 0.52))
	return root

static func _build_wayfinding(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01ArrivalWayfinding"
	parent.add_child(root)
	_box(root, "Post", Vector3(0.0, 1.05, 0.0), Vector3(0.14, 2.10, 0.14), WOOD_DARK)
	_box(root, "SignEast", Vector3(0.42, 1.65, 0.0), Vector3(0.95, 0.32, 0.12), SIGN)
	_box(root, "SignNorth", Vector3(-0.32, 1.32, 0.0), Vector3(0.75, 0.30, 0.12), SIGN)
	return root

static func _add_supply_bundle(parent: Node3D, name: String, position: Vector3) -> void:
	var root := Node3D.new()
	root.name = name
	root.position = position
	root.set_meta("pixel_rpg_prop_family", "SET01_PROP_SUPPLY_BUNDLE_A")
	parent.add_child(root)
	_box(root, "Bundle", Vector3.ZERO, Vector3(0.85, 0.70, 0.65), CLOTH)

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
