extends Node

const SCHEMA := "uhr.hunt01.tactical_movement.v1"
const MANIFEST_PATH := "res://content/regions/region_01/hunt01_graybox_build_manifest.json"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const ENTRY_NODE_ID := "R01_EF02_N01"
const MOVE_ACTION_ID := "TACTICAL_MOVE_ADJACENT"
const MOVE_AP_COST := 1

const TERRAIN_MOVE_SURCHARGE := {
	"STABLE_GROUND": 0,
	"ROUGH_GROUND": 1,
	"SHALLOW_WATER": 2,
	"MUD": 3,
}

const TERRAIN_FOOTING := {
	"STABLE_GROUND": "FOOTING_STABLE",
	"ROUGH_GROUND": "FOOTING_UNSTEADY",
	"SHALLOW_WATER": "FOOTING_UNSTEADY",
	"MUD": "FOOTING_COMPROMISED",
}

var _world: Node3D = null
var _shell: Node = null
var _hunter: CharacterBody3D = null
var _encounter_record: Dictionary = {}
var _nodes: Dictionary = {}
var _links: Dictionary = {}
var _current_node_id := ""
var _initialized := false
var _trace: Array[Dictionary] = []
var _trace_sequence := 0

var _panel: PanelContainer = null
var _node_label: Label = null
var _resource_label: Label = null
var _destinations: VBoxContainer = null

func initialize(world: Node3D, shell: Node, encounter_record: Dictionary) -> bool:
	if _initialized or world == null or shell == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not _load_graph():
		return false

	_world = world
	_shell = shell
	_encounter_record = encounter_record.duplicate(true)
	_hunter = _world.get_node_or_null("Hunter") as CharacterBody3D
	if _hunter == null:
		return false

	_current_node_id = String(_encounter_record.get("player_tactical_node", ENTRY_NODE_ID))
	if not _nodes.has(_current_node_id):
		return false

	_build_hud()
	_initialized = true
	_record_trace("TACTICAL_MOVEMENT_READY", {
		"current_node_id": _current_node_id,
		"node_count": _nodes.size(),
		"link_count": _count_undirected_links(),
	})
	_refresh_hud()
	return true

