extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
const G05 := preload("res://scripts/world/settlement/settlement_01_residential_graybox.gd")
const G06 := preload("res://scripts/world/settlement/settlement_01_work_support_graybox.gd")
const G07 := preload("res://scripts/world/settlement/settlement_01_worker_passage_graybox.gd")
const G08 := preload("res://scripts/world/settlement/settlement_01_south_gate_graybox.gd")
const G09 := preload("res://scripts/world/settlement/settlement_01_security_graybox.gd")
const G10 := preload("res://scripts/world/settlement/settlement_01_logistics_graybox.gd")
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

func _world_bounds_x(body: StaticBody3D) -> Vector2:
	var size := _shape_size(body)
	var center_x := body.global_position.x
	return Vector2(center_x - size.x * 0.5, center_x + size.x * 0.5)

func _run() -> void:
	print("Pixel RPG Settlement 01 G10 — isolated Caravan / Visitor Logistics gate")

	_check("G10 Logistics schema is stable", String(G10.get_schema()) == "pixel_rpg.settlement_01_logistics_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G10IsolatedHost"
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
	_check("G08 isolated South Gate still builds", g08.get("gatehouse") != null and g08.get("watch") != null)
	var g09: Dictionary = G09.add_security(base_root)
	_check("G09 isolated Security still builds", g09.get("barracks") != null and g09.get("canopy") != null)

	var g10: Dictionary = G10.add_logistics(base_root)
	var g10_root := g10.get("root") as Node3D
	var storage := g10.get("storage") as Node3D
	var awning := g10.get("awning") as Node3D
	var carts: Array = g10.get("carts", [])
	var hitching := g10.get("hitching") as Node3D
	var trough := g10.get("trough") as Node3D
	var bench := g10.get("bench") as Node3D
	var wayfinding := g10.get("wayfinding") as Node3D

	_check("G10 Logistics root is created", g10_root != null and g10_root.name == "CaravanVisitorLogisticsGraybox")
	if g10_root != null:
		_check("G10 root carries S01/A03 ownership",
			String(g10_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(g10_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A03_CARAVAN_VISITOR_STAGING"
		)
		_check("G10 root records isolated pass", String(g10_root.get_meta("pixel_rpg_graybox_pass", "")) == "G10")
		_check("G10 final art remains unlocked", not bool(g10_root.get_meta("pixel_rpg_final_art_locked", true)))
		_check("G10 exposes area-level logistics anchors",
			g10_root.has_node("A03_RoadConnector_A02")
			and g10_root.has_node("A03_RoadConnector_A04")
			and g10_root.has_node("A03_CartAnchor_01")
			and g10_root.has_node("A03_CartAnchor_02")
			and g10_root.has_node("A03_LoadingAnchor")
			and g10_root.has_node("A03_WaterAnchor")
			and g10_root.has_node("A03_VisitorIdleAnchor_01")
			and g10_root.has_node("A03_VisitorIdleAnchor_02")
			and g10_root.has_node("A03_WayfindingAnchor")
		)

	_check("Arrival Storage stays at locked center", storage != null and _vec3_equal(storage.position, Vector3(20.0, 0.0, 23.0)), str(storage.position) if storage != null else "missing")
	if storage != null:
		_check("Arrival Storage has stable building identity",
			String(storage.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_ARRIVAL_STORAGE"
			and String(storage.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(storage.get_meta("pixel_rpg_area_id", "")) == "SET01_A03_CARAVAN_VISITOR_STAGING"
		)
		_check("Arrival Storage records 7x6 locked footprint", (g10.get("target_footprint_xz", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(7.0, 6.0)))
		_check("Arrival Storage exposes required logistics anchors",
			storage.has_node("EntranceAnchor")
			and storage.has_node("ExitAnchor")
			and storage.has_node("StorageUseAnchor")
			and storage.has_node("ClerkAnchor")
			and storage.has_node("LoadingAnchor")
			and storage.has_node("InteriorCenterAnchor")
			and storage.has_node("RackSocket_01")
			and storage.has_node("RackSocket_04")
			and storage.has_node("RoofVisibilityGroup")
		)
		_check("Arrival Storage west facade collision is segmented",
			storage.has_node("Collision/WestNorthCollision")
			and storage.has_node("Collision/WestSouthCollision")
			and storage.has_node("Collision/WestLintelCollision")
		)
		_check("Arrival Storage has no monolithic sealed collider", storage.get_node_or_null("StorageCollision") == null)

		var west_north := storage.get_node_or_null("Collision/WestNorthCollision") as StaticBody3D
		var west_south := storage.get_node_or_null("Collision/WestSouthCollision") as StaticBody3D
		var west_lintel := storage.get_node_or_null("Collision/WestLintelCollision") as StaticBody3D
		if west_north != null and west_south != null and west_lintel != null:
			var north_size := _shape_size(west_north)
			var south_size := _shape_size(west_south)
			var lintel_size := _shape_size(west_lintel)
			var north_inner_z := west_north.position.z + north_size.z * 0.5
			var south_inner_z := west_south.position.z - south_size.z * 0.5
			var doorway_gap := south_inner_z - north_inner_z
			var lintel_bottom := west_lintel.position.y - lintel_size.y * 0.5
			_check("Arrival Storage doorway width remains 1.8 m", absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("Arrival Storage doorway height remains 2.3 m", lintel_bottom >= 2.3 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

		var storage_west_edge := storage.position.x - 7.0 * 0.5
		_check("Arrival Storage preserves 4.5 m west-side connector clearance", absf(storage_west_edge - 12.0 - 4.5) <= 0.001, "clearance=%.3f" % (storage_west_edge - 12.0))

	_check("Logistics awning stays in east/south yard pocket", awning != null and _vec3_equal(awning.position, Vector3(27.0, 0.0, 17.5)), str(awning.position) if awning != null else "missing")
	if awning != null:
		var awning_colliders := awning.find_children("*", "StaticBody3D", true, false)
		_check("Logistics awning collision remains four support posts only", awning_colliders.size() == 4, "count=%d" % awning_colliders.size())
		_check("Logistics awning remains open-sided",
			awning.get_node_or_null("PerimeterCollision") == null
			and awning.get_node_or_null("NorthWallCollision") == null
			and awning.get_node_or_null("SouthWallCollision") == null
			and awning.get_node_or_null("EastWallCollision") == null
			and awning.get_node_or_null("WestWallCollision") == null
		)
		_check("Logistics awning exposes reviewed anchors",
			awning.has_node("LoadingAnchor")
			and awning.has_node("ClerkAnchor")
			and awning.has_node("CargoSocket_01")
			and awning.has_node("CargoSocket_06")
			and awning.has_node("LanternSocket")
		)

	_check("G10 creates two reusable cargo carts", carts.size() == 2, "count=%d" % carts.size())
	for cart_variant in carts:
		var cart := cart_variant as Node3D
		if cart == null:
			continue
		_check("%s carries reusable cart family ID" % cart.name, String(cart.get_meta("pixel_rpg_cart_family", "")) == "SET01_PROP_CARGO_CART_A")
		_check("%s exposes four load sockets" % cart.name,
			cart.has_node("LoadSocket_01")
			and cart.has_node("LoadSocket_02")
			and cart.has_node("LoadSocket_03")
			and cart.has_node("LoadSocket_04")
			and cart.has_node("TowAnchor")
			and cart.has_node("ParkAnchor")
		)
		_check("%s uses one simple chassis collider" % cart.name, cart.get_node_or_null("CartCollision") != null)

	_check("Hitching rail uses reviewed prop family", hitching != null and String(hitching.get_meta("pixel_rpg_prop_family", "")) == "SET01_PROP_HITCHING_RAIL_A")
	_check("Water trough uses stable prop identity", trough != null and String(trough.get_meta("pixel_rpg_prop_id", "")) == "SET01_PROP_WATER_TROUGH_A" and trough.has_node("WaterUseAnchor"))
	_check("Visitor bench uses shared bench family", bench != null and String(bench.get_meta("pixel_rpg_prop_family", "")) == "SET01_PROP_BENCH_A")
	_check("Wayfinding remains presentation-only", wayfinding != null and wayfinding.find_children("*", "StaticBody3D", true, false).is_empty())

	# All permanent G10 collision must remain east of the protected A03 connector strip X 12..16.5.
	if g10_root != null:
		var colliders := g10_root.find_children("*", "StaticBody3D", true, false)
		for collider_variant in colliders:
			var collider := collider_variant as StaticBody3D
			if collider == null:
				continue
			var bounds_x := _world_bounds_x(collider)
			_check("%s stays out of protected A03 west connector strip" % collider.name, bounds_x.x >= 16.5 - 0.001, "min_x=%.3f" % bounds_x.x)

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	if storage != null:
		var door_query := PhysicsRayQueryParameters3D.create(
			storage.to_global(Vector3(-4.2, 0.9, 0.0)),
			storage.to_global(Vector3(-2.7, 0.9, 0.0))
		)
		door_query.collision_mask = 1
		_check("Arrival Storage physics ray passes through real west doorway", space_state.intersect_ray(door_query).is_empty())

		var wall_query := PhysicsRayQueryParameters3D.create(
			storage.to_global(Vector3(-4.2, 0.9, 2.0)),
			storage.to_global(Vector3(-2.7, 0.9, 2.0))
		)
		wall_query.collision_mask = 1
		_check("Arrival Storage adjacent west wall blocks physics", not space_state.intersect_ray(wall_query).is_empty())

	var connector_query := PhysicsRayQueryParameters3D.create(Vector3(14.0, 0.90, 28.5), Vector3(14.0, 0.90, 14.2))
	connector_query.collision_mask = 1
	_check("A03 west connector strip remains physically clear", space_state.intersect_ray(connector_query).is_empty())

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
		_check("current production world has no isolated G10 Logistics", prototype.find_child("CaravanVisitorLogisticsGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G10_ISOLATED_LOGISTICS_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G10_ISOLATED_LOGISTICS_FAILED")
	print("This gate verifies locked A03 visitor-logistics geometry: 7x6 Arrival Storage at +20,+23, a real west doorway, open-sided 6x5 logistics awning, cargo-cart family, hitching/water/bench/wayfinding props, stable logistics anchors and a clear 4.5 m west connector strip while proving the current app-boot settlement remains unchanged. Final logistics art, NPC schedules, streaming, persistence, production-world cutover and device acceptance remain outside G10.")
	quit(0 if failures.is_empty() else 1)
