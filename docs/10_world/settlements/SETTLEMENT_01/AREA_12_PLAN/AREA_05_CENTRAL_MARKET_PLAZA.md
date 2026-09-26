# Area 05 — Central Market Plaza

Status: REFERENCE_GENERATED / REVIEW PENDING  
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
