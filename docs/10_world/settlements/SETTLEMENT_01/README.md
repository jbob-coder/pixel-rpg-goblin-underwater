> **CURRENT PIXEL RPG SETTLEMENT-01 STATUS — 2026-09-26**
>
> Current production `main@abeeda02568a4e7b9a36d9dd9ee381d1539cdc67` implements and verifies the isolated Settlement 01 foundation through **G17**.
>
> G16 adds conservative section lifecycle/streaming intent. G17 adds a versioned stable-ID Settlement 01 durable-world snapshot boundary. Neither performs production-world cutover; G16 does not unload scene nodes and G17 does not write save files.
>
> Corrected G17 canonical CI run `36268786947` passed full verification and Android export after one legitimate JSON canonicalization defect was fixed.
>
> The existing compact first-person prototype remains the current player-facing world. Creator-final visual approval remains 0/12 and rebuilt-settlement phone acceptance remains unverified.
>
> Current runtime status: `SETTLEMENT_01_RUNTIME_STATUS_G00_G17_2026-09-26.md`
>
> Production cutover plan: `SETTLEMENT_01_PRODUCTION_CUTOVER_PLAN_2026-09-26.md`
>
> Older first-slice coordinates and old “NO GRAYBOX IMPLEMENTATION” statements below are historical provenance only.

Current planning report: `CURRENT_SETTLEMENT_ASSET_AND_BUILDOUT_REPORT_2026-09-25.md`

# SETTLEMENT_01 — First Frontier Hunter Settlement

Status: ACTIVE FIRST-SETTLEMENT PACKAGE / G00–G17 ISOLATED RUNTIME VERIFIED / PRODUCTION CUTOVER PENDING
Last reconciled: 2026-09-03

## Purpose

Own Settlement 01-specific spatial/service application of reusable systems.

Root spatial authority:
`/FIRST_SETTLEMENT_BLUEPRINT.md`.

Shared coordinate/dimension owner:
`/docs/10_world/spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`.

Concrete spatial registry:
`/docs/10_world/spatial/FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md`.

## Layered settlement blueprint

Master blueprint:

`SETTLEMENT_01_MASTER_LAYERED_BLUEPRINT_2026-09-25.md`

Layer package:

`BLUEPRINT_LAYERS/`

The package defines the provisional 60×70 m settlement in 13 layers: coordinates, sections, streets, parcels, interiors, props/corners, NPC/services, collision/navigation, streaming ownership, minimap/wayfinding, art/photo asset queue, performance/LOD, and migration sequencing.

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
`SETTLEMENT_01_ISOLATED_FOUNDATION_G00_G17_IMPLEMENTED = YES`
`SETTLEMENT_01_G16_STREAMING_LIFECYCLE_VERIFIED = YES`
`SETTLEMENT_01_G17_PERSISTENCE_HOOKS_VERIFIED = YES`
`SETTLEMENT_01_PRODUCTION_WORLD_CUTOVER = NO`
`SETTLEMENT_01_DISK_SAVE_LOAD_IMPLEMENTED = NO`
`SETTLEMENT_01_CREATOR_FINAL_ART_APPROVAL = 0_OF_12`.

## Runtime graybox implementation plan

`SETTLEMENT_01_RUNTIME_GRAYBOX_IMPLEMENTATION_PLAN_2026-09-26.md`

This converts the locked 12-area settlement into bounded runtime passes G00–G17 while preserving:
- first-person authority;
- current Smith functionality;
- explicit collision ownership;
- stable section/area/building IDs;
- one-pass-at-a-time migration;
- separate Android/device acceptance.
