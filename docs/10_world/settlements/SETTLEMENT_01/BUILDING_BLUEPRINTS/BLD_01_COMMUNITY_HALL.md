# BLD-01 — Community Hall / Local Lodge

Status: PROVISIONAL BUILDING BLUEPRINT  
Stable ID: `SET01_BLD_COMMUNITY_HALL`  
Section: `SET01_S03` — West Residential / Local

## 1. Role

Primary social/local-life building for Settlement 01.

Functions:
- local coordinator / hall keeper;
- conversations;
- notices/events;
- small gatherings;
- future social quest hooks;
- resident/local information.

This is not a tavern unless later lore explicitly changes it.

## 2. World parcel

Planned center:
- X -24.5
- Z 0

Planned footprint:
- 8 m wide × 10 m deep

Bounds:
- X -28.5..-20.5
- Z -5..+5

Primary facade:
- EAST, facing West Residential frontage lane and Central Plaza direction.

## 3. Overall vertical dimensions

Provisional:
- wall height: 3.8 m
- ridge height: 5.8–6.2 m
- floor thickness: <=0.25 m visual/collision treatment
- doorway clear height: 2.4 m
- doorway clear width: 1.8 m

## 4. Local floor plan

Local building size:
- X -4..+4
- Z -5..+5

East facade is local +X.

```
                    NORTH
              local Z -5
        ┌────────────────────┐
        │ Rear / meeting     │
        │ sockets + storage  │
        │                    │
        │───────┐    ┌───────│
        │notice │    │keeper │
        │ wall  │    │ desk  │
        │       MAIN HALL    │
        │       open floor   │
        │                    │
        │ seats        seats │
        │               D    │ EAST FACADE
        └────────────────────┘
              local Z +5
                    SOUTH
```

The diagram is schematic. The doorway is on the east facade near the southern half so the player enters into open hall space rather than directly into a service desk.

## 5. Interior zones

### Main Hall
Target usable clear area:
- about 5.5 × 6.5 m after walls/furniture

Purpose:
- player circulation;
- 3–5 NPC gathering anchors;
- event staging;
- conversation.

Keep at least:
- 1.5 m clear route from entrance to center;
- 1.2 m around critical NPC/service positions.

### Keeper / local coordinator zone
Target:
- north-east interior quadrant

Contains:
- keeper desk/table;
- NPC work anchor;
- future service/quest interaction.

### Notice / community wall
Target:
- west or north-west interior wall

Contains:
- notices;
- local-event display;
- future interaction anchor.

### Rear meeting/storage zone
Target:
- north/rear portion

First pass may be an open nook rather than a separate room.

Do not over-partition the first implementation.

## 6. Doors and windows

Main doorway:
- east wall
- clear width 1.8 m
- height 2.4 m
- outward/inward visual swing optional; collision must preserve clear passage.

Optional secondary/service door:
- west/north-west only if later NPC/service flow needs it.
- NOT required in first implementation.

Windows:
- east facade: 2 windows, one on either side of the entrance where geometry allows
- north wall: 1–2
- south wall: 1–2
- west wall: optional high/simple windows

Window visuals do not require complex collision.

## 7. Anchors

Required:
- `EntranceAnchor`
- `ExitAnchor`
- `HallCenterAnchor`
- `KeeperWorkAnchor`
- `NoticeBoardAnchor`
- `NPCIdleAnchor_01`
- `NPCIdleAnchor_02`
- `NPCIdleAnchor_03`
- `NPCIdleAnchor_04`
- `EventGatherAnchor_01`
- `EventGatherAnchor_02`
- `RoofVisibilityGroup`

Recommended local positions, approximate:
- EntranceAnchor: (+4.4,0,+1.5)
- ExitAnchor: (+3.4,0,+1.5)
- HallCenterAnchor: (0,0,0)
- KeeperWorkAnchor: (+2.4,0,-2.5)
- NoticeBoardAnchor: (-3.4,1.4,-1.8)

These are blueprint positions only.

## 8. Collision

Use segmented wall collision.

Required pieces:
- west wall
- north wall
- south wall
- east wall north segment
- east wall south segment
- doorway gap
- floor

Do not use one 8×10 solid collision box.

Furniture collision:
- keeper desk: simple box
- benches/tables: simple collision only if physically meaningful
- wall notices: no collision

## 9. Roof / first-person handling

Preferred:
- pitched roof or simple high silhouette;
- interior ceiling/underside should not obstruct the first-person camera;
- split roof into logical pieces only if visibility handling requires it.

Do not make roof hiding responsible for wall collision.

## 10. Exterior prop sockets

East frontage:
- sign
- lantern
- bench
- local notice marker

North/south edges:
- limited residential/civic props

Rear:
- storage/firewood/service props if needed

Avoid market clutter around the hall.

## 11. NPC relationship

Primary owner:
- Hall Keeper / Local Coordinator

Potential visible activity:
- keeper work
- residents gathering
- notice reading
- short events

No full AI required.

## 12. Photo/reference blueprint request

Preferred generated/reference image package:
- front/east facade
- 3/4 exterior
- side
- roof/high angle
- interior toward entrance
- interior toward keeper area

Visual goals:
- compact community lodge;
- sturdy local construction;
- identifiable civic building without looking grand/palatial;
- pixel-styled real-3D-compatible silhouette;
- original IP.

## 13. Focused implementation tests

Future test should verify:
- exact building ID;
- footprint within S03;
- east-facing real doorway;
- doorway ray/path passes;
- adjacent east wall segments block;
- EntranceAnchor exists;
- KeeperWorkAnchor exists;
- HallCenterAnchor exists;
- no monolithic sealed collision;
- roof visibility group exists if roof-hiding logic is used.

## 14. Asset readiness

Current state:
- BLUEPRINT_DRAFT

Next:
- reference/model sheet
- graybox scene
- collision test
- first-person interior test
- visual asset integration
