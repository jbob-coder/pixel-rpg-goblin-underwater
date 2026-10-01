extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_graybox.g03.v1"

const Layout := preload("res://scripts/world/settlement/settlement_01_layout_g00.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_graybox_g02.gd")
const SmithPack := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")

const AREA_ID := "SET01_A09_SMITHY_CRAFT_QUARTER"
const SECTION_ID := "SET01_S04"
const BUILDING_ID := "SET01_BLD_SMITH"

const LOCKED_POSITION := Vector3(24.5, 0.0, 0.0)
const LOCKED_YAW_DEG := -90.0

static func get_schema() -> String:
	return SCHEMA

static func build(parent: Node3D, include_debug_markers := false) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G03 graybox requires a valid parent.")
		return {}

	var base: Dictionary = G02.build(parent, include_debug_markers)
	var graybox_root := base.get("root") as Node3D
	if graybox_root == null:
		push_error("Settlement 01 G03 failed to build G02 base.")
		return {}

	var smith := SmithPack.add_enterable_smith(
		graybox_root,
		LOCKED_POSITION,
		LOCKED_YAW_DEG
	)
	if smith == null:
		push_error("Settlement 01 G03 failed to instantiate enterable Smith.")
		return base

	smith.set_meta("building_id", BUILDING_ID)
	smith.set_meta("section_id", SECTION_ID)
	smith.set_meta("area_id", AREA_ID)
	smith.set_meta("settlement_schema", SCHEMA)
	smith.set_meta("migration_source", "WorldPack004EnterableSmith")

	base["smith"] = smith
	return base
