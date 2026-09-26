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
const G11 := preload("res://scripts/world/settlement/settlement_01_hunter_staging_graybox.gd")
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
	print("Pixel RPG Settlement 01 G11 — isolated North Hunter Staging gate")

	_check("G11 Hunter Staging schema is stable", String(G11.get_schema()) == "pixel_rpg.settlement_01_hunter_staging_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G11IsolatedHost"
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
	_check("G10 isolated Logistics still builds", g10.get("storage") != null and g10.get("awning") != null)

	var g11: Dictionary = G11.add_hunter_staging(base_root)
	var g11_root := g11.get("root") as Node3D
	var bounty_board := g11.get("bounty_board") as Node3D
	var prep_racks: Array = g11.get("prep_racks", [])
	var supply_table := g11.get("supply_table") as Node3D
	var supply_cache := g11.get("supply_cache") as Node3D
	var benches: Array = g11.get("benches", [])
	var warning_markers: Array = g11.get("warning_markers", [])

	_check("G11 staging root is created", g11_root != null and g11_root.name == "NorthHunterStagingGraybox")
	if g11_root != null:
		_check("G11 root carries S05/A11 ownership",
			String(g11_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S05"
			and String(g11_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A11_NORTH_HUNTER_STAGING"
		)
		_check("G11 root records isolated pass", String(g11_root.get_meta("pixel_rpg_graybox_pass", "")) == "G11")
		_check("G11 final art remains unlocked", not bool(g11_root.get_meta("pixel_rpg_final_art_locked", true)))
		_check("G11 records exact Main Spine clearance band",
			absf(float(g11_root.get_meta("pixel_rpg_main_spine_min_x", 0.0)) - -4.0) <= 0.001
			and absf(float(g11_root.get_meta("pixel_rpg_main_spine_max_x", 0.0)) - 4.0) <= 0.001
		)
		_check("G11 exposes reviewed hunter anchors",
			g11_root.has_node("A11_BountyBoardAnchor")
			and g11_root.has_node("A11_PrepAnchor_01")
			and g11_root.has_node("A11_PrepAnchor_02")
			and g11_root.has_node("A11_SupplyAnchor")
			and g11_root.has_node("A11_HunterIdle_01")
			and g11_root.has_node("A11_HunterIdle_02")
			and g11_root.has_node("A11_HunterIdle_03")
			and g11_root.has_node("A11_HunterIdle_04")
			and g11_root.has_node("A11_Connector_A10")
			and g11_root.has_node("A11_Connector_A12")
		)

	_check("Bounty board uses stable variant ID", bounty_board != null and String(bounty_board.get_meta("pixel_rpg_prop_id", "")) == "SET01_PROP_BOUNTY_ROUTE_BOARD_A")
	if bounty_board != null:
		_check("Bounty board exposes authored-content interaction anchor", bounty_board.has_node("BoardUseAnchor"))
		var board_colliders := bounty_board.find_children("*", "StaticBody3D", true, false)
		_check("Bounty board collision is limited to two support posts", board_colliders.size() == 2, "count=%d" % board_colliders.size())

	_check("G11 creates two hunter prep rack variants", prep_racks.size() == 2, "count=%d" % prep_racks.size())
	for rack_variant in prep_racks:
		var rack := rack_variant as Node3D
		if rack == null:
			continue
		_check("%s reuses equipment rack family" % rack.name, String(rack.get_meta("pixel_rpg_equipment_rack_family", "")) == "SET01_PROP_EQUIPMENT_RACK_A")
		_check("%s exposes six display sockets and interaction anchor" % rack.name,
			rack.has_node("DisplaySocket_01")
			and rack.has_node("DisplaySocket_02")
			and rack.has_node("DisplaySocket_03")
			and rack.has_node("DisplaySocket_04")
			and rack.has_node("DisplaySocket_05")
			and rack.has_node("DisplaySocket_06")
			and rack.has_node("InteractionAnchor")
		)
		_check("%s uses one simple rack collider" % rack.name, rack.get_node_or_null("RackCollision") != null)

	_check("Hunter supply table uses shared service-table family",
		supply_table != null
		and String(supply_table.get_meta("pixel_rpg_prop_family", "")) == "SET01_PROP_SERVICE_TABLE_A"
		and supply_table.has_node("SupplyUseAnchor")
		and supply_table.has_node("SupplySocket_01")
		and supply_table.has_node("SupplySocket_04")
	)
	_check("Hunter supply cache uses shared crate family",
		supply_cache != null
		and String(supply_cache.get_meta("pixel_rpg_prop_family", "")) == "SET01_PROP_CRATE_A"
		and supply_cache.has_node("CacheUseAnchor")
	)

	_check("G11 creates two staging benches", benches.size() == 2, "count=%d" % benches.size())
	for bench_variant in benches:
		var bench := bench_variant as Node3D
		if bench == null:
			continue
		_check("%s uses shared bench family" % bench.name, String(bench.get_meta("pixel_rpg_prop_family", "")) == "SET01_PROP_BENCH_A")
		_check("%s uses simple bench collision" % bench.name, bench.get_node_or_null("BenchCollision") != null)

	_check("G11 creates two presentation-only warning markers", warning_markers.size() == 2, "count=%d" % warning_markers.size())
	for warning_variant in warning_markers:
		var warning := warning_variant as Node3D
		if warning == null:
			continue
		_check("%s remains presentation-only" % warning.name, warning.find_children("*", "StaticBody3D", true, false).is_empty())

	# Every G11 collider must stay completely outside the central 8 m Main Spine.
	if g11_root != null:
		var colliders := g11_root.find_children("*", "StaticBody3D", true, false)
		for collider_variant in colliders:
			var collider := collider_variant as StaticBody3D
			if collider == null:
				continue
			var bounds_x := _world_bounds_x(collider)
			_check("%s stays outside central Main Spine collision band" % collider.name,
				bounds_x.y <= -4.0 + 0.001 or bounds_x.x >= 4.0 - 0.001,
				"min_x=%.3f max_x=%.3f" % [bounds_x.x, bounds_x.y]
			)

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	var spine_query := PhysicsRayQueryParameters3D.create(Vector3(0.0, 0.90, -14.2), Vector3(0.0, 0.90, -22.8))
	spine_query.collision_mask = 1
	_check("A11 Main Spine route remains physically clear", space_state.intersect_ray(spine_query).is_empty())

	var left_lane_query := PhysicsRayQueryParameters3D.create(Vector3(-3.5, 0.90, -14.2), Vector3(-3.5, 0.90, -22.8))
	left_lane_query.collision_mask = 1
	_check("A11 west half of Main Spine remains physically clear", space_state.intersect_ray(left_lane_query).is_empty())

	var right_lane_query := PhysicsRayQueryParameters3D.create(Vector3(3.5, 0.90, -14.2), Vector3(3.5, 0.90, -22.8))
	right_lane_query.collision_mask = 1
	_check("A11 east half of Main Spine remains physically clear", space_state.intersect_ray(right_lane_query).is_empty())

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
		_check("current production world has no isolated G11 Staging", prototype.find_child("NorthHunterStagingGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G11_ISOLATED_HUNTER_STAGING_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G11_ISOLATED_HUNTER_STAGING_FAILED")
	print("This gate verifies locked A11 Hunter Staging geometry: edge-only bounty/prep/supply/bench content, reviewed anchors and a fully collision-free 8 m Main Spine through X -4..+4 while proving the current app-boot settlement remains unchanged. North Gate structures, final art, NPC schedules, streaming, persistence, production-world cutover and device acceptance remain outside G11.")
	quit(0 if failures.is_empty() else 1)
