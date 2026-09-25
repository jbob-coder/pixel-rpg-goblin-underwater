# 40_art — Art, Models and Presentation References

Status: ACTIVE ART MAP / CURRENT RUNTIME IMAGE-DERIVED ASSETS + HISTORICAL MODEL PIPELINE  
Last reconciled: 2026-09-25

## Purpose

Own art/reference/asset-lineage documentation without taking gameplay/collision/state authority.

## Current runtime-art lineage

Current Pixel RPG source includes verified image-derived presentation.

### Pack 010

Concept-derived material textures:

`game/assets/textures/concept_derived/`

Manifest:

`game/assets/textures/concept_derived/image_derived_asset_manifest.gd`

### Pack 011

Direct concept-photo PNG assets:

`game/assets/environment/starting_area/concept_photo_sprites_011/`

Runtime data/loader:

- `game/assets/environment/starting_area/concept_photo_sprite_data_011.gd`;
- `game/scripts/presentation/pixel_rpg/concept_photo_reconstruction_011.gd`.

### Canonical first-person hands

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`

Live ViewModel:

`game/assets/characters/first_person_viewmodel_01.tscn`

## Historical asset-pipeline package

`asset_pipeline/`

contains valuable lineage, QA, source/master/derivative, raster, image-to-3D, and reference rules.

Older status text such as:

- `NO ENGINE IMPORT YET`;
- `APPROVED_RUNTIME_2D = NONE`

is historical and does not describe the complete current Pixel RPG runtime asset inventory.

## Reviews

`reviews/`

records per-asset QA decisions.

A review may authorize a specific use level; it does not become gameplay authority.

## Core law

Generated/reference images are visual intent unless separately technically verified.

Do not infer from imagery alone:

- exact scale;
- collision;
- UVs;
- hidden geometry;
- hit zones;
- anatomy thresholds;
- final text/canon.

## Current visual authority

Player-facing style/camera authority:

`/PIXEL_RPG_VISUAL_DIRECTION.md`

Historical aerial/third-person/model-art documents remain provenance only where their presentation conflicts with current first-person Pixel RPG.

## Presentation boundary

Art may replace visible presentation.

Gameplay collision/state may remain separate invisible support.

Never make visual assets authoritative for combat, targeting truth, persistence, or durable state.
