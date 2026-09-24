# Raster Resolution, Zoom Quality and Derivative Policy

Status: ACTIVE ART/TECHNICAL CONTRACT / ENGINE BUDGETS STILL OPEN
Last reconciled: 2026-09-02

## Problem

Raster images lose apparent quality when displayed above their native pixel density. Enlarging a 1024px image to behave like a true 4096px source does not create verified original detail.

The project must solve zoom/readability structurally instead of repeatedly sharpening already-small images.

## Core solution

Use four layers:

1. **High-resolution master source**
2. **Separate close-detail/crop references when needed**
3. **Task-specific runtime derivatives**
4. **Mip/LOD/vector/SDF strategies at runtime**

Do not expect one giant sheet to support unlimited zoom.

## Modeling/reference masters

Preferred working targets when source generation/tooling permits:
- turnaround/anatomy/model sheets: 4096px+ long side;
- hero concepts: 2048–4096px+;
- detail-critical anatomy/damage crops: separate 2048px+ close sheets;
- technical vector diagrams: SVG/PDF/vector source where possible, raster preview optional.

If a generator outputs a smaller source:
- preserve it unchanged as `SOURCE`;
- optionally create an `UPSCALED_REFERENCE` derivative;
- never relabel the upscaled file as a technically verified high-resolution source.

## Better than zooming: split the sheet

Instead of one crowded 4K sheet containing eight tiny panels, use:
- one overview sheet;
- one dedicated front/side/back sheet;
- separate anatomy close-up;
- separate damage-state close-up;
- separate materials/detail sheet.

This gives each important subject actual pixels rather than forcing extreme zoom.

## Upscaling policy

Allowed for visual/reference enhancement:
- local/open-source AI upscalers such as Upscayl/Real-ESRGAN;
- commercial restoration/upscaling tools after licensing/cost review;
- controlled bicubic/Lanczos resize for non-generative scaling.

AI upscaling is **not** trusted for:
- exact body-part boundaries;
- scale measurements;
- technical labels;
- UV maps;
- normal maps;
- roughness/metallic/ORM maps;
- hit masks;
- collision/navigation masks.

Reason: restoration models can hallucinate surface detail.

## Runtime 2D scaling

### UI icons and symbols
Prefer:
- vector/SVG source where engine/toolchain supports conversion;
- SDF/MSDF for scalable monochrome/icon/font-like shapes where appropriate;
- multiple raster sizes when vector is not appropriate.

Do not take a 64px icon and stretch it to 512px.

### Illustrations/bestiary art
Use a high-resolution master and export device/runtime derivatives.

If the UI supports user zoom:
- define a maximum zoom based on source resolution;
- optionally load a higher-resolution derivative only when zoomed;
- avoid holding maximum-resolution art in memory unnecessarily.

### Map symbols
Prefer vector or resolution-independent shape generation.

### Billboards/impostors
Generate from the verified 3D asset at controlled angles/resolutions. Do not treat a concept painting as a physically accurate impostor.

### Decals/VFX sprites
Author at the largest justified runtime size, then downsample. Test alpha edges and compression.

## Mipmaps

For textures/sprites that shrink significantly in 3D or variable-scale UI where supported:
- generate/enable mipmaps;
- verify alpha edges;
- inspect shimmering/aliasing;
- use anisotropic filtering only where appropriate and supported;
- do not disable mipmaps just to preserve artificial sharpness if the result shimmers badly.

Exact settings wait for engine selection.

## Texture-source rule

`REFERENCE RESOLUTION != RUNTIME TEXTURE RESOLUTION`.

A 4096px concept/modeling sheet does not authorize a 4K Android texture.

Runtime texture budgets will be measured on the selected phone/engine.

## Quality ladder

When zoom quality is poor:
1. verify the correct high-resolution source is being displayed;
2. check whether the panel should be its own image rather than a crop from a sheet;
3. use vector/SDF if the asset is geometric/iconographic;
4. regenerate/re-render the subject at larger native resolution;
5. use reference-only AI upscaling if regeneration is impossible;
6. sharpen only after proper scaling, lightly;
7. never invent technical geometry from an upscaled artifact.

## Naming

Examples:
- `HUNTER_H02_TURNAROUND_v001_SOURCE.png`
- `HUNTER_H02_TURNAROUND_v001_UPSCALE_X4_REFERENCE.png`
- `HUNTER_H02_FRONT_DETAIL_v001_SOURCE.png`
- `UI_ICON_TRACK_v003_MASTER.svg`
- `UI_ICON_TRACK_v003_128.png`
- `UI_ICON_TRACK_v003_64.png`

## Verification

For every runtime 2D asset, record:
- master dimensions;
- export dimensions;
- intended display size;
- maximum allowed zoom if relevant;
- compression format/settings later;
- mip/filter policy later;
- target-device visual result.

No asset is called `ZOOM_VERIFIED` until actually inspected at intended device scale.
