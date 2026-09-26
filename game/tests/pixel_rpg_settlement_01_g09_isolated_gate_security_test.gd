extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
const G05 := preload("res://scripts/world/settlement/settlement_01_residential_graybox.gd")
const G06 := preload("res://scripts/world/settlement/settlement_01_work_support_graybox.gd")
const G07 := preload("res://scripts/world/settlement/settlement_01_worker_passage_graybox.gd")
const G08 := preload("res://scripts/world/settlement/settlement_01_south_gate_graybox.gd")
const G09 := preload("res://scripts/world/settlement/settlement_01_gate_security_graybox.gd")
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
	print("Pixel RPG Settlement 01 G09 — isolated Gate Barracks & Security gate")

	_check("G09 gate-security schema is stable", String(G09.get_schema()) == "pixel_rpg.settlement_01_gate_security_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G09IsolatedHost"
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
	_check("G08 isolated South Gate still builds", G08.add_south_gate(base_root).get("root") != null)

	var g09: Dictionary = G09.add_gate_security(base_root)
	var g09_root := g09.get("root") as Node3D
	var barracks := g09.get("barracks") as Node3D
	var canopy := g09.get("canopy") as Node3D
	var rack_group := g09.get("rack_group") as Node3D
	var duty_board := g09.get("duty_board") as MeshInstance3D
	var training_target := g09.get("training_target") as StaticBody3D
	var bench := g09.get("bench") as StaticBody3D
	var anchors: Array = g09.get("anchors", [])

	_check("G09 root is created", g09_root != null and g09_root.name == "GateBarracksSecurityGraybox")
	if g09_root != null:
		_check("G09 root carries S01/A02 ownership",
			String(g09_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(g09_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A02_GATE_BARRACKS_SECURITY"
		)
		_check("G09 records isolated pass", String(g09_root.get_meta("pixel_rpg_graybox_pass", "")) == "G09")
		_check("G09 final art remains unlocked", not bool(g09_root.get_meta("pixel_rpg_final_art_locked", true)))

	_check("Barracks exists at locked center", barracks != null and _vec3_equal(barracks.position, Vector3(-20.0, 0.0, 23.0)), str(barracks.position) if barracks != null else "missing")
	if barracks != null:
		_check("Barracks stable identity is preserved",
			String(barracks.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_ARRIVAL_GUARD"
			and String(barracks.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(barracks.get_meta("pixel_rpg_area_id", "")) == "SET01_A02_GATE_BARRACKS_SECURITY"
		)
		_check("Barracks final art remains unlocked", not bool(barracks.get_meta("pixel_rpg_final_art_locked", true)))
		_check("Barracks exposes model-sheet anchors",
			barracks.has_node("EntranceAnchor")
			and barracks.has_node("ExitAnchor")
			and barracks.has_node("GuardDutyAnchor")
			and barracks.has_node("PatrolStartAnchor")
			and barracks.has_node("EquipmentStorageAnchor")
			and barracks.has_node("GuardIdleAnchor")
			and barracks.has_node("InteriorCenterAnchor")
			and barracks.has_node("RoofVisibilityGroup")
		)
		_check("Barracks east facade collision is segmented",
			barracks.has_node("Collision/EastNorthCollision")
			and barracks.has_node("Collision/EastSouthCollision")
			and barracks.has_node("Collision/EastLintelCollision")
		)
		_check("Barracks has no monolithic sealed collider", barracks.get_node_or_null("BarracksCollision") == null)

		var east_north := barracks.get_node_or_null("Collision/EastNorthCollision") as StaticBody3D
		var east_south := barracks.get_node_or_null("Collision/EastSouthCollision") as StaticBody3D
		var east_lintel := barracks.get_node_or_null("Collision/EastLintelCollision") as StaticBody3D
		if east_north != null and east_south != null and east_lintel != null:
			var north_size := _shape_size(east_north)
			var south_size := _shape_size(east_south)
			var lintel_size := _shape_size(east_lintel)
			var north_inner_z := east_north.position.z + north_size.z * 0.5
			var south_inner_z := east_south.position.z - south_size.z * 0.5
			var doorway_gap := south_inner_z - north_inner_z
			var lintel_bottom := east_lintel.position.y - lintel_size.y * 0.5
			_check("Barracks doorway remains 1.8 m wide", absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("Barracks doorway remains at least 2.3 m high", lintel_bottom >= 2.3 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

	var building_spec := (LAYOUT.get_building_specs()["SET01_BLD_ARRIVAL_GUARD"] as Dictionary)
	var footprint: Vector2 = building_spec.get("footprint_xz", Vector2.ZERO)
	_check("Barracks footprint remains exactly 7x6 m", footprint.is_equal_approx(Vector2(7.0, 6.0)), str(footprint))

	_check("Briefing canopy exists at authored Area 02 location", canopy != null and _vec3_equal(canopy.position, Vector3(-27.0, 0.0, 17.5)), str(canopy.position) if canopy != null else "missing")
	if canopy != null:
		_check("Canopy carries S01/A02 ownership",
			String(canopy.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(canopy.get_meta("pixel_rpg_area_id", "")) == "SET01_A02_GATE_BARRACKS_SECURITY"
		)
		_check("Canopy is open-sided with no wall collision nodes",
			canopy.get_node_or_null("Collision/WestWallCollision") == null
			and canopy.get_node_or_null("Collision/EastWallCollision") == null
			and canopy.get_node_or_null("Collision/NorthWallCollision") == null
			and canopy.get_node_or_null("Collision/SouthWallCollision") == null
		)
		_check("Canopy has exactly four structural post colliders",
			canopy.has_node("Collision/PostCollision01")
			and canopy.has_node("Collision/PostCollision02")
			and canopy.has_node("Collision/PostCollision03")
			and canopy.has_node("Collision/PostCollision04")
		)
		_check("Canopy exposes briefing anchors",
			canopy.has_node("BriefingAnchor")
			and canopy.has_node("GuardIdleAnchor_01")
			and canopy.has_node("GuardIdleAnchor_02")
			and canopy.has_node("TableSocket")
			and canopy.has_node("LanternSocket")
		)

	_check("Equipment rack group exists", rack_group != null)
	if rack_group != null:
		_check("Polearm and shield rack frames exist",
			rack_group.has_node("PolearmRack")
			and rack_group.has_node("ShieldRack")
		)
		for rack_name in ["PolearmRack", "ShieldRack"]:
			var rack := rack_group.get_node_or_null(rack_name) as StaticBody3D
			_check("%s uses simple frame collision" % rack_name, rack != null and _shape_size(rack).x <= 2.2 and _shape_size(rack).z <= 0.6)
			_check("%s display remains presentation-only" % rack_name, rack != null and rack.has_node("DisplayPresentation"))

	_check("Duty board exists as presentation-first prop", duty_board != null and String(duty_board.get_meta("pixel_rpg_collision_class", "")) == "NONE")
	_check("Training target has simple collision", training_target != null and _shape_size(training_target).x <= 0.6)
	_check("Security bench has simple collision", bench != null and _shape_size(bench).x <= 2.2)

	_check("Area 02 stable anchor set exists", anchors.size() == 8, "count=%d" % anchors.size())
	if g09_root != null:
		_check("Area 02 exposes duty/patrol/briefing/equipment anchors",
			g09_root.has_node("A02_GuardDutyAnchor")
			and g09_root.has_node("A02_PatrolStartAnchor")
			and g09_root.has_node("A02_BriefingAnchor")
			and g09_root.has_node("A02_EquipmentUseAnchor")
		)
		_check("Area 02 exposes connector anchors",
			g09_root.has_node("A02_RoadConnector_A01")
			and g09_root.has_node("A02_RoadConnector_A03")
		)

	# Geometry-level clearance checks before physics.
	if barracks != null:
		var barracks_east_edge := barracks.position.x + 7.0 * 0.5
		_check("Barracks leaves at least 0.5 m before east connector strip", -16.0 - barracks_east_edge >= 0.5 - 0.001, "gap=%.3f" % (-16.0 - barracks_east_edge))

	if canopy != null:
		var canopy_east_edge := canopy.position.x + 6.0 * 0.5
		var canopy_north_edge := canopy.position.z - 4.0 * 0.5
		_check("Canopy stays west of north connector strip", canopy_east_edge <= -24.0 + 0.001, "edge=%.3f" % canopy_east_edge)
		_check("Canopy stays south of Area 02 north boundary", canopy_north_edge >= 14.0 - 0.001, "edge=%.3f" % canopy_north_edge)

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	if barracks != null:
		var door_query := PhysicsRayQueryParameters3D.create(
			barracks.to_global(Vector3(4.3, 0.9, 0.0)),
			barracks.to_global(Vector3(2.7, 0.9, 0.0))
		)
		door_query.collision_mask = 1
		_check("Barracks physics ray passes through east doorway", space_state.intersect_ray(door_query).is_empty())

		var wall_query := PhysicsRayQueryParameters3D.create(
			barracks.to_global(Vector3(4.3, 0.9, 2.0)),
			barracks.to_global(Vector3(2.7, 0.9, 2.0))
		)
		wall_query.collision_mask = 1
		_check("Barracks adjacent east wall blocks physics", not space_state.intersect_ray(wall_query).is_empty())

	if canopy != null:
		var canopy_open_query := PhysicsRayQueryParameters3D.create(
			canopy.to_global(Vector3(-3.4, 0.9, 1.05)),
			canopy.to_global(Vector3(3.4, 0.9, 1.05))
		)
		canopy_open_query.collision_mask = 1
		_check("Briefing canopy remains traversable west-to-east", space_state.intersect_ray(canopy_open_query).is_empty())

	var east_route_query := PhysicsRayQueryParameters3D.create(
		Vector3(-14.0, 0.9, 14.2),
		Vector3(-14.0, 0.9, 28.8)
	)
	east_route_query.collision_mask = 1
	_check("Area 02 east-side route remains physically clear", space_state.intersect_ray(east_route_query).is_empty())

	var north_route_query := PhysicsRayQueryParameters3D.create(
		Vector3(-23.8, 0.9, 15.0),
		Vector3(-16.2, 0.9, 15.0)
	)
	north_route_query.collision_mask = 1
	_check("Area 02 north connector strip remains physically clear", space_state.intersect_ray(north_route_query).is_empty())

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
		_check("current production world has no isolated G09 security yard", prototype.find_child("GateBarracksSecurityGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G09_ISOLATED_GATE_SECURITY_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G09_ISOLATED_GATE_SECURITY_FAILED")
	print("This gate verifies the locked A02 Barracks parcel, real east doorway, open briefing canopy, equipment/duty/training props, stable security anchors, east/north connector clearances and unchanged current app-boot settlement placement. Final security art, authored signage, NPC schedules, streaming, persistence, world cutover and device acceptance remain outside G09.")
	quit(0 if failures.is_empty() else 1)
