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

func _box_size(node: MeshInstance3D) -> Vector3:
	if node == null or not (node.mesh is BoxMesh):
		return Vector3.ZERO
	return (node.mesh as BoxMesh).size

func _run() -> void:
	print("Pixel RPG Settlement 01 G07 — isolated East Work Frontage / Worker Passage gate")

	_check("G07 worker-passage schema is stable", String(G07.get_schema()) == "pixel_rpg.settlement_01_worker_passage_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G07IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base still builds", base_root != null)
	_check("G02 isolated plaza still builds", G02.add_plaza(base_root).get("root") != null)

	var g03: Dictionary = G03.add_smith(base_root)
	var smith := g03.get("smith") as Node3D
	_check("G03 isolated Smith still builds", smith != null)

	_check("G04 isolated Community Hall still builds", G04.add_community_hall(base_root).get("hall") != null)
	var g05: Dictionary = G05.add_residences(base_root)
	_check("G05 isolated residences still build", g05.get("residence_w02") != null and g05.get("residence_w01") != null)

	var g06: Dictionary = G06.add_work_support(base_root)
	var canopy := g06.get("canopy") as Node3D
	var storage := g06.get("storage") as Node3D
	_check("G06 isolated work support still builds", canopy != null and storage != null)

	var g07: Dictionary = G07.add_worker_passage(base_root)
	var g07_root := g07.get("root") as Node3D
	var lane := g07.get("lane") as MeshInstance3D
	var props: Array = g07.get("props", [])
	var anchors: Array = g07.get("anchors", [])

	_check("G07 worker-passage root is created", g07_root != null and g07_root.name == "EastWorkFrontagePassageGraybox")
	if g07_root != null:
		_check("G07 carries S04/A08 ownership",
			String(g07_root.get_meta("pixel_rpg_section_id", "")) == "SET01_S04"
			and String(g07_root.get_meta("pixel_rpg_area_id", "")) == "SET01_A08_EAST_WORK_FRONTAGE"
		)
		_check("G07 metadata records isolated pass", String(g07_root.get_meta("pixel_rpg_graybox_pass", "")) == "G07")
		_check("G07 final art remains unlocked", not bool(g07_root.get_meta("pixel_rpg_final_art_locked", true)))
		_check("A08 introduces no building/collision owner", g07_root.find_children("*", "StaticBody3D", true, false).is_empty())

	_check("G07 lane presentation exists", lane != null)
	if lane != null:
		var lane_size := _box_size(lane)
		_check("East Frontage Lane center stays locked", _vec3_equal(lane.position, Vector3(16.25, 0.07, 0.0)), str(lane.position))
		_check("East Frontage Lane remains 4.5 m wide", absf(lane_size.x - 4.5) <= 0.001, "width=%.3f" % lane_size.x)
		_check("East Frontage Lane presentation covers Z -13..+13", absf(lane_size.z - 26.0) <= 0.001, "depth=%.3f" % lane_size.z)

	_check("G07 creates controlled edge-prop set", props.size() == 6, "count=%d" % props.size())
	var lane_max_x := 16.25 + 4.5 * 0.5
	for prop_variant in props:
		var prop := prop_variant as MeshInstance3D
		if prop == null:
			continue
		var size := _box_size(prop)
		var min_x := prop.position.x - size.x * 0.5
		var max_x := prop.position.x + size.x * 0.5
		_check("%s stays east of lane clearance buffer" % prop.name, min_x >= lane_max_x + 0.55 - 0.001, "min_x=%.3f lane_max_x=%.3f" % [min_x, lane_max_x])
		_check("%s stays inside A08 east bound" % prop.name, max_x <= 20.5 + 0.001, "max_x=%.3f" % max_x)
		_check("%s stays presentation-only" % prop.name, not prop.has_meta("pixel_rpg_building_id"))

	_check("G07 exposes worker/connector anchors", anchors.size() == 8, "count=%d" % anchors.size())
	for anchor_variant in anchors:
		var anchor := anchor_variant as Marker3D
		if anchor == null:
			continue
		_check("%s remains inside A08 bounds" % anchor.name,
			anchor.position.x >= 14.0 - 0.001
			and anchor.position.x <= 20.5 + 0.001
			and anchor.position.z >= -14.0 - 0.001
			and anchor.position.z <= 14.0 + 0.001,
			str(anchor.position)
		)

	if g07_root != null:
		_check("G07 exposes shift/tool anchors",
			g07_root.has_node("WorkerIdleAnchor_01")
			and g07_root.has_node("WorkerIdleAnchor_02")
			and g07_root.has_node("ShiftChangeAnchor")
			and g07_root.has_node("ToolPickupAnchor")
		)
		_check("G07 exposes district connector anchors",
			g07_root.has_node("NorthWorkPocketConnector")
			and g07_root.has_node("SouthWorkPocketConnector")
			and g07_root.has_node("PlazaConnector")
			and g07_root.has_node("SmithApproachAnchor")
		)

	if smith != null:
		var smith_west_edge := smith.position.x - 6.6 * 0.5
		_check("Smith remains east of frontage lane with >=2.7 m clearance", smith_west_edge - lane_max_x >= 2.7 - 0.001, "gap=%.3f" % (smith_west_edge - lane_max_x))

	for support_variant in [canopy, storage]:
		var support := support_variant as Node3D
		if support == null:
			continue
		var support_west_edge := support.position.x - 7.0 * 0.5
		_check("%s remains east of frontage lane with >=2.5 m clearance" % support.name, support_west_edge - lane_max_x >= 2.5 - 0.001, "gap=%.3f" % (support_west_edge - lane_max_x))

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
		_check("current production world has no isolated G07 worker passage", prototype.find_child("EastWorkFrontagePassageGraybox", true, false) == null)

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
	print("This gate verifies locked A08 East Work Frontage presentation, worker/shift/tool anchors, prop clearance and continued separation from Smith/A10 support while proving current app-boot settlement placement remains unchanged. Final work-district art, NPC schedule runtime, streaming, persistence, world cutover and device acceptance remain outside G07.")
	quit(0 if failures.is_empty() else 1)
