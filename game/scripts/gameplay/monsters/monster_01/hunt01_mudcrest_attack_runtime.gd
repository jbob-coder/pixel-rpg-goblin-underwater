extends Node

const SCHEMA := "uhr.hunt01.mudcrest_attack.v1"
const MANIFEST_PATH := "res://content/regions/region_01/hunt01_graybox_build_manifest.json"
const HEAD_SWEEP_TELEGRAPH_SCENE: PackedScene = preload("res://assets/effects/mudcrest_head_sweep_telegraph.tscn")
const TAIL_SWEEP_TELEGRAPH_SCENE: PackedScene = preload("res://assets/effects/mudcrest_tail_sweep_telegraph.tscn")
const HUNTER_DEFENSE_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_hunter_defense_consequence_runtime.gd")
const WOUND_CONTACT_SCRIPT: Script = preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd")
const ENCOUNTER_OUTCOME_SCRIPT: Script = preload("res://scripts/gameplay/combat/hunt01_encounter_outcome_runtime.gd")

const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"

# Existing verified Head Sweep identity/balance fixture. Keep these names stable:
# older regressions intentionally assert them as continuity contracts.
const ATTACK_ID := "M01_HEAD_SWEEP_GORE"
const CAPABILITY_ID := "CAP_M01_HEAD_ATTACK"
const AP_COST := 2
const STAMINA_COST := 14
const REACTION_POLEBLADE_BLOCK := "POLEBLADE_BLOCK"
const REACTION_DECLINE := "DECLINE_REACTION"
const STANDARD_BLOCK_IMPACT_DRAIN_STAMINA := 10
const WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M := 3.5
const PROVISIONAL_ATTACK_CONTROL_BASE := 68
const PROVISIONAL_HUNTER_DEFENSE_CONTROL := 54
const PROVISIONAL_BLOCK_DEFENSE_CONTROL_BONUS := 8
const VARIANCE_MIN := -6
const VARIANCE_MAX := 6
const FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_MUDCREST_HEAD_SWEEP_CONTROL_FIXTURE"
const STRUCTURAL_CAPABILITY_STATUS := "PROVISIONAL_BASELINE_HEAD_HORNS_USABLE_NO_BREAK_STATE_RUNTIME"

# First intact-tail attack slice. Geometry/control constants are reversible fixtures;
# the authored attack economy/channel/Block-drain values come from COMBAT_ATTACK_PACKET.
const TAIL_SWEEP_ATTACK_ID := "M01_TAIL_SWEEP"
const TAIL_SWEEP_CAPABILITY_ID := "CAP_M01_TAIL_SWEEP"
const TAIL_SWEEP_AP_COST := 3
const TAIL_SWEEP_STAMINA_COST := 18
const TAIL_SWEEP_STANDARD_BLOCK_IMPACT_DRAIN_STAMINA := 14
const TAIL_SWEEP_MAX_BODY_ENVELOPE_DISTANCE_M := 6.0
const TAIL_SWEEP_MAX_FORWARD_DOT := 0.25
const TAIL_SWEEP_PROVISIONAL_ATTACK_CONTROL_BASE := 68
const TAIL_SWEEP_FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_MUDCREST_TAIL_SWEEP_CONTROL_FIXTURE"
const TAIL_SWEEP_STRUCTURAL_CAPABILITY_STATUS := "PROVISIONAL_BASELINE_TAIL_DISTAL_ATTACHED_NO_SEVER_STATE_RUNTIME"

var _world: Node3D = null
var _shell: Node = null
var _reaction: Node = null
var _anatomy: Node = null
var _hunter_defense: Node = null
var _wound_contact: Node = null
var _encounter_outcome: Node = null
var _hunter: CharacterBody3D = null
var _monster: Node3D = null
var _encounter_record: Dictionary = {}
var _body_force_center := Vector2.ZERO
var _body_force_half_size := Vector2.ZERO
var _authored_forward_xz := Vector2.ZERO
var _pivot_center_xz := Vector2.ZERO
var _pivot_radius_m := 0.0
var _initialized := false
var _driver_registered := false
var _attack_sequence := 0
var _active_attack: Dictionary = {}
var _last_resolution: Dictionary = {}
var _resolutions: Dictionary = {}
var _trace_sequence := 0
var _trace: Array[Dictionary] = []
var _telegraph_visual: Node3D = null

func initialize(world: Node3D, shell: Node, reaction: Node, anatomy: Node, encounter_record: Dictionary) -> bool:
	if _initialized or world == null or shell == null or reaction == null or anatomy == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not bool(reaction.call("is_initialized")) or not bool(anatomy.call("is_initialized")):
		return false
	if not _load_manifest_context():
		return false

	_world = world
	_shell = shell
	_reaction = reaction
	_anatomy = anatomy
	_encounter_record = encounter_record.duplicate(true)
	_hunter = _world.get_node_or_null("Hunter") as CharacterBody3D
	_monster = _world.get_node_or_null("WorldGeometry/%s" % MONSTER_COMBATANT_ID) as Node3D
	if _hunter == null or _monster == null:
		return false

	var defense := HUNTER_DEFENSE_SCRIPT.new() as Node
	if defense == null:
		return false
	defense.name = "HunterDefenseConsequenceRuntime"
	_shell.add_child(defense)
	if not bool(defense.call("initialize", _shell, _encounter_record)):
		defense.queue_free()
		return false
	_hunter_defense = defense

	var wound_contact := WOUND_CONTACT_SCRIPT.new() as Node
	if wound_contact == null:
		return false
	wound_contact.name = "MudcrestWoundContactRuntime"
	add_child(wound_contact)
	if not bool(wound_contact.call("initialize", _encounter_record)):
		wound_contact.queue_free()
		return false
	_wound_contact = wound_contact

	if not _bind_encounter_outcome_runtime():
		return false

	_initialized = true
	_record_trace("MUDCREST_ATTACK_RUNTIME_READY", {
		"attack_id": ATTACK_ID,
		"tail_sweep_attack_id": TAIL_SWEEP_ATTACK_ID,
		"ap_cost": AP_COST,
		"stamina_cost": STAMINA_COST,
		"tail_sweep_ap_cost": TAIL_SWEEP_AP_COST,
		"tail_sweep_stamina_cost": TAIL_SWEEP_STAMINA_COST,
		"fixture_status": FIXTURE_STATUS,
		"tail_sweep_fixture_status": TAIL_SWEEP_FIXTURE_STATUS,
		"structural_capability_status": STRUCTURAL_CAPABILITY_STATUS,
		"tail_sweep_structural_capability_status": TAIL_SWEEP_STRUCTURAL_CAPABILITY_STATUS,
		"hunter_defense_schema": String(_hunter_defense.call("get_schema")),
		"wound_contact_schema": String(_wound_contact.call("get_schema")),
		"encounter_outcome_schema": String(_encounter_outcome.call("get_schema")),
	})
	call_deferred("_register_activation_driver")
	return true

