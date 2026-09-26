extends SceneTree

const G00 := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const G16 := preload("res://scripts/world/settlement/settlement_01_streaming_manager.gd")
const G17 := preload("res://scripts/world/settlement/settlement_01_persistence_contract.gd")
const OWNERSHIP := preload("res://scripts/state/pixel_rpg_state_ownership_contract.gd")

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
	print("Pixel RPG Settlement 01 G17 — persistence-hook contract gate")

	var g00_validation: Dictionary = G00.validate_contract()
	_check("G00 layout contract remains valid", bool(g00_validation.get("success", false)), str(g00_validation.get("errors", [])))
	var ownership_validation: Dictionary = OWNERSHIP.validate_contract()
	_check("state ownership contract remains valid", bool(ownership_validation.get("success", false)), str(ownership_validation.get("errors", [])))

	_check("G17 schema is stable", G17.get_schema() == "pixel_rpg.settlement_01_persistence_contract.v1")
	_check("G17 snapshot schema is stable", G17.get_snapshot_schema_id() == "PIXEL_RPG_SETTLEMENT_01_WORLD_STATE")
	_check("G17 snapshot version begins at 1", G17.get_snapshot_version() == 1)
	_check("G17 targets reserved durable.world_state owner", G17.get_target_owner_id() == "durable.world_state")
	_check("world.section_state remains assigned to durable.world_state",
		String(OWNERSHIP.get_datum_spec("world.section_state").get("owner_id", "")) == "durable.world_state"
	)

	var settlement_flags_a := {
		"weather_phase": "CLEAR",
		"south_gate_open": true,
	}
	var section_flags_a := {
		"SET01_S05": {"hunter_exit_warning_active": true},
		"SET01_S01": {"arrival_security_alert": false},
	}
	var building_flags_a := {
		"SET01_BLD_SMITH": {"service_enabled": true},
		"SET01_BLD_COMMUNITY_HALL": {"local_event_state": "IDLE"},
	}

	var built_a: Dictionary = G17.build_snapshot(settlement_flags_a, section_flags_a, building_flags_a)
	_check("G17 builds a valid stable-ID world snapshot", bool(built_a.get("success", false)), str(built_a.get("errors", [])))
	var snapshot_a := built_a.get("snapshot", {}) as Dictionary
	var validation_a: Dictionary = G17.validate_snapshot(snapshot_a)
	_check("G17 validates its generated snapshot", bool(validation_a.get("success", false)), str(validation_a.get("errors", [])))
	_check("G17 snapshot contains all five stable section records", int(validation_a.get("section_record_count", 0)) == 5, str(validation_a))
	_check("G17 snapshot contains all twelve stable building records", int(validation_a.get("building_record_count", 0)) == 12, str(validation_a))

	var payload_a := snapshot_a.get("payload", {}) as Dictionary
	_check("G17 persists only settlement/world payload namespaces",
		payload_a.keys().size() == 3
		and payload_a.has("settlement_flags")
		and payload_a.has("section_records")
		and payload_a.has("building_records"),
		str(payload_a.keys())
	)
	_check("G17 snapshot excludes camera/input/HUD/targeting state",
		not snapshot_a.has("camera")
		and not snapshot_a.has("input")
		and not snapshot_a.has("hud")
		and not snapshot_a.has("targeting")
	)
	_check("G17 snapshot excludes streaming lifecycle state",
		not snapshot_a.has("loaded_section_ids")
		and not snapshot_a.has("pending_unload_ids")
		and not payload_a.has("streaming")
	)
	_check("G17 snapshot excludes player/combat/inventory/economy/NPC-relationship ownership",
		not payload_a.has("player")
		and not payload_a.has("combat")
		and not payload_a.has("inventory")
		and not payload_a.has("economy")
		and not payload_a.has("npc_relationships")
	)

	var section_records := payload_a.get("section_records", {}) as Dictionary
	var smith_record := (payload_a.get("building_records", {}) as Dictionary).get("SET01_BLD_SMITH", {}) as Dictionary
	_check("authored S01 section flag survives snapshot build",
		bool(((section_records.get("SET01_S01", {}) as Dictionary).get("flags", {}) as Dictionary).get("arrival_security_alert", true)) == false
	)
	_check("authored Smith service flag survives snapshot build",
		bool((smith_record.get("flags", {}) as Dictionary).get("service_enabled", false))
	)

	var settlement_flags_b := {
		"south_gate_open": true,
		"weather_phase": "CLEAR",
	}
	var section_flags_b := {
		"SET01_S01": {"arrival_security_alert": false},
		"SET01_S05": {"hunter_exit_warning_active": true},
	}
	var building_flags_b := {
		"SET01_BLD_COMMUNITY_HALL": {"local_event_state": "IDLE"},
		"SET01_BLD_SMITH": {"service_enabled": true},
	}
	var built_b: Dictionary = G17.build_snapshot(settlement_flags_b, section_flags_b, building_flags_b)
	_check("alternate input insertion order also builds", bool(built_b.get("success", false)), str(built_b.get("errors", [])))
	var canonical_a := G17.canonical_json(snapshot_a)
	var canonical_b := G17.canonical_json(built_b.get("snapshot", {}) as Dictionary)
	_check("G17 canonical serialization is deterministic across Dictionary insertion order",
		not canonical_a.is_empty() and canonical_a == canonical_b
	)

	var parsed_variant = JSON.parse_string(canonical_a)
	_check("canonical Settlement 01 snapshot parses from JSON", typeof(parsed_variant) == TYPE_DICTIONARY)
	if typeof(parsed_variant) == TYPE_DICTIONARY:
		var parsed := parsed_variant as Dictionary
		var parsed_validation: Dictionary = G17.validate_snapshot(parsed)
		_check("JSON round-trip snapshot remains valid", bool(parsed_validation.get("success", false)), str(parsed_validation.get("errors", [])))
		_check("JSON round-trip canonical form is deterministic", G17.canonical_json(parsed) == canonical_a)
		var extracted: Dictionary = G17.extract_durable_world_payload(parsed)
		_check("G17 extracts validated durable world payload after round-trip", bool(extracted.get("success", false)), str(extracted.get("errors", [])))

	var unknown_section: Dictionary = G17.build_snapshot({}, {"SET01_UNKNOWN": {"flag": true}}, {})
	_check("unknown section stable ID is rejected", not bool(unknown_section.get("success", true)), str(unknown_section.get("errors", [])))

	var unknown_building: Dictionary = G17.build_snapshot({}, {}, {"SET01_BLD_UNKNOWN": {"flag": true}})
	_check("unknown building stable ID is rejected", not bool(unknown_building.get("success", true)), str(unknown_building.get("errors", [])))

	var runtime_object := RefCounted.new()
	var invalid_runtime_value: Dictionary = G17.build_snapshot({"bad_runtime_object": runtime_object}, {}, {})
	_check("non-serializable runtime objects are rejected", not bool(invalid_runtime_value.get("success", true)), str(invalid_runtime_value.get("errors", [])))

	var extra_key := snapshot_a.duplicate(true)
	extra_key["camera_yaw_pitch"] = [0.1, 0.2]
	var extra_validation: Dictionary = G17.validate_snapshot(extra_key)
	_check("unexpected transient top-level field is rejected", not bool(extra_validation.get("success", true)), str(extra_validation.get("errors", [])))

	var bad_layout := snapshot_a.duplicate(true)
	bad_layout["layout_schema"] = "stale.layout"
	var bad_layout_validation: Dictionary = G17.validate_snapshot(bad_layout)
	_check("snapshot tied to stale layout schema is rejected", not bool(bad_layout_validation.get("success", true)))

	var future_version := snapshot_a.duplicate(true)
	future_version["schema_version"] = 2
	var migration: Dictionary = G17.migrate_snapshot(future_version)
	_check("unsupported future snapshot version fails closed", not bool(migration.get("success", true)), str(migration.get("errors", [])))

	var same_version_migration: Dictionary = G17.migrate_snapshot(snapshot_a)
	_check("current v1 snapshot migration hook validates and returns a copy", bool(same_version_migration.get("success", false)), str(same_version_migration.get("errors", [])))
	_check("current migration hook preserves canonical state",
		G17.canonical_json(same_version_migration.get("snapshot", {}) as Dictionary) == canonical_a
	)

	var streaming = G16.new()
	_check("G16 configures independently from persistence", bool(streaming.configure().get("success", false)))
	streaming.set_current_section("SET01_S01", "SET01_S03")
	var transient_streaming_snapshot := streaming.get_runtime_snapshot()
	_check("G16 lifecycle snapshot contains transient loaded-section state", transient_streaming_snapshot.has("loaded_section_ids"))
	_check("G17 durable snapshot never consumes G16 lifecycle snapshot implicitly",
		not (snapshot_a.get("payload", {}) as Dictionary).has("loaded_section_ids")
		and not (snapshot_a.get("payload", {}) as Dictionary).has("pending_unload_ids")
	)

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G17_PERSISTENCE_HOOKS_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G17_PERSISTENCE_HOOKS_FAILED")
	print("This gate verifies a versioned Settlement 01 durable-world snapshot boundary keyed by locked section/building IDs, deterministic canonical JSON, validation/migration hooks and explicit exclusion of transient control/streaming and unrelated durable-owner domains. It does not write files, implement a global save system, own player/combat/NPC-relationship/inventory/economy state, cut Settlement 01 into production, or prove mobile lifecycle persistence.")
	quit(0 if failures.is_empty() else 1)
