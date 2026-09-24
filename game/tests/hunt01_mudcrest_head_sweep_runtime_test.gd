extends SceneTree

const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const ATTACK_ID := "M01_HEAD_SWEEP_GORE"
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
	print("Hunt-01 Mudcrest Head Sweep hostile attack runtime")
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
	var monster := world.get_node("WorldGeometry/monster_r01_m01_0001") as Node3D
	var tracking := world.get_node("TrackingRuntime")
	var encounter := world.get_node("EncounterRuntime")
	_check("tracking prerequisite resolves", await _record_tracking(tracking))
	_check("tracking reaches observation-ready", String((tracking.call("get_current_inference") as Dictionary).get("phase", "")) == "OBSERVATION_READY")
	await _settle_hunter(hunter, Vector3(-72.0, 0.875, -236.0))
	_check("physical engagement is available", String(encounter.call("get_state")) == "ENGAGEMENT_AVAILABLE", String(encounter.call("get_state")))
	var monster_before := monster.global_transform
	_check("explicit ENGAGE starts combat stack", bool(encounter.call("engage_for_test")))
	_check("encounter reports Mudcrest attack runtime started", bool(encounter.call("has_mudcrest_attack_started")))

	var shell := encounter.call("get_combat_turn_shell") as Node
	var movement := encounter.call("get_tactical_movement_runtime") as Node
	var reaction := encounter.call("get_reaction_window_runtime") as Node
	var anatomy := encounter.call("get_mudcrest_anatomy_runtime") as Node
	var mudcrest_attack := encounter.call("get_mudcrest_attack_runtime") as Node
	_check("combat dependencies exist", shell != null and movement != null and reaction != null and anatomy != null and mudcrest_attack != null)
	if shell == null or movement == null or reaction == null or anatomy == null or mudcrest_attack == null:
		_finish()
		return

	# Let the production driver's deliberately deferred registration settle.
	await process_frame
	_check("Mudcrest attack schema v1", String(mudcrest_attack.call("get_schema")) == "uhr.hunt01.mudcrest_attack.v1")
	_check("Head Sweep technical identity is stable", String(mudcrest_attack.call("get_attack_id")) == ATTACK_ID)
	_check("real Monster activation driver registers", bool(mudcrest_attack.call("is_driver_registered")))
	_check("working-melee fixture reuses 3.5 m body-envelope boundary", is_equal_approx(float(mudcrest_attack.call("get_working_melee_limit_m")), 3.5))
	_check("telegraph asset is absent before a legal hostile attack", get_nodes_in_group("hunt01_monster_attack_telegraph").is_empty())

	# Round 1: Hunter remains at N01. The first bounded Monster driver has no legal
	# Head Sweep and deterministically completes without inventing another attack.
	_check("ending Round-1 Hunter activation succeeds", bool(shell.call("end_player_turn")))
	var state: Dictionary = shell.call("get_current_state")
	_check("out-of-range Head Sweep does not stall scheduler", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("out-of-range skip commits no Mudcrest attack sequence", int(mudcrest_attack.call("get_attack_sequence")) == 0)
	_check("out-of-range skip emits no reaction telegraph", String(reaction.call("get_state")) == "IDLE" and get_nodes_in_group("hunt01_monster_attack_telegraph").is_empty())

	# Round 2: use the real authored tactical graph to approach the practical
	# working-melee node. No teleport or fake arena is introduced.
	_check("N01 -> N04 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N04")))
	_check("N04 -> N07 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N07")))
	_check("N07 -> N09 move succeeds", bool(movement.call("move_for_test", "R01_EF02_N09")))
	_check("Hunter reaches authored N09", String(movement.call("get_current_node_id")) == "R01_EF02_N09" and hunter.global_position.distance_to(Vector3(-22.0, 0.875, -238.0)) < 0.001, str(hunter.global_position))
	# move_for_test can commit several authored moves in one script slice. Give
	# CharacterBody3D one physics boundary so the hostile cover ray observes the
	# same N09 transform that real frame-separated player movement would expose.
	await physics_frame
	await process_frame
	_check("ending Hunter turn delegates real close-range Monster activation", bool(shell.call("end_player_turn")))

	state = shell.call("get_current_state")
	_check("Monster remains current while reaction window is open", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == MONSTER_ID, str(state))
	var active_attack: Dictionary = mudcrest_attack.call("get_active_attack")
	_check("Head Sweep commits and waits for reaction", String(active_attack.get("state", "")) == "WAITING_REACTION_DECISION" and String(active_attack.get("attack_id", "")) == ATTACK_ID, str(active_attack))
	var monster_resources: Dictionary = shell.call("get_resource_state", MONSTER_ID)
	_check("Head Sweep spends exactly 2 AP / 14 Stamina", int(monster_resources.get("ap", -1)) == 2 and int(monster_resources.get("stamina", -1)) == 86, str(monster_resources))
	var legality: Dictionary = active_attack.get("legality_snapshot", {})
	_check("Head Sweep passed close-range body-envelope gate", float(legality.get("body_envelope_distance_m", 99.0)) <= 3.5, str(legality))
	_check("Head Sweep passed front/front-flank bearing gate", float(legality.get("bearing_dot", -1.0)) >= 0.0, str(legality))
	_check("Head Sweep passed physical line/cover gate", String((legality.get("line_of_effect", {}) as Dictionary).get("reason", "")) == "CLEAR_TO_HUNTER_BODY", str(legality))
	_check("authoritative visual telegraph is present during reaction", bool(mudcrest_attack.call("is_telegraph_visible")) and get_nodes_in_group("hunt01_monster_attack_telegraph").size() == 1)

	var window: Dictionary = reaction.call("get_active_window")
	var window_id := String(window.get("window_id", ""))
	_check("real hostile action opens stable reaction window", String(window.get("source_action_id", "")) == ATTACK_ID and not window_id.is_empty(), str(window))
	var hunter_before_block: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	var committed: Dictionary = reaction.call("commit_reaction", window_id, REACTION_BLOCK)
	_check("Field Poleblade Block commits against Head Sweep", bool(committed.get("success", false)), str(committed))
	var hunter_after_block: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("Block consumes exactly 1 RP + 6 Stamina out of turn", int(hunter_after_block.get("rp", -1)) == int(hunter_before_block.get("rp", -1)) - 1 and int(hunter_after_block.get("stamina", -1)) == int(hunter_before_block.get("stamina", -1)) - 6, str(hunter_after_block))
	await process_frame
	await process_frame

	var first_resolution: Dictionary = mudcrest_attack.call("get_last_resolution")
	_check("Head Sweep resolves one hostile contact transaction", bool(first_resolution.get("success", false)) and String(first_resolution.get("status", "")) == "HOSTILE_CONTACT_RESOLVED_DAMAGE_PENDING", str(first_resolution))
	_check("Block participates in deterministic hostile resolution", bool(first_resolution.get("block_commitment_applied", false)) and int(first_resolution.get("block_defense_control_bonus", 0)) == 8, str(first_resolution))
	_check("first deterministic Blocked Head Sweep is SOLID", String(first_resolution.get("hit_quality", "")) == "SOLID" and int(first_resolution.get("variance_sample", 99)) == 5, str(first_resolution))
	_check("contact routes through directional Field Poleblade guard", String(first_resolution.get("protection_route", "")) == "FIELD_POLEBLADE_DIRECTIONAL_GUARD", str(first_resolution))
	var first_handoff: Dictionary = first_resolution.get("damage_handoff", {})
	_check("stable pending Hunter-damage handoff is emitted", String(first_handoff.get("status", "")) == "PENDING_HUNTER_DAMAGE_RUNTIME" and not String(first_handoff.get("resolution_id", "")).is_empty(), str(first_handoff))
	_check("final Hunter damage amount is not invented", not first_handoff.has("damage_amount") and String(first_handoff.get("final_damage_amount_status", "")) == "NOT_SELECTED_PENDING_HUNTER_DAMAGE_RUNTIME", str(first_handoff))
	_check("selected 10-Stamina Block impact profile is recorded but not prematurely applied", int(first_handoff.get("standard_block_impact_drain_stamina", -1)) == 10 and String(first_handoff.get("guard_impact_drain_status", "")) == "PENDING_FINAL_BLOCK_OUTCOME_RUNTIME", str(first_handoff))
	_check("reaction closes after hostile handoff", String(reaction.call("get_state")) == "IDLE")
	await process_frame
	_check("telegraph visual disappears after resolution", not bool(mudcrest_attack.call("is_telegraph_visible")) and get_nodes_in_group("hunt01_monster_attack_telegraph").is_empty())
	state = shell.call("get_current_state")
	_check("scheduler advances to Round-3 Hunter after one damaging Monster attack", int(state.get("round_id", 0)) == 3 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("stable resolution readback does not reroll", mudcrest_attack.call("get_resolution", String(first_resolution.get("resolution_id", ""))) == first_resolution)

	# Round 3: explicit decline must remain a real free choice and produce a second
	# distinct deterministic transaction without changing actor transforms.
	var hunter_before_decline: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("ending Round-3 Hunter turn opens second Head Sweep", bool(shell.call("end_player_turn")))
	window = reaction.call("get_active_window")
	var second_window_id := String(window.get("window_id", ""))
	_check("second Head Sweep uses a new reaction transaction", not second_window_id.is_empty() and second_window_id != window_id, str(window))
	var declined: Dictionary = reaction.call("decline_reaction", second_window_id)
	_check("explicit decline is accepted", bool(declined.get("success", false)), str(declined))
	_check("decline spends no Hunter reaction resources", int(declined.get("rp_cost", -1)) == 0 and int(declined.get("stamina_cost", -1)) == 0, str(declined))
	await process_frame
	await process_frame
	var second_resolution: Dictionary = mudcrest_attack.call("get_last_resolution")
	_check("declined Head Sweep creates a second stable hostile transaction", int(second_resolution.get("action_sequence", 0)) == 2 and String(second_resolution.get("reaction_id", "")) == "DECLINE_REACTION", str(second_resolution))
	_check("declined deterministic Head Sweep is SOLID", String(second_resolution.get("hit_quality", "")) == "SOLID" and int(second_resolution.get("variance_sample", 99)) == -4, str(second_resolution))
	_check("decline routes contact to pending body protection instead of guard", String(second_resolution.get("protection_route", "")) == "HUNTER_BODY_PROTECTION_PENDING_RUNTIME", str(second_resolution))
	_check("decline did not directly spend RP/Stamina before next activation recovery", int(hunter_before_decline.get("rp", -1)) == 1)

	_check("Mudcrest anatomy is unchanged by incoming Hunter-damage handoffs", int(anatomy.call("get_applied_resolution_count")) == 0)
	_check("Monster world transform is unchanged by state-only attack resolution", monster.global_transform.is_equal_approx(monster_before), str(monster.global_position))
	_check("Hunter remains on authored N09 because forced displacement is deferred", hunter.global_position.distance_to(Vector3(-22.0, 0.875, -238.0)) < 0.001, str(hunter.global_position))
	_check("exactly two legal Head Sweeps were committed", int(mudcrest_attack.call("get_attack_sequence")) == 2)

	var trace: Array = mudcrest_attack.call("get_trace")
	_check("attack trace records out-of-range skip", _has_event(trace, "MUDCREST_HEAD_SWEEP_SKIPPED"))
	_check("attack trace records telegraph", _has_event(trace, "MUDCREST_HEAD_SWEEP_TELEGRAPH_EMITTED"))
	_check("attack trace records committed Hunter-damage handoff", _has_event(trace, "MUDCREST_HEAD_SWEEP_RESOLUTION_HANDOFF_COMMITTED"))

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME_FAILED")
	print("Final Hunter HP/damage arithmetic, final Block outcome, break/sever/status, other Mudcrest attacks, behavior, phone acceptance and performance are not claimed by this gate.")
	quit(0 if failures.is_empty() else 1)
