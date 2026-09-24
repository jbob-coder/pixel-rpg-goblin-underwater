extends Control

const PROBE_WORLD := "res://scenes/probe_world.tscn"

func _on_start_probe_pressed() -> void:
	var error := get_tree().change_scene_to_file(PROBE_WORLD)
	if error != OK:
		push_error("Stage 1 probe scene failed to load: %s" % error)
