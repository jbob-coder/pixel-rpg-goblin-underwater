class_name PixelRPGSettlement01HunterStagingGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_hunter_staging_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "NorthHunterStagingGraybox"
const SECTION_ID := "SET01_S05"
const AREA_ID := "SET01_A11_NORTH_HUNTER_STAGING"

const MAIN_SPINE_MIN_X := -4.0
const MAIN_SPINE_MAX_X := 4.0

const BOUNTY_BOARD_CENTER := Vector2(-18.0, -18.2)
const PREP_RACK_W_CENTER := Vector2(-11.0, -20.0)
const PREP_RACK_E_CENTER := Vector2(11.0, -20.0)
const SUPPLY_TABLE_CENTER := Vector2(14.0, -17.5)
const SUPPLY_CACHE_CENTER := Vector2(18.0, -20.5)
const BENCH_W_CENTER := Vector2(-20.0, -16.5)
const BENCH_E_CENTER := Vector2(20.0, -16.5)
const WARNING_W_CENTER := Vector2(-6.0, -21.2)
const WARNING_E_CENTER := Vector2(6.0, -21.2)

const WOOD_DARK := Color(0.22, 0.15, 0.10)
const WOOD_MID := Color(0.39, 0.27, 0.16)
const WOOD_LIGHT := Color(0.55, 0.40, 0.23)
const BOARD := Color(0.49, 0.37, 0.20)
const METAL := Color(0.25, 0.28, 0.30)
const WARNING := Color(0.50, 0.24, 0.18)
const SUPPLY := Color(0.43, 0.34, 0.21)

static func get_schema() -> String:
	return SCHEMA

static func add_hunter_staging(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G11 Hunter Staging requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G11 Hunter Staging requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(AREA_ID):
		push_error("Settlement 01 G11 Hunter Staging area spec is missing.")
		return {}

	var area := area_specs[AREA_ID] as Dictionary
	if String(area.get("parent_section_id", "")) != SECTION_ID:
		push_error("Settlement 01 G11 Hunter Staging section ownership disagrees with the layout contract.")
		return {}

	var bounds_parts := area.get("bounds_parts", []) as Array
	if bounds_parts.size() != 1:
		push_error("Settlement 01 G11 Hunter Staging expects one locked A11 bounds part.")
		return {}
	var bounds := bounds_parts[0] as Dictionary
	if not _bounds_match(bounds, -30.0, 30.0, -23.0, -14.0):
		push_error("Settlement 01 G11 Hunter Staging bounds disagree with the spatial lock.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G11")
	root_node.set_meta("pixel_rpg_final_art_locked", false)
	root_node.set_meta("pixel_rpg_main_spine_min_x", MAIN_SPINE_MIN_X)
	root_node.set_meta("pixel_rpg_main_spine_max_x", MAIN_SPINE_MAX_X)
	parent.add_child(root_node)

	var bounty_board := _build_bounty_board(root_node)
	bounty_board.position = Vector3(BOUNTY_BOARD_CENTER.x, 0.0, BOUNTY_BOARD_CENTER.y)

	var prep_racks: Array[Node3D] = []
	prep_racks.append(_build_prep_rack(root_node, "HunterPrepRackW", PREP_RACK_W_CENTER, "WEST"))
	prep_racks.append(_build_prep_rack(root_node, "HunterPrepRackE", PREP_RACK_E_CENTER, "EAST"))

	var supply_table := _build_supply_table(root_node)
	supply_table.position = Vector3(SUPPLY_TABLE_CENTER.x, 0.0, SUPPLY_TABLE_CENTER.y)

	var supply_cache := _build_supply_cache(root_node)
	supply_cache.position = Vector3(SUPPLY_CACHE_CENTER.x, 0.0, SUPPLY_CACHE_CENTER.y)

	var benches: Array[Node3D] = []
	benches.append(_build_bench(root_node, "HunterBenchW", BENCH_W_CENTER))
	benches.append(_build_bench(root_node, "HunterBenchE", BENCH_E_CENTER))

	var warning_w := _build_warning_marker(root_node, "WarningMarkerW", WARNING_W_CENTER)
	var warning_e := _build_warning_marker(root_node, "WarningMarkerE", WARNING_E_CENTER)

	_anchor(root_node, "A11_BountyBoardAnchor", Vector3(BOUNTY_BOARD_CENTER.x, 0.90, BOUNTY_BOARD_CENTER.y))
	_anchor(root_node, "A11_PrepAnchor_01", Vector3(PREP_RACK_W_CENTER.x + 1.35, 0.90, PREP_RACK_W_CENTER.y))
	_anchor(root_node, "A11_PrepAnchor_02", Vector3(PREP_RACK_E_CENTER.x - 1.35, 0.90, PREP_RACK_E_CENTER.y))
	_anchor(root_node, "A11_SupplyAnchor", Vector3(SUPPLY_TABLE_CENTER.x, 0.90, SUPPLY_TABLE_CENTER.y + 1.0))
	_anchor(root_node, "A11_HunterIdle_01", Vector3(-16.0, 0.90, -16.2))
	_anchor(root_node, "A11_HunterIdle_02", Vector3(-9.0, 0.90, -16.5))
	_anchor(root_node, "A11_HunterIdle_03", Vector3(9.0, 0.90, -16.5))
	_anchor(root_node, "A11_HunterIdle_04", Vector3(16.0, 0.90, -16.2))
	_anchor(root_node, "A11_Connector_A10", Vector3(14.0, 0.90, -14.3))
	_anchor(root_node, "A11_Connector_A12", Vector3(0.0, 0.90, -22.7))

	return {
		"root": root_node,
		"bounty_board": bounty_board,
		"prep_racks": prep_racks,
		"supply_table": supply_table,
		"supply_cache": supply_cache,
		"benches": benches,
		"warning_markers": [warning_w, warning_e],
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"main_spine_min_x": MAIN_SPINE_MIN_X,
		"main_spine_max_x": MAIN_SPINE_MAX_X,
	}

static func _build_bounty_board(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01BountyRouteBoard"
	root.set_meta("pixel_rpg_prop_id", "SET01_PROP_BOUNTY_ROUTE_BOARD_A")
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "Board", Vector3(0.0, 1.55, 0.0), Vector3(2.2, 1.35, 0.12), BOARD)
	_box(root, "PostL", Vector3(-0.84, 0.78, 0.0), Vector3(0.14, 1.56, 0.14), WOOD_DARK)
	_box(root, "PostR", Vector3(0.84, 0.78, 0.0), Vector3(0.14, 1.56, 0.14), WOOD_DARK)
	_collision_box(root, "PostLCollision", Vector3(-0.84, 0.78, 0.0), Vector3(0.14, 1.56, 0.14))
	_collision_box(root, "PostRCollision", Vector3(0.84, 0.78, 0.0), Vector3(0.14, 1.56, 0.14))
	_anchor(root, "BoardUseAnchor", Vector3(0.0, 0.95, -0.75))
	return root

static func _build_prep_rack(parent: Node3D, name: String, center: Vector2, variant: String) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_equipment_rack_family", "SET01_PROP_EQUIPMENT_RACK_A")
	root.set_meta("pixel_rpg_variant_tag", "HUNTER_PREP_%s" % variant)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "FrameTop", Vector3(0.0, 1.82, 0.0), Vector3(2.0, 0.14, 0.50), WOOD_DARK)
	_box(root, "FrameL", Vector3(-0.93, 0.95, 0.0), Vector3(0.14, 1.90, 0.50), WOOD_DARK)
	_box(root, "FrameR", Vector3(0.93, 0.95, 0.0), Vector3(0.14, 1.90, 0.50), WOOD_DARK)
	_collision_box(root, "RackCollision", Vector3(0.0, 0.95, 0.0), Vector3(2.0, 1.90, 0.50))

	for index in range(6):
		var x := -0.78 + float(index) * 0.31
		_anchor(root, "DisplaySocket_%02d" % (index + 1), Vector3(x, 1.25, 0.0))
	_anchor(root, "InteractionAnchor", Vector3(0.0, 0.90, -0.80))
	return root

