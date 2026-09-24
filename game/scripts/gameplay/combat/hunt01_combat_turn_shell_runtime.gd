extends Node

const SCHEMA := "uhr.hunt01.combat_turn_shell.v1"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"
const INITIATIVE_FIXTURE_STATUS := "PROVISIONAL_CONTRACT_EXAMPLE_FIXTURE"

const HUNTER_MAX_AP := 4
const HUNTER_MAX_RP := 1
const HUNTER_MAX_STAMINA := 100
const HUNTER_PASSIVE_STAMINA_RECOVERY := 10
const MONSTER_MAX_AP := 4
const MONSTER_MAX_RP := 0
const MONSTER_REFERENCE_STAMINA := 100

const HUNTER_AGILITY_FIXTURE := 50
const HUNTER_PERCEPTION_FIXTURE := 40
const MONSTER_AGILITY_FIXTURE := 45
const MONSTER_PERCEPTION_FIXTURE := 50

var _world: Node3D = null
var _encounter_record: Dictionary = {}
var _initialized := false
var _round_id := 0
var _round_roster: Array[String] = []
var _slot_states: Dictionary = {}
var _initiative_snapshots: Dictionary = {}
var _resources: Dictionary = {}
var _activation_started: Dictionary = {}
var _reaction_commits: Dictionary = {}
var _current_index := -1
var _current_actor_id := ""
var _monster_activation_driver: Node = null
var _status_timing_driver: Node = null
var _encounter_terminal := false
var _terminal_state: Dictionary = {}
var _trace: Array[Dictionary] = []
var _trace_sequence := 0

var _panel: PanelContainer = null
var _state_label: Label = null
var _resource_label: Label = null
var _end_turn_button: Button = null

func initialize(world: Node3D, encounter_record: Dictionary) -> bool:
	if _initialized or world == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		push_error("Combat turn shell rejected unexpected encounter identity.")
		return false
	_world = world
	_encounter_record = encounter_record.duplicate(true)
	_configure_participants()
	_lock_exploration_locomotion()
	_build_hud()
	_initialized = true
	_begin_round()
	return true

func _configure_participants() -> void:
	_initiative_snapshots[HUNTER_COMBATANT_ID] = _make_snapshot(HUNTER_COMBATANT_ID, HUNTER_AGILITY_FIXTURE, HUNTER_PERCEPTION_FIXTURE, 0)
	_initiative_snapshots[MONSTER_COMBATANT_ID] = _make_snapshot(MONSTER_COMBATANT_ID, MONSTER_AGILITY_FIXTURE, MONSTER_PERCEPTION_FIXTURE, 0)
	_resources[HUNTER_COMBATANT_ID] = {"max_ap": HUNTER_MAX_AP, "ap": 0, "max_rp": HUNTER_MAX_RP, "rp": 0, "max_stamina": HUNTER_MAX_STAMINA, "stamina": HUNTER_MAX_STAMINA, "passive_stamina_recovery": HUNTER_PASSIVE_STAMINA_RECOVERY}
	_resources[MONSTER_COMBATANT_ID] = {"max_ap": MONSTER_MAX_AP, "ap": 0, "max_rp": MONSTER_MAX_RP, "rp": 0, "max_stamina": MONSTER_REFERENCE_STAMINA, "stamina": MONSTER_REFERENCE_STAMINA, "passive_stamina_recovery": 0}

func _make_snapshot(combatant_id: String, agility: int, perception: int, modifier: int) -> Dictionary:
	return {"encounter_id": EXPECTED_ENCOUNTER_ID, "combatant_instance_id": combatant_id, "effective_agility": agility, "effective_perception": perception, "explicit_initiative_modifier": modifier, "initiative_rating": (2 * agility) + perception + modifier, "fixture_status": INITIATIVE_FIXTURE_STATUS}

func _initiative_before(a: String, b: String) -> bool:
	var left: Dictionary = _initiative_snapshots[a]
	var right: Dictionary = _initiative_snapshots[b]
	var left_rating := int(left["initiative_rating"])
	var right_rating := int(right["initiative_rating"])
	if left_rating != right_rating:
		return left_rating > right_rating
	var left_agility := int(left["effective_agility"])
	var right_agility := int(right["effective_agility"])
	if left_agility != right_agility:
		return left_agility > right_agility
	var left_perception := int(left["effective_perception"])
	var right_perception := int(right["effective_perception"])
	if left_perception != right_perception:
		return left_perception > right_perception
	return a < b

