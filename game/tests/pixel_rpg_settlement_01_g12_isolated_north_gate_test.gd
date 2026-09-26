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

func _verify_south_door(building: Node3D, half_z: float, label: String, space_state: PhysicsDirectSpaceState3D) -> void:
	_check("%s exists" % label, building != null)
	if building == null:
		return

	_check("%s exposes real entrance/exit/interior anchors" % label,
		building.has_node("EntranceAnchor")
		and building.has_node("ExitAnchor")
		and building.has_node("InteriorCenterAnchor")
		and building.has_node("RoofVisibilityGroup")
	)
	_check("%s uses segmented south facade collision" % label,
		building.has_node("Collision/SouthLeftCollision")
		and building.has_node("Collision/SouthRightCollision")
		and building.has_node("Collision/SouthLintelCollision")
	)
	_check("%s has no monolithic sealed collider" % label,
		building.get_node_or_null("BuildingCollision") == null
		and building.get_node_or_null("WatchCollision") == null
		and building.get_node_or_null("CacheCollision") == null
	)

	var left := building.get_node_or_null("Collision/SouthLeftCollision") as StaticBody3D
	var right := building.get_node_or_null("Collision/SouthRightCollision") as StaticBody3D
	var lintel := building.get_node_or_null("Collision/SouthLintelCollision") as StaticBody3D
	if left != null and right != null and lintel != null:
		var left_size := _shape_size(left)
		var right_size := _shape_size(right)
		var lintel_size := _shape_size(lintel)
		var left_inner_x := left.position.x + left_size.x * 0.5
		var right_inner_x := right.position.x - right_size.x * 0.5
		var doorway_gap := right_inner_x - left_inner_x
		var lintel_bottom := lintel.position.y - lintel_size.y * 0.5
		_check("%s doorway width remains 1.8 m" % label, absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
		_check("%s doorway height remains 2.4 m" % label, lintel_bottom >= 2.4 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

	var door_query := PhysicsRayQueryParameters3D.create(
		building.to_global(Vector3(0.0, 0.90, half_z + 0.7)),
		building.to_global(Vector3(0.0, 0.90, half_z - 0.7))
	)
	door_query.collision_mask = 1
	_check("%s physics ray passes through real south doorway" % label, space_state.intersect_ray(door_query).is_empty())

	var wall_query := PhysicsRayQueryParameters3D.create(
		building.to_global(Vector3(2.0, 0.90, half_z + 0.7)),
		building.to_global(Vector3(2.0, 0.90, half_z - 0.7))
	)
	wall_query.collision_mask = 1
	_check("%s adjacent south wall blocks physics" % label, not space_state.intersect_ray(wall_query).is_empty())

func _run() -> void:
	print("Pixel RPG Settlement 01 G12 — isolated North Watch Gate & Trail Exit gate")

	_check("G12 North Gate schema is stable", String(G12.get_schema()) == "pixel_rpg.settlement_01_north_gate_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G12IsolatedHost"
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
	var g12_root := g12.get("root") as Node3D
	var watch := g12.get("watch") as Node3D
	var cache := g12.get("cache") as Node3D
	var gate := g12.get("gate") as Node3D
	var trail := g12.get("trail_transition") as Node3D

	_check("G12 root is created", g12_root != null and g12_root.name == "NorthWatchGateTrailExitGraybox")
	if g12_root != null:
		_check("G12 root carries S05/A12 ownership",
			String(g12_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S05"
			and String(g12_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT"
		)
		_check("G12 root records isolated pass", String(g12_root.get_meta("pixel_rpg_graybox_pass", "")) == "G12")
		_check("G12 final art remains unlocked", not bool(g12_root.get_meta("pixel_rpg_final_art_locked", true)))
		_check("G12 root records exact 8 m gate width", absf(float(g12_root.get_meta("pixel_rpg_gate_clear_width_m", 0.0)) - 8.0) <= 0.001)
		_check("G12 exposes reviewed area anchors",
			g12_root.has_node("A12_NorthGateCenterAnchor")
			and g12_root.has_node("A12_WardenAnchor")
			and g12_root.has_node("A12_WatchAnchor")
			and g12_root.has_node("A12_WarningAnchor")
			and g12_root.has_node("A12_TrailConnectorAnchor")
			and g12_root.has_node("A12_ReturnAnchor")
			and g12_root.has_node("A12_Connector_A11")
		)
		var trail_anchor := g12_root.get_node("A12_TrailConnectorAnchor") as Marker3D
		var return_anchor := g12_root.get_node("A12_ReturnAnchor") as Marker3D
		var a11_anchor := g12_root.get_node("A12_Connector_A11") as Marker3D
		_check("G12 trail connector stays north/outside gate", _vec3_equal(trail_anchor.position, Vector3(0.0, 0.90, -38.5)))
		_check("G12 safe return anchor stays settlement-side", _vec3_equal(return_anchor.position, Vector3(0.0, 0.90, -31.8)))
		_check("G12 A11 connector stays on south edge", _vec3_equal(a11_anchor.position, Vector3(0.0, 0.90, -23.3)))

	_check("Hunter Watch stays at locked center", watch != null and _vec3_equal(watch.position, Vector3(-19.0, 0.0, -27.0)), str(watch.position) if watch != null else "missing")
	if watch != null:
		_check("Hunter Watch has stable identity and 7x7 footprint",
			String(watch.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_HUNTER_WATCH"
			and String(watch.get_meta("pixel_rpg_section_id", "")) == "SET01_S05"
			and String(watch.get_meta("pixel_rpg_area_id", "")) == "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT"
			and (watch.get_meta("pixel_rpg_footprint_xz", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(7.0, 7.0))
		)
		_check("Hunter Watch exposes reviewed service anchors",
			watch.has_node("WardenWorkAnchor")
			and watch.has_node("LookoutAnchor")
			and watch.has_node("BountyBoardAnchor")
			and watch.has_node("PrepAnchor")
			and watch.has_node("ReturnContextAnchor")
		)

	_check("Supply Cache stays at locked center", cache != null and _vec3_equal(cache.position, Vector3(19.0, 0.0, -27.0)), str(cache.position) if cache != null else "missing")
	if cache != null:
		_check("Supply Cache has stable identity and 7x6 footprint",
			String(cache.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_SUPPLY_CACHE"
			and String(cache.get_meta("pixel_rpg_section_id", "")) == "SET01_S05"
			and String(cache.get_meta("pixel_rpg_area_id", "")) == "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT"
			and (cache.get_meta("pixel_rpg_footprint_xz", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(7.0, 6.0))
		)
		_check("Supply Cache exposes reviewed service anchors",
			cache.has_node("SupplyUseAnchor")
			and cache.has_node("QuartermasterAnchor")
			and cache.has_node("EmergencyCacheAnchor")
			and cache.has_node("RackSocket_01")
			and cache.has_node("RackSocket_04")
		)

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	_verify_south_door(watch, 3.5, "Hunter Watch", space_state)
	_verify_south_door(cache, 3.0, "Supply Cache", space_state)

	_check("North Gate is created at locked center", gate != null and _vec3_equal(gate.position, Vector3(0.0, 0.0, -35.0)), str(gate.position) if gate != null else "missing")
	if gate != null:
		_check("North Gate uses stable identity/open state",
			String(gate.get_meta("pixel_rpg_gate_id", "")) == "SET01_NORTH_GATE"
			and String(gate.get_meta("pixel_rpg_gate_state", "")) == "OPEN_GRAYBOX"
			and absf(float(gate.get_meta("pixel_rpg_clear_width_m", 0.0)) - 8.0) <= 0.001
		)
		_check("North Gate exposes center/inner/outer anchors",
			gate.has_node("GateCenterAnchor")
			and gate.has_node("GateInnerAnchor")
			and gate.has_node("GateOuterAnchor")
		)
		_check("Open gate leaves remain presentation-only",
			gate.find_children("GateLeaf*", "StaticBody3D", true, false).is_empty()
		)

		var left_post := gate.get_node_or_null("GatePostLCollision") as StaticBody3D
		var right_post := gate.get_node_or_null("GatePostRCollision") as StaticBody3D
		_check("North Gate side-post colliders exist", left_post != null and right_post != null)
		if left_post != null and right_post != null:
			var left_size := _shape_size(left_post)
			var right_size := _shape_size(right_post)
			var left_inner_edge := left_post.position.x + left_size.x * 0.5
			var right_inner_edge := right_post.position.x - right_size.x * 0.5
			_check("North Gate left post inner edge stays at X -4", absf(left_inner_edge - -4.0) <= 0.001, "edge=%.3f" % left_inner_edge)
			_check("North Gate right post inner edge stays at X +4", absf(right_inner_edge - 4.0) <= 0.001, "edge=%.3f" % right_inner_edge)
			_check("North Gate clear physical opening remains exactly 8 m", absf((right_inner_edge - left_inner_edge) - 8.0) <= 0.001)

		var gate_colliders := gate.find_children("*", "StaticBody3D", true, false)
		for collider_variant in gate_colliders:
			var collider := collider_variant as StaticBody3D
			if collider == null:
				continue
			var size := _shape_size(collider)
			var min_x := gate.position.x + collider.position.x - size.x * 0.5
			var max_x := gate.position.x + collider.position.x + size.x * 0.5
			_check("%s stays outside open X -4..+4 passage" % collider.name,
				max_x <= -4.0 + 0.001 or min_x >= 4.0 - 0.001,
				"min_x=%.3f max_x=%.3f" % [min_x, max_x]
			)

	_check("Trail transition is created north of settlement", trail != null and _vec3_equal(trail.position, Vector3(0.0, 0.0, -40.0)), str(trail.position) if trail != null else "missing")
	if trail != null:
		_check("Trail transition is presentation-only with Ground collision owner",
			bool(trail.get_meta("pixel_rpg_presentation_only", false))
			and String(trail.get_meta("pixel_rpg_collision_owner", "")) == "GROUND"
		)
		_check("Trail transition owns no StaticBody collision", trail.find_children("*", "StaticBody3D", true, false).is_empty())
		_check("Trail center visual exists", trail.has_node("TrailSurfaceVisual"))

	var gate_center_query := PhysicsRayQueryParameters3D.create(Vector3(0.0, 0.90, -33.5), Vector3(0.0, 0.90, -36.5))
	gate_center_query.collision_mask = 1
	_check("North Gate center passage remains physically clear", space_state.intersect_ray(gate_center_query).is_empty())

	var gate_left_lane_query := PhysicsRayQueryParameters3D.create(Vector3(-3.5, 0.90, -33.5), Vector3(-3.5, 0.90, -36.5))
	gate_left_lane_query.collision_mask = 1
	_check("North Gate west side of 8 m opening remains clear", space_state.intersect_ray(gate_left_lane_query).is_empty())

	var gate_right_lane_query := PhysicsRayQueryParameters3D.create(Vector3(3.5, 0.90, -33.5), Vector3(3.5, 0.90, -36.5))
	gate_right_lane_query.collision_mask = 1
	_check("North Gate east side of 8 m opening remains clear", space_state.intersect_ray(gate_right_lane_query).is_empty())

	var left_post_query := PhysicsRayQueryParameters3D.create(Vector3(-5.0, 0.90, -33.5), Vector3(-5.0, 0.90, -36.5))
	left_post_query.collision_mask = 1
	_check("North Gate left post blocks outside the opening", not space_state.intersect_ray(left_post_query).is_empty())

	var right_post_query := PhysicsRayQueryParameters3D.create(Vector3(5.0, 0.90, -33.5), Vector3(5.0, 0.90, -36.5))
	right_post_query.collision_mask = 1
	_check("North Gate right post blocks outside the opening", not space_state.intersect_ray(right_post_query).is_empty())

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
		_check("current production world has no isolated G12 North Gate", prototype.find_child("NorthWatchGateTrailExitGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G12_ISOLATED_NORTH_GATE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G12_ISOLATED_NORTH_GATE_FAILED")
	print("This gate verifies locked A12 geometry: Hunter Watch at -19,-27, Supply Cache at +19,-27, real south-facing doorways, an exact 8 m open North Gate at 0,-35, presentation-only trail transition northward and reviewed Warden/return/trail anchors while proving the current app-boot settlement remains unchanged. Final art, NPC schedules, perimeter integration, streaming, persistence, production-world cutover and device acceptance remain outside G12.")
	quit(0 if failures.is_empty() else 1)
