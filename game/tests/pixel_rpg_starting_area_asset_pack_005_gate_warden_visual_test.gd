extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const WARDEN_SCENE: PackedScene = preload("res://assets/characters/gate_warden_visual_01.tscn")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _contains_physics(node: Node) -> bool:
	if node is CollisionObject3D or node is CollisionShape3D:
		return true
	for child in node.get_children():
		if _contains_physics(child):
			return true
	return false

func _run() -> void:
	print("Pixel RPG Starting Area Asset Pack 005 Gate Warden visual runtime gate")

	var visual := WARDEN_SCENE.instantiate() as Node3D
	_check("Gate Warden reusable visual instantiates", visual != null)
	if visual != null:
		root.add_child(visual)
		_check("Gate Warden visual remains presentation-only", not _contains_physics(visual))
		_check("Gate Warden has readable body silhouette", visual.has_node("Torso") and visual.has_node("Head") and visual.has_node("ArmL") and visual.has_node("ArmR"))
		_check("Gate Warden has role-specific equipment", visual.has_node("SpearShaft") and visual.has_node("SpearHead") and visual.has_node("WardenMark"))
		_check("Gate Warden has bounded armor/readability details", visual.has_node("ShoulderL") and visual.has_node("ShoulderR") and visual.has_node("ChestGuard") and visual.has_node("BeltBadge"))
		visual.queue_free()

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with Gate Warden visual", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
	var hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	var warden := geometry.get_node_or_null("GateWarden") as Node3D if geometry != null else null
	var live_visual := warden.get_node_or_null("GateWardenVisual") as Node3D if warden != null else null
	var smith := geometry.get_node_or_null("WorldPack004EnterableSmith") as Node3D if geometry != null else null
	var monster := geometry.get_node_or_null("MonsterProxy") as Node3D if geometry != null else null

	_check("Gate Warden anchor remains exact", warden != null and warden.position.is_equal_approx(Vector3(-2.6, 0.0, -6.2)), str(warden.position) if warden != null else "missing")
	_check("live Gate Warden uses reusable visual", live_visual != null and live_visual.has_node("SpearShaft") and live_visual.has_node("WardenMark"))
	_check("live Gate Warden visual owns no physics", live_visual != null and not _contains_physics(live_visual))

	if hunter != null and warden != null:
		hunter.global_position = warden.global_position
		prototype.call("_update_contextual_action")
		var action_button := prototype.get_node_or_null("HUD/Touch/ActionButton") as Button
		var prompt := prototype.get_node_or_null("HUD/InteractionPrompt") as Label
		_check("Gate Warden TALK action remains reachable", action_button != null and action_button.visible and action_button.text == "TALK", action_button.text if action_button != null else "missing")
		_check("Gate Warden prompt identity remains unchanged", prompt != null and "Gate Warden" in prompt.text, prompt.text if prompt != null else "missing")
		prototype.call("_on_action_button_pressed")
		var objective := prototype.get_node_or_null("HUD/ObjectivePanel/Objective") as Label
		_check("Gate Warden TALK result remains bounded field-note behavior", objective != null and "tracks crossed the north gate" in objective.text, objective.text if objective != null else "missing")

	_check("first-person camera remains current", camera != null and camera.current)
	_check("smith contract remains present", smith != null and smith.has_node("UseAnchor") and smith.has_node("Collision"))
	_check("Mudcrest anchor remains exact", monster != null and monster.position.is_equal_approx(Vector3(0.0, 0.0, -49.0)))

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_005_GATE_WARDEN_VISUAL_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STARTING_AREA_ASSET_PACK_005_GATE_WARDEN_VISUAL_FAILED")
	print("This gate proves reusable presentation-only Gate Warden art plus exact anchor/TALK behavior, first-person, smith and Mudcrest preservation. Device visual/performance acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
