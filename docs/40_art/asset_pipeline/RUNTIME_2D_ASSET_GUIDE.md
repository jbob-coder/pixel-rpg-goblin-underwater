# Runtime 2D Asset Guide

Status: ACTIVE CLASSIFICATION/QUALITY CONTRACT / ENGINE-SPECIFIC IMPORT SETTINGS OPEN
Last reconciled: 2026-09-02

## Purpose

Define which PNG/image outputs may become actual game assets, how they differ from modeling references, and how they are processed before entering `04_Approved_Exports/2D_Runtime`.

## Runtime-eligible categories

### UI icons
Good candidates when:
- silhouette remains legible at phone size;
- no fine painterly detail is required;
- source can be reconstructed/vectorized where appropriate;
- alpha/edge quality is clean.

Preferred source:
- SVG/vector for geometric icons where practical;
- high-resolution transparent PNG for painterly/iconographic assets that do not vectorize well.

### Bestiary/field-guide illustrations
Can directly use illustrated PNG art when deliberately selected.

Requirements:
- separate high-res master;
- controlled crop/aspect ratio;
- zoom limit or higher-resolution derivative policy;
- no generated technical labels embedded in final art unless manually corrected.

### Portraits
Potentially direct runtime assets if the UI adopts portraits.

Requirements:
- consistent lighting/palette/background treatment;
- crop-safe framing;
- face/gear continuity with 3D character where the same person exists in 3D.

### Contract illustrations
May use stylized 2D art, but must not reveal hidden anatomy/monster facts the player has not learned unless intentionally designed as inaccurate folklore/art.

### Map symbols
Prefer vector or deterministic redraw rather than raw AI-generated text/icon sheets.

### Decals
Possible direct-use categories:
- blood/wound presentation decals;
- mud/water splash masks;
- scratches/track overlays;
- environmental stains.

Generated images require cleanup, seamless/alpha checks, and physical plausibility review.

### VFX sprites
Possible for smoke, sparks, dust, elemental wisps, impact cards, etc. Runtime atlas/pooling/performance rules apply.

### Billboards/impostors
Preferred source is a render of the verified 3D model/environment asset, not concept art. This preserves silhouette and state consistency.

## Not directly runtime-valid

Do not ship a generated image merely because it visually resembles:
- normal map;
- roughness map;
- metallic map;
- ambient occlusion map;
- UV layout;
- collision/hit mask;
- navigation mask;
- shadow map;
- baked lightmap;
- exact depth map.

These are technical outputs and require deterministic generation/validation.

## Runtime asset state machine

`SOURCE`
→ `CLEANED`
→ `TECHNICALLY_PREPARED`
→ `ENGINE_IMPORTED`
→ `DEVICE_VISUAL_CHECK`
→ `PERFORMANCE_CHECK`
→ `APPROVED_RUNTIME`

Do not jump directly from `GENERATED` to `APPROVED_RUNTIME`.

## Cleanup checklist

For transparent PNGs:
- remove unwanted background halos;
- inspect premultiplied/straight alpha behavior later in engine;
- ensure no accidental checkerboard/background is baked in;
- inspect 1px edge contamination;
- keep padding around sprite where atlasing requires it.

For illustrations:
- crop without cutting important silhouette;
- remove/replace incorrect generated text;
- inspect hands/equipment/monster anatomy for contradictions;
- verify no impossible duplicate anatomy;
- preserve approved visual design.

## Multi-resolution strategy

Keep one master and produce derivatives.

Example:
`BESTIARY_M01_MASTER_4096.png`
→ `BESTIARY_M01_2048.png`
→ `BESTIARY_M01_1024.png`
→ `BESTIARY_M01_THUMB_256.png`

Do not repeatedly resize a smaller derivative to make the next derivative.

Always derive from the master.

## Zoomable content

For zoomable bestiary/map art:
- cap zoom to meaningful source pixel density;
- load larger derivative on demand if engine/UI supports it;
- use tiled/vector map layers when large continuous maps require deep zoom;
- do not keep massive full-resolution files resident unnecessarily on Android.

## Relationship to modeling references

A single generated hero illustration may be:
- accepted as `MODEL_REFERENCE`, and
- separately cleaned/cropped into a `BESTIARY_ILLUSTRATION`.

Those are two distinct derivatives with distinct metadata/status.

The bestiary version cannot silently become the 3D conversion input if its pose/background/perspective are unsuitable.

## Metadata minimum

Each selected runtime 2D asset should eventually record:
- asset ID;
- source reference ID/version;
- intended UI/world use;
- dimensions;
- alpha yes/no;
- color-space expectation later;
- zoomable yes/no;
- max intended display/zoom;
- engine import status;
- Android visual/performance gate;
- attribution/license/provenance where relevant.

## Current project storage

Source work:
`02_2D_Runtime_Assets/`

Approved runtime output:
`04_Approved_Exports/2D_Runtime/`

Nothing reaches the approved folder only because it looks good in a chat preview.
