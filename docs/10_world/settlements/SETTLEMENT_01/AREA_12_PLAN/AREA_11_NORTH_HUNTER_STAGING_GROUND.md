# Area 11 — North Hunter Staging Ground

Status: FINAL_REFERENCE_GENERATED / F002 CURRENT REVIEW TARGET / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
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


## Final position-locked reference F001

Reference ID:
`FINAL_REF_SET01_A11_F001`

Artifact:
- filename: `AREA_11_NORTH_HUNTER_STAGING_GROUND_F001_LOCKED.png`
- dimensions: 1524×300
- bytes: 4,810
- SHA-256: `a1c35a967580295ab9465c618f3a5547f11111377d239bf89952e2e866f3d95e`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_11_NORTH_HUNTER_STAGING_GROUND_F001_LOCKED.png`
- Library file ID: `libfile_ff02079a24688191b47ba502f3aced34`
- backing file ID: `file_00000000cbf081f69a74eb5acd2159a2`

Spatial validation:
- north = image top;
- frame uses X -30..+30 / Z -23..-14;
- Main Spine remains clear at X -4..+4;
- bounty board, prep racks, benches and supplies remain outside the central route;
- route to Area 12 remains visible at the north/top edge;
- no permanent building or market stall was introduced.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`


## Creator-review revision F002

Reason:
- F001 passed spatial checks but was too thin/under-developed for the hunter-preparation threshold.

Reference ID:
`FINAL_REF_SET01_A11_F002`

Artifact:
- filename: `AREA_11_NORTH_HUNTER_STAGING_GROUND_F002_LOCKED.png`
- dimensions: 1280×380
- bytes: 7,153
- SHA-256: `4bad2fd48b62d19eadfee05ae5a411f6ab5efdc23fe1a749970b6a4cf352d2dd`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_11_NORTH_HUNTER_STAGING_GROUND_F002_LOCKED.png`
- Library file ID: `libfile_a35941b0c6e481918dcd8b44ebabe2c5`
- backing file ID: `file_00000000f31c81f6a4a5dd90895663eb`

F002 preserves:
- north-up orientation;
- frame X -30..+30 / Z -23..-14;
- 8 m Main Spine remains fully clear at center;
- northward route toward Area 12 remains visible;
- no permanent building or market stall is introduced;
- bounty/prep/supply elements stay outside the center route.

F002 improves:
- bounty/route board prominence;
- hunter prep racks;
- supply/equipment staging;
- warning-banner identity;
- regrouping/readiness cues;
- controlled hunter/support NPC density;
- pixel-art depth without military-barracks drift.

Spatial status:
`SPATIAL_CHECK_PASS_BY_CONSTRUCTION`

Technical art review:
`F002 PREFERRED OVER F001`

Creator final visual approval:
`PENDING`

F001 remains archived for provenance.
