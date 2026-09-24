# SETTLEMENT_01 — First Frontier Hunter Settlement

Status: ACTIVE FIRST-SETTLEMENT PACKAGE / SMITH SERVICE + PROTOTYPE SPATIAL ANCHORS RECORDED / NO GRAYBOX IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Own Settlement 01-specific spatial/service application of reusable systems.

Root spatial authority:
`/FIRST_SETTLEMENT_BLUEPRINT.md`.

Shared coordinate/dimension owner:
`/docs/10_world/spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`.

Concrete spatial registry:
`/docs/10_world/spatial/FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md`.

## Current first-slice service authority

`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.

The Smith/Workshop maps `CRAFT_STATION_WEAPON_WORKBENCH` into the physical Hunter Service Loop.

## Selected local spatial facts

Space:
`space_settlement_01`.

Prototype planning extent:
`X -100..+100 m`, `Z -10..+250 m`, primary walkable `Y ~0..+14 m`.

Origin:
`anchor_set01_hunter_gate_inner = (0,0,0) m`.

Key prototype anchors:
- Hunter Gate outer `(0,0,-10)`;
- Processing Yard `(-34,1,22)`;
- Smith center `(-22,3,42)`;
- Smith entry `(-16,3,34)`;
- Smith workbench `(-22,3,40)`;
- Storage/Loadout `(24,4,38)`;
- Hunter Lodge `(34,7,105)`;
- Market/Civic `(-34,7,105)`;
- Recovery/Inn `(20,12,175)`;
- upper Residential center `(-22,12,185)`;
- civilian/arrival gate `(0,7,242)`.

Gate->Smith workbench direct planning distance is ~45.7 m. The existing <=25-second walking target remains `UNVERIFIED` until a real graybox path/movement speed exists.

## Local dimensional targets

- Smith footprint ~16×22 m;
- processing yard ~28×24 m;
- storage/loadout ~16×20 m;
- Hunter Lodge ~28×32 m;
- market/civic plaza ~28×24 m;
- recovery/inn ~18×24 m;
- main Hunter Spine ~8 m;
- secondary street ~5 m;
- service alley ~3 m;
- Hunter Gate clear width ~7 m;
- defensive wall baseline ~7 m high.

All are prototype graybox targets unless another narrower authority says otherwise.

## Ownership boundary

Settlement 01 owns local service/route application. Shared spatial coordinates/dimension vocabulary live under `/docs/10_world/spatial/`. Crafting, Inventory, Progression and Persistence keep their own domain ownership.

## Verification boundary

`SETTLEMENT_01_SMITH_SERVICE_DESIGN_RECORDED = YES`
`SETTLEMENT_01_SPATIAL_TARGETS_RECORDED = YES`
`SETTLEMENT_01_GRAYBOX_IMPLEMENTED = NO`
`SETTLEMENT_01_RUNTIME_VERIFIED = NO`.