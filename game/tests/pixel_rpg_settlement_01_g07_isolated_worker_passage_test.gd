extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
const G05 := preload("res://scripts/world/settlement/settlement_01_residential_graybox.gd")
const G06 := preload("res://scripts/world/settlement/settlement_01_work_support_graybox.gd")
const G07 := preload("res://scripts/world/settlement/settlement_01_worker_passage_graybox.gd")
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

func _mesh_size(node: MeshInstance3D) -> Vector3:
	if node == null or not (node.mesh is BoxMesh):
		return Vector3.ZERO
	return (node.mesh as BoxMesh).size

func _run() -> void:
	print("Pixel RPG Settlement 01 G07 — isolated Worker Passage gate")

	_check("G07 Worker Passage schema is stable", String(G07.get_schema()) == "pixel_rpg.settlement_01_worker_passage_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var area_defs: Dictionary = LAYOUT.get_area_specs()
	var a08: Dictionary = area_defs.get("SET01_A08_EAST_WORK_FRONTAGE", {}) as Dictionary
	_check("A08 remains S04-owned", String(a08.get("parent_section_id", "")) == "SET01_S04")
	_check("A08 retains one declared bounds part", (a08.get("bounds_parts", []) as Array).size() == 1)

	var building_specs: Dictionary = LAYOUT.get_building_specs()
	var a08_building_count := 0
	for spec_variant in building_specs.values():
		var spec := spec_variant as Dictionary
		if String(spec.get("area_id", "")) == "SET01_A08_EAST_WORK_FRONTAGE":
			a08_building_count += 1
	_check("A08 has no permanent building parcels", a08_building_count == 0, str(a08_building_count))

	var host := Node3D.new()
	host.name = "G07IsolatedHost"
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

	var g07: Dictionary = G07.add_worker_passage(base_root)
	var g07_root := g07.get("root") as Node3D
	_check("G07 root is created", g07_root != null and g07_root.name == "EastWorkFrontageWorkerPassageGraybox")

	if g07_root != null:
		_check("G07 carries S04 ownership", String(g07_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S04")
		_check("G07 carries A08 ownership", String(g07_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A08_EAST_WORK_FRONTAGE")
		_check("G07 records G07 ownership", String(g07_root.get_meta("pixel_rpg_graybox_pass", "")) == "G07")
		_check("G07 final art remains unlocked", not bool(g07_root.get_meta("pixel_rpg_final_art_locked", true)))
		_check("G07 does not claim building identity", not g07_root.has_meta("pixel_rpg_building_id"))

		var lane := g07_root.get_node_or_null("EastFrontageLane") as MeshInstance3D
		var edge := g07_root.get_node_or_null("WorkEdgeStrip") as MeshInstance3D
		_check("east frontage lane presentation exists", lane != null)
		_check("work-edge presentation strip exists", edge != null)

		if lane != null:
			var lane_size: Vector3 = _mesh_size(lane)
			_check("frontage lane center is locked at X 16.25", absf(lane.position.x - 16.25) <= 0.001, str(lane.position))
			_check("frontage lane remains 4.5 m wide", absf(lane_size.x - 4.5) <= 0.001, str(lane_size))
			_check("frontage lane remains Z -13..+13", absf(lane_size.z - 26.0) <= 0.001 and absf(lane.position.z) <= 0.001, "%s @ %s" % [lane_size, lane.position])

		if edge != null:
			var edge_size: Vector3 = _mesh_size(edge)
			_check("work edge starts at lane east boundary", absf((edge.position.x - edge_size.x * 0.5) - 18.5) <= 0.001, "%s @ %s" % [edge_size, edge.position])
			_check("work edge stays within A08 east bound", edge.position.x + edge_size.x * 0.5 <= 20.5 + 0.001)

		var static_bodies: Array[Node] = g07_root.find_children("*", "StaticBody3D", true, false)
		var collision_shapes: Array[Node] = g07_root.find_children("*", "CollisionShape3D", true, false)
		_check("G07 adds no gameplay StaticBody collision", static_bodies.is_empty(), str(static_bodies.size()))
		_check("G07 adds no collision shapes", collision_shapes.is_empty(), str(collision_shapes.size()))

		for anchor_name in [
			"ShiftStartAnchor",
			"ToolPickupAnchor",
			"WorkerIdleAnchor_01",
			"WorkerIdleAnchor_02",
			"ToolReturnAnchor",
			"ShiftEndAnchor",
			"ConnectorNorthAnchor",
			"ConnectorSouthAnchor",
		]:
			var anchor := g07_root.get_node_or_null(anchor_name) as Marker3D
			_check("G07 anchor %s exists" % anchor_name, anchor != null)
			if anchor != null and not anchor_name.begins_with("Connector"):
				_check("G07 anchor %s stays east of clear lane" % anchor_name, anchor.position.x >= 18.75, str(anchor.position))

		for prop_name in ["ShiftBoard", "ToolRackNorth", "ToolRackSouth", "SupplyCrateBottom"]:
			var prop := g07_root.find_child(prop_name, true, false) as MeshInstance3D
			_check("G07 prop %s exists" % prop_name, prop != null)
			if prop != null:
				var prop_size: Vector3 = _mesh_size(prop)
				var prop_min_x: float = prop.global_position.x - prop_size.x * 0.5
				_check("G07 prop %s does not intrude into 4.5 m lane" % prop_name, prop_min_x >= 18.5 - 0.001, "min_x=%.3f" % prop_min_x)

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
		_check("current production world has no isolated G07 passage", prototype.find_child("EastWorkFrontageWorkerPassageGraybox", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G07_ISOLATED_WORKER_PASSAGE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G07_ISOLATED_WORKER_PASSAGE_FAILED")
	print("This gate verifies A08 as a collision-free S04 frontage/worker-passage slice with the full 4.5 m lane preserved, edge-only work presentation and stable worker/tool anchors while proving A08 gains no permanent building parcel and current app-boot settlement placement remains unchanged. NPC schedules, final art, streaming, persistence, world cutover and device acceptance remain outside G07.")
	quit(0 if failures.is_empty() else 1)
