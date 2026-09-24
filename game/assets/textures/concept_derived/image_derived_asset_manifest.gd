class_name PixelRPGImageDerivedAssetManifest
extends RefCounted

const SCHEMA := "pixel_rpg.image_derived_asset_pack_010.v1"
const SOURCE_FILENAME := "voxel_fantasy_village_gate.png"
const SOURCE_SHA256 := "766e16c7992699553842c7205eeef060a483e7c758f1ed3c3193c63ba0373b2b"
const SOURCE_DIMENSIONS := Vector2i(1672, 941)
const DERIVATION := "Actual pixels sampled from the generated starting-area concept; 8x8 color grid encoded as 64x64 crisp SVG texture mosaics. No generative substitute."
const TEXTURES := {
	"wood": {"path": "res://assets/textures/concept_derived/concept_wood_beam_01.svg", "crop_xyxy": Rect2i(300, 320, 90, 120)},
	"stone": {"path": "res://assets/textures/concept_derived/concept_stone_block_01.svg", "crop_xyxy": Rect2i(900, 390, 70, 150)},
	"dirt": {"path": "res://assets/textures/concept_derived/concept_packed_dirt_01.svg", "crop_xyxy": Rect2i(760, 610, 220, 220)},
	"foliage": {"path": "res://assets/textures/concept_derived/concept_foliage_01.svg", "crop_xyxy": Rect2i(1300, 350, 160, 150)},
	"roof": {"path": "res://assets/textures/concept_derived/concept_roof_shingle_01.svg", "crop_xyxy": Rect2i(130, 155, 390, 105)},
	"banner": {"path": "res://assets/textures/concept_derived/concept_banner_red_01.svg", "crop_xyxy": Rect2i(950, 315, 65, 125)},
	"metal": {"path": "res://assets/textures/concept_derived/concept_metal_dark_01.svg", "crop_xyxy": Rect2i(470, 525, 115, 95)},
}
