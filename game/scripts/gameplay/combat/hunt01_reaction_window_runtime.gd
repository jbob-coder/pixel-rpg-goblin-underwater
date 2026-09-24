extends Node

const SCHEMA := "uhr.hunt01.reaction_window.v1"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"

const REACTION_POLEBLADE_BLOCK := "POLEBLADE_BLOCK"
const REACTION_DECLINE := "DECLINE_REACTION"
const BLOCK_RP_COST := 1
const BLOCK_STAMINA_COST := 6
const BLOCK_COST_AUTHORITY := "MONSTER_01_COMBAT_ATTACK_PACKET_RECORDED_FIELD_POLEBLADE_BLOCK_COMMITMENT"

const STATE_IDLE := "IDLE"
const STATE_OPEN := "OPEN"
const STATE_COMMITTED := "COMMITTED_WAITING_SOURCE_RESOLUTION"
const STATE_DECLINED := "DECLINED_WAITING_SOURCE_RESOLUTION"
const STATE_CLOSED := "CLOSED"

var _world: Node3D = null
var _shell: Node = null
var _encounter_record: Dictionary = {}
var _initialized := false
var _state := STATE_IDLE
var _active_window: Dictionary = {}
var _window_fingerprints: Dictionary = {}
var _closed_windows: Dictionary = {}
var _trace: Array[Dictionary] = []
var _trace_sequence := 0

var _panel: PanelContainer = null
var _telegraph_label: Label = null
var _resource_label: Label = null
var _block_button: Button = null
var _decline_button: Button = null
var _result_label: Label = null

func initialize(world: Node3D, shell: Node, encounter_record: Dictionary) -> bool:
	if _initialized or world == null or shell == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not bool(shell.call("is_initialized")):
		return false
	_world = world
	_shell = shell
	_encounter_record = encounter_record.duplicate(true)
	_build_hud()
	_initialized = true
	_record_trace("REACTION_RUNTIME_READY", {
		"supported_reaction": REACTION_POLEBLADE_BLOCK,
		"block_rp_cost": BLOCK_RP_COST,
		"block_stamina_cost": BLOCK_STAMINA_COST,
		"cost_authority": BLOCK_COST_AUTHORITY,
	})
	_refresh_hud()
	return true

func open_window(source_actor_id: String, source_action_id: String, source_action_sequence: int, allowed_reactions: Array[String], telegraph_text: String = "") -> Dictionary:
	if not _initialized:
		return _rejection("REACTION_RUNTIME_NOT_INITIALIZED")
	if source_actor_id != MONSTER_COMBATANT_ID:
		return _rejection("UNSUPPORTED_REACTION_SOURCE")
	if source_action_id.is_empty() or source_action_sequence <= 0:
		return _rejection("INVALID_SOURCE_ACTION_IDENTITY")

	var shell_state: Dictionary = _shell.call("get_current_state")
	if String(shell_state.get("current_actor_id", "")) != source_actor_id:
		return _rejection("SOURCE_ACTOR_NOT_CURRENT_ACTIVATION")
	var round_id := int(shell_state.get("round_id", 0))
	var window_id := "%s|R%d|%s|%s|A%d" % [
		EXPECTED_ENCOUNTER_ID,
		round_id,
		source_actor_id,
		source_action_id,
		source_action_sequence,
	]
	var normalized_allowed := _normalize_allowed_reactions(allowed_reactions)
	var fingerprint := "%s|%s|%d|%s" % [source_actor_id, source_action_id, source_action_sequence, str(normalized_allowed)]

	if _closed_windows.has(window_id):
		var closed: Dictionary = (_closed_windows[window_id] as Dictionary).duplicate(true)
		if String(_window_fingerprints.get(window_id, "")) != fingerprint:
			return _rejection("REACTION_WINDOW_ID_COLLISION")
		closed["duplicate"] = true
		return closed

	if not _active_window.is_empty():
		if String(_active_window.get("window_id", "")) == window_id and String(_window_fingerprints.get(window_id, "")) == fingerprint:
			var existing := _active_window.duplicate(true)
			existing["duplicate"] = true
			return existing
		return _rejection("REACTION_WINDOW_ALREADY_ACTIVE")

	if not normalized_allowed.has(REACTION_POLEBLADE_BLOCK):
		return _rejection("NO_IMPLEMENTED_REACTION_AVAILABLE")

	_active_window = {
		"success": true,
		"duplicate": false,
		"schema": SCHEMA,
		"window_id": window_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"round_id": round_id,
		"source_actor_id": source_actor_id,
		"reactor_id": HUNTER_COMBATANT_ID,
		"source_action_id": source_action_id,
		"source_action_sequence": source_action_sequence,
		"allowed_reactions": normalized_allowed.duplicate(),
		"supported_reactions": [REACTION_POLEBLADE_BLOCK],
		"always_available_choice": REACTION_DECLINE,
		"telegraph_text": telegraph_text,
		"state": STATE_OPEN,
		"resolution_status": "REACTION_DECISION_PENDING",
	}
	_window_fingerprints[window_id] = fingerprint
	_state = STATE_OPEN
	_record_trace("REACTION_WINDOW_OPENED", _active_window)
	_refresh_hud()
	return _active_window.duplicate(true)

