extends Node

const COMBAT_TURN_SHELL_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd")
const TACTICAL_MOVEMENT_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_tactical_movement_runtime.gd")
const REACTION_WINDOW_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_reaction_window_runtime.gd")
const MUDCREST_ANATOMY_SCRIPT: Script = preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd")
const HUNTER_ATTACK_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_hunter_attack_runtime.gd")
const MUDCREST_ATTACK_SCRIPT: Script = preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd")
const ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const FOOTPRINT_ID := "R01_EF02"
const MONSTER_ID := "monster_r01_m01_0001"
const SOURCE_SECTOR_ID := "R01_S03"
const ENTRY_NODE_ID := "R01_EF02_N01"
const OBSERVATION_ANCHOR := Vector3(-72.0, 0.0, -236.0)
const ENGAGEMENT_ANCHOR := Vector3(-70.0, 0.0, -238.0)
const OBSERVATION_RADIUS_M := 7.0
const ENGAGEMENT_RADIUS_M := 4.0

var _world: Node3D = null
var _hunter: CharacterBody3D = null
var _monster: Node3D = null
var _tracking: Node = null
var _engage_button: Button = null
var _status_label: Label = null
var _toggle_view_button: Button = null
var _inside_observation := false
var _inside_engagement := false
var _encounter_started := false
var _state := "SEARCHING"
var _encounter_record: Dictionary = {}
var _combat_turn_shell: Node = null
var _tactical_movement_runtime: Node = null
var _reaction_window_runtime: Node = null
var _mudcrest_anatomy_runtime: Node = null
var _hunter_attack_runtime: Node = null
var _mudcrest_attack_runtime: Node = null

func _ready() -> void:
	call_deferred("_bind_runtime")

func _bind_runtime() -> void:
	_world = get_parent() as Node3D
	if _world == null:
		push_error("Hunt-01 encounter trigger requires the Region-01 world parent.")
		return
	_hunter = _world.get_node_or_null("Hunter") as CharacterBody3D
	_monster = _world.get_node_or_null("WorldGeometry/%s" % MONSTER_ID) as Node3D
	_tracking = _world.get_node_or_null("TrackingRuntime")
	_engage_button = _world.get_node_or_null("HUD/Touch/EngageEncounter") as Button
	_status_label = _world.get_node_or_null("HUD/EvidencePanel/EvidenceStatus") as Label
	_toggle_view_button = _world.get_node_or_null("HUD/Touch/ToggleView") as Button
	if _hunter == null or _monster == null or _tracking == null or _engage_button == null:
		push_error("Hunt-01 encounter trigger could not bind required runtime nodes.")
		return
	_create_zone("H01_OBSERVATION_ZONE", OBSERVATION_ANCHOR, OBSERVATION_RADIUS_M, "hunt01_observation_zone")
	_create_zone("H01_ENGAGEMENT_ZONE", ENGAGEMENT_ANCHOR, ENGAGEMENT_RADIUS_M, "hunt01_engagement_zone")
	_engage_button.visible = false
	_engage_button.disabled = true
	_engage_button.pressed.connect(_on_engage_pressed)
	_refresh_state()

func _process(_delta: float) -> void:
	if _hunter == null or _tracking == null:
		return
	_refresh_state()

func _create_zone(node_name: String, center: Vector3, radius: float, group_name: String) -> Area3D:
	var existing := _world.get_node_or_null("WorldGeometry/%s" % node_name) as Area3D
	if existing != null:
		return existing
	var area := Area3D.new()
	area.name = node_name
	area.position = center
	area.collision_layer = 0
	area.collision_mask = 1
	area.monitoring = true
	area.monitorable = true
	area.add_to_group(group_name)
	_world.get_node("WorldGeometry").add_child(area)
	var collision := CollisionShape3D.new()
	collision.position.y = 0.9
	var shape := SphereShape3D.new()
	shape.radius = radius
	collision.shape = shape
	area.add_child(collision)
	area.body_entered.connect(_on_zone_entered.bind(group_name))
	area.body_exited.connect(_on_zone_exited.bind(group_name))
	return area

func _on_zone_entered(body: Node3D, group_name: String) -> void:
	if body != _hunter:
		return
	if group_name == "hunt01_observation_zone":
		_inside_observation = true
	elif group_name == "hunt01_engagement_zone":
		_inside_engagement = true
	_refresh_state()

