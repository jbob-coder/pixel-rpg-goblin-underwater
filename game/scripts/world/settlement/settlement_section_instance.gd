class_name PixelRPGSettlementSectionInstance
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_section_instance.v1"
const SectionDefinition := preload("res://scripts/world/settlement/settlement_section_definition.gd")

var _definition: Dictionary = {}
var _loaded := false

func get_schema() -> String:
	return SCHEMA

func configure(definition: Dictionary) -> Dictionary:
	var errors: Array[String] = SectionDefinition.validate(definition)
	if not errors.is_empty():
		_definition = {}
		_loaded = false
		return {
			"success": false,
			"errors": errors,
		}
	_definition = definition.duplicate(true)
	_loaded = false
	return {
		"success": true,
		"errors": [],
		"section_id": get_section_id(),
	}

func get_section_id() -> String:
	return String(_definition.get("section_id", ""))

func get_definition() -> Dictionary:
	return _definition.duplicate(true)

func is_configured() -> bool:
	return not _definition.is_empty()

func is_loaded() -> bool:
	return _loaded

func set_loaded(value: bool) -> void:
	if _definition.is_empty():
		_loaded = false
		return
	_loaded = value
