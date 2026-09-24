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

func _run() -> void:
	print("Hunt-01 Mudcrest Head Sweep wound/contact classification runtime")
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
	var attack := encounter.call("get_mudcrest_attack_runtime") as Node
	_check("production combat dependencies exist", shell != null and movement != null and reaction != null and attack != null)
	if shell == null or movement == null or reaction == null or attack == null:
		_finish()
		return
	await process_frame

	var classifier := attack.call("get_wound_contact_runtime") as Node
	var defense := attack.call("get_hunter_defense_runtime") as Node
	var health: Node = null
	if defense != null:
		health = defense.call("get_hunter_health_runtime") as Node
	_check("species wound/contact owner is integrated", classifier != null and bool(classifier.call("is_initialized")))
	_check("classifier schema v1", classifier != null and String(classifier.call("get_schema")) == "uhr.hunt01.mudcrest_wound_contact.v1")
	_check("classification fixture is explicitly provisional", classifier != null and String(classifier.call("get_fixture_status")) == "PROVISIONAL_FIRST_SLICE_HEAD_SWEEP_WOUND_CONTACT_CLASSIFICATION_FIXTURE")
	if classifier == null or health == null:
		_finish()
		return

	# Round 1 remains out of range.
	_check("Round-1 Hunter turn can end", bool(shell.call("end_player_turn")))
	var state: Dictionary = shell.call("get_current_state")
	_check("out-of-range Monster activation advances to Round 2 Hunter", int(state.get("round_id", 0)) == 2 and String(state.get("current_actor_id", "")) == HUNTER_ID, str(state))
	_check("N01 -> N04", bool(movement.call("move_for_test", "R01_EF02_N04")))
	_check("N04 -> N07", bool(movement.call("move_for_test", "R01_EF02_N07")))
	_check("N07 -> N09", bool(movement.call("move_for_test", "R01_EF02_N09")))
	await physics_frame
	await process_frame

	# Real blocked SOLID path: strong guard should not claim penetration/dominance.
	_check("Round-2 Hunter end opens real Head Sweep", bool(shell.call("end_player_turn")))
	var window: Dictionary = reaction.call("get_active_window")
	var window_id := String(window.get("window_id", ""))
	_check("first reaction window opens", not window_id.is_empty(), str(window))
	_check("Poleblade Block commits", bool((reaction.call("commit_reaction", window_id, REACTION_BLOCK) as Dictionary).get("success", false)))
	await process_frame
	await process_frame
	var blocked_attack: Dictionary = attack.call("get_last_resolution")
	var blocked_classification: Dictionary = blocked_attack.get("wound_contact_classification", {}) as Dictionary
	_check("real blocked Head Sweep is classified before activation completes", bool(blocked_classification.get("success", false)), str(blocked_classification))
	_check("SOLID strong Block makes no status request", String(blocked_classification.get("hit_quality", "")) == "SOLID" and String(blocked_classification.get("block_outcome", "")) == "BLOCK_STRONG" and int(blocked_classification.get("status_request_count", -1)) == 0, str(blocked_classification))
	_check("strong Block does not invent horn penetration or impact dominance", not bool(blocked_classification.get("horn_penetration_established", true)) and not bool(blocked_classification.get("impact_dominant_established", true)), str(blocked_classification))

	# Real declined SOLID path: unguarded GORE_SWEEP + injury qualifies Bleeding.
	_check("Round-3 Hunter turn opens second Head Sweep", bool(shell.call("end_player_turn")))
	window = reaction.call("get_active_window")
	var second_window_id := String(window.get("window_id", ""))
	_check("second reaction window opens", not second_window_id.is_empty())
	_check("explicit decline commits", bool((reaction.call("decline_reaction", second_window_id) as Dictionary).get("success", false)))
	await process_frame
	await process_frame
	var unguarded_attack: Dictionary = attack.call("get_last_resolution")
	var unguarded_classification: Dictionary = unguarded_attack.get("wound_contact_classification", {}) as Dictionary
	_check("real unguarded SOLID Head Sweep establishes provisional horn penetration", String(unguarded_classification.get("hit_quality", "")) == "SOLID" and String(unguarded_classification.get("contact_mode", "")) == "HORN_PENETRATION_PROVISIONAL" and bool(unguarded_classification.get("horn_penetration_established", false)), str(unguarded_classification))
	var bleed_requests: Array = unguarded_classification.get("status_application_requests", []) as Array
	_check("real unguarded wound emits one valid Bleeding +1 request", bleed_requests.size() == 1 and String((bleed_requests[0] as Dictionary).get("status_id", "")) == "status_bleeding" and int((bleed_requests[0] as Dictionary).get("intensity_delta", 0)) == 1 and String((bleed_requests[0] as Dictionary).get("consumer_status", "")) == "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME", str(bleed_requests))
	_check("classifier does not apply status itself", not unguarded_classification.has("status_instance") and String((bleed_requests[0] as Dictionary).get("status", "")) == "VALID_STATUS_APPLICATION_REQUEST")

	var health_before_synthetic := health.call("get_health_state") as Dictionary
	var synthetic_damage := {
		"status": "PENDING_HUNTER_DAMAGE_RUNTIME",
		"resolution_id": "enc_r01_ef02_m01_0001:CLASSIFIER:CLEAN_PARTIAL",
		"encounter_id": "enc_r01_ef02_m01_0001",
		"attacker_id": MONSTER_ID,
		"defender_id": HUNTER_ID,
		"attack_id": ATTACK_ID,
		"attack_profile": "GORE_SWEEP",
		"damage_channels": ["PIERCING", "IMPACT"],
		"contact_class": "HUNTER_BODY_CONTACT",
		"hit_quality": "CLEAN",
	}
	var synthetic_defense := {
		"success": true,
		"block_outcome": "BLOCK_PARTIAL",
		"health_injury_consequence": {
			"success": true,
			"status": "HUNTER_HEALTH_INJURY_RESOLVED",
			"resolution_id": "enc_r01_ef02_m01_0001:CLASSIFIER:CLEAN_PARTIAL",
			"hit_quality": "CLEAN",
			"defense_outcome": "BLOCK_PARTIAL",
			"applied_injury_load": 7,
		}
	}
	var impact_classification: Dictionary = classifier.call("resolve_head_sweep_consequence", synthetic_damage, synthetic_defense)
	var impact_requests: Array = impact_classification.get("status_application_requests", []) as Array
	_check("CLEAN partial Block establishes provisional impact-dominant contact", String(impact_classification.get("contact_mode", "")) == "IMPACT_DOMINANT_GUARD_FAILURE_PROVISIONAL" and bool(impact_classification.get("impact_dominant_established", false)), str(impact_classification))
	_check("impact-dominant CLEAN emits one Off-Balance request", impact_requests.size() == 1 and String((impact_requests[0] as Dictionary).get("status_id", "")) == "status_off_balance" and String((impact_requests[0] as Dictionary).get("application_mode", "")) == "APPLY_OR_REFRESH", str(impact_requests))
	_check("synthetic classifier call cannot mutate Hunter health", health.call("get_health_state") == health_before_synthetic)
	var replay: Dictionary = classifier.call("resolve_head_sweep_consequence", synthetic_damage, synthetic_defense)
	_check("classification replay is exact/idempotent", replay == impact_classification)
	_check("classification replay still cannot mutate Hunter health", health.call("get_health_state") == health_before_synthetic)

	var no_wound_damage := synthetic_damage.duplicate(true)
	no_wound_damage["resolution_id"] = "enc_r01_ef02_m01_0001:CLASSIFIER:NO_WOUND"
	no_wound_damage["hit_quality"] = "SOLID"
	var no_wound_defense := synthetic_defense.duplicate(true)
	no_wound_defense["block_outcome"] = "NOT_APPLICABLE"
	no_wound_defense["health_injury_consequence"] = {
		"success": true,
		"status": "HUNTER_HEALTH_INJURY_RESOLVED",
		"resolution_id": "enc_r01_ef02_m01_0001:CLASSIFIER:NO_WOUND",
		"hit_quality": "SOLID",
		"defense_outcome": "NO_ACTIVE_GUARD",
		"applied_injury_load": 0,
	}
	var no_wound: Dictionary = classifier.call("resolve_head_sweep_consequence", no_wound_damage, no_wound_defense)
	_check("zero resolved injury produces explicit no-request classification", int(no_wound.get("status_request_count", -1)) == 0 and String(no_wound.get("classification_reason", "")) == "NO_RESOLVED_WOUND_OR_CONTACT", str(no_wound))
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME_FAILED")
	print("This gate does not apply/tick/stack statuses, change attack RNG/costs, alter Health/resources/anatomy, resolve defeat, verify phone acceptance or verify performance.")
	quit(0 if failures.is_empty() else 1)
