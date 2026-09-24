# 10_world/spatial — Coordinate and Dimension Authority

Status: ACTIVE FIRST-SLICE SPATIAL DESIGN PACKAGE / MAJOR COORDINATES + HUNT-01 BUILD APPLICATION RECORDED / NO GRAYBOX RUNTIME IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Own the shared meter-based reference used to build Settlement 01, Frontier, Region 01 and encounter footprints without incompatible local scale/axis assumptions.

Primary law:
**all first-slice world geometry uses one documented measurement/axis vocabulary, while each major streamed area owns a stable local coordinate space.**

## Local authorities

- `FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md` — shared coordinate/origin/dimension rules;
- `FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md` — major spaces, Settlement/Frontier/Region sector and footprint coordinates.

## Region-specific application

Content-specific evidence/tactical/build coordinates stay local to the Region/hunt package.

Current Region 01 Hunt-01 chain:
- `/docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md` — stable Hunt/evidence/node/Monster coordinates;
- `/docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md` — primitive dimensions/volumes;
- `/docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.md` — human build mapping;
- `/docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json` — machine build mapping;
- `/docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md` — package validation rules.

This keeps shared world/sector/footprint coordinates global and local build controls local.

## Selected spatial model

Measurement:
`1 world unit = 1 meter`.

Axes:
- `+X = EAST`;
- `+Y = UP`;
- `-Z = NORTH / outbound wilderness`;
- `+Z = SOUTH / settlement-interior`.

Major local spaces:
- `space_settlement_01`;
- `space_frontier_01`;
- `space_region_01`.

Persistence stores space ID + local XYZ + orientation + stable anchor/sector references.

## Current dimension references

- Hunter Base 01 = 1.75 m `LOCKED/CURRENT`;
- Monster 01 = ~6.6 m long / ~3.0 m shoulder-body `PROTOTYPE TARGET`;
- Settlement 01 = 200×260 m prototype planning envelope;
- Frontier = ~80 m centerline;
- Region 01 linked sector centers = ~117–165 m apart;
- Hunt-01 required route target = 285–315 m;
- River Ford basin = 58×54 m;
- EF02 working floor = 70×54 m;
- Raker-required route width = >=9 m where specified;
- first Charge clear lane = ~48 m × >=9 m.

Build-only observation-ramp midpoint:
`(-74.0,4.62,-237.5)`.

Classification:
`PROTOTYPE_BUILD_CONTROL_NOT_GAMEPLAY_ANCHOR`.

## Precision/status rule

Stable/unbuilt layout coordinates normally use nearest-meter precision. Decimals are reserved for meaningful dimensions or explicit construction controls such as Hunter height, Monster length, water depth and the ramp grade-control point.

A build-control coordinate is not automatically promoted to stable gameplay/persistence identity.

## Status

`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_RECORDED = YES`
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_RECORDED = YES`
`HUNT01_GRAYBOX_MANIFEST_STATIC_VALIDATOR_IMPLEMENTED = NO`
`WORLD_SPATIAL_GRAYBOX_IMPLEMENTED = NO`
`WORLD_SPATIAL_RUNTIME_VERIFIED = NO`
`SPATIAL_COORDINATES_PHONE_VERIFIED = NO`.

## Exact downstream dependency

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_STATIC_VALIDATOR_IMPLEMENTATION`.

Next should verify the machine manifest/source-coordinate consistency before any engine graybox is created.
