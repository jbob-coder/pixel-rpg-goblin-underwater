extends SceneTree

const G15 := preload("res://scripts/world/settlement/settlement_01_minimap_contract.gd")
const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const MINIMAP_MATH := preload("res://scripts/presentation/pixel_rpg/minimap_math_001.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _run() -> void:
	print("Pixel RPG Settlement 01 G15 — minimap derivation gate")

	_check("G15 schema is stable", G15.get_schema() == "pixel_rpg.settlement_01_minimap_contract.v1")
	_check("legacy minimap math schema remains stable", MINIMAP_MATH.get_schema() == "pixel_rpg.minimap_math_001.v1")

	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var validation: Dictionary = G15.validate_contract()
	_check("G15 minimap contract validates", bool(validation.get("success", false)), str(validation.get("errors", [])))
	_check("G15 derives five section shapes", int(validation.get("section_count", 0)) == 5, str(validation))
	_check("G15 derives twelve area landmarks", int(validation.get("area_count", 0)) == 12, str(validation))
	_check("G15 derives twelve building markers", int(validation.get("building_count", 0)) == 12, str(validation))
	_check("G15 derives two gate markers", int(validation.get("gate_count", 0)) == 2, str(validation))
	_check("G15 derives four road shapes", int(validation.get("road_count", 0)) == 4, str(validation))

	var bounds := G15.get_world_bounds()
	_check("G15 world bounds come from locked 60x70 settlement envelope",
		is_equal_approx(float(bounds.get("min_x", 0.0)), -30.0)
		and is_equal_approx(float(bounds.get("max_x", 0.0)), 30.0)
		and is_equal_approx(float(bounds.get("min_z", 0.0)), -36.0)
		and is_equal_approx(float(bounds.get("max_z", 0.0)), 34.0),
		str(bounds)
	)

	var normalized_min: Vector2 = G15.normalized_position(Vector2(-30.0, -36.0))
	var normalized_max: Vector2 = G15.normalized_position(Vector2(30.0, 34.0))
	var normalized_center: Vector2 = G15.normalized_position(Vector2(0.0, -1.0))
	_check("G15 maps settlement minimum corner to normalized origin", normalized_min.is_equal_approx(Vector2.ZERO), str(normalized_min))
	_check("G15 maps settlement maximum corner to normalized one", normalized_max.is_equal_approx(Vector2.ONE), str(normalized_max))
	_check("G15 maps geometric settlement center to normalized half", normalized_center.is_equal_approx(Vector2(0.5, 0.5)), str(normalized_center))

	var map_size := Vector2(200.0, 100.0)
	var marker_size := Vector2(10.0, 10.0)
	var marker_min: Vector2 = G15.marker_position(Vector3(-30.0, 0.0, -36.0), map_size, marker_size)
	var marker_max: Vector2 = G15.marker_position(Vector3(30.0, 0.0, 34.0), map_size, marker_size)
	_check("G15 marker minimum uses bounds-aware minimap math", marker_min.is_equal_approx(Vector2.ZERO), str(marker_min))
	_check("G15 marker maximum respects marker extents", marker_max.is_equal_approx(Vector2(190.0, 90.0)), str(marker_max))

	var legacy_sample := Vector3(0.0, 0.0, 0.0)
	var legacy_before := MINIMAP_MATH.marker_position(legacy_sample, map_size, marker_size)
	var legacy_bounds := {
		"min_x": MINIMAP_MATH.WORLD_MIN_X,
		"max_x": MINIMAP_MATH.WORLD_MAX_X,
		"min_z": MINIMAP_MATH.WORLD_MIN_Z,
		"max_z": MINIMAP_MATH.WORLD_MAX_Z,
	}
	var legacy_via_generic := MINIMAP_MATH.marker_position_in_bounds(legacy_sample, legacy_bounds, map_size, marker_size)
	_check("legacy current-world minimap wrapper remains exactly compatible", legacy_before.is_equal_approx(legacy_via_generic), "%s vs %s" % [legacy_before, legacy_via_generic])

	var sections: Array[Dictionary] = G15.get_section_shapes()
	_check("section shape order is stable/sorted",
		String(sections[0].get("section_id", "")) == "SET01_S01"
		and String(sections[4].get("section_id", "")) == "SET01_S05"
	)

	var areas: Array[Dictionary] = G15.get_area_landmarks()
	var shared_found := false
	for area in areas:
		if String(area.get("area_id", "")) == "SET01_A04_MAIN_CENTRAL_SPINE":
			shared_found = String(area.get("kind", "")) == "SHARED_CONNECTOR" and String(area.get("parent_section_id", "")).is_empty()
	_check("Area 04 remains presentation/shared infrastructure, not a durable section owner", shared_found)

	var gates: Array[Dictionary] = G15.get_gate_markers()
	_check("south/north gate minimap markers are stable",
		String(gates[0].get("gate_id", "")) == "SET01_GATE_SOUTH"
		and String(gates[1].get("gate_id", "")) == "SET01_GATE_NORTH"
	)

	var roads: Array[Dictionary] = G15.get_road_shapes()
	_check("main-spine minimap road remains exactly 8 m",
		String(roads[0].get("road_id", "")) == "SET01_ROAD_MAIN_SPINE"
		and is_equal_approx(float(roads[0].get("width_m", 0.0)), 8.0)
	)
	_check("central-cross minimap road remains exactly 5 m",
		String(roads[1].get("road_id", "")) == "SET01_ROAD_CENTRAL_CROSS"
		and is_equal_approx(float(roads[1].get("width_m", 0.0)), 5.0)
	)

	var contract := G15.new()
	_check("G15 is data-only RefCounted with no scene-tree ownership", contract is RefCounted and not contract.has_method("get_parent"))

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G15_MINIMAP_DERIVATION_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G15_MINIMAP_DERIVATION_FAILED")
	print("This gate verifies minimap presentation data derived from the locked G00 Settlement 01 layout: world bounds, section shapes, area landmarks, building/gate markers and road shapes. It preserves the current prototype's legacy minimap wrapper and does not cut the new settlement into production, enable streaming, persist minimap state or prove device UI readability.")
	quit(0 if failures.is_empty() else 1)
