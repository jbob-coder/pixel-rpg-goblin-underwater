extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
const G05 := preload("res://scripts/world/settlement/settlement_01_residential_graybox.gd")
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

func _validate_residence(
	host: Node3D,
	residence: Node3D,
	expected_id: String,
	expected_position: Vector3,
	expected_variant: String
) -> void:
	_check("%s exists" % expected_id, residence != null)
	if residence == null:
		return

	_check("%s uses locked center" % expected_id, _vec3_equal(residence.position, expected_position), str(residence.position))
	_check("%s carries stable building ID" % expected_id, String(residence.get_meta("pixel_rpg_building_id", "")) == expected_id)
	_check("%s uses reusable Residence A family" % expected_id, String(residence.get_meta("pixel_rpg_building_family", "")) == "SET01_BLD_RESIDENCE_A")
	_check("%s carries S03 ownership" % expected_id, String(residence.get_meta("pixel_rpg_section_id", "")) == "SET01_S03")
	_check("%s carries A07 ownership" % expected_id, String(residence.get_meta("pixel_rpg_area_id", "")) == "SET01_A07_WEST_RESIDENTIAL_CLUSTER")
	_check("%s carries declared variant" % expected_id, String(residence.get_meta("pixel_rpg_residence_variant", "")) == expected_variant)
	_check("%s records G05 ownership" % expected_id, String(residence.get_meta("pixel_rpg_graybox_pass", "")) == "G05")
	_check("%s final art remains unlocked" % expected_id, not bool(residence.get_meta("pixel_rpg_final_art_locked", true)))

	var entrance := residence.get_node_or_null("EntranceAnchor") as Marker3D
	var exit_anchor := residence.get_node_or_null("ExitAnchor") as Marker3D
	var center_anchor := residence.get_node_or_null("InteriorCenterAnchor") as Marker3D
	var idle_anchor := residence.get_node_or_null("ResidentIdleAnchor") as Marker3D
	var rest_anchor := residence.get_node_or_null("ResidentRestAnchor") as Marker3D
	var yard_anchor := residence.get_node_or_null("YardAnchor") as Marker3D
	_check("%s exposes reusable residence anchors" % expected_id, entrance != null and exit_anchor != null and center_anchor != null and idle_anchor != null and rest_anchor != null and yard_anchor != null)

	if entrance != null:
		_check("%s doorway faces east" % expected_id, entrance.global_position.x > residence.global_position.x, "entrance=%s residence=%s" % [entrance.global_position, residence.global_position])
		_check("%s doorway keeps local Z +0.8" % expected_id, absf(entrance.global_position.z - (residence.global_position.z + 0.8)) <= 0.01, str(entrance.global_position))

	_check("%s contains simple readable interior" % expected_id,
		residence.has_node("InteriorFloor")
		and residence.has_node("LivingTable")
		and residence.has_node("RestBed")
		and residence.has_node("StorageChest")
	)
	_check("%s contains roof visibility group" % expected_id,
		residence.has_node("RoofVisibilityGroup/RoofWest")
		and residence.has_node("RoofVisibilityGroup/RoofEast")
		and residence.has_node("RoofVisibilityGroup/RidgeBeam")
	)

	var east_north := residence.get_node_or_null("Collision/EastNorthCollision") as StaticBody3D
	var east_south := residence.get_node_or_null("Collision/EastSouthCollision") as StaticBody3D
	var east_lintel := residence.get_node_or_null("Collision/EastLintelCollision") as StaticBody3D
	_check("%s east facade collision is segmented" % expected_id, east_north != null and east_south != null and east_lintel != null)
	_check("%s has no monolithic ResidenceCollision" % expected_id, residence.get_node_or_null("ResidenceCollision") == null)

	if east_north != null and east_south != null and east_lintel != null:
		var north_size := _shape_size(east_north)
		var south_size := _shape_size(east_south)
		var lintel_size := _shape_size(east_lintel)
		var north_inner_z := east_north.position.z + north_size.z * 0.5
		var south_inner_z := east_south.position.z - south_size.z * 0.5
		var doorway_gap := south_inner_z - north_inner_z
		var lintel_bottom := east_lintel.position.y - lintel_size.y * 0.5
		_check("%s doorway width remains 1.6 m" % expected_id, absf(doorway_gap - 1.6) <= 0.02, "gap=%.3f" % doorway_gap)
		_check("%s doorway height remains 2.3 m" % expected_id, lintel_bottom >= 2.3 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

	var space_state := host.get_world_3d().direct_space_state
	var door_query := PhysicsRayQueryParameters3D.create(
		residence.to_global(Vector3(4.4, 0.9, 0.8)),
		residence.to_global(Vector3(3.0, 0.9, 0.8))
	)
	door_query.collision_mask = 1
	var door_hit := space_state.intersect_ray(door_query)
	_check("%s physics ray passes through real east doorway" % expected_id, door_hit.is_empty(), str(door_hit))

	var wall_query := PhysicsRayQueryParameters3D.create(
		residence.to_global(Vector3(4.4, 0.9, -1.4)),
		residence.to_global(Vector3(3.0, 0.9, -1.4))
	)
	wall_query.collision_mask = 1
	var wall_hit := space_state.intersect_ray(wall_query)
	_check("%s adjacent east wall blocks physics" % expected_id, not wall_hit.is_empty(), str(wall_hit))

func _run() -> void:
	print("Pixel RPG Settlement 01 G05 — isolated West Residences gate")

	_check("G05 residential schema is stable", String(G05.get_schema()) == "pixel_rpg.settlement_01_residential_graybox.v1")
	_check("G05 residence family ID is stable", String(G05.get_family_id()) == "SET01_BLD_RESIDENCE_A")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G05IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base still builds", base_root != null)

	var g02: Dictionary = G02.add_plaza(base_root)
	_check("G02 isolated plaza still builds", g02.get("root") != null)

	var g03: Dictionary = G03.add_smith(base_root)
	_check("G03 isolated Smith still builds", g03.get("smith") != null)

	var g04: Dictionary = G04.add_community_hall(base_root)
	var hall := g04.get("hall") as Node3D
	_check("G04 isolated Community Hall still builds", hall != null)

	var g05: Dictionary = G05.add_residences(base_root)
	var g05_root := g05.get("root") as Node3D
	var w02 := g05.get("residence_w02") as Node3D
	var w01 := g05.get("residence_w01") as Node3D

	_check("G05 residential root is created", g05_root != null and g05_root.name == "WestResidentialClusterGraybox")
	_check("G05 creates exactly the two locked residence IDs", (g05.get("building_ids", []) as Array).size() == 2)

	await physics_frame
	_validate_residence(host, w02, "SET01_BLD_RES_W02", Vector3(-24.5, 0.0, -10.0), "A_NORTH")
	_validate_residence(host, w01, "SET01_BLD_RES_W01", Vector3(-24.5, 0.0, 10.0), "A_SOUTH")

	if hall != null and w02 != null and w01 != null:
		_check("W02 remains north of Community Hall", w02.position.z < hall.position.z)
		_check("W01 remains south of Community Hall", w01.position.z > hall.position.z)
		var hall_half_depth := 10.0 * 0.5
		var residence_half_depth := 5.5 * 0.5
		var north_gap := (hall.position.z - hall_half_depth) - (w02.position.z + residence_half_depth)
		var south_gap := (w01.position.z - residence_half_depth) - (hall.position.z + hall_half_depth)
		_check("W02 keeps separation from Community Hall", north_gap >= 2.0, "gap=%.3f" % north_gap)
		_check("W01 keeps separation from Community Hall", south_gap >= 2.0, "gap=%.3f" % south_gap)

	var west_frontage_lane_min_x := -16.25 - 4.5 * 0.5
	for residence in [w02, w01]:
		if residence == null:
			continue
		var residence_max_x: float = residence.position.x + 7.0 * 0.5
		_check(
			"%s keeps at least 2.5 m frontage clearance" % residence.name,
			west_frontage_lane_min_x - residence_max_x >= 2.5 - 0.001,
			"residence_max_x=%.3f lane_min_x=%.3f" % [residence_max_x, west_frontage_lane_min_x]
		)

	# G05 remains isolated from app boot.
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
		_check("current production world does not contain isolated W02", prototype.find_child("Settlement01ResidenceW02", true, false) == null)
		_check("current production world does not contain isolated W01", prototype.find_child("Settlement01ResidenceW01", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G05_ISOLATED_RESIDENCES_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G05_ISOLATED_RESIDENCES_FAILED")
	print("This gate verifies two reusable Residence Type A instances at locked A07 positions with real east-facing doorways, segmented collision, resident anchors and clear separation around the Community Hall while proving the current app-boot settlement remains unchanged. Final residence art, resident schedules, section streaming, persistence, world cutover and device acceptance remain outside G05.")
	quit(0 if failures.is_empty() else 1)
