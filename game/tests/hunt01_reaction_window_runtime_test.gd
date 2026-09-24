extends SceneTree

const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"
const REACTION_BLOCK := "POLEBLADE_BLOCK"

class MockMonsterActivationDriver extends Node:
	var calls := 0
	var last_actor_id := ""
	var last_round_id := 0

	func begin_monster_activation(actor_id: String, round_id: int) -> bool:
		calls += 1
		last_actor_id = actor_id
		last_round_id = round_id
		return true

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

func _has_event(trace: Array, event_name: String) -> bool:
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) == event_name:
			return true
	return false

func _run() -> void:
	print("Hunt-01 Hunter reaction-window runtime")
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
	var encounter := world.get_node("EncounterRuntime")
	var tracking := world.get_node("TrackingRuntime")
	_check("encounter runtime available", encounter != null)
	_check("tracking runtime available", tracking != null)

	var evidence_ids := [
		"R01_H01_EV01_OUTER_PRINTS",
		"R01_H01_EV02_BANK_REEDS",
		"R01_H01_EV03_FRESH_WALLOW",
		"R01_H01_EV05_OLD_ROOT_SCRAPE",
		"R01_H01_EV04_WATER_EXIT",
		"R01_H01_EV06_FEEDING_REMAINS",
		"R01_H01_EV07_FLATTENED_GRASS_AUDIO",
	]
	var all_recorded := true
	for evidence_id in evidence_ids:
		if not bool(tracking.call("record_evidence_for_test", evidence_id)):
			all_recorded = false
		await process_frame
	_check("tracking prerequisite resolves", all_recorded and int(tracking.call("get_collected_count")) == 7)
	var inference: Dictionary = tracking.call("get_current_inference")
	_check("tracking reaches observation-ready", String(inference.get("phase", "")) == "OBSERVATION_READY")

	await _settle_hunter(hunter, Vector3(-72.0, 0.875, -236.0))
	_check("physical engagement is available", String(encounter.call("get_state")) == "ENGAGEMENT_AVAILABLE", String(encounter.call("get_state")))
	_check("explicit ENGAGE starts combat stack", bool(encounter.call("engage_for_test")))
	_check("encounter reports reaction runtime started", bool(encounter.call("has_reaction_window_started")))

	var shell := encounter.call("get_combat_turn_shell") as Node
	var reaction := encounter.call("get_reaction_window_runtime") as Node
	var anatomy := encounter.call("get_mudcrest_anatomy_runtime") as Node
	_check("combat shell exists", shell != null)
	_check("reaction runtime exists", reaction != null)
	_check("anatomy runtime exists", anatomy != null)
	if shell == null or reaction == null or anatomy == null:
		_finish()
		return

	# This regression owns the reaction-window contract with a controlled hostile
	# source. The production Head Sweep runtime has a deferred driver registration,
	# so remove that sibling before installing the mock instead of weakening the
	# shell's one-driver production invariant.
	var production_attack := encounter.call("get_mudcrest_attack_runtime") as Node
	_check("production Mudcrest attack runtime exists before reaction isolation", production_attack != null)
	if production_attack != null:
		production_attack.free()
	_check("reaction test isolates the production hostile driver", not is_instance_valid(production_attack))

	_check("reaction schema v1", String(reaction.call("get_schema")) == "uhr.hunt01.reaction_window.v1")
	_check("reaction runtime starts idle", String(reaction.call("get_state")) == "IDLE")
	var panel := world.get_node_or_null("HUD/ReactionWindowPanel") as Control
	_check("reaction HUD exists", panel != null)
	_check("reaction HUD is hidden without hostile telegraph", panel != null and not panel.visible)

	var driver := MockMonsterActivationDriver.new()
	driver.name = "MockMonsterActivationDriver"
	shell.add_child(driver)
	_check("turn shell accepts one Monster activation driver", bool(shell.call("register_monster_activation_driver", driver)))
	_check("duplicate Monster activation driver registration is rejected", not bool(shell.call("register_monster_activation_driver", driver)))

	var anatomy_before: Dictionary = anatomy.call("get_all_target_states")
	var hunter_before_end: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("Hunter begins with 1 RP and 100 Stamina", int(hunter_before_end.get("rp", -1)) == 1 and int(hunter_before_end.get("stamina", -1)) == 100, str(hunter_before_end))
	_check("ending Hunter turn hands Round-1 activation to Monster driver", bool(shell.call("end_player_turn")))
	var scheduler_state: Dictionary = shell.call("get_current_state")
	_check("Monster remains current while external driver owns activation", int(scheduler_state.get("round_id", 0)) == 1 and String(scheduler_state.get("current_actor_id", "")) == MONSTER_ID, str(scheduler_state))
	_check("Monster driver was invoked exactly once", driver.calls == 1 and driver.last_actor_id == MONSTER_ID and driver.last_round_id == 1)

	var hunter_resources: Dictionary = shell.call("get_resource_state", HUNTER_ID)
	_check("ending Hunter turn discards AP but preserves RP/Stamina for reaction", int(hunter_resources.get("ap", -1)) == 0 and int(hunter_resources.get("rp", -1)) == 1 and int(hunter_resources.get("stamina", -1)) == 100, str(hunter_resources))

	var allowed: Array[String] = [REACTION_BLOCK]
	var opened: Dictionary = reaction.call("open_window", MONSTER_ID, "M01_HEAD_SWEEP_GORE", 1, allowed, "Mudcrest Raker lowers its horned head and sweeps across the front arc.")
	_check("Monster telegraph opens reaction window", bool(opened.get("success", false)) and String(opened.get("state", "")) == "OPEN", str(opened))
	var window_id := String(opened.get("window_id", ""))
	_check("reaction window has stable non-empty identity", not window_id.is_empty())
	_check("reaction HUD becomes visible", panel != null and panel.visible)
	var supported: Array = opened.get("supported_reactions", [])
	_check("Block is the implemented first reaction", supported.has(REACTION_BLOCK))
	_check("decline is always exposed without resource cost", String(opened.get("always_available_choice", "")) == "DECLINE_REACTION")

	var recursive: Dictionary = reaction.call("open_window", MONSTER_ID, "M01_TAIL_SWEEP", 2, allowed, "second hostile action")
	_check("recursive/overlapping normal reaction window is rejected", not bool(recursive.get("success", true)) and String(recursive.get("reason", "")) == "REACTION_WINDOW_ALREADY_ACTIVE", str(recursive))

	var committed: Dictionary = reaction.call("commit_reaction", window_id, REACTION_BLOCK)
	_check("Field Poleblade Block commits", bool(committed.get("success", false)) and String(committed.get("state", "")) == "COMMITTED_WAITING_SOURCE_RESOLUTION", str(committed))
	_check("reaction outcome remains pending hostile-action resolution", String(committed.get("resolution_status", "")) == "PENDING_ATTACK_DEFENSE_RESOLUTION")
	_check("Block spends exactly 1 RP + 6 Stamina", int(committed.get("rp_cost", -1)) == 1 and int(committed.get("stamina_cost", -1)) == 6, str(committed))

	hunter_resources = shell.call("get_resource_state", HUNTER_ID)
	_check("out-of-turn reaction spends no AP", int(hunter_resources.get("ap", -1)) == 0, str(hunter_resources))
	_check("out-of-turn Block leaves RP 0 and Stamina 94", int(hunter_resources.get("rp", -1)) == 0 and int(hunter_resources.get("stamina", -1)) == 94, str(hunter_resources))
	var committed_resources := hunter_resources.duplicate(true)

	var duplicate: Dictionary = reaction.call("commit_reaction", window_id, REACTION_BLOCK)
	_check("duplicate Block readback is idempotent", bool(duplicate.get("success", false)) and bool(duplicate.get("duplicate", false)), str(duplicate))
	_check("duplicate Block does not spend resources twice", shell.call("get_resource_state", HUNTER_ID) == committed_resources)
	var decline_after_commit: Dictionary = reaction.call("decline_reaction", window_id)
	_check("second reaction choice after commitment is rejected", not bool(decline_after_commit.get("success", true)) and String(decline_after_commit.get("reason", "")) == "REACTION_DECISION_ALREADY_FINAL", str(decline_after_commit))

	var closed: Dictionary = reaction.call("close_window", window_id, "HOSTILE_ACTION_RESOLUTION_PENDING_NEXT_LAYER")
	_check("committed window closes explicitly after source resolver acknowledgment", String(closed.get("state", "")) == "CLOSED", str(closed))
	_check("reaction runtime returns to idle after close", String(reaction.call("get_state")) == "IDLE")
	_check("reaction HUD hides after close", panel != null and not panel.visible)

	var readback: Dictionary = reaction.call("open_window", MONSTER_ID, "M01_HEAD_SWEEP_GORE", 1, allowed, "Mudcrest Raker lowers its horned head and sweeps across the front arc.")
	_check("closed reaction transaction readback is stable/idempotent", String(readback.get("state", "")) == "CLOSED" and bool(readback.get("duplicate", false)), str(readback))
	_check("closed readback does not spend resources", shell.call("get_resource_state", HUNTER_ID) == committed_resources)

	var opened_second: Dictionary = reaction.call("open_window", MONSTER_ID, "M01_HEAD_SWEEP_GORE", 2, allowed, "Second test telegraph")
	_check("new hostile action sequence gets a new reaction window", bool(opened_second.get("success", false)) and String(opened_second.get("window_id", "")) != window_id, str(opened_second))
	var second_id := String(opened_second.get("window_id", ""))
	var unaffordable: Dictionary = reaction.call("commit_reaction", second_id, REACTION_BLOCK)
	_check("Block is rejected when Hunter RP is exhausted", not bool(unaffordable.get("success", true)) and String(unaffordable.get("reason", "")) == "INSUFFICIENT_REACTION_RESOURCES", str(unaffordable))
	_check("failed reaction commitment spends nothing", shell.call("get_resource_state", HUNTER_ID) == committed_resources)
	var declined: Dictionary = reaction.call("decline_reaction", second_id)
	_check("Hunter can explicitly decline when no paid reaction is available", bool(declined.get("success", false)) and String(declined.get("state", "")) == "DECLINED_WAITING_SOURCE_RESOLUTION", str(declined))
	_check("decline costs 0 RP / 0 Stamina", int(declined.get("rp_cost", -1)) == 0 and int(declined.get("stamina_cost", -1)) == 0, str(declined))
	_check("decline also leaves resources unchanged", shell.call("get_resource_state", HUNTER_ID) == committed_resources)
	var second_closed: Dictionary = reaction.call("close_window", second_id, "HOSTILE_ACTION_RESOLUTION_PENDING_NEXT_LAYER")
	_check("declined window closes explicitly", String(second_closed.get("state", "")) == "CLOSED")

	_check("reaction prerequisite does not alter Mudcrest anatomy", anatomy.call("get_all_target_states") == anatomy_before)
	_check("reaction prerequisite applies no anatomy transactions", int(anatomy.call("get_applied_resolution_count")) == 0)

	_check("external Monster activation completes through shell authority", bool(shell.call("complete_external_activation", MONSTER_ID, "REACTION_TEST_MONSTER_TURN_COMPLETE")))
	scheduler_state = shell.call("get_current_state")
	hunter_resources = shell.call("get_resource_state", HUNTER_ID)
	_check("scheduler resumes at Round-2 Hunter activation", int(scheduler_state.get("round_id", 0)) == 2 and String(scheduler_state.get("current_actor_id", "")) == HUNTER_ID, str(scheduler_state))
	_check("Hunter RP refreshes to 1 on next normal activation", int(hunter_resources.get("rp", -1)) == 1, str(hunter_resources))
	_check("Hunter passive recovery restores/clamps Stamina after reaction", int(hunter_resources.get("stamina", -1)) == 100, str(hunter_resources))

	var shell_trace: Array = shell.call("get_trace")
	var reaction_trace: Array = reaction.call("get_trace")
	_check("shell trace records Monster activation delegation", _has_event(shell_trace, "MONSTER_ACTIVATION_DELEGATED"))
	_check("shell trace records reaction resource commitment", _has_event(shell_trace, "REACTION_RESOURCE_COMMITTED"))
	_check("reaction trace records open/commit/close lifecycle", _has_event(reaction_trace, "REACTION_WINDOW_OPENED") and _has_event(reaction_trace, "REACTION_COMMITTED") and _has_event(reaction_trace, "REACTION_WINDOW_CLOSED"))

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_HUNTER_REACTION_WINDOW_RUNTIME_VERIFIED")
		quit(0)
	else:
		print("Gate: HUNT01_HUNTER_REACTION_WINDOW_RUNTIME_FAILED")
		for failure in failures:
			print("FAILED: %s" % failure)
		quit(1)
