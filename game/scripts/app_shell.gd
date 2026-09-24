extends Node

const FIRST_SLICE_SCENE := "res://scenes/prototypes/pixel_rpg_prototype_001.tscn"

func _ready() -> void:
	call_deferred("_enter_first_slice")

func _enter_first_slice() -> void:
	var error := get_tree().change_scene_to_file(FIRST_SLICE_SCENE)
	if error != OK:
		push_error("Failed to enter Pixel RPG prototype slice: %s" % error_string(error))