func _on_zone_exited(body: Node3D, group_name: String) -> void:
	if body != _hunter:
		return
	if group_name == "hunt01_observation_zone":
		_inside_observation = false
	elif group_name == "hunt01_engagement_zone":
		_inside_engagement = false
	_refresh_state()

func _tracking_ready() -> bool:
	if _tracking == null:
		return false
	var inference: Dictionary = _tracking.call("get_current_inference")
	return String(inference.get("phase", "")) == "OBSERVATION_READY"

func _refresh_state() -> void:
	if _encounter_started:
		_state = "ENCOUNTER_STAGED_FIRST_PERSON"
		_set_engage_button(false)
		return
	if not _tracking_ready():
		_state = "SEARCHING"
		_set_engage_button(false)
		return
	if _inside_engagement:
		_state = "ENGAGEMENT_AVAILABLE"
		_set_engage_button(true)
		if _status_label != null:
			_status_label.text = "Observation complete. Mudcrest Raker located in the Meadow. ENGAGE starts the same physical encounter; it does not teleport either actor."
		return
	if _inside_observation:
		_state = "OBSERVATION_AVAILABLE"
		_set_engage_button(false)
		if _status_label != null:
			_status_label.text = "Mudcrest Raker observed at the Meadow edge. Move a few meters into the engagement position when ready. Combat will not auto-start."
		return
	_state = "TRAIL_RESOLVED"
	_set_engage_button(false)

func _set_engage_button(enabled: bool) -> void:
	if _engage_button == null:
		return
	_engage_button.visible = enabled
	_engage_button.disabled = not enabled

func _on_engage_pressed() -> void:
	_engage()

func _engage() -> bool:
	if _encounter_started or not _tracking_ready() or not _inside_engagement:
		return false
	if _hunter == null or _monster == null:
		return false

	var hunter_before := _hunter.global_transform
	var monster_before := _monster.global_transform
	_encounter_record = {
		"encounter_id": ENCOUNTER_ID,
		"footprint_id": FOOTPRINT_ID,
		"monster_id": MONSTER_ID,
		"source_sector_id": SOURCE_SECTOR_ID,
		"player_tactical_node": ENTRY_NODE_ID,
		"player_world_position": hunter_before.origin,
		"monster_world_position": monster_before.origin,
		"entry_state": "ENCOUNTER_STAGED_FIRST_PERSON",
	}

	var first_person_camera := _world.get_node("Hunter/FirstPersonCamera") as Camera3D
	if not first_person_camera.current:
		_world.call("_on_toggle_view_pressed")
	if _toggle_view_button != null:
		_toggle_view_button.disabled = true

	for marker_variant in get_tree().get_nodes_in_group("hunt01_tactical_nodes"):
		var marker := marker_variant as Node3D
		if marker != null:
			marker.visible = true

	if not _hunter.global_transform.is_equal_approx(hunter_before) or not _monster.global_transform.is_equal_approx(monster_before):
		push_error("Encounter staging changed an actor world transform; same-location continuity violated.")
		return false

	if not _start_combat_turn_shell():
		push_error("Encounter staging could not start the authoritative combat runtime stack.")
		return false

	_encounter_started = true
	_state = "ENCOUNTER_STAGED_FIRST_PERSON"
	_set_engage_button(false)
	if _status_label != null:
		_status_label.text = "Encounter staged • R01_EF02 • deterministic turns, tactical movement, Measured Cut, Mudcrest integrity, shared reactions and first Head Sweep hostile attack active. Final Hunter damage remains a later layer."
	return true

