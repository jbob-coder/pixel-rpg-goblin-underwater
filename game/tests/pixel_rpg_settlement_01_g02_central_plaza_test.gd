extends SceneTree

const Layout := preload("res://scripts/world/settlement/settlement_01_layout_g00.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_graybox_g02.gd")
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

func _rect_from_center(center_x: float, center_z: float, width: float, depth: float) -> Dictionary:
	return {
		"x_min": center_x - width * 0.5,
		"x_max": center_x + width * 0.5,
		"z_min": center_z - depth * 0.5,
		"z_max": center_z + depth * 0.5,
	}

func _rects_overlap(left: Dictionary, right: Dictionary) -> bool:
	return (
		float(left["x_min"]) < float(right["x_max"])
		and float(left["x_max"]) > float(right["x_min"])
		and float(left["z_min"]) < float(right["z_max"])
		and float(left["z_max"]) > float(right["z_min"])
	)

func _run() -> void:
	print("Pixel RPG Settlement 01 G02 — Central Plaza gate")

	var validation: Dictionary = Layout.validate_contract()
	_check("G00 layout remains valid", bool(validation.get("success", false)), str(validation.get("errors", [])))
	_check("G02 schema is stable", G02.get_schema() == "pixel_rpg.settlement_01_graybox.g02.v1")

	var host := Node3D.new()
	host.name = "G02TestHost"
	root.add_child(host)

	var built: Dictionary = G02.build(host, false)
	var graybox_root := built.get("root") as Node3D
	var plaza := built.get("plaza_root") as Node3D
	var stall_sockets := built.get("stall_sockets", {}) as Dictionary
	var civic_water := built.get("civic_water") as MeshInstance3D
	var notice_socket := built.get("notice_socket") as Marker3D
	var social_anchors := built.get("social_anchors", {}) as Dictionary

	_check("G02 reuses standalone G01 root", graybox_root != null and graybox_root.name == "Settlement01GrayboxG01")
	_check("Central Plaza root exists", plaza != null and plaza.name == "CentralMarketPlazaG02")
	_check("Central Plaza keeps Area 05 identity", plaza != null and String(plaza.get_meta("area_id", "")) == "SET01_A05_CENTRAL_MARKET_PLAZA")

	_check("four market stall sockets exist", stall_sockets.size() == 4, str(stall_sockets.keys()))

	var main_spine_rect := {
		"x_min": -4.0,
		"x_max": 4.0,
		"z_min": -35.0,
		"z_max": 33.0,
	}
	var cross_street_rect := {
		"x_min": -20.0,
		"x_max": 20.0,
		"z_min": -2.5,
		"z_max": 2.5,
	}
	var plaza_bounds := (Layout.get_section_specs()["SET01_S02"] as Dictionary).get("bounds", {}) as Dictionary

	for socket_variant in stall_sockets.keys():
		var socket_name := String(socket_variant)
		var socket := stall_sockets[socket_name] as Marker3D
		_check("stall socket is Marker3D: %s" % socket_name, socket != null)
		if socket == null:
			continue
		var width := float(socket.get_meta("width_m", 0.0))
		var depth := float(socket.get_meta("depth_m", 0.0))
		_check("stall footprint remains 4×3: %s" % socket_name, _approx(width, 4.0) and _approx(depth, 3.0), "%sx%s" % [width, depth])
		var footprint := _rect_from_center(socket.position.x, socket.position.z, width, depth)
		_check("stall stays inside S02: %s" % socket_name,
			float(footprint["x_min"]) >= float(plaza_bounds["x_min"])
			and float(footprint["x_max"]) <= float(plaza_bounds["x_max"])
			and float(footprint["z_min"]) >= float(plaza_bounds["z_min"])
			and float(footprint["z_max"]) <= float(plaza_bounds["z_max"]),
			str(footprint)
		)
		_check("stall avoids 8 m Main Spine: %s" % socket_name, not _rects_overlap(footprint, main_spine_rect), str(footprint))
		_check("stall avoids 5 m Cross Street: %s" % socket_name, not _rects_overlap(footprint, cross_street_rect), str(footprint))
		_check("stall socket owns no collision: %s" % socket_name, _count_collision_shapes(socket) == 0)

	_check("civic water placeholder exists", civic_water != null)
	if civic_water != null:
		_check("civic water position is locked", _approx(civic_water.position.x, -7.0) and _approx(civic_water.position.z, -5.5), str(civic_water.position))
		_check("civic water is non-physical", _count_collision_shapes(civic_water) == 0)

	_check("notice-board socket exists", notice_socket != null)
	if notice_socket != null:
		_check("notice-board position is locked", _approx(notice_socket.position.x, 7.7) and _approx(notice_socket.position.z, -5.8), str(notice_socket.position))
		_check("notice board is non-physical", _count_collision_shapes(notice_socket) == 0)

	_check("six social/interaction anchors exist", social_anchors.size() == 6, str(social_anchors.keys()))
	for anchor_variant in social_anchors.keys():
		var anchor_name := String(anchor_variant)
		var anchor := social_anchors[anchor_name] as Marker3D
		_check("social anchor is Marker3D: %s" % anchor_name, anchor != null)
		if anchor != null:
			_check("social anchor owns no collision: %s" % anchor_name, _count_collision_shapes(anchor) == 0)

	_check("G02 preserves exactly one collision shape in full standalone settlement", _count_collision_shapes(graybox_root) == 1, str(_count_collision_shapes(graybox_root)))

	# G02 remains isolated from current production layout.
	_check("current production Market remains unchanged", CurrentWorldSettlement.MARKET_POSITION == Vector3(7.0, 0.0, 6.0), str(CurrentWorldSettlement.MARKET_POSITION))
	_check("current production Smith remains unchanged", CurrentWorldSettlement.SMITH_POSITION == Vector3(-7.4, 0.0, -1.5), str(CurrentWorldSettlement.SMITH_POSITION))

	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G02_CENTRAL_PLAZA_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G02_CENTRAL_PLAZA_FAILED")
	print("This gate verifies isolated Central Plaza sockets/placeholders and road-clearance geometry only. It does not add market services, NPC schedules, persistence, production-world integration, or phone acceptance.")
	quit(0 if failures.is_empty() else 1)
