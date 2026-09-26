# BLD-03 — South Gatehouse / Arrival Security Complex

Status: PROVISIONAL BUILDING BLUEPRINT  
Primary ID: `SET01_BLD_SOUTH_GATEHOUSE_W`  
Companion ID: `SET01_BLD_SOUTH_WATCH_E`  
Section: `SET01_S01`

## 1. Role

Defines the civilian/visitor arrival identity of Settlement 01.

Must communicate:
- settlement boundary;
- security;
- first orientation;
- protected but accessible community.

It should visually differ from S05 Hunter Gate, which is a hunt/departure threshold.

## 2. Gate opening

South gate center:
- world (0,0,+33)

Clear opening:
- 8 m
- X -4..+4

The gate opening itself is not occupied by either gatehouse parcel.

## 3. West Gatehouse

Center:
- (-8,+29)

Footprint:
- 8 × 7 m

Bounds:
- X -12..-4
- Z +25.5..+32.5

Notice:
- east wall ends exactly at X -4, aligning with gate opening edge.
- collision must not intrude into X > -4.

Role:
- arrival guard/admin
- settlement information
- gate-control visual identity

## 4. East Watch structure

Center:
- (+8,+29)

Footprint:
- 6 × 6 m

Bounds:
- X +5..+11
- Z +26..+32

The east side intentionally leaves at least 1 m horizontal separation from the +4 m gate opening edge.

Role:
- watch silhouette
- secondary guard position
- arrival landmark

## 5. West Gatehouse interior

Target:
- small guard/admin room
- visitor conversation position
- wall/notice storage

```
              NORTH
      ┌──────────────────┐
      │ guard/admin      │
      │ desk / storage   │
      │                  │
GATE  │ D    open room   │ WEST/SOUTH WALLS
SIDE  │                  │
      └──────────────────┘
              SOUTH
```

Primary entrance should face inward/north-east or east toward the arrival space, not directly force the player into the gate opening.

## 6. Watch structure

First pass can be:
- ground-level small room/covered guard position;
- strong vertical upper watch silhouette;
- non-enterable upper deck if stairs would add unnecessary complexity.

If upper platform becomes traversable later, it requires a separate navigation/collision contract.

## 7. Anchors

West Gatehouse:
- EntranceAnchor
- ExitAnchor
- ArrivalGuardWorkAnchor
- VisitorConversationAnchor
- GateControlAnchor
- NoticeAnchor
- GuardIdleAnchor

East Watch:
- WatchGuardAnchor
- LookoutAnchor
- LanternSocket
- BannerSocket

Gate:
- SouthGateCenterAnchor
- SouthGateInnerArrivalAnchor
- SouthGateOuterArrivalAnchor

## 8. Collision

Gate opening:
- center must remain physically clear.

West gatehouse:
- authored segmented building collision.

East watch:
- simple authored collision.

Perimeter wall connects to outer sides of gatehouse/watch modules.

No giant gate/wall collider.

## 9. Exterior arrival layout

South-west/security:
- notice board
- supply crates
- guard staging

South-east/logistics:
- water trough
- carts
- visitor/loadout supplies

The 8 m central gate corridor remains clean.

## 10. Gate visual behavior

Gate door itself may eventually:
- remain open normally;
- close for scripted state/emergency;
- reflect world-state flags.

Do not implement stateful gate logic in the visual scene itself.

## 11. Photo/reference request

Need separate references for:
- compact guard gatehouse
- simple watch structure
- gate/wall connector
- 3/4 arrival composition

Avoid:
- giant fortress gate
- ornate castle
- copied fantasy-game gate design

Target:
- grounded settlement defense
- modest scale
- readable from first-person
- original design

## 12. South vs North gate visual distinction

South Gate:
- civilian
- settlement identity
- welcome/security
- carts/logistics

North Hunter Gate:
- rugged
- preparation
- warnings
- hunt route
- supplies/watch

They may share construction materials but should not be identical.

## 13. Tests

Future:
- gate opening width >=8 m in blueprint/runtime contract
- center ray/path clear
- gatehouse and watch collisions block outside opening
- west gatehouse inside S01
- east watch inside S01
- no intrusion into main spine
- required anchors exist
- wall connectors align without sealing gate.

## 14. Asset readiness

Current:
- BLUEPRINT_DRAFT

This blueprint should be implemented after the generic reusable building contract proves one second real enterable building.