func _bind_encounter_outcome_runtime() -> bool:
	var outcome := _shell.get_node_or_null("EncounterOutcomeRuntime")
	if outcome == null:
		outcome = ENCOUNTER_OUTCOME_SCRIPT.new() as Node
		if outcome == null:
			return false
		outcome.name = "EncounterOutcomeRuntime"
		_shell.add_child(outcome)
		if not bool(outcome.call("initialize", _shell, _encounter_record)):
			outcome.queue_free()
			return false
	elif not bool(outcome.call("is_initialized")) and not bool(outcome.call("initialize", _shell, _encounter_record)):
		return false
	if String(outcome.call("get_schema")) != "uhr.hunt01.encounter_outcome.v1":
		return false
	_encounter_outcome = outcome
	return true

func _register_activation_driver() -> void:
	if not _initialized or _driver_registered or _shell == null or _hunter_defense == null or _wound_contact == null or _encounter_outcome == null:
		return
	_driver_registered = bool(_shell.call("register_monster_activation_driver", self))
	_record_trace("MUDCREST_ACTIVATION_DRIVER_REGISTRATION", {"registered": _driver_registered})
	if not _driver_registered:
		push_error("Mudcrest attack runtime could not register the Monster activation driver.")

func _process(_delta: float) -> void:
	if _active_attack.is_empty():
		return
	if String(_active_attack.get("state", "")) != "WAITING_REACTION_DECISION":
		return
	var active_window: Dictionary = _reaction.call("get_active_window")
	if String(active_window.get("window_id", "")) != String(_active_attack.get("reaction_window_id", "")):
		return
	var reaction_state := String(active_window.get("state", ""))
	if reaction_state != "COMMITTED_WAITING_SOURCE_RESOLUTION" and reaction_state != "DECLINED_WAITING_SOURCE_RESOLUTION":
		return
	if String(_active_attack.get("attack_id", "")) == TAIL_SWEEP_ATTACK_ID:
		_resolve_active_tail_sweep(active_window)
	else:
		_resolve_active_head_sweep(active_window)

func _load_manifest_context() -> bool:
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var manifest := parsed as Dictionary
	if String(manifest.get("encounter", "")) != EXPECTED_ENCOUNTER_ID or String(manifest.get("monster", "")) != MONSTER_COMBATANT_ID:
		return false
	if not manifest.has("monster_clearance"):
		return false
	var clearance: Dictionary = manifest["monster_clearance"]
	if not clearance.has("body_force") or not clearance.has("charge") or not clearance.has("pivot"):
		return false

	var body_force: Dictionary = clearance["body_force"]
	var center: Array = body_force.get("center", [])
	var size_xz: Array = body_force.get("size_xz", [])
	if center.size() < 3 or size_xz.size() < 2:
		return false
	_body_force_center = Vector2(float(center[0]), float(center[2]))
	_body_force_half_size = Vector2(float(size_xz[0]) * 0.5, float(size_xz[1]) * 0.5)

	var charge: Dictionary = clearance["charge"]
	var start_values: Array = charge.get("start", [])
	var end_values: Array = charge.get("end", [])
	if start_values.size() < 3 or end_values.size() < 3:
		return false
	_authored_forward_xz = Vector2(float(end_values[0]) - float(start_values[0]), float(end_values[2]) - float(start_values[2])).normalized()

	var pivot: Dictionary = clearance["pivot"]
	var pivot_center: Array = pivot.get("center", [])
	if pivot_center.size() < 3:
		return false
	_pivot_center_xz = Vector2(float(pivot_center[0]), float(pivot_center[2]))
	_pivot_radius_m = float(pivot.get("radius", 0.0))
	return _authored_forward_xz.length() > 0.0 and _pivot_radius_m > 0.0

func _head_capability_state() -> Dictionary:
	if _anatomy == null:
		return {"available": false, "reason": "ANATOMY_RUNTIME_MISSING"}
	var head_state: Dictionary = _anatomy.call("get_target_state", "HEAD")
	var horn_state: Dictionary = _anatomy.call("get_target_state", "HORN_CREST")
	if head_state.is_empty() or horn_state.is_empty():
		return {"available": false, "reason": "HEAD_OR_HORN_STATE_MISSING"}
	return {
		"available": true,
		"reason": "BASELINE_HEAD_CAPABILITY_AVAILABLE",
		"capability_id": CAPABILITY_ID,
		"profile": "GORE_SWEEP",
		"damage_channels": ["PIERCING", "IMPACT"],
		"structural_capability_status": STRUCTURAL_CAPABILITY_STATUS,
	}

