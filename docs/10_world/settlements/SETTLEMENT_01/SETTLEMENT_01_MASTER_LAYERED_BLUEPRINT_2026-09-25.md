# Settlement 01 — Master Layered Blueprint

Status: PROVISIONAL FULL-SETTLEMENT BLUEPRINT / DOCUMENTATION ONLY  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

Layer package:

`BLUEPRINT_LAYERS/`

## 1. Blueprint purpose

This is the consolidated top-down plan for the approved five-section Settlement 01 rebuild.

It defines:
- section ownership;
- major roads;
- building parcels;
- important interiors;
- corner functions;
- service/NPC zones;
- collision expectations;
- streaming/minimap ownership;
- asset production priorities;
- migration order.

It does **not** move current runtime geometry.

## 2. Overall envelope

Provisional:
- width: 60 m
- depth: 70 m
- X: -30..+30
- Z: -36..+34
- nominal floor: Y 0

Coordinate direction:
- west = negative X
- east = positive X
- south/arrival = positive Z
- north/trail = negative Z

## 3. Top-down conceptual plan

```
Z -36  NORTH / HUNT TRAIL
        ┌──────────────────────────────────────────────────────────┐
        │                     S05 HUNTER EXIT                      │
        │  [Hunter Watch]   prep / bounty   [Supply Cache]        │
        │         NW             ||                NE              │
        │                        ||                                │
        │                   NORTH GATE 8m                          │
Z -14   ├───────────────┬────────||────────┬───────────────────────┤
        │      S03      │       S02        │         S04           │
        │ WEST LOCAL    │ CENTRAL PLAZA    │ EAST WORK DISTRICT    │
        │ [Res W02]     │  NW        NE    │      [Work Canopy]    │
        │               │  stall    stall  │                       │
        │ [Community]===│==== CROSS ST ====│=== [Smith]            │
        │   [Hall]      │  stall    stall  │                       │
        │ [Res W01]     │  SW        SE    │      [Storage]        │
Z +14   ├───────────────┴────────||────────┴───────────────────────┤
        │                     S01 ARRIVAL                          │
        │ [Arrival Guard]         ||          [Arrival Storage]    │
        │ notice / supplies       ||          trough / carts       │
        │ [Gatehouse W]       SOUTH GATE      [Watch E]            │
Z +34   └──────────────────────────────────────────────────────────┘
                         CIVILIAN ARRIVAL
```

Diagram is schematic. Coordinate tables below are the planning source.

## 4. Section bounds

| Section | X bounds | Z bounds | Primary role |
|---|---:|---:|---|
| S01 South Gate / Arrival | -30..+30 | +14..+34 | arrival/security/logistics |
| S02 Central Plaza / Market | -14..+14 | -14..+14 | civic/market/navigation |
| S03 West Residential / Local | -30..-14 | -14..+14 | Community Hall/residences |
| S04 East Work District | +14..+30 | -14..+14 | smith/storage/work |
| S05 North Hunter Exit | -30..+30 | -36..-14 | hunt preparation/trail |

## 5. Required section graph

```
S03 ←→ S02 ←→ S04
        ↑  ↓
       S01 S05
```

Required connectors:
- S01↔S02 main: 8 m
- S02↔S05 main: 8 m
- S02↔S03: 5 m
- S02↔S04: 5 m

Optional side connectors remain future choices.

## 6. Street plan

### Main Hunter Spine
- center X 0
- width 8 m
- X -4..+4
- South Gate → Plaza → North Gate

### Central Cross Street
- center Z 0
- width 5 m
- Z -2.5..+2.5
- X -20..+20
- terminates before Community Hall and Smith footprints

### West frontage lane
- center X -16.25
- width 4.5 m
- Z -13..+13

### East frontage lane
- center X +16.25
- width 4.5 m
- Z -13..+13

### Rear service alleys
- west center X about -28.5
- east center X about +28.5
- width target 2.5 m
- may be discontinuous

## 7. Building parcel register

| ID | Center X/Z | Footprint | Section | State |
|---|---|---|---|---|
| South Gatehouse W | -8,+29 | 8×7 | S01 | planned |
| South Watch E | +8,+29 | 6×6 | S01 | planned |
| Arrival Guard | -20,+23 | 7×6 | S01 | planned |
| Arrival Storage | +20,+23 | 7×6 | S01 | planned |
| Community Hall | -24.5,0 | 8×10 | S03 | planned |
| Residence W01 | -24.5,+10 | 7×5.5 | S03 | planned |
| Residence W02 | -24.5,-10 | 7×5.5 | S03 | planned |
| Smith | +24.5,0 | 6.6×6.4 | S04 | adapt current implemented smith |
| Work Storage | +24.5,+9.5 | 7×6 | S04 | planned |
| Work Canopy | +24.5,-9.5 | 7×6 | S04 | planned |
| Hunter Watch | -19,-27 | 7×7 | S05 | planned |
| Supply Cache | +19,-27 | 7×6 | S05 | planned |