func commit_reaction(window_id: String, reaction_id: String) -> Dictionary:
	if not _initialized:
		return _rejection("REACTION_RUNTIME_NOT_INITIALIZED")
	if _active_window.is_empty() or String(_active_window.get("window_id", "")) != window_id:
		if _closed_windows.has(window_id):
			var closed: Dictionary = (_closed_windows[window_id] as Dictionary).duplicate(true)
			closed["duplicate"] = true
			return closed
		return _rejection("REACTION_WINDOW_NOT_ACTIVE")

	if String(_active_window.get("state", "")) == STATE_COMMITTED:
		if String(_active_window.get("reaction_id", "")) == reaction_id:
			var duplicate := _active_window.duplicate(true)
			duplicate["duplicate"] = true
			return duplicate
		return _rejection("REACTION_ALREADY_COMMITTED")
	if String(_active_window.get("state", "")) != STATE_OPEN:
		return _rejection("REACTION_DECISION_ALREADY_FINAL")
	if reaction_id == REACTION_DECLINE:
		return decline_reaction(window_id)
	if reaction_id != REACTION_POLEBLADE_BLOCK:
		return _rejection("REACTION_NOT_IMPLEMENTED")
	var allowed: Array = _active_window.get("allowed_reactions", [])
	if not allowed.has(reaction_id):
		return _rejection("REACTION_NOT_ALLOWED_BY_SOURCE_ACTION")

	var cost_result: Dictionary = _shell.call(
		"try_commit_reaction_cost",
		HUNTER_COMBATANT_ID,
		String(_active_window.get("source_actor_id", "")),
		reaction_id,
		window_id,
		BLOCK_RP_COST,
		BLOCK_STAMINA_COST
	)
	if not bool(cost_result.get("success", false)):
		var rejected := _rejection(String(cost_result.get("reason", "REACTION_RESOURCE_COMMIT_FAILED")))
		rejected["window_id"] = window_id
		rejected["reaction_id"] = reaction_id
		_record_trace("REACTION_COMMIT_REJECTED", rejected)
		_refresh_hud()
		return rejected

	_active_window["reaction_id"] = reaction_id
	_active_window["state"] = STATE_COMMITTED
	_active_window["resolution_status"] = "PENDING_ATTACK_DEFENSE_RESOLUTION"
	_active_window["rp_cost"] = BLOCK_RP_COST
	_active_window["stamina_cost"] = BLOCK_STAMINA_COST
	_active_window["cost_authority"] = BLOCK_COST_AUTHORITY
	_active_window["duplicate"] = false
	_state = STATE_COMMITTED
	_record_trace("REACTION_COMMITTED", _active_window)
	_refresh_hud()
	return _active_window.duplicate(true)

func decline_reaction(window_id: String) -> Dictionary:
	if not _initialized:
		return _rejection("REACTION_RUNTIME_NOT_INITIALIZED")
	if _active_window.is_empty() or String(_active_window.get("window_id", "")) != window_id:
		if _closed_windows.has(window_id):
			var closed: Dictionary = (_closed_windows[window_id] as Dictionary).duplicate(true)
			closed["duplicate"] = true
			return closed
		return _rejection("REACTION_WINDOW_NOT_ACTIVE")
	if String(_active_window.get("state", "")) != STATE_OPEN:
		return _rejection("REACTION_DECISION_ALREADY_FINAL")

	_active_window["reaction_id"] = REACTION_DECLINE
	_active_window["state"] = STATE_DECLINED
	_active_window["resolution_status"] = "PENDING_ATTACK_RESOLUTION_NO_REACTION"
	_active_window["rp_cost"] = 0
	_active_window["stamina_cost"] = 0
	_active_window["duplicate"] = false
	_state = STATE_DECLINED
	_record_trace("REACTION_DECLINED", _active_window)
	_refresh_hud()
	return _active_window.duplicate(true)

func close_window(window_id: String, source_resolution_status: String) -> Dictionary:
	if not _initialized:
		return _rejection("REACTION_RUNTIME_NOT_INITIALIZED")
	if _active_window.is_empty() or String(_active_window.get("window_id", "")) != window_id:
		if _closed_windows.has(window_id):
			var closed: Dictionary = (_closed_windows[window_id] as Dictionary).duplicate(true)
			closed["duplicate"] = true
			return closed
		return _rejection("REACTION_WINDOW_NOT_ACTIVE")
	var current_state := String(_active_window.get("state", ""))
	if current_state != STATE_COMMITTED and current_state != STATE_DECLINED:
		return _rejection("REACTION_DECISION_NOT_FINAL")
	if source_resolution_status.is_empty():
		return _rejection("SOURCE_RESOLUTION_STATUS_REQUIRED")

	var closed := _active_window.duplicate(true)
	closed["state"] = STATE_CLOSED
	closed["source_resolution_status"] = source_resolution_status
	closed["duplicate"] = false
	_closed_windows[window_id] = closed.duplicate(true)
	_record_trace("REACTION_WINDOW_CLOSED", closed)
	_active_window.clear()
	_state = STATE_IDLE
	_refresh_hud()
	return closed

