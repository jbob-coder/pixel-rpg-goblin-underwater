extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
const G05 := preload("res://scripts/world/settlement/settlement_01_residential_graybox.gd")
const G06 := preload("res://scripts/world/settlement/settlement_01_work_support_graybox.gd")
const G07 := preload("res://scripts/world/settlement/settlement_01_worker_passage_graybox.gd")
const G08 := preload("res://scripts/world/settlement/settlement_01_south_gate_graybox.gd")
const G09 := preload("res://scripts/world/settlement/settlement_01_security_graybox.gd")
const G10 := preload("res://scripts/world/settlement/settlement_01_logistics_graybox.gd")
const G11 := preload("res://scripts/world/settlement/settlement_01_hunter_staging_graybox.gd")
const G12 := preload("res://scripts/world/settlement/settlement_01_north_gate_graybox.gd")
const G13 := preload("res://scripts/world/settlement/settlement_01_perimeter_streetscape_graybox.gd")
const G14 := preload("res://scripts/world/settlement/settlement_01_npc_schedule_contract.gd")
const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

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
	print("Pixel RPG Settlement 01 G14 — NPC anchor + simple schedule gate")

	_check("G14 schema is stable", G14.get_schema() == "pixel_rpg.settlement_01_npc_schedule_contract.v1")

	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var contract_validation: Dictionary = G14.validate_contract()
	_check("G14 NPC/schedule contract validates", bool(contract_validation.get("success", false)), str(contract_validation.get("errors", [])))
	_check("G14 defines seven authored NPC identities", int(contract_validation.get("npc_count", 0)) == 7, str(contract_validation))
	_check("G14 defines 27 unique stable anchor IDs", int(contract_validation.get("anchor_id_count", 0)) == 27, str(contract_validation))
	_check("G14 unloaded policy is abstract schedule state", String(contract_validation.get("unloaded_policy", "")) == "ABSTRACT_SCHEDULE_STATE")

	var npc_specs: Dictionary = G14.get_npc_specs()
	var npc_ids: Array[String] = G14.get_npc_ids()
	_check("G14 returns seven sorted NPC IDs", npc_ids.size() == 7)
	for npc_id in npc_ids:
		var npc := npc_specs[npc_id] as Dictionary
		_check("%s presentation does not own durable state" % npc_id, not bool(npc.get("presentation_owns_durable_state", true)))
		_check("%s uses abstract unloaded state policy" % npc_id, String(npc.get("unloaded_policy", "")) == "ABSTRACT_SCHEDULE_STATE")

	var host := Node3D.new()
	host.name = "G14IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base builds", base_root != null)
	if base_root == null:
		host.queue_free()
		await process_frame
		_finish()
		return

	_check("G02 plaza builds", G02.add_plaza(base_root).get("root") != null)
	_check("G03 Smith builds", G03.add_smith(base_root).get("smith") != null)
	_check("G04 Community Hall builds", G04.add_community_hall(base_root).get("hall") != null)

	var g05: Dictionary = G05.add_residences(base_root)
	_check("G05 residences build", g05.get("residence_w02") != null and g05.get("residence_w01") != null)

	var g06: Dictionary = G06.add_work_support(base_root)
	_check("G06 work support builds", g06.get("canopy") != null and g06.get("storage") != null)

	_check("G07 worker passage builds", G07.add_worker_passage(base_root).get("root") != null)

	var g08: Dictionary = G08.add_south_gate(base_root)
	_check("G08 South Gate builds", g08.get("gatehouse") != null and g08.get("watch") != null)

	var g09: Dictionary = G09.add_security(base_root)
	_check("G09 Security builds", g09.get("barracks") != null and g09.get("canopy") != null)

	var g10: Dictionary = G10.add_logistics(base_root)
	_check("G10 Logistics builds", g10.get("storage") != null and g10.get("awning") != null)

	_check("G11 Hunter Staging builds", G11.add_hunter_staging(base_root).get("root") != null)

	var g12: Dictionary = G12.add_north_gate(base_root)
	_check("G12 North Gate builds", g12.get("watch") != null and g12.get("cache") != null)

	_check("G13 Perimeter/Streetscape builds", G13.add_perimeter_streetscape(base_root).get("root") != null)

	await process_frame

	var runtime_validation: Dictionary = G14.validate_runtime_anchors(base_root)
	_check("G14 resolves every authored anchor in the isolated G01-G13 settlement", bool(runtime_validation.get("success", false)), str(runtime_validation.get("errors", [])))
	_check("G14 resolves exactly 27 authored anchor bindings", int(runtime_validation.get("resolved_anchor_count", 0)) == 27, str(runtime_validation))

	for npc_id in npc_ids:
		var npc := npc_specs[npc_id] as Dictionary
		var anchors := npc.get("anchors", {}) as Dictionary
		for anchor_key_variant in anchors.keys():
			var anchor_key := String(anchor_key_variant)
			var marker := G14.resolve_anchor(base_root, npc_id, anchor_key)
			_check("%s/%s resolves to Marker3D" % [npc_id, anchor_key], marker != null)

	var guard_off := G14.get_schedule_segment("SET01_NPC_SECURITY_GUARD_01", 120)
	_check("security guard night state is abstract/off-duty",
		String(guard_off.get("state", "")) == "OFF_DUTY"
		and String(guard_off.get("mode", "")) == G14.MODE_ABSTRACT
		and String(guard_off.get("anchor_key", "")).is_empty()
	)

	var guard_duty := G14.get_schedule_segment("SET01_NPC_SECURITY_GUARD_01", 600)
	_check("security guard daytime duty binds authored duty anchor",
		String(guard_duty.get("state", "")) == "DUTY"
		and String(guard_duty.get("mode", "")) == G14.MODE_ANCHORED
		and String(guard_duty.get("anchor_key", "")) == "duty"
	)

	var resident_rest := G14.get_schedule_segment("SET01_NPC_RESIDENT_W01_01", 60)
	_check("resident W01 night state remains anchored to authored home rest",
		String(resident_rest.get("state", "")) == "REST"
		and String(resident_rest.get("anchor_key", "")) == "rest"
	)

	var warden_bounty := G14.get_schedule_segment("SET01_NPC_HUNTER_WARDEN_01", 780)
	_check("Hunter Warden midday schedule reaches A11 bounty anchor",
		String(warden_bounty.get("state", "")) == "BOUNTY_CHECK"
		and String(warden_bounty.get("anchor_key", "")) == "bounty"
	)

	var wrapped := G14.get_schedule_segment("SET01_NPC_QUARTERMASTER_01", 1500)
	_check("schedule lookup wraps minute-of-day deterministically",
		String(wrapped.get("state", "")) == "OFF_DUTY"
		and String(wrapped.get("mode", "")) == G14.MODE_ABSTRACT
	)

	var npc_bodies := base_root.find_children("*", "CharacterBody3D", true, false)
	_check("G14 contract adds no NPC CharacterBody simulation", npc_bodies.is_empty(), "count=%d" % npc_bodies.size())

	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G14_NPC_ANCHORS_SCHEDULES_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G14_NPC_ANCHORS_SCHEDULES_FAILED")
	print("This gate verifies stable NPC IDs, unique stable anchor IDs, runtime binding against the isolated G01-G13 settlement, deterministic full-day authored schedules, abstract unloaded/off-duty states, and zero NPC CharacterBody simulation. NPC presentation, relationship persistence, pathfinding, production-world cutover, final visuals and device acceptance remain outside G14.")
	quit(0 if failures.is_empty() else 1)
