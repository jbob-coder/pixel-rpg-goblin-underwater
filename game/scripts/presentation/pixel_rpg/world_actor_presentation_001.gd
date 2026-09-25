class_name PixelRPGWorldActorPresentation001
extends RefCounted

const SCHEMA := "pixel_rpg.world_actor_presentation_001.v1"

const GATE_WARDEN_POSITION := Vector3(-2.6, 0.0, -6.2)
const MUDCREST_POSITION := Vector3(0.0, 0.0, -49.0)

const GateWardenVisualScene: PackedScene = preload("res://assets/characters/gate_warden_visual_01.tscn")
const MudcrestVisualScene: PackedScene = preload("res://assets/monsters/mudcrest_visual.tscn")

static func get_schema() -> String:
	return SCHEMA

static func add_actor_presentation(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Pixel RPG World Actor Presentation 001 requires a valid parent.")
		return {}

	var npc_anchor := Node3D.new()
	npc_anchor.name = "GateWarden"
	npc_anchor.position = GATE_WARDEN_POSITION
	parent.add_child(npc_anchor)

	var warden_visual := GateWardenVisualScene.instantiate() as Node3D
	if warden_visual == null:
		push_error("Pixel RPG World Actor Presentation 001 failed to instantiate Gate Warden visual.")
	else:
		warden_visual.name = "GateWardenVisual"
		npc_anchor.add_child(warden_visual)

	var monster_anchor := Node3D.new()
	monster_anchor.name = "MonsterProxy"
	monster_anchor.position = MUDCREST_POSITION
	parent.add_child(monster_anchor)

	var monster_visual := MudcrestVisualScene.instantiate() as Node3D
	if monster_visual == null:
		push_error("Pixel RPG World Actor Presentation 001 failed to instantiate Mudcrest visual.")
	else:
		monster_visual.name = "MudcrestVisual"
		monster_anchor.add_child(monster_visual)

	return {
		"npc_anchor": npc_anchor,
		"warden_visual": warden_visual,
		"monster_anchor": monster_anchor,
		"monster_visual": monster_visual,
	}
