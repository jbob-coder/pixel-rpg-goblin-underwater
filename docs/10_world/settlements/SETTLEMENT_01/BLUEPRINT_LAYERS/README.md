# Settlement 01 — Layered Blueprint Package

Status: PROVISIONAL DESIGN BLUEPRINT / DOCUMENTATION ONLY  
Created: 2026-09-25

This package decomposes the planned five-section Settlement 01 into explicit layers so geometry, streets, buildings, interiors, gameplay anchors, collision, streaming, art and performance can be implemented independently without creating conflicting truth.

## Planning authority

Approved topology:
- S01 South Gate / Arrival
- S02 Central Plaza / Market
- S03 West Residential / Local NPC building
- S04 East Work District / Smith + storage
- S05 North Hunter Exit / trail transition

Provisional envelope:
- X: -30..+30 m
- Z: -36..+34 m
- nominal ground Y: 0 m
- total plan: 60 × 70 m

These are documentation planning coordinates, not current runtime constants.

## Layer order

0. `LAYER_00_COORDINATE_SCALE_AND_RULES.md`
1. `LAYER_01_SECTION_LAYOUT_AND_CONNECTORS.md`
2. `LAYER_02_STREETS_AND_CIRCULATION.md`
3. `LAYER_03_BUILDING_PARCELS_AND_FOOTPRINTS.md`
4. `LAYER_04_INTERIORS_AND_ANCHORS.md`
5. `LAYER_05_STREETSCAPE_CORNERS_AND_PROPS.md`
6. `LAYER_06_NPCS_SERVICES_AND_ACTIVITY.md`
7. `LAYER_07_COLLISION_AND_NAVIGATION.md`
8. `LAYER_08_STREAMING_AND_SECTION_OWNERSHIP.md`
9. `LAYER_09_MINIMAP_SIGNAGE_AND_WAYFINDING.md`
10. `LAYER_10_ART_ASSET_AND_PHOTO_BLUEPRINT_QUEUE.md`
11. `LAYER_11_PERFORMANCE_LOD_AND_VISIBILITY.md`
12. `LAYER_12_MIGRATION_AND_IMPLEMENTATION_SEQUENCE.md`

## Core rule

Later layers may refine implementation details but must not silently change earlier spatial ownership.

Any coordinate change must update:
- section ownership;
- connectors;
- building parcel;
- collision;
- anchors;
- minimap;
- tests.

## Current-world firewall

Current production geometry remains authoritative until a later implementation issue migrates it.

This package does not move runtime objects by itself.
