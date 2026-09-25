extends Node

const WorldBase001 := preload("res://scripts/presentation/pixel_rpg/world_base_001.gd")
const WorldPaths001 := preload("res://scripts/presentation/pixel_rpg/world_paths_001.gd")
const WorldSettlementCore001 := preload("res://scripts/presentation/pixel_rpg/world_settlement_core_001.gd")
const WorldGateProps001 := preload("res://scripts/presentation/pixel_rpg/world_gate_props_001.gd")
const WorldTrailEnvironment001 := preload("res://scripts/presentation/pixel_rpg/world_trail_environment_001.gd")
const WorldActorPresentation001 := preload("res://scripts/presentation/pixel_rpg/world_actor_presentation_001.gd")
const FirstPersonCameraMath001 := preload("res://scripts/presentation/pixel_rpg/first_person_camera_math_001.gd")
const PlayerMotionMath001 := preload("res://scripts/presentation/pixel_rpg/player_motion_math_001.gd")
const TouchInputMath001 := preload("res://scripts/presentation/pixel_rpg/touch_input_math_001.gd")
const HudLayout001 := preload("res://scripts/presentation/pixel_rpg/hud_layout_001.gd")
const MinimapMath001 := preload("res://scripts/presentation/pixel_rpg/minimap_math_001.gd")
const WorldPack004EnterableSmith := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")
const CombatTurnShellRuntime: Script = preload("res://scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd")
const MudcrestAnatomyRuntime: Script = preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd")
const ConceptPhotoReconstruction011 := preload("res://scripts/presentation/pixel_rpg/concept_photo_reconstruction_011.gd")

const MOVE_SPEED_MPS := 5.2
const GRAVITY_MPS2 := 9.8
const JOYSTICK_DEADZONE := 0.12
const LOOK_REGION_START_X_RATIO := 0.44
const DEFAULT_LOOK_DEGREES_PER_PIXEL := 0.105
const CAMERA_PITCH_MIN_DEG := -78.0
const CAMERA_PITCH_MAX_DEG := 78.0
const NPC_INTERACT_DISTANCE_M := 2.6
const SMITH_INTERACT_DISTANCE_M := 2.2
const MONSTER_ENGAGE_DISTANCE_M := 8.0
const MONSTER_OBSERVE_DISTANCE_M := 15.0
const MUDCREST_TARGETABLE_GROUPS := [
	"HEAD",
	"HORN_CREST",
	"FORELEG_L",
	"FORELEG_R",
	"HINDLEG_L",
	"HINDLEG_R",
	"DORSAL_PLATES",
	"TAIL",
]
const RESPAWN_Y_M := -8.0
const PLAYER_START := Vector3(0.0, 0.9, 13.0)
const HUD_EDGE_MARGIN := 18.0
const DOMAIN_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"
const DOMAIN_MONSTER_ID := "monster_r01_m01_0001"
const DOMAIN_HUNTER_ID := "hunter_player_0001"

