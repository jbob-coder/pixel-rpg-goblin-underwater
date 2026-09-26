extends SceneTree

const G00 := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const G15 := preload("res://scripts/world/settlement/settlement_01_minimap_contract.gd")
const G16 := preload("res://scripts/world/settlement/settlement_01_streaming_manager.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _array_equal(left: Array, right: Array) -> bool:
	return left == right

func _run() -> void:
	print("Pixel RPG Settlement 01 G16 — conservative streaming lifecycle gate")

	var g00_validation: Dictionary = G00.validate_contract()
	_check("G00 layout contract remains valid", bool(g00_validation.get("success", false)), str(g00_validation.get("errors", [])))

	var g15_validation: Dictionary = G15.validate_contract()
	_check("G15 minimap contract remains valid", bool(g15_validation.get("success", false)), str(g15_validation.get("errors", [])))

	var manager = G16.new()
	_check("G16 schema is stable", manager.get_schema() == "pixel_rpg.settlement_01_streaming_manager.v1")
	_check("G16 is data-only RefCounted with no scene-tree parent API", manager is RefCounted and not manager.has_method("get_parent"))

	var configured: Dictionary = manager.configure()
	_check("G16 configures exactly five SectionInstance owners", bool(configured.get("success", false)) and int(configured.get("section_count", 0)) == 5, str(configured))
	_check("G16 creates no loaded sections before a current section is known", manager.get_loaded_section_ids().is_empty(), str(manager.get_loaded_section_ids()))
	_check("Area 04 shared Main Spine remains always-available infrastructure",
		_array_equal(manager.get_always_loaded_area_ids(), ["SET01_A04_MAIN_CENTRAL_SPINE"]),
		str(manager.get_always_loaded_area_ids())
	)

	var s01: Dictionary = manager.set_current_section("SET01_S01")
	_check("S01 loads current + direct neighbor only",
		bool(s01.get("success", false))
		and _array_equal(manager.get_loaded_section_ids(), ["SET01_S01", "SET01_S02"]),
		str(manager.get_loaded_section_ids())
	)
	_check("S01 transition has no immediate unload candidates", manager.get_pending_unload_ids().is_empty(), str(manager.get_pending_unload_ids()))

	var s01_preload: Dictionary = manager.set_current_section("SET01_S01", "SET01_S03")
	_check("S01 may conservatively preload one two-hop probable-next section through S02",
		bool(s01_preload.get("success", false))
		and _array_equal(manager.get_loaded_section_ids(), ["SET01_S01", "SET01_S02", "SET01_S03"]),
		str(manager.get_loaded_section_ids())
	)

	var protected_result: Dictionary = manager.set_protected_section_ids(["SET01_S05"])
	_check("interaction-target protection loads and protects a valid section",
		bool(protected_result.get("success", false))
		and manager.is_section_loaded("SET01_S05")
		and _array_equal(manager.get_protected_section_ids(), ["SET01_S05"]),
		str(protected_result)
	)

	var center_result: Dictionary = manager.set_current_section("SET01_S02")
	_check("central S02 keeps all five sections available because all four are direct neighbors",
		bool(center_result.get("success", false))
		and _array_equal(manager.get_loaded_section_ids(), ["SET01_S01", "SET01_S02", "SET01_S03", "SET01_S04", "SET01_S05"]),
		str(manager.get_loaded_section_ids())
	)
	_check("central S02 produces no pending unload churn", manager.get_pending_unload_ids().is_empty(), str(manager.get_pending_unload_ids()))

	var west_result: Dictionary = manager.set_current_section("SET01_S03")
	_check("moving to west S03 keeps S02 + protected S05 desired",
		bool(west_result.get("success", false))
		and _array_equal(manager.get_desired_loaded_section_ids(), ["SET01_S02", "SET01_S03", "SET01_S05"]),
		str(manager.get_desired_loaded_section_ids())
	)
	_check("distant sections are pending rather than immediately unloaded",
		_array_equal(manager.get_pending_unload_ids(), ["SET01_S01", "SET01_S04"]),
		str(manager.get_pending_unload_ids())
	)
	_check("pending sections remain loaded until safe-delay commit", manager.is_section_loaded("SET01_S01") and manager.is_section_loaded("SET01_S04"))

	var commit_result: Dictionary = manager.commit_pending_unloads()
	_check("safe-delay commit unloads only distant unprotected sections",
		bool(commit_result.get("success", false))
		and _array_equal(commit_result.get("unloaded_section_ids", []), ["SET01_S01", "SET01_S04"])
		and _array_equal(manager.get_loaded_section_ids(), ["SET01_S02", "SET01_S03", "SET01_S05"]),
		str(commit_result)
	)
	_check("current section is never unloaded", manager.is_section_loaded("SET01_S03"))
	_check("protected interaction section is never unloaded", manager.is_section_loaded("SET01_S05"))

	var clear_protection: Dictionary = manager.set_protected_section_ids([])
	_check("clearing protection marks now-distant S05 pending without immediate removal",
		bool(clear_protection.get("success", false))
		and _array_equal(manager.get_pending_unload_ids(), ["SET01_S05"])
		and manager.is_section_loaded("SET01_S05"),
		str(clear_protection)
	)
	manager.commit_pending_unloads()
	_check("safe-delay commit removes formerly protected distant S05",
		_array_equal(manager.get_loaded_section_ids(), ["SET01_S02", "SET01_S03"]),
		str(manager.get_loaded_section_ids())
	)

	var invalid_before := manager.get_runtime_snapshot()
	var invalid: Dictionary = manager.set_current_section("SET01_UNKNOWN")
	_check("unknown current section is rejected", not bool(invalid.get("success", true)))
	_check("invalid transition leaves runtime state unchanged", manager.get_runtime_snapshot() == invalid_before)

	var probable: Dictionary = manager.set_current_section("SET01_S03", "SET01_S04")
	_check("outer S03 may preload outer S04 through shared neighbor S02",
		bool(probable.get("success", false))
		and _array_equal(manager.get_desired_loaded_section_ids(), ["SET01_S02", "SET01_S03", "SET01_S04"]),
		str(probable)
	)
	manager.commit_pending_unloads()
	var snapshot := manager.get_runtime_snapshot()

	var restored = G16.new()
	var restored_config: Dictionary = restored.configure()
	_check("fresh G16 manager configures for runtime-state restoration", bool(restored_config.get("success", false)))
	var restore_result: Dictionary = restored.restore_runtime_snapshot(snapshot)
	_check("G16 runtime lifecycle snapshot restores deterministically", bool(restore_result.get("success", false)), str(restore_result))
	_check("restored current section matches exactly", restored.get_current_section_id() == manager.get_current_section_id())
	_check("restored probable-next section matches exactly", restored.get_probable_next_section_id() == manager.get_probable_next_section_id())
	_check("restored loaded section set matches exactly", restored.get_loaded_section_ids() == manager.get_loaded_section_ids(), "%s vs %s" % [restored.get_loaded_section_ids(), manager.get_loaded_section_ids()])
	_check("restored pending-unload set matches exactly", restored.get_pending_unload_ids() == manager.get_pending_unload_ids())
	_check("restored protected set matches exactly", restored.get_protected_section_ids() == manager.get_protected_section_ids())

	var bad_protected := restored.set_protected_section_ids(["SET01_UNKNOWN"])
	_check("unknown protected interaction section is rejected", not bool(bad_protected.get("success", true)))

	var all_ids := restored.get_section_ids()
	var unique: Dictionary = {}
	for section_id in all_ids:
		unique[section_id] = true
	_check("G16 maintains exactly one lifecycle instance per section", all_ids.size() == 5 and unique.size() == 5, str(all_ids))

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G16_CONSERVATIVE_STREAMING_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G16_CONSERVATIVE_STREAMING_FAILED")
	print("This gate verifies conservative Settlement 01 section lifecycle intent: current + neighbors, optional one-hop-ahead preload, protected interaction sections, delayed unload commit, one instance per section, shared Area 04 availability and deterministic runtime-state restoration. It does not destroy/load scene nodes, cut Settlement 01 into the production world, implement durable save persistence, or prove device pop/performance.")
	quit(0 if failures.is_empty() else 1)
