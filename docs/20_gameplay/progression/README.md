# Progression Package — Gameplay Authority

Status: ACTIVE PACKAGE GUIDE / FIRST-SLICE CRAFTED REFINEMENT + PHYSICAL SMITH ACCESS RECORDED / DESIGN ONLY
Last reconciled: 2026-09-03

## Purpose

Own generic player-power progression rules across hunts, regions, settlements and equipment content.

Primary progression authority:
`PLAYER_PROGRESSION_AND_EQUIPMENT_SYSTEM.md`.

Related authorities:
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md` — typed modifier pipeline;
- `/MECHANICAL_SYSTEMS_GUIDE.md` — hunt/combat/harvest/crafting relationship;
- `/CONTENT_DATA_GUIDE.md` — stable-ID/data direction;
- `../crafting/FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT.md` — first concrete material-to-equipment proof;
- `/docs/10_world/settlements/SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md` — physical service access.

## Core rule

**Progression should widen and deepen tactical options faster than it increases raw numeric power.**

## First-slice crafted progression proof

Recipe:
`recipe_field_poleblade_raker_tendon_grip`.

Refinement:
`refinement_field_poleblade_raker_tendon_grip`.

Material logic:
- HIGH Mudcrest Raker distal-tail tendon rewards controlled anatomy preservation;
- STANDARD-or-better Raker hide supplies grip/binding material;
- exact Inventory lots are consumed atomically.

Effect:
`POLEBLADE_PLACED_HEW` Stamina 18 -> 16 through typed `COST_MODIFIER`.

The result is intentionally not a raw damage/item-level upgrade.

## Physical service proof

The refinement is accessed through the actual Settlement 01 Smith/weapon workbench, not a global abstract crafting button.

The service:
- is physically on the Hunter Service Loop;
- revalidates a stable Field Poleblade instance on Confirm;
- does not let UI/NPC/Settlement state directly write equipment power.

## Verification boundary

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_RECORDED = YES`
`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_RECORDED = YES`
`PROGRESSION_RUNTIME_IMPLEMENTED = NO`
`CRAFTING_RUNTIME_IMPLEMENTED = NO`.

## Exact next dependency

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT`

That pass must preserve the crafted refinement and its transaction result across save/reload together with the material/Monster/world state that produced it.
