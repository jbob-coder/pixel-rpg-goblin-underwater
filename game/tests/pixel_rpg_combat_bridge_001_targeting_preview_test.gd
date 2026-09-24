extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")

const EXPECTED_TARGET_GROUPS := [
	"HEAD",
	"HORN_CREST",
	"FORELEG_L",
	"FORELEG_R",
	"HINDLEG_L",
	"HINDLEG_R",
	"DORSAL_PLATES",
	"TAIL",
]

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _group_has_overlay(node: Node) -> bool:
	if node is MeshInstance3D and (node as MeshInstance3D).material_overlay != null:
		return true
	for child in node.get_children():
		if _group_has_overlay(child):
			return true
	return false

func _find_target_index(selector: OptionButton, target_group: String) -> int:
	for index in range(selector.item_count):
		if String(selector.get_item_metadata(index)) == target_group:
			return index
	return -1

func _xz(position: Vector3) -> Vector2:
	return Vector2(position.x, position.z)

func _run() -> void:
	print("Pixel RPG Combat Bridge 001 first-person targeting preview regression gate")

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
	var hunter_visual := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/Visual") as Node3D
	var monster_anchor := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/MonsterProxy") as Node3D
	var monster_visual := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/MonsterProxy/MudcrestVisual") as Node3D
	var panel := prototype.get_node_or_null("HUD/TargetingPanel") as PanelContainer
	var selector := prototype.get_node_or_null("HUD/TargetingPanel/Layout/TargetGroup") as OptionButton
	var status := prototype.get_node_or_null("HUD/TargetingPanel/Layout/TargetStatus") as Label
	var action_button := prototype.get_node_or_null("HUD/Touch/ActionButton") as Button
	var joystick := prototype.get_node_or_null("HUD/Touch/MoveJoystick") as Control

	_check("current Pixel RPG world/hunter/Mudcrest exist", world != null and hunter != null and monster_anchor != null and monster_visual != null)
	_check("targeting HUD nodes exist", panel != null and selector != null and status != null)
	_check("first-person direct camera is authoritative", camera != null and camera.current)
	_check("legacy SpringArm remains inert and outside active camera path", spring_arm != null and spring_arm.get_node_or_null("Camera3D") == null)
	_check("third-person hunter visual is hidden in normal first-person presentation", hunter_visual != null and not hunter_visual.visible)
	_check("no duplicate legacy FirstPersonCamera controller exists", hunter != null and hunter.get_node_or_null("FirstPersonCamera") == null)
	_check("targeting panel starts closed", panel != null and not panel.visible)

	if hunter == null or monster_anchor == null or monster_visual == null or panel == null or selector == null or action_button == null:
		prototype.queue_free()
		await process_frame
		_finish()
		return

	hunter.global_position = monster_anchor.global_position + Vector3(0.0, 0.9, 12.0)
	hunter.velocity = Vector3.ZERO
	prototype.call("_update_contextual_action")
	_check("observation remains available outside engage radius", action_button.visible and action_button.text == "OBSERVE", action_button.text)

	hunter.global_position = monster_anchor.global_position + Vector3(0.0, 0.9, 7.0)
	hunter.velocity = Vector3.ZERO
	prototype.call("_update_contextual_action")
	_check("current-world ENGAGE appears inside 8 m radius", action_button.visible and action_button.text == "ENGAGE", action_button.text)

	var hunter_before := hunter.global_transform
	var monster_before := monster_anchor.global_transform
	prototype.call("_on_action_button_pressed")
	var state: Dictionary = prototype.call("get_targeting_preview_state")
	_check("ENGAGE opens targeting preview", bool(state.get("open", false)) and panel.visible, str(state))
	_check("targeting preview keeps first-person camera current", String(state.get("camera_mode", "")) == "first_person" and bool(state.get("first_person_camera_current", false)) and camera.current)
	_check("ENGAGE preserves Hunter transform", hunter.global_transform.is_equal_approx(hunter_before), str(hunter.global_position))
	_check("ENGAGE preserves Mudcrest transform", monster_anchor.global_transform.is_equal_approx(monster_before), str(monster_anchor.global_position))
	_check("exploration joystick hides only after explicit ENGAGE", joystick != null and not joystick.visible)

	_check("selector exposes exactly eight attack-authority body groups", selector.item_count == EXPECTED_TARGET_GROUPS.size(), "count=%d" % selector.item_count)
	var metadata_matches := true
	var all_nodes_exist := true
	for index in range(selector.item_count):
		var group := String(selector.get_item_metadata(index))
		if index >= EXPECTED_TARGET_GROUPS.size() or group != EXPECTED_TARGET_GROUPS[index]:
			metadata_matches = false
		if monster_visual.get_node_or_null(NodePath(group)) == null:
			all_nodes_exist = false
	_check("selector metadata matches current Measured Cut target order", metadata_matches)
	_check("every selectable target maps to a live Mudcrest visual node", all_nodes_exist)
	_check("GENERAL_TORSO remains non-selectable fallback", _find_target_index(selector, "GENERAL_TORSO") == -1)

	var dorsal := monster_visual.get_node_or_null("DORSAL_PLATES")
	_check("default DORSAL_PLATES selection is visibly highlighted", dorsal != null and _group_has_overlay(dorsal))

	var head_index := _find_target_index(selector, "HEAD")
	_check("HEAD target is available", head_index >= 0)
	if head_index >= 0:
		prototype.call("_on_target_group_selected", head_index)
		state = prototype.call("get_targeting_preview_state")
		var head := monster_visual.get_node_or_null("HEAD")
		_check("selecting HEAD updates preview authority", String(state.get("selected_target_group", "")) == "HEAD", str(state))
		_check("selected HEAD receives highlight", head != null and _group_has_overlay(head))
		_check("previous DORSAL_PLATES highlight clears", dorsal != null and not _group_has_overlay(dorsal))
		prototype.call("_on_lock_target_pressed")
		state = prototype.call("get_targeting_preview_state")
		_check("lock action records selected visual target only", String(state.get("locked_target_group", "")) == "HEAD" and "LOCKED" in status.text, str(state))

	_check("targeting preview does not start legacy CombatTurnShellRuntime", world.get_node_or_null("CombatTurnShellRuntime") == null)
	_check("targeting preview does not start Mudcrest anatomy damage runtime", world.get_node_or_null("MudcrestAnatomyRuntime") == null)

	prototype.call("_apply_safe_area_layout")
	await process_frame
	var panel_rect := panel.get_global_rect()
	_check("targeting panel touch is excluded from camera-look capture", not bool(prototype.call("_can_claim_look_touch", panel_rect.get_center())))

	var viewport_size := root.get_visible_rect().size
	var free_look_point := Vector2(viewport_size.x * 0.55, viewport_size.y * 0.55)
	if panel_rect.has_point(free_look_point):
		free_look_point = Vector2(viewport_size.x * 0.50, viewport_size.y * 0.72)
	_check("right-side look remains available outside targeting controls", bool(prototype.call("_can_claim_look_touch", free_look_point)), str(free_look_point))

	var yaw_before := (prototype.get_node("WorldDisplay/WorldViewport/World/Hunter/CameraYaw") as Node3D).rotation.y
	prototype.call("_apply_look_delta", Vector2(18.0, 0.0))
	var yaw_after := (prototype.get_node("WorldDisplay/WorldViewport/World/Hunter/CameraYaw") as Node3D).rotation.y
	_check("first-person camera can still rotate during targeting", not is_equal_approx(yaw_before, yaw_after))

	prototype.set("_joystick_vector", Vector2(1.0, 0.0))
	var xz_before := _xz(hunter.global_position)
	prototype.call("_physics_process", 0.016)
	var xz_after := _xz(hunter.global_position)
	_check("targeting state locks locomotion despite stale joystick input", xz_after.distance_to(xz_before) <= 0.001, "%s -> %s" % [xz_before, xz_after])

	prototype.call("_on_targeting_close_pressed")
	state = prototype.call("get_targeting_preview_state")
	_check("EXIT TARGETING closes preview and restores joystick", not bool(state.get("open", true)) and not panel.visible and joystick.visible, str(state))
	_check("closing targeting clears visual highlight", dorsal != null and not _group_has_overlay(dorsal) and not _group_has_overlay(monster_visual.get_node("HEAD")))
	_check("preview slice never changed actor transforms except test-controlled Hunter placement", monster_anchor.global_transform.is_equal_approx(monster_before))

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_COMBAT_BRIDGE_001_TARGETING_PREVIEW_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_COMBAT_BRIDGE_001_TARGETING_PREVIEW_FAILED")
	print("This gate verifies current-world target acquisition remains compatible with the creator-authoritative first-person presentation; AP/Stamina/damage and legacy combat-coordinate adaptation remain outside this bridge slice.")
	quit(0 if failures.is_empty() else 1)
