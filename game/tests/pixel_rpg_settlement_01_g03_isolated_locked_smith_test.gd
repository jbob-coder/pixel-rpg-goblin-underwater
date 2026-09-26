extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const SMITH_PACK := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")
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
	print("Pixel RPG Settlement 01 G03 — isolated locked-position Smith gate")

	_check("G03 Smith schema is stable", String(G03.get_schema()) == "pixel_rpg.settlement_01_smith_graybox.v1")
	_check("G03 target yaw is locked west-facing -90 degrees", is_equal_approx(G03.get_target_yaw_deg(), -90.0))

	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G03IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base still builds", base_root != null)

	var g02: Dictionary = G02.add_plaza(base_root)
	_check("G02 isolated plaza still builds", g02.get("root") != null)

	var g03: Dictionary = G03.add_smith(base_root)
	var g03_root := g03.get("root") as Node3D
	var smith := g03.get("smith") as Node3D

	_check("G03 Smith quarter root is created", g03_root != null and g03_root.name == "SmithyCraftQuarterGraybox")
	_check("locked Smith instance is created", smith != null and smith.name == "WorldPack004EnterableSmith")
	if smith != null:
		_check("locked Smith center is +24.5,0,0", _vec3_equal(smith.position, Vector3(24.5, 0.0, 0.0)), str(smith.position))
		_check("locked Smith yaw is -90 degrees", absf(smith.rotation_degrees.y - (-90.0)) <= 0.001, str(smith.rotation_degrees))
		_check("locked Smith carries stable building ID", String(smith.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_SMITH")
		_check("locked Smith carries S04 section ownership", String(smith.get_meta("pixel_rpg_section_id", "")) == "SET01_S04")
		_check("locked Smith carries A09 area ownership", String(smith.get_meta("pixel_rpg_area_id", "")) == "SET01_A09_SMITHY_CRAFT_QUARTER")
		_check("locked Smith records G03 ownership", String(smith.get_meta("pixel_rpg_graybox_pass", "")) == "G03")

		var expected_footprint: Vector2 = g03.get("target_footprint_xz", Vector2.ZERO)
		_check("G00 Smith footprint remains 6.6x6.4", expected_footprint.is_equal_approx(Vector2(6.6, 6.4)), str(expected_footprint))
		_check("Smith pack width matches G00", is_equal_approx(SMITH_PACK.FOOTPRINT_WIDTH_M, expected_footprint.x))
		_check("Smith pack depth matches G00", is_equal_approx(SMITH_PACK.FOOTPRINT_DEPTH_M, expected_footprint.y))

		var entrance := smith.get_node_or_null("EntranceAnchor") as Node3D
		var use_anchor := smith.get_node_or_null("UseAnchor") as Node3D
		_check("locked Smith preserves EntranceAnchor and UseAnchor", entrance != null and use_anchor != null)

		if entrance != null:
			_check("locked Smith doorway faces west toward frontage lane", entrance.global_position.x < smith.global_position.x, "entrance=%s smith=%s" % [entrance.global_position, smith.global_position])
			_check("locked Smith doorway remains centered near world Z 0", absf(entrance.global_position.z) <= 0.05, str(entrance.global_position))
			var east_frontage_lane_max_x := 16.25 + 4.5 * 0.5
			_check(
				"locked Smith entrance keeps at least 2 m frontage clearance",
				entrance.global_position.x - east_frontage_lane_max_x >= 2.0,
				"entrance_x=%.3f lane_max_x=%.3f" % [entrance.global_position.x, east_frontage_lane_max_x]
			)

		var smith_min_x := smith.position.x - expected_footprint.x * 0.5
		var central_cross_max_x := 20.0
		var east_frontage_lane_max_x := 16.25 + 4.5 * 0.5
		_check("Smith footprint stays east of Central Cross Street", smith_min_x > central_cross_max_x, "smith_min_x=%.3f" % smith_min_x)
		_check("Smith footprint stays east of frontage lane", smith_min_x > east_frontage_lane_max_x, "smith_min_x=%.3f" % smith_min_x)

		_check("locked Smith preserves readable interior floor and work stations",
			smith.has_node("InteriorFloor")
			and smith.has_node("ForgeHearth")
			and smith.has_node("AnvilTop")
			and smith.has_node("SmithBench")
			and smith.has_node("ToolRack")
		)
		_check("locked Smith preserves split roof geometry", smith.has_node("RoofA") and smith.has_node("RoofB") and smith.has_node("RidgeBeam"))

		var collision_root := smith.get_node_or_null("Collision") as Node3D
		var front_left := smith.get_node_or_null("Collision/FrontLeftCollision") as StaticBody3D
		var front_right := smith.get_node_or_null("Collision/FrontRightCollision") as StaticBody3D
		var front_lintel := smith.get_node_or_null("Collision/FrontLintelCollision") as StaticBody3D
		_check("locked Smith preserves segmented collision root", collision_root != null)
		_check("locked Smith front collision remains segmented around doorway", front_left != null and front_right != null and front_lintel != null)
		_check("locked Smith has no monolithic SmithCollision", smith.get_node_or_null("SmithCollision") == null)

		if front_left != null and front_right != null and front_lintel != null:
			var left_size := _shape_size(front_left)
			var right_size := _shape_size(front_right)
			var lintel_size := _shape_size(front_lintel)
			var left_inner := front_left.position.x + left_size.x * 0.5
			var right_inner := front_right.position.x - right_size.x * 0.5
			var doorway_gap := right_inner - left_inner
			var lintel_bottom := front_lintel.position.y - lintel_size.y * 0.5
			_check("locked Smith doorway width remains 1.8 m", absf(doorway_gap - SMITH_PACK.DOOR_WIDTH_M) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("locked Smith doorway height remains 2.4 m", lintel_bottom >= SMITH_PACK.DOOR_HEIGHT_M - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

		await physics_frame
		var space_state := host.get_world_3d().direct_space_state
		var door_query := PhysicsRayQueryParameters3D.create(
			smith.to_global(Vector3(0.0, 0.9, 4.2)),
			smith.to_global(Vector3(0.0, 0.9, 2.0))
		)
		door_query.collision_mask = 1
		var door_hit := space_state.intersect_ray(door_query)
		_check("locked-position physics ray passes through real Smith doorway", door_hit.is_empty(), str(door_hit))

		var wall_query := PhysicsRayQueryParameters3D.create(
			smith.to_global(Vector3(2.0, 0.9, 4.2)),
			smith.to_global(Vector3(2.0, 0.9, 2.0))
		)
		wall_query.collision_mask = 1
		var wall_hit := space_state.intersect_ray(wall_query)
		_check("locked-position adjacent Smith wall still blocks physics", not wall_hit.is_empty(), str(wall_hit))

	# G03 is still isolated. The current app-boot Smith remains exactly where
	# the pre-migration world places it until a later integration pass.
	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("current prototype still instantiates", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		var current_smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D
		_check("current production Smith remains at -7.4,0,-1.5", current_smith != null and _vec3_equal(current_smith.position, Vector3(-7.4, 0.0, -1.5)), str(current_smith.position) if current_smith != null else "missing")
		if current_smith != null:
			_check("current production Smith yaw remains +90 degrees", absf(current_smith.rotation_degrees.y - 90.0) <= 0.001, str(current_smith.rotation_degrees))

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G03_ISOLATED_LOCKED_SMITH_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G03_ISOLATED_LOCKED_SMITH_FAILED")
	print("This gate verifies the existing enterable Smith at its locked future A09 position/orientation inside the isolated settlement graybox while proving app-boot Smith placement remains unchanged. Host roof-visibility integration, full crafting, final world cutover, streaming, persistence and device acceptance remain outside G03.")
	quit(0 if failures.is_empty() else 1)