@onready var world_viewport: SubViewport = $WorldDisplay/WorldViewport
@onready var world: Node3D = $WorldDisplay/WorldViewport/World
@onready var world_geometry: Node3D = $WorldDisplay/WorldViewport/World/WorldGeometry
@onready var hunter: CharacterBody3D = $WorldDisplay/WorldViewport/World/Hunter
@onready var hunter_visual: Node3D = $WorldDisplay/WorldViewport/World/Hunter/Visual
@onready var camera_yaw: Node3D = $WorldDisplay/WorldViewport/World/Hunter/CameraYaw
@onready var camera_pitch: Node3D = $WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch
@onready var spring_arm: SpringArm3D = $WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/SpringArm3D
@onready var camera: Camera3D = $WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D
@onready var joystick_base: Control = $HUD/Touch/MoveJoystick
@onready var joystick_knob: Control = $HUD/Touch/MoveJoystick/Knob
@onready var action_button: Button = $HUD/Touch/ActionButton
@onready var watch_button: Button = $HUD/Touch/WatchButton
@onready var settings_button: Button = $HUD/Touch/SettingsButton
@onready var minimap_panel: PanelContainer = $HUD/MinimapPanel
@onready var minimap_canvas: Control = $HUD/MinimapPanel/Map
@onready var minimap_player_marker: ColorRect = $HUD/MinimapPanel/Map/PlayerMarker
@onready var status_panel: PanelContainer = $HUD/TopLeft
@onready var status_label: Label = $HUD/TopLeft/Status
@onready var objective_panel: PanelContainer = $HUD/ObjectivePanel
@onready var objective_label: Label = $HUD/ObjectivePanel/Objective
@onready var prompt_label: Label = $HUD/InteractionPrompt
@onready var watch_panel: PanelContainer = $HUD/WatchPanel
@onready var watch_text: Label = $HUD/WatchPanel/Layout/Body
@onready var settings_panel: PanelContainer = $HUD/SettingsPanel
@onready var settings_sensitivity_label: Label = $HUD/SettingsPanel/Layout/SensitivityLabel
@onready var camera_sensitivity_slider: HSlider = $HUD/SettingsPanel/Layout/CameraSensitivity
@onready var targeting_panel: PanelContainer = $HUD/TargetingPanel
@onready var target_group_selector: OptionButton = $HUD/TargetingPanel/Layout/TargetGroup
@onready var target_status_label: Label = $HUD/TargetingPanel/Layout/TargetStatus
@onready var target_mode_label: Label = $HUD/TargetingPanel/Layout/Mode
@onready var target_lock_button: Button = $HUD/TargetingPanel/Layout/LockTarget
@onready var start_combat_domain_button: Button = $HUD/TargetingPanel/Layout/StartCombatDomain
@onready var targeting_close_button: Button = $HUD/TargetingPanel/Layout/Close

var _joystick_vector := Vector2.ZERO
var _joystick_touch_id := -1
var _look_touch_id := -1
var _look_last_position := Vector2.ZERO
var _camera_yaw_rad := 0.0
var _camera_pitch_rad := 0.0
var _look_degrees_per_pixel := DEFAULT_LOOK_DEGREES_PER_PIXEL
var _npc_anchor: Node3D
var _smith_root: Node3D
var _smith_use_anchor: Node3D
var _monster_anchor: Node3D
var _monster_visual: Node3D
var _domain_monster_body: StaticBody3D
var _combat_turn_shell: Node
var _mudcrest_anatomy: Node
var _combat_domain_started := false
var _targeting_open := false
var _selected_target_group := "DORSAL_PLATES"
var _locked_target_group := ""
var _target_highlight_material: StandardMaterial3D
var _current_context := "NONE"
var _world_ready := false
var _elapsed := 0.0

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_FOCUS_IN:
			_reset_transient_input()

func _ready() -> void:
	_build_prototype_world()
	_camera_yaw_rad = 0.0
	_camera_pitch_rad = 0.0
	_apply_camera_rotation()
	hunter_visual.visible = false
	camera.current = true
	watch_panel.visible = false
	settings_panel.visible = false
	targeting_panel.visible = false
	_configure_targeting_preview()
	camera_sensitivity_slider.value = _look_degrees_per_pixel
	_update_sensitivity_label()
	prompt_label.visible = false
	action_button.visible = false
	get_viewport().size_changed.connect(_apply_safe_area_layout)
	_apply_safe_area_layout()
	_update_minimap()
	_world_ready = true
	_update_contextual_action()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			if not _targeting_open and _joystick_touch_id == -1 and joystick_base.get_global_rect().has_point(touch.position):
				_joystick_touch_id = touch.index
				_update_joystick(touch.position)
				get_viewport().set_input_as_handled()
			elif _look_touch_id == -1 and _can_claim_look_touch(touch.position):
				_look_touch_id = touch.index
				_look_last_position = touch.position
				get_viewport().set_input_as_handled()
		else:
			if touch.index == _joystick_touch_id:
				_reset_joystick()
				get_viewport().set_input_as_handled()
			elif touch.index == _look_touch_id:
				_look_touch_id = -1
				get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _joystick_touch_id:
			_update_joystick(drag.position)
			get_viewport().set_input_as_handled()
		elif drag.index == _look_touch_id:
			var delta_px := drag.position - _look_last_position
			_look_last_position = drag.position
			_apply_look_delta(delta_px)
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var mouse_motion := event as InputEventMouseMotion
		_apply_look_delta(mouse_motion.relative)

