# 20_gameplay/harvest — Harvest Gameplay Package

Status: ACTIVE FIRST-SLICE DESIGN PACKAGE / BASELINE RECORDED / INVENTORY DOWNSTREAM RECORDED / NO HARVEST IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Own reusable rules that convert surviving physical Monster anatomy into finite recoverable materials.

Primary law:
**Harvest reads the real surviving anatomy state. It never creates disconnected random loot or more material than the physical source can still contain.**

## File map

- `README.md` — this local front door.
- `FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md` — authoritative finite-capacity, condition, sever-transfer, depletion, persistence and anti-duplication rules.
- `HARVEST_TRANSACTION_EXAMPLE.md` — supporting worked arithmetic example only; not a separate owner.

## Supporting/downstream authorities

- `/MECHANICAL_SYSTEMS_GUIDE.md` — anatomy -> harvest -> inventory -> crafting relationship.
- `/CONTENT_DATA_GUIDE.md` — material/harvest-source schema and stable IDs.
- `/docs/20_gameplay/combat/DEFEAT_RETREAT_BASELINE_CONTRACT.md` — Monster dead/escaped/mutual-terminal state before harvest.
- `../inventory/FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT.md` — owns material after committed harvest output becomes a recovery bundle and transfers toward player inventory.
- Monster packages configure concrete source capacities/material IDs without redefining generic harvest math.

## First content consumer

Monster 01:
`/docs/30_content/monsters/MONSTER_01/HARVEST_CAPACITY_PACKET.md`.

Prototype selected source total when pristine:
`45` capacity units.

Sources:
horn L 4 / horn R 4 / dorsal plates 8 / torso hide 12 / distal-tail ridge 5 / distal-tail tendon 4 / dense bone 8.

## Generic selected rules

Condition bands and preservation multipliers:
PRISTINE 1.00 / GOOD 0.90 / DAMAGED 0.70 / POOR 0.40 / RUINED 0.10 / DESTROYED 0.00.

`surviving_capacity = floor(original_capacity * preservation_multiplier)`.

Recovery efficiency is deterministic and capped at `<=1.00`.

Clean sever transfers source lineage and never adds matter. Partial harvest removes only successfully recovered quantity and persists through save/region reload.

## Ownership

Harvest owns source capacity/condition, physical harvest containers, extraction efficiency, depletion, source lineage and yield transaction.

Inventory owns the recovered material after the committed harvest transaction establishes a `RECOVERY_BUNDLE` owner. Inventory rejection does not restore the anatomy source.

Harvest does not own recipes/economy, party reward sharing or final art/animation.

## Current status

`FIRST_SLICE_HARVEST_BASELINE_RECORDED = YES`
`MONSTER_01_HARVEST_PACKET_RECORDED = YES`
`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_RECORDED = YES`
`HARVEST_RUNTIME_IMPLEMENTED = NO`
`HARVEST_RUNTIME_VERIFIED = NO`.

## Exact next downstream dependency

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT`

Harvest itself is no longer waiting on inventory ownership design. The next vertical-slice design packet should consume inventory-owned material through one deterministic recipe/equipment improvement.
