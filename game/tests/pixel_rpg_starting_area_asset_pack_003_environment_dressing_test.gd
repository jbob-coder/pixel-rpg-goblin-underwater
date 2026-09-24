extends SceneTree

const WORLD_PACK := preload("res://scripts/presentation/pixel_rpg/world_pack_001.gd")
const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const FENCE_SCENE: PackedScene = preload("res://assets/environment/starting_area/fence_01.tscn")
const BANNER_SCENE: PackedScene = preload("res://assets/environment/starting_area/banner_post_01.tscn")
const VEGETATION_SCENE: PackedScene = preload("res://assets/environment/starting_area/vegetation_cluster_01.tscn")
const ROCK_SCENE: PackedScene = preload("res://assets/environment/starting_area/rock_cluster_01.tscn")

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

func _check_scene(scene: PackedScene, expected_name: String, required_nodes: Array[String]) -> void:
	var instance := scene.instantiate() as Node3D
	_check(expected_name + " instantiates", instance != null)
	if instance == null:
		return
	root.add_child(instance)
	_check(expected_name + " root identity", instance.name == expected_name, instance.name)
	_check(expected_name + " remains presentation-only", not _contains_physics(instance))
	for node_name in required_nodes:
		_check(expected_name + " contains " + node_name, instance.has_node(NodePath(node_name)))
	instance.queue_free()

func _run() -> void:
	print("Pixel RPG Starting Area Asset Pack 003 environment dressing runtime gate")
	_check("environment dressing schema is stable", WORLD_PACK.ENVIRONMENT_DRESSING_SCHEMA == "pixel_rpg.starting_area_asset_pack_003_environment_dressing.v1")

	_check_scene(FENCE_SCENE, "WorldPack001Fence", ["PostLeft", "PostRight", "RailLow", "RailHigh", "FootingLeft"])
	_check_scene(BANNER_SCENE, "WorldPack001Banner", ["Post", "TopBar", "Banner", "StoneFoot", "BannerMarkCross"])
	_check_scene(VEGETATION_SCENE, "WorldPack001Vegetation", ["TreeATrunk", "TreeACanopyLower", "TreeBTrunk", "BushA", "GrassA"])
	_check_scene(ROCK_SCENE, "WorldPack001Rocks", ["RockA", "RockB", "RockC", "MossPatchA", "PebbleA"])

	var parent := Node3D.new()
	parent.name = "EnvironmentBuilderContractRoot"
	root.add_child(parent)
	var fence := WORLD_PACK.add_fence(parent, Vector3(-4.0, 0.0, -16.5), 10.0)
	var banner := WORLD_PACK.add_banner_post(parent, Vector3(-6.7, 0.0, -9.2), -8.0)
	var vegetation := WORLD_PACK.add_vegetation_cluster(parent, Vector3(-8.5, 0.0, -22.0), 21.0)
	var rocks := WORLD_PACK.add_rock_cluster(parent, Vector3(4.8, 0.0, -34.0), -17.0)
	_check("fence caller transform preserved", fence != null and fence.position.is_equal_approx(Vector3(-4.0, 0.0, -16.5)) and is_equal_approx(fence.rotation_degrees.y, 10.0))
	_check("banner caller transform preserved", banner != null and banner.position.is_equal_approx(Vector3(-6.7, 0.0, -9.2)) and is_equal_approx(banner.rotation_degrees.y, -8.0))
	_check("vegetation caller transform preserved", vegetation != null and vegetation.position.is_equal_approx(Vector3(-8.5, 0.0, -22.0)) and is_equal_approx(vegetation.rotation_degrees.y, 21.0))
	_check("rocks caller transform preserved", rocks != null and rocks.position.is_equal_approx(Vector3(4.8, 0.0, -34.0)) and is_equal_approx(rocks.rotation_degrees.y, -17.0))
	parent.queue_free()

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with environment dressing", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		await process_frame
		await physics_frame
		var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
		var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
		var smith := geometry.get_node_or_null("WorldPack004EnterableSmith") as Node3D if geometry != null else null
		var first_fence := geometry.find_child("WorldPack001Fence", false, false) as Node3D if geometry != null else null
		var banner_live := geometry.get_node_or_null("WorldPack001Banner") as Node3D if geometry != null else null
		var vegetation_live := geometry.find_child("WorldPack001Vegetation", false, false) as Node3D if geometry != null else null
		var rocks_live := geometry.get_node_or_null("WorldPack001Rocks") as Node3D if geometry != null else null
		_check("live fence uses reusable scene internals", first_fence != null and first_fence.has_node("FootingLeft") and first_fence.has_node("RopeTieLeft"))
		_check("live banner uses reusable scene internals", banner_live != null and banner_live.has_node("StoneFoot") and banner_live.has_node("BannerMarkCross"))
		_check("live vegetation uses reusable scene internals", vegetation_live != null and vegetation_live.has_node("TreeACanopyUpper") and vegetation_live.has_node("GrassA"))
		_check("live rocks use reusable scene internals", rocks_live != null and rocks_live.has_node("MossPatchA") and rocks_live.has_node("PebbleA"))
		_check("Pack 004 smith remains present", smith != null and smith.has_node("UseAnchor") and smith.has_node("Collision"))
		_check("first-person camera remains current", camera != null and camera.current)
		prototype.queue_free()
		await process_frame

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_003_ENVIRONMENT_DRESSING_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_003_ENVIRONMENT_DRESSING_FAILED")
	print("This gate proves reusable non-colliding environment dressing, preserved builder transforms, live application, smith preservation and first-person preservation. Device visual/performance acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
