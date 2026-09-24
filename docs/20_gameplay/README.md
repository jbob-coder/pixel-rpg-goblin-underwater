# 20_gameplay — Gameplay Systems

Status: ACTIVE GAMEPLAY DESIGN MAP / COMBAT + HARVEST + INVENTORY + CRAFT/EQUIP + SMITH SERVICE LINK RECORDED / PERSISTENCE NEXT
Last reconciled: 2026-09-03

## Purpose

Own reusable gameplay rules across settlements, regions, monsters and content packages. The game is the objective; this package prevents individual content or UI from silently redefining generic mechanics.

## Package map

### Combat
Front door: `combat/README.md`.
Nine generic first-slice combat/outcome contracts are recorded through Defeat/Retreat.

### Harvest
Front door: `harvest/README.md`.
Authority: `harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`.

### Inventory
Front door: `inventory/README.md`.
Authority: `inventory/FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT.md`.

### Crafting
Front door: `crafting/README.md`.
Authority: `crafting/FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT.md`.

First recipe:
`recipe_field_poleblade_raker_tendon_grip`.

Inputs:
2 HIGH tail tendon + 2 STANDARD-or-better hide.

Output/effect:
Raker-Tendon Grip refinement; Placed Hew Stamina 18 -> 16 through typed `COST_MODIFIER` only.

### Progression
Front door: `progression/README.md`.
Direction remains equipment + mastery + knowledge weighted, with bounded specialization.

## Physical Smith service integration

World owner:
`/docs/10_world/settlements/SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.

Selected physical proof:
- `CRAFT_STATION_WEAPON_WORKBENCH` maps to Settlement 01 Smith/Workshop;
- workbench sits on the Hunter Service Loop near the gate/processing route;
- return-path graybox target <=25 seconds normal walking from gate return threshold;
- service remains available in normal Settlement state without requiring one NPC at one anchor;
- opening/previewing/canceling mutates nothing;
- Confirm submits the normal authoritative Craft request;
- UI/Settlement/NPC logic may not consume materials or write refinements.

## First-slice ownership chain

```text
COMBAT DAMAGE/SEVER
-> FINAL ANATOMY STATE
-> DEFEAT/ESCAPE OUTCOME
-> HARVEST SOURCE CAPACITY/CONDITION
-> RECOVERY BUNDLE
-> PLAYER MATERIAL INVENTORY
-> RETURN THROUGH SETTLEMENT GATE
-> PHYSICAL SMITH/WORKBENCH INTERACTION
-> CRAFT RESERVATION/ATOMIC COMMIT
-> FIELD POLEBLADE REFINEMENT
-> SHARED EFFECT PIPELINE
-> NEXT-HUNT TACTICAL DIFFERENCE
```

No downstream package may manufacture matter, replay a committed transaction, or silently rewrite upstream physical truth.

## Verification state

`COMBAT_DESIGN_BASELINE_COMPLETE = YES`
`FIRST_SLICE_HARVEST_BASELINE_RECORDED = YES`
`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_RECORDED = YES`
`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_RECORDED = YES`
`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_RECORDED = YES`.

Runtime gameplay remains unimplemented/unverified beyond the existing Stage-1 engine probe.

## Exact next gameplay/system dependency

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT`

That pass should define one authoritative first-slice save/reload boundary across player/world/Monster/hunt/anatomy/harvest/Inventory/crafting/refinement/Settlement state and transaction ledgers before broader content expansion.
