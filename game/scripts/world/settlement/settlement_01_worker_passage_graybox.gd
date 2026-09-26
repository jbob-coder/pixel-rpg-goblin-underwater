class_name PixelRPGSettlement01WorkerPassageGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_worker_passage_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "EastWorkFrontageWorkerPassageGraybox"
const SECTION_ID := "SET01_S04"
const AREA_ID := "SET01_A08_EAST_WORK_FRONTAGE"

const LANE_CENTER_X := 16.25
const LANE_WIDTH_M := 4.5
const LANE_MIN_Z := -13.0
const LANE_MAX_Z := 13.0
const AREA_MIN_X := 14.0
const AREA_MAX_X := 20.5
const AREA_MIN_Z := -14.0
const AREA_MAX_Z := 14.0
const EDGE_STRIP_CENTER_X := 19.5
const EDGE_STRIP_WIDTH_M := 2.0

const LANE_COLOR := Color(0.34, 0.30, 0.22)
const EDGE_COLOR := Color(0.27, 0.24, 0.18)
const WOOD_DARK := Color(0.24, 0.17, 0.11)
const WOOD_MID := Color(0.43, 0.30, 0.18)
const TOOL_METAL := Color(0.30, 0.33, 0.34)

static func get_schema() -> String:
	return SCHEMA

static func add_worker_passage(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G07 Worker Passage requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G07 Worker Passage requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var areas: Dictionary = LayoutContract.get_area_specs()
	if not areas.has(AREA_ID):
		push_error("Settlement 01 G07 A08 area definition is missing.")
		return {}

	var area: Dictionary = areas[AREA_ID] as Dictionary
	if String(area.get("parent_section_id", "")) != SECTION_ID:
		push_error("Settlement 01 G07 A08 parent section mismatch.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G07")
	root_node.set_meta("pixel_rpg_final_art_locked", false)
	parent.add_child(root_node)

	var lane_length: float = LANE_MAX_Z - LANE_MIN_Z
	_box(
		root_node,
		"EastFrontageLane",
		Vector3(LANE_CENTER_X, 0.045, (LANE_MIN_Z + LANE_MAX_Z) * 0.5),
		Vector3(LANE_WIDTH_M, 0.03, lane_length),
		LANE_COLOR
	)
	_box(
		root_node,
		"WorkEdgeStrip",
		Vector3(EDGE_STRIP_CENTER_X, 0.052, 0.0),
		Vector3(EDGE_STRIP_WIDTH_M, 0.025, lane_length),
		EDGE_COLOR
	)

	_add_shift_board(root_node, Vector3(19.55, 0.0, -8.75))
	_add_tool_rack(root_node, "ToolRackNorth", Vector3(19.55, 0.0, -4.75))
	_add_tool_rack(root_node, "ToolRackSouth", Vector3(19.55, 0.0, 4.75))
	_add_supply_stack(root_node, Vector3(19.55, 0.0, 8.75))

	_anchor(root_node, "ShiftStartAnchor", Vector3(19.05, 0.90, -8.75))
	_anchor(root_node, "ToolPickupAnchor", Vector3(19.05, 0.90, -4.75))
	_anchor(root_node, "WorkerIdleAnchor_01", Vector3(19.00, 0.90, -1.75))
	_anchor(root_node, "WorkerIdleAnchor_02", Vector3(19.00, 0.90, 1.75))
	_anchor(root_node, "ToolReturnAnchor", Vector3(19.05, 0.90, 4.75))
	_anchor(root_node, "ShiftEndAnchor", Vector3(19.05, 0.90, 8.75))
	_anchor(root_node, "ConnectorNorthAnchor", Vector3(LANE_CENTER_X, 0.0, LANE_MIN_Z))
	_anchor(root_node, "ConnectorSouthAnchor", Vector3(LANE_CENTER_X, 0.0, LANE_MAX_Z))

	return {
		"root": root_node,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"lane_center_x": LANE_CENTER_X,
		"lane_width_m": LANE_WIDTH_M,
		"lane_min_z": LANE_MIN_Z,
		"lane_max_z": LANE_MAX_Z,
		"area_bounds": {
			"min_x": AREA_MIN_X,
			"max_x": AREA_MAX_X,
			"min_z": AREA_MIN_Z,
			"max_z": AREA_MAX_Z,
		},
	}

static func _add_shift_board(parent: Node3D, base_position: Vector3) -> void:
	_box(parent, "ShiftBoardPost", base_position + Vector3(0.0, 0.80, 0.0), Vector3(0.18, 1.60, 0.18), WOOD_DARK)
	_box(parent, "ShiftBoard", base_position + Vector3(0.0, 1.45, 0.0), Vector3(0.18, 1.00, 1.35), WOOD_MID)

static func _add_tool_rack(parent: Node3D, name: String, base_position: Vector3) -> void:
	var rack := Node3D.new()
	rack.name = name
	rack.position = base_position
	parent.add_child(rack)
	_box(rack, "Frame", Vector3(0.0, 0.85, 0.0), Vector3(0.38, 1.70, 1.30), WOOD_DARK)
	_box(rack, "ToolBar", Vector3(-0.24, 1.05, 0.0), Vector3(0.12, 0.12, 1.12), TOOL_METAL)
	_box(rack, "ToolHeadNorth", Vector3(-0.25, 0.72, -0.34), Vector3(0.15, 0.55, 0.24), TOOL_METAL)
	_box(rack, "ToolHeadSouth", Vector3(-0.25, 0.72, 0.34), Vector3(0.15, 0.55, 0.24), TOOL_METAL)

static func _add_supply_stack(parent: Node3D, base_position: Vector3) -> void:
	_box(parent, "SupplyCrateBottom", base_position + Vector3(0.0, 0.35, 0.0), Vector3(1.15, 0.70, 1.20), WOOD_MID)
	_box(parent, "SupplyCrateTop", base_position + Vector3(0.0, 0.88, 0.18), Vector3(0.85, 0.55, 0.82), WOOD_DARK)

static func _anchor(parent: Node3D, name: String, position: Vector3) -> Marker3D:
	var anchor := Marker3D.new()
	anchor.name = name
	anchor.position = position
	parent.add_child(anchor)
	return anchor

static func _box(parent: Node3D, name: String, position: Vector3, size: Vector3, color: Color) -> MeshInstance3D:
	var node := MeshInstance3D.new()
	node.name = name
	var mesh := BoxMesh.new()
	mesh.size = size
	node.mesh = mesh
	node.position = position
	node.material_override = _material(color)
	parent.add_child(node)
	return node

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
