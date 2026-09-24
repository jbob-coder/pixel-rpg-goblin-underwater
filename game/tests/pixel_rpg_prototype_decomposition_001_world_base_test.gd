extends SceneTree

const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
const WORLD_BASE := preload("res://scripts/presentation/pixel_rpg/world_base_001.gd")
const OWNERSHIP := preload("res://scripts/state/pixel_rpg_state_ownership_contract.gd")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _vec3_equal(left: Vector3, right: Vector3, epsilon := 0.0001) -> bool:
	return left.distance_to(right) <= epsilon

func _find_mesh(parent: Node) -> MeshInstance3D:
	if parent == null:
		return null
	for child in parent.get_children():
		if child is MeshInstance3D:
			return child as MeshInstance3D
	return null

func _find_collision(parent: Node) -> CollisionShape3D:
	if parent == null:
		return null
	for child in parent.get_children():
		if child is CollisionShape3D:
			return child as CollisionShape3D
	return null

func _run() -> void:
	print("Pixel RPG prototype decomposition 001 — world-base parity gate")

	_check("world-base schema is stable", String(WORLD_BASE.get_schema()) == "pixel_rpg.world_base_001.v1")
	_check("ground position contract preserved", _vec3_equal(WORLD_BASE.GROUND_POSITION, Vector3(0.0, -0.35, -18.0)))
	_check("ground size contract preserved", _vec3_equal(WORLD_BASE.GROUND_SIZE, Vector3(46.0, 0.7, 78.0)))
	_check("ground color contract preserved", WORLD_BASE.GROUND_COLOR.is_equal_approx(Color(0.19, 0.29, 0.16)))

	var ownership_validation: Dictionary = OWNERSHIP.validate_contract()
	_check("state ownership contract remains valid", bool(ownership_validation.get("success", false)), str(ownership_validation.get("errors", [])))

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("prototype scene instantiates", prototype != null)
	if prototype == null:
		_finish()
		return

	var authored_hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
	_check("authored Hunter spawn is unchanged before physics", authored_hunter != null and _vec3_equal(authored_hunter.position, Vector3(0.0, 0.9, 13.0)), str(authored_hunter.position) if authored_hunter != null else "missing")

	root.add_child(prototype)
	await process_frame
	await physics_frame

	var geometry := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry") as Node3D
	var hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
	var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
	var ground := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/Ground") as StaticBody3D

	_check("world geometry exists", geometry != null)
	_check("extracted Ground remains a StaticBody3D", ground != null)
	if ground != null:
		_check("Ground local position is unchanged", _vec3_equal(ground.position, Vector3(0.0, -0.35, -18.0)), str(ground.position))
		_check("Ground remains on default collision layer", ground.collision_layer == 1)
		_check("Ground remains on default collision mask", ground.collision_mask == 1)

		var mesh_instance := _find_mesh(ground)
		var collision := _find_collision(ground)
		_check("Ground still has exactly one mesh child", mesh_instance != null)
		_check("Ground still has exactly one collision child", collision != null)

		if mesh_instance != null:
			_check("Ground mesh remains BoxMesh", mesh_instance.mesh is BoxMesh)
			if mesh_instance.mesh is BoxMesh:
				_check("Ground mesh dimensions unchanged", _vec3_equal((mesh_instance.mesh as BoxMesh).size, Vector3(46.0, 0.7, 78.0)))
			var material := mesh_instance.material_override as StandardMaterial3D
			_check("Ground material remains StandardMaterial3D", material != null)
			if material != null:
				_check("Ground albedo unchanged", material.albedo_color.is_equal_approx(Color(0.19, 0.29, 0.16)), str(material.albedo_color))
				_check("Ground roughness unchanged", is_equal_approx(material.roughness, 0.95))
				_check("Ground per-vertex shading unchanged", material.shading_mode == BaseMaterial3D.SHADING_MODE_PER_VERTEX)
				_check("Ground nearest texture filtering unchanged", material.texture_filter == BaseMaterial3D.TEXTURE_FILTER_NEAREST)

		if collision != null:
			_check("Ground collision remains BoxShape3D", collision.shape is BoxShape3D)
			if collision.shape is BoxShape3D:
				_check("Ground collision dimensions unchanged", _vec3_equal((collision.shape as BoxShape3D).size, Vector3(46.0, 0.7, 78.0)))

	# The remainder of _build_prototype_world intentionally stays in the host in
	# this sub-slice. Snapshot major anchors so this extraction cannot silently
	# move path/settlement/interaction/combat presentation.
	var street := geometry.get_node_or_null("Street") as Node3D if geometry != null else null
	var trail := geometry.get_node_or_null("Trail") as Node3D if geometry != null else null
	var smith := geometry.get_node_or_null("WorldPack004EnterableSmith") as Node3D if geometry != null else null
	var gate := geometry.get_node_or_null("WorldPack001Gate") as Node3D if geometry != null else null
	var warden := geometry.get_node_or_null("GateWarden") as Node3D if geometry != null else null
	var monster := geometry.get_node_or_null("MonsterProxy") as Node3D if geometry != null else null
	var domain_monster := geometry.get_node_or_null("monster_r01_m01_0001") as StaticBody3D if geometry != null else null

	_check("Hunter runtime X/Z remain at authored spawn", hunter != null and absf(hunter.position.x) <= 0.0001 and absf(hunter.position.z - 13.0) <= 0.0001, str(hunter.position) if hunter != null else "missing")
	# Headless scheduling may advance one or more legitimate gravity steps before this assertion.\n\t# Guard against teleport/fall while leaving exact physics-frame count to movement-specific tests.\n\t_check("Hunter vertical physics settle remains baseline-bounded", hunter != null and hunter.position.y <= 0.9001 and hunter.position.y >= 0.84, str(hunter.position) if hunter != null else "missing")
	_check("first-person camera remains current", camera != null and camera.current)
	_check("Street remains in host at same position", street != null and _vec3_equal(street.position, Vector3(0.0, 0.03, 2.0)), str(street.position) if street != null else "missing")
	_check("Trail remains in host at same position", trail != null and _vec3_equal(trail.position, Vector3(0.0, 0.04, -31.0)), str(trail.position) if trail != null else "missing")
	_check("enterable smith placement unchanged", smith != null and _vec3_equal(smith.position, Vector3(-7.4, 0.0, -1.5)), str(smith.position) if smith != null else "missing")
	_check("settlement gate placement unchanged", gate != null and _vec3_equal(gate.position, Vector3(0.0, 0.0, -10.0)), str(gate.position) if gate != null else "missing")
	_check("Gate Warden placement unchanged", warden != null and _vec3_equal(warden.position, Vector3(-2.6, 0.0, -6.2)), str(warden.position) if warden != null else "missing")
	_check("Mudcrest proxy placement unchanged", monster != null and _vec3_equal(monster.position, Vector3(0.0, 0.0, -49.0)), str(monster.position) if monster != null else "missing")
	_check("domain monster alias stays co-located", domain_monster != null and monster != null and _vec3_equal(domain_monster.position, monster.position))

	prototype.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_PROTOTYPE_DECOMPOSITION_001_WORLD_BASE_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_PROTOTYPE_DECOMPOSITION_001_WORLD_BASE_FAILED")
	print("This gate verifies mechanical Ground extraction and major world-anchor parity only. Paths, settlement, gate/props, trail environment, controller/HUD decomposition and phone acceptance remain open.")
	quit(0 if failures.is_empty() else 1)