func _physics_process(delta: float) -> void:
	if not _world_ready:
		return

	var movement_input := Vector2.ZERO
	if not _targeting_open:
		var desktop_x := (1.0 if Input.is_key_pressed(KEY_D) else 0.0) - (1.0 if Input.is_key_pressed(KEY_A) else 0.0)
		var desktop_y := (1.0 if Input.is_key_pressed(KEY_S) else 0.0) - (1.0 if Input.is_key_pressed(KEY_W) else 0.0)
		movement_input = Vector2(desktop_x, desktop_y) + _joystick_vector
		if movement_input.length() > 1.0:
			movement_input = movement_input.normalized()

	var move_world := _camera_relative_movement(movement_input)
	hunter.velocity = PlayerMotionMath001.apply_horizontal_velocity(
		hunter.velocity,
		move_world,
		MOVE_SPEED_MPS
	)
	hunter.velocity.y = PlayerMotionMath001.apply_vertical_velocity(
		hunter.velocity.y,
		hunter.is_on_floor(),
		delta,
		GRAVITY_MPS2
	)

	hunter.move_and_slide()

	hunter_visual.rotation.y = PlayerMotionMath001.visual_yaw(
		hunter_visual.rotation.y,
		move_world,
		delta
	)

	if PlayerMotionMath001.should_respawn(hunter.global_position.y, RESPAWN_Y_M):
		hunter.global_position = PLAYER_START
		hunter.velocity = Vector3.ZERO

func _process(delta: float) -> void:
	_elapsed += maxf(delta, 0.0)
	if _elapsed < 0.12:
		return
	_elapsed = 0.0
	_update_contextual_action()
	var pos := hunter.global_position
	status_label.text = "HP 100   ST 100\nX %.0f  Z %.0f" % [pos.x, pos.z]
	_update_minimap()
	_update_smith_interior_visibility()

func _camera_relative_movement(input_vector: Vector2) -> Vector3:
	return FirstPersonCameraMath001.camera_relative_movement(camera_yaw.global_transform.basis, input_vector)

func _apply_look_delta(delta_px: Vector2) -> void:
	var next_rotation := FirstPersonCameraMath001.apply_look_delta(
		_camera_yaw_rad,
		_camera_pitch_rad,
		delta_px,
		_look_degrees_per_pixel,
		CAMERA_PITCH_MIN_DEG,
		CAMERA_PITCH_MAX_DEG
	)
	_camera_yaw_rad = next_rotation.x
	_camera_pitch_rad = next_rotation.y
	_apply_camera_rotation()

func _apply_camera_rotation() -> void:
	FirstPersonCameraMath001.apply_camera_rotation(
		camera_yaw,
		camera_pitch,
		_camera_yaw_rad,
		_camera_pitch_rad
	)

func _can_claim_look_touch(screen_position: Vector2) -> bool:
	var viewport_size := get_viewport().get_visible_rect().size
	if not TouchInputMath001.is_in_look_region(screen_position, viewport_size, LOOK_REGION_START_X_RATIO):
		return false
	if action_button.visible and action_button.get_global_rect().has_point(screen_position):
		return false
	if watch_button.get_global_rect().has_point(screen_position):
		return false
	if settings_button.get_global_rect().has_point(screen_position):
		return false
	if minimap_panel.get_global_rect().has_point(screen_position):
		return false
	if watch_panel.visible and watch_panel.get_global_rect().has_point(screen_position):
		return false
	if settings_panel.visible and settings_panel.get_global_rect().has_point(screen_position):
		return false
	if targeting_panel.visible and targeting_panel.get_global_rect().has_point(screen_position):
		return false
	return true

func _update_joystick(screen_position: Vector2) -> void:
	var sample := TouchInputMath001.joystick_sample(
		screen_position,
		joystick_base.get_global_rect(),
		joystick_knob.size,
		JOYSTICK_DEADZONE
	)
	_joystick_vector = sample.get("vector", Vector2.ZERO) as Vector2
	joystick_knob.position = sample.get("knob_position", Vector2.ZERO) as Vector2

