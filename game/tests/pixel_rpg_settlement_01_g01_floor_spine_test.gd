extends SceneTree

const Layout := preload("res://scripts/world/settlement/settlement_01_layout_g00.gd")
const Graybox := preload("res://scripts/world/settlement/settlement_01_graybox_g01.gd")
const CurrentWorldBase := preload("res://scripts/presentation/pixel_rpg/world_base_001.gd")
const CurrentWorldPaths := preload("res://scripts/presentation/pixel_rpg/world_paths_001.gd")

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

func _find_first_child_of_type(parent: Node, type_name: String) -> Node:
	if parent == null:
		return null
	for child in parent.get_children():
		if child.get_class() == type_name:
			return child
	return null

func _count_collision_shapes(parent: Node) -> int:
	if parent == null:
		return 0
	var count := 1 if parent is CollisionShape3D else 0
	for child in parent.get_children():
		count += _count_collision_shapes(child)
	return count

func _run() -> void:
	print("Pixel RPG Settlement 01 G01 — floor and shared-road graybox gate")

	var layout_validation: Dictionary = Layout.validate_contract()
	_check("G00 layout remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))
	_check("G01 schema is stable", Graybox.get_schema() == "pixel_rpg.settlement_01_graybox.g01.v1")

	var host := Node3D.new()
	host.name = "G01TestHost"
	root.add_child(host)

	var built: Dictionary = Graybox.build(host, true)
	var graybox_root := built.get("root") as Node3D
	var floor := built.get("floor") as StaticBody3D
	var main_spine := built.get("main_spine") as Node3D
	var cross_street := built.get("cross_street") as Node3D
	var debug_markers := built.get("debug_markers") as Node3D

	_check("G01 root is created", graybox_root != null and graybox_root.name == "Settlement01GrayboxG01")
	_check("G01 root keeps Settlement 01 identity", graybox_root != null and String(graybox_root.get_meta("settlement_id", "")) == "SETTLEMENT_01")

	_check("settlement floor is StaticBody3D", floor != null)
	if floor != null:
		_check("floor center is locked to 0,-0.35,-1", _vec3_equal(floor.position, Vector3(0.0, -0.35, -1.0)), str(floor.position))
		_check("floor owns exactly one collision shape", _count_collision_shapes(floor) == 1, str(_count_collision_shapes(floor)))

		var floor_mesh := _find_first_child_of_type(floor, "MeshInstance3D") as MeshInstance3D
		var floor_collision := _find_first_child_of_type(floor, "CollisionShape3D") as CollisionShape3D
		_check("floor has a BoxMesh", floor_mesh != null and floor_mesh.mesh is BoxMesh)
		_check("floor has a BoxShape3D", floor_collision != null and floor_collision.shape is BoxShape3D)
		if floor_mesh != null and floor_mesh.mesh is BoxMesh:
			_check("floor visual is exactly 60×0.7×70", _vec3_equal((floor_mesh.mesh as BoxMesh).size, Vector3(60.0, 0.7, 70.0)), str((floor_mesh.mesh as BoxMesh).size))
		if floor_collision != null and floor_collision.shape is BoxShape3D:
			_check("floor collision is exactly 60×0.7×70", _vec3_equal((floor_collision.shape as BoxShape3D).size, Vector3(60.0, 0.7, 70.0)), str((floor_collision.shape as BoxShape3D).size))

	_check("Main Spine exists", main_spine != null)
	if main_spine != null:
		_check("Main Spine center is 0,0.03,-1", _vec3_equal(main_spine.position, Vector3(0.0, 0.03, -1.0)), str(main_spine.position))
		var spine_mesh := _find_first_child_of_type(main_spine, "MeshInstance3D") as MeshInstance3D
		_check("Main Spine is 8×68 visual", spine_mesh != null and spine_mesh.mesh is BoxMesh and _vec3_equal((spine_mesh.mesh as BoxMesh).size, Vector3(8.0, 0.08, 68.0)), str((spine_mesh.mesh as BoxMesh).size) if spine_mesh != null and spine_mesh.mesh is BoxMesh else "missing")
		_check("Main Spine has no collision", _count_collision_shapes(main_spine) == 0, str(_count_collision_shapes(main_spine)))
		_check("Main Spine declares ground physics owner", String(main_spine.get_meta("physics_owner", "")) == "GROUND")

	_check("Cross Street exists", cross_street != null)
	if cross_street != null:
		_check("Cross Street center is 0,0.031,0", _vec3_equal(cross_street.position, Vector3(0.0, 0.031, 0.0)), str(cross_street.position))
		var cross_mesh := _find_first_child_of_type(cross_street, "MeshInstance3D") as MeshInstance3D
		_check("Cross Street is 40×5 visual", cross_mesh != null and cross_mesh.mesh is BoxMesh and _vec3_equal((cross_mesh.mesh as BoxMesh).size, Vector3(40.0, 0.08, 5.0)), str((cross_mesh.mesh as BoxMesh).size) if cross_mesh != null and cross_mesh.mesh is BoxMesh else "missing")
		_check("Cross Street has no collision", _count_collision_shapes(cross_street) == 0, str(_count_collision_shapes(cross_street)))
		_check("Cross Street declares ground physics owner", String(cross_street.get_meta("physics_owner", "")) == "GROUND")

	_check("debug section boundary group is optional and present when requested", debug_markers != null and bool(debug_markers.get_meta("debug_only", false)))
	if debug_markers != null:
		_check("four debug boundary markers exist", debug_markers.get_child_count() == 4, str(debug_markers.get_child_count()))
		_check("debug boundary markers have no collision", _count_collision_shapes(debug_markers) == 0, str(_count_collision_shapes(debug_markers)))

	_check("entire standalone G01 has exactly one collision shape", _count_collision_shapes(graybox_root) == 1, str(_count_collision_shapes(graybox_root)))

	# G01 stays isolated. Current production world constants must remain untouched.
	_check("production Ground position remains unchanged", CurrentWorldBase.GROUND_POSITION == Vector3(0.0, -0.35, -18.0), str(CurrentWorldBase.GROUND_POSITION))
	_check("production Ground size remains unchanged", CurrentWorldBase.GROUND_SIZE == Vector3(46.0, 0.7, 78.0), str(CurrentWorldBase.GROUND_SIZE))
	_check("production Street position remains unchanged", CurrentWorldPaths.STREET_POSITION == Vector3(0.0, 0.03, 2.0), str(CurrentWorldPaths.STREET_POSITION))
	_check("production Street size remains unchanged", CurrentWorldPaths.STREET_SIZE == Vector3(6.2, 0.10, 34.0), str(CurrentWorldPaths.STREET_SIZE))
	_check("production Trail position remains unchanged", CurrentWorldPaths.TRAIL_POSITION == Vector3(0.0, 0.04, -31.0), str(CurrentWorldPaths.TRAIL_POSITION))
	_check("production Trail size remains unchanged", CurrentWorldPaths.TRAIL_SIZE == Vector3(4.2, 0.11, 34.0), str(CurrentWorldPaths.TRAIL_SIZE))

	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G01_FLOOR_SPINE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G01_FLOOR_SPINE_FAILED")
	print("This gate verifies an isolated Settlement 01 floor/Main Spine/Cross Street graybox. It does not replace the production boot world, migrate buildings, enable streaming, or prove phone runtime.")
	quit(0 if failures.is_empty() else 1)
