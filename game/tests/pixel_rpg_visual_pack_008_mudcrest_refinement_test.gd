extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const MUDCREST_SCENE: PackedScene = preload("res://assets/monsters/mudcrest_visual.tscn")

const TARGET_ROOTS := [
	"HEAD",
	"HORN_CREST",
	"FORELEG_L",
	"FORELEG_R",
	"HINDLEG_L",
	"HINDLEG_R",
	"DORSAL_PLATES",
	"TAIL",
	"GENERAL_TORSO",
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

func _contains_physics(node: Node) -> bool:
	if node is CollisionObject3D or node is CollisionShape3D:
		return true
	for child in node.get_children():
		if _contains_physics(child):
			return true
	return false

func _run() -> void:
	print("Pixel RPG Visual Pack 008 Mudcrest refinement runtime gate")

	var mudcrest := MUDCREST_SCENE.instantiate() as Node3D
	_check("refined Mudcrest instantiates", mudcrest != null)
	if mudcrest != null:
		root.add_child(mudcrest)
		_check("Mudcrest visual remains presentation-only", not _contains_physics(mudcrest))
		for root_name in TARGET_ROOTS:
			var target := mudcrest.get_node_or_null(NodePath(root_name))
			_check("anatomy target root preserved " + root_name, target != null and target is Node3D)
			_check("anatomy target owns visible children " + root_name, target != null and target.get_child_count() > 0)

		_check("HEAD gains eyes jaw and tusks", mudcrest.has_node("HEAD/EyeL") and mudcrest.has_node("HEAD/EyeR") and mudcrest.has_node("HEAD/JawLower") and mudcrest.has_node("HEAD/TuskL") and mudcrest.has_node("HEAD/TuskR"))
		_check("HORN_CREST gains reinforced bases", mudcrest.has_node("HORN_CREST/CrestBaseL") and mudcrest.has_node("HORN_CREST/CrestBaseR"))
		_check("GENERAL_TORSO gains shoulder/mud breakup", mudcrest.has_node("GENERAL_TORSO/ShoulderPlateL") and mudcrest.has_node("GENERAL_TORSO/ShoulderPlateR") and mudcrest.has_node("GENERAL_TORSO/MudPatch"))
		_check("DORSAL_PLATES gains secondary plates", mudcrest.has_node("DORSAL_PLATES/PlateRear2") and mudcrest.has_node("DORSAL_PLATES/PlateFrontL") and mudcrest.has_node("DORSAL_PLATES/PlateFrontR"))
		for leg_name in ["FORELEG_L", "FORELEG_R", "HINDLEG_L", "HINDLEG_R"]:
			_check(leg_name + " gains two claw details", mudcrest.has_node(NodePath(leg_name + "/ClawOuter")) and mudcrest.has_node(NodePath(leg_name + "/ClawInner")))
		_check("TAIL gains spine/mud details", mudcrest.has_node("TAIL/TailSpineA") and mudcrest.has_node("TAIL/TailSpineB") and mudcrest.has_node("TAIL/TailMudBand"))
		mudcrest.queue_free()

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype instantiates with refined Mudcrest", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	var monster_anchor := geometry.get_node_or_null("MonsterProxy") as Node3D if geometry != null else null
	var live_visual := monster_anchor.get_node_or_null("MudcrestVisual") as Node3D if monster_anchor != null else null
	var domain_body := geometry.get_node_or_null("monster_r01_m01_0001") as StaticBody3D if geometry != null else null

	_check("MonsterProxy anchor remains exact", monster_anchor != null and monster_anchor.position.is_equal_approx(Vector3(0.0, 0.0, -49.0)), str(monster_anchor.position) if monster_anchor != null else "missing")
	_check("domain monster body remains co-located", domain_body != null and monster_anchor != null and domain_body.position.is_equal_approx(monster_anchor.position))
	_check("refined live visual exists", live_visual != null)
	if live_visual != null:
		for root_name in TARGET_ROOTS:
			_check("live anatomy root preserved " + root_name, live_visual.has_node(NodePath(root_name)))
		var highlight_ok := bool(prototype.call("_apply_target_highlight", "HEAD"))
		var eye_l := live_visual.get_node_or_null("HEAD/EyeL") as MeshInstance3D
		_check("HEAD highlight traverses into new eye detail", highlight_ok and eye_l != null and eye_l.material_overlay != null)
		prototype.call("_clear_target_highlight")
		_check("clearing target highlight clears new eye detail", eye_l != null and eye_l.material_overlay == null)

	_check("first-person camera remains current", camera != null and camera.current)

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_VISUAL_PACK_008_MUDCREST_REFINEMENT_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_VISUAL_PACK_008_MUDCREST_REFINEMENT_FAILED")
	print("This gate verifies presentation refinement only: anatomy target roots, recursive highlighting, world/domain anchors and first-person presentation remain authoritative. Device visual/performance acceptance remains open.")
	quit(0 if failures.is_empty() else 1)
