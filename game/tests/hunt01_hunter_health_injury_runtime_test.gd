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
	print("Hunt-01 Hunter health/injury runtime")
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
	var mudcrest_attack := encounter.call("get_mudcrest_attack_runtime") as Node
	_check("production dependencies exist", shell != null and movement != null and reaction != null and mudcrest_attack != null)
	if shell == null or movement == null or reaction == null or mudcrest_attack == null:
		_finish()
		return
	await process_frame

	var defense := mudcrest_attack.call("get_hunter_defense_runtime") as Node
	var health: Node = null
	if defense != null:
		health = defense.call("get_hunter_health_runtime") as Node
	_check("Hunter health runtime is integrated through generic defense owner", health != null and bool(health.call("is_initialized")))
	if health == null:
		_finish()
		return
	_check("Hunter health schema v1", String(health.call("get_schema")) == "uhr.hunt01.hunter_health_injury.v1")
	_check("health fixture is explicitly provisional", String(health.call("get_fixture_status")) == "PROVISIONAL_FIRST_SLICE_HUNTER_HEALTH_INJURY_FIXTURE")
	_check("missing authored gameplay armor is explicit", String(health.call("get_protection_fixture_status")) == "PROVISIONAL_NO_AUTHORED_HUNTER_GAMEPLAY_ARMOR_PROFILE_RESIDUAL_FORCE_BASELINE")
	_check("normalized first-slice Hunter health starts at 100", int((health.call("get_health_state") as Dictionary).get("health", -1)) == 100)

	# Round 1 remains out of range.
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
	var block_commit: Dictionary = reaction.call("commit_reaction", window_id, REACTION_BLOCK)
	_check("Poleblade Block commits", bool(block_commit.get("success", false)), str(block_commit))
	await process_frame
	await process_frame

	var first_attack: Dictionary = mudcrest_attack.call("get_last_resolution")
	var first_defense: Dictionary = first_attack.get("defense_consequence", {}) as Dictionary
	var first_health: Dictionary = first_defense.get("health_injury_consequence", {}) as Dictionary
	var first_health_handoff: Dictionary = first_defense.get("health_handoff", {}) as Dictionary
	_check("real Head Sweep resolves health before Monster activation completion", bool(first_health.get("success", false)) and String(first_health.get("status", "")) == "HUNTER_HEALTH_INJURY_RESOLVED", str(first_health))
	_check("real blocked Head Sweep preserves SOLID + BLOCK_STRONG trace", String(first_health.get("hit_quality", "")) == "SOLID" and String(first_health.get("defense_outcome", "")) == "BLOCK_STRONG", str(first_health))
	_check("provisional SOLID base load is 8", int(first_health.get("base_injury_load", -1)) == 8, str(first_health))
	_check("BLOCK_STRONG keeps 25 percent residual force in named fixture", int(first_health.get("defense_residual_percent", -1)) == 25, str(first_health))
	_check("first real blocked Head Sweep applies 2 normalized injury", int(first_health.get("applied_injury_load", -1)) == 2 and int(first_health.get("health_before", -1)) == 100 and int(first_health.get("health_after", -1)) == 98, str(first_health))
	_check("status application stays deferred without dominant-channel wound classification", (first_health.get("status_requests", []) as Array).is_empty() and String(first_health.get("status_request_boundary", "")) == "DEFERRED_PENDING_DOMINANT_CHANNEL_AND_WOUND_CLASSIFICATION", str(first_health))
	_check("possible bleeding remains candidate-only, not applied", (first_health.get("status_request_candidates", []) as Array).size() >= 1, str(first_health))
	state = shell.call("get_current_state")
	_check("Monster activation completes after health consequence", int(state.get("round_id", 0)) == 3 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))

	var health_before_replay := health.call("get_health_state") as Dictionary
	var replay: Dictionary = health.call("resolve_health_handoff", first_health_handoff)
	_check("health handoff replay returns exact stored resolution", replay == first_health)
	_check("health replay cannot apply injury twice", health.call("get_health_state") == health_before_replay)

	# Round 3 decline exercises the no-guard body-contact path through production.
	_check("Round-3 Hunter turn opens second Head Sweep", bool(shell.call("end_player_turn")))
	window = reaction.call("get_active_window")
	var second_window_id := String(window.get("window_id", ""))
	_check("second reaction window opens", not second_window_id.is_empty())
	_check("explicit decline commits", bool((reaction.call("decline_reaction", second_window_id) as Dictionary).get("success", false)))
	await process_frame
	await process_frame
	var second_attack: Dictionary = mudcrest_attack.call("get_last_resolution")
	var second_defense: Dictionary = second_attack.get("defense_consequence", {}) as Dictionary
	var second_health: Dictionary = second_defense.get("health_injury_consequence", {}) as Dictionary
	_check("declined SOLID Head Sweep uses no-active-guard residual path", String(second_health.get("hit_quality", "")) == "SOLID" and String(second_health.get("defense_outcome", "")) == "NO_ACTIVE_GUARD", str(second_health))
	_check("no-active-guard SOLID applies full provisional 8 load", int(second_health.get("applied_injury_load", -1)) == 8 and int(second_health.get("health_after", -1)) == 90, str(second_health))

	# Domain stress: eight unique CLEAN/no-guard residual transactions drive 90 to
	# zero and prove clamp + downstream defeat handoff without implementing defeat.
	var last_zero: Dictionary = {}
	for index in range(8):
		var synthetic := {
			"status": "PENDING_HUNTER_HEALTH_INJURY_RUNTIME",
			"resolution_id": "enc_r01_ef02_m01_0001:HEALTH_STRESS:%02d" % index,
			"encounter_id": "enc_r01_ef02_m01_0001",
			"attacker_id": MONSTER_ID,
			"defender_id": HUNTER_ID,
			"attack_id": ATTACK_ID,
			"attack_profile": "GORE_SWEEP",
			"damage_channels": ["PIERCING", "IMPACT"],
			"contact_class": "HUNTER_BODY_CONTACT",
			"hit_quality": "CLEAN",
			"defense_outcome": "NO_ACTIVE_GUARD",
			"residual_force_status": "HUNTER_BODY_CONTACT",
			"final_damage_amount_status": "NOT_SELECTED",
		}
		last_zero = health.call("resolve_health_handoff", synthetic)
		_check("synthetic CLEAN transaction %d resolves" % index, bool(last_zero.get("success", false)), str(last_zero))
	_check("health clamps exactly at zero", int((health.call("get_health_state") as Dictionary).get("health", -1)) == 0, str(health.call("get_health_state")))
	_check("final clamp never applies more than remaining health", int(last_zero.get("health_after", -1)) == 0 and int(last_zero.get("applied_injury_load", -1)) <= int(last_zero.get("requested_injury_load", -1)), str(last_zero))
	var defeat_handoff: Dictionary = last_zero.get("defeat_handoff", {}) as Dictionary
	_check("zero health emits pending defeat/outcome instead of implementing defeat", String(defeat_handoff.get("status", "")) == "PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME", str(defeat_handoff))

	var no_injury_handoff := {
		"status": "NO_HUNTER_HEALTH_INJURY_CONSEQUENCE",
		"resolution_id": "enc_r01_ef02_m01_0001:NO_INJURY_AFTER_ZERO",
		"defender_id": HUNTER_ID,
		"reason": "NO_CONTACT",
	}
	var no_injury: Dictionary = health.call("resolve_health_handoff", no_injury_handoff)
	_check("no-injury path mutates no health", String(no_injury.get("status", "")) == "HUNTER_HEALTH_NO_INJURY_RESOLVED" and int(no_injury.get("health_after", -1)) == 0, str(no_injury))

	var trace: Array = health.call("get_trace")
	_check("health trace records real/synthetic injury", _has_event(trace, "HUNTER_HEALTH_INJURY_RESOLVED"))
	_check("health trace records zero-health boundary", _has_event(trace, "HUNTER_HEALTH_ZERO_REACHED"))
	_check("health trace records no-injury boundary", _has_event(trace, "HUNTER_HEALTH_NO_INJURY_RESOLVED"))
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_HUNTER_HEALTH_INJURY_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_HUNTER_HEALTH_INJURY_RUNTIME_FAILED")
	print("Final Max Health/damage/armor balance, status application, forced movement, defeat resolution, other Mudcrest attacks, phone acceptance and performance are not claimed by this gate.")
	quit(0 if failures.is_empty() else 1)