func _begin_round() -> void:
	if _encounter_terminal:
		return
	_round_id += 1
	_round_roster = [HUNTER_COMBATANT_ID, MONSTER_COMBATANT_ID]
	_round_roster.sort_custom(Callable(self, "_initiative_before"))
	_slot_states.clear()
	for combatant_id in _round_roster:
		_slot_states[combatant_id] = "PENDING"
	_current_index = -1
	_current_actor_id = ""
	_record_trace("ROUND_START", {"order": _round_roster.duplicate()})
	_advance_scheduler()

func _advance_scheduler() -> void:
	if _encounter_terminal:
		return
	while true:
		_current_index += 1
		if _current_index >= _round_roster.size():
			if _status_timing_driver != null:
				var round_end_result: Dictionary = _status_timing_driver.call("on_round_end", _round_id)
				_record_trace("STATUS_TIMING_ROUND_END", {"success": bool(round_end_result.get("success", false)), "result": round_end_result.duplicate(true)})
				if not bool(round_end_result.get("success", false)):
					push_error("Status timing ROUND_END hook failed.")
			_begin_round()
			return
		var combatant_id := _round_roster[_current_index]
		if String(_slot_states.get(combatant_id, "")) != "PENDING":
			continue
		if not _start_activation(combatant_id):
			_slot_states[combatant_id] = "SKIPPED_INELIGIBLE"
			continue
		if combatant_id == MONSTER_COMBATANT_ID:
			if _monster_activation_driver != null:
				_record_trace("MONSTER_ACTIVATION_DELEGATED", {"combatant_id": combatant_id, "driver": _monster_activation_driver.name})
				var accepted := bool(_monster_activation_driver.call("begin_monster_activation", combatant_id, _round_id))
				if accepted:
					_refresh_hud()
					return
				_record_trace("MONSTER_DRIVER_REJECTED_ACTIVATION", {"combatant_id": combatant_id, "driver": _monster_activation_driver.name})
				_end_current_activation("MONSTER_DRIVER_REJECTED_ACTIVATION")
				continue
			_record_trace("MONSTER_PLACEHOLDER_WAIT", {"combatant_id": combatant_id, "reason": "WAIT_NO_ATTACK_RUNTIME"})
			_end_current_activation("WAIT_NO_ATTACK_RUNTIME")
			continue
		_refresh_hud()
		return

func _start_activation(combatant_id: String) -> bool:
	if _encounter_terminal:
		return false
	var activation_key := "%d|%s" % [_round_id, combatant_id]
	if _activation_started.has(activation_key):
		_record_trace("INVARIANT_REJECTED_DUPLICATE_ACTIVATION", {"combatant_id": combatant_id})
		return false
	if _status_timing_driver != null:
		var turn_start_result: Dictionary = _status_timing_driver.call("on_turn_start_pre_recovery", combatant_id, _round_id)
		_record_trace("STATUS_TIMING_TURN_START_PRE_RECOVERY", {"combatant_id": combatant_id, "success": bool(turn_start_result.get("success", false)), "result": turn_start_result.duplicate(true)})
		if not bool(turn_start_result.get("success", false)):
			push_error("Status timing TURN_START_PRE_RECOVERY hook failed.")
	var state: Dictionary = (_resources[combatant_id] as Dictionary).duplicate(true)
	var max_stamina := int(state["max_stamina"])
	var passive_recovery := int(state["passive_stamina_recovery"])
	state["stamina"] = mini(max_stamina, int(state["stamina"]) + passive_recovery)
	state["ap"] = int(state["max_ap"])
	state["rp"] = int(state["max_rp"])
	_resources[combatant_id] = state
	_activation_started[activation_key] = true
	_current_actor_id = combatant_id
	_record_trace("ACTIVATION_START", {"combatant_id": combatant_id, "ap": state["ap"], "rp": state["rp"], "stamina": state["stamina"]})
	_refresh_hud()
	return true

func register_monster_activation_driver(driver: Node) -> bool:
	if not _initialized or _encounter_terminal or driver == null or _monster_activation_driver != null:
		return false
	if not driver.has_method("begin_monster_activation"):
		return false
	_monster_activation_driver = driver
	_record_trace("MONSTER_ACTIVATION_DRIVER_REGISTERED", {"driver": driver.name})
	return true

