class_name PixelRPGConceptPhotoReconstruction011
extends Node3D

const SpriteData := preload("res://assets/environment/starting_area/concept_photo_sprite_data_011.gd")

const SCHEMA := "pixel_rpg.concept_photo_reconstruction_011.v2"

func _ready() -> void:
	name = "ConceptPhotoReconstruction011"
	_add_sprite("GateBannerLeftPhoto", "gate_left", Vector3(-1.75, 3.45, -9.28), 0.0475)
	_add_sprite("GateBannerRightPhoto", "gate_right", Vector3(1.75, 3.45, -9.28), 0.0475)
	_add_sprite("SmithBannerPhoto", "smith_banner", Vector3(-4.08, 2.42, -3.78), 0.0375, 90.0)
	_add_sprite("SmithForgePhoto", "forge", Vector3(-9.28, 1.52, -3.40), 0.036, 90.0)
	_add_sprite("SignpostPhoto", "signpost", Vector3(2.9, 1.52, -12.82), 0.0375, -15.0)
	_add_sprite("WaterTroughPhoto", "water_trough", Vector3(7.9, 1.02, 9.15), 0.0375, -18.0)
	_add_sprite("FencePhoto", "fence", Vector3(4.0, 1.15, -18.82), 0.035, -12.0)

func _add_sprite(node_name: String, sprite_id: String, world_position: Vector3, pixel_size: float, yaw_deg := 0.0) -> Sprite3D:
	var texture := SpriteData.load_texture(sprite_id)
	if texture == null:
		push_error("Pixel RPG Pack 011 missing direct concept-photo PNG: " + SpriteData.texture_path(sprite_id))
		return null
	var sprite := Sprite3D.new()
	sprite.name = node_name
	sprite.position = world_position
	sprite.rotation_degrees.y = yaw_deg
	sprite.pixel_size = pixel_size
	sprite.texture = texture
	sprite.shaded = false
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	add_child(sprite)
	return sprite
