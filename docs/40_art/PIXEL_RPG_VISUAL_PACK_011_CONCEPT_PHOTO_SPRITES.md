# Pixel RPG Visual Pack 011 — Concept Photo Sprites

Status: BUILD-VERIFIED / DEVICE VISUAL ACCEPTANCE PENDING
Date: 2026-09-23
Branch: `pixel-rpg`

## Purpose

Correct the earlier asset pipeline so the generated starting-area concept is not merely an art-direction reference or color source. Pack 011 reconstructs concrete visible objects from exact pixels derived from the generated concept and renders them in the live Godot world.

## Source image

- `voxel_fantasy_village_gate.png`
- dimensions: `1672 × 941`
- SHA-256: `766e16c7992699553842c7205eeef060a483e7c758f1ed3c3193c63ba0373b2b`

## Runtime implementation

- `game/assets/environment/starting_area/concept_photo_sprite_data_011.gd` stores source crop identity, palettes and exact derived pixel rows.
- `game/scripts/presentation/pixel_rpg/concept_photo_reconstruction_011.gd` reconstructs ImageTextures and places seven `Sprite3D` presentation assets.
- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd` instantiates the reconstruction into the live starting-area `WorldGeometry`.
- `game/tests/pixel_rpg_visual_pack_011_concept_photo_sprites_test.gd` proves the exact source identity, seven generated textures, live scene placement, presentation-only ownership and first-person preservation.

Applied objects: two gate banners, smith banner, smith forge panel, signpost, water trough and fence segment.

## Ownership boundary

The new sprites are presentation only. Existing world geometry/collision remains authoritative. No sprite owns collision, interaction range, targeting, combat, input, camera, save data or persistent world state.

Pack 011 is a 2.5D concept-photo reconstruction. It does not claim that every concept object has become a full 3D mesh. Future work may replace additional procedural visible surfaces while retaining gameplay owners.

## Build evidence

## Latest verified checkpoint — Visual Pack 011 Concept Photo Sprites

- exact build source SHA: `444bae4da21c93fcaf975f93c6f09e29a65db3bf`;
- workflow run: `35941955332` — SUCCESS;
- job: `107451563407` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.18-visual-pack-011-concept-photo-sprites`;
- APK: `PixelRPG-visual-pack-011-concept-photo-sprites-debug.apk`;
- APK size: `58,276,380` bytes;
- APK SHA-256: `5a5b736801c076178df73aa40cf083e67a8b658d9bdba47968dc89df86fdbd7b`;
- APK artifact ID: `10785097119`;
- APK artifact digest: `6374b38aa78757a39626fffe47bc5f95756ede79e2aeba77286bd15723d5d76c`;
- build-evidence artifact ID: `10785690463`;
- build-evidence digest: `e452c016616ec53e8e3224bfcb5343c8cec9e3e6749befde3d14b60798d69c02`.

Concept source authority:
- generated image: `voxel_fantasy_village_gate.png`;
- dimensions: `1672 × 941`;
- SHA-256: `766e16c7992699553842c7205eeef060a483e7c758f1ed3c3193c63ba0373b2b`;
- Pack 010 sampled concept pixels into repeatable material textures only;
- Pack 011 is the first checkpoint that reconstructs and renders concrete pictured objects from the concept pixel data.

Applied live photo-derived objects:
- left gate banner;
- right gate banner;
- smith hanging banner;
- smith forge panel;
- direction signpost;
- water trough;
- fence segment.

Implementation boundary:
- the photo-derived objects are runtime-generated `Sprite3D` presentation assets using palette-indexed pixel data derived from exact source-image crops;
- they are instantiated under `WorldGeometry/ConceptPhotoReconstruction011`;
- they own no collision, input, interaction, targeting, combat, save state or durable world state;
- existing geometry/collision remains authoritative underneath so gameplay behavior is preserved;
- this is a 2.5D concept-object reconstruction, not a claim that every pictured object has already become a full 3D mesh.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35941955332_visual-pack-011-concept-photo-sprites/`
- folder ID: `1PqJNvEhIJkIlV23Y64MdWw_LwfEFGftK`;
- APK ID: `1j5ZzFk81tHO8E28w1V4lFZNlCZXks2h1`;
- BuildIdentity JSON ID: `1iBthD8jjScWp-jUEQZqBTmFEPE7R55_H`;
- BuildIdentity Markdown ID: `1CyEJl8YNhsC2a0BULQIPLZx7TpTDhW2M`;
- raw CI evidence ID: `1qZ9yHMwUrYfim1RH7AT9-glFYer9L0Q8`;
- device checklist ID: `1RZEHACTSrlKenha4ziRAaC2soPnXdqu9`.

Verification:
- Pack 011 exact concept-photo sprite gate PASS;
- all prior first-person, viewmodel, image-derived material, Mudcrest, HUD, smith, targeting/combat, State Ownership, world-base and Starting Area Pack gates PASS;
- deterministic combat/anatomy/status regressions PASS;
- Android export and package-size ceiling PASS.

Physical Android visual acceptance, sprite alignment/occlusion quality, touch feel, sustained FPS/heat and installed footprint remain NOT VERIFIED.


## Next bounded slice

`PIXEL_RPG_VISUAL_PACK_012_CONCEPT_OBJECT_REPLACEMENT`: expand concept-derived visible art and remove duplicated procedural presentation where safe, without changing world/collision/gameplay authority.