func register_status_timing_driver(driver: Node) -> bool:
	if not _initialized or _encounter_terminal or driver == null or _status_timing_driver != null:
		return false
	if not driver.has_method("on_turn_start_pre_recovery") or not driver.has_method("on_turn_end") or not driver.has_method("on_round_end"):
		return false
	_status_timing_driver = driver
	_record_trace("STATUS_TIMING_DRIVER_REGISTERED", {"driver": driver.name})
	return true

func complete_external_activation(combatant_id: String, reason: String) -> bool:
	if not _initialized or _encounter_terminal or _monster_activation_driver == null:
		return false
	if combatant_id != MONSTER_COMBATANT_ID or _current_actor_id != combatant_id or reason.is_empty():
		return false
	_end_current_activation(reason)
	_advance_scheduler()
	return true

func try_commit_cost(combatant_id: String, action_id: String, ap_cost: int, stamina_cost: int) -> bool:
	if not _initialized or _encounter_terminal or combatant_id != _current_actor_id or ap_cost < 0 or stamina_cost < 0:
		return false
	var state: Dictionary = (_resources[combatant_id] as Dictionary).duplicate(true)
	if int(state["ap"]) < ap_cost or int(state["stamina"]) < stamina_cost:
		_record_trace("RESOURCE_COMMIT_REJECTED", {"combatant_id": combatant_id, "action_id": action_id, "ap_cost": ap_cost, "stamina_cost": stamina_cost})
		return false
	state["ap"] = int(state["ap"]) - ap_cost
	state["stamina"] = int(state["stamina"]) - stamina_cost
	_resources[combatant_id] = state
	_record_trace("RESOURCE_COMMITTED", {"combatant_id": combatant_id, "action_id": action_id, "ap_cost": ap_cost, "stamina_cost": stamina_cost})
	_refresh_hud()
	return true

func try_commit_reaction_cost(combatant_id: String, source_actor_id: String, reaction_id: String, window_id: String, rp_cost: int, stamina_cost: int) -> Dictionary:
	if not _initialized:
		return {"success": false, "reason": "SHELL_NOT_INITIALIZED"}
	if _encounter_terminal:
		return {"success": false, "reason": "ENCOUNTER_TERMINATED"}
	if combatant_id.is_empty() or source_actor_id.is_empty() or reaction_id.is_empty() or window_id.is_empty():
		return {"success": false, "reason": "INVALID_REACTION_IDENTITY"}
	if _current_actor_id != source_actor_id or combatant_id == source_actor_id:
		return {"success": false, "reason": "REACTION_SOURCE_NOT_CURRENT_HOSTILE_ACTOR"}
	if not _resources.has(combatant_id):
		return {"success": false, "reason": "UNKNOWN_REACTOR"}
	if rp_cost < 0 or stamina_cost < 0:
		return {"success": false, "reason": "INVALID_REACTION_COST"}
	var commit_key := "%s|%s" % [window_id, combatant_id]
	if _reaction_commits.has(commit_key):
		var existing: Dictionary = (_reaction_commits[commit_key] as Dictionary).duplicate(true)
		existing["duplicate"] = true
		return existing
	var state: Dictionary = (_resources[combatant_id] as Dictionary).duplicate(true)
	if int(state["rp"]) < rp_cost or int(state["stamina"]) < stamina_cost:
		_record_trace("REACTION_RESOURCE_COMMIT_REJECTED", {"combatant_id": combatant_id, "source_actor_id": source_actor_id, "reaction_id": reaction_id, "window_id": window_id, "rp_cost": rp_cost, "stamina_cost": stamina_cost})
		return {"success": false, "reason": "INSUFFICIENT_REACTION_RESOURCES", "window_id": window_id, "reaction_id": reaction_id}
	state["rp"] = int(state["rp"]) - rp_cost
	state["stamina"] = int(state["stamina"]) - stamina_cost
	_resources[combatant_id] = state
	var committed := {"success": true, "reason": "REACTION_RESOURCES_COMMITTED", "window_id": window_id, "combatant_id": combatant_id, "source_actor_id": source_actor_id, "reaction_id": reaction_id, "rp_cost": rp_cost, "stamina_cost": stamina_cost, "duplicate": false}
	_reaction_commits[commit_key] = committed.duplicate(true)
	_record_trace("REACTION_RESOURCE_COMMITTED", committed)
	_refresh_hud()
	return committed

