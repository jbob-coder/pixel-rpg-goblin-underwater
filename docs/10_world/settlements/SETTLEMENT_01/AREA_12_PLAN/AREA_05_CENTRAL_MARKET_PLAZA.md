# Area 05 — Central Market Plaza

Status: FINAL_REFERENCE_GENERATED / F002 CURRENT REVIEW TARGET / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S02`  
Area ID: `SET01_A05_CENTRAL_MARKET_PLAZA`

## Purpose

Area 05 is the commercial and social center of Settlement 01.

It must support:
- market stalls;
- public gathering;
- central orientation;
- notices/events;
- connection to Community Hall, Work District, South Arrival and North Hunter routes.

## Geometry

Plaza planning target:
- approximately 28×24 m.

Keep clear:
- 8 m Main Hunter Spine through center;
- 5 m Central Cross Street through center.

This produces a plus-shaped circulation corridor.

## Visual composition

Standalone pixel-art plaza only.

Show:
- four market stall positions around perimeter;
- open center;
- one civic water/well/trough feature offset from exact center;
- notice board;
- benches;
- lanterns;
- sparse tree/green accents;
- small local gathering clusters.

Do not show:
- whole settlement;
- enclosed marketplace maze;
- giant fountain dominating the plaza;
- dense vendor clutter blocking movement.

## Stall roles

SW:
- general goods / produce

SE:
- food/basic supplies

NW:
- civic/local rotating vendor

NE:
- hunter/material/equipment display

## Central identity

The plaza should be recognizable from first person by:
- open central space;
- symmetrical but not sterile stall distribution;
- strong cross-street sightlines;
- civic notice/water landmark.

## NPC density

Reference:
- 6–12 small people maximum.

Runtime target may be lower.

## Prop categories

- stalls
- signs
- benches
- crates
- barrels
- baskets
- notice board
- lanterns
- one water/civic feature

## Anchors

Planned:
- `A05_Stall_SW`
- `A05_Stall_SE`
- `A05_Stall_NW`
- `A05_Stall_NE`
- `A05_NoticeAnchor`
- `A05_CivicWaterAnchor`
- `A05_EventAnchor`
- `A05_SocialAnchor_01..04`
- `A05_Connector_South`
- `A05_Connector_North`
- `A05_Connector_West`
- `A05_Connector_East`

## Collision

- ground owns walkability;
- stall posts/counters: minimal simple collision;
- benches/water feature: simple collision;
- small goods presentation-only where possible.

## Image brief

Generate only Area 05.

Desired view:
- high 3/4 deliberate pixel art;
- compact open plaza;
- four perimeter stalls;
- plus-shaped open circulation;
- no full settlement;
- no infographic/map panels.

## Acceptance checklist

Approve only if:
- center remains visibly open;
- all four directions read clearly;
- stalls stay on perimeter;
- market identity obvious;
- not over-cluttered;
- deliberate pixel style.


## Accepted reference artifact

Reference ID:
`REF_SET01_A05_CENTRAL_MARKET_PLAZA_R001`

Accepted pixel-art artifact:
- source file: `AREA_05_CENTRAL_MARKET_PLAZA_R001.png`
- dimensions: 1152×768
- bytes: 9,738
- SHA-256: `f89b2113a7a90647fd53096c60649674ff4f832c89213a270d9db5b533409176`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_05_CENTRAL_MARKET_PLAZA_R001.png`
- Library file ID: `libfile_0486cb5d89ac8191a345de15ba8d976e`
- backing file ID: `file_000000002f9081f69dbc271e88c567e5`

Disposition:
- accepted as current Area 05 pixel-art reference;
- plaza dimensions and circulation remain blueprint authority.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_05_CENTRAL_MARKET_PLAZA_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_05/`

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
`FINAL_REF_SET01_A05_F001`

Artifact:
- filename: `AREA_05_CENTRAL_MARKET_PLAZA_F001_LOCKED.png`
- dimensions: 1092×1092
- bytes: 10,402
- SHA-256: `f0f52664e9a021e1e1a24c9140b59aee11869eac9f1688bbfbf16c6fa8aa9910`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_05_CENTRAL_MARKET_PLAZA_F001_LOCKED.png`
- Library file ID: `libfile_85f336f794cc8191a73adb7ad4d1d7b8`
- backing file ID: `file_00000000dac481f6a657818025a8c031`

Spatial validation:
- north = image top;
- bounds X -14..+14 / Z -14..+14;
- Main Spine remains X -4..+4;
- Cross Street remains Z -2.5..+2.5;
- four 4×3 m stall slots remain outside both clear corridors;
- plaza center remains open;
- civic water/notice/bench/tree props remain peripheral.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`


## Creator-review revision F002

Reason:
- F001 passed spatial checks but remained too flat/diagram-like for the desired market/civic quality level.

Reference ID:
`FINAL_REF_SET01_A05_F002`

Artifact:
- filename: `AREA_05_CENTRAL_MARKET_PLAZA_F002_LOCKED.png`
- dimensions: 1260×1260
- bytes: 14,715
- SHA-256: `c7c1f4187bfb3296cb11d3f9d703659d47a982e5b1eb5db9d75db654a91d9c3b`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_05_CENTRAL_MARKET_PLAZA_F002_LOCKED.png`
- Library file ID: `libfile_8d693400146881918fbda73d9ad3d58a`
- backing file ID: `file_000000005b4881f6abc4731682f9203a`

F002 preserves:
- north-up orientation;
- Area 05 bounds X -14..+14 / Z -14..+14;
- Main Spine X -4..+4 remains fully clear;
- Cross Street Z -2.5..+2.5 remains fully clear;
- four market stall positions remain in perimeter quadrants;
- plaza center/intersection remains open;
- civic water feature, notice board, benches, lanterns and trees remain outside locked clear corridors.

F002 improves:
- pixel-art depth and texture;
- market-stall readability;
- quadrant identity;
- civic/social visual hierarchy;
- first-person landmark readability from the road approaches;
- controlled NPC/prop density without blocking circulation.

Spatial status:
`SPATIAL_CHECK_PASS_BY_CONSTRUCTION`

Technical art review:
`F002 PREFERRED OVER F001`

Creator final visual approval:
`PENDING`

F001 remains archived for provenance.
