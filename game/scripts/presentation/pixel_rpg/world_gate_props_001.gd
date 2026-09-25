class_name PixelRPGWorldGateProps001
extends RefCounted

const SCHEMA := "pixel_rpg.world_gate_props_001.v1"

const GATE_POSITION := Vector3(0.0, 0.0, -10.0)

const GATE_LEFT_COLLISION_POSITION := Vector3(-4.8, 2.2, -10.0)
const GATE_RIGHT_COLLISION_POSITION := Vector3(4.8, 2.2, -10.0)
const GATE_COLLISION_SIZE := Vector3(2.2, 4.4, 2.2)

const CLUTTER_POSITION := Vector3(-3.8, 0.0, -5.5)

const LANTERN_LEFT_POSITION := Vector3(-3.1, 0.0, -7.0)
const LANTERN_LEFT_YAW_DEG := 0.0
const LANTERN_RIGHT_POSITION := Vector3(3.1, 0.0, -7.0)
const LANTERN_RIGHT_YAW_DEG := 180.0

const BANNER_POSITION := Vector3(-6.7, 0.0, -9.2)
const BANNER_YAW_DEG := 0.0

const SIGNPOST_POSITION := Vector3(2.9, 0.0, -13.0)
const SIGNPOST_YAW_DEG := -15.0

const FENCE_LEFT_POSITION := Vector3(-4.0, 0.0, -16.5)
const FENCE_LEFT_YAW_DEG := 10.0
const FENCE_RIGHT_POSITION := Vector3(4.0, 0.0, -19.0)
const FENCE_RIGHT_YAW_DEG := -12.0

const WorldPack001 := preload("res://scripts/presentation/pixel_rpg/world_pack_001.gd")

static func get_schema() -> String:
	return SCHEMA

static func add_gate_props(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Pixel RPG World Gate Props 001 requires a valid parent.")
		return {}

	var gate := WorldPack001.add_settlement_gate(parent, GATE_POSITION)
	var left_collision := _add_collision_box(
		parent,
		"GateLeftCollision",
		GATE_LEFT_COLLISION_POSITION,
		GATE_COLLISION_SIZE
	)
	var right_collision := _add_collision_box(
		parent,
		"GateRightCollision",
		GATE_RIGHT_COLLISION_POSITION,
		GATE_COLLISION_SIZE
	)
	var clutter := WorldPack001.add_service_clutter(parent, CLUTTER_POSITION)
	var lantern_left := WorldPack001.add_lantern_post(parent, LANTERN_LEFT_POSITION, LANTERN_LEFT_YAW_DEG)
	var lantern_right := WorldPack001.add_lantern_post(parent, LANTERN_RIGHT_POSITION, LANTERN_RIGHT_YAW_DEG)
	var banner := WorldPack001.add_banner_post(parent, BANNER_POSITION, BANNER_YAW_DEG)
	var signpost := WorldPack001.add_signpost(parent, SIGNPOST_POSITION, SIGNPOST_YAW_DEG)
	var fence_left := WorldPack001.add_fence(parent, FENCE_LEFT_POSITION, FENCE_LEFT_YAW_DEG)
	var fence_right := WorldPack001.add_fence(parent, FENCE_RIGHT_POSITION, FENCE_RIGHT_YAW_DEG)

	return {
		"gate": gate,
		"left_collision": left_collision,
		"right_collision": right_collision,
		"clutter": clutter,
		"lantern_left": lantern_left,
		"lantern_right": lantern_right,
		"banner": banner,
		"signpost": signpost,
		"fence_left": fence_left,
		"fence_right": fence_right,
	}

static func _add_collision_box(parent: Node3D, node_name: String, position: Vector3, size: Vector3) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = node_name
	body.position = position
	parent.add_child(body)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	return body
