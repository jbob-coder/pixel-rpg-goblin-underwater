# 20_gameplay/crafting — Crafting & Equipment Linkage

Status: ACTIVE FIRST-SLICE DESIGN PACKAGE / ONE RECIPE + PHYSICAL SMITH SERVICE LINK RECORDED / NO CRAFTING IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Own the smallest deterministic bridge from conserved Monster materials in inventory to one meaningful equipment improvement.

Primary law:

**Crafting consumes real authoritative inventory material and produces one authoritative equipment/refinement state. It cannot mint materials, replay a transaction, or bypass the existing equipment/effect pipeline.**

## Local authority

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT.md`.

## Physical service consumer

Settlement 01 world owner:
`/docs/10_world/settlements/SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.

That contract maps logical station capability:
`CRAFT_STATION_WEAPON_WORKBENCH`
into the actual walkable Smith/Workshop.

Important ownership split:
- Settlement/world validates physical access/service availability;
- Crafting validates/commits the recipe;
- Inventory owns material quantity/quality/provenance;
- Equipment owns the Poleblade refinement/effect;
- UI only previews/requests/displays.

## First-slice selected recipe

Recipe ID:
`recipe_field_poleblade_raker_tendon_grip`.

Requirements:
- `2 x material_m01_tail_tendon` at HIGH quality;
- `2 x material_m01_hide` at STANDARD quality or better;
- compatible Field Poleblade instance;
- valid `CRAFT_STATION_WEAPON_WORKBENCH` context.

Refinement:
`refinement_field_poleblade_raker_tendon_grip`.

Effect:
- typed `COST_MODIFIER`;
- target `POLEBLADE_PLACED_HEW` Stamina;
- prototype 18 -> 16;
- no AP/damage/hit-quality/sever/Initiative/reaction/Max-Stamina bonus.

## Transaction law

Craft commit is atomic/idempotent:
- deterministic input selection;
- reserve exact eligible lots before mutation;
- validate station + target weapon + inventory;
- consume exact inputs and apply exactly one refinement together;
- failure before commit consumes nothing;
- repeat transaction ID cannot replay.

The Smith interaction may not implement a second copy of these rules.

## Verification boundary

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_RECORDED = YES`
`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_RECORDED = YES`
`CRAFTING_RUNTIME_IMPLEMENTED = NO`
`CRAFTING_RUNTIME_VERIFIED = NO`.

## Exact next cross-system dependency

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT`

That next packet should unify the already-recorded persistence/anti-replay requirements across Monster identity, harvest depletion, recovery bundles, Inventory transfers, crafting/refinement, Settlement service state and player/world continuity without starting production code.
