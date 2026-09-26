extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
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
	var collision := body.get_node_or_null("Shape") as CollisionShape3D
	if collision == null or not (collision.shape is BoxShape3D):
		return Vector3.ZERO
	return (collision.shape as BoxShape3D).size

func _run() -> void:
	print("Pixel RPG Settlement 01 G04 — isolated Community Hall gate")

	_check("G04 Community Hall schema is stable", String(G04.get_schema()) == "pixel_rpg.settlement_01_community_hall_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G04IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base still builds", base_root != null)

	var g02: Dictionary = G02.add_plaza(base_root)
	_check("G02 isolated plaza still builds", g02.get("root") != null)

	var g03: Dictionary = G03.add_smith(base_root)
	_check("G03 isolated Smith still builds", g03.get("smith") != null)

	var g04: Dictionary = G04.add_community_hall(base_root)
	var g04_root := g04.get("root") as Node3D
	var hall := g04.get("hall") as Node3D

	_check("G04 civic-core root is created", g04_root != null and g04_root.name == "CommunityHallCivicCoreGraybox")
	_check("G04 Community Hall is created", hall != null and hall.name == "Settlement01CommunityHall")

	if hall != null:
		_check("Community Hall center is locked at -24.5,0,0", _vec3_equal(hall.position, Vector3(-24.5, 0.0, 0.0)), str(hall.position))
		_check("Community Hall carries stable building ID", String(hall.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_COMMUNITY_HALL")
		_check("Community Hall carries S03 section ownership", String(hall.get_meta("pixel_rpg_section_id", "")) == "SET01_S03")
		_check("Community Hall carries A06 area ownership", String(hall.get_meta("pixel_rpg_area_id", "")) == "SET01_A06_COMMUNITY_HALL_CIVIC_CORE")
		_check("Community Hall records G04 ownership", String(hall.get_meta("pixel_rpg_graybox_pass", "")) == "G04")
		_check("Community Hall final art remains unlocked", not bool(hall.get_meta("pixel_rpg_final_art_locked", true)))

		var footprint: Vector2 = g04.get("target_footprint_xz", Vector2.ZERO)
		_check("Community Hall footprint remains 8x10", footprint.is_equal_approx(Vector2(8.0, 10.0)), str(footprint))

		var entrance := hall.get_node_or_null("EntranceAnchor") as Marker3D
		var exit_anchor := hall.get_node_or_null("ExitAnchor") as Marker3D
		var use_anchor := hall.get_node_or_null("UseAnchor") as Marker3D
		var hall_center := hall.get_node_or_null("HallCenterAnchor") as Marker3D
		var keeper := hall.get_node_or_null("KeeperWorkAnchor") as Marker3D
		var notice := hall.get_node_or_null("NoticeBoardAnchor") as Marker3D
		_check("Community Hall preserves reusable entrance/exit/use anchors", entrance != null and exit_anchor != null and use_anchor != null)
		_check("Community Hall exposes HallCenter/Keeper/Notice anchors", hall_center != null and keeper != null and notice != null)

		if entrance != null:
			_check("Community Hall doorway faces east", entrance.global_position.x > hall.global_position.x, "entrance=%s hall=%s" % [entrance.global_position, hall.global_position])
			_check("Community Hall doorway stays at locked Z +1.5", absf(entrance.global_position.z - 1.5) <= 0.01, str(entrance.global_position))

		var hall_max_x := hall.position.x + footprint.x * 0.5
		var west_frontage_lane_min_x := -16.25 - 4.5 * 0.5
		_check(
			"Community Hall footprint keeps 2 m frontage clearance",
			west_frontage_lane_min_x - hall_max_x >= 2.0 - 0.001,
			"hall_max_x=%.3f lane_min_x=%.3f" % [hall_max_x, west_frontage_lane_min_x]
		)

		_check("Community Hall contains readable graybox civic interior",
			hall.has_node("InteriorFloor")
			and hall.has_node("KeeperDesk")
			and hall.has_node("NoticeBoard")
			and hall.has_node("BenchNorth")
			and hall.has_node("BenchSouth")
		)
		_check("Community Hall contains roof visibility group", hall.has_node("RoofVisibilityGroup"))
		_check("Community Hall roof group contains split roof and ridge",
			hall.has_node("RoofVisibilityGroup/RoofWest")
			and hall.has_node("RoofVisibilityGroup/RoofEast")
			and hall.has_node("RoofVisibilityGroup/RidgeBeam")
		)

		for anchor_name in [
			"NPCIdleAnchor_01",
			"NPCIdleAnchor_02",
			"NPCIdleAnchor_03",
			"NPCIdleAnchor_04",
			"EventGatherAnchor_01",
			"EventGatherAnchor_02",
		]:
			_check("Community Hall anchor %s exists" % anchor_name, hall.has_node(anchor_name))

		var collision_root := hall.get_node_or_null("Collision") as Node3D
		var east_north := hall.get_node_or_null("Collision/EastNorthCollision") as StaticBody3D
		var east_south := hall.get_node_or_null("Collision/EastSouthCollision") as StaticBody3D
		var east_lintel := hall.get_node_or_null("Collision/EastLintelCollision") as StaticBody3D
		_check("Community Hall has explicit Collision root", collision_root != null)
		_check("Community Hall east facade collision is segmented around doorway", east_north != null and east_south != null and east_lintel != null)
		_check("Community Hall has no monolithic HallCollision", hall.get_node_or_null("HallCollision") == null)

		if east_north != null and east_south != null and east_lintel != null:
			var north_size := _shape_size(east_north)
			var south_size := _shape_size(east_south)
			var lintel_size := _shape_size(east_lintel)
			var north_inner_z := east_north.position.z + north_size.z * 0.5
			var south_inner_z := east_south.position.z - south_size.z * 0.5
			var doorway_gap := south_inner_z - north_inner_z
			var lintel_bottom := east_lintel.position.y - lintel_size.y * 0.5
			_check("Community Hall doorway width remains 1.8 m", absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("Community Hall doorway height remains 2.4 m", lintel_bottom >= 2.4 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

		await physics_frame
		var space_state := host.get_world_3d().direct_space_state
		var door_query := PhysicsRayQueryParameters3D.create(
			hall.to_global(Vector3(5.0, 0.9, 1.5)),
			hall.to_global(Vector3(3.0, 0.9, 1.5))
		)
		door_query.collision_mask = 1
		var door_hit := space_state.intersect_ray(door_query)
		_check("Community Hall physics ray passes through real east doorway", door_hit.is_empty(), str(door_hit))

		var wall_query := PhysicsRayQueryParameters3D.create(
			hall.to_global(Vector3(5.0, 0.9, -2.0)),
			hall.to_global(Vector3(3.0, 0.9, -2.0))
		)
		wall_query.collision_mask = 1
		var wall_hit := space_state.intersect_ray(wall_query)
		_check("Community Hall adjacent east wall blocks physics", not wall_hit.is_empty(), str(wall_hit))

	# G04 remains isolated. The current app-boot settlement must remain untouched.
	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("current prototype still instantiates", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		var current_smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D
		var current_market := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Market") as Node3D
		var current_gate := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Gate") as Node3D
		_check("current production Smith remains at -7.4,0,-1.5", current_smith != null and _vec3_equal(current_smith.position, Vector3(-7.4, 0.0, -1.5)), str(current_smith.position) if current_smith != null else "missing")
		_check("current production Market remains at 7,0,6", current_market != null and _vec3_equal(current_market.position, Vector3(7.0, 0.0, 6.0)), str(current_market.position) if current_market != null else "missing")
		_check("current production Gate remains at 0,0,-10", current_gate != null and _vec3_equal(current_gate.position, Vector3(0.0, 0.0, -10.0)), str(current_gate.position) if current_gate != null else "missing")
		_check("current production world does not contain isolated G04 Hall", prototype.find_child("Settlement01CommunityHall", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G04_ISOLATED_COMMUNITY_HALL_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G04_ISOLATED_COMMUNITY_HALL_FAILED")
	print("This gate verifies the second enterable Settlement 01 building at locked A06 coordinates with a real east-facing doorway, segmented collision and stable civic/NPC anchors while proving the current app-boot settlement remains unchanged. Final hall facade art, NPC schedules, section streaming, persistence, world cutover and device acceptance remain outside G04.")
	quit(0 if failures.is_empty() else 1)
