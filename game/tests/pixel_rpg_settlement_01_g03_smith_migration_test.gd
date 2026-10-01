extends SceneTree

const Layout := preload("res://scripts/world/settlement/settlement_01_layout_g00.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_graybox_g03.gd")
const SmithPack := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")
const CurrentWorldSettlement := preload("res://scripts/presentation/pixel_rpg/world_settlement_core_001.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _approx(left: float, right: float, epsilon := 0.0001) -> bool:
	return absf(left - right) <= epsilon

func _count_collision_shapes(parent: Node) -> int:
	if parent == null:
		return 0
	var count := 1 if parent is CollisionShape3D else 0
	for child in parent.get_children():
		count += _count_collision_shapes(child)
	return count

func _shape_size(body: StaticBody3D) -> Vector3:
	if body == null:
		return Vector3.ZERO
	var shape_node := body.get_node_or_null("Shape") as CollisionShape3D
	if shape_node == null or not (shape_node.shape is BoxShape3D):
		return Vector3.ZERO
	return (shape_node.shape as BoxShape3D).size

func _run() -> void:
	print("Pixel RPG Settlement 01 G03 — locked Smith migration gate")

	var validation: Dictionary = Layout.validate_contract()
	_check("G00 layout remains valid", bool(validation.get("success", false)), str(validation.get("errors", [])))
	_check("G03 schema is stable", G03.get_schema() == "pixel_rpg.settlement_01_graybox.g03.v1")

	var host := Node3D.new()
	host.name = "G03TestHost"
	root.add_child(host)

	var built: Dictionary = G03.build(host, false)
	var graybox_root := built.get("root") as Node3D
	var smith := built.get("smith") as Node3D

	_check("standalone settlement root exists", graybox_root != null)
	_check("migrated Smith exists", smith != null and smith.name == "WorldPack004EnterableSmith")
	if smith == null:
		host.queue_free()
		await process_frame
		_finish()
		return

	_check("Smith building ID is locked", String(smith.get_meta("building_id", "")) == "SET01_BLD_SMITH")
	_check("Smith section ID is S04", String(smith.get_meta("section_id", "")) == "SET01_S04")
	_check("Smith area ID is A09", String(smith.get_meta("area_id", "")) == "SET01_A09_SMITHY_CRAFT_QUARTER")
	_check("Smith migration source remains WorldPack004", String(smith.get_meta("migration_source", "")) == "WorldPack004EnterableSmith")

	_check("Smith position is locked to +24.5,0,0", smith.position == Vector3(24.5, 0.0, 0.0), str(smith.position))
	_check("Smith yaw faces west at -90 degrees", _approx(smith.rotation_degrees.y, -90.0), str(smith.rotation_degrees))

	_check("Smith footprint constants remain 6.6×6.4", _approx(SmithPack.FOOTPRINT_WIDTH_M, 6.6) and _approx(SmithPack.FOOTPRINT_DEPTH_M, 6.4))
	_check("Smith doorway contract remains 1.8×2.4", _approx(SmithPack.DOOR_WIDTH_M, 1.8) and _approx(SmithPack.DOOR_HEIGHT_M, 2.4))

	var entrance := smith.get_node_or_null("EntranceAnchor") as Node3D
	var use_anchor := smith.get_node_or_null("UseAnchor") as Node3D
	_check("Smith preserves EntranceAnchor", entrance != null)
	_check("Smith preserves UseAnchor", use_anchor != null)
	_check("Smith preserves interior station geometry",
		smith.has_node("InteriorFloor")
		and smith.has_node("ForgeHearth")
		and smith.has_node("AnvilTop")
		and smith.has_node("SmithBench")
		and smith.has_node("ToolRack")
	)
	_check("Smith preserves split roof behavior nodes",
		smith.has_node("RoofA")
		and smith.has_node("RoofB")
		and smith.has_node("RidgeBeam")
	)
	var detail_root := smith.get_node_or_null("SmithVisualDetails") as Node3D
	_check("Smith preserves visual detail root", detail_root != null)
	if detail_root != null:
		_check("Smith preserves all four additive detail scenes",
			detail_root.has_node("SmithForgeDetail01")
			and detail_root.has_node("SmithAnvilDetail01")
			and detail_root.has_node("SmithBenchDetail01")
			and detail_root.has_node("SmithFrontageDetail01")
		)

	var collision_root := smith.get_node_or_null("Collision") as Node3D
	_check("Smith preserves segmented collision root", collision_root != null)
	if collision_root != null:
		_check("Smith preserves exactly seven authoritative collision bodies", collision_root.get_child_count() == 7, str(collision_root.get_child_count()))

	var front_left := smith.get_node_or_null("Collision/FrontLeftCollision") as StaticBody3D
	var front_right := smith.get_node_or_null("Collision/FrontRightCollision") as StaticBody3D
	var front_lintel := smith.get_node_or_null("Collision/FrontLintelCollision") as StaticBody3D
	_check("front wall remains segmented around doorway", front_left != null and front_right != null and front_lintel != null)

	if front_left != null and front_right != null and front_lintel != null:
		var left_size := _shape_size(front_left)
		var right_size := _shape_size(front_right)
		var lintel_size := _shape_size(front_lintel)
		var left_inner := front_left.position.x + left_size.x * 0.5
		var right_inner := front_right.position.x - right_size.x * 0.5
		var doorway_gap := right_inner - left_inner
		var lintel_bottom := front_lintel.position.y - lintel_size.y * 0.5
		_check("migrated doorway remains exactly 1.8 m clear", absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
		_check("migrated lintel preserves 2.4 m clearance", lintel_bottom >= 2.38, "lintel_bottom=%.3f" % lintel_bottom)

	if entrance != null:
		var expected_entrance_global := Vector3(20.75, 0.9, 0.0)
		_check("west-facing entrance lands on frontage side", entrance.global_position.distance_to(expected_entrance_global) <= 0.02, str(entrance.global_position))
		_check("entrance keeps >2 m clearance from East Frontage Lane edge",
			entrance.global_position.x - 18.5 >= 2.0,
			"entrance_x=%.3f clearance=%.3f" % [entrance.global_position.x, entrance.global_position.x - 18.5]
		)

	await physics_frame
	if smith.is_inside_tree():
		var space_state := smith.get_world_3d().direct_space_state
		var door_query := PhysicsRayQueryParameters3D.create(
			smith.to_global(Vector3(0.0, 0.9, 4.2)),
			smith.to_global(Vector3(0.0, 0.9, 2.0))
		)
		door_query.collision_mask = 1
		var door_hit := space_state.intersect_ray(door_query)
		_check("physics ray still passes through migrated real doorway", door_hit.is_empty(), str(door_hit))

		var wall_query := PhysicsRayQueryParameters3D.create(
			smith.to_global(Vector3(2.0, 0.9, 4.2)),
			smith.to_global(Vector3(2.0, 0.9, 2.0))
		)
		wall_query.collision_mask = 1
		var wall_hit := space_state.intersect_ray(wall_query)
		_check("adjacent migrated front wall still blocks", not wall_hit.is_empty(), str(wall_hit))

	_check("G03 standalone collision count is floor plus seven Smith shapes", _count_collision_shapes(graybox_root) == 8, str(_count_collision_shapes(graybox_root)))

	# Production world remains untouched by isolated migration.
	_check("production Smith position remains unchanged", CurrentWorldSettlement.SMITH_POSITION == Vector3(-7.4, 0.0, -1.5), str(CurrentWorldSettlement.SMITH_POSITION))
	_check("production Smith yaw remains unchanged", _approx(CurrentWorldSettlement.SMITH_YAW_DEG, 90.0), str(CurrentWorldSettlement.SMITH_YAW_DEG))

	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G03_SMITH_MIGRATION_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G03_SMITH_MIGRATION_FAILED")
	print("This gate verifies isolated locked Smith migration, doorway physics, segmented collision and anchor preservation. It does not move the production Smith, implement crafting, or prove phone acceptance.")
	quit(0 if failures.is_empty() else 1)