func end_player_turn() -> bool:
	if not _initialized or _encounter_terminal or _current_actor_id != HUNTER_COMBATANT_ID:
		return false
	var state: Dictionary = (_resources[HUNTER_COMBATANT_ID] as Dictionary).duplicate(true)
	state["ap"] = 0
	_resources[HUNTER_COMBATANT_ID] = state
	_record_trace("UNUSED_AP_DISCARDED", {"combatant_id": HUNTER_COMBATANT_ID})
	_end_current_activation("PLAYER_END_TURN")
	_advance_scheduler()
	return true

func _end_current_activation(reason: String) -> void:
	if _current_actor_id.is_empty():
		return
	var ending_actor := _current_actor_id
	if _status_timing_driver != null:
		var turn_end_result: Dictionary = _status_timing_driver.call("on_turn_end", ending_actor, _round_id)
		_record_trace("STATUS_TIMING_TURN_END", {"combatant_id": ending_actor, "success": bool(turn_end_result.get("success", false)), "result": turn_end_result.duplicate(true)})
		if not bool(turn_end_result.get("success", false)):
			push_error("Status timing TURN_END hook failed.")
	_slot_states[ending_actor] = "ACTED"
	_record_trace("ACTIVATION_END", {"combatant_id": ending_actor, "reason": reason})
	_current_actor_id = ""
	_refresh_hud()

func commit_terminal_outcome(outcome: String, source_resolution_id: String, downed_actor_id: String) -> Dictionary:
	if not _initialized:
		return {"success": false, "reason": "SHELL_NOT_INITIALIZED"}
	if not _terminal_state.is_empty():
		if String(_terminal_state.get("outcome", "")) == outcome and String(_terminal_state.get("source_resolution_id", "")) == source_resolution_id and String(_terminal_state.get("downed_actor_id", "")) == downed_actor_id:
			return _terminal_state.duplicate(true)
		return {"success": false, "reason": "ENCOUNTER_TERMINAL_OUTCOME_ALREADY_COMMITTED", "terminal_state": _terminal_state.duplicate(true)}
	if outcome != "HUNTERS_DEFEATED" or downed_actor_id != HUNTER_COMBATANT_ID or source_resolution_id.is_empty():
		return {"success": false, "reason": "UNSUPPORTED_TERMINAL_OUTCOME"}
	if _current_actor_id.is_empty():
		return {"success": false, "reason": "NO_AUTHORITATIVE_RESOLUTION_ACTIVATION"}

	# Finish the current authoritative activation/status boundary first. Only
	# after that boundary is terminal state committed and scheduler advancement
	# is frozen.
	_end_current_activation("ENCOUNTER_TERMINATED_HUNTERS_DEFEATED")
	_encounter_terminal = true
	for combatant_id in _round_roster:
		if String(_slot_states.get(combatant_id, "")) == "PENDING":
			_slot_states[combatant_id] = "REMOVED"
			_record_trace("ROUND_SLOT_REMOVED", {"combatant_id": combatant_id, "reason": "ENCOUNTER_TERMINATED"})
	_current_index = _round_roster.size()
	_current_actor_id = ""
	_terminal_state = {
		"success": true,
		"status": "ENCOUNTER_TERMINAL_COMMITTED",
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"encounter_terminal": true,
		"outcome": outcome,
		"source_resolution_id": source_resolution_id,
		"downed_actor_id": downed_actor_id,
		"round_id": _round_id,
		"slot_states": _slot_states.duplicate(true),
	}
	_record_trace("ENCOUNTER_TERMINAL_COMMITTED", _terminal_state)
	_refresh_hud()
	return _terminal_state.duplicate(true)

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {"sequence": _trace_sequence, "event": event_name, "encounter_id": EXPECTED_ENCOUNTER_ID, "round_id": _round_id}
	for key in details.keys():
		entry[key] = details[key]
	_trace.append(entry)

func _lock_exploration_locomotion() -> void:
	_world.call("_reset_transient_controls")
	_world.set_physics_process(false)
	var hunter := _world.get_node_or_null("Hunter") as CharacterBody3D
	if hunter != null:
		hunter.velocity = Vector3.ZERO
	var joystick := _world.get_node_or_null("HUD/Touch/MoveJoystick") as Control
	if joystick != null:
		joystick.visible = false
	var reset_button := _world.get_node_or_null("HUD/Touch/ResetToStart") as Button
	if reset_button != null:
		reset_button.disabled = true