func _tail_capability_state() -> Dictionary:
	if _anatomy == null:
		return {"available": false, "reason": "ANATOMY_RUNTIME_MISSING"}
	var tail_state: Dictionary = _anatomy.call("get_target_state", "TAIL")
	if tail_state.is_empty():
		return {"available": false, "reason": "TAIL_STATE_MISSING"}
	# Structural thresholds are explicitly open. Integrity is read back for trace
	# only and is not converted into an invented sever/break transition.
	return {
		"available": true,
		"reason": "BASELINE_TAIL_DISTAL_ATTACHED",
		"capability_id": TAIL_SWEEP_CAPABILITY_ID,
		"profile": "TAIL_SWEEP_IMPACT",
		"damage_channels": ["IMPACT"],
		"tail_integrity_readback": int(tail_state.get("integrity", -1)),
		"structural_capability_status": TAIL_SWEEP_STRUCTURAL_CAPABILITY_STATUS,
	}

func _distance_to_body_envelope() -> float:
	if _hunter == null:
		return INF
	var point := Vector2(_hunter.global_position.x, _hunter.global_position.z)
	var offset := Vector2(absf(point.x - _body_force_center.x), absf(point.y - _body_force_center.y))
	var outside := Vector2(maxf(offset.x - _body_force_half_size.x, 0.0), maxf(offset.y - _body_force_half_size.y, 0.0))
	return outside.length()

func _bearing_dot() -> float:
	if _hunter == null or _monster == null:
		return -1.0
	var to_hunter := Vector2(_hunter.global_position.x - _monster.global_position.x, _hunter.global_position.z - _monster.global_position.z)
	if to_hunter.length() <= 0.001:
		return 1.0
	return _authored_forward_xz.dot(to_hunter.normalized())

func _line_of_effect() -> Dictionary:
	if _world == null or _hunter == null or _monster == null:
		return {"clear": false, "reason": "MISSING_ACTOR"}
	var origin := Vector3(_monster.global_position.x, 1.6, _monster.global_position.z)
	var target := Vector3(_hunter.global_position.x, 1.6, _hunter.global_position.z)
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	var exclude_rids: Array[RID] = []
	if _monster is CollisionObject3D:
		exclude_rids.append((_monster as CollisionObject3D).get_rid())
	query.exclude = exclude_rids
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := _world.get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return {"clear": false, "reason": "NO_HUNTER_CONTACT_PATH", "origin": origin, "target": target}
	var collider: Object = result.get("collider")
	if collider == _hunter:
		return {"clear": true, "reason": "CLEAR_TO_HUNTER_BODY", "origin": origin, "target": target}
	return {"clear": false, "reason": "BLOCKED_BY_%s" % String(collider.get("name") if collider != null else "UNKNOWN"), "origin": origin, "target": target}

func _tail_pivot_clearance() -> Dictionary:
	if _world == null or _monster == null:
		return {"clear": false, "reason": "MISSING_PIVOT_CONTEXT"}
	var origin := Vector3(_pivot_center_xz.x, 1.6, _pivot_center_xz.y)
	var right := Vector2(-_authored_forward_xz.y, _authored_forward_xz.x)
	var directions: Array[Vector2] = [_authored_forward_xz, -_authored_forward_xz, right, -right]
	var probes: Array[Dictionary] = []
	var exclude_rids: Array[RID] = []
	if _monster is CollisionObject3D:
		exclude_rids.append((_monster as CollisionObject3D).get_rid())
	for direction in directions:
		var target := origin + Vector3(direction.x, 0.0, direction.y) * _pivot_radius_m
		var query := PhysicsRayQueryParameters3D.create(origin, target)
		query.exclude = exclude_rids
		query.collide_with_areas = false
		query.collide_with_bodies = true
		var result := _world.get_world_3d().direct_space_state.intersect_ray(query)
		if not result.is_empty():
			var collider: Object = result.get("collider")
			if collider != _hunter:
				return {
					"clear": false,
					"reason": "PIVOT_BLOCKED_BY_%s" % String(collider.get("name") if collider != null else "UNKNOWN"),
					"pivot_radius_m": _pivot_radius_m,
					"blocked_probe_target": target,
				}
		probes.append({"origin": origin, "target": target})
	return {"clear": true, "reason": "CLEAR_AUTHORED_PIVOT_RADIUS", "pivot_radius_m": _pivot_radius_m, "probe_count": probes.size(), "probes": probes}

func get_head_sweep_legality() -> Dictionary:
	if not _initialized:
		return {"legal": false, "reason": "NOT_INITIALIZED"}
	var shell_state: Dictionary = _shell.call("get_current_state")
	if String(shell_state.get("current_actor_id", "")) != MONSTER_COMBATANT_ID:
		return {"legal": false, "reason": "NOT_MONSTER_ACTIVATION"}
	var capability := _head_capability_state()
	if not bool(capability.get("available", false)):
		return {"legal": false, "reason": String(capability.get("reason", "HEAD_CAPABILITY_UNAVAILABLE"))}
	var envelope_distance := _distance_to_body_envelope()
	if envelope_distance > WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M:
		return {"legal": false, "reason": "OUT_OF_WORKING_MELEE", "body_envelope_distance_m": envelope_distance, "max_body_envelope_distance_m": WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M}
	var bearing_dot := _bearing_dot()
	if bearing_dot < 0.0:
		return {"legal": false, "reason": "OUTSIDE_FRONT_OR_FRONT_FLANK", "bearing_dot": bearing_dot}
	var line := _line_of_effect()
	if not bool(line.get("clear", false)):
		return {"legal": false, "reason": "FULL_COVER_OR_BLOCKED_SWEEP_PATH", "line_of_effect": line}
	var resources: Dictionary = _shell.call("get_resource_state", MONSTER_COMBATANT_ID)
	if int(resources.get("ap", 0)) < AP_COST:
		return {"legal": false, "reason": "INSUFFICIENT_AP", "resources": resources}
	if int(resources.get("stamina", 0)) < STAMINA_COST:
		return {"legal": false, "reason": "INSUFFICIENT_STAMINA", "resources": resources}
	return {"legal": true, "reason": "LEGAL_M01_HEAD_SWEEP_GORE", "capability": capability.duplicate(true), "body_envelope_distance_m": envelope_distance, "max_body_envelope_distance_m": WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M, "bearing_dot": bearing_dot, "bearing_class": "FRONT_OR_FRONT_FLANK_AUTHORED_FORWARD_HEMISPHERE", "line_of_effect": line, "ap_cost": AP_COST, "stamina_cost": STAMINA_COST}

