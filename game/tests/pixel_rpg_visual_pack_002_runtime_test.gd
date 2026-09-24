extends SceneTree

const HUNTER_SCENE: PackedScene = preload("res://assets/characters/hunter_visual.tscn")
const MUDCREST_SCENE: PackedScene = preload("res://assets/monsters/mudcrest_visual.tscn")
const REQUIRED_MUDCREST_TARGETS := [
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

func _run() -> void:
	print("Pixel RPG Visual Pack 002 runtime gate")

	var hunter := HUNTER_SCENE.instantiate() as Node3D
	_check("hunter visual instantiates as Node3D", hunter != null)
	if hunter != null:
		root.add_child(hunter)
		_check("hunter keeps readable torso/head anchors", hunter.has_node("Torso") and hunter.has_node("Head"))
		_check("hunter now has both visible arms", hunter.has_node("ArmL") and hunter.has_node("ArmR"))
		_check("hunter keeps poleblade silhouette", hunter.has_node("PolebladeShaft") and hunter.has_node("PolebladeHead") and hunter.has_node("PolebladeHook"))
		_check("hunter gains bounded field-equipment cues", hunter.has_node("Belt") and hunter.has_node("PouchL") and hunter.has_node("ToolRoll"))
		hunter.queue_free()

	var mudcrest := MUDCREST_SCENE.instantiate() as Node3D
	_check("Mudcrest visual instantiates as Node3D", mudcrest != null)
	if mudcrest != null:
		root.add_child(mudcrest)
		for target_variant in REQUIRED_MUDCREST_TARGETS:
			var target := String(target_variant)
			var target_node := mudcrest.get_node_or_null(NodePath(target))
			_check("Mudcrest visual exposes anatomy target " + target, target_node != null)
			if target_node != null:
				_check("anatomy target " + target + " owns visible geometry", target_node.get_child_count() > 0)
		mudcrest.queue_free()

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_VISUAL_PACK_002_RUNTIME_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_VISUAL_PACK_002_RUNTIME_FAILED")
	print("This gate verifies asset instantiation and anatomy-node mapping only; phone visual acceptance and performance remain open.")
	quit(0 if failures.is_empty() else 1)
