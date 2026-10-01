extends SceneTree

const Layout := preload("res://scripts/world/settlement/settlement_01_layout_g00.gd")
const CurrentWorldSettlement := preload("res://scripts/presentation/pixel_rpg/world_settlement_core_001.gd")
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

func _approx(left: float, right: float, epsilon := 0.0001) -> bool:
	return absf(left - right) <= epsilon

func _run() -> void:
	print("Pixel RPG Settlement 01 G00 — schema and identity gate")

	var validation: Dictionary = Layout.validate_contract()
	_check("G00 schema is stable", Layout.get_schema() == "pixel_rpg.settlement_01_layout.g00.v1")
	_check("layout self-validation passes", bool(validation.get("success", false)), str(validation.get("errors", [])))
	_check("five durable settlement sections declared", int(validation.get("section_count", 0)) == 5, str(validation))
	_check("twelve authored settlement areas declared", int(validation.get("area_count", 0)) == 12, str(validation))
	_check("four required section connectors declared", int(validation.get("connector_count", 0)) == 4, str(validation))
	_check("twelve fixed building parcels declared", int(validation.get("building_count", 0)) == 12, str(validation))

	var bounds: Dictionary = Layout.get_settlement_bounds()
	_check("settlement width remains 60 m", _approx(float(bounds["x_max"]) - float(bounds["x_min"]), 60.0), str(bounds))
	_check("settlement depth remains 70 m", _approx(float(bounds["z_max"]) - float(bounds["z_min"]), 70.0), str(bounds))

	var sections: Dictionary = Layout.get_section_specs()
	_check("S01 arrival exists", sections.has("SET01_S01"))
	_check("S02 plaza exists", sections.has("SET01_S02"))
	_check("S03 west local exists", sections.has("SET01_S03"))
	_check("S04 east work exists", sections.has("SET01_S04"))
	_check("S05 hunter exit exists", sections.has("SET01_S05"))

	var areas: Dictionary = Layout.get_area_specs()
	var area_04 := areas["SET01_A04_MAIN_CENTRAL_SPINE"] as Dictionary
	_check("Area 04 remains shared infrastructure", String(area_04.get("ownership", "")) == "SHARED_INFRASTRUCTURE")
	_check("Area 04 does not become a durable section owner", String(area_04.get("parent_section_id", "")).is_empty())
	var area_08 := areas["SET01_A08_EAST_WORK_FRONTAGE"] as Dictionary
	_check("Area 08 uses corrected worker-passage identity", String(area_08.get("name", "")) == "East Work Frontage / Worker Passage")
	_check("Area 08 remains building-free at schema level", not area_08.has("building_ids"))

	var shared: Dictionary = Layout.get_shared_infrastructure_specs()
	var main_spine := shared["main_spine"] as Dictionary
	var cross_street := shared["central_cross_street"] as Dictionary
	var west_lane := shared["west_frontage_lane"] as Dictionary
	var east_lane := shared["east_frontage_lane"] as Dictionary
	_check("Main Spine remains 8 m", _approx(float(main_spine.get("width_m", 0.0)), 8.0), str(main_spine))
	_check("Central Cross Street remains 5 m", _approx(float(cross_street.get("width_m", 0.0)), 5.0), str(cross_street))
	_check("West frontage lane remains 4.5 m", _approx(float(west_lane.get("width_m", 0.0)), 4.5), str(west_lane))
	_check("East frontage lane remains 4.5 m", _approx(float(east_lane.get("width_m", 0.0)), 4.5), str(east_lane))
	_check("shared road physics stays ground-owned", String(main_spine.get("physics_owner", "")) == "GROUND" and String(cross_street.get("physics_owner", "")) == "GROUND")

	var connectors: Dictionary = Layout.get_connector_specs()
	_check("S01↔S02 main connector remains 8 m", _approx(float((connectors["SET01_CON_S01_S02_MAIN"] as Dictionary).get("clear_width_m", 0.0)), 8.0))
	_check("S02↔S05 main connector remains 8 m", _approx(float((connectors["SET01_CON_S02_S05_MAIN"] as Dictionary).get("clear_width_m", 0.0)), 8.0))
	_check("S02↔S03 connector remains 5 m", _approx(float((connectors["SET01_CON_S02_S03"] as Dictionary).get("clear_width_m", 0.0)), 5.0))
	_check("S02↔S04 connector remains 5 m", _approx(float((connectors["SET01_CON_S02_S04"] as Dictionary).get("clear_width_m", 0.0)), 5.0))

	var buildings: Dictionary = Layout.get_building_specs()
	var smith := buildings["SET01_BLD_SMITH"] as Dictionary
	_check("future Smith center is locked to +24.5,0", _approx(float(smith.get("center_x", 0.0)), 24.5) and _approx(float(smith.get("center_z", 0.0)), 0.0), str(smith))
	_check("future Smith footprint is locked to 6.6×6.4", _approx(float(smith.get("width_m", 0.0)), 6.6) and _approx(float(smith.get("depth_m", 0.0)), 6.4), str(smith))
	var hall := buildings["SET01_BLD_COMMUNITY_HALL"] as Dictionary
	_check("Community Hall center is locked to -24.5,0", _approx(float(hall.get("center_x", 0.0)), -24.5) and _approx(float(hall.get("center_z", 0.0)), 0.0), str(hall))
	var hunter_watch := buildings["SET01_BLD_HUNTER_WATCH"] as Dictionary
	_check("Hunter Watch center is locked to -19,-27", _approx(float(hunter_watch.get("center_x", 0.0)), -19.0) and _approx(float(hunter_watch.get("center_z", 0.0)), -27.0), str(hunter_watch))

	# G00 is data-only. Snapshot current runtime placement constants to prove this
	# branch has not silently migrated the live prototype while adding the schema.
	_check("current Smith runtime position is still unchanged", CurrentWorldSettlement.SMITH_POSITION == Vector3(-7.4, 0.0, -1.5), str(CurrentWorldSettlement.SMITH_POSITION))
	_check("current Market runtime position is still unchanged", CurrentWorldSettlement.MARKET_POSITION == Vector3(7.0, 0.0, 6.0), str(CurrentWorldSettlement.MARKET_POSITION))
	_check("current Street runtime position is still unchanged", CurrentWorldPaths.STREET_POSITION == Vector3(0.0, 0.03, 2.0), str(CurrentWorldPaths.STREET_POSITION))
	_check("current Trail runtime position is still unchanged", CurrentWorldPaths.TRAIL_POSITION == Vector3(0.0, 0.04, -31.0), str(CurrentWorldPaths.TRAIL_POSITION))

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G00_SCHEMA_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G00_SCHEMA_FAILED")
	print("This gate verifies Settlement 01 schema/identity only. It does not move current runtime geometry, enable streaming, implement persistence, or prove Android/device behavior.")
	quit(0 if failures.is_empty() else 1)