func _start_combat_turn_shell() -> bool:
	if _combat_turn_shell != null:
		return false
	var shell := COMBAT_TURN_SHELL_SCRIPT.new() as Node
	if shell == null:
		return false
	shell.name = "CombatTurnShellRuntime"
	_world.add_child(shell)
	if not bool(shell.call("initialize", _world, _encounter_record)):
		shell.queue_free()
		return false

	var movement := TACTICAL_MOVEMENT_SCRIPT.new() as Node
	if movement == null:
		shell.queue_free()
		return false
	movement.name = "TacticalMovementRuntime"
	shell.add_child(movement)
	if not bool(movement.call("initialize", _world, shell, _encounter_record)):
		movement.queue_free()
		shell.queue_free()
		return false

	var reaction := REACTION_WINDOW_SCRIPT.new() as Node
	if reaction == null:
		movement.queue_free()
		shell.queue_free()
		return false
	reaction.name = "ReactionWindowRuntime"
	shell.add_child(reaction)
	if not bool(reaction.call("initialize", _world, shell, _encounter_record)):
		reaction.queue_free()
		movement.queue_free()
		shell.queue_free()
		return false

	var anatomy := MUDCREST_ANATOMY_SCRIPT.new() as Node
	if anatomy == null:
		reaction.queue_free()
		movement.queue_free()
		shell.queue_free()
		return false
	anatomy.name = "MudcrestAnatomyRuntime"
	shell.add_child(anatomy)
	if not bool(anatomy.call("initialize", _world, _encounter_record)):
		anatomy.queue_free()
		reaction.queue_free()
		movement.queue_free()
		shell.queue_free()
		return false

	var attack := HUNTER_ATTACK_SCRIPT.new() as Node
	if attack == null:
		anatomy.queue_free()
		reaction.queue_free()
		movement.queue_free()
		shell.queue_free()
		return false
	attack.name = "HunterAttackRuntime"
	shell.add_child(attack)
	if not bool(attack.call("initialize", _world, shell, movement, anatomy, _encounter_record)):
		attack.queue_free()
		anatomy.queue_free()
		reaction.queue_free()
		movement.queue_free()
		shell.queue_free()
		return false

	var mudcrest_attack := MUDCREST_ATTACK_SCRIPT.new() as Node
	if mudcrest_attack == null:
		attack.queue_free()
		anatomy.queue_free()
		reaction.queue_free()
		movement.queue_free()
		shell.queue_free()
		return false
	mudcrest_attack.name = "MudcrestAttackRuntime"
	shell.add_child(mudcrest_attack)
	if not bool(mudcrest_attack.call("initialize", _world, shell, reaction, anatomy, _encounter_record)):
		mudcrest_attack.queue_free()
		attack.queue_free()
		anatomy.queue_free()
		reaction.queue_free()
		movement.queue_free()
		shell.queue_free()
		return false

	_combat_turn_shell = shell
	_tactical_movement_runtime = movement
	_reaction_window_runtime = reaction
	_mudcrest_anatomy_runtime = anatomy
	_hunter_attack_runtime = attack
	_mudcrest_attack_runtime = mudcrest_attack
	return true

func get_state() -> String:
	return _state

func has_encounter_started() -> bool:
	return _encounter_started

func get_encounter_record() -> Dictionary:
	return _encounter_record.duplicate(true)

func is_inside_observation_zone() -> bool:
	return _inside_observation

func is_inside_engagement_zone() -> bool:
	return _inside_engagement

func has_combat_turn_shell_started() -> bool:
	return _combat_turn_shell != null and bool(_combat_turn_shell.call("is_initialized"))

func get_combat_turn_shell() -> Node:
	return _combat_turn_shell

func has_tactical_movement_started() -> bool:
	return _tactical_movement_runtime != null and bool(_tactical_movement_runtime.call("is_initialized"))

func get_tactical_movement_runtime() -> Node:
	return _tactical_movement_runtime

func has_reaction_window_started() -> bool:
	return _reaction_window_runtime != null and bool(_reaction_window_runtime.call("is_initialized"))

func get_reaction_window_runtime() -> Node:
	return _reaction_window_runtime

func has_mudcrest_anatomy_started() -> bool:
	return _mudcrest_anatomy_runtime != null and bool(_mudcrest_anatomy_runtime.call("is_initialized"))

func get_mudcrest_anatomy_runtime() -> Node:
	return _mudcrest_anatomy_runtime

func has_hunter_attack_started() -> bool:
	return _hunter_attack_runtime != null and bool(_hunter_attack_runtime.call("is_initialized"))

func get_hunter_attack_runtime() -> Node:
	return _hunter_attack_runtime

func has_mudcrest_attack_started() -> bool:
	return _mudcrest_attack_runtime != null and bool(_mudcrest_attack_runtime.call("is_initialized"))

func get_mudcrest_attack_runtime() -> Node:
	return _mudcrest_attack_runtime

func engage_for_test() -> bool:
	return _engage()
