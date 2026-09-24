extends SceneTree

const Manifest := preload("res://assets/textures/concept_derived/image_derived_asset_manifest.gd")
const GATE: PackedScene = preload("res://assets/environment/starting_area/settlement_gate_01.tscn")
const SMITH_FORGE: PackedScene = preload("res://assets/environment/starting_area/smith_forge_detail_01.tscn")
const STREET: PackedScene = preload("res://assets/environment/starting_area/street_surface_details_01.tscn")
const PINE: PackedScene = preload("res://assets/environment/starting_area/trail_pine_01.tscn")
const ROCK: PackedScene = preload("res://assets/environment/starting_area/trail_rock_visual_01.tscn")
const LANTERN: PackedScene = preload("res://assets/environment/starting_area/lantern_post_01.tscn")
const PROTOTYPE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")
var failures: Array[String] = []
var checks := 0
func _init() -> void: call_deferred("_run")
func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition: failures.append(label)
func _texture_path(scene: PackedScene, node_path: NodePath) -> String:
	var instance := scene.instantiate() as Node3D
	if instance == null: return ""
	root.add_child(instance)
	var mesh := instance.get_node_or_null(node_path) as MeshInstance3D
	var result := ""
	if mesh != null and mesh.material_override is StandardMaterial3D:
		var mat := mesh.material_override as StandardMaterial3D
		if mat.albedo_texture != null: result = mat.albedo_texture.resource_path
	instance.queue_free()
	return result
func _run() -> void:
	print("Pixel RPG Visual Pack 010 concept-image-derived texture gate")
	_check("manifest schema", Manifest.SCHEMA == "pixel_rpg.image_derived_asset_pack_010.v1")
	_check("exact generated concept SHA", Manifest.SOURCE_SHA256 == "766e16c7992699553842c7205eeef060a483e7c758f1ed3c3193c63ba0373b2b")
	_check("exact concept dimensions", Manifest.SOURCE_DIMENSIONS == Vector2i(1672, 941))
	_check("seven sampled categories", Manifest.TEXTURES.size() == 7)
	for key in Manifest.TEXTURES:
		var p := String(Manifest.TEXTURES[key]["path"])
		var t := load(p) as Texture2D
		_check("loads " + String(key), t != null, p)
		if t != null: _check("64x64 " + String(key), t.get_width() == 64 and t.get_height() == 64, "%dx%d" % [t.get_width(), t.get_height()])
	_check("gate wood derived", _texture_path(GATE, "LeftTower").ends_with("concept_wood_beam_01.svg"))
	_check("gate stone derived", _texture_path(GATE, "StoneFootingLeft").ends_with("concept_stone_block_01.svg"))
	_check("gate roof derived", _texture_path(GATE, "LeftCap").ends_with("concept_roof_shingle_01.svg"))
	_check("gate banner derived", _texture_path(GATE, "GateBanner").ends_with("concept_banner_red_01.svg"))
	_check("smith stone derived", _texture_path(SMITH_FORGE, "ForgeBackplate").ends_with("concept_stone_block_01.svg"))
	_check("smith metal derived", _texture_path(SMITH_FORGE, "ToolBar").ends_with("concept_metal_dark_01.svg"))
	_check("street dirt derived", _texture_path(STREET, "RutLeftA").ends_with("concept_packed_dirt_01.svg"))
	_check("pine foliage derived", _texture_path(PINE, "CrownLower").ends_with("concept_foliage_01.svg"))
	_check("rock stone derived", _texture_path(ROCK, ".").ends_with("concept_stone_block_01.svg"))
	_check("lantern wood derived", _texture_path(LANTERN, "Pole").ends_with("concept_wood_beam_01.svg"))
	_check("lantern metal derived", _texture_path(LANTERN, "Frame").ends_with("concept_metal_dark_01.svg"))
	var prototype := PROTOTYPE.instantiate()
	_check("prototype instantiates", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		await process_frame
		await physics_frame
		var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
		var hunter_visual := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/Visual") as Node3D
		_check("first-person current", camera != null and camera.current)
		_check("third-person body hidden", hunter_visual != null and not hunter_visual.visible)
		prototype.queue_free()
		await process_frame
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	print("Gate: " + ("PIXEL_RPG_VISUAL_PACK_010_IMAGE_DERIVED_ASSETS_VERIFIED" if failures.is_empty() else "PIXEL_RPG_VISUAL_PACK_010_IMAGE_DERIVED_ASSETS_FAILED"))
	quit(0 if failures.is_empty() else 1)
