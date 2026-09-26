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

	_check("G09 Security schema is stable", String(G09.get_schema()) == "pixel_rpg.settlement_01_security_graybox.v1")
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
	var g08: Dictionary = G08.add_south_gate(base_root)
	_check("G08 isolated South Gate still builds", g08.get("gatehouse") != null and g08.get("watch") != null)

	var g09: Dictionary = G09.add_security(base_root)
	var g09_root := g09.get("root") as Node3D
	var barracks := g09.get("barracks") as Node3D
	var canopy := g09.get("canopy") as Node3D
	var racks: Array = g09.get("equipment_racks", [])
	var duty_board := g09.get("duty_board") as Node3D
	var training_target := g09.get("training_target") as Node3D

	_check("G09 Security root is created", g09_root != null and g09_root.name == "GateBarracksSecurityGraybox")
	if g09_root != null:
		_check("G09 root carries S01/A02 ownership",
			String(g09_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(g09_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A02_GATE_BARRACKS_SECURITY"
		)
		_check("G09 root records isolated pass", String(g09_root.get_meta("pixel_rpg_graybox_pass", "")) == "G09")
		_check("G09 final art remains unlocked", not bool(g09_root.get_meta("pixel_rpg_final_art_locked", true)))
		_check("G09 exposes area-level security anchors",
			g09_root.has_node("A02_GuardDutyAnchor")
			and g09_root.has_node("A02_PatrolStartAnchor")
			and g09_root.has_node("A02_BriefingAnchor")
			and g09_root.has_node("A02_EquipmentUseAnchor")
			and g09_root.has_node("A02_GuardIdleAnchor_01")
			and g09_root.has_node("A02_GuardIdleAnchor_02")
			and g09_root.has_node("A02_RoadConnector_A01")
			and g09_root.has_node("A02_RoadConnector_A03")
		)

	_check("Barracks stays at locked center", barracks != null and _vec3_equal(barracks.position, Vector3(-20.0, 0.0, 23.0)), str(barracks.position) if barracks != null else "missing")
	if barracks != null:
		_check("Barracks has stable building identity",
			String(barracks.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_ARRIVAL_GUARD"
			and String(barracks.get_meta("pixel_rpg_section_id", "")) == "SET01_S01"
			and String(barracks.get_meta("pixel_rpg_area_id", "")) == "SET01_A02_GATE_BARRACKS_SECURITY"
		)
		_check("Barracks records 7x6 locked footprint", (g09.get("target_footprint_xz", Vector2.ZERO) as Vector2).is_equal_approx(Vector2(7.0, 6.0)))
		_check("Barracks exposes required duty anchors",
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
			_check("Barracks doorway width remains 1.8 m", absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("Barracks doorway height remains 2.4 m", lintel_bottom >= 2.4 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

		var barracks_east_edge := barracks.position.x + 7.0 * 0.5
		_check("Barracks preserves 4.5 m east-side A02 connector clearance", absf((-12.0) - barracks_east_edge - 4.5) <= 0.001, "clearance=%.3f" % ((-12.0) - barracks_east_edge))

	_check("Briefing canopy is created at locked security-yard position", canopy != null and _vec3_equal(canopy.position, Vector3(-27.0, 0.0, 17.5)), str(canopy.position) if canopy != null else "missing")
	if canopy != null:
		var canopy_colliders := canopy.find_children("*", "StaticBody3D", true, false)
		_check("Briefing canopy collision remains four support posts only", canopy_colliders.size() == 4, "count=%d" % canopy_colliders.size())
		_check("Briefing canopy remains open-sided",
			canopy.get_node_or_null("PerimeterCollision") == null
			and canopy.get_node_or_null("NorthWallCollision") == null
			and canopy.get_node_or_null("SouthWallCollision") == null
			and canopy.get_node_or_null("EastWallCollision") == null
			and canopy.get_node_or_null("WestWallCollision") == null
		)
		_check("Briefing canopy exposes reviewed anchors",
			canopy.has_node("BriefingAnchor")
			and canopy.has_node("GuardIdleAnchor_01")
			and canopy.has_node("GuardIdleAnchor_02")
			and canopy.has_node("TableSocket")
			and canopy.has_node("LanternSocket")
		)

	_check("G09 creates two reusable equipment racks", racks.size() == 2, "count=%d" % racks.size())
	for rack_variant in racks:
		var rack := rack_variant as Node3D
		if rack == null:
			continue
		_check("%s carries reusable rack family ID" % rack.name, String(rack.get_meta("pixel_rpg_equipment_rack_family", "")) == "SET01_PROP_EQUIPMENT_RACK_A")
		_check("%s exposes six display sockets" % rack.name,
			rack.has_node("DisplaySocket_01")
			and rack.has_node("DisplaySocket_02")
			and rack.has_node("DisplaySocket_03")
			and rack.has_node("DisplaySocket_04")
			and rack.has_node("DisplaySocket_05")
			and rack.has_node("DisplaySocket_06")
		)
		_check("%s uses one simple frame collider" % rack.name, rack.get_node_or_null("RackCollision") != null)

	_check("Duty board is presentation/anchor content", duty_board != null and duty_board.has_node("DutyBoardAnchor"))
	_check("Training target uses a simple collider", training_target != null and training_target.get_node_or_null("TargetCollision") != null)

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	if barracks != null:
		var door_query := PhysicsRayQueryParameters3D.create(
			barracks.to_global(Vector3(4.2, 0.9, 0.0)),
			barracks.to_global(Vector3(2.7, 0.9, 0.0))
		)
		door_query.collision_mask = 1
		_check("Barracks physics ray passes through real east doorway", space_state.intersect_ray(door_query).is_empty())

		var wall_query := PhysicsRayQueryParameters3D.create(
			barracks.to_global(Vector3(4.2, 0.9, 2.0)),
			barracks.to_global(Vector3(2.7, 0.9, 2.0))
		)
		wall_query.collision_mask = 1
		_check("Barracks adjacent east wall blocks physics", not space_state.intersect_ray(wall_query).is_empty())

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
		_check("current production world has no isolated G09 Security", prototype.find_child("GateBarracksSecurityGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G09_ISOLATED_SECURITY_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G09_ISOLATED_SECURITY_FAILED")
	print("This gate verifies locked A02 Security geometry: 7x6 barracks at -20,+23, a real east doorway, open-sided 6x4 briefing canopy, equipment rack family, duty/training props and stable security anchors while proving the current app-boot settlement remains unchanged. Final security art, NPC schedules, streaming, persistence, production-world cutover and device acceptance remain outside G09.")
	quit(0 if failures.is_empty() else 1)
