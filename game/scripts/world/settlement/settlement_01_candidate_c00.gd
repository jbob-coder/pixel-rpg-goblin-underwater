extends Node

const SCHEMA := "pixel_rpg.settlement_01_candidate_c00.v1"

const G00 := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const G14 := preload("res://scripts/world/settlement/settlement_01_npc_schedule_contract.gd")
const G15 := preload("res://scripts/world/settlement/settlement_01_minimap_contract.gd")
const G16 := preload("res://scripts/world/settlement/settlement_01_streaming_manager.gd")
const G17 := preload("res://scripts/world/settlement/settlement_01_persistence_contract.gd")

func get_schema() -> String:
	return SCHEMA

func get_candidate_status() -> Dictionary:
	var errors: Array[String] = []

	var g00: Dictionary = G00.validate_contract()
	if not bool(g00.get("success", false)):
		errors.append("G00 layout contract invalid")

	var g14: Dictionary = G14.validate_contract()
	if not bool(g14.get("success", false)):
		errors.append("G14 NPC schedule contract invalid")

	var g15: Dictionary = G15.validate_contract()
	if not bool(g15.get("success", false)):
		errors.append("G15 minimap contract invalid")

	var streaming = G16.new()
	var g16: Dictionary = streaming.configure()
	if not bool(g16.get("success", false)):
		errors.append("G16 streaming manager failed configuration")

	var g17_build: Dictionary = G17.build_snapshot()
	if not bool(g17_build.get("success", false)):
		errors.append("G17 persistence contract failed empty-world snapshot build")

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"schema": SCHEMA,
		"candidate_stage": "C00_SELECTION_SHELL_ONLY",
		"player_owner_present": false,
		"camera_owner_present": false,
		"production_cutover": false,
		"settlement_layout_schema": G00.get_schema(),
		"settlement_section_count": int(g00.get("section_count", 0)),
		"settlement_area_count": int(g00.get("area_count", 0)),
	}
