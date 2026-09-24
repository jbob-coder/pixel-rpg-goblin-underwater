extends Node

const SCHEMA := "uhr.hunt01.hunter_attack.v1"
const MANIFEST_PATH := "res://content/regions/region_01/hunt01_graybox_build_manifest.json"
const EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_COMBATANT_ID := "hunter_player_0001"
const MONSTER_COMBATANT_ID := "monster_r01_m01_0001"
const TECHNIQUE_ID := "POLEBLADE_MEASURED_CUT"
const TECHNIQUE_LABEL := "Measured Cut"
const AP_COST := 2
const STAMINA_COST := 12
const DAMAGE_CHANNEL := "CUTTING"
const BODY_FALLBACK_POLICY := "ALLOW_BODY_FALLBACK"
const HIT_QUALITY_CEILING := "CLEAN"
const WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M := 3.5
const PROVISIONAL_ATTACK_CONTROL_BASE := 70
const PROVISIONAL_DEFENSE_CONTROL := 55
const PART_ACQUISITION_MARGIN := 6
const VARIANCE_MIN := -6
const VARIANCE_MAX := 6
const FIXTURE_STATUS := "PROVISIONAL_FIRST_SLICE_CONTROL_FIXTURE"

const TARGET_GROUPS := [
	"HEAD",
	"HORN_CREST",
	"FORELEG_L",
	"FORELEG_R",
	"HINDLEG_L",
	"HINDLEG_R",
	"DORSAL_PLATES",
	"TAIL",
]

const TARGET_CONTROL_PENALTY := {
	"HEAD": 4,
	"HORN_CREST": 10,
	"FORELEG_L": 6,
	"FORELEG_R": 6,
	"HINDLEG_L": 6,
	"HINDLEG_R": 6,
	"DORSAL_PLATES": 2,
	"TAIL": 8,
}

const TARGET_PROTECTION := {
	"HEAD": "REINFORCED_HEAD_SKULL",
	"HORN_CREST": "HARD_HORN_STRUCTURE",
	"FORELEG_L": "HIDE_LIMB_STRUCTURE",
	"FORELEG_R": "HIDE_LIMB_STRUCTURE",
	"HINDLEG_L": "HIDE_LIMB_STRUCTURE",
	"HINDLEG_R": "HIDE_LIMB_STRUCTURE",
	"DORSAL_PLATES": "MINERALIZED_DORSAL_PLATE",
	"TAIL": "MUSCULAR_TAIL_DISTAL_RIDGE",
	"GENERAL_TORSO": "HIDE_TORSO",
}

var _world: Node3D = null
var _shell: Node = null
var _movement: Node = null
var _anatomy: Node = null
var _hunter: CharacterBody3D = null
var _monster: Node3D = null
var _encounter_record: Dictionary = {}
var _body_force_center := Vector2.ZERO
var _body_force_half_size := Vector2.ZERO
var _initialized := false
var _selected_target := "DORSAL_PLATES"
var _attack_sequence := 0
var _trace_sequence := 0
var _trace: Array[Dictionary] = []
var _last_resolution: Dictionary = {}

var _panel: PanelContainer = null
var _target_selector: OptionButton = null
var _attack_button: Button = null
var _legality_label: Label = null
var _result_label: Label = null

