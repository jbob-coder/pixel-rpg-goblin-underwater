class_name PixelRPGConceptPhotoSpriteData011
extends RefCounted

const SCHEMA := "pixel_rpg.concept_photo_sprite_data_011.v2"
const SOURCE_FILENAME := "voxel_fantasy_village_gate.png"
const SOURCE_SHA256 := "766e16c7992699553842c7205eeef060a483e7c758f1ed3c3193c63ba0373b2b"
const SOURCE_DIMENSIONS := Vector2i(1672, 941)
const DERIVATION := "Standalone RGBA PNG game assets exported from exact source-image crop pixels, nearest-downsampled/palette-quantized and hard-masked. Runtime loads these files directly; no in-memory synthetic reconstruction."

const SPRITES := {
	"gate_left": {
		"path": "res://assets/environment/starting_area/concept_photo_sprites_011/concept_gate_banner_left.png",
		"source_crop": Rect2i(900, 270, 115, 200),
		"size": Vector2i(24, 40),
		"role": "left gate banner",
		"sha256": "aa27f9ee80557e2ffc3b4b66f4fa01c9e951c7c012446701efa4115762cd92fd",
	},
	"gate_right": {
		"path": "res://assets/environment/starting_area/concept_photo_sprites_011/concept_gate_banner_right.png",
		"source_crop": Rect2i(1090, 255, 120, 205),
		"size": Vector2i(24, 41),
		"role": "right gate banner",
		"sha256": "4e3cceca5b80b7ba9adb0ebc95e98911e5a8c05b4fc0d15ecd4a98dbbac8c8d5",
	},
	"smith_banner": {
		"path": "res://assets/environment/starting_area/concept_photo_sprites_011/concept_smith_banner.png",
		"source_crop": Rect2i(500, 210, 165, 180),
		"size": Vector2i(32, 36),
		"role": "smith hanging banner",
		"sha256": "26381950b3fbdfd0e990b89413f6908f5d5bdf9020f3e71a8f9492d051ac09e5",
	},
	"signpost": {
		"path": "res://assets/environment/starting_area/concept_photo_sprites_011/concept_signpost.png",
		"source_crop": Rect2i(1290, 410, 215, 230),
		"size": Vector2i(40, 44),
		"role": "direction signpost",
		"sha256": "8c3869de36cfe3497fdf03baef3835f23f582e5b2c7b33d2924add0404365ff5",
	},
	"water_trough": {
		"path": "res://assets/environment/starting_area/concept_photo_sprites_011/concept_water_trough.png",
		"source_crop": Rect2i(1340, 600, 330, 305),
		"size": Vector2i(48, 44),
		"role": "water trough assembly",
		"sha256": "334cecb58f64db411dc140d169da0b24fb10d8bd09e35fc2e7a7616e394b3aab",
	},
	"fence": {
		"path": "res://assets/environment/starting_area/concept_photo_sprites_011/concept_fence_segment.png",
		"source_crop": Rect2i(1160, 535, 345, 290),
		"size": Vector2i(56, 48),
		"role": "fence segment",
		"sha256": "ee99df39405c8039bfd9ce8c988b6e0106c125c86bac75b6d54f4e7907983d2c",
	},
	"forge": {
		"path": "res://assets/environment/starting_area/concept_photo_sprites_011/concept_forge_panel.png",
		"source_crop": Rect2i(345, 405, 300, 265),
		"size": Vector2i(56, 48),
		"role": "smith forge interior panel",
		"sha256": "229563418e15e93c6b08bf0a0a878bbeafa91b1596815823efd0801e90b4d324",
	},
}

static func load_texture(sprite_id: String) -> Texture2D:
	if not SPRITES.has(sprite_id):
		return null
	return load(String(SPRITES[sprite_id]["path"])) as Texture2D

static func texture_path(sprite_id: String) -> String:
	if not SPRITES.has(sprite_id):
		return ""
	return String(SPRITES[sprite_id]["path"])
