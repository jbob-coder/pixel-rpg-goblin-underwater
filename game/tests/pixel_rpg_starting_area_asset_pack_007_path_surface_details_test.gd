extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const STREET_DETAILS: PackedScene = preload("res://assets/environment/starting_area/street_surface_details_01.tscn")
const TRAIL_DETAILS: PackedScene = preload("res://assets/environment/starting_area/trail_surface_details_01.tscn")

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

func _box_size(holder: Node3D) -> Vector3:
	if holder == null:
		return Vector3.ZERO
	for child in holder.get_children():
		if child is MeshInstance3D and (child as MeshInstance3D).mesh is BoxMesh:
			return ((child as MeshInstance3D).mesh as BoxMesh).size
	return Vector3.ZERO

func _run() -> void:
	print("Pixel RPG Starting Area Asset Pack 007 path surface details runtime gate")

	var street_asset := STREET_DETAILS.instantiate() as Node3D
	_check("street detail scene instantiates", street_asset != null)
	if street_asset != null:
		root.add_child(street_asset)
		_check("street detail remains presentation-only", not _contains_physics(street_asset))
		_check("street detail has readable ruts and stones", street_asset.has_node("RutLeftA") and street_asset.has_node("RutRightB") and street_asset.has_node("StoneA"))
		street_asset.queue_free()

	var trail_asset := TRAIL_DETAILS.instantiate() as Node3D
	_check("trail detail scene instantiates", trail_asset != null)
	if trail_asset != null:
		root.add_child(trail_asset)
		_check("trail detail remains presentation-only", not _contains_physics(trail_asset))
		_check("trail detail has wear/edge breakup", trail_asset.has_node("CenterWearA") and trail_asset.has_node("EdgeStoneA") and trail_asset.has_node("MossEdgeA"))
		trail_asset.queue_free()

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with path surface details", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	var street := geometry.get_node_or_null("Street") as Node3D if geometry != null else null
	var trail := geometry.get_node_or_null("Trail") as Node3D if geometry != null else null
	var ground := geometry.get_node_or_null("Ground") as StaticBody3D if geometry != null else null
	var street_details := geometry.get_node_or_null("StreetSurfaceDetails") as Node3D if geometry != null else null
	var trail_details := geometry.get_node_or_null("TrailSurfaceDetails") as Node3D if geometry != null else null
	var warden := geometry.get_node_or_null("GateWarden") as Node3D if geometry != null else null
	var smith := geometry.get_node_or_null("WorldPack004EnterableSmith") as Node3D if geometry != null else null
	var monster := geometry.get_node_or_null("MonsterProxy") as Node3D if geometry != null else null

	_check("Street base position remains exact", street != null and street.position.is_equal_approx(Vector3(0.0, 0.03, 2.0)), str(street.position) if street != null else "missing")
	_check("Street base size remains exact", street != null and _box_size(street).is_equal_approx(Vector3(6.2, 0.10, 34.0)), str(_box_size(street)))
	_check("Trail base position remains exact", trail != null and trail.position.is_equal_approx(Vector3(0.0, 0.04, -31.0)), str(trail.position) if trail != null else "missing")
	_check("Trail base size remains exact", trail != null and _box_size(trail).is_equal_approx(Vector3(4.2, 0.11, 34.0)), str(_box_size(trail)))
	_check("Ground remains physical floor authority", ground != null and ground.collision_layer == 1 and ground.get_child_count() >= 2)

	_check("live street detail placement remains exact", street_details != null and street_details.position.is_equal_approx(Vector3(0.0, 0.03, 2.0)))
	_check("live trail detail placement remains exact", trail_details != null and trail_details.position.is_equal_approx(Vector3(0.0, 0.04, -31.0)))
	_check("live street details own no physics", street_details != null and not _contains_physics(street_details))
	_check("live trail details own no physics", trail_details != null and not _contains_physics(trail_details))

	_check("Gate Warden remains exact", warden != null and warden.position.is_equal_approx(Vector3(-2.6, 0.0, -6.2)))
	_check("Pack 004 smith remains intact", smith != null and smith.has_node("UseAnchor") and smith.has_node("Collision"))
	_check("Mudcrest anchor remains exact", monster != null and monster.position.is_equal_approx(Vector3(0.0, 0.0, -49.0)))
	_check("first-person camera remains current", camera != null and camera.current)

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_007_PATH_SURFACE_DETAILS_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_007_PATH_SURFACE_DETAILS_FAILED")
	print("This gate proves presentation-only Street/Trail detail, exact base mesh parity, Ground collision authority, and first-person/world-anchor preservation. Device acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
