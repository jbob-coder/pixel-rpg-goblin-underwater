# BLD-04 — East Work District Support Buildings

Status: PROVISIONAL BLUEPRINT  
Section: `SET01_S04`

Covers:
- `SET01_BLD_WORK_STORAGE`
- `SET01_BLD_WORK_CANOPY`

## Work Storage

Center:
- (+24.5,+9.5)

Footprint:
- 7×6 m

Facade:
- west / toward frontage lane

Purpose:
- material/equipment storage
- loading
- future work-service support

Interior:
- single open storage room
- perimeter racks
- clear center lane

Doorway:
- 1.8 m target
- west facade

Anchors:
- EntranceAnchor
- ExitAnchor
- StorageUseAnchor
- WorkerIdleAnchor
- LoadingAnchor
- RackSocket_01..04

Collision:
- real segmented walls
- simple rack collision only where necessary

Exterior:
- cart/loading socket
- crate/material sockets
- lantern

## Work Canopy

Center:
- (+24.5,-9.5)

Footprint:
- 7×6 m

Purpose:
- open-air production/work
- material staging
- visible settlement activity

Structure:
- roof/canopy
- 4–6 support posts
- at least two open walk-through sides

Avoid converting it into a sealed building.

Anchors:
- WorkAnchor_01
- WorkAnchor_02
- MaterialRackAnchor
- CartAnchor
- WorkerIdleAnchor

Collision:
- posts
- workbench/rack only where meaningful
- no invisible wall around open edges

## Relationship to Smith

Smith is primary service building.
Storage/canopy support smith/work district visually and logistically.

Crafting state remains in future crafting/service owner, not these scenes.

## Tests

- both parcels within S04
- west frontage lane remains clear
- storage doorway passes
- canopy remains traversable
- no overlap with Smith
- anchor sets exist
