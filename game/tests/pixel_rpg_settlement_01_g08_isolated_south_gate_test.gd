extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
const G05 := preload("res://scripts/world/settlement/settlement_01_residential_graybox.gd")
const G06 := preload("res://scripts/world/settlement/settlement_01_work_support_graybox.gd")
const G07 := preload("res://scripts/world/settlement/settlement_01_worker_passage_graybox.gd")
const G08 := preload("res://scripts/world/settlement/settlement_01_south_gate_graybox.gd")
const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _vec3_equal(left: Vector3, right: Vector3, epsilon := 0.0001) -> bool:
	return left.distance_to(right) <= epsilon

func _shape_size(body: StaticBody3D) -> Vector3:
	if body == null:
		return Vector3.ZERO
	var shape_node := body.get_node_or_null("Shape") as CollisionShape3D
	if shape_node == null or not (shape_node.shape is BoxShape3D):
		return Vector3.ZERO
	return (shape_node.shape as BoxShape3D).size

func _run() -> void:
	print("Pixel RPG Settlement 01 G08 — isolated South Arrival Gate gate")

	_check("G08 South Gate schema is stable", String(G08.get_schema()) == "pixel_rpg.settlement_01_south_gate_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G08IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base still builds", base_root != null)
	_check("G02 isolated plaza still builds", G02.add_plaza(base_root).get("root") != null)
	_check("G03 isolated Smith still builds", G03.add_smith(base_root).get("smith") != null)
	_check("G04 isolated Community Hall still builds", G04.add_community_hall(base_root).get("hall") != null)
	var g05: Dictionary = G05.add_residences(base_root)
	_check("G05 isolated residences still build", g05.get("residence_w02") != null and g05.get("residence_w01") != null)
	var g06: Dictionary = G06.add_work_support(base_root)
	_check("G06 isolated work support still builds", g06.get("canopy") != null and g06.get("storage") != null)
	_check("G07 isolated worker passage still builds", G07.add_worker_passage(base_root).get("root") != null)

	var g08: Dictionary = G08.add_south_gate(base_root)
	var g08_root := g08.get("root") as Node3D
	var gatehouse := g08.get("gatehouse") as Node3D
	var watch := g08.get("watch") as Node3D
	var gate_frame := g08.get("gate_frame") as Node3D
	var connectors: Array = g08.get("wall_connectors", [])

	_check("G08 South Gate root is created", g08_root != null and g08_root.name == "SouthArrivalGateGraybox")
	if g08_root != null:
		_check("G08 root carries S01/A01 ownership",
			String(g08_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(g08_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A01_SOUTH_ARRIVAL_GATE"
		)
		_check("G08 root records isolated pass", String(g08_root.get_meta("pixel_rpg_graybox_pass", "")) == "G08")
		_check("G08 final art remains unlocked", not bool(g08_root.get_meta("pixel_rpg_final_art_locked", true)))

	_check("Gatehouse W stays at locked center", gatehouse != null and _vec3_equal(gatehouse.position, Vector3(-8.0, 0.0, 29.0)), str(gatehouse.position) if gatehouse != null else "missing")
	_check("Watch E stays at locked center", watch != null and _vec3_equal(watch.position, Vector3(8.0, 0.0, 29.0)), str(watch.position) if watch != null else "missing")
	_check("South Gate frame stays at locked center", gate_frame != null and _vec3_equal(gate_frame.position, Vector3(0.0, 0.0, 33.0)), str(gate_frame.position) if gate_frame != null else "missing")

	if gatehouse != null:
		_check("Gatehouse has stable building identity",
			String(gatehouse.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_SOUTH_GATEHOUSE_W"
			and String(gatehouse.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(gatehouse.get_meta("pixel_rpg_area_id", "")) == "SET01_A01_SOUTH_ARRIVAL_GATE"
		)
		_check("Gatehouse final art remains unlocked", not bool(gatehouse.get_meta("pixel_rpg_final_art_locked", true)))
		_check("Gatehouse exposes required arrival anchors",
			gatehouse.has_node("EntranceAnchor")
			and gatehouse.has_node("ExitAnchor")
			and gatehouse.has_node("ArrivalGuardWorkAnchor")
			and gatehouse.has_node("VisitorConversationAnchor")
			and gatehouse.has_node("GateControlAnchor")
			and gatehouse.has_node("NoticeAnchor")
			and gatehouse.has_node("GuardIdleAnchor")
			and gatehouse.has_node("RoofVisibilityGroup")
		)
		_check("Gatehouse east facade collision is segmented",
			gatehouse.has_node("Collision/EastNorthCollision")
			and gatehouse.has_node("Collision/EastSouthCollision")
			and gatehouse.has_node("Collision/EastLintelCollision")
		)
		_check("Gatehouse has no monolithic sealed building collider", gatehouse.get_node_or_null("GatehouseCollision") == null)

		var east_north := gatehouse.get_node_or_null("Collision/EastNorthCollision") as StaticBody3D
		var east_south := gatehouse.get_node_or_null("Collision/EastSouthCollision") as StaticBody3D
		var east_lintel := gatehouse.get_node_or_null("Collision/EastLintelCollision") as StaticBody3D
		if east_north != null and east_south != null and east_lintel != null:
			var north_size := _shape_size(east_north)
			var south_size := _shape_size(east_south)
			var lintel_size := _shape_size(east_lintel)
			var north_inner_z := east_north.position.z + north_size.z * 0.5
			var south_inner_z := east_south.position.z - south_size.z * 0.5
			var doorway_gap := south_inner_z - north_inner_z
			var lintel_bottom := east_lintel.position.y - lintel_size.y * 0.5
			_check("Gatehouse doorway width remains 1.8 m", absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("Gatehouse doorway height remains 2.4 m", lintel_bottom >= 2.4 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

	if watch != null:
		_check("Watch has stable building identity",
			String(watch.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_SOUTH_WATCH_E"
			and String(watch.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(watch.get_meta("pixel_rpg_area_id", "")) == "SET01_A01_SOUTH_ARRIVAL_GATE"
		)
		_check("Watch exposes ground/watch anchors",
			watch.has_node("GroundEntranceAnchor")
			and watch.has_node("WatchGuardAnchor")
			and watch.has_node("LookoutAnchor")
			and watch.has_node("LanternSocket")
			and watch.has_node("BannerSocket")
		)
		var upper := watch.get_node_or_null("UpperWatchPresentation") as Node3D
		_check("Watch upper silhouette is presentation-only",
			upper != null and upper.find_children("*", "StaticBody3D", true, false).is_empty()
		)
		_check("Watch west facade collision is segmented",
			watch.has_node("Collision/WestNorthCollision")
			and watch.has_node("Collision/WestSouthCollision")
			and watch.has_node("Collision/WestLintelCollision")
		)

		var west_north := watch.get_node_or_null("Collision/WestNorthCollision") as StaticBody3D
		var west_south := watch.get_node_or_null("Collision/WestSouthCollision") as StaticBody3D
		var west_lintel := watch.get_node_or_null("Collision/WestLintelCollision") as StaticBody3D
		if west_north != null and west_south != null and west_lintel != null:
			var north_size := _shape_size(west_north)
			var south_size := _shape_size(west_south)
			var lintel_size := _shape_size(west_lintel)
			var north_inner_z := west_north.position.z + north_size.z * 0.5
			var south_inner_z := west_south.position.z - south_size.z * 0.5
			var doorway_gap := south_inner_z - north_inner_z
			var lintel_bottom := west_lintel.position.y - lintel_size.y * 0.5
			_check("Watch doorway width remains 1.6 m", absf(doorway_gap - 1.6) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("Watch doorway height remains 2.3 m", lintel_bottom >= 2.3 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

	if gatehouse != null and watch != null:
		var gatehouse_east_edge := gatehouse.position.x + 8.0 * 0.5
		var watch_west_edge := watch.position.x - 6.0 * 0.5
		_check("Gatehouse ends exactly at west gate edge", absf(gatehouse_east_edge - -4.0) <= 0.001, "edge=%.3f" % gatehouse_east_edge)
		_check("Watch stays at least 1 m east of gate edge", watch_west_edge >= 5.0 - 0.001, "edge=%.3f" % watch_west_edge)

	if gate_frame != null:
		_check("Gate frame records 8 m clear-width contract", absf(float(gate_frame.get_meta("pixel_rpg_gate_clear_width_m", 0.0)) - 8.0) <= 0.001)
		_check("Gate frame exposes arrival anchors",
			gate_frame.has_node("SouthGateCenterAnchor")
			and gate_frame.has_node("SouthGateInnerArrivalAnchor")
			and gate_frame.has_node("SouthGateOuterArrivalAnchor")
		)
		var left_post := gate_frame.get_node_or_null("Collision/GatePostLCollision") as StaticBody3D
		var right_post := gate_frame.get_node_or_null("Collision/GatePostRCollision") as StaticBody3D
		_check("Gate frame has separate blocking side posts", left_post != null and right_post != null)
		if left_post != null and right_post != null:
			var left_size := _shape_size(left_post)
			var right_size := _shape_size(right_post)
			var left_inner_x := left_post.position.x + left_size.x * 0.5
			var right_inner_x := right_post.position.x - right_size.x * 0.5
			var clear_gap := right_inner_x - left_inner_x
			_check("Gate post collision preserves exact 8 m opening", absf(clear_gap - 8.0) <= 0.001, "gap=%.3f" % clear_gap)

		_check("Open gate leaves remain presentation-only",
			gate_frame.has_node("GateLeafL_OpenPresentation")
			and gate_frame.has_node("GateLeafR_OpenPresentation")
			and gate_frame.get_node_or_null("Collision/GateLeafLCollision") == null
			and gate_frame.get_node_or_null("Collision/GateLeafRCollision") == null
		)

	_check("G08 creates left/right wall connector pair", connectors.size() == 2, "count=%d" % connectors.size())
	for connector_variant in connectors:
		var connector := connector_variant as StaticBody3D
		if connector == null:
			continue
		var size := _shape_size(connector)
		var min_x := connector.position.x - size.x * 0.5
		var max_x := connector.position.x + size.x * 0.5
		_check("%s remains outside central gate corridor" % connector.name, max_x <= -4.0 + 0.001 or min_x >= 4.0 - 0.001, "min=%.3f max=%.3f" % [min_x, max_x])
		_check("%s remains inside A01 X frame" % connector.name, min_x >= -14.0 - 0.001 and max_x <= 14.0 + 0.001, "min=%.3f max=%.3f" % [min_x, max_x])

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	if gatehouse != null:
		var door_query := PhysicsRayQueryParameters3D.create(
			gatehouse.to_global(Vector3(4.8, 0.9, 0.0)),
			gatehouse.to_global(Vector3(3.0, 0.9, 0.0))
		)
		door_query.collision_mask = 1
		_check("Gatehouse physics ray passes through real east doorway", space_state.intersect_ray(door_query).is_empty())

		var wall_query := PhysicsRayQueryParameters3D.create(
			gatehouse.to_global(Vector3(4.8, 0.9, 2.0)),
			gatehouse.to_global(Vector3(3.0, 0.9, 2.0))
		)
		wall_query.collision_mask = 1
		_check("Gatehouse adjacent east wall blocks physics", not space_state.intersect_ray(wall_query).is_empty())

	if watch != null:
		var door_query := PhysicsRayQueryParameters3D.create(
			watch.to_global(Vector3(-3.8, 0.9, 0.0)),
			watch.to_global(Vector3(-2.0, 0.9, 0.0))
		)
		door_query.collision_mask = 1
		_check("Watch physics ray passes through real west doorway", space_state.intersect_ray(door_query).is_empty())

		var wall_query := PhysicsRayQueryParameters3D.create(
			watch.to_global(Vector3(-3.8, 0.9, 2.0)),
			watch.to_global(Vector3(-2.0, 0.9, 2.0))
		)
		wall_query.collision_mask = 1
		_check("Watch adjacent west wall blocks physics", not space_state.intersect_ray(wall_query).is_empty())

	var gate_center_query := PhysicsRayQueryParameters3D.create(Vector3(0.0, 1.0, 34.2), Vector3(0.0, 1.0, 31.8))
	gate_center_query.collision_mask = 1
	_check("South Gate center corridor remains physically clear", space_state.intersect_ray(gate_center_query).is_empty())

	var left_post_query := PhysicsRayQueryParameters3D.create(Vector3(-4.5, 2.0, 34.2), Vector3(-4.5, 2.0, 31.8))
	left_post_query.collision_mask = 1
	_check("South Gate left post blocks outside clear corridor", not space_state.intersect_ray(left_post_query).is_empty())

	var right_post_query := PhysicsRayQueryParameters3D.create(Vector3(4.5, 2.0, 34.2), Vector3(4.5, 2.0, 31.8))
	right_post_query.collision_mask = 1
	_check("South Gate right post blocks outside clear corridor", not space_state.intersect_ray(right_post_query).is_empty())

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("current prototype still instantiates", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		var current_smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D
		var current_market := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Market") as Node3D
		var current_gate := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Gate") as Node3D
		_check("current production Smith remains unchanged", current_smith != null and _vec3_equal(current_smith.position, Vector3(-7.4, 0.0, -1.5)), str(current_smith.position) if current_smith != null else "missing")
		_check("current production Market remains unchanged", current_market != null and _vec3_equal(current_market.position, Vector3(7.0, 0.0, 6.0)), str(current_market.position) if current_market != null else "missing")
		_check("current production Gate remains unchanged", current_gate != null and _vec3_equal(current_gate.position, Vector3(0.0, 0.0, -10.0)), str(current_gate.position) if current_gate != null else "missing")
		_check("current production world has no isolated G08 South Gate", prototype.find_child("SouthArrivalGateGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G08_ISOLATED_SOUTH_GATE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G08_ISOLATED_SOUTH_GATE_FAILED")
	print("This gate verifies the locked A01 South Arrival Gate geometry: Gatehouse W, Watch E, exact 8 m gate opening, separate blocking posts, presentation-only open leaves, wall connectors and real ground-level doorways while proving current app-boot settlement placement remains unchanged. Final gate art, stateful closing, perimeter completion, NPC schedules, streaming, persistence, world cutover and device acceptance remain outside G08.")
	quit(0 if failures.is_empty() else 1)
