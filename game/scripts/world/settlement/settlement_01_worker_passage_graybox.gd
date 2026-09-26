class_name PixelRPGSettlement01WorkerPassageGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_worker_passage_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "EastWorkFrontagePassageGraybox"
const SECTION_ID := "SET01_S04"
const AREA_ID := "SET01_A08_EAST_WORK_FRONTAGE"

const LANE_CENTER_X := 16.25
const LANE_WIDTH_M := 4.5
const LANE_MIN_Z := -13.0
const LANE_MAX_Z := 13.0
const LANE_SURFACE_Y := 0.07
const LANE_SURFACE_HEIGHT := 0.06

const AREA_MIN_X := 14.0
const AREA_MAX_X := 20.5
const AREA_MIN_Z := -14.0
const AREA_MAX_Z := 14.0

const PROP_CLEARANCE_FROM_LANE_M := 0.55

const LANE_COLOR := Color(0.36, 0.29, 0.19)
const WOOD_DARK := Color(0.24, 0.17, 0.11)
const WOOD_MID := Color(0.40, 0.28, 0.16)
const WORK_ACCENT := Color(0.43, 0.32, 0.18)
const METAL := Color(0.22, 0.24, 0.24)

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

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(AREA_ID):
		push_error("Settlement 01 G07 missing area spec %s." % AREA_ID)
		return {}

	var area_spec: Dictionary = area_specs[AREA_ID] as Dictionary
	if String(area_spec.get("parent_section_id", "")) != SECTION_ID:
		push_error("Settlement 01 G07 ownership mismatch for %s." % AREA_ID)
		return {}

	var bounds_parts: Array = area_spec.get("bounds_parts", [])
	if bounds_parts.size() != 1:
		push_error("Settlement 01 G07 expects one locked Area 08 bounds part.")
		return {}

	var bounds := bounds_parts[0] as Dictionary
	if (
		not is_equal_approx(float(bounds.get("min_x", 0.0)), AREA_MIN_X)
		or not is_equal_approx(float(bounds.get("max_x", 0.0)), AREA_MAX_X)
		or not is_equal_approx(float(bounds.get("min_z", 0.0)), AREA_MIN_Z)
		or not is_equal_approx(float(bounds.get("max_z", 0.0)), AREA_MAX_Z)
	):
		push_error("Settlement 01 G07 Area 08 bounds drifted from the spatial lock.")
		return {}

	var infrastructure: Dictionary = LayoutContract.get_infrastructure_specs()
	var frontage := infrastructure.get("east_frontage_lane", {}) as Dictionary
	if (
		not is_equal_approx(float(frontage.get("center_x", 0.0)), LANE_CENTER_X)
		or not is_equal_approx(float(frontage.get("width_m", 0.0)), LANE_WIDTH_M)
		or not is_equal_approx(float(frontage.get("min_z", 0.0)), LANE_MIN_Z)
		or not is_equal_approx(float(frontage.get("max_z", 0.0)), LANE_MAX_Z)
	):
		push_error("Settlement 01 G07 East Frontage Lane drifted from the layout contract.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)
	root_node.set_meta("pixel_rpg_section_id", SECTION_ID)
	root_node.set_meta("pixel_rpg_area_id", AREA_ID)
	root_node.set_meta("pixel_rpg_graybox_pass", "G07")
	root_node.set_meta("pixel_rpg_final_art_locked", false)
	root_node.set_meta("pixel_rpg_area_role", "WORKER_PASSAGE")

	var lane := _add_lane(root_node)
	var props := _add_edge_props(root_node)
	var anchors := _add_worker_anchors(root_node)

	return {
		"root": root_node,
		"lane": lane,
		"props": props,
		"anchors": anchors,
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

static func _add_lane(parent: Node3D) -> MeshInstance3D:
	var lane := MeshInstance3D.new()
	lane.name = "EastFrontageLanePresentation"
	lane.position = Vector3(LANE_CENTER_X, LANE_SURFACE_Y, 0.0)
	var mesh := BoxMesh.new()
	mesh.size = Vector3(LANE_WIDTH_M, LANE_SURFACE_HEIGHT, LANE_MAX_Z - LANE_MIN_Z)
	lane.mesh = mesh
	lane.material_override = _material(LANE_COLOR)
	parent.add_child(lane)
	return lane

static func _add_edge_props(parent: Node3D) -> Array[MeshInstance3D]:
	var props: Array[MeshInstance3D] = []
	props.append(_box(parent, "ShiftBenchNorth", Vector3(19.55, 0.42, -8.5), Vector3(1.20, 0.84, 2.20), WOOD_MID))
	props.append(_box(parent, "SharedToolRack", Vector3(19.70, 0.85, 0.0), Vector3(0.90, 1.70, 2.00), WOOD_DARK))
	props.append(_box(parent, "ShiftBenchSouth", Vector3(19.55, 0.42, 8.5), Vector3(1.20, 0.84, 2.20), WOOD_MID))
	props.append(_box(parent, "ToolCrateNorth", Vector3(19.55, 0.38, -5.3), Vector3(1.10, 0.76, 1.10), WORK_ACCENT))
	props.append(_box(parent, "ToolCrateSouth", Vector3(19.55, 0.38, 5.3), Vector3(1.10, 0.76, 1.10), WORK_ACCENT))
	props.append(_box(parent, "WorkDistrictSign", Vector3(19.65, 1.25, 11.4), Vector3(0.18, 2.50, 1.40), METAL))
	return props

static func _add_worker_anchors(parent: Node3D) -> Array[Marker3D]:
	var anchors: Array[Marker3D] = []
	anchors.append(_anchor(parent, "WorkerIdleAnchor_01", Vector3(19.0, 0.90, -8.5)))
	anchors.append(_anchor(parent, "WorkerIdleAnchor_02", Vector3(19.0, 0.90, 8.5)))
	anchors.append(_anchor(parent, "ShiftChangeAnchor", Vector3(19.0, 0.90, 0.0)))
	anchors.append(_anchor(parent, "ToolPickupAnchor", Vector3(19.0, 0.90, -0.9)))
	anchors.append(_anchor(parent, "SmithApproachAnchor", Vector3(18.85, 0.90, 0.0)))
	anchors.append(_anchor(parent, "NorthWorkPocketConnector", Vector3(16.25, 0.90, -13.0)))
	anchors.append(_anchor(parent, "SouthWorkPocketConnector", Vector3(16.25, 0.90, 13.0)))
	anchors.append(_anchor(parent, "PlazaConnector", Vector3(14.0, 0.90, 0.0)))
	return anchors

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

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
