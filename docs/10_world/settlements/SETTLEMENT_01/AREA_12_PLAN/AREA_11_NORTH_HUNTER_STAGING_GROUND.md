# Area 11 — North Hunter Staging Ground

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL_SHEET_READY / FINAL REFERENCE REGEN REQUIRED
Parent section: `SET01_S05`  
Area ID: `SET01_A11_NORTH_HUNTER_STAGING`

## Purpose

Area 11 is the preparation zone immediately before the dangerous North Watch Gate.

Functions:
- hunt preparation;
- bounty/route information;
- equipment checks;
- supply handoff;
- regrouping;
- transition from settlement life to hunt state.

## Composition

Standalone pixel-art staging ground only.

Show:
- open preparation yard;
- bounty/route board;
- hunter prep racks;
- benches;
- supply table;
- weapon/tool check area;
- lanterns;
- limited warning banners;
- small watch/support structure at edge;
- clear route toward Area 12.

Do not show:
- full north gate as dominant element;
- huge training arena;
- monster fight;
- full settlement.

## Yard target

Provisional:
- about 18×16 m usable preparation space.

Keep center open.

## Props

Required:
- bounty/route board
- prep rack
- equipment table
- supply crate/cache
- bench
- lantern
- warning sign/banner

Optional:
- small practice target
- water barrel
- hitching point

## NPC density

Reference:
- 4–8 hunter/support figures maximum.

Runtime likely lower.

## Anchors

Planned:
- `A11_BountyBoardAnchor`
- `A11_PrepAnchor_01`
- `A11_PrepAnchor_02`
- `A11_SupplyAnchor`
- `A11_HunterIdle_01..04`
- `A11_Connector_A10`
- `A11_Connector_A12`

## Collision

- large prep racks/simple tables: simple collision;
- small equipment visuals: presentation-only;
- signs/lanterns minimal;
- center route stays clear.

## Image brief

Generate only Area 11.

Desired view:
- high 3/4 deliberate pixel art;
- compact hunter-preparation yard;
- route/bounty board;
- equipment prep;
- visible path continuing north;
- no full settlement or infographic.

## Acceptance checklist

Approve only if:
- hunt-preparation purpose obvious;
- center open;
- not confused with military barracks;
- Area 12 direction visible;
- prop density controlled;
- genuine pixel art.


## Accepted reference artifact

Reference ID:
`REF_SET01_A11_NORTH_HUNTER_STAGING_R001`

Accepted pixel-art artifact:
- source file: `AREA_11_NORTH_HUNTER_STAGING_GROUND_R001.png`
- dimensions: 1152×768
- bytes: 7,993
- SHA-256: `63afae7b08b3069a0b74deec359061f1437188d12f6672b5b1965ff241aa8bc0`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_11_NORTH_HUNTER_STAGING_GROUND_R001.png`
- Library file ID: `libfile_0bb6bce88c988191818a153a1f206df2`
- backing file ID: `file_00000000157c81f6a1c05c924fd94c77`

Disposition:
- accepted as current Area 11 pixel-art reference;
- hunter-preparation geometry remains blueprint authority.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_11_NORTH_HUNTER_STAGING_GROUND_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_11/`

Final-reference placement authority:
`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

Current state:
- R001 concept reference preserved;
- technical asset review complete;
- primary model-sheet contracts ready;
- final position-locked reference still requires regeneration;
- runtime implementation not started;
- device visual verification not started.
