# Area 03 — Caravan Yard / Visitor Staging

Status: REFERENCE_GENERATED / REVIEW PENDING  
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
