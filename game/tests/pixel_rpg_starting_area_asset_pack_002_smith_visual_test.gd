extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const SMITH_PACK := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")
const FORGE_DETAIL: PackedScene = preload("res://assets/environment/starting_area/smith_forge_detail_01.tscn")
const ANVIL_DETAIL: PackedScene = preload("res://assets/environment/starting_area/smith_anvil_detail_01.tscn")
const BENCH_DETAIL: PackedScene = preload("res://assets/environment/starting_area/smith_bench_detail_01.tscn")
const FRONTAGE_DETAIL: PackedScene = preload("res://assets/environment/starting_area/smith_frontage_detail_01.tscn")

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

func _check_detail_scene(scene: PackedScene, expected_name: String, required_nodes: Array[String]) -> void:
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
	print("Pixel RPG Starting Area Asset Pack 002 smith visual runtime gate")
	_check("smith visual schema is stable", SMITH_PACK.SMITH_VISUAL_ASSET_PACK_SCHEMA == "pixel_rpg.starting_area_asset_pack_002_smith_visual.v1")

	_check_detail_scene(FORGE_DETAIL, "SmithForgeDetail01", ["EmberCore", "ForgeBackplate", "ChimneyStack", "ToolBar"])
	_check_detail_scene(ANVIL_DETAIL, "SmithAnvilDetail01", ["AnvilHorn", "AnvilWaist", "WorkHandle", "WorkHead"])
	_check_detail_scene(BENCH_DETAIL, "SmithBenchDetail01", ["BenchTop", "BenchLowerShelf", "ToolRackCrossbar", "ToolRoll"])
	_check_detail_scene(FRONTAGE_DETAIL, "SmithFrontageDetail01", ["DoorHeaderBeam", "LeftBrace", "RightBrace", "SmithBanner"])

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with smith visual pack", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	_check("smith root identity remains unchanged", smith != null and smith.name == "WorldPack004EnterableSmith")
	if smith != null:
		_check("existing direct-node contracts remain present",
			smith.has_node("InteriorFloor")
			and smith.has_node("ForgeHearth")
			and smith.has_node("AnvilTop")
			and smith.has_node("SmithBench")
			and smith.has_node("RoofA")
			and smith.has_node("RoofB")
			and smith.has_node("RidgeBeam")
			and smith.has_node("EntranceAnchor")
			and smith.has_node("UseAnchor")
			and smith.has_node("Collision")
		)
		var details := smith.get_node_or_null("SmithVisualDetails") as Node3D
		_check("smith detail root is applied", details != null)
		if details != null:
			_check("all four smith detail scenes are applied",
				details.has_node("SmithForgeDetail01")
				and details.has_node("SmithAnvilDetail01")
				and details.has_node("SmithBenchDetail01")
				and details.has_node("SmithFrontageDetail01")
			)
			_check("applied details remain presentation-only", not _contains_physics(details))
		var collision_root := smith.get_node_or_null("Collision") as Node3D
		_check("authoritative smith collision remains separate", collision_root != null and collision_root.get_child_count() == 7)
	_check("first-person camera remains current", camera != null and camera.current)

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_002_SMITH_VISUAL_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_002_SMITH_VISUAL_FAILED")
	print("This gate proves additive smith presentation assets, preserved direct-node contracts, collision separation and first-person preservation. Phone visual acceptance and performance remain open.")
	quit(0 if failures.is_empty() else 1)