func get_tail_sweep_legality() -> Dictionary:
	if not _initialized:
		return {"legal": false, "reason": "NOT_INITIALIZED"}
	var shell_state: Dictionary = _shell.call("get_current_state")
	if String(shell_state.get("current_actor_id", "")) != MONSTER_COMBATANT_ID:
		return {"legal": false, "reason": "NOT_MONSTER_ACTIVATION"}
	var capability := _tail_capability_state()
	if not bool(capability.get("available", false)):
		return {"legal": false, "reason": String(capability.get("reason", "TAIL_SWEEP_CAPABILITY_UNAVAILABLE"))}
	var envelope_distance := _distance_to_body_envelope()
	if envelope_distance > TAIL_SWEEP_MAX_BODY_ENVELOPE_DISTANCE_M + 0.001:
		return {"legal": false, "reason": "OUT_OF_TAIL_SWEEP_REACH", "body_envelope_distance_m": envelope_distance, "max_body_envelope_distance_m": TAIL_SWEEP_MAX_BODY_ENVELOPE_DISTANCE_M}
	var bearing_dot := _bearing_dot()
	if bearing_dot > TAIL_SWEEP_MAX_FORWARD_DOT:
		return {"legal": false, "reason": "OUTSIDE_REAR_OR_FLANK_SWEEP_RELATION", "bearing_dot": bearing_dot, "max_forward_dot": TAIL_SWEEP_MAX_FORWARD_DOT}
	var pivot_clearance := _tail_pivot_clearance()
	if not bool(pivot_clearance.get("clear", false)):
		return {"legal": false, "reason": "HINDQUARTER_PIVOT_BLOCKED", "pivot_clearance": pivot_clearance}
	var line := _line_of_effect()
	if not bool(line.get("clear", false)):
		return {"legal": false, "reason": "FULL_COVER_OR_BLOCKED_TAIL_SWEEP_ARC", "line_of_effect": line}
	var resources: Dictionary = _shell.call("get_resource_state", MONSTER_COMBATANT_ID)
	if int(resources.get("ap", 0)) < TAIL_SWEEP_AP_COST:
		return {"legal": false, "reason": "INSUFFICIENT_AP", "resources": resources}
	if int(resources.get("stamina", 0)) < TAIL_SWEEP_STAMINA_COST:
		return {"legal": false, "reason": "INSUFFICIENT_STAMINA", "resources": resources}
	return {
		"legal": true,
		"reason": "LEGAL_M01_TAIL_SWEEP",
		"capability": capability.duplicate(true),
		"body_envelope_distance_m": envelope_distance,
		"max_body_envelope_distance_m": TAIL_SWEEP_MAX_BODY_ENVELOPE_DISTANCE_M,
		"bearing_dot": bearing_dot,
		"bearing_class": "REAR_OR_FLANK_PROVISIONAL_FORWARD_DOT_MAX",
		"max_forward_dot": TAIL_SWEEP_MAX_FORWARD_DOT,
		"pivot_clearance": pivot_clearance,
		"line_of_effect": line,
		"ap_cost": TAIL_SWEEP_AP_COST,
		"stamina_cost": TAIL_SWEEP_STAMINA_COST,
		"geometry_fixture_status": "PROVISIONAL_AUTHORED_N10_FLANK_REACH_AND_BEARING_FIXTURE",
	}

func begin_monster_activation(actor_id: String, round_id: int) -> bool:
	if not _initialized or actor_id != MONSTER_COMBATANT_ID or not _active_attack.is_empty():
		return false
	var shell_state: Dictionary = _shell.call("get_current_state")
	if bool(shell_state.get("encounter_terminal", false)) or int(shell_state.get("round_id", 0)) != round_id or String(shell_state.get("current_actor_id", "")) != MONSTER_COMBATANT_ID:
		return false
	var tail_legality := get_tail_sweep_legality()
	if bool(tail_legality.get("legal", false)):
		return _begin_tail_sweep(round_id, tail_legality)
	_record_trace("MUDCREST_TAIL_SWEEP_CANDIDATE_REJECTED", {"round_id": round_id, "reason": String(tail_legality.get("reason", "TAIL_SWEEP_ILLEGAL")), "legality": tail_legality.duplicate(true)})
	return _begin_head_sweep(round_id)

