# Area 10 — Storage / Workshop Yard

Status: FINAL_REFERENCE_GENERATED / F002 CURRENT REVIEW TARGET / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
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


## Final position-locked reference F001

Reference ID:
`FINAL_REF_SET01_A10_F001`

Artifact:
- filename: `AREA_10_STORAGE_WORKSHOP_YARD_F001_LOCKED.png`
- dimensions: 426×1092
- bytes: 5,958
- SHA-256: `ef6e410ce4308fc0855dd8d0029486b6f9308207d7726ae8e63824b6bc7e0fb4`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_10_STORAGE_WORKSHOP_YARD_F001_LOCKED.png`
- Library file ID: `libfile_01bd38d4ad4881918e0364d24392aae6`
- backing file ID: `file_00000000f01081f6acaa975abf463e60`

Spatial validation:
- north = image top;
- full relation frame uses X +20.5..+30 / Z -14..+14;
- Work Canopy remains north at center +24.5,-9.5;
- Smith remains between the work pockets at center +24.5,0;
- Work Storage remains south at center +24.5,+9.5;
- east service-alley edge remains readable;
- carts/materials stay within their work pockets and do not merge the two areas.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`


## Creator-review revision F002

Reason:
- F001 passed spatial checks but was too diagram-like for the storage/work-support district.

Reference ID:
`FINAL_REF_SET01_A10_F002`

Artifact:
- filename: `AREA_10_STORAGE_WORKSHOP_YARD_F002_LOCKED.png`
- dimensions: 630×1860
- bytes: 11,374
- SHA-256: `11b6b61e269ad3c67cebca8797fe415204cb38c41e3eb5cf240dcbb932b09b44`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_10_STORAGE_WORKSHOP_YARD_F002_LOCKED.png`
- Library file ID: `libfile_45154eda501081918983f283c0edce7b`
- backing file ID: `file_00000000dbc881f681d452c0defa498e`

F002 preserves:
- north-up orientation;
- frame X +20.5..+30 / Z -14..+14;
- Work Canopy remains north at center +24.5,-9.5;
- Smith remains centered between the two work pockets at +24.5,0;
- Work Storage remains south at center +24.5,+9.5;
- east service alley remains readable;
- north and south pockets remain distinct;
- carts/materials stay inside their intended work zones.

F002 improves:
- open-canopy readability;
- storage/loading identity;
- ore/firewood/material staging;
- cart/loading pockets;
- worker activity;
- service-alley continuity;
- pixel-art depth.

Spatial status:
`SPATIAL_CHECK_PASS_BY_CONSTRUCTION`

Technical art review:
`F002 PREFERRED OVER F001`

Creator final visual approval:
`PENDING`

F001 remains archived for provenance.
