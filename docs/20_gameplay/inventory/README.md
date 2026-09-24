# 20_gameplay/inventory — Material Ownership Package

Status: ACTIVE FIRST-SLICE DESIGN PACKAGE / BASELINE + CRAFT/SMITH CONSUMER RECORDED / NO INVENTORY IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Own reusable first-slice material-container, stack, transfer, quantity-conservation, provenance and save/load rules between harvesting and crafting.

Primary law:
**a committed material quantity always has exactly one authoritative owner.**

## Local authorities

- `FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT.md` — material ownership/transfer authority.
- `INVENTORY_TRANSFER_EXAMPLE.md` — supporting worked example.

Upstream:
`../harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`.

Downstream:
- `../crafting/FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT.md`;
- `/docs/10_world/settlements/SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.

## Selected first-slice model

- primary material destination `PLAYER_FIELD_INVENTORY`;
- prototype 20 stack entries;
- max 99 units per stack;
- visible stack key `material_id + quality_band`;
- provenance preserved internally as lots;
- harvested output first belongs to persistent `RECOVERY_BUNDLE`;
- partial/full inventory rejection preserves exact bundle remainder;
- `SOURCE_LOSS == DESTINATION_GAIN`;
- stable transfer IDs are idempotent across UI/save/load.

## First craft/Smith consumer

Recipe:
`recipe_field_poleblade_raker_tendon_grip`.

Consumes only material already owned by `PLAYER_FIELD_INVENTORY`:
- 2 HIGH tail tendon;
- 2 STANDARD-or-better hide.

The physical Settlement 01 Smith service may preview/submit the Craft request, but it cannot directly mutate Inventory.

## Verification boundary

`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_RECORDED = YES`
`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_RECORDED = YES`
`INVENTORY_RUNTIME_IMPLEMENTED = NO`
`INVENTORY_RUNTIME_VERIFIED = NO`.

## Exact next cross-system dependency

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT`

The next pass must preserve stacks, provenance, recovery bundles and transfer ledgers together with Monster/harvest/crafting/Settlement state so reload cannot restore or duplicate material.