func _begin_head_sweep(round_id: int) -> bool:
	var legality := get_head_sweep_legality()
	if not bool(legality.get("legal", false)):
		var reason := String(legality.get("reason", "HEAD_SWEEP_ILLEGAL"))
		_record_trace("MUDCREST_HEAD_SWEEP_SKIPPED", {"round_id": round_id, "reason": reason, "legality": legality.duplicate(true)})
		return bool(_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "WAIT_NO_ATTACK_RUNTIME"))
	_attack_sequence += 1
	var action_source_id := "%s:%03d" % [ATTACK_ID, _attack_sequence]
	if not bool(_shell.call("try_commit_cost", MONSTER_COMBATANT_ID, action_source_id, AP_COST, STAMINA_COST)):
		_record_trace("MUDCREST_HEAD_SWEEP_COMMIT_REJECTED", {"round_id": round_id, "action_sequence": _attack_sequence, "reason": "RESOURCE_COMMIT_REJECTED_AFTER_VALIDATION"})
		return bool(_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "WAIT_NO_ATTACK_RUNTIME"))
	var telegraph_text := "Mudcrest Raker cocks its horned head, loads the forequarter, and sweeps across the front arc."
	var allowed_reactions: Array[String] = [REACTION_POLEBLADE_BLOCK]
	var opened: Dictionary = _reaction.call("open_window", MONSTER_COMBATANT_ID, ATTACK_ID, _attack_sequence, allowed_reactions, telegraph_text)
	if not bool(opened.get("success", false)):
		_record_trace("MUDCREST_HEAD_SWEEP_REACTION_OPEN_FAILED", {"round_id": round_id, "action_sequence": _attack_sequence, "reaction_result": opened.duplicate(true)})
		push_error("Committed Mudcrest Head Sweep could not open its required reaction window.")
		return bool(_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "WAIT_NO_ATTACK_RUNTIME"))
	var capability: Dictionary = legality.get("capability", {})
	_active_attack = {"state": "WAITING_REACTION_DECISION", "round_id": round_id, "action_sequence": _attack_sequence, "action_source_id": action_source_id, "attack_id": ATTACK_ID, "profile": String(capability.get("profile", "GORE_SWEEP")), "damage_channels": (capability.get("damage_channels", ["PIERCING", "IMPACT"]) as Array).duplicate(true), "reaction_window_id": String(opened.get("window_id", "")), "telegraph": telegraph_text, "legality_snapshot": legality.duplicate(true), "hunter_position": _hunter.global_position, "monster_position": _monster.global_position, "fixture_status": FIXTURE_STATUS, "structural_capability_status": STRUCTURAL_CAPABILITY_STATUS}
	_show_telegraph_visual()
	_record_trace("MUDCREST_HEAD_SWEEP_TELEGRAPH_EMITTED", _active_attack)
	return true

func _begin_tail_sweep(round_id: int, legality: Dictionary) -> bool:
	_attack_sequence += 1
	var action_source_id := "%s:%03d" % [TAIL_SWEEP_ATTACK_ID, _attack_sequence]
	if not bool(_shell.call("try_commit_cost", MONSTER_COMBATANT_ID, action_source_id, TAIL_SWEEP_AP_COST, TAIL_SWEEP_STAMINA_COST)):
		_record_trace("MUDCREST_TAIL_SWEEP_COMMIT_REJECTED", {"round_id": round_id, "action_sequence": _attack_sequence, "reason": "RESOURCE_COMMIT_REJECTED_AFTER_VALIDATION"})
		return bool(_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "WAIT_NO_ATTACK_RUNTIME"))
	var telegraph_text := "Mudcrest Raker plants its hindquarters, counter-rotates, and coils the mineralized tail across the rear flank."
	var allowed_reactions: Array[String] = [REACTION_POLEBLADE_BLOCK]
	var opened: Dictionary = _reaction.call("open_window", MONSTER_COMBATANT_ID, TAIL_SWEEP_ATTACK_ID, _attack_sequence, allowed_reactions, telegraph_text)
	if not bool(opened.get("success", false)):
		_record_trace("MUDCREST_TAIL_SWEEP_REACTION_OPEN_FAILED", {"round_id": round_id, "action_sequence": _attack_sequence, "reaction_result": opened.duplicate(true)})
		push_error("Committed Mudcrest Tail Sweep could not open its required reaction window.")
		return bool(_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "WAIT_NO_ATTACK_RUNTIME"))
	var capability: Dictionary = legality.get("capability", {})
	_active_attack = {
		"state": "WAITING_REACTION_DECISION",
		"round_id": round_id,
		"action_sequence": _attack_sequence,
		"action_source_id": action_source_id,
		"attack_id": TAIL_SWEEP_ATTACK_ID,
		"profile": String(capability.get("profile", "TAIL_SWEEP_IMPACT")),
		"damage_channels": (capability.get("damage_channels", ["IMPACT"]) as Array).duplicate(true),
		"reaction_window_id": String(opened.get("window_id", "")),
		"telegraph": telegraph_text,
		"legality_snapshot": legality.duplicate(true),
		"hunter_position": _hunter.global_position,
		"monster_position": _monster.global_position,
		"fixture_status": TAIL_SWEEP_FIXTURE_STATUS,
		"structural_capability_status": TAIL_SWEEP_STRUCTURAL_CAPABILITY_STATUS,
	}
	_show_tail_sweep_telegraph_visual()
	_record_trace("MUDCREST_TAIL_SWEEP_TELEGRAPH_EMITTED", _active_attack)
	return true

