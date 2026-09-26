# Area 06 — Community Hall / Civic Core

Status: FINAL_REFERENCE_GENERATED / F002 CURRENT REVIEW TARGET / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S03`  
Area ID: `SET01_A06_COMMUNITY_CIVIC_CORE`

## Purpose

Area 06 is the local civic/social anchor built around the Community Hall.

Functions:
- local coordinator / hall keeper;
- meetings;
- notices;
- small events;
- civic identity;
- bridge between Central Plaza and West Residential.

## Relationship

Area 05:
- public market/social center.

Area 06:
- civic administration and local community.

Area 07:
- quieter residential life.

## Core structure

Primary building:
- Community Hall / Local Lodge
- footprint authority: 8×10 m
- east-facing real doorway
- open interior hall
- keeper work area
- notice/community wall

## Area composition

Standalone pixel-art civic courtyard only.

Show:
- Community Hall as dominant structure;
- modest frontage court;
- public notice board;
- 2–3 benches;
- lanterns;
- small civic tree/green patch;
- limited crates/storage at rear edge;
- visible road connector toward Central Plaza;
- visible lane toward residences.

Do not show:
- full market;
- huge government palace;
- temple/church;
- giant fountain.

## Courtyard target

Provisional visible outdoor zone:
- about 16×14 m around Hall frontage.

Keep east-facing entry clear.

## NPC density

Reference:
- 4–8 small figures maximum.

Suggested roles:
- hall keeper;
- 2–4 residents;
- 1 visitor/notice reader.

## Prop categories

- notice board
- benches
- sign/crest bracket
- lanterns
- planter/tree
- small civic storage
- optional event banner socket

## Anchors

Planned:
- `A06_HallEntranceConnector`
- `A06_HallKeeperAnchor`
- `A06_NoticeAnchor`
- `A06_EventGatherAnchor`
- `A06_SocialAnchor_01..04`
- `A06_Connector_A05`
- `A06_Connector_A07`

## Collision

Community Hall follows building blueprint:
- segmented wall collision;
- real doorway;
- interior floor.

Outdoor:
- benches/notice board simple collision;
- small foliage presentation-only.

## Image brief

Generate only Area 06.

Desired view:
- high 3/4 deliberate pixel art;
- Community Hall dominant;
- compact civic frontage/courtyard;
- clear east-facing approach;
- road/lane edges visible;
- no full settlement or infographic.

## Acceptance checklist

Approve only if:
- Hall reads as civic/local building;
- courtyard compact;
- entrance readable;
- clear relationship to road/lane;
- not confused with market or temple;
- genuine pixel style.


## Accepted reference artifact

Reference ID:
`REF_SET01_A06_COMMUNITY_HALL_CIVIC_CORE_R001`

Accepted pixel-art artifact:
- source file: `AREA_06_COMMUNITY_HALL_CIVIC_CORE_R001.png`
- dimensions: 1152×768
- bytes: 8,278
- SHA-256: `9d7e800d7c71cfb3ead52a28d45b12d7589ba5e44146775fca9e2a80c017069a`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_06_COMMUNITY_HALL_CIVIC_CORE_R001.png`
- Library file ID: `libfile_4930f61027088191b60af81747b41a76`
- backing file ID: `file_00000000476081f69b73dc35526842aa`

Disposition:
- accepted as current Area 06 pixel-art reference;
- Community Hall geometric blueprint remains dimension/collision authority.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_06_COMMUNITY_HALL_CIVIC_CORE_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_06/`

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
`FINAL_REF_SET01_A06_F001`

Artifact:
- filename: `AREA_06_COMMUNITY_HALL_CIVIC_CORE_F001_LOCKED.png`
- dimensions: 852×660
- bytes: 5,919
- SHA-256: `3bd272b112af7ab0898e6597dee3ffdfd9b27304b78139dfde3c3f6e121ef614`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_06_COMMUNITY_HALL_CIVIC_CORE_F001_LOCKED.png`
- Library file ID: `libfile_9355a08b2aec819180cf433f516e4842`
- backing file ID: `file_00000000c25881f69ad2a98c1ee6cdf4`

Spatial validation:
- north = image top;
- frame uses X -30..-14 / Z -6..+6;
- Community Hall fixed at center -24.5,0;
- hall footprint fixed at 8×10 m;
- east-facing doorway preserved;
- West Frontage Lane fixed at X -18.5..-14;
- approximately 2 m frontage clearance remains between hall and lane;
- notice board, benches, tree and lanterns do not block the door or connector.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`


## Creator-review revision F002

Reason:
- F001 passed spatial checks but was too flat and weak as the settlement's civic landmark.

Reference ID:
`FINAL_REF_SET01_A06_F002`

Artifact:
- filename: `AREA_06_COMMUNITY_HALL_CIVIC_CORE_F002_LOCKED.png`
- dimensions: 1278×990
- bytes: 11,049
- SHA-256: `1495a4c62038226252a808b5a1bdb3da60251647fbdf9866b6fd70a03051fdc2`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_06_COMMUNITY_HALL_CIVIC_CORE_F002_LOCKED.png`
- Library file ID: `libfile_b4e5cac777b881919c9245c5cc0f7277`
- backing file ID: `file_00000000ac9881f6b83678225ea72f73`

F002 preserves:
- north-up orientation;
- frame X -30..-14 / Z -6..+6;
- Community Hall fixed at center -24.5,0;
- hall footprint remains 8×10 m;
- east-facing doorway remains toward the frontage lane;
- West Frontage Lane remains on the east/right side;
- approximately 2 m frontage clearance is retained;
- notice board, benches, lanterns, civic tree and NPCs stay outside the doorway path and lane.

F002 improves:
- Community Hall silhouette;
- civic identity;
- roof/timber/stone readability;
- frontage/courtyard depth;
- first-person entrance visibility;
- controlled social detail.

Spatial status:
`SPATIAL_CHECK_PASS_BY_CONSTRUCTION`

Technical art review:
`F002 PREFERRED OVER F001`

Creator final visual approval:
`PENDING`

F001 remains archived for provenance.
