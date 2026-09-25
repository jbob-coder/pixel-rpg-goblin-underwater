extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const BUILDING_DETAILS_SCENE: PackedScene = preload("res://assets/environment/starting_area/settlement_building_details_01.tscn")
const SETTLEMENT_CORE := preload("res://scripts/presentation/pixel_rpg/world_settlement_core_001.gd")

const EXPECTED_BUILDINGS := [
	{"position": Vector3(-7.0, 1.7, 8.5), "size": Vector3(7.0, 3.4, 7.0)},
	{"position": Vector3(7.5, 1.6, -3.0), "size": Vector3(6.8, 3.2, 6.4)},
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

func _box_shape(body: StaticBody3D) -> BoxShape3D:
	if body == null:
		return null
	for child in body.get_children():
		if child is CollisionShape3D and (child as CollisionShape3D).shape is BoxShape3D:
			return (child as CollisionShape3D).shape as BoxShape3D
	return null

func _find_building_body(geometry: Node3D, expected_position: Vector3, expected_size: Vector3) -> StaticBody3D:
	if geometry == null:
		return null
	for child in geometry.get_children():
		if child is StaticBody3D:
			var body := child as StaticBody3D
			if body.position.distance_to(expected_position) > 0.0001:
				continue
			var shape := _box_shape(body)
			if shape != null and shape.size.distance_to(expected_size) <= 0.0001:
				return body
	return null

func _has_detail_at(details: Array[Node3D], expected_position: Vector3) -> bool:
	for detail in details:
		if detail.position.distance_to(expected_position) <= 0.0001:
			return true
	return false

func _run() -> void:
	print("Pixel RPG Starting Area Asset Pack 006 + extracted settlement-core parity gate")

	_check("settlement-core owner schema is stable", String(SETTLEMENT_CORE.get_schema()) == "pixel_rpg.world_settlement_core_001.v1")
	_check("building A placement contract is exact", SETTLEMENT_CORE.GENERIC_BUILDING_A_POSITION.is_equal_approx(Vector3(-7.0, 1.7, 8.5)) and SETTLEMENT_CORE.GENERIC_BUILDING_A_SIZE.is_equal_approx(Vector3(7.0, 3.4, 7.0)))
	_check("market placement contract is exact", SETTLEMENT_CORE.MARKET_POSITION.is_equal_approx(Vector3(7.0, 0.0, 6.0)) and is_equal_approx(SETTLEMENT_CORE.MARKET_YAW_DEG, -90.0))
	_check("smith placement contract is exact", SETTLEMENT_CORE.SMITH_POSITION.is_equal_approx(Vector3(-7.4, 0.0, -1.5)) and is_equal_approx(SETTLEMENT_CORE.SMITH_YAW_DEG, 90.0))
	_check("building B placement contract is exact", SETTLEMENT_CORE.GENERIC_BUILDING_B_POSITION.is_equal_approx(Vector3(7.5, 1.6, -3.0)) and SETTLEMENT_CORE.GENERIC_BUILDING_B_SIZE.is_equal_approx(Vector3(6.8, 3.2, 6.4)))

	var reusable := BUILDING_DETAILS_SCENE.instantiate() as Node3D
	_check("settlement building detail scene instantiates", reusable != null)
	if reusable != null:
		root.add_child(reusable)
		_check("building details remain presentation-only", not _contains_physics(reusable))
		_check("building details expose door/windows", reusable.has_node("DoorPanel") and reusable.has_node("WindowLeft") and reusable.has_node("WindowRight"))
		_check("building details expose structural readability", reusable.has_node("FrontBeam") and reusable.has_node("CornerPostLeft") and reusable.has_node("EaveFront") and reusable.has_node("Chimney"))
		reusable.queue_free()

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with settlement building details", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	var warden := geometry.get_node_or_null("GateWarden") as Node3D if geometry != null else null
	var smith := geometry.get_node_or_null("WorldPack004EnterableSmith") as Node3D if geometry != null else null
	var market := geometry.get_node_or_null("WorldPack001Market") as Node3D if geometry != null else null
	var monster := geometry.get_node_or_null("MonsterProxy") as Node3D if geometry != null else null

	var details: Array[Node3D] = []
	if geometry != null:
		for child in geometry.get_children():
			if child is Node3D and bool(child.get_meta("pixel_rpg_settlement_building_details", false)):
				details.append(child as Node3D)

	_check("exactly two reusable building detail layers are live", details.size() == 2, str(details.size()))
	for expected_variant in EXPECTED_BUILDINGS:
		var expected := expected_variant as Dictionary
		var expected_position: Vector3 = expected["position"]
		var expected_size: Vector3 = expected["size"]
		var body := _find_building_body(geometry, expected_position, expected_size)
		_check("building collision body preserved at " + str(expected_position), body != null)
		if body != null:
			_check("building collision layer/mask preserved " + str(expected_position), body.collision_layer == 1 and body.collision_mask == 1)
		_check("building detail placement preserved " + str(expected_position), _has_detail_at(details, expected_position))

	for detail in details:
		_check("live building detail owns no physics " + detail.name, not _contains_physics(detail))
		_check("live building detail contains facade identity " + detail.name, detail.has_node("DoorPanel") and detail.has_node("FrontBeam") and detail.has_node("Chimney"))

	_check("Gate Warden remains exact", warden != null and warden.position.is_equal_approx(Vector3(-2.6, 0.0, -6.2)))
	_check("Pack 004 smith remains intact", smith != null and smith.has_node("UseAnchor") and smith.has_node("Collision"))
	_check("smith transform remains exact after settlement extraction", smith != null and smith.position.is_equal_approx(Vector3(-7.4, 0.0, -1.5)) and is_equal_approx(smith.rotation_degrees.y, 90.0))
	_check("market transform remains exact after settlement extraction", market != null and market.position.is_equal_approx(Vector3(7.0, 0.0, 6.0)) and is_equal_approx(market.rotation_degrees.y, -90.0))
	_check("Mudcrest anchor remains exact", monster != null and monster.position.is_equal_approx(Vector3(0.0, 0.0, -49.0)))
	_check("first-person camera remains current", camera != null and camera.current)

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_006_SETTLEMENT_BUILDING_DETAILS_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_006_SETTLEMENT_BUILDING_DETAILS_FAILED")
	print("This gate proves the extracted settlement core preserves reusable presentation-only building details, exact generic-building collision/body parity, market/smith transforms, Gate Warden, Mudcrest and first-person presentation. Collision ownership is mechanically preserved here, not redesigned. Device acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