func _load_graph() -> bool:
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var manifest := parsed as Dictionary
	if String(manifest.get("encounter", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not manifest.has("nodes") or not manifest.has("links"):
		return false

	_nodes.clear()
	_links.clear()
	for entry_variant in manifest["nodes"]:
		var entry: Array = entry_variant
		if entry.size() < 4:
			return false
		var node_id := String(entry[0])
		var position_values: Array = entry[1]
		var tags: Array = entry[3]
		_nodes[node_id] = {
			"position": Vector3(float(position_values[0]), float(position_values[1]), float(position_values[2])),
			"surface": String(entry[2]),
			"tags": tags.duplicate(true),
		}
		_links[node_id] = []

	for link_variant in manifest["links"]:
		var link: Array = link_variant
		if link.size() < 2:
			return false
		var a := String(link[0])
		var b := String(link[1])
		if not _nodes.has(a) or not _nodes.has(b):
			return false
		(_links[a] as Array).append(b)
		(_links[b] as Array).append(a)
	return _nodes.has(ENTRY_NODE_ID)

func _count_undirected_links() -> int:
	var directed_count := 0
	for value in _links.values():
		directed_count += (value as Array).size()
	return directed_count / 2

func _build_hud() -> void:
	var hud := _world.get_node_or_null("HUD") as CanvasLayer
	if hud == null:
		return
	_panel = PanelContainer.new()
	_panel.name = "TacticalMovementPanel"
	_panel.offset_left = 520.0
	_panel.offset_top = 360.0
	_panel.offset_right = 1195.0
	_panel.offset_bottom = 680.0
	_panel.add_to_group("hunt01_tactical_movement_ui")
	hud.add_child(_panel)

	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 5)
	_panel.add_child(layout)

	var title := Label.new()
	title.name = "Title"
	title.text = "TACTICAL MOVEMENT"
	title.add_theme_font_size_override("font_size", 19)
	layout.add_child(title)

	_node_label = Label.new()
	_node_label.name = "CurrentNode"
	layout.add_child(_node_label)

	_resource_label = Label.new()
	_resource_label.name = "MovementRule"
	layout.add_child(_resource_label)

	_destinations = VBoxContainer.new()
	_destinations.name = "Destinations"
	_destinations.add_theme_constant_override("separation", 3)
	layout.add_child(_destinations)

func _refresh_hud() -> void:
	if _node_label == null or _resource_label == null or _destinations == null:
		return
	var node_state := get_node_state(_current_node_id)
	_node_label.text = "Node %s • %s • %s" % [
		_current_node_id,
		String(node_state.get("surface", "")),
		String(TERRAIN_FOOTING.get(String(node_state.get("surface", "")), "FOOTING_UNKNOWN")),
	]
	_resource_label.text = "Adjacent move = 1 AP + destination terrain Stamina • authored links only"

	while _destinations.get_child_count() > 0:
		_destinations.get_child(0).free()

	var available := get_available_destinations()
	for destination_variant in available:
		var destination_id := String(destination_variant)
		var cost := get_move_cost(destination_id)
		var button := Button.new()
		button.name = "Move_%s" % destination_id
		button.text = "MOVE %s • %d AP + %d STA • %s" % [
			destination_id,
			int(cost.get("ap_cost", MOVE_AP_COST)),
			int(cost.get("stamina_cost", 0)),
			String(cost.get("destination_surface", "")),
		]
		button.disabled = not _hunter_has_activation() or not bool(cost.get("legal", false))
		button.pressed.connect(_on_move_button_pressed.bind(destination_id))
		_destinations.add_child(button)

func _hunter_has_activation() -> bool:
	if _shell == null:
		return false
	var state: Dictionary = _shell.call("get_current_state")
	return String(state.get("current_actor_id", "")) == HUNTER_COMBATANT_ID

func _on_move_button_pressed(destination_id: String) -> void:
	try_move(destination_id)

func get_move_cost(destination_id: String) -> Dictionary:
	if not _initialized and _nodes.is_empty():
		return {"legal": false, "reason": "NOT_INITIALIZED"}
	if not _nodes.has(destination_id):
		return {"legal": false, "reason": "UNKNOWN_DESTINATION"}
	if not (_links.get(_current_node_id, []) as Array).has(destination_id):
		return {"legal": false, "reason": "NON_ADJACENT_DESTINATION"}
	var destination: Dictionary = _nodes[destination_id]
	var surface := String(destination.get("surface", ""))
	if not TERRAIN_MOVE_SURCHARGE.has(surface):
		return {"legal": false, "reason": "UNSUPPORTED_TERRAIN", "destination_surface": surface}
	return {
		"legal": true,
		"reason": "AUTHORED_LINK_VALID",
		"action_id": MOVE_ACTION_ID,
		"ap_cost": MOVE_AP_COST,
		"base_stamina_cost": 0,
		"terrain_stamina_surcharge": int(TERRAIN_MOVE_SURCHARGE[surface]),
		"stamina_cost": int(TERRAIN_MOVE_SURCHARGE[surface]),
		"destination_surface": surface,
		"destination_footing": String(TERRAIN_FOOTING.get(surface, "FOOTING_UNKNOWN")),
		"destination_tags": (destination.get("tags", []) as Array).duplicate(true),
	}

func try_move(destination_id: String) -> bool:
	if not _initialized:
		return false
	if not _hunter_has_activation():
		_record_rejection(destination_id, "NOT_HUNTER_ACTIVATION")
		_refresh_hud()
		return false
	var cost := get_move_cost(destination_id)
	if not bool(cost.get("legal", false)):
		_record_rejection(destination_id, String(cost.get("reason", "ILLEGAL_MOVE")))
		_refresh_hud()
		return false

	var origin_id := _current_node_id
	var origin: Dictionary = _nodes[origin_id]
	var destination: Dictionary = _nodes[destination_id]
	var stamina_cost := int(cost.get("stamina_cost", 0))
	if not bool(_shell.call("try_commit_cost", HUNTER_COMBATANT_ID, "%s:%s" % [MOVE_ACTION_ID, destination_id], MOVE_AP_COST, stamina_cost)):
		_record_rejection(destination_id, "INSUFFICIENT_RESOURCES")
		_refresh_hud()
		return false

	var authored_position: Vector3 = destination["position"]
	var previous_position := _hunter.global_position
	_hunter.global_position = Vector3(authored_position.x, previous_position.y, authored_position.z)
	_hunter.velocity = Vector3.ZERO
	_current_node_id = destination_id
	_record_trace("TACTICAL_MOVE_COMMITTED", {
		"action_id": MOVE_ACTION_ID,
		"combatant_id": HUNTER_COMBATANT_ID,
		"origin_node_id": origin_id,
		"destination_node_id": destination_id,
		"origin_surface": String(origin.get("surface", "")),
		"destination_surface": String(destination.get("surface", "")),
		"destination_tags": (destination.get("tags", []) as Array).duplicate(true),
		"base_ap_cost": MOVE_AP_COST,
		"base_stamina_cost": 0,
		"terrain_stamina_surcharge": stamina_cost,
		"final_ap_cost": MOVE_AP_COST,
		"final_stamina_cost": stamina_cost,
		"footing": String(cost.get("destination_footing", "")),
		"clearance": "AUTHORED_LINK_VALID",
		"world_position_before": previous_position,
		"world_position_after": _hunter.global_position,
		"result": "MOVED",
	})
	_refresh_hud()
	return true

func _record_rejection(destination_id: String, reason: String) -> void:
	_record_trace("TACTICAL_MOVE_REJECTED", {
		"action_id": MOVE_ACTION_ID,
		"combatant_id": HUNTER_COMBATANT_ID,
		"origin_node_id": _current_node_id,
		"destination_node_id": destination_id,
		"reason": reason,
		"result": "REJECTED",
	})

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

func get_schema() -> String:
	return SCHEMA

func is_initialized() -> bool:
	return _initialized

func get_current_node_id() -> String:
	return _current_node_id

func get_available_destinations() -> Array:
	if not _links.has(_current_node_id):
		return []
	var destinations: Array = (_links[_current_node_id] as Array).duplicate()
	destinations.sort()
	return destinations

func get_node_state(node_id: String) -> Dictionary:
	if not _nodes.has(node_id):
		return {}
	return (_nodes[node_id] as Dictionary).duplicate(true)

func get_trace() -> Array:
	return _trace.duplicate(true)

func get_node_count() -> int:
	return _nodes.size()

func get_link_count() -> int:
	return _count_undirected_links()

func move_for_test(destination_id: String) -> bool:
	return try_move(destination_id)