func _reset_joystick() -> void:
	_joystick_touch_id = -1
	_joystick_vector = Vector2.ZERO
	joystick_knob.position = TouchInputMath001.joystick_center_position(
		joystick_base.get_rect().size,
		joystick_knob.size
	)

func _reset_transient_input() -> void:
	_reset_joystick()
	_look_touch_id = -1

func _apply_safe_area_layout() -> void:
	var layout := HudLayout001.calculate(
		get_viewport().get_visible_rect().size,
		DisplayServer.window_get_size(),
		DisplayServer.get_display_safe_area(),
		HUD_EDGE_MARGIN
	)
	if layout.is_empty():
		return

	HudLayout001.apply_offsets(status_panel, layout.get("status_offsets", Rect2()) as Rect2)
	HudLayout001.apply_offsets(objective_panel, layout.get("objective_offsets", Rect2()) as Rect2)

	settings_button.anchor_left = 0.5
	settings_button.anchor_right = 0.5
	settings_button.anchor_top = 0.0
	settings_button.anchor_bottom = 0.0
	HudLayout001.apply_offsets(settings_button, layout.get("settings_button_offsets", Rect2()) as Rect2)

	minimap_panel.anchor_left = 1.0
	minimap_panel.anchor_right = 1.0
	minimap_panel.anchor_top = 0.0
	minimap_panel.anchor_bottom = 0.0
	HudLayout001.apply_offsets(minimap_panel, layout.get("minimap_offsets", Rect2()) as Rect2)

	HudLayout001.apply_offsets(watch_button, layout.get("watch_button_offsets", Rect2()) as Rect2)
	HudLayout001.apply_offsets(joystick_base, layout.get("joystick_offsets", Rect2()) as Rect2)
	HudLayout001.apply_offsets(action_button, layout.get("action_button_offsets", Rect2()) as Rect2)

	prompt_label.anchor_left = 0.32
	prompt_label.anchor_right = 0.68
	prompt_label.anchor_top = 1.0
	prompt_label.anchor_bottom = 1.0
	HudLayout001.apply_offsets(prompt_label, layout.get("prompt_offsets", Rect2()) as Rect2)

	watch_panel.anchor_left = 0.5
	watch_panel.anchor_right = 0.5
	watch_panel.anchor_top = 0.5
	watch_panel.anchor_bottom = 0.5
	HudLayout001.apply_offsets(watch_panel, layout.get("watch_panel_offsets", Rect2()) as Rect2)

	settings_panel.anchor_left = 0.5
	settings_panel.anchor_right = 0.5
	settings_panel.anchor_top = 0.5
	settings_panel.anchor_bottom = 0.5
	HudLayout001.apply_offsets(settings_panel, layout.get("settings_panel_offsets", Rect2()) as Rect2)

	targeting_panel.anchor_left = 1.0
	targeting_panel.anchor_right = 1.0
	targeting_panel.anchor_top = 0.5
	targeting_panel.anchor_bottom = 0.5
	HudLayout001.apply_offsets(targeting_panel, layout.get("targeting_panel_offsets", Rect2()) as Rect2)

	_update_minimap()
	_reset_joystick()

func _update_minimap() -> void:
	if minimap_canvas == null or minimap_player_marker == null or hunter == null:
		return
	var map_size := minimap_canvas.size
	if map_size.x <= 1.0 or map_size.y <= 1.0:
		return
	minimap_player_marker.position = MinimapMath001.marker_position(
		hunter.global_position,
		map_size,
		minimap_player_marker.size
	)

func _configure_targeting_preview() -> void:
	target_group_selector.clear()
	for group_variant in MUDCREST_TARGETABLE_GROUPS:
		var group := String(group_variant)
		target_group_selector.add_item(group.replace("_", " "))
		target_group_selector.set_item_metadata(target_group_selector.item_count - 1, group)
		if group == _selected_target_group:
			target_group_selector.select(target_group_selector.item_count - 1)
	_target_highlight_material = StandardMaterial3D.new()
	_target_highlight_material.albedo_color = Color(1.0, 0.62, 0.16, 0.38)
	_target_highlight_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_target_highlight_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	start_combat_domain_button.disabled = true
	_refresh_targeting_status()

