# Handoff — Hunt-01 Mudcrest Head Sweep Wound / Contact Classification Runtime

Date: 2026-09-04 (America/Puerto_Rico)
Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED

## Verified source/build identity

Repository: `jbob-coder/Chatgptjuegolpcal`
Branch: `worldlife-reference-docs`
Implementation commit: `6012235a958c0d4a73ff7c36201e2eff20715b70`
Production workflow: `33935813877` — SUCCESS
Workflow job: `101223419039` — SUCCESS

Artifact:
- ID `9960134957`
- name `UnnamedHuntRPG-Hunt01-WoundContact-debug`
- size `57,384,899` bytes
- SHA-256 `54f942ec0d891a27c9ee702db58db8edf68cb905e2468b07f3097797976820b1`
- APK `UnnamedHuntRPG-Hunt01-WoundContact-debug.apk`

## Runtime owner

`game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd`

Schema: `uhr.hunt01.mudcrest_wound_contact.v1`
Fixture: `PROVISIONAL_FIRST_SLICE_HEAD_SWEEP_WOUND_CONTACT_CLASSIFICATION_FIXTURE`

The owner consumes only the already-resolved Head Sweep damage/defense/health consequence. It never rerolls contact or reapplies injury.

## Verified behavior

- stable idempotent classification keyed to hostile resolution;
- Strong Block / no contact / zero injury produce no status request;
- real unguarded SOLID GORE_SWEEP + injury produces provisional horn penetration and a valid Bleeding +1 request;
- CLEAN partial/broken guard residual + injury can produce provisional impact-dominant classification and a valid Off-Balance request;
- CLEAN unguarded horned GORE_SWEEP prioritizes penetration rather than silently requesting two mixed-channel statuses;
- request schema is `uhr.status_application_request.v1` and consumer remains `PENDING_GENERIC_STATUS_APPLICATION_RUNTIME`;
- no RNG, Health/resource/anatomy/coordinate/status-state mutation.

Dedicated gates:
- `HUNT01_MUDCREST_WOUND_CONTACT_SOURCE_STATIC_VERIFIED`
- `HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME_VERIFIED`

The same run passed every existing combat regression and Android export/upload.

## Deferred boundary

This layer does not apply/stack/refresh/tick/expire statuses. It does not implement structural break/sever, remaining Mudcrest attacks, defeat/escape, harvest, inventory/crafting, phone acceptance or performance verification.

## Exact next bounded piece

`FIRST_SLICE_GENERIC_STATUS_APPLICATION_RUNTIME_IMPLEMENTATION`

Build a generic combat status owner that consumes already-valid content requests. First scope: actor-level Bleeding and Off-Balance application state, exact idempotency, Bleeding cap 3 plus `first_tick_round = application_round + 1`, Off-Balance refresh plus pending expiry metadata, deterministic trace. Do not bundle periodic Bleeding health loss or turn-hook transitions/expiry; those belong to the following scheduler/timing layer.
