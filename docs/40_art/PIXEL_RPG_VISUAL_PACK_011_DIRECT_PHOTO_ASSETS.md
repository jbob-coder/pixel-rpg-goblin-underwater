# Pixel RPG — Visual Pack 011 — Direct Concept-Photo PNG Assets

Status: BUILD-VERIFIED / DEVICE VISUAL ACCEPTANCE PENDING
Build source: `93978e1947fe8cffaeb0876574d8d761dcad90b2`
Workflow run: `35947488962`
Job: `107468585038`
Version: `0.19-visual-pack-011-direct-photo-assets`

## Authority

The generated starting-area concept `voxel_fantasy_village_gate.png` is an actual runtime-art source, not merely a palette/reference source.

Source identity:
- dimensions: 1672 × 941;
- SHA-256: `766e16c7992699553842c7205eeef060a483e7c758f1ed3c3193c63ba0373b2b`.

Pack 011 direct assets live under:
`game/assets/environment/starting_area/concept_photo_sprites_011/`

Files:
- `concept_gate_banner_left.png` — SHA-256 `aa27f9ee80557e2ffc3b4b66f4fa01c9e951c7c012446701efa4115762cd92fd`;
- `concept_gate_banner_right.png` — SHA-256 `4e3cceca5b80b7ba9adb0ebc95e98911e5a8c05b4fc0d15ecd4a98dbbac8c8d5`;
- `concept_smith_banner.png` — SHA-256 `26381950b3fbdfd0e990b89413f6908f5d5bdf9020f3e71a8f9492d051ac09e5`;
- `concept_signpost.png` — SHA-256 `8c3869de36cfe3497fdf03baef3835f23f582e5b2c7b33d2924add0404365ff5`;
- `concept_water_trough.png` — SHA-256 `334cecb58f64db411dc140d169da0b24fb10d8bd09e35fc2e7a7616e394b3aab`;
- `concept_fence_segment.png` — SHA-256 `ee99df39405c8039bfd9ce8c988b6e0106c125c86bac75b6d54f4e7907983d2c`;
- `concept_forge_panel.png` — SHA-256 `229563418e15e93c6b08bf0a0a878bbeafa91b1596815823efd0801e90b4d324`.

## Runtime contract

`concept_photo_sprite_data_011.gd` stores direct PNG resource paths and source/crop identity. It does not contain palette rows or reconstruct textures in memory.

`concept_photo_reconstruction_011.gd` loads the PNG files directly and applies them to presentation-only `Sprite3D` nodes under `WorldGeometry/ConceptPhotoReconstruction011`.

No Pack 011 PNG owns:
- physics or collision;
- input/camera authority;
- interactions;
- targeting/combat;
- save/persistence or durable world state.

Existing 3D geometry/collision remains gameplay authority while concept-derived art is progressively substituted.

## Verification

The Pack 011 CI gate verifies:
- seven standalone PNG files exist;
- exact source concept SHA/dimensions;
- each PNG imports with expected dimensions;
- each original PNG byte stream matches its recorded SHA-256;
- each runtime Sprite3D texture resource path points directly to the expected `.png`;
- nearest texture filtering;
- presentation-only ownership;
- live prototype integration;
- first-person camera remains current;
- third-person Hunter body remains hidden.

Full workflow, prior runtime/domain regression stack and Android export all passed.

APK:
- `PixelRPG-visual-pack-011-direct-photo-assets-debug.apk`;
- 58,290,596 bytes;
- SHA-256 `bec6ba206a293edab5ab6b5220090e444b110a3521f7f8a48c6e9b6cade40c7b`.

## Next bounded task

`PIXEL_RPG_VISUAL_PACK_012_CONCEPT_OBJECT_REPLACEMENT`:
expand direct concept-derived structural/frontage assets, beginning with gate structure and smith frontage, and remove duplicated procedural presentation only after parity is proven. Preserve gameplay geometry/collision until an explicit replacement proves equivalent behavior.

Physical-device visual acceptance remains NOT VERIFIED.