func _resolve_active_head_sweep(reaction_window: Dictionary) -> void:
	if _active_attack.is_empty():
		return
	var round_id := int(_active_attack.get("round_id", 0))
	var action_sequence := int(_active_attack.get("action_sequence", 0))
	var reaction_id := String(reaction_window.get("reaction_id", REACTION_DECLINE))
	if reaction_id.is_empty():
		reaction_id = REACTION_DECLINE
	var block_committed := reaction_id == REACTION_POLEBLADE_BLOCK
	var defense_control := PROVISIONAL_HUNTER_DEFENSE_CONTROL + (PROVISIONAL_BLOCK_DEFENSE_CONTROL_BONUS if block_committed else 0)
	var seed_key := "%s|%d|%d|%s|%s|%s" % [EXPECTED_ENCOUNTER_ID, round_id, action_sequence, MONSTER_COMBATANT_ID, ATTACK_ID, reaction_id]
	var variance := _stable_variance(seed_key)
	var control_margin := PROVISIONAL_ATTACK_CONTROL_BASE + variance - defense_control
	var hit_quality := _classify_hit_quality(control_margin)
	var contact_class := "NO_CONTACT" if hit_quality == "MISS" else "HUNTER_BODY_CONTACT"
	var protection_route := "NONE_NO_CONTACT"
	if contact_class != "NO_CONTACT":
		protection_route = "FIELD_POLEBLADE_DIRECTIONAL_GUARD" if block_committed else "HUNTER_BODY_PROTECTION_PENDING_RUNTIME"
	var resolution_id := "%s:R%d:A%d:%s" % [EXPECTED_ENCOUNTER_ID, round_id, action_sequence, ATTACK_ID]
	var damage_handoff := {"status": "PENDING_HUNTER_DAMAGE_RUNTIME", "resolution_id": resolution_id, "encounter_id": EXPECTED_ENCOUNTER_ID, "round_id": round_id, "action_sequence": action_sequence, "attacker_id": MONSTER_COMBATANT_ID, "defender_id": HUNTER_COMBATANT_ID, "attack_id": ATTACK_ID, "attack_profile": String(_active_attack.get("profile", "GORE_SWEEP")), "damage_channels": (_active_attack.get("damage_channels", []) as Array).duplicate(true), "reaction_id": reaction_id, "contact_class": contact_class, "hit_quality": hit_quality, "protection_route": protection_route, "standard_block_impact_drain_stamina": STANDARD_BLOCK_IMPACT_DRAIN_STAMINA if block_committed else 0, "guard_impact_drain_status": "PENDING_FINAL_BLOCK_OUTCOME_RUNTIME" if block_committed else "NOT_APPLICABLE", "final_damage_amount_status": "NOT_SELECTED_PENDING_HUNTER_DAMAGE_RUNTIME"}
	var defense_consequence: Dictionary = _hunter_defense.call("resolve_hostile_handoff", damage_handoff)
	if not bool(defense_consequence.get("success", false)):
		push_error("Mudcrest Head Sweep could not resolve the Hunter defense consequence.")
	var wound_contact: Dictionary = _wound_contact.call("resolve_head_sweep_consequence", damage_handoff, defense_consequence)
	if not bool(wound_contact.get("success", false)):
		push_error("Mudcrest Head Sweep could not classify its wound/contact consequence.")
	var resolution := {"success": true, "status": "HOSTILE_CONTACT_RESOLVED_DAMAGE_PENDING", "resolution_id": resolution_id, "encounter_id": EXPECTED_ENCOUNTER_ID, "round_id": round_id, "action_sequence": action_sequence, "attack_id": ATTACK_ID, "attacker_id": MONSTER_COMBATANT_ID, "defender_id": HUNTER_COMBATANT_ID, "attack_profile": String(_active_attack.get("profile", "GORE_SWEEP")), "damage_channels": (_active_attack.get("damage_channels", []) as Array).duplicate(true), "reaction_window_id": String(_active_attack.get("reaction_window_id", "")), "reaction_id": reaction_id, "reaction_state": String(reaction_window.get("state", "")), "block_commitment_applied": block_committed, "attack_control": PROVISIONAL_ATTACK_CONTROL_BASE, "defense_control_base": PROVISIONAL_HUNTER_DEFENSE_CONTROL, "block_defense_control_bonus": PROVISIONAL_BLOCK_DEFENSE_CONTROL_BONUS if block_committed else 0, "defense_control": defense_control, "seed_key": seed_key, "variance_sample": variance, "variance_bounds": [VARIANCE_MIN, VARIANCE_MAX], "control_margin": control_margin, "contact_class": contact_class, "hit_quality": hit_quality, "protection_route": protection_route, "fixture_status": FIXTURE_STATUS, "structural_capability_status": STRUCTURAL_CAPABILITY_STATUS, "legality_snapshot": (_active_attack.get("legality_snapshot", {}) as Dictionary).duplicate(true), "damage_handoff": damage_handoff.duplicate(true), "defense_consequence": defense_consequence.duplicate(true), "wound_contact_classification": wound_contact.duplicate(true)}
	_resolutions[resolution_id] = resolution.duplicate(true)
	_last_resolution = resolution.duplicate(true)
	var window_id := String(_active_attack.get("reaction_window_id", ""))
	var health_handoff: Dictionary = defense_consequence.get("health_handoff", {}) as Dictionary
	var close_status := String(health_handoff.get("status", "PENDING_HUNTER_HEALTH_INJURY_RUNTIME"))
	var close_result: Dictionary = _reaction.call("close_window", window_id, close_status)
	_last_resolution["reaction_close_result"] = close_result.duplicate(true)

	var health_consequence: Dictionary = defense_consequence.get("health_injury_consequence", {}) as Dictionary
	var defeat_handoff: Dictionary = health_consequence.get("defeat_handoff", {}) as Dictionary
	var outcome_consequence: Dictionary = {"success": true, "status": "NOT_APPLICABLE_HEALTH_ABOVE_ZERO", "encounter_terminal": false}
	if String(defeat_handoff.get("status", "")) == "PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME":
		outcome_consequence = _encounter_outcome.call("resolve_hunter_defeat_handoff", defeat_handoff)
		if not bool(outcome_consequence.get("success", false)):
			push_error("Mudcrest Head Sweep reached zero Hunter Health but the encounter outcome transaction failed.")
	_last_resolution["encounter_outcome_consequence"] = outcome_consequence.duplicate(true)
	_resolutions[resolution_id] = _last_resolution.duplicate(true)
	_hide_telegraph_visual()
	_record_trace("MUDCREST_HEAD_SWEEP_RESOLUTION_HANDOFF_COMMITTED", _last_resolution)
	_active_attack.clear()
	if bool(outcome_consequence.get("encounter_terminal", false)):
		return
	if not bool(_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "HEAD_SWEEP_DEFENSE_CONSEQUENCE_COMMITTED")):
		push_error("Mudcrest Head Sweep resolved but the shell could not complete the Monster activation.")

