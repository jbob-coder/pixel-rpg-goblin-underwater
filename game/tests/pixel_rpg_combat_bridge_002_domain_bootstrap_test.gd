extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const HUNTER_ID := "hunter_player_0001"
const MONSTER_ID := "monster_r01_m01_0001"

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _find_target_index(selector: OptionButton, target_group: String) -> int:
	for index in range(selector.item_count):
		if String(selector.get_item_metadata(index)) == target_group:
			return index
	return -1

func _trace_has_event(trace: Array, event_name: String) -> bool:
	for entry_variant in trace:
		var entry := entry_variant as Dictionary
		if String(entry.get("event", "")) == event_name:
			return true
	return false

func _run() -> void:
	print("Pixel RPG Combat Bridge 002 current-world domain bootstrap no-attack gate")
	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype scene instantiates", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame
	await process_frame

	var world := prototype.get_node_or_null("WorldDisplay/WorldViewport/World") as Node3D
	var hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	var spring_arm := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/SpringArm3D") as SpringArm3D
	var monster_proxy := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/MonsterProxy") as Node3D
	var monster_visual := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/MonsterProxy/MudcrestVisual") as Node3D
	var domain_body := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/%s" % MONSTER_ID) as StaticBody3D
	var selector := prototype.get_node_or_null("HUD/TargetingPanel/Layout/TargetGroup") as OptionButton
	var start_button := prototype.get_node_or_null("HUD/TargetingPanel/Layout/StartCombatDomain") as Button
	var close_button := prototype.get_node_or_null("HUD/TargetingPanel/Layout/Close") as Button
	var target_status := prototype.get_node_or_null("HUD/TargetingPanel/Layout/TargetStatus") as Label

	_check("current Pixel RPG World has transient-control compatibility only", world != null and world.has_method("_reset_transient_controls") and String(world.call("get_schema")) == "pixel_rpg.world_combat_compat.v1")
	_check("first-person camera remains authoritative", camera != null and camera.current and spring_arm != null and spring_arm.get_node_or_null("Camera3D") == null)
	_check("live Mudcrest presentation remains under MonsterProxy", monster_proxy != null and monster_visual != null and monster_visual.get_parent() == monster_proxy)
	_check("stable domain Monster body alias exists", domain_body != null and domain_body.name == MONSTER_ID)
	if domain_body != null and monster_proxy != null:
		var collision := domain_body.get_node_or_null("CollisionShape3D") as CollisionShape3D
		_check("domain Monster body alias is collidable", collision != null and collision.shape != null)
		_check("domain Monster body shares live Mudcrest world position", domain_body.global_position.is_equal_approx(monster_proxy.global_position), "%s / %s" % [domain_body.global_position, monster_proxy.global_position])

	if world == null or hunter == null or monster_proxy == null or selector == null or start_button == null:
		prototype.queue_free()
		await process_frame
		_finish()
		return

	hunter.global_position = monster_proxy.global_position + Vector3(0.0, 0.9, 7.0)
	hunter.velocity = Vector3.ZERO
	prototype.call("_update_contextual_action")
	prototype.call("_on_action_button_pressed")
	_check("ENGAGE opens Bridge 001 targeting before domain bootstrap", bool(prototype.call("get_targeting_preview_state").get("open", false)))
	_check("START COMBAT DOMAIN stays disabled before target lock", start_button.disabled)

	var head_index := _find_target_index(selector, "HEAD")
	_check("HEAD target remains available", head_index >= 0)
	if head_index >= 0:
		prototype.call("_on_target_group_selected", head_index)
		prototype.call("_on_lock_target_pressed")
	_check("explicit target lock enables domain bootstrap action", not start_button.disabled)
	_check("no gameplay domain runtimes start merely from target lock", world.get_node_or_null("CombatTurnShellRuntime") == null and world.get_node_or_null("MudcrestAnatomyRuntime") == null)

	var hunter_before := hunter.global_transform
	var monster_before := monster_proxy.global_transform
	var camera_parent_before := camera.get_parent() if camera != null else null
	prototype.call("_on_start_combat_domain_pressed")

	var shell := world.get_node_or_null("CombatTurnShellRuntime")
	var anatomy := world.get_node_or_null("MudcrestAnatomyRuntime")
	var state: Dictionary = prototype.call("get_targeting_preview_state")
	_check("explicit START COMBAT DOMAIN starts exactly the approved two runtimes", shell != null and anatomy != null and bool(state.get("combat_domain_started", false)))
	_check("turn shell schema is preserved", shell != null and String(shell.call("get_schema")) == "uhr.hunt01.combat_turn_shell.v1")
	_check("Mudcrest anatomy schema is preserved", anatomy != null and String(anatomy.call("get_schema")) == "uhr.hunt01.mudcrest_anatomy.v1")
	_check("domain bootstrap preserves Hunter transform", hunter.global_transform.is_equal_approx(hunter_before), str(hunter.global_position))
	_check("domain bootstrap preserves live Mudcrest visual transform", monster_proxy.global_transform.is_equal_approx(monster_before), str(monster_proxy.global_position))
	_check("domain bootstrap preserves direct first-person camera path", camera != null and camera.current and camera.get_parent() == camera_parent_before and camera.get_parent().name == "CameraPitch")
	_check("legacy tactical movement and attack runtimes remain absent", world.get_node_or_null("CombatTurnShellRuntime/TacticalMovementRuntime") == null and world.get_node_or_null("AttackRuntime") == null and world.get_node_or_null("CombatResolutionRuntime") == null)

	if shell != null:
		var shell_state: Dictionary = shell.call("get_current_state")
		var resources: Dictionary = shell.call("get_resource_state", HUNTER_ID)
		var trace: Array = shell.call("get_trace")
		_check("turn shell begins deterministic Round 1 on Hunter without an attack", int(shell_state.get("round_id", 0)) == 1 and String(shell_state.get("current_actor_id", "")) == HUNTER_ID, str(shell_state))
		_check("bootstrap initializes but does not spend Hunter AP/Stamina", int(resources.get("ap", -1)) == 4 and int(resources.get("stamina", -1)) == 100, str(resources))
		_check("bootstrap trace contains no resource commitment", not _trace_has_event(trace, "RESOURCE_COMMITTED") and not _trace_has_event(trace, "REACTION_RESOURCE_COMMITTED"), str(trace))

	if anatomy != null:
		var head_state: Dictionary = anatomy.call("get_target_state", "HEAD")
		_check("locked HEAD anatomy begins at untouched normalized integrity", int(head_state.get("integrity", -1)) == 100 and int(anatomy.call("get_applied_resolution_count")) == 0, str(head_state))

	_check("current targeting UI exposes initialized domain state", target_status != null and "DOMAIN ACTIVE" in target_status.text and "no attack runtime" in target_status.text)
	_check("domain bootstrap freezes retarget/start/exit controls for this no-attack checkpoint", selector.disabled and start_button.disabled and close_button != null and close_button.disabled)

	var yaw := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw") as Node3D
	if yaw != null:
		var yaw_before := yaw.rotation.y
		prototype.call("_apply_look_delta", Vector2(16.0, 0.0))
		_check("first-person look remains available after domain bootstrap", not is_equal_approx(yaw.rotation.y, yaw_before))

	var shell_id := shell.get_instance_id() if shell != null else 0
	var anatomy_id := anatomy.get_instance_id() if anatomy != null else 0
	prototype.call("_on_start_combat_domain_pressed")
	_check("duplicate bootstrap attempt does not create duplicate runtimes", world.get_node_or_null("CombatTurnShellRuntime").get_instance_id() == shell_id and world.get_node_or_null("MudcrestAnatomyRuntime").get_instance_id() == anatomy_id)

	prototype.call("_on_targeting_close_pressed")
	state = prototype.call("get_targeting_preview_state")
	_check("exit targeting cannot silently resume exploration after domain start", bool(state.get("open", false)) and bool(state.get("combat_domain_started", false)))

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_COMBAT_BRIDGE_002_DOMAIN_BOOTSTRAP_NO_ATTACK_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_COMBAT_BRIDGE_002_DOMAIN_BOOTSTRAP_NO_ATTACK_FAILED")
	print("This gate proves current-world turn/anatomy bootstrap only. Hunter attack, damage, legacy tactical movement, phone UX and final combat presentation remain outside this slice.")
	quit(0 if failures.is_empty() else 1)