func _set_material_overlay_recursive(node: Node, overlay: Material) -> void:
	if node is MeshInstance3D:
		(node as MeshInstance3D).material_overlay = overlay
	for child in node.get_children():
		_set_material_overlay_recursive(child, overlay)

func _clear_target_highlight() -> void:
	if _monster_visual == null:
		return
	for group_variant in MUDCREST_TARGETABLE_GROUPS:
		var target_root := _monster_visual.get_node_or_null(NodePath(String(group_variant)))
		if target_root != null:
			_set_material_overlay_recursive(target_root, null)

func _apply_target_highlight(target_group: String) -> bool:
	_clear_target_highlight()
	if _monster_visual == null or not MUDCREST_TARGETABLE_GROUPS.has(target_group):
		return false
	var target_root := _monster_visual.get_node_or_null(NodePath(target_group))
	if target_root == null:
		return false
	_set_material_overlay_recursive(target_root, _target_highlight_material)
	return true

func _refresh_targeting_status() -> void:
	if target_status_label == null:
		return
	if _combat_domain_started and _combat_turn_shell != null and _mudcrest_anatomy != null:
		var shell_state: Dictionary = _combat_turn_shell.call("get_current_state")
		var resources: Dictionary = _combat_turn_shell.call("get_resource_state", DOMAIN_HUNTER_ID)
		var anatomy_state: Dictionary = _mudcrest_anatomy.call("get_target_state", _locked_target_group)
		var actor := String(shell_state.get("current_actor_id", ""))
		target_status_label.text = "DOMAIN ACTIVE • Round %d • %s\nAP %d/%d • Stamina %d/%d\n%s Integrity %d/%d • no attack runtime" % [
			int(shell_state.get("round_id", 0)),
			"HUNTER" if actor == DOMAIN_HUNTER_ID else actor,
			int(resources.get("ap", 0)),
			int(resources.get("max_ap", 0)),
			int(resources.get("stamina", 0)),
			int(resources.get("max_stamina", 0)),
			_locked_target_group.replace("_", " "),
			int(anatomy_state.get("integrity", 0)),
			int(anatomy_state.get("max_integrity", 0)),
		]
		return
	var readable := _selected_target_group.replace("_", " ")
	if not _locked_target_group.is_empty():
		target_status_label.text = "LOCKED • %s • ready for domain bootstrap" % _locked_target_group.replace("_", " ")
	else:
		target_status_label.text = "SELECTED • %s • preview only" % readable

func _open_targeting_preview() -> bool:
	if _targeting_open or _monster_visual == null:
		return false
	var target_root := _monster_visual.get_node_or_null(NodePath(_selected_target_group))
	if target_root == null:
		return false
	_targeting_open = true
	_locked_target_group = ""
	start_combat_domain_button.disabled = true
	target_group_selector.disabled = false
	target_lock_button.disabled = false
	targeting_close_button.disabled = false
	_current_context = "TARGETING"
	targeting_panel.visible = true
	action_button.visible = false
	prompt_label.visible = false
	joystick_base.visible = false
	settings_button.disabled = true
	watch_button.disabled = true
	settings_panel.visible = false
	watch_panel.visible = false
	_reset_transient_input()
	_apply_target_highlight(_selected_target_group)
	_refresh_targeting_status()
	objective_label.text = "First-person target acquisition active. Select a Mudcrest body part; no combat resources or damage are committed."
	return true

func _close_targeting_preview() -> void:
	if not _targeting_open or _combat_domain_started:
		return
	_targeting_open = false
	_locked_target_group = ""
	targeting_panel.visible = false
	joystick_base.visible = true
	settings_button.disabled = false
	watch_button.disabled = false
	_clear_target_highlight()
	_current_context = "NONE"
	_update_contextual_action()

func _on_target_group_selected(index: int) -> void:
	if _combat_domain_started or index < 0 or index >= target_group_selector.item_count:
		return
	var group := String(target_group_selector.get_item_metadata(index))
	if not MUDCREST_TARGETABLE_GROUPS.has(group):
		return
	_selected_target_group = group
	_locked_target_group = ""
	start_combat_domain_button.disabled = true
	_apply_target_highlight(group)
	_refresh_targeting_status()

