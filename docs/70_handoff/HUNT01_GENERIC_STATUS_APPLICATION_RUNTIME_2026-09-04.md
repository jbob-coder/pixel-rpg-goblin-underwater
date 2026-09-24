# Handoff — Hunt-01 Generic Status Application Runtime

Date: 2026-09-04 (America/Puerto_Rico)
Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED

## Verified source/build identity

Repository: `jbob-coder/Chatgptjuegolpcal`
Branch: `worldlife-reference-docs`
Implementation commit: `6c9fc8592ce0de769f213790cc0e3e0a8ff95fdc`
Production workflow: `33936580266` — SUCCESS
Workflow job: `101225581109` — SUCCESS

Artifact:
- ID `9960395435`
- name `UnnamedHuntRPG-Hunt01-StatusApplication-debug`
- size `57,410,444` bytes
- SHA-256 `4606069697c5ae9128acf27ddad65724613ad8e83d53e8791a292339c8b0b15f`
- APK `UnnamedHuntRPG-Hunt01-StatusApplication-debug.apk`

## Runtime owner

`game/scripts/gameplay/combat/hunt01_status_application_runtime.gd`
Schema `uhr.hunt01.status_application.v1`.

## Verified behavior

- accepts only already-valid status application requests routed to the generic owner;
- stable request ID is exactly-once for ON_APPLY; replay is readback-idempotent;
- Bleeding is one actor-level capped-intensity instance, max 3;
- first Bleeding application round R records first eligible tick R+1;
- Off-Balance is one refresh-duration instance with pending completed-activation TURN_END expiry metadata;
- invalid/misrouted requests reject without state mutation;
- real Head Sweep unguarded wound dispatches into real Bleeding application;
- Strong Block produces no status application;
- in-memory rehydration restores consumed identities/instances without replaying ON_APPLY;
- synthetic status applications do not mutate Health/resources/anatomy;
- no status RNG or Initiative authority.

Dedicated gates:
- `HUNT01_GENERIC_STATUS_APPLICATION_SOURCE_STATIC_VERIFIED`
- `HUNT01_GENERIC_STATUS_APPLICATION_RUNTIME_VERIFIED`

## Deferred boundary

No Bleeding periodic Health amount is selected or applied. TURN_START/TURN_END/ROUND_END scheduling, Off-Balance expiry execution, Staggered transition, Brace integration, structural damage, defeat, harvest and full save persistence remain downstream.

## Exact next bounded piece

`FIRST_SLICE_GENERIC_STATUS_TIMING_RUNTIME_IMPLEMENTATION`

Implement deterministic lifecycle hook ordering. Expire Off-Balance exactly once after the affected actor completes its next normal activation. At eligible ROUND_END emit one pending Bleeding periodic Health-consequence event per actor/round no earlier than first_tick_round. Do not invent periodic HP magnitude.