func _normalize_allowed_reactions(allowed_reactions: Array[String]) -> Array[String]:
	var normalized: Array[String] = []
	for reaction_id in allowed_reactions:
		if reaction_id.is_empty() or normalized.has(reaction_id):
			continue
		normalized.append(reaction_id)
	normalized.sort()
	return normalized

func _rejection(reason: String) -> Dictionary:
	return {
		"success": false,
		"reason": reason,
		"schema": SCHEMA,
	}

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {
		"sequence": _trace_sequence,
		"event": event_name,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
	}
	for key in details.keys():
		entry[key] = details[key]
	_trace.append(entry)

func _build_hud() -> void:
	var hud := _world.get_node_or_null("HUD") as CanvasLayer
	if hud == null:
		return
	_panel = PanelContainer.new()
	_panel.name = "ReactionWindowPanel"
	_panel.offset_left = 520.0
	_panel.offset_top = 360.0
	_panel.offset_right = 1195.0
	_panel.offset_bottom = 555.0
	_panel.visible = false
	_panel.add_to_group("hunt01_reaction_ui")
	hud.add_child(_panel)

	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 4)
	_panel.add_child(layout)

	var title := Label.new()
	title.name = "Title"
	title.text = "REACTION WINDOW"
	title.add_theme_font_size_override("font_size", 19)
	layout.add_child(title)

	_telegraph_label = Label.new()
	_telegraph_label.name = "Telegraph"
	_telegraph_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(_telegraph_label)

	_resource_label = Label.new()
	_resource_label.name = "Resources"
	layout.add_child(_resource_label)

	_block_button = Button.new()
	_block_button.name = "PolebladeBlock"
	_block_button.text = "BLOCK • 1 RP + 6 Stamina"
	_block_button.pressed.connect(_on_block_pressed)
	layout.add_child(_block_button)

	_decline_button = Button.new()
	_decline_button.name = "Decline"
	_decline_button.text = "DECLINE REACTION"
	_decline_button.pressed.connect(_on_decline_pressed)
	layout.add_child(_decline_button)

	_result_label = Label.new()
	_result_label.name = "Result"
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(_result_label)

func _on_block_pressed() -> void:
	if _active_window.is_empty():
		return
	commit_reaction(String(_active_window.get("window_id", "")), REACTION_POLEBLADE_BLOCK)

func _on_decline_pressed() -> void:
	if _active_window.is_empty():
		return
	decline_reaction(String(_active_window.get("window_id", "")))

func _refresh_hud() -> void:
	if _panel == null or _telegraph_label == null or _resource_label == null or _block_button == null or _decline_button == null or _result_label == null:
		return
	_panel.visible = not _active_window.is_empty()
	if _active_window.is_empty():
		return

	var window_state := String(_active_window.get("state", ""))
	var telegraph := String(_active_window.get("telegraph_text", ""))
	_telegraph_label.text = telegraph if not telegraph.is_empty() else "%s telegraphed by Mudcrest Raker" % String(_active_window.get("source_action_id", "UNKNOWN_ACTION"))
	var hunter_resources: Dictionary = _shell.call("get_resource_state", HUNTER_COMBATANT_ID)
	_resource_label.text = "Hunter RP %d/%d • Stamina %d/%d" % [
		int(hunter_resources.get("rp", 0)),
		int(hunter_resources.get("max_rp", 0)),
		int(hunter_resources.get("stamina", 0)),
		int(hunter_resources.get("max_stamina", 0)),
	]
	var allowed: Array = _active_window.get("allowed_reactions", [])
	_block_button.disabled = window_state != STATE_OPEN or not allowed.has(REACTION_POLEBLADE_BLOCK) or int(hunter_resources.get("rp", 0)) < BLOCK_RP_COST or int(hunter_resources.get("stamina", 0)) < BLOCK_STAMINA_COST
	_decline_button.disabled = window_state != STATE_OPEN
	if window_state == STATE_OPEN:
		_result_label.text = "Choose one normal reaction. Block commitment is authoritative; defense outcome waits for the hostile action resolver."
	elif window_state == STATE_COMMITTED:
		_result_label.text = "BLOCK COMMITTED • defense outcome pending hostile-action resolution."
	elif window_state == STATE_DECLINED:
		_result_label.text = "REACTION DECLINED • hostile-action resolution pending."

func get_schema() -> String:
	return SCHEMA

func is_initialized() -> bool:
	return _initialized

func get_state() -> String:
	return _state

func get_active_window() -> Dictionary:
	return _active_window.duplicate(true)

func get_closed_window(window_id: String) -> Dictionary:
	if not _closed_windows.has(window_id):
		return {}
	return (_closed_windows[window_id] as Dictionary).duplicate(true)

func get_trace() -> Array[Dictionary]:
	return _trace.duplicate(true)
