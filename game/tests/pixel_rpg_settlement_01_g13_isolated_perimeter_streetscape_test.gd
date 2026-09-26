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
const G12 := preload("res://scripts/world/settlement/settlement_01_north_gate_graybox.gd")
const G13 := preload("res://scripts/world/settlement/settlement_01_perimeter_streetscape_graybox.gd")
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
	return Vector2(body.global_position.x - size.x * 0.5, body.global_position.x + size.x * 0.5)

func _world_bounds_z(body: StaticBody3D) -> Vector2:
	var size := _shape_size(body)
	return Vector2(body.global_position.z - size.z * 0.5, body.global_position.z + size.z * 0.5)

func _run() -> void:
	print("Pixel RPG Settlement 01 G13 — isolated Perimeter + Streetscape integration gate")

	_check("G13 Perimeter/Streetscape schema is stable", String(G13.get_schema()) == "pixel_rpg.settlement_01_perimeter_streetscape_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G13IsolatedHost"
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
	_check("G11 isolated Hunter Staging still builds", g11.get("root") != null)
	var g12: Dictionary = G12.add_north_gate(base_root)
	_check("G12 isolated North Gate still builds", g12.get("watch") != null and g12.get("cache") != null and g12.get("gate") != null)

	var g13: Dictionary = G13.add_perimeter_streetscape(base_root)
	var g13_root := g13.get("root") as Node3D
	var wall_holder := g13.get("wall_holder") as Node3D
	var wall_modules: Array = g13.get("wall_modules", [])
	var benches: Array = g13.get("benches", [])
	var lanterns: Array = g13.get("lanterns", [])
	var wayfinding: Array = g13.get("wayfinding", [])

	_check("G13 root is created", g13_root != null and g13_root.name == "PerimeterStreetscapeGraybox")
	if g13_root != null:
		_check("G13 root uses shared-infrastructure ownership", String(g13_root.get_meta("pixel_rpg_shared_owner", "")) == "SET01_SHARED_INFRASTRUCTURE")
		_check("G13 root records isolated pass", String(g13_root.get_meta("pixel_rpg_graybox_pass", "")) == "G13")
		_check("G13 final art remains unlocked", not bool(g13_root.get_meta("pixel_rpg_final_art_locked", true)))
		_check("G13 records side-wall inner edge outside envelope", absf(float(g13_root.get_meta("pixel_rpg_side_wall_inner_edge_abs_x", 0.0)) - 30.25) <= 0.001)
		_check("G13 exposes route approach anchors",
			g13_root.has_node("G13_SouthGateApproachAnchor")
			and g13_root.has_node("G13_PlazaSouthAnchor")
			and g13_root.has_node("G13_PlazaNorthAnchor")
			and g13_root.has_node("G13_NorthGateApproachAnchor")
		)

	_check("G13 modular perimeter holder exists", wall_holder != null and wall_holder.name == "ModularPerimeter")
	_check("G13 uses exactly 56 independent wall/corner modules", wall_modules.size() == 56, "count=%d" % wall_modules.size())

	for module_variant in wall_modules:
		var module := module_variant as StaticBody3D
		if module == null:
			continue
		var size := _shape_size(module)
		_check("%s has explicit wall-family ownership" % module.name,
			String(module.get_meta("pixel_rpg_wall_family", "")).begins_with("SET01_WALL_")
			and String(module.get_meta("pixel_rpg_shared_owner", "")) == "SET01_SHARED_INFRASTRUCTURE"
		)
		_check("%s remains a bounded modular collider" % module.name,
			size.x <= 4.001 and size.z <= 4.001,
			"size=%s" % str(size)
		)

	# Side perimeter inner edges must sit outside the locked ±30 m envelope.
	var west_modules := wall_holder.find_children("WestWall*", "StaticBody3D", false, false)
	var east_modules := wall_holder.find_children("EastWall*", "StaticBody3D", false, false)
	_check("G13 creates 17 west side modules", west_modules.size() == 17, "count=%d" % west_modules.size())
	_check("G13 creates 17 east side modules", east_modules.size() == 17, "count=%d" % east_modules.size())
	for west_variant in west_modules:
		var west := west_variant as StaticBody3D
		var bounds_x := _world_bounds_x(west)
		_check("%s inner edge stays west of envelope" % west.name, bounds_x.y <= -30.25 + 0.001, "max_x=%.3f" % bounds_x.y)
	for east_variant in east_modules:
		var east := east_variant as StaticBody3D
		var bounds_x := _world_bounds_x(east)
		_check("%s inner edge stays east of envelope" % east.name, bounds_x.x >= 30.25 - 0.001, "min_x=%.3f" % bounds_x.x)

	# Protect G10 edge logistics from the new east perimeter.
	var logistics_root := g10.get("root") as Node3D
	if logistics_root != null:
		var logistics_colliders := logistics_root.find_children("*", "StaticBody3D", true, false)
		var max_logistics_x := -INF
		for collider_variant in logistics_colliders:
			var collider := collider_variant as StaticBody3D
			if collider == null:
				continue
			max_logistics_x = maxf(max_logistics_x, _world_bounds_x(collider).y)
		_check("G13 east perimeter stays outside all G10 logistics collision", max_logistics_x < 30.25, "max_logistics_x=%.3f" % max_logistics_x)

	_check("G13 creates four plaza-perimeter benches", benches.size() == 4, "count=%d" % benches.size())
	for bench_variant in benches:
		var bench := bench_variant as StaticBody3D
		if bench == null:
			continue
		var bounds_x := _world_bounds_x(bench)
		var bounds_z := _world_bounds_z(bench)
		_check("%s stays outside 8 m Main Spine" % bench.name, bounds_x.y <= -4.0 or bounds_x.x >= 4.0, "x=%s" % str(bounds_x))
		_check("%s stays outside 5 m Central Cross Street" % bench.name, bounds_z.y <= -2.5 or bounds_z.x >= 2.5, "z=%s" % str(bounds_z))
		_check("%s uses shared bench family" % bench.name, String(bench.get_meta("pixel_rpg_prop_family", "")) == "SET01_PROP_BENCH_A")

	_check("G13 creates eight presentation-only spine lanterns", lanterns.size() == 8, "count=%d" % lanterns.size())
	for lantern_variant in lanterns:
		var lantern := lantern_variant as Node3D
		if lantern == null:
			continue
		_check("%s owns no collision" % lantern.name, lantern.find_children("*", "StaticBody3D", true, false).is_empty())
		_check("%s is marked presentation-only" % lantern.name, bool(lantern.get_meta("pixel_rpg_presentation_only", false)))

	_check("G13 creates two presentation-only wayfinding markers", wayfinding.size() == 2, "count=%d" % wayfinding.size())
	for sign_variant in wayfinding:
		var sign := sign_variant as Node3D
		if sign == null:
			continue
		_check("%s owns no collision" % sign.name, sign.find_children("*", "StaticBody3D", true, false).is_empty())
		_check("%s exposes a wayfinding anchor" % sign.name, sign.has_node("WayfindingAnchor"))

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	# Entire main route must remain traversable through both gates.
	var spine_query := PhysicsRayQueryParameters3D.create(Vector3(0.0, 0.90, 32.5), Vector3(0.0, 0.90, -34.5))
	spine_query.collision_mask = 1
	_check("G13 preserves full South-to-North Main Spine traversal", space_state.intersect_ray(spine_query).is_empty())

	var cross_query := PhysicsRayQueryParameters3D.create(Vector3(-19.5, 0.90, 0.0), Vector3(19.5, 0.90, 0.0))
	cross_query.collision_mask = 1
	_check("G13 preserves full Central Cross Street traversal", space_state.intersect_ray(cross_query).is_empty())

	var south_gate_query := PhysicsRayQueryParameters3D.create(Vector3(0.0, 0.90, 31.5), Vector3(0.0, 0.90, 34.5))
	south_gate_query.collision_mask = 1
	_check("G13 preserves South Gate center opening", space_state.intersect_ray(south_gate_query).is_empty())

	var north_gate_query := PhysicsRayQueryParameters3D.create(Vector3(0.0, 0.90, -33.5), Vector3(0.0, 0.90, -36.5))
	north_gate_query.collision_mask = 1
	_check("G13 preserves North Gate center opening", space_state.intersect_ray(north_gate_query).is_empty())

	# Perimeter blocks outside gate openings.
	var west_wall_query := PhysicsRayQueryParameters3D.create(Vector3(-29.5, 0.90, 0.0), Vector3(-31.2, 0.90, 0.0))
	west_wall_query.collision_mask = 1
	_check("G13 west perimeter blocks settlement edge", not space_state.intersect_ray(west_wall_query).is_empty())

	var east_wall_query := PhysicsRayQueryParameters3D.create(Vector3(29.5, 0.90, 0.0), Vector3(31.2, 0.90, 0.0))
	east_wall_query.collision_mask = 1
	_check("G13 east perimeter blocks settlement edge", not space_state.intersect_ray(east_wall_query).is_empty())

	var south_wall_query := PhysicsRayQueryParameters3D.create(Vector3(20.0, 0.90, 32.0), Vector3(20.0, 0.90, 34.0))
	south_wall_query.collision_mask = 1
	_check("G13 south perimeter blocks outside gate complex", not space_state.intersect_ray(south_wall_query).is_empty())

	var north_wall_query := PhysicsRayQueryParameters3D.create(Vector3(20.0, 0.90, -34.0), Vector3(20.0, 0.90, -36.0))
	north_wall_query.collision_mask = 1
	_check("G13 north perimeter blocks outside North Gate", not space_state.intersect_ray(north_wall_query).is_empty())

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
		_check("current production world has no isolated G13 perimeter", prototype.find_child("PerimeterStreetscapeGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G13_ISOLATED_PERIMETER_STREETSCAPE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G13_ISOLATED_PERIMETER_STREETSCAPE_FAILED")
	print("This gate verifies modular perimeter ownership and sparse streetscape integration after G01-G12: 56 bounded wall/corner modules, side collision outside the ±30 m envelope, unobstructed Main Spine/Central Cross/South Gate/North Gate routes, controlled plaza benches and presentation-only lantern/signage while proving the current app-boot settlement remains unchanged. Final perimeter art, NPC schedules, minimap, streaming, persistence, production-world cutover and device acceptance remain outside G13.")
	quit(0 if failures.is_empty() else 1)
