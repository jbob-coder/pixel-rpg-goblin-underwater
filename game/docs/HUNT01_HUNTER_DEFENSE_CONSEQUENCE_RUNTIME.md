# Hunt-01 Hunter Defense Consequence Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED
Last reconciled: 2026-09-04

## Purpose

Consume the first stable hostile `PENDING_HUNTER_DAMAGE_RUNTIME` transaction without inventing final Hunter health or injury numbers.

Generic owner:
`game/scripts/gameplay/combat/hunt01_hunter_defense_consequence_runtime.gd`.

Schema:
`uhr.hunt01.hunter_defense_consequence.v1`.

## Verified executable rules

- hostile resolution identity is consumed exactly once and replay/readback is idempotent;
- `NO_CONTACT / MISS` produces zero resource/health consequence;
- `FIELD_POLEBLADE_DIRECTIONAL_GUARD` consumes the Head Sweep impact profile separately from the already-spent `1 RP / 6 Stamina` Block commitment;
- Head Sweep's selected standard impact drain is `10 Stamina`;
- impact drain is clamped to available Stamina and cannot create debt;
- the impact spend uses a separate stable zero-RP shell resource transaction keyed to the hostile resolution;
- body contact without active guard applies no Block impact drain and remains pending for the health/injury owner.

## Reversible Block fixture

`PROVISIONAL_FIRST_SLICE_POLEBLADE_BLOCK_OUTCOME_FIXTURE` exists only to make the first hostile defense transaction executable while final Guard Stability/Might/equipment formulas remain open.

Current deterministic mapping:
- impact drain cannot be fully met → `BLOCK_BROKEN`;
- fully funded `GRAZE` or `SOLID` contact → `BLOCK_STRONG`;
- fully funded `CLEAN` contact → `BLOCK_PARTIAL`.

This mapping is not final balance.

## Downstream boundary

Residual body contact emits:
`PENDING_HUNTER_HEALTH_INJURY_RUNTIME`.

This layer does not select final Hunter Max Health, health damage, wound severity, armor values, status application, forced movement, final Block balance, or Dodge/Parry/Brace outcomes.

## Verification evidence

Implementation head:
`598abcd66ba3333808fc2fe54c873c8cb5df01f9`.

Static gate:
`HUNT01_HUNTER_DEFENSE_CONSEQUENCE_SOURCE_STATIC_VERIFIED`.

Headless gate:
`HUNT01_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_VERIFIED`.

Production workflow `33933869555`: SUCCESS.
Job `101217865434`: SUCCESS.

Artifact:
- ID `9959508072`;
- name `UnnamedHuntRPG-Hunt01-HunterDefense-debug`;
- size `57,342,853` bytes;
- SHA-256 `8eacdaa455574046381c7f153f20dceef59a3d4a9071e091f9c9b2b0691fa51d`;
- APK output `UnnamedHuntRPG-Hunt01-HunterDefense-debug.apk`.

Phone/user acceptance remains deferred-batch. Performance remains unverified.

## Next owner

`FIRST_SLICE_HUNTER_HEALTH_INJURY_RUNTIME_IMPLEMENTATION` consumes the stable pending health/injury handoff. Its numeric first-slice health/damage values must remain a named reversible fixture because final balance is open.