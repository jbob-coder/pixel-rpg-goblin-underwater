class_name PixelRPGWorldTrailEnvironment001
extends RefCounted

const SCHEMA := "pixel_rpg.world_trail_environment_001.v1"

const TREE_POSITIONS := [
	Vector3(-7.5, 0.0, -18.0),
	Vector3(7.0, 0.0, -20.0),
	Vector3(-7.5, 0.0, -25.0),
	Vector3(7.0, 0.0, -27.0),
	Vector3(-7.5, 0.0, -33.0),
	Vector3(7.0, 0.0, -35.0),
	Vector3(-7.5, 0.0, -48.0),
	Vector3(7.0, 0.0, -50.0),
	Vector3(-11.0, 0.0, -39.0),
	Vector3(11.5, 0.0, -43.0),
]

const TRAIL_ROCK_POSITION := Vector3(-3.8, 0.75, -29.0)
const TRAIL_ROCK_COLLISION_SIZE := Vector3(2.4, 1.5, 2.0)

const VEGETATION_LEFT_POSITION := Vector3(-8.5, 0.0, -22.0)
const VEGETATION_LEFT_YAW_DEG := 0.0
const VEGETATION_RIGHT_POSITION := Vector3(8.0, 0.0, -31.0)
const VEGETATION_RIGHT_YAW_DEG := 120.0

const ROCK_CLUSTER_POSITION := Vector3(4.8, 0.0, -34.0)
const ROCK_CLUSTER_YAW_DEG := 0.0

const TrailPineScene: PackedScene = preload("res://assets/environment/starting_area/trail_pine_01.tscn")
const TrailRockVisualScene: PackedScene = preload("res://assets/environment/starting_area/trail_rock_visual_01.tscn")
const WorldPack001 := preload("res://scripts/presentation/pixel_rpg/world_pack_001.gd")

static func get_schema() -> String:
	return SCHEMA

static func add_trail_environment(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Pixel RPG World Trail Environment 001 requires a valid parent.")
		return {}

	var trees: Array[Node3D] = []
	for position in TREE_POSITIONS:
		var tree := _add_tree(parent, position)
		if tree != null:
			trees.append(tree)

	var trail_rock := _add_trail_rock(parent)
	var vegetation_left := WorldPack001.add_vegetation_cluster(
		parent,
		VEGETATION_LEFT_POSITION,
		VEGETATION_LEFT_YAW_DEG
	)
	var vegetation_right := WorldPack001.add_vegetation_cluster(
		parent,
		VEGETATION_RIGHT_POSITION,
		VEGETATION_RIGHT_YAW_DEG
	)
	var rock_cluster := WorldPack001.add_rock_cluster(
		parent,
		ROCK_CLUSTER_POSITION,
		ROCK_CLUSTER_YAW_DEG
	)

	return {
		"trees": trees,
		"trail_rock": trail_rock,
		"vegetation_left": vegetation_left,
		"vegetation_right": vegetation_right,
		"rock_cluster": rock_cluster,
	}

static func _add_tree(parent: Node3D, position: Vector3) -> Node3D:
	var visual := TrailPineScene.instantiate() as Node3D
	if visual == null:
		push_error("Pixel RPG World Trail Environment 001 failed to instantiate trail pine visual.")
		return null
	visual.position = position
	visual.set_meta("pixel_rpg_trail_pine_visual", true)
	parent.add_child(visual)
	return visual

static func _add_trail_rock(parent: Node3D) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = "TrailRockL"
	body.position = TRAIL_ROCK_POSITION
	body.collision_layer = 1
	body.collision_mask = 1
	parent.add_child(body)

	var visual := TrailRockVisualScene.instantiate() as MeshInstance3D
	if visual == null:
		push_error("Pixel RPG World Trail Environment 001 failed to instantiate TrailRockL visual.")
	else:
		visual.name = "MeshInstance3D"
		body.add_child(visual)

	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var shape := BoxShape3D.new()
	shape.size = TRAIL_ROCK_COLLISION_SIZE
	collision.shape = shape
	body.add_child(collision)

	return body
