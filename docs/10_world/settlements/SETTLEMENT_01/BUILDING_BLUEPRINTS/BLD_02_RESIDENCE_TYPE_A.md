# BLD-02 — Residence Type A

Status: PROVISIONAL REUSABLE BUILDING BLUEPRINT  
Stable family ID: `SET01_BLD_RESIDENCE_A`

Initial instances:
- `SET01_BLD_RES_W01`
- `SET01_BLD_RES_W02`

Section:
- `SET01_S03`

## 1. Role

Reusable compact home for named/local NPCs.

Goals:
- real doorway;
- believable interior;
- low runtime cost;
- reusable with visual variation;
- supports resident schedule anchors.

This is not intended to simulate every household detail.

## 2. Parcel instances

### W01
Center:
- (-24.5,+10)

### W02
Center:
- (-24.5,-10)

Target footprint:
- 7 m × 5.5 m

Bounds per instance:
- X -28..-21
- Z center ±2.75

Facade:
- EAST

## 3. Vertical dimensions

Provisional:
- wall height: 3.2 m
- ridge height: 4.8–5.4 m
- doorway: 1.6 m × 2.3 m

## 4. Interior plan

Local footprint:
- X -3.5..+3.5
- Z -2.75..+2.75

```
       NORTH / local Z -
    ┌───────────────────┐
    │ private/rest      │
    │ zone / storage    │
    │──────────┐        │
    │          │        │
    │ main living room  │
    │          │    D   │ EAST
    └───────────────────┘
       SOUTH / local Z +
```

First implementation:
- one main room;
- one light private/rest zone or partial partition;
- no hallway maze.

## 5. Variation system

Keep same collision/anchor contract while allowing visual variation:

Variant knobs:
- roof material
- facade beam layout
- window arrangement
- sign/house marker
- small awning
- yard props
- chimney optional

Collision must remain compatible across variants unless variant has its own explicit contract.

## 6. Anchors

Required:
- EntranceAnchor
- ExitAnchor
- ResidentIdleAnchor
- ResidentRestAnchor
- InteriorCenterAnchor
- YardAnchor
- RoofVisibilityGroup if used

Approximate local:
- EntranceAnchor: (+3.9,0,+0.8)
- ExitAnchor: (+2.9,0,+0.8)
- InteriorCenterAnchor: (0,0,0)
- ResidentIdleAnchor: (-0.5,0,+0.5)
- ResidentRestAnchor: (-2.0,0,-1.3)
- YardAnchor: (+5.0,0,0)

## 7. Collision

Segmented wall collision around real doorway.

Simple floor.

Furniture:
- mostly no collision unless large enough to obstruct traversal;
- bed/table may use simple boxes.

## 8. Window plan

2–4 windows total.

Recommended:
- east facade: one window beside doorway
- west wall: one
- north/south: one optional each

Avoid too many unique window meshes.

## 9. Yard / exterior sockets

Per residence:
- one woodpile/storage socket
- one bench/stool socket
- one lantern socket
- one optional low garden/laundry visual socket

Keep frontage lane clear.

## 10. NPC relationship

Each residence gets one primary resident identity in the first implementation.

Optional household expansion later.

Schedule hooks:
- HOME
- LEAVE_HOME
- RETURN_HOME
- REST
- YARD

Unloaded state remains abstract.

## 11. Photo/reference request

Need:
- front
- side
- rear
- roof
- simple interior

Target character:
- compact;
- practical;
- not luxurious;
- visually distinct enough from smith/hall;
- modular enough for at least two instances.

## 12. Tests

Future:
- both W01/W02 inside S03
- doorway open
- adjacent wall collision blocks
- anchor set exists
- variants preserve footprint contract
- no collision with West frontage lane
- yard props do not block lane.

## 13. Asset readiness

Current:
- BLUEPRINT_DRAFT

This building should become the first reusable multi-instance residence contract.
