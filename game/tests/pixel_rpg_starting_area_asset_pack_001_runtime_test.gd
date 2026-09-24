extends SceneTree

const WORLD_PACK := preload("res://scripts/presentation/pixel_rpg/world_pack_001.gd")
const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const GATE_SCENE: PackedScene = preload("res://assets/environment/starting_area/settlement_gate_01.tscn")
const MARKET_SCENE: PackedScene = preload("res://assets/environment/starting_area/market_stall_01.tscn")
const CLUTTER_SCENE: PackedScene = preload("res://assets/environment/starting_area/service_clutter_01.tscn")
const SIGNPOST_SCENE: PackedScene = preload("res://assets/environment/starting_area/signpost_01.tscn")
const LANTERN_SCENE: PackedScene = preload("res://assets/environment/starting_area/lantern_post_01.tscn")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _check_scene(scene: PackedScene, expected_root: String, required_nodes: Array[String]) -> void:
	var instance := scene.instantiate() as Node3D
	_check(expected_root + " scene instantiates", instance != null)
	if instance == null:
		return
	root.add_child(instance)
	_check(expected_root + " root name preserved", instance.name == expected_root, instance.name)
	for node_name in required_nodes:
		_check(expected_root + " contains " + node_name, instance.get_node_or_null(NodePath(node_name)) != null)
	instance.queue_free()

func _run() -> void:
	print("Pixel RPG Starting Area Asset Pack 001 runtime gate")
	_check("asset pack schema is stable", WORLD_PACK.STARTING_AREA_ASSET_PACK_SCHEMA == "pixel_rpg.starting_area_asset_pack_001.v1")

	_check_scene(GATE_SCENE, "WorldPack001Gate", ["LeftTower", "RightTower", "UpperBeam", "BraceLeft", "BraceRight", "StoneFootingLeft", "GateBanner"])
	_check_scene(MARKET_SCENE, "WorldPack001Market", ["Counter", "PostLeft", "PostRight", "Canopy", "CrateA", "CrateB", "CounterTop", "Shelf"])
	_check_scene(CLUTTER_SCENE, "WorldPack001Clutter", ["Crate", "Barrel", "CrateLid", "SackA"])
	_check_scene(SIGNPOST_SCENE, "WorldPack001Signpost", ["Post", "SignA", "SignB", "SignC", "StoneFoot"])
	_check_scene(LANTERN_SCENE, "WorldPack001Lantern", ["Pole", "Arm", "Frame", "Glow", "LanternCap"])

	var parent := Node3D.new()
	parent.name = "BuilderContractRoot"
	root.add_child(parent)
	var gate := WORLD_PACK.add_settlement_gate(parent, Vector3(2.0, 0.0, -4.0))
	var market := WORLD_PACK.add_market_stall(parent, Vector3(-3.0, 0.0, 5.0), 37.0)
	var clutter := WORLD_PACK.add_service_clutter(parent, Vector3(1.0, 0.0, 2.0), -15.0)
	var signpost := WORLD_PACK.add_signpost(parent, Vector3(4.0, 0.0, -2.0), 12.0)
	var lantern := WORLD_PACK.add_lantern_post(parent, Vector3(-4.0, 0.0, -2.0), 180.0)
	_check("gate builder preserves caller position", gate != null and gate.position.is_equal_approx(Vector3(2.0, 0.0, -4.0)), str(gate.position) if gate != null else "missing")
	_check("market builder preserves caller yaw", market != null and is_equal_approx(market.rotation_degrees.y, 37.0), str(market.rotation_degrees.y) if market != null else "missing")
	_check("clutter builder preserves caller transform", clutter != null and clutter.position.is_equal_approx(Vector3(1.0, 0.0, 2.0)) and is_equal_approx(clutter.rotation_degrees.y, -15.0))
	_check("signpost builder preserves caller transform", signpost != null and signpost.position.is_equal_approx(Vector3(4.0, 0.0, -2.0)) and is_equal_approx(signpost.rotation_degrees.y, 12.0))
	_check("lantern builder preserves caller yaw", lantern != null and is_equal_approx(absf(lantern.rotation_degrees.y), 180.0), str(lantern.rotation_degrees.y) if lantern != null else "missing")
	parent.queue_free()

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with applied asset pack", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		await process_frame
		await physics_frame
		var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
		var live_gate := geometry.get_node_or_null("WorldPack001Gate") as Node3D if geometry != null else null
		var live_market := geometry.get_node_or_null("WorldPack001Market") as Node3D if geometry != null else null
		var live_clutter := geometry.get_node_or_null("WorldPack001Clutter") as Node3D if geometry != null else null
		var live_signpost := geometry.get_node_or_null("WorldPack001Signpost") as Node3D if geometry != null else null
		var live_camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
		_check("starting-area gate uses Pack 001 scene asset", live_gate != null and live_gate.has_node("StoneFootingLeft") and live_gate.has_node("GateBanner"))
		_check("starting-area market uses Pack 001 scene asset", live_market != null and live_market.has_node("CounterTop") and live_market.has_node("Shelf"))
		_check("starting-area clutter uses Pack 001 scene asset", live_clutter != null and live_clutter.has_node("CrateLid") and live_clutter.has_node("SackA"))
		_check("starting-area signpost uses Pack 001 scene asset", live_signpost != null and live_signpost.has_node("StoneFoot"))
		_check("first-person camera remains current", live_camera != null and live_camera.current)
		prototype.queue_free()
		await process_frame

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_001_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_001_FAILED")
	print("This gate proves reusable scene instantiation, builder wiring, applied starting-area nodes and first-person preservation. Physical-device visual acceptance and sustained performance remain open.")
	quit(0 if failures.is_empty() else 1)
