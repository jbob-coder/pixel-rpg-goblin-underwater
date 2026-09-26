extends SceneTree

const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const SECTION_DEFINITION := preload("res://scripts/world/settlement/settlement_section_definition.gd")
const AREA_DEFINITION := preload("res://scripts/world/settlement/settlement_area_definition.gd")
const SECTION_INSTANCE := preload("res://scripts/world/settlement/settlement_section_instance.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _vec2_equal(left: Vector2, right: Vector2, epsilon := 0.0001) -> bool:
	return left.distance_to(right) <= epsilon

func _run() -> void:
	print("Pixel RPG Settlement 01 G00 — schema, identity and locked-layout gate")

	_check("section definition schema is stable", String(SECTION_DEFINITION.get_schema()) == "pixel_rpg.settlement_section_definition.v1")
	_check("area definition schema is stable", String(AREA_DEFINITION.get_schema()) == "pixel_rpg.settlement_area_definition.v1")
	var instance := SECTION_INSTANCE.new()
	_check("section instance schema is stable", String(instance.get_schema()) == "pixel_rpg.settlement_section_instance.v1")
	_check("layout schema is stable", String(LAYOUT.get_schema()) == "pixel_rpg.settlement_01_layout.v1")

	var validation: Dictionary = LAYOUT.validate_contract()
	_check("layout contract self-validation passes", bool(validation.get("success", false)), str(validation.get("errors", [])))
	_check("exactly five durable sections are defined", int(validation.get("section_count", 0)) == 5, str(validation))
	_check("exactly twelve authored areas are defined", int(validation.get("area_count", 0)) == 12, str(validation))
	_check("required four-section connectors are defined", int(validation.get("connector_count", 0)) == 4, str(validation))
	_check("all five durable sections are connected", int(validation.get("connected_section_count", 0)) == 5, str(validation))
	_check("twelve fixed building parcels are defined", int(validation.get("building_count", 0)) == 12, str(validation))

	var sections: Dictionary = LAYOUT.get_section_specs()
	var areas: Dictionary = LAYOUT.get_area_specs()
	var connectors: Dictionary = LAYOUT.get_connector_specs()
	var buildings: Dictionary = LAYOUT.get_building_specs()
	var infrastructure: Dictionary = LAYOUT.get_infrastructure_specs()

	_check("South Arrival section ID exists", sections.has("SET01_S01"))
	_check("Central Plaza section ID exists", sections.has("SET01_S02"))
	_check("West Local section ID exists", sections.has("SET01_S03"))
	_check("East Work section ID exists", sections.has("SET01_S04"))
	_check("North Hunter section ID exists", sections.has("SET01_S05"))

	var area04 := areas.get("SET01_A04_MAIN_CENTRAL_SPINE", {}) as Dictionary
	_check("Area 04 is shared connector infrastructure", String(area04.get("kind", "")) == AREA_DEFINITION.KIND_SHARED_CONNECTOR)
	_check("Area 04 does not claim a durable parent section", String(area04.get("parent_section_id", "")).is_empty())

	var area07 := areas.get("SET01_A07_WEST_RESIDENTIAL_CLUSTER", {}) as Dictionary
	var area10 := areas.get("SET01_A10_STORAGE_WORKSHOP_YARD", {}) as Dictionary
	_check("Area 07 retains two locked residential pockets", (area07.get("bounds_parts", []) as Array).size() == 2)
	_check("Area 10 retains two locked work-support pockets", (area10.get("bounds_parts", []) as Array).size() == 2)

	var area08 := areas.get("SET01_A08_EAST_WORK_FRONTAGE", {}) as Dictionary
	_check("corrected Area 08 stable ID exists", not area08.is_empty())
	_check("Area 08 remains S04-owned frontage, not housing", String(area08.get("parent_section_id", "")) == "SET01_S04")
	var area08_buildings := 0
	for building_variant in buildings.values():
		var building := building_variant as Dictionary
		if String(building.get("area_id", "")) == "SET01_A08_EAST_WORK_FRONTAGE":
			area08_buildings += 1
	_check("Area 08 contains no unauthorized permanent building parcel", area08_buildings == 0, str(area08_buildings))

	var south_gate := infrastructure.get("south_gate", {}) as Dictionary
	var north_gate := infrastructure.get("north_gate", {}) as Dictionary
	var main_spine := infrastructure.get("main_spine", {}) as Dictionary
	var cross_street := infrastructure.get("central_cross_street", {}) as Dictionary
	_check("South Gate stays centered at 0,+33", _vec2_equal(south_gate.get("center_xz", Vector2.ZERO), Vector2(0.0, 33.0)))
	_check("North Gate stays centered at 0,-35", _vec2_equal(north_gate.get("center_xz", Vector2.ZERO), Vector2(0.0, -35.0)))
	_check("both gate openings remain exactly 8 m", is_equal_approx(float(south_gate.get("clear_width_m", 0.0)), 8.0) and is_equal_approx(float(north_gate.get("clear_width_m", 0.0)), 8.0))
	_check("Main Hunter Spine remains exactly 8 m", is_equal_approx(float(main_spine.get("width_m", 0.0)), 8.0))
	_check("Central Cross Street remains exactly 5 m", is_equal_approx(float(cross_street.get("width_m", 0.0)), 5.0))

	var hall := buildings.get("SET01_BLD_COMMUNITY_HALL", {}) as Dictionary
	var smith := buildings.get("SET01_BLD_SMITH", {}) as Dictionary
	var work_canopy := buildings.get("SET01_BLD_WORK_CANOPY", {}) as Dictionary
	var work_storage := buildings.get("SET01_BLD_WORK_STORAGE", {}) as Dictionary
	_check("Community Hall stays fixed at -24.5,0", _vec2_equal(hall.get("center_xz", Vector2.ZERO), Vector2(-24.5, 0.0)))
	_check("Smith stays fixed at +24.5,0", _vec2_equal(smith.get("center_xz", Vector2.ZERO), Vector2(24.5, 0.0)))
	_check("Work Canopy stays north at +24.5,-9.5", _vec2_equal(work_canopy.get("center_xz", Vector2.ZERO), Vector2(24.5, -9.5)))
	_check("Work Storage stays south at +24.5,+9.5", _vec2_equal(work_storage.get("center_xz", Vector2.ZERO), Vector2(24.5, 9.5)))

	var main_connector := connectors.get("SET01_CON_S01_S02_MAIN", {}) as Dictionary
	var west_connector := connectors.get("SET01_CON_S02_S03", {}) as Dictionary
	var east_connector := connectors.get("SET01_CON_S02_S04", {}) as Dictionary
	var north_connector := connectors.get("SET01_CON_S02_S05_MAIN", {}) as Dictionary
	_check("south connector width is 8 m", is_equal_approx(float(main_connector.get("clear_width_m", 0.0)), 8.0))
	_check("west connector width is 5 m", is_equal_approx(float(west_connector.get("clear_width_m", 0.0)), 5.0))
	_check("east connector width is 5 m", is_equal_approx(float(east_connector.get("clear_width_m", 0.0)), 5.0))
	_check("north connector width is 8 m", is_equal_approx(float(north_connector.get("clear_width_m", 0.0)), 8.0))

	var configured: Dictionary = instance.configure(sections["SET01_S01"] as Dictionary)
	_check("SectionInstance accepts a valid SectionDefinition", bool(configured.get("success", false)), str(configured))
	_check("SectionInstance exposes stable section ID", instance.get_section_id() == "SET01_S01")
	_check("SectionInstance starts unloaded", not instance.is_loaded())
	instance.set_loaded(true)
	_check("SectionInstance can represent lifecycle state without world mutation", instance.is_loaded())
	_check("SectionInstance is data-only RefCounted, not a scene Node", not (instance is Node))

	var invalid := SECTION_INSTANCE.new()
	var invalid_result: Dictionary = invalid.configure({})
	_check("SectionInstance rejects invalid empty definitions", not bool(invalid_result.get("success", true)))
	_check("invalid SectionInstance remains unconfigured and unloaded", not invalid.is_configured() and not invalid.is_loaded())

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G00_LAYOUT_CONTRACT_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G00_LAYOUT_CONTRACT_FAILED")
	print("This gate verifies Settlement 01 data-only IDs, locked bounds, graph/connectors, fixed building parcels and SectionInstance contract. It does not move visible world geometry, enable streaming, implement persistence, or prove physical-device behavior.")
	quit(0 if failures.is_empty() else 1)