static func _build_supply_table(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01HunterSupplyTable"
	root.set_meta("pixel_rpg_prop_family", "SET01_PROP_SERVICE_TABLE_A")
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "Top", Vector3(0.0, 0.90, 0.0), Vector3(2.4, 0.18, 0.90), WOOD_MID)
	_box(root, "LegL", Vector3(-0.85, 0.44, 0.0), Vector3(0.16, 0.88, 0.65), WOOD_DARK)
	_box(root, "LegR", Vector3(0.85, 0.44, 0.0), Vector3(0.16, 0.88, 0.65), WOOD_DARK)
	_collision_box(root, "TableCollision", Vector3(0.0, 0.52, 0.0), Vector3(2.4, 1.04, 0.90))
	_anchor(root, "SupplyUseAnchor", Vector3(0.0, 0.90, -1.05))
	for index in range(4):
		_anchor(root, "SupplySocket_%02d" % (index + 1), Vector3(-0.75 + float(index) * 0.50, 1.08, 0.0))
	return root

static func _build_supply_cache(parent: Node3D) -> Node3D:
	var root := Node3D.new()
	root.name = "Settlement01HunterSupplyCache"
	root.set_meta("pixel_rpg_prop_family", "SET01_PROP_CRATE_A")
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "CacheBody", Vector3(0.0, 0.60, 0.0), Vector3(1.6, 1.20, 1.2), SUPPLY)
	_collision_box(root, "CacheCollision", Vector3(0.0, 0.60, 0.0), Vector3(1.6, 1.20, 1.2))
	_anchor(root, "CacheUseAnchor", Vector3(0.0, 0.90, -1.10))
	return root

static func _build_bench(parent: Node3D, name: String, center: Vector2) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_prop_family", "SET01_PROP_BENCH_A")
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "Seat", Vector3(0.0, 0.48, 0.0), Vector3(1.8, 0.18, 0.48), WOOD_LIGHT)
	_box(root, "LegL", Vector3(-0.65, 0.24, 0.0), Vector3(0.16, 0.48, 0.38), WOOD_DARK)
	_box(root, "LegR", Vector3(0.65, 0.24, 0.0), Vector3(0.16, 0.48, 0.38), WOOD_DARK)
	_collision_box(root, "BenchCollision", Vector3(0.0, 0.42, 0.0), Vector3(1.8, 0.84, 0.52))
	return root

static func _build_warning_marker(parent: Node3D, name: String, center: Vector2) -> Node3D:
	var root := Node3D.new()
	root.name = name
	root.position = Vector3(center.x, 0.0, center.y)
	root.set_meta("pixel_rpg_section_id", SECTION_ID)
	root.set_meta("pixel_rpg_area_id", AREA_ID)
	parent.add_child(root)

	_box(root, "Post", Vector3(0.0, 1.45, 0.0), Vector3(0.12, 2.90, 0.12), WOOD_DARK)
	_box(root, "Banner", Vector3(0.28, 2.15, 0.0), Vector3(0.55, 1.05, 0.08), WARNING)
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

static func _box(parent: Node3D, name: String, position: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	node.position = position
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
