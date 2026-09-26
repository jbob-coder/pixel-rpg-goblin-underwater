# 20_gameplay — Gameplay Systems

Status: ACTIVE GAMEPLAY MAP / DETERMINISTIC COMBAT IMPLEMENTED / HARVEST-INVENTORY-CRAFTING-PERSISTENCE PARTIAL OR DESIGN  
Last reconciled: 2026-09-25

## Purpose

Own reusable gameplay rules across worlds, settlements, Monsters, and content packages.

Generic mechanics belong here conceptually; exact current runtime behavior is proven by `game/scripts/gameplay/` and its tests.

## Current implementation split

### Combat — implemented deterministic runtime lineage

Current source includes live owners for:

- turn/round/activation scheduling;
- AP/RP/Stamina;
- tactical movement;
- reaction windows;
- Hunter attack;
- Hunter defense consequence;
- Hunter health/injury;
- status application/timing;
- encounter outcome;
- Mudcrest anatomy/attacks/wound-contact;
- tracking and encounter triggering.

Runtime source:

`game/scripts/gameplay/`

Current first-person boot does **not** expose the entire Hunt-01 stack yet.

### Harvest — design/provenance

Finite-capacity anatomy-derived harvest contracts are recorded.

Broad current-world harvest runtime is not implemented.

### Inventory — design/provenance

Material ownership/transfer contracts are recorded.

Broad current-world inventory runtime is not implemented.

### Crafting — design/provenance

One-recipe/craft/equipment linkage is recorded.

Current first-person smith interaction does not yet provide full crafting.

### Progression — design/provenance

Progression/equipment direction remains useful design input.

Do not infer a completed current progression runtime from these documents.

## Current first-person combat boundary

Current player-facing path:

Observe/Engage  
→ targeting preview  
→ anatomy target selection/lock  
→ Combat Bridge 002  
→ initialize Mudcrest anatomy + combat turn shell  
→ no attack yet.

The proven deterministic combat domain should be adapted into the current world rather than duplicated in presentation code.

## Ownership law

- combat domain owns combat truth;
- Monster anatomy owner owns anatomy integrity;
- presentation/HUD may request/display but not resolve gameplay;
- world interaction may request crafting/harvest actions but may not directly mutate generic inventory/equipment truth.

## Persistence

Broad current-world save/load is not implemented.

Current persistence boundary starts with explicit state ownership under:

`docs/50_technical/persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`

and:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`.

## Verification boundary

Historical design contracts remain useful, but current claims require current source/tests/evidence.
