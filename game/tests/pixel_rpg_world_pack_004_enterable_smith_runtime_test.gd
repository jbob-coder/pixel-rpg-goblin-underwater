extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const SMITH_PACK := preload("res://scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _shape_size(body: StaticBody3D) -> Vector3:
	if body == null:
		return Vector3.ZERO
	var collision := body.get_node_or_null("Shape") as CollisionShape3D
	if collision == null or not (collision.shape is BoxShape3D):
		return Vector3.ZERO
	return (collision.shape as BoxShape3D).size

func _run() -> void:
	print("Pixel RPG World Pack 004 enterable smith runtime gate")

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype scene instantiates", prototype != null)
	if prototype == null:
		_finish()
		return

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var world := prototype.get_node_or_null("WorldDisplay/WorldViewport/World") as Node3D
	var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
	var hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
	var hunter_collision := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CollisionShape3D") as CollisionShape3D
	var smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D

	_check("world and hunter runtime nodes exist", world != null and geometry != null and hunter != null)
	_check("Pack 004 enterable smith replaces Pack 001 smith", smith != null and geometry.get_node_or_null("WorldPack001Smith") == null)
	_check("old monolithic SmithCollision is absent", geometry.get_node_or_null("SmithCollision") == null)

	if smith != null:
		var entrance := smith.get_node_or_null("EntranceAnchor") as Node3D
		var use_anchor := smith.get_node_or_null("UseAnchor") as Node3D
		_check("smith exposes entrance and use anchors", entrance != null and use_anchor != null)
		_check("smith has readable interior floor and station geometry",
			smith.has_node("InteriorFloor")
			and smith.has_node("ForgeHearth")
			and smith.has_node("AnvilTop")
			and smith.has_node("SmithBench")
		)
		_check("smith roof is split for interior camera handling", smith.has_node("RoofA") and smith.has_node("RoofB") and smith.has_node("RidgeBeam"))

		var collision_root := smith.get_node_or_null("Collision") as Node3D
		var front_left := smith.get_node_or_null("Collision/FrontLeftCollision") as StaticBody3D
		var front_right := smith.get_node_or_null("Collision/FrontRightCollision") as StaticBody3D
		var front_lintel := smith.get_node_or_null("Collision/FrontLintelCollision") as StaticBody3D
		_check("wall-aligned collision root exists", collision_root != null)
		_check("front collision is segmented around doorway", front_left != null and front_right != null and front_lintel != null)

		if front_left != null and front_right != null and front_lintel != null:
			var left_size := _shape_size(front_left)
			var right_size := _shape_size(front_right)
			var lintel_size := _shape_size(front_lintel)
			var left_inner := front_left.position.x + left_size.x * 0.5
			var right_inner := front_right.position.x - right_size.x * 0.5
			var doorway_gap := right_inner - left_inner
			var lintel_bottom := front_lintel.position.y - lintel_size.y * 0.5
			var hunter_radius := 0.0
			if hunter_collision != null and hunter_collision.shape is CapsuleShape3D:
				hunter_radius = (hunter_collision.shape as CapsuleShape3D).radius
			_check("doorway clear width matches 1.8 m contract", absf(doorway_gap - SMITH_PACK.DOOR_WIDTH_M) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("doorway comfortably clears hunter diameter", doorway_gap > hunter_radius * 2.0 + 0.5, "gap=%.3f hunter_diameter=%.3f" % [doorway_gap, hunter_radius * 2.0])
			_check("doorway lintel clears 2.4 m contract", lintel_bottom >= SMITH_PACK.DOOR_HEIGHT_M - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

		if world != null and hunter != null:
			var space_state := world.get_world_3d().direct_space_state
			var door_query := PhysicsRayQueryParameters3D.create(
				smith.to_global(Vector3(0.0, 0.9, 4.2)),
				smith.to_global(Vector3(0.0, 0.9, 2.0))
			)
			door_query.collision_mask = 1
			door_query.exclude = [hunter.get_rid()]
			var door_hit := space_state.intersect_ray(door_query)
			_check("physics ray passes through real doorway", door_hit.is_empty(), str(door_hit))

			var wall_query := PhysicsRayQueryParameters3D.create(
				smith.to_global(Vector3(2.0, 0.9, 4.2)),
				smith.to_global(Vector3(2.0, 0.9, 2.0))
			)
			wall_query.collision_mask = 1
			wall_query.exclude = [hunter.get_rid()]
			var wall_hit := space_state.intersect_ray(wall_query)
			_check("adjacent front wall still blocks physics", not wall_hit.is_empty(), str(wall_hit))

		if hunter != null:
			hunter.global_position = smith.to_global(Vector3(0.0, 0.9, 0.0))
			prototype.call("_update_smith_interior_visibility")
			var roof_a := smith.get_node_or_null("RoofA") as GeometryInstance3D
			var roof_b := smith.get_node_or_null("RoofB") as GeometryInstance3D
			_check("roof hides while hunter is inside", roof_a != null and roof_b != null and not roof_a.visible and not roof_b.visible)

			hunter.global_position = smith.to_global(Vector3(0.0, 0.9, 5.0))
			prototype.call("_update_smith_interior_visibility")
			_check("roof restores when hunter exits", roof_a != null and roof_b != null and roof_a.visible and roof_b.visible)

			if use_anchor != null:
				hunter.global_position = use_anchor.global_position
				prototype.call("_update_contextual_action")
				var action_button := prototype.get_node_or_null("HUD/Touch/ActionButton") as Button
				var prompt := prototype.get_node_or_null("HUD/InteractionPrompt") as Label
				_check("smith station exposes bounded USE interaction", action_button != null and action_button.visible and action_button.text == "USE")
				_check("smith interaction prompt names station", prompt != null and "Smithing station" in prompt.text, prompt.text if prompt != null else "")
				prototype.call("_on_action_button_pressed")
				var objective := prototype.get_node_or_null("HUD/ObjectivePanel/Objective") as Label
				_check("smith USE remains bounded and does not claim full crafting", objective != null and "Full crafting remains outside" in objective.text, objective.text if objective != null else "")

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_WORLD_PACK_004_ENTERABLE_SMITH_RUNTIME_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_WORLD_PACK_004_ENTERABLE_SMITH_RUNTIME_FAILED")
	print("This gate verifies the first exterior-doorway-interior building pattern; full crafting, phone acceptance and sustained performance remain open.")
	quit(0 if failures.is_empty() else 1)
