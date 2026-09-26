# 50_technical/persistence — Pixel RPG State Ownership and Persistence

Status: ACTIVE OWNERSHIP PACKAGE / STATE OWNERSHIP IMPLEMENTED / BROAD SAVE-LOAD NOT IMPLEMENTED  
Last reconciled: 2026-09-25

## Purpose

Own persistence boundaries and the mapping between authoritative runtime owners and future durable save data.

## Current authority

Current Pixel RPG ownership contract:

`PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`

Executable schema:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Focused verification:

`game/tests/pixel_rpg_state_ownership_contract_test.gd`

## Current ownership rule

Only the declared owner is authoritative for a datum.

Examples:

- Hunter transform/physics → world Hunter owner;
- combat AP/RP/Stamina/round state → combat turn shell;
- Mudcrest anatomy → anatomy owner;
- touch/joystick → transient exploration-input owner;
- yaw/pitch → first-person camera-state owner;
- targeting/context → transient control owners;
- HUD/highlights/minimap → presentation only.

## Persistence classifications

Current contract distinguishes:

- never-save transient control/presentation;
- local preference candidates;
- durable-eligible future state;
- checkpointable deterministic domain state;
- planned durable player/world/inventory/NPC/economy owners.

Broad serializer/save-slot implementation is not present.

## Historical first-slice persistence design

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`

is retained for:

- safe snapshot boundaries;
- anti-replay/idempotency ideas;
- transaction continuity;
- corruption/atomic-write design;
- future schema migration concepts.

It is not proof of implemented Pixel RPG save/load.

Its old `UHR_SAVE_SCHEMA_1`, legacy spatial IDs, and Region-01 assumptions are historical design unless a current persistence implementation explicitly adopts them.

## Current next direction

Persistence work should begin from current state ownership and the current issue register, not from replaying the old first-slice implementation order.

When implemented, durable save data must serialize authoritative owners rather than HUD/UI/callback state.