func _resolve_active_tail_sweep(reaction_window: Dictionary) -> void:
	if _active_attack.is_empty():
		return
	var round_id := int(_active_attack.get("round_id", 0))
	var action_sequence := int(_active_attack.get("action_sequence", 0))
	var reaction_id := String(reaction_window.get("reaction_id", REACTION_DECLINE))
	if reaction_id.is_empty():
		reaction_id = REACTION_DECLINE
	var block_committed := reaction_id == REACTION_POLEBLADE_BLOCK
	var defense_control := PROVISIONAL_HUNTER_DEFENSE_CONTROL + (PROVISIONAL_BLOCK_DEFENSE_CONTROL_BONUS if block_committed else 0)
	var seed_key := "%s|%d|%d|%s|%s|%s" % [EXPECTED_ENCOUNTER_ID, round_id, action_sequence, MONSTER_COMBATANT_ID, TAIL_SWEEP_ATTACK_ID, reaction_id]
	var variance := _stable_variance(seed_key)
	var control_margin := TAIL_SWEEP_PROVISIONAL_ATTACK_CONTROL_BASE + variance - defense_control
	var hit_quality := _classify_hit_quality(control_margin)
	var contact_class := "NO_CONTACT" if hit_quality == "MISS" else "HUNTER_BODY_CONTACT"
	var protection_route := "NONE_NO_CONTACT"
	if contact_class != "NO_CONTACT":
		protection_route = "FIELD_POLEBLADE_DIRECTIONAL_GUARD" if block_committed else "HUNTER_BODY_PROTECTION_PENDING_RUNTIME"
	var resolution_id := "%s:R%d:A%d:%s" % [EXPECTED_ENCOUNTER_ID, round_id, action_sequence, TAIL_SWEEP_ATTACK_ID]
	var damage_handoff := {
		"status": "PENDING_HUNTER_DAMAGE_RUNTIME",
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"round_id": round_id,
		"action_sequence": action_sequence,
		"attacker_id": MONSTER_COMBATANT_ID,
		"defender_id": HUNTER_COMBATANT_ID,
		"attack_id": TAIL_SWEEP_ATTACK_ID,
		"attack_profile": "TAIL_SWEEP_IMPACT",
		"damage_channels": ["IMPACT"],
		"reaction_id": reaction_id,
		"contact_class": contact_class,
		"hit_quality": hit_quality,
		"protection_route": protection_route,
		"standard_block_impact_drain_stamina": TAIL_SWEEP_STANDARD_BLOCK_IMPACT_DRAIN_STAMINA if block_committed else 0,
		"guard_impact_drain_status": "PENDING_FINAL_BLOCK_OUTCOME_RUNTIME" if block_committed else "NOT_APPLICABLE",
		"final_damage_amount_status": "NOT_SELECTED_PENDING_HUNTER_DAMAGE_RUNTIME",
	}
	var defense_consequence: Dictionary = _hunter_defense.call("resolve_hostile_handoff", damage_handoff)
	if not bool(defense_consequence.get("success", false)):
		push_error("Mudcrest Tail Sweep could not resolve the Hunter defense consequence.")
	var wound_contact: Dictionary = _wound_contact.call("resolve_tail_sweep_consequence", damage_handoff, defense_consequence)
	if not bool(wound_contact.get("success", false)):
		push_error("Mudcrest Tail Sweep could not classify its wound/contact consequence.")
	var resolution := {
		"success": true,
		"status": "HOSTILE_CONTACT_RESOLVED_DAMAGE_PENDING",
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"round_id": round_id,
		"action_sequence": action_sequence,
		"attack_id": TAIL_SWEEP_ATTACK_ID,
		"attacker_id": MONSTER_COMBATANT_ID,
		"defender_id": HUNTER_COMBATANT_ID,
		"attack_profile": "TAIL_SWEEP_IMPACT",
		"damage_channels": ["IMPACT"],
		"reaction_window_id": String(_active_attack.get("reaction_window_id", "")),
		"reaction_id": reaction_id,
		"reaction_state": String(reaction_window.get("state", "")),
		"block_commitment_applied": block_committed,
		"attack_control": TAIL_SWEEP_PROVISIONAL_ATTACK_CONTROL_BASE,
		"defense_control_base": PROVISIONAL_HUNTER_DEFENSE_CONTROL,
		"block_defense_control_bonus": PROVISIONAL_BLOCK_DEFENSE_CONTROL_BONUS if block_committed else 0,
		"defense_control": defense_control,
		"seed_key": seed_key,
		"variance_sample": variance,
		"variance_bounds": [VARIANCE_MIN, VARIANCE_MAX],
		"control_margin": control_margin,
		"contact_class": contact_class,
		"hit_quality": hit_quality,
		"protection_route": protection_route,
		"fixture_status": TAIL_SWEEP_FIXTURE_STATUS,
		"structural_capability_status": TAIL_SWEEP_STRUCTURAL_CAPABILITY_STATUS,
		"legality_snapshot": (_active_attack.get("legality_snapshot", {}) as Dictionary).duplicate(true),
		"damage_handoff": damage_handoff.duplicate(true),
		"defense_consequence": defense_consequence.duplicate(true),
		"wound_contact_classification": wound_contact.duplicate(true),
	}
	_resolutions[resolution_id] = resolution.duplicate(true)
	_last_resolution = resolution.duplicate(true)
	var window_id := String(_active_attack.get("reaction_window_id", ""))
	var health_handoff: Dictionary = defense_consequence.get("health_handoff", {}) as Dictionary
	var close_status := String(health_handoff.get("status", "PENDING_HUNTER_HEALTH_INJURY_RUNTIME"))
	var close_result: Dictionary = _reaction.call("close_window", window_id, close_status)
	_last_resolution["reaction_close_result"] = close_result.duplicate(true)

	var health_consequence: Dictionary = defense_consequence.get("health_injury_consequence", {}) as Dictionary
	var defeat_handoff: Dictionary = health_consequence.get("defeat_handoff", {}) as Dictionary
	var outcome_consequence: Dictionary = {"success": true, "status": "NOT_APPLICABLE_HEALTH_ABOVE_ZERO", "encounter_terminal": false}
	if String(defeat_handoff.get("status", "")) == "PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME":
		outcome_consequence = _encounter_outcome.call("resolve_hunter_defeat_handoff", defeat_handoff)
		if not bool(outcome_consequence.get("success", false)):
			push_error("Mudcrest Tail Sweep reached zero Hunter Health but the encounter outcome transaction failed.")
	_last_resolution["encounter_outcome_consequence"] = outcome_consequence.duplicate(true)
	_resolutions[resolution_id] = _last_resolution.duplicate(true)
	_hide_telegraph_visual()
	_record_trace("MUDCREST_TAIL_SWEEP_RESOLUTION_HANDOFF_COMMITTED", _last_resolution)
	_active_attack.clear()
	if bool(outcome_consequence.get("encounter_terminal", false)):
		return
	if not bool(_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "TAIL_SWEEP_DEFENSE_CONSEQUENCE_COMMITTED")):
		push_error("Mudcrest Tail Sweep resolved but the shell could not complete the Monster activation.")

