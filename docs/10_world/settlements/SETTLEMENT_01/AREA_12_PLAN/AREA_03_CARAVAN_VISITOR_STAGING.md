# Area 03 — Caravan Yard / Visitor Staging

Status: FINAL_REFERENCE_GENERATED / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S01`  
Area ID: `SET01_A03_CARAVAN_VISITOR_STAGING`

## Purpose

Area 03 is the civilian logistics pocket immediately beyond South Gate security.

It handles:
- visitor carts;
- temporary goods staging;
- traveler orientation;
- loading/unloading;
- short-term animal/cart parking;
- transition from arrival/security into the central settlement route.

It is not a permanent market district.

## Relationship

Area 01:
- public entry/gate.

Area 02:
- guard/security operations.

Area 03:
- visitor/logistics staging before people disperse toward Area 04 and Area 05.

## Composition

Standalone pixel-art area only.

Core visual elements:
- two to three carts/wagons;
- open packed-earth staging yard;
- covered supply awning;
- hitching posts;
- water trough;
- wayfinding sign;
- loading crates/sacks;
- small traveler rest bench;
- one modest clerk/check-in table or booth;
- visible clear road connector.

## Yard geometry

Provisional usable area:
- approximately 18×16 m.

Keep center mostly open.

No permanent building larger than:
- about 6×5 m.

## Circulation

Required:
- 5 m clear route toward Area 04;
- direct visible connection back toward Area 01/02;
- carts parked at perimeter, not in through-route.

## Props

Required categories:
- carts
- crates
- sacks
- trough
- hitching posts
- wayfinding
- lantern
- awning
- bench

Optional:
- small traveler notice board
- barrel
- handcart

Avoid:
- full market stalls;
- dense vendor crowds;
- warehouse;
- military equipment;
- giant stables.

## NPC density

Reference image:
- 3–6 travelers/workers maximum.

Runtime can be lower.

## Visual language

Match Areas 01/02:
- deliberate pixel art;
- timber;
- stone/packed earth;
- muted cloth;
- warm lanterns;
- original IP.

Area 03 should feel busy but temporary.

## Anchors

Planned:
- `A03_RoadConnector_A02`
- `A03_RoadConnector_A04`
- `A03_CartAnchor_01`
- `A03_CartAnchor_02`
- `A03_LoadingAnchor`
- `A03_WaterAnchor`
- `A03_VisitorIdleAnchor_01`
- `A03_VisitorIdleAnchor_02`
- `A03_WayfindingAnchor`

## Collision

- carts: simple collision;
- trough: simple collision;
- small sacks/crates: collision only when substantial;
- signs/lanterns: minimal;
- ground owns walking physics.

## Image-generation brief

Generate only Area 03.

Desired view:
- high 3/4 pixel-art game-map view;
- compact visitor staging yard;
- clear road edge;
- two or three carts;
- awning and cargo;
- no full settlement;
- no infographic panels;
- no numbered-district map.

## Acceptance checklist

Approve only if:
- Area 03 function is obvious;
- central circulation remains clear;
- cart density controlled;
- not mistaken for a market;
- pixel style is genuine;
- reference remains compact and mobile-readable.


## Accepted reference artifact

Reference ID:
`REF_SET01_A03_CARAVAN_VISITOR_STAGING_R001`

Accepted pixel-art artifact:
- source file: `AREA_03_CARAVAN_VISITOR_STAGING_R001.png`
- dimensions: 1152×768
- bytes: 9,293
- SHA-256: `5ba054d60d69d3cbd6a4365850a6fd4617ae2d3bb824936a4faed72ff9bd65f3`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_03_CARAVAN_VISITOR_STAGING_R001.png`
- Library file ID: `libfile_13295846ca3c819196a0f8dc020dd388`
- backing file ID: `file_0000000071ec81f6ba11a699db2d3316`

Disposition:
- accepted as current Area 03 pixel-art reference;
- image is visual-reference authority only;
- road/collision dimensions remain owned by the settlement blueprint.


## Asset extraction and model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_03_CARAVAN_VISITOR_STAGING_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_03/`

Current state:
- reference generated and archived;
- technical reference review passed;
- primary model-sheet contracts ready;
- runtime implementation not started;
- device visual verification not started.


## Final-reference placement authority

`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

The archived R001 image remains a concept/asset reference.

A later final reference must be regenerated against the locked coordinates, orientation, neighbor edges, streets and building parcels before runtime placement is approved.


## Final position-locked reference F001

Reference ID:
`FINAL_REF_SET01_A03_F001`

Artifact:
- filename: `AREA_03_CARAVAN_VISITOR_STAGING_F001_LOCKED.png`
- dimensions: 840×714
- bytes: 6,500
- SHA-256: `c8356b01a18f60ed606b7ea7b9fffca7dd0796d06fd440f427d32466e70ccac5`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_03_CARAVAN_VISITOR_STAGING_F001_LOCKED.png`
- Library file ID: `libfile_4000ab4f8b688191bbc00d05db6c9513`
- backing file ID: `file_000000000f2481f69bee9e9a6a9abcee`

Spatial validation:
- north = image top;
- frame uses X +12..+30 / Z +14..+29;
- Arrival Storage/Logistics fixed at center +20,+23;
- building footprint remains 7×6 m;
- bounds X +16.5..+23.5 / Z +20..+26;
- west-side connector remains clear;
- building has a dedicated frontage strip before the connector lane;
- carts, awning, hitching and trough remain outside the connector;
- yard remains logistics/staging, not market.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`


## Creator-review revision F002

Reason:
- F001 passed spatial checks but remained too flat and under-detailed for the desired caravan/logistics identity.

Reference ID:
`FINAL_REF_SET01_A03_F002`

Artifact:
- filename: `AREA_03_CARAVAN_VISITOR_STAGING_F002_LOCKED.png`
- dimensions: 1260×900
- bytes: 10,615
- SHA-256: `5ec85e08721ec2327cd52d00007933cabf6a47e538bbe10bd203b5d7d09e999c`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_03_CARAVAN_VISITOR_STAGING_F002_LOCKED.png`
- Library file ID: `libfile_026839b1bdb081919c5ad3aae3541173`
- backing file ID: `file_000000005ed481f686284274ca91dfab`

F002 preserves:
- north-up orientation;
- Arrival Storage remains the primary building mass;
- west connector toward Area 01/Main Spine remains clear;
- north connector remains clear;
- cart/awning/trough staging remains outside connector lanes.

F002 improves:
- caravan-yard readability;
- cart staging;
- registration/wayfinding;
- supply/water identity;
- pixel-art depth and density.

Spatial status:
`SPATIAL_CHECK_PASS_BY_CONSTRUCTION`

Creator final visual approval:
`PENDING`

F001 remains archived for provenance.
