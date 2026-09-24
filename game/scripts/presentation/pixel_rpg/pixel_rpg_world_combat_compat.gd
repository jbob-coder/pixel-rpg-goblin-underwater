extends Node3D

const SCHEMA := "pixel_rpg.world_combat_compat.v1"

func get_schema() -> String:
	return SCHEMA

func _presentation_host() -> Node:
	var viewport := get_parent()
	if viewport == null:
		return null
	var display := viewport.get_parent()
	if display == null:
		return null
	return display.get_parent()

func _reset_transient_controls() -> void:
	var host := _presentation_host()
	if host != null and host.has_method("_reset_transient_input"):
		host.call("_reset_transient_input")
