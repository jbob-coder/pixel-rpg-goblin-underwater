extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
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

func _has_collision_recursive(node: Node) -> bool:
	if node == null:
		return false
	if node is CollisionObject3D or node is CollisionShape3D:
		return true
	for child in node.get_children():
		if _has_collision_recursive(child):
			return true
	return false

func _rects_overlap(
	center_a: Vector2,
	size_a: Vector2,
	center_b: Vector2,
	size_b: Vector2,
	epsilon := 0.0001
) -> bool:
	var half_a := size_a * 0.5
	var half_b := size_b * 0.5
	return (
		abs(center_a.x - center_b.x) < half_a.x + half_b.x - epsilon
		and abs(center_a.y - center_b.y) < half_a.y + half_b.y - epsilon
	)

func _run() -> void:
	print("Pixel RPG Settlement 01 G02 — isolated Central Plaza graybox gate")

	_check("G02 plaza schema is stable", String(G02.get_schema()) == "pixel_rpg.settlement_01_plaza_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G02IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base still builds", base_root != null)

	var g02: Dictionary = G02.add_plaza(base_root)
	var plaza_root := g02.get("root") as Node3D
	var plaza_surface := g02.get("plaza_surface") as Node3D
	var stall_sockets := g02.get("stall_sockets") as Node3D
	var water_placeholder := g02.get("water_placeholder") as Node3D
	var notice_placeholder := g02.get("notice_placeholder") as Node3D
	var social_anchors := g02.get("social_anchors") as Node3D

	_check("G02 plaza root is created", plaza_root != null and plaza_root.name == "CentralMarketPlazaGraybox")
	_check("G02 plaza creates no gameplay collision", plaza_root != null and not _has_collision_recursive(plaza_root))

	_check("A05 plaza surface exists", plaza_surface != null)
	if plaza_surface != null:
		_check("A05 plaza surface is centered at world origin", _vec3_equal(plaza_surface.position, Vector3(0.0, 0.01, 0.0)), str(plaza_surface.position))
		var plaza_mesh := _find_mesh(plaza_surface)
		_check("A05 plaza surface has presentation mesh", plaza_mesh != null)
		if plaza_mesh != null and plaza_mesh.mesh is BoxMesh:
			_check("A05 plaza surface matches locked 28x28 area bounds", _vec3_equal((plaza_mesh.mesh as BoxMesh).size, Vector3(28.0, 0.02, 28.0)), str((plaza_mesh.mesh as BoxMesh).size))
		else:
			_check("A05 plaza surface uses BoxMesh", false)

	var expected_stalls := {
		"SET01_A05_STALL_SW": Vector2(-11.0, 8.5),
		"SET01_A05_STALL_SE": Vector2(11.0, 8.5),
		"SET01_A05_STALL_NW": Vector2(-11.0, -8.5),
		"SET01_A05_STALL_NE": Vector2(11.0, -8.5),
	}
	_check("G02 creates exactly four market stall sockets", stall_sockets != null and stall_sockets.get_child_count() == 4, str(stall_sockets.get_child_count()) if stall_sockets != null else "missing")
	if stall_sockets != null:
		for socket_variant in expected_stalls.keys():
			var socket_id := String(socket_variant)
			var expected: Vector2 = expected_stalls[socket_id]
			var socket := stall_sockets.get_node_or_null(socket_id) as Marker3D
			_check("stall socket %s exists" % socket_id, socket != null)
			if socket == null:
				continue
			_check(
				"stall socket %s uses locked center" % socket_id,
				_vec3_equal(socket.position, Vector3(expected.x, 0.045, expected.y)),
				str(socket.position)
			)
			var footprint := socket.get_node_or_null("Footprint") as MeshInstance3D
			_check("stall socket %s has footprint mesh" % socket_id, footprint != null)
			if footprint != null and footprint.mesh is BoxMesh:
				_check(
					"stall socket %s footprint is 4x3" % socket_id,
					_vec3_equal((footprint.mesh as BoxMesh).size, Vector3(4.0, 0.02, 3.0)),
					str((footprint.mesh as BoxMesh).size)
				)
			else:
				_check("stall socket %s footprint uses BoxMesh" % socket_id, false)

			_check(
				"stall socket %s stays outside 8 m Main Spine" % socket_id,
				not _rects_overlap(expected, Vector2(4.0, 3.0), Vector2(0.0, 0.0), Vector2(8.0, 68.0))
			)
			_check(
				"stall socket %s stays outside 5 m Central Cross Street" % socket_id,
				not _rects_overlap(expected, Vector2(4.0, 3.0), Vector2(0.0, 0.0), Vector2(40.0, 5.0))
			)

	_check("G02 water placeholder exists", water_placeholder != null)
	if water_placeholder != null:
		_check("water placeholder uses provisional safe position", _vec3_equal(water_placeholder.position, Vector3(-7.0, 0.08, -5.5)), str(water_placeholder.position))
	_check("G02 notice placeholder exists", notice_placeholder != null)
	if notice_placeholder != null:
		_check("notice placeholder uses provisional safe position", _vec3_equal(notice_placeholder.position, Vector3(7.0, 0.62, -5.5)), str(notice_placeholder.position))

	_check("G02 creates four social anchors", social_anchors != null and social_anchors.get_child_count() == 4, str(social_anchors.get_child_count()) if social_anchors != null else "missing")
	if social_anchors != null:
		for anchor_variant in G02.get_social_anchor_specs().keys():
			var anchor_id := String(anchor_variant)
			var xz: Vector2 = G02.get_social_anchor_specs()[anchor_id]
			var anchor := social_anchors.get_node_or_null(anchor_id) as Marker3D
			_check("social anchor %s exists" % anchor_id, anchor != null)
			if anchor != null:
				_check("social anchor %s uses declared position" % anchor_id, _vec3_equal(anchor.position, Vector3(xz.x, 0.08, xz.y)), str(anchor.position))
				_check("social anchor %s is outside Main Spine" % anchor_id, abs(xz.x) > 4.0)
				_check("social anchor %s is outside Cross Street" % anchor_id, abs(xz.y) > 2.5)

	# G02 remains isolated from app boot. Verify the current production prototype
	# still builds the same pre-migration settlement landmarks.
	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("current prototype still instantiates", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		var current_market := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Market") as Node3D
		var current_smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D
		var current_gate := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Gate") as Node3D
		_check("current production Market remains at 7,0,6", current_market != null and _vec3_equal(current_market.position, Vector3(7.0, 0.0, 6.0)), str(current_market.position) if current_market != null else "missing")
		_check("current production Smith remains at -7.4,0,-1.5", current_smith != null and _vec3_equal(current_smith.position, Vector3(-7.4, 0.0, -1.5)), str(current_smith.position) if current_smith != null else "missing")
		_check("current production Gate remains at 0,0,-10", current_gate != null and _vec3_equal(current_gate.position, Vector3(0.0, 0.0, -10.0)), str(current_gate.position) if current_gate != null else "missing")

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G02_ISOLATED_CENTRAL_PLAZA_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G02_ISOLATED_CENTRAL_PLAZA_FAILED")
	print("This gate verifies the isolated A05 Central Plaza presentation, four locked market-stall sockets, safe placeholder civic objects, and social anchors. It does not integrate G02 into app boot, move production buildings, add plaza collision, enable NPC schedules, streaming, persistence, or device acceptance.")
	quit(0 if failures.is_empty() else 1)