func _build_hud() -> void:
	var hud := _world.get_node_or_null("HUD") as CanvasLayer
	if hud == null:
		return
	_panel = PanelContainer.new()
	_panel.name = "CombatTurnPanel"
	_panel.offset_left = 520.0
	_panel.offset_top = 190.0
	_panel.offset_right = 1195.0
	_panel.offset_bottom = 350.0
	_panel.add_to_group("hunt01_combat_ui")
	hud.add_child(_panel)
	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 4)
	_panel.add_child(layout)
	var title := Label.new()
	title.name = "Title"
	title.text = "TACTICAL ENCOUNTER • R01_EF02"
	title.add_theme_font_size_override("font_size", 20)
	layout.add_child(title)
	_state_label = Label.new()
	_state_label.name = "State"
	layout.add_child(_state_label)
	_resource_label = Label.new()
	_resource_label.name = "Resources"
	layout.add_child(_resource_label)
	var note := Label.new()
	note.name = "BoundaryNote"
	note.text = "Turn shell active • free roaming locked • reactions share RP/Stamina authority • terminal outcomes freeze this scheduler."
	layout.add_child(note)
	_end_turn_button = Button.new()
	_end_turn_button.name = "EndTurn"
	_end_turn_button.text = "END TURN"
	_end_turn_button.pressed.connect(_on_end_turn_pressed)
	layout.add_child(_end_turn_button)
	_refresh_hud()

func _on_end_turn_pressed() -> void:
	end_player_turn()

func _refresh_hud() -> void:
	if _state_label == null or _resource_label == null or _end_turn_button == null:
		return
	if _encounter_terminal:
		_state_label.text = "Encounter terminal • %s" % String(_terminal_state.get("outcome", "RESOLVED"))
		_resource_label.text = ""
		_end_turn_button.disabled = true
		return
	if _current_actor_id.is_empty():
		_state_label.text = "Round %d • resolving scheduler" % _round_id
		_resource_label.text = ""
		_end_turn_button.disabled = true
		return
	var state: Dictionary = _resources[_current_actor_id]
	var actor_label := "HUNTER" if _current_actor_id == HUNTER_COMBATANT_ID else "MUDCREST RAKER"
	_state_label.text = "Round %d • %s activation" % [_round_id, actor_label]
	_resource_label.text = "AP %d/%d • RP %d/%d • Stamina %d/%d" % [int(state["ap"]), int(state["max_ap"]), int(state["rp"]), int(state["max_rp"]), int(state["stamina"]), int(state["max_stamina"])]
	_end_turn_button.disabled = _current_actor_id != HUNTER_COMBATANT_ID

func get_schema() -> String:
	return SCHEMA

func is_initialized() -> bool:
	return _initialized

func get_current_state() -> Dictionary:
	return {"round_id": _round_id, "current_actor_id": _current_actor_id, "round_roster": _round_roster.duplicate(), "slot_states": _slot_states.duplicate(true), "monster_activation_driver_registered": _monster_activation_driver != null, "encounter_terminal": _encounter_terminal, "terminal_outcome": String(_terminal_state.get("outcome", ""))}

func get_terminal_state() -> Dictionary:
	return _terminal_state.duplicate(true)

func is_encounter_terminal() -> bool:
	return _encounter_terminal

func get_initiative_snapshot(combatant_id: String) -> Dictionary:
	if not _initiative_snapshots.has(combatant_id):
		return {}
	return (_initiative_snapshots[combatant_id] as Dictionary).duplicate(true)

func get_resource_state(combatant_id: String) -> Dictionary:
	if not _resources.has(combatant_id):
		return {}
	return (_resources[combatant_id] as Dictionary).duplicate(true)

func get_reaction_commit(window_id: String, combatant_id: String) -> Dictionary:
	var commit_key := "%s|%s" % [window_id, combatant_id]
	if not _reaction_commits.has(commit_key):
		return {}
	return (_reaction_commits[commit_key] as Dictionary).duplicate(true)

func get_trace() -> Array[Dictionary]:
	return _trace.duplicate(true)

func get_slot_state(combatant_id: String) -> String:
	return String(_slot_states.get(combatant_id, ""))

func attempt_duplicate_activation_for_test() -> bool:
	if _current_actor_id.is_empty():
		return false
	return _start_activation(_current_actor_id)
