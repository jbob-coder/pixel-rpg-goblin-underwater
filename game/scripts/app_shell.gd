extends Node

const WORLD_SELECTION := preload("res://scripts/startup/pixel_rpg_world_selection_001.gd")
const FIRST_SLICE_SCENE := WORLD_SELECTION.LEGACY_SCENE_PATH

func _ready() -> void:
	call_deferred("_enter_selected_world")

func resolve_startup_target() -> Dictionary:
	return WORLD_SELECTION.resolve_configured_selection()

func _enter_selected_world() -> void:
	var selection := resolve_startup_target()
	if not bool(selection.get("success", false)):
		push_warning(
			"Pixel RPG world selection fell back to legacy compact world: %s"
			% str(selection.get("errors", []))
		)

	var scene_path := String(selection.get("scene_path", FIRST_SLICE_SCENE))
	var error := get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error(
			"Failed to enter Pixel RPG world mode %s at %s: %s"
			% [
				String(selection.get("selected_mode", WORLD_SELECTION.MODE_LEGACY_COMPACT_WORLD)),
				scene_path,
				error_string(error),
			]
		)

# Compatibility wrapper retained for older callers/tests.
func _enter_first_slice() -> void:
	var error := get_tree().change_scene_to_file(FIRST_SLICE_SCENE)
	if error != OK:
		push_error("Failed to enter Pixel RPG prototype slice: %s" % error_string(error))