func _on_lock_target_pressed() -> void:
	if _combat_domain_started or not _targeting_open or not MUDCREST_TARGETABLE_GROUPS.has(_selected_target_group):
		return
	_locked_target_group = _selected_target_group
	start_combat_domain_button.disabled = false
	_apply_target_highlight(_locked_target_group)
	_refresh_targeting_status()
	objective_label.text = "Target locked: %s. Domain bootstrap is available; no attack or damage is active." % _locked_target_group.replace("_", " ")

func _on_start_combat_domain_pressed() -> void:
	if _combat_domain_started or not _targeting_open or _locked_target_group.is_empty():
		return
	if _domain_monster_body == null or world == null:
		objective_label.text = "Combat domain bootstrap blocked: current-world Monster authority unavailable."
		return

	var encounter_record := {
		"encounter_id": DOMAIN_ENCOUNTER_ID,
		"monster_id": DOMAIN_MONSTER_ID,
	}

	var anatomy := MudcrestAnatomyRuntime.new() as Node
	anatomy.name = "MudcrestAnatomyRuntime"
	world.add_child(anatomy)
	if not bool(anatomy.call("initialize", world, encounter_record)):
		anatomy.queue_free()
		objective_label.text = "Combat domain bootstrap blocked: Mudcrest anatomy authority rejected initialization."
		return

	var shell := CombatTurnShellRuntime.new() as Node
	shell.name = "CombatTurnShellRuntime"
	world.add_child(shell)
	if not bool(shell.call("initialize", world, encounter_record)):
		shell.queue_free()
		anatomy.queue_free()
		objective_label.text = "Combat domain bootstrap blocked: turn-shell authority rejected initialization."
		return

	_mudcrest_anatomy = anatomy
	_combat_turn_shell = shell
	_combat_domain_started = true
	target_group_selector.disabled = true
	target_lock_button.disabled = true
	start_combat_domain_button.disabled = true
	targeting_close_button.disabled = true
	target_mode_label.text = "FIRST-PERSON COMBAT DOMAIN BOOTSTRAP\nTurn/anatomy state initialized • no attack, damage, AP/Stamina spend, or actor teleport."
	objective_label.text = "Combat domain initialized against live Mudcrest. Target %s remains locked; attack runtime is intentionally absent." % _locked_target_group.replace("_", " ")
	_refresh_targeting_status()

func _on_targeting_close_pressed() -> void:
	_close_targeting_preview()

func get_targeting_preview_state() -> Dictionary:
	return {
		"open": _targeting_open,
		"selected_target_group": _selected_target_group,
		"locked_target_group": _locked_target_group,
		"target_count": MUDCREST_TARGETABLE_GROUPS.size(),
		"camera_mode": "first_person",
		"first_person_camera_current": camera.current,
		"third_person_camera_current": false,
		"monster_visual_ready": _monster_visual != null,
		"domain_monster_body_ready": _domain_monster_body != null,
		"combat_domain_started": _combat_domain_started,
		"combat_turn_shell_ready": _combat_turn_shell != null,
		"mudcrest_anatomy_ready": _mudcrest_anatomy != null,
	}

func _update_smith_interior_visibility() -> void:
	if _smith_root == null:
		return
	var local_player := _smith_root.to_local(hunter.global_position)
	var inside := WorldPack004EnterableSmith.is_inside(local_player)
	for roof_name in ["RoofA", "RoofB", "RidgeBeam"]:
		var roof := _smith_root.get_node_or_null(NodePath(roof_name)) as GeometryInstance3D
		if roof != null:
			roof.visible = not inside

func _update_contextual_action() -> void:
	if _targeting_open:
		_current_context = "TARGETING"
		action_button.visible = false
		prompt_label.visible = false
		return
	if _npc_anchor != null:
		var npc_distance := hunter.global_position.distance_to(_npc_anchor.global_position)
		if npc_distance <= NPC_INTERACT_DISTANCE_M:
			_set_context("TALK", "Talk • Gate Warden")
			return
	if _smith_use_anchor != null:
		var smith_distance := hunter.global_position.distance_to(_smith_use_anchor.global_position)
		if smith_distance <= SMITH_INTERACT_DISTANCE_M:
			_set_context("SMITH", "Use • Smithing station")
			return
	if _monster_anchor != null:
		var monster_distance := hunter.global_position.distance_to(_monster_anchor.global_position)
		if monster_distance <= MONSTER_ENGAGE_DISTANCE_M:
			_set_context("ENGAGE", "Engage • Target Mudcrest body part")
			return
		if monster_distance <= MONSTER_OBSERVE_DISTANCE_M:
			_set_context("OBSERVE", "Observe • Large trail beast")
			return
	_set_context("NONE", "")

