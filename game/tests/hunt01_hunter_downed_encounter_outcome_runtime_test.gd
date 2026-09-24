extends SceneTree

const ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const ATTACK_ID := "M01_HEAD_SWEEP_GORE"
const REACTION_DECLINE := "DECLINE_REACTION"

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

func _health_handoff(resolution_id: String, hit_quality: String) -> Dictionary:
	return {
		"status": "PENDING_HUNTER_HEALTH_INJURY_RUNTIME",
		"resolution_id": resolution_id,
		"encounter_id": ENCOUNTER_ID,
		"attacker_id": MONSTER_ID,
		"defender_id": HUNTER_ID,
		"attack_id": ATTACK_ID,
		"attack_profile": "GORE_SWEEP",
		"damage_channels": ["PIERCING", "IMPACT"],
		"contact_class": "HUNTER_BODY_CONTACT",
		"hit_quality": hit_quality,
		"defense_outcome": "NO_ACTIVE_GUARD",
		"residual_force_status": "HUNTER_BODY_CONTACT",
		"final_damage_amount_status": "NOT_SELECTED",
	}

func _has_event(trace: Array, event_name: String) -> bool:
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) == event_name:
			return true
	return false

func _run() -> void:
	print("Hunt-01 Hunter Downed encounter-outcome runtime")
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
	_check("ENGAGE starts production combat stack", bool(encounter.call("engage_for_test")))

	var shell := encounter.call("get_combat_turn_shell") as Node
	var movement := encounter.call("get_tactical_movement_runtime") as Node
	var reaction := encounter.call("get_reaction_window_runtime") as Node
	var anatomy := encounter.call("get_mudcrest_anatomy_runtime") as Node
	var attack := encounter.call("get_mudcrest_attack_runtime") as Node
	_check("production dependencies exist", shell != null and movement != null and reaction != null and anatomy != null and attack != null)
	if shell == null or movement == null or reaction == null or anatomy == null or attack == null:
		_finish()
		return
	await process_frame

	var defense := attack.call("get_hunter_defense_runtime") as Node
	var health: Node = null
	if defense != null:
		health = defense.call("get_hunter_health_runtime") as Node
	var outcome := attack.call("get_encounter_outcome_runtime") as Node
	_check("generic outcome owner is integrated", outcome != null and bool(outcome.call("is_initialized")))
	if health == null or outcome == null:
		_finish()
		return
	_check("outcome schema v1", String(outcome.call("get_schema")) == "uhr.hunt01.encounter_outcome.v1")
	_check("Hunter and Monster begin ACTIVE", String(outcome.call("get_participation_state", HUNTER_ID)) == "ACTIVE" and String(outcome.call("get_participation_state", MONSTER_ID)) == "ACTIVE")
	_check("shell begins non-terminal", not bool(shell.call("is_encounter_terminal")))

	# Test-only preparation uses the already verified provisional health fixture.
	# It stops at 8 Health; the real production Head Sweep must supply the final
	# authoritative contact and trigger the outcome chain.
	for index in range(7):
		var prep: Dictionary = health.call("resolve_health_handoff", _health_handoff("%s:DOWNED_PREP:CLEAN:%02d" % [ENCOUNTER_ID, index], "CLEAN"))
		_check("preparation CLEAN %d resolves" % index, bool(prep.get("success", false)), str(prep))
	var prep_solid: Dictionary = health.call("resolve_health_handoff", _health_handoff("%s:DOWNED_PREP:SOLID" % ENCOUNTER_ID, "SOLID"))
	_check("preparation SOLID resolves", bool(prep_solid.get("success", false)), str(prep_solid))
	_check("preparation leaves Hunter at exactly 8 Health", int((health.call("get_health_state") as Dictionary).get("health", -1)) == 8, str(health.call("get_health_state")))
	_check("direct health preparation cannot commit encounter outcome", int(outcome.call("get_resolution_count")) == 0 and not bool(shell.call("is_encounter_terminal")))

	# Round 1 remains out of range. Round 2 is moved into the authored Head Sweep position.
	_check("Round-1 Hunter turn can end", bool(shell.call("end_player_turn")))
	var state: Dictionary = shell.call("get_current_state")
	_check("out-of-range Monster activation advances to Round 2 Hunter", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("N01 -> N04", bool(movement.call("move_for_test", "R01_EF02_N04")))
	_check("N04 -> N07", bool(movement.call("move_for_test", "R01_EF02_N07")))
	_check("N07 -> N09", bool(movement.call("move_for_test", "R01_EF02_N09")))
	await physics_frame
	await process_frame
	var head_before: Dictionary = anatomy.call("get_target_state", "HEAD")
	_check("Round-2 Hunter end opens real Head Sweep", bool(shell.call("end_player_turn")))
	var window: Dictionary = reaction.call("get_active_window")
	var window_id := String(window.get("window_id", ""))
	_check("real reaction window opens", not window_id.is_empty(), str(window))
	_check("decline reaction commits", bool((reaction.call("decline_reaction", window_id) as Dictionary).get("success", false)))
	await process_frame
	await process_frame

	var final_attack: Dictionary = attack.call("get_last_resolution")
	var final_defense: Dictionary = final_attack.get("defense_consequence", {}) as Dictionary
	var final_health: Dictionary = final_defense.get("health_injury_consequence", {}) as Dictionary
	var defeat_handoff: Dictionary = final_health.get("defeat_handoff", {}) as Dictionary
	var final_outcome: Dictionary = final_attack.get("encounter_outcome_consequence", {}) as Dictionary
	_check("real Head Sweep supplied final zero-Health consequence", bool(final_health.get("success", false)) and int(final_health.get("health_before", -1)) == 8 and int(final_health.get("health_after", -1)) == 0, str(final_health))
	_check("health emits stable pending defeat handoff", String(defeat_handoff.get("status", "")) == "PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME", str(defeat_handoff))
	_check("production chain commits Hunter defeat outcome", bool(final_outcome.get("success", false)) and String(final_outcome.get("status", "")) == "HUNTER_DEFEAT_OUTCOME_COMMITTED" and String(final_outcome.get("outcome", "")) == "HUNTERS_DEFEATED", str(final_outcome))
	_check("Hunter transitions DOWNED while living Monster remains ACTIVE", String(outcome.call("get_participation_state", HUNTER_ID)) == "DOWNED" and String(outcome.call("get_participation_state", MONSTER_ID)) == "ACTIVE")

	var terminal: Dictionary = shell.call("get_terminal_state")
	state = shell.call("get_current_state")
	_check("shell terminal state is committed for same source resolution", bool(terminal.get("success", false)) and bool(terminal.get("encounter_terminal", false)) and String(terminal.get("outcome", "")) == "HUNTERS_DEFEATED" and String(terminal.get("source_resolution_id", "")) == String(defeat_handoff.get("resolution_id", "")), str(terminal))
	_check("terminal commit freezes current actor and remains in Round 2", bool(state.get("encounter_terminal", false)) and String(state.get("current_actor_id", "")) == "" and int(state.get("round_id", 0)) == 2, str(state))
	_check("reaction window is closed before terminal freeze", (reaction.call("get_active_window") as Dictionary).is_empty())
	for _frame in range(4):
		await process_frame
	state = shell.call("get_current_state")
	_check("scheduler cannot advance to Round 3 after defeat", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == "")
	_check("new player turn commitment is rejected after terminal", not bool(shell.call("end_player_turn")))
	_check("external Monster completion is rejected after terminal", not bool(shell.call("complete_external_activation", MONSTER_ID, "SHOULD_NOT_ADVANCE")))
	_check("living Mudcrest anatomy is not reset by Hunter defeat", anatomy.call("get_target_state", "HEAD") == head_before)

	var outcome_count := int(outcome.call("get_resolution_count"))
	var replay: Dictionary = outcome.call("resolve_hunter_defeat_handoff", defeat_handoff)
	_check("defeat handoff replay returns stored result", replay == final_outcome)
	_check("defeat replay cannot commit twice", int(outcome.call("get_resolution_count")) == outcome_count and shell.call("get_terminal_state") == terminal)
	var invalid := defeat_handoff.duplicate(true)
	invalid["resolution_id"] = "%s:INVALID_ACTOR" % ENCOUNTER_ID
	invalid["actor_id"] = MONSTER_ID
	var rejected: Dictionary = outcome.call("resolve_hunter_defeat_handoff", invalid)
	_check("wrong-actor defeat handoff is rejected", not bool(rejected.get("success", false)) and String(rejected.get("reason", "")) == "UNEXPECTED_ACTOR_ID", str(rejected))
	_check("outcome trace records Downed commit", _has_event(outcome.call("get_trace") as Array, "HUNTER_DOWNED_OUTCOME_COMMITTED"))
	_check("shell trace records terminal commit", _has_event(shell.call("get_trace") as Array, "ENCOUNTER_TERMINAL_COMMITTED"))
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_FAILED")
	print("Forced recovery/respawn costs, voluntary withdrawal, Monster escape/death, structural thresholds, harvest, Bleeding periodic HP, phone acceptance and performance are not claimed by this gate.")
	quit(0 if failures.is_empty() else 1)
