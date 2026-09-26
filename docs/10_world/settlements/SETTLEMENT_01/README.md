# SETTLEMENT_01 — First Frontier Hunter Settlement

Status: ACTIVE FIRST-SETTLEMENT PACKAGE / LIVE G00–G17 FOUNDATION + C00 WORLD-SELECTION SEAM
Last reconciled: 2026-09-26

## Purpose

Own Settlement 01-specific spatial/service application of reusable systems.

## Current layout authority

Runtime layout contract:
`/game/scripts/world/settlement/settlement_01_layout_contract.gd`.

Canonical A01–A12 visual legend:
`SETTLEMENT_01_AREA_VISUAL_LEGEND.md`.

For current Settlement 01 area identity, numbering, bounds, section membership and visual-reference generation, use those two sources together. `A01–A12` are the twelve visual/design areas. `S01–S05` are runtime/streaming sections. Colors are optional planning aids only and are not area identity.

The current active layout spans approximately `X -30..30 m`, `Z -36..34 m`. `A04` is the shared Main Central Spine and intentionally has no single parent section.

## Current implementation boundary

The live repository contains the Settlement 01 layout contract and isolated graybox/runtime foundation through G17, plus the C00 world-selection seam. The legacy compact world remains the default player-facing world; Settlement 01 remains a non-default candidate during integration.

## Current first-slice service authority

`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.

The Smith/Workshop maps `CRAFT_STATION_WEAPON_WORKBENCH` into the physical Hunter Service Loop.

## Historical prototype spatial record

The values below predate the current A01–A12 layout contract. They are retained as historical planning/provenance and must not override the live layout contract or the canonical visual legend.

Historical root spatial authority:
`/FIRST_SETTLEMENT_BLUEPRINT.md`.

Shared coordinate/dimension owner:
`/docs/10_world/spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`.

Concrete spatial registry:
`/docs/10_world/spatial/FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md`.

Historical prototype planning extent:
`X -100..+100 m`, `Z -10..+250 m`, primary walkable `Y ~0..+14 m`.

Historical origin:
`anchor_set01_hunter_gate_inner = (0,0,0) m`.

Historical key prototype anchors:
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

Historical Gate->Smith workbench direct planning distance is ~45.7 m. These historical values are not current A01–A12 geometry.

## Historical local dimensional targets

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

These remain provenance unless corroborated by current runtime geometry.

## Ownership boundary

Settlement 01 owns local service/route application. Shared spatial coordinates/dimension vocabulary live under `/docs/10_world/spatial/`. Crafting, Inventory, Progression and Persistence keep their own domain ownership.

## Visual-reference correction rule

Any earlier generated image that conflicts with `SETTLEMENT_01_AREA_VISUAL_LEGEND.md` in numbering, area geometry, section grouping, or the one-area-per-image rule is superseded/reference-only until corrected and explicitly approved.

## Verification boundary

`SETTLEMENT_01_A01_A12_LAYOUT_CONTRACT = PRESENT`
`SETTLEMENT_01_G00_G17_FOUNDATION = PRESENT`
`SETTLEMENT_01_C00_WORLD_SELECTION_SEAM = PRESENT`
`SETTLEMENT_01_DEFAULT_PLAYER_WORLD = NO`
`SETTLEMENT_01_12_VISUAL_AREAS_APPROVED = NO`
