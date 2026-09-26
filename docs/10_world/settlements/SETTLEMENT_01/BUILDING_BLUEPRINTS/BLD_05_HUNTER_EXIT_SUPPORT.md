# BLD-05 — North Hunter Exit Support

Status: PROVISIONAL BLUEPRINT  
Section: `SET01_S05`

Covers:
- `SET01_BLD_HUNTER_WATCH`
- `SET01_BLD_SUPPLY_CACHE`
- North Hunter Gate support relationship

## Hunter Watch

Center:
- (-19,-27)

Footprint:
- 7×7 m

Role:
- hunter/watcher presence
- route warnings
- preparation
- Gate Warden support

Facade:
- south/east toward settlement/gate approach

Interior:
- small ground room
- lookout identity
- optional non-traversable upper watch silhouette initially

Anchors:
- EntranceAnchor
- WardenWorkAnchor
- LookoutAnchor
- BountyBoardAnchor
- PrepAnchor
- ReturnContextAnchor

Collision:
- segmented real doorway
- upper decorative silhouette need not be walkable

## Supply Cache

Center:
- (+19,-27)

Footprint:
- 7×6 m

Role:
- emergency/hunt supplies
- future quartermaster/service

Facade:
- south/west toward gate approach

Interior:
- simple supply room
- wall racks
- central clear lane

Anchors:
- EntranceAnchor
- SupplyUseAnchor
- QuartermasterAnchor
- EmergencyCacheAnchor
- RackSocket_01..04

## North Hunter Gate

Center:
- (0,-35)

Clear opening:
- 8 m

Current gate/Warden assets are migration references.

Future gate presentation should:
- feel rugged
- show warnings/preparation identity
- differ from civilian South Gate

## Exterior sockets

NW:
- bounty/route board
- hunter prep rack
- bench
- warning lantern/banner

NE:
- supply rack
- emergency cache
- route sign
- fence/wall termination

## Tests

- gate opening clear
- buildings within S05
- no building overlaps main spine
- anchors exist
- trail connector remains unobstructed