## 8. Building rectangle bounds

Planning bounds:

- South Gatehouse W: X -12..-4 / Z +25.5..+32.5
- South Watch E: X +5..+11 / Z +26..+32
- Arrival Guard: X -23.5..-16.5 / Z +20..+26
- Arrival Storage: X +16.5..+23.5 / Z +20..+26
- Community Hall: X -28.5..-20.5 / Z -5..+5
- Residence W01: X -28..-21 / Z +7.25..+12.75
- Residence W02: X -28..-21 / Z -12.75..-7.25
- Smith: X +21.2..+27.8 / Z -3.2..+3.2
- Work Storage: X +21..+28 / Z +6.5..+12.5
- Work Canopy: X +21..+28 / Z -12.5..-6.5
- Hunter Watch: X -22.5..-15.5 / Z -30.5..-23.5
- Supply Cache: X +15.5..+22.5 / Z -30..-24

## 9. Geometric planning validation

Checked against the provisional rectangles:

- all planned buildings remain inside their assigned section bounds;
- no planned building footprints overlap each other;
- no building intrudes into the 8 m Main Hunter Spine;
- Central Cross Street stops before Community Hall and Smith;
- west frontage provides about 2 m clearance to Community Hall;
- east frontage provides about 2.7 m clearance to Smith;
- north/south gate centerlines remain open.

This is documentation geometry validation only.

## 10. Corner-function map

### South-west
Security:
- guard
- notice
- supply crates
- wall/watch identity

### South-east
Arrival logistics:
- trough
- carts
- visitor supplies
- sign/lantern

### Plaza south-west
General goods / produce

### Plaza south-east
Food/service

### Plaza north-west
Local/civic route identity

### Plaza north-east
Hunter/work/material identity

### West residential
Community Hall + two residence fronts + low-density life props

### East work
Smith + storage + canopy + functional material clutter

### North-west
Hunter preparation:
- bounty/route board
- prep rack
- watchpost

### North-east
Supply/warning:
- emergency cache
- warning sign/banner
- fence/wall termination

## 11. Important interior priorities

Tier 1:
- Community Hall
- Smith
- South Gatehouse
- Hunter Watch

Tier 2:
- Residence W01
- Residence W02
- Work Storage
- Supply Cache

Tier 3:
- open work canopy
- market stalls

Every Tier 1/2 important building requires a real entrance and usable interior.

## 12. Asset-production relationship

Use existing assets first:
- current smith
- current market stall
- current gate visual
- lantern
- fence
- banner
- signpost
- pines/rocks/vegetation
- Pack 010/011 materials/images

New blueprint/photo-reference priorities:
1. Community Hall
2. residence type
3. South Gatehouse
4. work storage
5. Hunter Watch
6. modular wall/corner kit
7. work canopy
8. market variants
9. cart/notice board/bench/rack props

Photo/reference method:
`../../../../40_art/asset_pipeline/PHOTO_REFERENCE_REVERSE_ENGINEERING_GUIDE.md`

## 13. Current runtime mapping

Current Market
→ future S02.

Current Smith
→ future S04.

Current Gate + Gate Warden
→ future S05.

Current Street
→ seed/reference for Main Hunter Spine.

Current Trail
→ S05 north trail connector.

Current Generic Building A
→ scale/temporary reference only for S03.

Current Generic Building B
→ scale/temporary reference only for S04.

Do not move all objects at once.

## 14. Implementation order

1. section data over current world
2. reusable building contract
3. second real enterable building
4. S04 Smith/work district
5. S02 Plaza/market
6. S03 Community/residential
7. S01 South arrival
8. S05 Hunter exit
9. perimeter/walls/props
10. minimap/signage
11. conservative streaming
12. services/persistence

## 15. Layer package

Read in order:

- Layer 00: coordinates/scale
- Layer 01: sections/connectors
- Layer 02: streets
- Layer 03: parcels/buildings
- Layer 04: interiors/anchors
- Layer 05: props/corners
- Layer 06: NPC/services
- Layer 07: collision/navigation
- Layer 08: streaming/ownership
- Layer 09: minimap/wayfinding
- Layer 10: art/photo queue
- Layer 11: performance/LOD
- Layer 12: migration/implementation

## 16. Change-control rule

A change to one layer must propagate to dependent layers.

Examples:

Move building
→ update parcel
→ doorway/interior anchor
→ collision
→ NPC/service anchor
→ minimap
→ section ownership
→ tests.

Change street width
→ update connector
→ frontage clearance
→ prop sockets
→ minimap
→ navigation tests.

No silent coordinate drift.
