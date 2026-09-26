# 10_world — World, Settlements, Spatial Framework and Hunting Regions

Status: ACTIVE WORLD DOCUMENTATION MAP / CURRENT COMPACT WORLD + LEGACY REGION-01 PROVENANCE  
Last reconciled: 2026-09-25

## Purpose

Own world, settlement, Region, spatial, and streaming design packages without replacing live runtime world ownership.

Current production world implementation lives primarily under:

`game/scripts/presentation/pixel_rpg/`

Important current owners include:

- `world_base_001.gd`;
- `world_paths_001.gd`;
- `world_settlement_core_001.gd`;
- `world_gate_props_001.gd`;
- `world_trail_environment_001.gd`;
- `world_actor_presentation_001.gd`;
- `world_pack_004_enterable_smith.gd`.

## Current world distinction

Two world lineages coexist:

1. **Current compact first-person Pixel RPG world** — current app boot/runtime authority.
2. **Region-01 Hunt-01 graybox** — still real/tested legacy integration and regression provenance, but not current app boot/spatial authority.

Do not apply Region-01 absolute coordinates directly to the compact first-person world.

## Package map

- `spatial/` — historical/shared first-slice coordinate framework and registries;
- `settlements/` — settlement design packages and older Settlement-01 planning contracts;
- `regions/` — hunting-region packages, including the implemented/tested Region-01 graybox lineage.

## Current compact-world rule

Current compact-world transforms/collision come from live source/tests.

Documentation may describe:

- intended sections;
- settlement structure;
- streaming boundaries;
- service locations;
- world-scale constraints.

It does not become runtime transform authority merely by recording coordinates.

## Region-01 rule

Region 01 remains valuable for:

- tracking/encounter integration;
- tactical/combat-domain regression;
- graybox geometry history;
- manifest/projection validation.

It is not the current first-person compact-world layout.

Current-world combat positioning must use an explicit adapter rather than offsetting the legacy tactical graph.

## Settlement rule

The current enterable smith is the strongest implemented building-pattern reference.

Generic current settlement buildings still use monolithic collision despite visual doors.

Older `SETTLEMENT_01` planning coordinates remain design provenance unless current source explicitly adopts them.

## Streaming/section direction

Current section/streaming work is planned through the current issue register.

Do not infer implemented streaming merely from older world-design documents.

## Verification boundary

Keep separate:

- world design recorded;
- source implementation;
- headless/runtime verification;
- Android build verification;
- physical-device acceptance.

Use live source/tests for implementation truth.
