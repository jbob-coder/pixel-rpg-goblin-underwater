# Area 04 — Main Central Spine Road

Status: FINAL_REFERENCE_GENERATED / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent relationship: shared connector infrastructure  
Area ID: `SET01_A04_MAIN_CENTRAL_SPINE`

## Purpose

Area 04 is the strongest north-south circulation axis of Settlement 01.

It connects:
- South Arrival / visitor staging;
- Central Market Plaza;
- Community/Work branches;
- North Hunter staging;
- North Trail exit.

This area is primarily **circulation and visual orientation**, not a building district.

## Geometry

Authoritative planning relationship:
- center X: 0
- width: 8 m
- edge range: X -4..+4
- south-to-north run: South Gate → Central Plaza → North Gate

Area 04 visual reference should show a representative segment, not the entire 70 m route.

## Visual identity

Target:
- wide packed-earth / stone-reinforced main route;
- readable edge treatment;
- repeated lantern/sign rhythm;
- building frontages visible only at edges;
- clear forward sightline;
- stronger civic maintenance than alleys;
- still grounded and practical.

## Reference composition

Standalone pixel-art corridor scene only.

Show:
- a long central road segment;
- two side branch intersections;
- lantern posts;
- signpost/wayfinding;
- one or two benches;
- limited crates/carts at edges;
- building facades set back;
- pedestrians kept sparse.

Do not show:
- complete settlement map;
- district labels;
- all buildings;
- giant plaza;
- combat scene.

## Surface language

Main route:
- packed dirt with embedded stone / stabilized paving;
- subtle wheel wear;
- drainage/edge stones only if low-cost and readable.

No dense cobblestone texture that destroys pixel readability.

## Edge zones

Target 1.5–2.5 m visual shoulder outside the 8 m main road where practical.

Possible:
- lantern;
- bench;
- sign;
- tree;
- barrel/crate;
- facade entrance setback.

Permanent clutter must not narrow the main route below 6 m usable.

## Intersections

Reference should make side-street branches obvious without creating a complex road web.

Cross street:
- 5 m target

Side lanes:
- 4.5 m target

## NPC density

Reference:
- 4–8 small pedestrian figures maximum across the scene.

Runtime can be lower.

## Anchors

Planned:
- `A04_Connector_A03`
- `A04_Connector_A05`
- `A04_WestBranchConnector`
- `A04_EastBranchConnector`
- `A04_WayfindingAnchor_01`
- `A04_WayfindingAnchor_02`
- `A04_LanternSocket_01..N`
- `A04_BenchSocket_01..N`

## Collision

- ground owns walking physics;
- signs/lanterns: minimal/simple;
- benches/carts: simple only if substantial;
- decorative edge stones: presentation-only unless deliberately curbed.

## Image brief

Generate only a representative Main Central Spine Road segment.

Desired view:
- high 3/4 deliberate pixel art;
- clear 8 m road;
- visible long sightline;
- two side branches;
- edge facades/lanterns/signs;
- no overview map or infographic panels.

## Acceptance checklist

Approve only if:
- route reads as the settlement's primary road;
- central corridor remains open;
- side branches understandable;
- image is not mistaken for a plaza;
- no excessive prop density;
- deliberate pixel-art style.


## Accepted reference artifact

Reference ID:
`REF_SET01_A04_MAIN_CENTRAL_SPINE_R001`

Accepted pixel-art artifact:
- source file: `AREA_04_MAIN_CENTRAL_SPINE_ROAD_R001.png`
- dimensions: 1152×768
- bytes: 9,688
- SHA-256: `0be02d5640aac5293738bcc4db2b8f09d795e31b699e8367fdb8942564967442`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_04_MAIN_CENTRAL_SPINE_ROAD_R001.png`
- Library file ID: `libfile_19a66f2318a48191a67d3585c113a31d`
- backing file ID: `file_000000004e2881f6b32937f0d4bc8c8e`

Disposition:
- accepted as current Area 04 pixel-art reference;
- road widths and connector geometry remain blueprint authority.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_04_MAIN_CENTRAL_SPINE_ROAD_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_04/`

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
`FINAL_REF_SET01_A04_F001`

Artifact:
- filename: `AREA_04_MAIN_CENTRAL_SPINE_ROAD_F001_LOCKED.png`
- dimensions: 564×1764
- bytes: 10,970
- SHA-256: `edcd2f70ab34d40a3abe0afe15785fdfcef85059ad64627eb86a00910ff050cf`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_04_MAIN_CENTRAL_SPINE_ROAD_F001_LOCKED.png`
- Library file ID: `libfile_bfacf733c100819181584a5e7875d3fd`
- backing file ID: `file_00000000498081f6b46c09e872abb73e`

Spatial validation:
- north = image top;
- frame uses X -10..+10 / Z -36..+34;
- Main Hunter Spine fixed at X -4..+4 for the entire image;
- Central Cross Street fixed at Z -2.5..+2.5;
- South Gate threshold fixed at Z +33;
- North Gate threshold fixed at Z -35;
- neighboring South Gate structures appear only where their real parcels intersect the frame;
- no neighboring building is moved into the road corridor;
- permanent props stay outside the central travel path.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`


## Creator-review revision F002

Reason:
- F001 passed spatial checks but visually read as a bare road diagram rather than the settlement's primary circulation/landmark corridor.

Reference ID:
`FINAL_REF_SET01_A04_F002`

Artifact:
- filename: `AREA_04_MAIN_CENTRAL_SPINE_ROAD_F002_LOCKED.png`
- dimensions: 768×1920
- bytes: 15,639
- SHA-256: `9086c1d865c2ced758a6711aaf5c7dbe56ca7e669b5459cd7198c62049eb408d`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_04_MAIN_CENTRAL_SPINE_ROAD_F002_LOCKED.png`
- Library file ID: `libfile_a9afa198e7808191a4d4e95347b63f6f`
- backing file ID: `file_000000004ac881f68c9c6d36de8283b1`

F002 preserves:
- north-up orientation;
- X -4..+4 Main Hunter Spine corridor;
- central cross street at Z 0;
- north/south gate-threshold relationships;
- frontage buildings remain outside the road corridor;
- props remain on shoulders.

F002 improves:
- long-road visual rhythm;
- side-frontage depth;
- wayfinding;
- benches/lantern cadence;
- side-branch readability;
- pixel-art environmental detail.

Spatial status:
`SPATIAL_CHECK_PASS_BY_CONSTRUCTION`

Creator final visual approval:
`PENDING`

F001 remains archived for provenance.
