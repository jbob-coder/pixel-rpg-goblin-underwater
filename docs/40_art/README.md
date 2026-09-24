# 40_art — Art, Models and Presentation References

Purpose: visual language, asset-production standards, runtime 2D rules, reference packages and 3D conversion workflows.

Belongs here:
- model/art direction;
- reference-image requirements;
- hunter/NPC/monster model sheets;
- building/environment visual sheets;
- materials and palette guides;
- animation/telegraph presentation guides;
- VFX/audio presentation references;
- UI/bestiary/map-art references;
- asset provenance/reference metadata;
- raster resolution/zoom-quality rules;
- runtime 2D asset preparation;
- image-to-3D conversion/orchestration guides.

## Current asset-pipeline package

`asset_pipeline/`
- `README.md` — asset classes and Drive storage map;
- `RASTER_RESOLUTION_AND_ZOOM_QUALITY.md` — high-resolution master, zoom, derivative, vector/SDF and upscaling policy;
- `RUNTIME_2D_ASSET_GUIDE.md` — which generated images may become actual game assets and their approval gates;
- `PNG_TO_3D_AUTOMATION_PIPELINE.md` — reconstruction → Blender → anatomy/sever → rig → animation → LOD → device pipeline;
- `GENERATED_SHEET_REGISTRY.md` — planned/generated sheet IDs and destinations.

## Current root authorities

- `/MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`;
- `/MODEL_REFERENCE_IMAGE_AND_CREATION_PIPELINE.md`;
- `/VISUAL_WORLD_BEHAVIOR_BIBLE.md`;
- `/GAME_EXPERIENCE_BIBLE.md`.

## Core rule

Generated PNGs are visual intent unless separately technically verified. Never treat generated image text, UV-looking art, normal/ORM-looking art, hit regions, scale or collision as production truth by appearance alone.

A generated image can be classified separately as:
- modeling reference;
- 3D conversion input candidate;
- runtime 2D candidate;
- discussion-only concept.

Those classifications are not interchangeable.

Region-specific visual requirements live in the region package, shared production standards live here/root authority, and entity-specific visual/body requirements live in the matching content package.