func initialize(world: Node3D, shell: Node, movement: Node, anatomy: Node, encounter_record: Dictionary) -> bool:
	if _initialized or world == null or shell == null or movement == null or anatomy == null:
		return false
	if String(encounter_record.get("encounter_id", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not bool(anatomy.call("is_initialized")):
		return false
	if not _load_manifest_combat_envelope():
		return false

	_world = world
	_shell = shell
	_movement = movement
	_anatomy = anatomy
	_encounter_record = encounter_record.duplicate(true)
	_hunter = _world.get_node_or_null("Hunter") as CharacterBody3D
	_monster = _world.get_node_or_null("WorldGeometry/%s" % MONSTER_COMBATANT_ID) as Node3D
	if _hunter == null or _monster == null:
		return false

	_build_hud()
	_initialized = true
	_record_trace("HUNTER_ATTACK_RUNTIME_READY", {
		"technique_id": TECHNIQUE_ID,
		"ap_cost": AP_COST,
		"stamina_cost": STAMINA_COST,
		"working_melee_body_envelope_distance_m": WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M,
		"fixture_status": FIXTURE_STATUS,
		"anatomy_schema": String(_anatomy.call("get_schema")),
	})
	_refresh_hud()
	return true

func _load_manifest_combat_envelope() -> bool:
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	var manifest := parsed as Dictionary
	if String(manifest.get("encounter", "")) != EXPECTED_ENCOUNTER_ID:
		return false
	if not manifest.has("monster_clearance"):
		return false
	var clearance: Dictionary = manifest["monster_clearance"]
	if not clearance.has("body_force"):
		return false
	var body_force: Dictionary = clearance["body_force"]
	var center: Array = body_force.get("center", [])
	var size_xz: Array = body_force.get("size_xz", [])
	if center.size() < 3 or size_xz.size() < 2:
		return false
	_body_force_center = Vector2(float(center[0]), float(center[2]))
	_body_force_half_size = Vector2(float(size_xz[0]) * 0.5, float(size_xz[1]) * 0.5)
	return true

func _build_hud() -> void:
	var hud := _world.get_node_or_null("HUD") as CanvasLayer
	if hud == null:
		return
	_panel = PanelContainer.new()
	_panel.name = "HunterAttackPanel"
	_panel.offset_left = 520.0
	_panel.offset_top = 52.0
	_panel.offset_right = 1195.0
	_panel.offset_bottom = 345.0
	_panel.add_to_group("hunt01_hunter_attack_ui")
	hud.add_child(_panel)

	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 5)
	_panel.add_child(layout)

	var title := Label.new()
	title.name = "Title"
	title.text = "FIELD POLEBLADE • MEASURED CUT"
	title.add_theme_font_size_override("font_size", 19)
	layout.add_child(title)

	var cost := Label.new()
	cost.name = "Cost"
	cost.text = "2 AP • 12 Stamina • Cutting • selected-part target • body fallback allowed"
	layout.add_child(cost)

	_target_selector = OptionButton.new()
	_target_selector.name = "TargetGroup"
	for group_variant in TARGET_GROUPS:
		var group := String(group_variant)
		_target_selector.add_item(group.replace("_", " "))
		_target_selector.set_item_metadata(_target_selector.item_count - 1, group)
		if group == _selected_target:
			_target_selector.select(_target_selector.item_count - 1)
	_target_selector.item_selected.connect(_on_target_selected)
	layout.add_child(_target_selector)

	_attack_button = Button.new()
	_attack_button.name = "MeasuredCut"
	_attack_button.text = "COMMIT MEASURED CUT"
	_attack_button.pressed.connect(_on_attack_pressed)
	layout.add_child(_attack_button)

	_legality_label = Label.new()
	_legality_label.name = "Legality"
	layout.add_child(_legality_label)

	_result_label = Label.new()
	_result_label.name = "Result"
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(_result_label)

func _on_target_selected(index: int) -> void:
	if _target_selector == null:
		return
	_selected_target = String(_target_selector.get_item_metadata(index))
	_refresh_hud()

func _on_attack_pressed() -> void:
	commit_measured_cut(_selected_target)

func _refresh_hud() -> void:
	if _attack_button == null or _legality_label == null or _result_label == null:
		return
	var legality := get_measured_cut_legality(_selected_target)
	_attack_button.disabled = not bool(legality.get("legal", false))
	if bool(legality.get("legal", false)):
		_legality_label.text = "READY • %s • body-envelope gap %.2f m • line of effect clear" % [
			String(legality.get("current_node_id", "")),
			float(legality.get("body_envelope_distance_m", 0.0)),
		]
	else:
		_legality_label.text = "NOT READY • %s" % String(legality.get("reason", "UNKNOWN"))
	if _last_resolution.is_empty():
		_result_label.text = "No attack committed yet. Positioning, target legality and resources are authoritative."
		return
	var anatomy_result := _last_resolution.get("anatomy_result", {}) as Dictionary
	if anatomy_result.is_empty():
		_result_label.text = "%s • %s • %s → %s • protection %s • anatomy result unavailable" % [
			String(_last_resolution.get("hit_quality", "")),
			String(_last_resolution.get("contact_class", "")),
			String(_last_resolution.get("selected_target_group", "")),
			String(_last_resolution.get("resolved_target_group", "")),
			String(_last_resolution.get("protection_profile", "")),
		]
		return
	_result_label.text = "%s • %s • %s → %s • protection %s • integrity %s → %s (−%s) • provisional" % [
		String(_last_resolution.get("hit_quality", "")),
		String(_last_resolution.get("contact_class", "")),
		String(_last_resolution.get("selected_target_group", "")),
		String(_last_resolution.get("resolved_target_group", "")),
		String(_last_resolution.get("protection_profile", "")),
		str(anatomy_result.get("integrity_before", "—")),
		str(anatomy_result.get("integrity_after", "—")),
		str(anatomy_result.get("integrity_loss", 0)),
	]

func _hunter_has_activation() -> bool:
	if _shell == null:
		return false
	var state: Dictionary = _shell.call("get_current_state")
	return String(state.get("current_actor_id", "")) == HUNTER_COMBATANT_ID

func _current_node_id() -> String:
	if _movement == null:
		return ""
	return String(_movement.call("get_current_node_id"))

func _distance_from_node_to_body_envelope(node_id: String) -> float:
	var node_state: Dictionary = _movement.call("get_node_state", node_id)
	if node_state.is_empty():
		return INF
	var position: Vector3 = node_state.get("position", Vector3.ZERO)
	var point := Vector2(position.x, position.z)
	var offset := Vector2(absf(point.x - _body_force_center.x), absf(point.y - _body_force_center.y))
	var outside := Vector2(maxf(offset.x - _body_force_half_size.x, 0.0), maxf(offset.y - _body_force_half_size.y, 0.0))
	return outside.length()

func _line_of_effect() -> Dictionary:
	if _world == null or _hunter == null or _monster == null:
		return {"clear": false, "reason": "MISSING_ACTOR"}
	var origin := Vector3(_hunter.global_position.x, 1.6, _hunter.global_position.z)
	var target := Vector3(_monster.global_position.x, 1.6, _monster.global_position.z)
	var query := PhysicsRayQueryParameters3D.create(origin, target)
	query.exclude = [_hunter.get_rid()]
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := _world.get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return {"clear": false, "reason": "NO_MONSTER_CONTACT_PATH", "origin": origin, "target": target}
	var collider: Object = result.get("collider")
	if collider == _monster:
		return {"clear": true, "reason": "CLEAR_TO_MONSTER_BODY", "origin": origin, "target": target}
	return {
		"clear": false,
		"reason": "BLOCKED_BY_%s" % String(collider.get("name") if collider != null else "UNKNOWN"),
		"origin": origin,
		"target": target,
	}

func get_measured_cut_legality(target_group: String) -> Dictionary:
	if not _initialized:
		return {"legal": false, "reason": "NOT_INITIALIZED"}
	if not _hunter_has_activation():
		return {"legal": false, "reason": "NOT_HUNTER_ACTIVATION"}
	if not TARGET_GROUPS.has(target_group):
		return {"legal": false, "reason": "UNKNOWN_TARGET_GROUP"}
	var node_id := _current_node_id()
	var envelope_distance := _distance_from_node_to_body_envelope(node_id)
	if envelope_distance > WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M:
		return {
			"legal": false,
			"reason": "OUT_OF_WORKING_MELEE",
			"current_node_id": node_id,
			"body_envelope_distance_m": envelope_distance,
			"max_body_envelope_distance_m": WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M,
		}
	var line := _line_of_effect()
	if not bool(line.get("clear", false)):
		return {
			"legal": false,
			"reason": "FULL_COVER_OR_BLOCKED_LINE_OF_EFFECT",
			"line_of_effect": line,
			"current_node_id": node_id,
			"body_envelope_distance_m": envelope_distance,
		}
	var resources: Dictionary = _shell.call("get_resource_state", HUNTER_COMBATANT_ID)
	if int(resources.get("ap", 0)) < AP_COST:
		return {"legal": false, "reason": "INSUFFICIENT_AP", "current_node_id": node_id, "resources": resources}
	if int(resources.get("stamina", 0)) < STAMINA_COST:
		return {"legal": false, "reason": "INSUFFICIENT_STAMINA", "current_node_id": node_id, "resources": resources}
	return {
		"legal": true,
		"reason": "LEGAL_MEASURED_CUT",
		"current_node_id": node_id,
		"body_envelope_distance_m": envelope_distance,
		"max_body_envelope_distance_m": WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M,
		"line_of_effect": line,
		"selected_target_group": target_group,
		"exposure": "EXPOSED_PROTOTYPE_EXTERNAL_GROUP",
		"fallback_policy": BODY_FALLBACK_POLICY,
		"hit_quality_ceiling": HIT_QUALITY_CEILING,
		"ap_cost": AP_COST,
		"stamina_cost": STAMINA_COST,
	}

func commit_measured_cut(target_group: String) -> Dictionary:
	var legality := get_measured_cut_legality(target_group)
	if not bool(legality.get("legal", false)):
		var rejection := {
			"success": false,
			"technique_id": TECHNIQUE_ID,
			"selected_target_group": target_group,
			"reason": String(legality.get("reason", "ILLEGAL_ATTACK")),
		}
		_record_trace("HUNTER_ATTACK_REJECTED", rejection)
		_refresh_hud()
		return rejection

	_attack_sequence += 1
	var action_source_id := "%s:%03d:%s" % [TECHNIQUE_ID, _attack_sequence, target_group]
	if not bool(_shell.call("try_commit_cost", HUNTER_COMBATANT_ID, action_source_id, AP_COST, STAMINA_COST)):
		var race_rejection := {
			"success": false,
			"technique_id": TECHNIQUE_ID,
			"selected_target_group": target_group,
			"reason": "RESOURCE_COMMIT_REJECTED_AFTER_VALIDATION",
		}
		_record_trace("HUNTER_ATTACK_REJECTED", race_rejection)
		_refresh_hud()
		return race_rejection

	var state: Dictionary = _shell.call("get_current_state")
	var round_id := int(state.get("round_id", 0))
	var target_penalty := int(TARGET_CONTROL_PENALTY.get(target_group, 0))
	var attack_control := PROVISIONAL_ATTACK_CONTROL_BASE - target_penalty
	var defense_control := PROVISIONAL_DEFENSE_CONTROL
	var seed_key := "%s|%d|%d|%s|%s|%s" % [
		EXPECTED_ENCOUNTER_ID,
		round_id,
		_attack_sequence,
		HUNTER_COMBATANT_ID,
		TECHNIQUE_ID,
		target_group,
	]
	var variance := _stable_variance(seed_key)
	var control_margin := attack_control + variance - defense_control
	var contact_class := "NO_CONTACT"
	var resolved_target_group := ""
	if control_margin >= PART_ACQUISITION_MARGIN:
		contact_class = "SELECTED_PART_CONTACT"
		resolved_target_group = target_group
	elif control_margin >= 0:
		contact_class = "BODY_CONTACT_OFF_TARGET"
		resolved_target_group = "GENERAL_TORSO"
	var hit_quality := _classify_hit_quality(control_margin)
	var protection_profile := String(TARGET_PROTECTION.get(resolved_target_group, "NONE_NO_CONTACT")) if not resolved_target_group.is_empty() else "NONE_NO_CONTACT"
	var resolution_id := "%s:%d:%d:%s" % [EXPECTED_ENCOUNTER_ID, round_id, _attack_sequence, TECHNIQUE_ID]
	var damage_handoff := {
		"status": "PENDING_ANATOMY_DAMAGE_RUNTIME",
		"resolution_id": resolution_id,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"round_id": round_id,
		"action_sequence": _attack_sequence,
		"attacker_id": HUNTER_COMBATANT_ID,
		"defender_id": MONSTER_COMBATANT_ID,
		"technique_id": TECHNIQUE_ID,
		"resolved_target_group": resolved_target_group,
		"hit_quality": hit_quality,
		"damage_channel": DAMAGE_CHANNEL,
		"protection_profile": protection_profile,
	}
	var anatomy_result := _anatomy.call("apply_damage_handoff", damage_handoff) as Dictionary
	if not bool(anatomy_result.get("success", false)):
		damage_handoff["status"] = "ANATOMY_APPLICATION_FAILED"
		push_error("Committed Hunter attack could not apply its Mudcrest anatomy handoff: %s" % str(anatomy_result))
	else:
		damage_handoff["status"] = String(anatomy_result.get("status", "ANATOMY_INTEGRITY_RESULT_UNKNOWN"))

	_last_resolution = {
		"success": true,
		"encounter_id": EXPECTED_ENCOUNTER_ID,
		"round_id": round_id,
		"action_sequence": _attack_sequence,
		"resolution_id": resolution_id,
		"technique_id": TECHNIQUE_ID,
		"technique_label": TECHNIQUE_LABEL,
		"attacker_id": HUNTER_COMBATANT_ID,
		"defender_id": MONSTER_COMBATANT_ID,
		"selected_target_group": target_group,
		"resolved_target_group": resolved_target_group,
		"contact_class": contact_class,
		"hit_quality": hit_quality,
		"hit_quality_ceiling": HIT_QUALITY_CEILING,
		"fallback_policy": BODY_FALLBACK_POLICY,
		"damage_channel": DAMAGE_CHANNEL,
		"protection_profile": protection_profile,
		"current_node_id": String(legality.get("current_node_id", "")),
		"body_envelope_distance_m": float(legality.get("body_envelope_distance_m", INF)),
		"line_of_effect": (legality.get("line_of_effect", {}) as Dictionary).duplicate(true),
		"exposure": String(legality.get("exposure", "")),
		"reaction_window": "OPEN_NO_MONSTER_REACTION_RUNTIME_YET",
		"attack_control_base": PROVISIONAL_ATTACK_CONTROL_BASE,
		"target_control_penalty": target_penalty,
		"attack_control": attack_control,
		"defense_control": defense_control,
		"seed_key": seed_key,
		"variance_sample": variance,
		"variance_bounds": [VARIANCE_MIN, VARIANCE_MAX],
		"control_margin": control_margin,
		"fixture_status": FIXTURE_STATUS,
		"resource_cost": {"ap": AP_COST, "stamina": STAMINA_COST},
		"damage_handoff": damage_handoff.duplicate(true),
		"anatomy_result": anatomy_result.duplicate(true),
	}
	_record_trace("HUNTER_ATTACK_RESOLVED", _last_resolution)
	_refresh_hud()
	return _last_resolution.duplicate(true)

func _stable_variance(seed_key: String) -> int:
	# FNV-1a 32-bit gives one reproducible bounded sample without engine/global RNG.
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

func get_target_groups() -> Array:
	return TARGET_GROUPS.duplicate()

func get_selected_target() -> String:
	return _selected_target

func get_last_resolution() -> Dictionary:
	return _last_resolution.duplicate(true)

func get_attack_sequence() -> int:
	return _attack_sequence

func get_trace() -> Array:
	return _trace.duplicate(true)

func get_working_melee_limit_m() -> float:
	return WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M

func commit_measured_cut_for_test(target_group: String) -> Dictionary:
	return commit_measured_cut(target_group)