func _stable_variance(seed_key: String) -> int:
	# One FNV-1a 32-bit bounded sample; no engine/global RNG.
	var value: int = 2166136261
	for byte_value in seed_key.to_utf8_buffer():
		value = value ^ int(byte_value)
		value = (value * 16777619) & 0xffffffff
	var width := VARIANCE_MAX - VARIANCE_MIN + 1
	return int(value % width) + VARIANCE_MIN

func _classify_hit_quality(control_margin: int) -> String:
	if control_margin < 0:
		return "MISS"
	if control_margin <= 4:
		return "GRAZE"
	if control_margin <= 11:
		return "SOLID"
	return "CLEAN"

func _show_telegraph_visual() -> void:
	_show_attack_telegraph(HEAD_SWEEP_TELEGRAPH_SCENE)

func _show_tail_sweep_telegraph_visual() -> void:
	_show_attack_telegraph(TAIL_SWEEP_TELEGRAPH_SCENE)

func _show_attack_telegraph(scene: PackedScene) -> void:
	_hide_telegraph_visual()
	if scene == null or _world == null or _monster == null or _hunter == null:
		return
	var instance := scene.instantiate() as Node3D
	if instance == null:
		return
	instance.add_to_group("hunt01_monster_attack_telegraph")
	_world.get_node("WorldGeometry").add_child(instance)
	var midpoint := (_monster.global_position + _hunter.global_position) * 0.5
	midpoint.y = _hunter.global_position.y + 0.04
	instance.global_position = midpoint
	var flat_target := Vector3(_hunter.global_position.x, midpoint.y, _hunter.global_position.z)
	if instance.global_position.distance_to(flat_target) > 0.001:
		instance.look_at(flat_target, Vector3.UP)
	_telegraph_visual = instance

func _hide_telegraph_visual() -> void:
	if _telegraph_visual != null and is_instance_valid(_telegraph_visual):
		_telegraph_visual.queue_free()
	_telegraph_visual = null

func _record_trace(event_name: String, details: Dictionary = {}) -> void:
	_trace_sequence += 1
	var entry: Dictionary = {"sequence": _trace_sequence, "event": event_name, "encounter_id": EXPECTED_ENCOUNTER_ID, "monster_id": MONSTER_COMBATANT_ID}
	for key in details.keys():
		entry[key] = details[key]
	_trace.append(entry)

func get_schema() -> String:
	return SCHEMA

func is_initialized() -> bool:
	return _initialized

func is_driver_registered() -> bool:
	return _driver_registered

func get_attack_id() -> String:
	return ATTACK_ID

func get_tail_sweep_attack_id() -> String:
	return TAIL_SWEEP_ATTACK_ID

func get_attack_sequence() -> int:
	return _attack_sequence

func get_active_attack() -> Dictionary:
	return _active_attack.duplicate(true)

func get_last_resolution() -> Dictionary:
	return _last_resolution.duplicate(true)

func get_resolution(resolution_id: String) -> Dictionary:
	if not _resolutions.has(resolution_id):
		return {}
	return (_resolutions[resolution_id] as Dictionary).duplicate(true)

func get_hunter_defense_runtime() -> Node:
	return _hunter_defense

func get_wound_contact_runtime() -> Node:
	return _wound_contact

func get_encounter_outcome_runtime() -> Node:
	return _encounter_outcome

func get_trace() -> Array:
	return _trace.duplicate(true)

func get_working_melee_limit_m() -> float:
	return WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M

func get_tail_sweep_reach_fixture_m() -> float:
	return TAIL_SWEEP_MAX_BODY_ENVELOPE_DISTANCE_M

func get_tail_sweep_bearing_fixture_max_dot() -> float:
	return TAIL_SWEEP_MAX_FORWARD_DOT

func is_telegraph_visible() -> bool:
	return _telegraph_visual != null and is_instance_valid(_telegraph_visual)