func _set_context(context: String, prompt: String) -> void:
	_current_context = context
	var active := context != "NONE"
	action_button.visible = active
	prompt_label.visible = active
	prompt_label.text = prompt
	match context:
		"TALK":
			action_button.text = "TALK"
		"SMITH":
			action_button.text = "USE"
		"ENGAGE":
			action_button.text = "ENGAGE"
		"OBSERVE":
			action_button.text = "OBSERVE"
		_:
			action_button.text = "ACTION"

func _on_action_button_pressed() -> void:
	match _current_context:
		"TALK":
			objective_label.text = "Warden: tracks crossed the north gate before dawn. Follow the damaged pines."
			watch_text.text = "FIELD NOTE\nFresh heavy tracks north of the settlement.\nThe gate warden reports damaged pines along the trail."
		"SMITH":
			objective_label.text = "Smithing station inspected. Full crafting remains outside this prototype slice."
			watch_text.text = "SMITHING NOTE\nThe settlement forge is accessible and operational.\nCrafting systems remain outside this prototype slice."
		"ENGAGE":
			_open_targeting_preview()
		"OBSERVE":
			objective_label.text = "Observation recorded: broad tail, armored dorsal ridge, heavy forequarters."
			watch_text.text = "HUNTER JOURNAL\nObserved from the trail:\n• armored dorsal ridge\n• broad tail\n• heavy forequarters\nBody-part data remains provisional until combat."

func _on_settings_button_pressed() -> void:
	settings_panel.visible = not settings_panel.visible
	if settings_panel.visible:
		watch_panel.visible = false
		_reset_transient_input()

func _on_settings_close_pressed() -> void:
	settings_panel.visible = false

func _on_camera_sensitivity_changed(value: float) -> void:
	_look_degrees_per_pixel = clampf(value, 0.06, 0.18)
	_update_sensitivity_label()

func _update_sensitivity_label() -> void:
	settings_sensitivity_label.text = "CAMERA SENSITIVITY  %.3f" % _look_degrees_per_pixel

func _on_watch_button_pressed() -> void:
	watch_panel.visible = not watch_panel.visible
	if watch_panel.visible:
		settings_panel.visible = false
		_reset_transient_input()

func _on_watch_close_pressed() -> void:
	watch_panel.visible = false

func _build_prototype_world() -> void:
	WorldBase001.add_world_base(world_geometry)
	var concept_photo_reconstruction := ConceptPhotoReconstruction011.new() as Node3D
	world_geometry.add_child(concept_photo_reconstruction)
	WorldPaths001.add_paths(world_geometry)

	var settlement_refs := WorldSettlementCore001.add_settlement_core(world_geometry)
	_smith_root = settlement_refs.get("smith_root") as Node3D
	_smith_use_anchor = settlement_refs.get("smith_use_anchor") as Node3D

	WorldGateProps001.add_gate_props(world_geometry)

	WorldTrailEnvironment001.add_trail_environment(world_geometry)

	var actor_refs := WorldActorPresentation001.add_actor_presentation(world_geometry)
	_npc_anchor = actor_refs.get("npc_anchor") as Node3D
	_monster_anchor = actor_refs.get("monster_anchor") as Node3D
	_monster_visual = actor_refs.get("monster_visual") as Node3D
	if _monster_anchor != null:
		_add_domain_monster_body_alias(_monster_anchor.position)

func _add_domain_monster_body_alias(position: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = DOMAIN_MONSTER_ID
	body.position = position
	body.collision_layer = 1
	body.collision_mask = 1
	world_geometry.add_child(body)
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	collision.position = Vector3(0.0, 1.0, 0.0)
	var shape := CapsuleShape3D.new()
	shape.radius = 0.9
	shape.height = 2.2
	collision.shape = shape
	body.add_child(collision)
	_domain_monster_body = body
