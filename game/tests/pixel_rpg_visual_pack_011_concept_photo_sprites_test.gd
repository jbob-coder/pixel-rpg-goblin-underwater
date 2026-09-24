extends SceneTree

const SPRITE_DATA := preload("res://assets/environment/starting_area/concept_photo_sprite_data_011.gd")
const RECONSTRUCTION := preload("res://scripts/presentation/pixel_rpg/concept_photo_reconstruction_011.gd")
const PROTOTYPE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")

const NODE_TO_SPRITE_ID := {
	"GateBannerLeftPhoto": "gate_left",
	"GateBannerRightPhoto": "gate_right",
	"SmithBannerPhoto": "smith_banner",
	"SmithForgePhoto": "forge",
	"SignpostPhoto": "signpost",
	"WaterTroughPhoto": "water_trough",
	"FencePhoto": "fence",
}

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

func _file_sha256(path: String) -> String:
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.is_empty():
		return ""
	var context := HashingContext.new()
	if context.start(HashingContext.HASH_SHA256) != OK:
		return ""
	if context.update(bytes) != OK:
		return ""
	return context.finish().hex_encode()

func _check_direct_png(sprite_id: String) -> void:
	var record: Dictionary = SPRITE_DATA.SPRITES[sprite_id]
	var path := String(record["path"])
	var expected_size: Vector2i = record["size"]
	var expected_sha := String(record["sha256"])
	_check("direct PNG exists " + sprite_id, FileAccess.file_exists(path), path)
	var texture := SPRITE_DATA.load_texture(sprite_id)
	_check("direct PNG loads " + sprite_id, texture != null, path)
	if texture != null:
		_check("resource path is direct PNG " + sprite_id, texture.resource_path == path, texture.resource_path)
		_check("PNG dimensions " + sprite_id, texture.get_width() == expected_size.x and texture.get_height() == expected_size.y, "%dx%d" % [texture.get_width(), texture.get_height()])
	var actual_sha := _file_sha256(path)
	_check("PNG byte SHA " + sprite_id, actual_sha == expected_sha, actual_sha)

func _run() -> void:
	print("Pixel RPG Visual Pack 011 direct concept-photo PNG asset gate")
	_check("sprite-data schema", SPRITE_DATA.SCHEMA == "pixel_rpg.concept_photo_sprite_data_011.v2")
	_check("reconstruction schema", RECONSTRUCTION.SCHEMA == "pixel_rpg.concept_photo_reconstruction_011.v2")
	_check("exact concept source SHA", SPRITE_DATA.SOURCE_SHA256 == "766e16c7992699553842c7205eeef060a483e7c758f1ed3c3193c63ba0373b2b")
	_check("exact concept dimensions", SPRITE_DATA.SOURCE_DIMENSIONS == Vector2i(1672, 941))
	_check("seven standalone concept-photo PNG assets", SPRITE_DATA.SPRITES.size() == 7)

	for sprite_id in SPRITE_DATA.SPRITES:
		_check_direct_png(String(sprite_id))

	var overlay := RECONSTRUCTION.new() as Node3D
	root.add_child(overlay)
	await process_frame
	_check("overlay root identity", overlay.name == "ConceptPhotoReconstruction011", overlay.name)
	_check("overlay remains presentation-only", not _contains_physics(overlay))
	for node_name in NODE_TO_SPRITE_ID:
		var sprite := overlay.get_node_or_null(NodePath(node_name)) as Sprite3D
		var sprite_id := String(NODE_TO_SPRITE_ID[node_name])
		var expected_path := SPRITE_DATA.texture_path(sprite_id)
		_check("overlay contains " + node_name, sprite != null)
		if sprite != null:
			_check("overlay loads direct PNG " + node_name, sprite.texture != null and sprite.texture.resource_path == expected_path, sprite.texture.resource_path if sprite.texture != null else "null")
			_check("nearest filtering " + node_name, sprite.texture_filter == BaseMaterial3D.TEXTURE_FILTER_NEAREST)
	overlay.queue_free()

	var prototype := PROTOTYPE.instantiate()
	_check("prototype instantiates with direct PNG Pack 011", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		await process_frame
		await physics_frame
		var live_overlay := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/ConceptPhotoReconstruction011") as Node3D
		var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
		var hunter_visual := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/Visual") as Node3D
		_check("live game contains direct-photo overlay", live_overlay != null)
		if live_overlay != null:
			_check("live overlay stays presentation-only", not _contains_physics(live_overlay))
			for node_name in NODE_TO_SPRITE_ID:
				var live_sprite := live_overlay.get_node_or_null(NodePath(node_name)) as Sprite3D
				var sprite_id := String(NODE_TO_SPRITE_ID[node_name])
				var expected_path := SPRITE_DATA.texture_path(sprite_id)
				_check("live direct PNG " + node_name, live_sprite != null and live_sprite.texture != null and live_sprite.texture.resource_path == expected_path, live_sprite.texture.resource_path if live_sprite != null and live_sprite.texture != null else "missing")
		_check("first-person camera remains current", camera != null and camera.current)
		_check("third-person Hunter remains hidden", hunter_visual != null and not hunter_visual.visible)
		prototype.queue_free()
		await process_frame

	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	print("Gate: " + ("PIXEL_RPG_VISUAL_PACK_011_CONCEPT_PHOTO_SPRITES_VERIFIED" if failures.is_empty() else "PIXEL_RPG_VISUAL_PACK_011_CONCEPT_PHOTO_SPRITES_FAILED"))
	quit(0 if failures.is_empty() else 1)
