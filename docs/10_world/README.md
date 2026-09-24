# 10_world — World, Settlements, Spatial Framework and Hunting Regions

Status: ACTIVE WORLD PACKAGE MAP / HUNT-01 BUILD MANIFEST + VALIDATION CONTRACT RECORDED / NO WORLD RUNTIME IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Own spatial/playable-world packages and world-specific application of shared gameplay systems.

Belongs here:
- world spatial framework and coordinates;
- settlement/frontier packages;
- hunting-region packages;
- sector topology;
- camps/safe anchors;
- tracking/evidence routes;
- persistent Monster routes;
- encounter-footprint placement;
- graybox geometry specifications;
- engine-neutral build manifests/data;
- local streaming adjacency/application.

Does not own generic combat/stat formulas, behavior-engine semantics, Crystal definitions, persistence implementation or final art standards.

## Current front doors

Shared spatial:
`spatial/README.md`.

Settlement 01:
`settlements/SETTLEMENT_01/README.md`.

Region 01:
`regions/REGION_01/README.md`.

## Shared coordinate baseline

Framework:
`spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`.

Major registry:
`spatial/FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md`.

Selected:
- `1 world unit = 1 meter`;
- +X East / +Y Up / -Z North / +Z South;
- separate local spaces for Settlement 01, Frontier and Region 01;
- stable anchor mappings connect spaces;
- all unbuilt numeric positions remain prototype targets unless explicitly locked.

## Region 01 Hunt-01 package chain

Spatial integration:
- `regions/REGION_01/FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_CONTRACT.md`;
- `regions/REGION_01/FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

Geometry:
- `regions/REGION_01/FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION.md`;
- `regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md`.

Build/validation:
- `regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.md`;
- `regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`;
- `regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.

Recorded proof:
`S00 -> S01 -> S03 -> R01_EF02 -> escape toward S05 -> reacquisition`.

Current physical targets include:
- 285–315 m required route;
- 58×54 m Ford basin;
- 34×18 m shallow water;
- 70×54 m EF02 floor;
- 10 tactical nodes / 14 links;
- physical cover;
- >=9 m Raker corridors;
- Monster/camera/streaming clearance/debug volumes.

The build manifest also records the reversible observation-ramp control `(-74.0,4.62,-237.5)` as BUILD ONLY, never gameplay/persistence authority.

## Root authorities

- `/MAP_WORLD_SETTLEMENT_STRUCTURE.md`;
- `/WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `/FIRST_SETTLEMENT_BLUEPRINT.md`;
- `/PERFORMANCE_BUDGETS_AND_CAPS.md`.

World packages apply shared owners rather than redefining them.

## Verification state

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_RECORDED = YES`
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION_RECORDED = YES`
`HUNT01_GRAYBOX_MANIFEST_STATIC_VALIDATOR_IMPLEMENTED = NO`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`WORLD_SPATIAL_RUNTIME_VERIFIED = NO`.

## Exact next world dependency

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_STATIC_VALIDATOR_IMPLEMENTATION`.

The next pass should validate build data/invariants only. It must not start production world implementation or claim runtime/phone evidence.
