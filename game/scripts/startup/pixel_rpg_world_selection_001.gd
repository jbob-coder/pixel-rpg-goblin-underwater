class_name PixelRPGWorldSelection001
extends RefCounted

const SCHEMA := "pixel_rpg.world_selection_001.v1"

const MODE_LEGACY_COMPACT_WORLD := "LEGACY_COMPACT_WORLD"
const MODE_SETTLEMENT_01_CANDIDATE := "SETTLEMENT_01_CANDIDATE"

const DEFAULT_MODE := MODE_LEGACY_COMPACT_WORLD
const PROJECT_SETTING_KEY := "pixel_rpg/runtime/world_mode"

const LEGACY_SCENE_PATH := "res://scenes/prototypes/pixel_rpg_prototype_001.tscn"
const SETTLEMENT_01_CANDIDATE_SCENE_PATH := "res://scenes/prototypes/settlement_01_candidate_c00.tscn"

static func get_schema() -> String:
	return SCHEMA

static func get_default_mode() -> String:
	return DEFAULT_MODE

static func get_supported_modes() -> Array[String]:
	return [
		MODE_LEGACY_COMPACT_WORLD,
		MODE_SETTLEMENT_01_CANDIDATE,
	]

static func get_configured_mode() -> String:
	return String(ProjectSettings.get_setting(PROJECT_SETTING_KEY, DEFAULT_MODE))

static func resolve_configured_selection() -> Dictionary:
	return resolve_mode(get_configured_mode())

static func resolve_mode(requested_mode: String) -> Dictionary:
	if requested_mode == MODE_LEGACY_COMPACT_WORLD:
		return _selection(true, requested_mode, MODE_LEGACY_COMPACT_WORLD, LEGACY_SCENE_PATH, false, [])
	if requested_mode == MODE_SETTLEMENT_01_CANDIDATE:
		return _selection(true, requested_mode, MODE_SETTLEMENT_01_CANDIDATE, SETTLEMENT_01_CANDIDATE_SCENE_PATH, false, [])

	return _selection(
		false,
		requested_mode,
		MODE_LEGACY_COMPACT_WORLD,
		LEGACY_SCENE_PATH,
		true,
		["unsupported world mode: %s" % requested_mode]
	)

static func _selection(
	success: bool,
	requested_mode: String,
	selected_mode: String,
	scene_path: String,
	fallback_used: bool,
	errors: Array[String]
) -> Dictionary:
	return {
		"success": success,
		"schema": SCHEMA,
		"requested_mode": requested_mode,
		"selected_mode": selected_mode,
		"scene_path": scene_path,
		"fallback_used": fallback_used,
		"errors": errors,
	}
