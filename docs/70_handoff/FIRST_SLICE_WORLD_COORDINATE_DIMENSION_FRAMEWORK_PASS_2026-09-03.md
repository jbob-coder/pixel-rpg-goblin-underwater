# First-Slice World Coordinate / Dimension Framework Pass — 2026-09-03

Status: BOUNDED WORLD/SPATIAL DESIGN PASS COMPLETE / NO GRAYBOX OR RUNTIME IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT`

This pass implements the user's new direction to begin building/documenting in-game dimensions and coordinates while preserving the existing world topology and explicit design-vs-runtime verification boundary.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md` after Persistence closure;
- `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `MAP_WORLD_SETTLEMENT_STRUCTURE.md`;
- `FIRST_SETTLEMENT_BLUEPRINT.md`;
- `docs/10_world/README.md`;
- Settlement 01 local package/Smith service;
- Region 01 README/topology/encounter/streaming/acceptance authorities;
- Hunter Base 01 proportion/axis authority;
- Monster 01 body-dimension authority;
- first-slice Persistence owner.

## New spatial package

Front door:
`docs/10_world/spatial/README.md`.

Framework authority:
`docs/10_world/spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`.

Concrete registry:
`docs/10_world/spatial/FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md`.

## Measurement / axes

Adopted existing locked convention:
`1 world unit = 1 meter`.

Selected world/map frame:
- +X East;
- +Y Up;
- -Z North / outbound wilderness;
- +Z South / settlement-inbound.

Heading:
0° North, 90° East, 180° South, 270° West.

Hunter Base 01's local +Z-forward frame remains model-local and maps through actor heading; it does not conflict with world +Z South.

## Major local spaces

Selected:
- `space_settlement_01`;
- `space_frontier_01`;
- `space_region_01`.

All use the same axis orientation but independent origins.

Persistence therefore stores `space ID + local XYZ + orientation + stable anchor/sector references` rather than requiring huge global coordinates.

## Settlement 01 prototype plan

Selected planning envelope:
- X -100..+100 m;
- Z -10..+250 m;
- primary walkable Y approximately 0..+14 m;
- 200 m × 260 m plan.

This fits the existing more-specific Settlement Blueprint range of approximately 220–280 m long × 160–230 m short.

Origin:
`anchor_set01_hunter_gate_inner = (0,0,0) m`.

Recorded major anchors include:
- Hunter Gate outer `(0,0,-10)`;
- Processing Yard `(-34,1,22)`;
- Smith center `(-22,3,42)`;
- Smith entry `(-16,3,34)`;
- Smith workbench `(-22,3,40)`;
- Storage/Loadout `(24,4,38)`;
- Hunter Lodge `(34,7,105)`;
- Market/Civic `(-34,7,105)`;
- Recovery/Inn `(20,12,175)`;
- Residential center `(-22,12,185)`;
- civilian/arrival gate `(0,7,242)`.

Gate-to-Smith workbench direct planning distance is about 45.7 m. This makes the <=25-second path target plausible but remains unverified until actual graybox movement/path measurement.

## Built-scale targets

Recorded prototype dimensions include:
- Hunter: locked 1.75 m;
- Smith: 16×22 m footprint;
- Smith internal clear height ~5.5 m;
- Smith service door ~2.4 m wide × 3.0 m high;
- processing yard 28×24 m;
- storage/loadout 16×20 m;
- Hunter Lodge 28×32 m;
- market plaza 28×24 m;
- recovery/inn 18×24 m;
- main Hunter Spine ~8 m;
- secondary street ~5 m;
- service alley ~3 m;
- gate clear width ~7 m;
- defensive wall baseline ~7 m high.

## Frontier transition

`space_frontier_01` prototype:
- ~80 m centerline length;
- ~12 m normal clear width;
- ~8 m minimum choke;
- up to ~18 m watch/supply widening;
- ~4 m total elevation drop toward Region 01.

Anchors:
- gate outer `(0,0,0)`;
- pass exit `(0,-1,-14)`;
- watch/supply `(6,-2,-42)`;
- Region handoff `(0,-4,-80)`.

## Region 01 coordinate layout

`space_region_01` origin:
`anchor_r01_entry = (0,0,0)`.

Sector centers:
- S00 `(0,0,-35)`;
- S01 `(-90,-3,-130)`;
- S02 `(75,2,-135)`;
- S03 `(-35,4,-245)`;
- S04 `(-45,22,-365)`;
- S05 `(80,-4,-265)`;
- S06 `(70,18,-395)`.

Canonical connected center distances are approximately 117–165 m, matching Region 01's existing ~100–180 m characteristic-sector direction.

The deepest sector center is ~401.6 m from entry; planning envelopes extend the Region footprint to roughly the mid-400-meter range.

All 11 canonical Region topology links have planning route anchors. No new adjacency was created.

Sector envelopes remain technical planning aids, not visible square arenas or teleport boundaries.

## Encounter footprints

Recorded centers/envelopes:
- EF01 Riverbank Ford `(-92,-4,-145)`, 52×46 m;
- EF02 Meadow Edge `(-45,4,-250)`, 76×60 m;
- EF03 Root/Boulder Hollow `(43,0,-205)`, 58×52 m;
- EF04 Deep Nest Shelf `(70,19,-405)`, 68×56 m.

All fit the current broad 30–90 m footprint guidance.

Exact tactical nodes, cover positions and Monster anchors remain for the next Region graybox-integration pass.

## Verification boundary

Internal design consistency checked:
- Settlement selected dimensions lie inside accepted blueprint ranges;
- canonical Region center distances lie inside/near the existing sector-size design direction;
- no topology edge was added/removed;
- encounter envelopes remain inside broad current footprint guidance;
- major-space coordinates consume existing meter convention.

No graybox/runtime/phone verification is claimed.

`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_RECORDED = YES`
`WORLD_SPATIAL_GRAYBOX_IMPLEMENTED = NO`
`WORLD_SPATIAL_RUNTIME_VERIFIED = NO`
`SPATIAL_COORDINATES_PHONE_VERIFIED = NO`.

## Exact next bounded action

`FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_CONTRACT`

That next pass should consume this registry to define one representative first-slice physical pursuit chain through Region 01, including evidence anchors, player route choice, Monster route/position anchors, engagement location, footprint tactical-node plan, escape/reacquisition mapping and path-length/visibility acceptance targets. It remains a graybox/integration design contract until implementation gates allow actual production-domain work.