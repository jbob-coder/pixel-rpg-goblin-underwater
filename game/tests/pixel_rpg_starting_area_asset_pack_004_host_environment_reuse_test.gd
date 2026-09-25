extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const PINE_SCENE: PackedScene = preload("res://assets/environment/starting_area/trail_pine_01.tscn")
const ROCK_VISUAL_SCENE: PackedScene = preload("res://assets/environment/starting_area/trail_rock_visual_01.tscn")
const TRAIL_ENV := preload("res://scripts/presentation/pixel_rpg/world_trail_environment_001.gd")

const EXPECTED_TREE_POSITIONS := [
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

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _contains_physics(node: Node) -> bool:
	if node is CollisionObject3D or node is CollisionShape3D:
		return true
	for child in node.get_children():
		if _contains_physics(child):
			return true
	return false

func _has_position(positions: Array, target: Vector3) -> bool:
	for position_variant in positions:
		if position_variant is Vector3 and (position_variant as Vector3).distance_to(target) <= 0.0001:
			return true
	return false

func _same_positions(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for expected in a:
		if not _has_position(b, expected as Vector3):
			return false
	return true

func _collect_roots_with_nodes(parent: Node3D, required_a: String, required_b: String) -> Array[Node3D]:
	var found: Array[Node3D] = []
	if parent == null:
		return found
	for child in parent.get_children():
		if child is Node3D:
			var node3d := child as Node3D
			if node3d.has_node(NodePath(required_a)) and node3d.has_node(NodePath(required_b)):
				found.append(node3d)
	return found

func _run() -> void:
	print("Pixel RPG Starting Area Asset Pack 004 + extracted trail-environment parity gate")

	_check("trail-environment owner schema is stable", String(TRAIL_ENV.get_schema()) == "pixel_rpg.world_trail_environment_001.v1")
	_check("trail-environment tree placement contract is exact", _same_positions(TRAIL_ENV.TREE_POSITIONS, EXPECTED_TREE_POSITIONS))
	_check("TrailRockL placement contract is exact", TRAIL_ENV.TRAIL_ROCK_POSITION.is_equal_approx(Vector3(-3.8, 0.75, -29.0)))
	_check("TrailRockL collision contract is exact", TRAIL_ENV.TRAIL_ROCK_COLLISION_SIZE.is_equal_approx(Vector3(2.4, 1.5, 2.0)))
	_check("trail vegetation placement contracts are exact", TRAIL_ENV.VEGETATION_LEFT_POSITION.is_equal_approx(Vector3(-8.5, 0.0, -22.0)) and is_equal_approx(TRAIL_ENV.VEGETATION_LEFT_YAW_DEG, 0.0) and TRAIL_ENV.VEGETATION_RIGHT_POSITION.is_equal_approx(Vector3(8.0, 0.0, -31.0)) and is_equal_approx(TRAIL_ENV.VEGETATION_RIGHT_YAW_DEG, 120.0))
	_check("trail rock-cluster placement contract is exact", TRAIL_ENV.ROCK_CLUSTER_POSITION.is_equal_approx(Vector3(4.8, 0.0, -34.0)) and is_equal_approx(TRAIL_ENV.ROCK_CLUSTER_YAW_DEG, 0.0))

	var pine := PINE_SCENE.instantiate() as Node3D
	_check("trail pine scene instantiates", pine != null)
	if pine != null:
		root.add_child(pine)
		_check("trail pine is presentation-only", not _contains_physics(pine))
		_check("trail pine keeps readable trunk/crown structure", pine.has_node("Trunk") and pine.has_node("CrownLower") and pine.has_node("CrownUpper"))
		pine.queue_free()

	var rock_visual := ROCK_VISUAL_SCENE.instantiate() as MeshInstance3D
	_check("trail rock visual scene instantiates as direct mesh", rock_visual != null)
	if rock_visual != null:
		root.add_child(rock_visual)
		_check("trail rock visual is presentation-only", not _contains_physics(rock_visual))
		_check("trail rock visual keeps original BoxMesh envelope", rock_visual.mesh is BoxMesh and (rock_visual.mesh as BoxMesh).size.is_equal_approx(Vector3(2.4, 1.5, 2.0)))
		_check("trail rock visual adds bounded surface detail", rock_visual.has_node("MossPatchA") and rock_visual.has_node("PebbleA"))
		rock_visual.queue_free()

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with host environment reuse", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	var smith := geometry.get_node_or_null("WorldPack004EnterableSmith") as Node3D if geometry != null else null
	var monster := geometry.get_node_or_null("MonsterProxy") as Node3D if geometry != null else null
	var trail_rock := geometry.get_node_or_null("TrailRockL") as StaticBody3D if geometry != null else null
	var vegetation_roots := _collect_roots_with_nodes(geometry, "TreeATrunk", "GrassA")
	var rock_roots := _collect_roots_with_nodes(geometry, "RockA", "MossPatchA")

	var live_tree_positions: Array[Vector3] = []
	if geometry != null:
		for child in geometry.get_children():
			if child is Node3D and bool(child.get_meta("pixel_rpg_trail_pine_visual", false)):
				live_tree_positions.append((child as Node3D).position)

	_check("exactly ten host trail trees now use reusable visual scene", live_tree_positions.size() == EXPECTED_TREE_POSITIONS.size(), str(live_tree_positions.size()))
	for expected_position in EXPECTED_TREE_POSITIONS:
		_check("trail tree position preserved " + str(expected_position), _has_position(live_tree_positions, expected_position))

	_check("TrailRockL remains StaticBody3D", trail_rock != null)
	if trail_rock != null:
		_check("TrailRockL position preserved", trail_rock.position.is_equal_approx(Vector3(-3.8, 0.75, -29.0)), str(trail_rock.position))
		_check("TrailRockL collision layer/mask preserved", trail_rock.collision_layer == 1 and trail_rock.collision_mask == 1)
		var live_visual := trail_rock.get_node_or_null("MeshInstance3D") as MeshInstance3D
		var collision := trail_rock.get_node_or_null("CollisionShape3D") as CollisionShape3D
		_check("TrailRockL keeps direct reusable mesh child", live_visual != null and live_visual.has_node("MossPatchA") and not _contains_physics(live_visual))
		_check("TrailRockL keeps direct collision child", collision != null and collision.shape is BoxShape3D)
		if collision != null and collision.shape is BoxShape3D:
			_check("TrailRockL collision dimensions preserved", (collision.shape as BoxShape3D).size.is_equal_approx(Vector3(2.4, 1.5, 2.0)), str((collision.shape as BoxShape3D).size))

	_check("two trail vegetation clusters remain live", vegetation_roots.size() == 2, str(vegetation_roots.map(func(node): return {"name": node.name, "position": node.position, "yaw": node.rotation_degrees.y})))
	_check("left trail vegetation transform preserved", vegetation_roots.any(func(node): return node.position.is_equal_approx(Vector3(-8.5, 0.0, -22.0)) and is_equal_approx(node.rotation_degrees.y, 0.0)))
	_check("right trail vegetation transform preserved", vegetation_roots.any(func(node): return node.position.is_equal_approx(Vector3(8.0, 0.0, -31.0)) and is_equal_approx(node.rotation_degrees.y, 120.0)))
	_check("trail rock-cluster transform preserved", rock_roots.size() == 1 and rock_roots[0].position.is_equal_approx(Vector3(4.8, 0.0, -34.0)) and is_equal_approx(rock_roots[0].rotation_degrees.y, 0.0))

	_check("Pack 004 smith remains intact", smith != null and smith.has_node("UseAnchor") and smith.has_node("Collision"))
	_check("Mudcrest world anchor remains unchanged", monster != null and monster.position.is_equal_approx(Vector3(0.0, 0.0, -49.0)))
	_check("first-person camera remains current", camera != null and camera.current)

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_004_HOST_ENVIRONMENT_REUSE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_004_HOST_ENVIRONMENT_REUSE_FAILED")
	print("This gate proves the extracted trail-environment owner preserves exact tree/vegetation/rock placement, TrailRockL gameplay collision, reusable presentation scenes, smith/monster anchors and first-person presentation. Device acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
