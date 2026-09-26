# Area 10 — Storage / Workshop Yard

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL_SHEET_READY / FINAL REFERENCE REGEN REQUIRED
Parent section: `SET01_S04`  
Area ID: `SET01_A10_STORAGE_WORKSHOP_YARD`

## Purpose

Area 10 is the material/logistics support yard for the East Work District.

Functions:
- storage;
- loading/unloading;
- work canopy;
- material racks;
- cart staging;
- support for Smithy & Craft Quarter.

## Composition

Standalone pixel-art yard only.

Show:
- one compact storage building;
- one open work canopy;
- material racks;
- carts;
- crates;
- ore/wood piles;
- clear loading lane;
- minimal worker figures.

Do not show:
- primary smith building dominating;
- market stalls;
- residences;
- giant warehouse.

## Storage building

Target:
- about 7×6 m;
- west-facing real doorway;
- simple one-room interior;
- loading pocket.

## Work canopy

Target:
- about 7×6 m;
- open sides;
- 4–6 posts;
- workbench/material rack;
- no invisible walls.

## Yard

Target usable exterior:
- about 16×14 m.

Keep center clear enough for cart/load movement.

## NPC density

Reference:
- 2–5 workers maximum.

## Anchors

Planned:
- `A10_StorageEntrance`
- `A10_LoadingAnchor`
- `A10_WorkAnchor_01`
- `A10_WorkAnchor_02`
- `A10_CartAnchor`
- `A10_MaterialRackAnchor`
- `A10_Connector_A09`
- `A10_Connector_A08`

## Collision

- storage building: segmented collision;
- canopy: post/workbench collision only;
- carts/racks: simple collision;
- small loose materials presentation-only where possible.

## Image brief

Generate only Area 10.

Desired view:
- high 3/4 deliberate pixel art;
- compact storage/work yard;
- clear cart/loading lane;
- storage building + open canopy;
- no full settlement or infographic.

## Acceptance checklist

Approve only if:
- logistics function clear;
- center loading path open;
- canopy visibly open;
- storage building compact;
- not warehouse/factory scale;
- genuine pixel style.


## Accepted reference artifact

Reference ID:
`REF_SET01_A10_STORAGE_WORKSHOP_YARD_R001`

Accepted pixel-art artifact:
- source file: `AREA_10_STORAGE_WORKSHOP_YARD_R001.png`
- dimensions: 1152×768
- bytes: 7,507
- SHA-256: `8e9bd95f377c8917bd44103c1c0a754b0fc79ae06dc198ddfd3243cc2f98a680`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_10_STORAGE_WORKSHOP_YARD_R001.png`
- Library file ID: `libfile_ed59a2812eb08191ae8cd434677811e0`
- backing file ID: `file_00000000579881f68a8107a3f618108b`

Disposition:
- accepted as current Area 10 pixel-art reference;
- loading/collision geometry remains blueprint authority.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_10_STORAGE_WORKSHOP_YARD_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_10/`

Final-reference placement authority:
`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

Current state:
- R001 concept reference preserved;
- technical asset review complete;
- primary model-sheet contracts ready;
- final position-locked reference still requires regeneration;
- runtime implementation not started;
- device visual verification not started.
