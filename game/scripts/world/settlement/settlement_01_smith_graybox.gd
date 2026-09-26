class_name PixelRPGSettlement01SmithGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_smith_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const SmithPack := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")

const ROOT_NAME := "SmithyCraftQuarterGraybox"
const BUILDING_ID := "SET01_BLD_SMITH"
const SECTION_ID := "SET01_S04"
const AREA_ID := "SET01_A09_SMITHY_CRAFT_QUARTER"
const TARGET_YAW_DEG := -90.0

static func get_schema() -> String:
	return SCHEMA

static func get_target_yaw_deg() -> float:
	return TARGET_YAW_DEG

static func add_smith(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G03 Smith requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G03 Smith requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var building_specs: Dictionary = LayoutContract.get_building_specs()
	if not building_specs.has(BUILDING_ID):
		push_error("Settlement 01 G03 Smith building spec is missing.")
		return {}

	var building := building_specs[BUILDING_ID] as Dictionary
	if String(building.get("section_id", "")) != SECTION_ID or String(building.get("area_id", "")) != AREA_ID:
		push_error("Settlement 01 G03 Smith ownership does not match the locked layout contract.")
		return {}

	var center: Vector2 = building.get("center_xz", Vector2.ZERO)
	var footprint: Vector2 = building.get("footprint_xz", Vector2.ZERO)
	if not is_equal_approx(footprint.x, SmithPack.FOOTPRINT_WIDTH_M) or not is_equal_approx(footprint.y, SmithPack.FOOTPRINT_DEPTH_M):
		push_error("Settlement 01 G03 Smith footprint disagrees with the enterable Smith pack.")
		return {}

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)

	var smith := SmithPack.add_enterable_smith(
		root_node,
		Vector3(center.x, 0.0, center.y),
		TARGET_YAW_DEG
	)
	if smith == null:
		push_error("Settlement 01 G03 failed to instantiate the enterable Smith.")
		root_node.queue_free()
		return {}

	smith.set_meta("pixel_rpg_building_id", BUILDING_ID)
	smith.set_meta("pixel_rpg_section_id", SECTION_ID)
	smith.set_meta("pixel_rpg_area_id", AREA_ID)
	smith.set_meta("pixel_rpg_graybox_pass", "G03")

	return {
		"root": root_node,
		"smith": smith,
		"building_id": BUILDING_ID,
		"section_id": SECTION_ID,
		"area_id": AREA_ID,
		"target_center_xz": center,
		"target_footprint_xz": footprint,
		"target_yaw_deg": TARGET_YAW_DEG,
	}
