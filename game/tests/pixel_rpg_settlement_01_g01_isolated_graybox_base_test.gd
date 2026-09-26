extends SceneTree

const GRAYBOX := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
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

func _find_mesh(parent: Node) -> MeshInstance3D:
	if parent == null:
		return null
	for child in parent.get_children():
		if child is MeshInstance3D:
			return child as MeshInstance3D
	return null

func _find_collision(parent: Node) -> CollisionShape3D:
	if parent == null:
		return null
	for child in parent.get_children():
		if child is CollisionShape3D:
			return child as CollisionShape3D
	return null

func _run() -> void:
	print("Pixel RPG Settlement 01 G01 — isolated floor and shared-road graybox gate")

	_check("G01 graybox schema is stable", String(GRAYBOX.get_schema()) == "pixel_rpg.settlement_01_graybox_base.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G01IsolatedHost"
	root.add_child(host)

	var built: Dictionary = GRAYBOX.add_graybox_base(host)
	var graybox_root := built.get("root") as Node3D
	var floor := built.get("floor") as StaticBody3D
	var spine := built.get("main_spine") as Node3D
	var cross := built.get("cross_street") as Node3D
	_check("isolated graybox root is created", graybox_root != null and graybox_root.name == "Settlement01GrayboxBase")
	_check("default G01 build does not create debug boundaries", built.get("debug_boundaries") == null)

	_check("Settlement floor is a StaticBody3D", floor != null)
	if floor != null:
		_check("Settlement floor center matches -30..+30 / -36..+34 envelope", _vec3_equal(floor.position, Vector3(0.0, -0.35, -1.0)), str(floor.position))
		var floor_mesh := _find_mesh(floor)
		var floor_collision := _find_collision(floor)
		_check("Settlement floor has a mesh", floor_mesh != null)
		_check("Settlement floor has one authored collision shape", floor_collision != null)
		if floor_mesh != null and floor_mesh.mesh is BoxMesh:
			_check("Settlement floor mesh is exactly 60x0.7x70", _vec3_equal((floor_mesh.mesh as BoxMesh).size, Vector3(60.0, 0.7, 70.0)), str((floor_mesh.mesh as BoxMesh).size))
		else:
			_check("Settlement floor mesh uses BoxMesh", false)
		if floor_collision != null and floor_collision.shape is BoxShape3D:
			_check("Settlement floor collision is exactly 60x0.7x70", _vec3_equal((floor_collision.shape as BoxShape3D).size, Vector3(60.0, 0.7, 70.0)), str((floor_collision.shape as BoxShape3D).size))
		else:
			_check("Settlement floor collision uses BoxShape3D", false)

	_check("Main Hunter Spine presentation exists", spine != null)
	if spine != null:
		_check("Main Hunter Spine center matches locked corridor", _vec3_equal(spine.position, Vector3(0.0, 0.04, -1.0)), str(spine.position))
		var spine_mesh := _find_mesh(spine)
		_check("Main Hunter Spine has presentation mesh", spine_mesh != null)
		if spine_mesh != null and spine_mesh.mesh is BoxMesh:
			_check("Main Hunter Spine presentation is exactly 8x0.08x68", _vec3_equal((spine_mesh.mesh as BoxMesh).size, Vector3(8.0, 0.08, 68.0)), str((spine_mesh.mesh as BoxMesh).size))
		else:
			_check("Main Hunter Spine uses BoxMesh", false)
		_check("Main Hunter Spine has no duplicate collision", _find_collision(spine) == null)

	_check("Central Cross Street presentation exists", cross != null)
	if cross != null:
		_check("Central Cross Street center is locked at world origin", _vec3_equal(cross.position, Vector3(0.0, 0.04, 0.0)), str(cross.position))
		var cross_mesh := _find_mesh(cross)
		_check("Central Cross Street has presentation mesh", cross_mesh != null)
		if cross_mesh != null and cross_mesh.mesh is BoxMesh:
			_check("Central Cross Street presentation is exactly 40x0.08x5", _vec3_equal((cross_mesh.mesh as BoxMesh).size, Vector3(40.0, 0.08, 5.0)), str((cross_mesh.mesh as BoxMesh).size))
		else:
			_check("Central Cross Street uses BoxMesh", false)
		_check("Central Cross Street has no duplicate collision", _find_collision(cross) == null)

	var debug_host := Node3D.new()
	debug_host.name = "G01DebugHost"
	root.add_child(debug_host)
	var debug_built: Dictionary = GRAYBOX.add_graybox_base(debug_host, true)
	var debug_boundaries := debug_built.get("debug_boundaries") as Node3D
	_check("debug-boundary mode creates presentation-only holder", debug_boundaries != null and debug_boundaries.name == "SectionBoundaryDebug")
	if debug_boundaries != null:
		_check("debug-boundary mode creates exactly four section markers", debug_boundaries.get_child_count() == 4, str(debug_boundaries.get_child_count()))
		var debug_has_collision := false
		for child in debug_boundaries.get_children():
			if child is CollisionObject3D or child is CollisionShape3D:
				debug_has_collision = true
		_check("debug boundaries create no gameplay collision", not debug_has_collision)

	# G01 is intentionally isolated. Current boot-world geometry must stay exactly
	# at the verified pre-migration placements until a later bounded migration pass.
	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("current prototype still instantiates", prototype != null)
	if prototype != null:
		var authored_hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
		_check("current Hunter authored spawn remains unchanged", authored_hunter != null and _vec3_equal(authored_hunter.position, Vector3(0.0, 0.9, 13.0)), str(authored_hunter.position) if authored_hunter != null else "missing")

		# World geometry is assembled in the prototype's _ready(). Add it to the
		# tree, then inspect immediately before advancing a physics frame so this
		# isolation gate does not conflate world-build parity with gravity settling.
		root.add_child(prototype)
		var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
		var current_ground := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/Ground") as StaticBody3D
		var current_street := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/Street") as Node3D
		var current_trail := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/Trail") as Node3D
		var current_smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D
		var current_gate := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Gate") as Node3D

		_check("current WorldGeometry remains present after _ready world build", geometry != null)
		_check("current production Ground position remains unchanged", current_ground != null and _vec3_equal(current_ground.position, Vector3(0.0, -0.35, -18.0)), str(current_ground.position) if current_ground != null else "missing")
		if current_ground != null:
			var current_ground_mesh := _find_mesh(current_ground)
			_check(
				"current production Ground remains 46x0.7x78",
				current_ground_mesh != null
					and current_ground_mesh.mesh is BoxMesh
					and _vec3_equal((current_ground_mesh.mesh as BoxMesh).size, Vector3(46.0, 0.7, 78.0))
			)
		_check("current production Street remains at 0,0.03,2", current_street != null and _vec3_equal(current_street.position, Vector3(0.0, 0.03, 2.0)), str(current_street.position) if current_street != null else "missing")
		_check("current production Trail remains at 0,0.04,-31", current_trail != null and _vec3_equal(current_trail.position, Vector3(0.0, 0.04, -31.0)), str(current_trail.position) if current_trail != null else "missing")
		_check("current enterable Smith remains at -7.4,0,-1.5", current_smith != null and _vec3_equal(current_smith.position, Vector3(-7.4, 0.0, -1.5)), str(current_smith.position) if current_smith != null else "missing")
		_check("current settlement Gate remains at 0,0,-10", current_gate != null and _vec3_equal(current_gate.position, Vector3(0.0, 0.0, -10.0)), str(current_gate.position) if current_gate != null else "missing")

	if prototype != null:
		prototype.queue_free()
	debug_host.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G01_ISOLATED_GRAYBOX_BASE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G01_ISOLATED_GRAYBOX_BASE_FAILED")
	print("This gate verifies the isolated 60x70 floor/Main Spine/Cross Street graybox and proves current production world placement is unchanged. It does not integrate the new floor into app boot, move buildings, enable streaming, implement persistence, or prove device behavior.")
	quit(0 if failures.is_empty() else 1)
