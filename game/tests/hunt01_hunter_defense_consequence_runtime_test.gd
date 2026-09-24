extends SceneTree

const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const REACTION_BLOCK := "POLEBLADE_BLOCK"

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _settle_hunter(hunter: CharacterBody3D, position: Vector3) -> void:
	hunter.global_position = position
	hunter.velocity = Vector3.ZERO
	for _frame in range(8):
		await physics_frame
		await process_frame

func _record_tracking(tracking: Node) -> bool:
	var evidence_ids := [
		"R01_H01_EV01_OUTER_PRINTS",
		"R01_H01_EV02_BANK_REEDS",
		"R01_H01_EV03_FRESH_WALLOW",
		"R01_H01_EV05_OLD_ROOT_SCRAPE",
		"R01_H01_EV04_WATER_EXIT",
		"R01_H01_EV06_FEEDING_REMAINS",
		"R01_H01_EV07_FLATTENED_GRASS_AUDIO",
	]
	for evidence_id in evidence_ids:
		if not bool(tracking.call("record_evidence_for_test", evidence_id)):
			return false
		await process_frame
	return int(tracking.call("get_collected_count")) == 7

func _has_event(trace: Array, event_name: String) -> bool:
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) == event_name:
			return true
	return false

func _run() -> void:
	print("Hunt-01 Hunter defense consequence runtime")
	var packed := load("res://scenes/regions/region_01_hunt01_graybox.tscn") as PackedScene
	if packed == null:
		_check("production Region-01 scene loads", false)
		_finish()
		return

	var world := packed.instantiate() as Node3D
	root.add_child(world)
	for _frame in range(4):
		await process_frame
		await physics_frame

	var hunter := world.get_node("Hunter") as CharacterBody3D
	var tracking := world.get_node("TrackingRuntime")
	var encounter := world.get_node("EncounterRuntime")
	_check("tracking prerequisite resolves", await _record_tracking(tracking))
	await _settle_hunter(hunter, Vector3(-72.0, 0.875, -236.0))
	_check("engagement becomes available", String(encounter.call("get_state")) == "ENGAGEMENT_AVAILABLE", String(encounter.call("get_state")))
	_check("ENGAGE starts production combat stack", bool(encounter.call("engage_for_test")))

	var shell := encounter.call("get_combat_turn_shell") as Node
	var movement := encounter.call("get_tactical_movement_runtime") as Node
	var reaction := encounter.call("get_reaction_window_runtime") as Node
	var mudcrest_attack := encounter.call("get_mudcrest_attack_runtime") as Node
	_check("production combat dependencies exist", shell != null and movement != null and reaction != null and mudcrest_attack != null)
	if shell == null or movement == null or reaction == null or mudcrest_attack == null:
		_finish()
		return
	await process_frame

	var defense := mudcrest_attack.call("get_hunter_defense_runtime") as Node
	_check("generic Hunter defense runtime is integrated", defense != null and bool(defense.call("is_initialized")))
	if defense == null:
		_finish()
		return
	_check("Hunter defense schema v1", String(defense.call("get_schema")) == "uhr.hunt01.hunter_defense_consequence.v1")
	_check("Block outcome fixture is explicitly provisional", String(defense.call("get_fixture_status")) == "PROVISIONAL_FIRST_SLICE_POLEBLADE_BLOCK_OUTCOME_FIXTURE")

	# Round 1 stays at N01, preserving the verified no-legal-Head-Sweep path.
	_check("Round-1 Hunter turn can end", bool(shell.call("end_player_turn")))
	var state: Dictionary = shell.call("get_current_state")
	_check("out-of-range Monster activation advances to Round 2 Hunter", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))

	_check("N01 -> N04", bool(movement.call("move_for_test", "R01_EF02_N04")))
	_check("N04 -> N07", bool(movement.call("move_for_test", "R01_EF02_N07")))
	_check("N07 -> N09", bool(movement.call("move_for_test", "R01_EF02_N09")))
	await physics_frame
	await process_frame
	_check("Round-2 Hunter end opens real Head Sweep", bool(shell.call("end_player_turn")))
	var window: Dictionary = reaction.call("get_active_window")
	var window_id := String(window.get("window_id", ""))
	_check("real Head Sweep reaction window opens", not window_id.is_empty(), str(window))
	var before_block: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	var block_commit: Dictionary = reaction.call("commit_reaction", window_id, REACTION_BLOCK)
	_check("Poleblade Block commits", bool(block_commit.get("success", false)), str(block_commit))
	_check("base Block commitment spends 6 Stamina", int((shell.call("get_resource_state", HUNTER_ID) as Dictionary).get("stamina", -1)) == int(before_block.get("stamina", -1)) - 6)
	await process_frame
	await process_frame

	var attack_resolution: Dictionary = mudcrest_attack.call("get_last_resolution")
	var source_handoff: Dictionary = attack_resolution.get("damage_handoff", {}) as Dictionary
	var defense_result: Dictionary = attack_resolution.get("defense_consequence", {}) as Dictionary
	_check("Head Sweep source handoff remains stable", String(source_handoff.get("status", "")) == "PENDING_HUNTER_DAMAGE_RUNTIME" and not String(source_handoff.get("resolution_id", "")).is_empty(), str(source_handoff))
	_check("defense consequence resolves before activation completion", bool(defense_result.get("success", false)) and String(defense_result.get("status", "")) == "HUNTER_DEFENSE_CONSEQUENCE_RESOLVED_HEALTH_PENDING", str(defense_result))
	_check("SOLID fully-funded first-slice Poleblade Block is BLOCK_STRONG", String(defense_result.get("block_outcome", "")) == "BLOCK_STRONG" and String(defense_result.get("hit_quality", "")) == "SOLID", str(defense_result))
	_check("Head Sweep applies selected 10-Stamina guard-impact drain", int(defense_result.get("guard_impact_requested_stamina", -1)) == 10 and int(defense_result.get("guard_impact_applied_stamina", -1)) == 10 and bool(defense_result.get("guard_impact_fully_paid", false)), str(defense_result))
	_check("impact drain is separate from Block commitment", int(defense_result.get("hunter_stamina_before_impact", -1)) == 94 and int(defense_result.get("hunter_stamina_after_impact", -1)) == 84, str(defense_result))
	var health_handoff: Dictionary = defense_result.get("health_handoff", {}) as Dictionary
	_check("final health/injury remains an explicit downstream handoff", String(health_handoff.get("status", "")) == "PENDING_HUNTER_HEALTH_INJURY_RUNTIME" and not health_handoff.has("damage_amount"), str(health_handoff))
	_check("defense runtime never invents final health damage", String(defense_result.get("final_health_damage_status", "")) == "NOT_SELECTED_PENDING_HUNTER_HEALTH_INJURY_RUNTIME")

	state = shell.call("get_current_state")
	var round3_hunter: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("Monster activation completes only after defense consequence", int(state.get("round_id", 0)) == 3 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("Round-3 passive recovery follows 6+10 Stamina defense spend", int(round3_hunter.get("stamina", -1)) == 94 and int(round3_hunter.get("rp", -1)) == 1, str(round3_hunter))

	var resources_before_replay := round3_hunter.duplicate(true)
	var replay: Dictionary = defense.call("resolve_hostile_handoff", source_handoff)
	_check("same hostile resolution readback is exact/idempotent", replay == defense_result)
	_check("replay cannot drain Stamina twice", shell.call("get_resource_state", HUNTER_ID) == resources_before_replay)

	var no_contact_handoff := source_handoff.duplicate(true)
	no_contact_handoff["resolution_id"] = "%s:NO_CONTACT_FIXTURE" % String(source_handoff.get("resolution_id", ""))
	no_contact_handoff["contact_class"] = "NO_CONTACT"
	no_contact_handoff["hit_quality"] = "MISS"
	no_contact_handoff["protection_route"] = "NONE_NO_CONTACT"
	no_contact_handoff["reaction_id"] = "DECLINE_REACTION"
	no_contact_handoff["standard_block_impact_drain_stamina"] = 0
	var no_contact: Dictionary = defense.call("resolve_hostile_handoff", no_contact_handoff)
	_check("no-contact hostile handoff resolves with zero consequence", String(no_contact.get("status", "")) == "HUNTER_DEFENSE_NO_CONTACT_RESOLVED" and int(no_contact.get("guard_impact_applied_stamina", -1)) == 0, str(no_contact))
	var no_contact_health: Dictionary = no_contact.get("health_handoff", {}) as Dictionary
	_check("no-contact emits no Hunter health/injury consequence", String(no_contact_health.get("status", "")) == "NO_HUNTER_HEALTH_INJURY_CONSEQUENCE", str(no_contact_health))
	_check("no-contact branch changes no resources", shell.call("get_resource_state", HUNTER_ID) == resources_before_replay)

	_check("two unique defense transactions are stored", int(defense.call("get_applied_resolution_count")) == 2)
	var trace: Array = defense.call("get_trace")
	_check("defense trace records Block consequence", _has_event(trace, "HUNTER_DEFENSE_BLOCK_RESOLVED"))
	_check("defense trace records no-contact consequence", _has_event(trace, "HUNTER_DEFENSE_NO_CONTACT_RESOLVED"))
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_FAILED")
	print("Final Hunter Max Health/damage/wound arithmetic, final Block balance, forced movement/status, other reactions and other Mudcrest attacks are not claimed by this gate.")
	quit(0 if failures.is_empty() else 1)
