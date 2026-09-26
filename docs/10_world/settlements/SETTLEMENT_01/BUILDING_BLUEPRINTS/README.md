# Settlement 01 — Building Blueprint Package

Status: PROVISIONAL BUILDING DESIGN / DOCUMENTATION ONLY  
Created: 2026-09-25

Purpose: turn the Settlement 01 parcel plan into repeatable first-person building contracts before runtime implementation.

## Current blueprint set

1. `BLD_01_COMMUNITY_HALL.md`
2. `BLD_02_RESIDENCE_TYPE_A.md`
3. `BLD_03_SOUTH_GATEHOUSE.md`

Current implemented comparison reference:

`game/scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd`

The enterable smith remains the strongest runtime example for:
- segmented collision;
- real doorway;
- interior floor;
- stable entrance/use anchors;
- first-person roof handling.

## Common building contract

Every important building blueprint must define:

- stable building ID;
- owning settlement section;
- parcel center;
- footprint;
- facade/frontage;
- real doorway geometry;
- wall/collision segmentation;
- interior walkable area;
- EntranceAnchor;
- ExitAnchor;
- service/interaction anchors;
- NPC anchors;
- prop sockets;
- roof/ceiling behavior;
- photo/reference requirements;
- automated test requirements;
- migration/implementation notes.

## Local-coordinate convention

Each building uses a local origin at the center of its ground footprint.

- local +X = building right when facing its primary facade
- local -X = building left
- local +Z / -Z are documented per building orientation
- Y 0 = building floor

Every blueprint must state which world direction the facade faces.

## Blueprint status

These are planning blueprints, not current runtime assets.

Values may change after first-person graybox testing, but any change must update:
- settlement parcel plan;
- door/frontage clearance;
- collision;
- anchors;
- minimap;
- section ownership;
- focused tests.
