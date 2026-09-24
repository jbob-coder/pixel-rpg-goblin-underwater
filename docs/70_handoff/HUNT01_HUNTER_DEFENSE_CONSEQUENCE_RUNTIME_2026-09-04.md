# HUNT-01 Hunter Defense Consequence Runtime — Verified Handoff

Date: 2026-09-04
Project: Unnamed Hunt RPG
Branch: `worldlife-reference-docs`
Production root: `game/`

## Completed bounded layer

`FIRST_SLICE_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_IMPLEMENTATION`

Verification status:
- IMPLEMENTED: YES
- STATIC VERIFIED: YES
- GODOT 4.7.2 PARSE/IMPORT: PASS
- HEADLESS VERIFIED: YES
- ANDROID BUILD VERIFIED: YES
- APK/EVIDENCE ARTIFACT UPLOAD: PASS
- PHONE VERIFIED: NO / DEFERRED_BATCH
- PERFORMANCE VERIFIED: NO

Verified implementation head:
`598abcd66ba3333808fc2fe54c873c8cb5df01f9`.

Production workflow `33933869555`: SUCCESS.
Workflow job `101217865434`: SUCCESS.

## Implemented ownership

Generic owner:
`game/scripts/gameplay/combat/hunt01_hunter_defense_consequence_runtime.gd`.

Schema:
`uhr.hunt01.hunter_defense_consequence.v1`.

The runtime:
- validates and consumes the stable `PENDING_HUNTER_DAMAGE_RUNTIME` hostile transaction exactly once;
- preserves deterministic replay/readback;
- resolves `NO_CONTACT / MISS` with no Hunter resource or health consequence;
- recognizes the exact `FIELD_POLEBLADE_DIRECTIONAL_GUARD` route;
- preserves the original `POLEBLADE_BLOCK = 1 RP + 6 Stamina` commitment as a separate transaction;
- applies Head Sweep's selected standard `10 Stamina` impact drain through combat-shell resource authority;
- clamps impact drain to available Stamina and never creates debt;
- records stable Strong/Partial/Broken-compatible Block outcome data;
- emits `PENDING_HUNTER_HEALTH_INJURY_RUNTIME` when residual force reaches the Hunter;
- does not invent final Hunter HP, armor, wound, status or forced-movement arithmetic.

## Reversible balance boundary

Fixture:
`PROVISIONAL_FIRST_SLICE_POLEBLADE_BLOCK_OUTCOME_FIXTURE`.

Current mapping:
- fully funded GRAZE/SOLID → `BLOCK_STRONG`;
- fully funded CLEAN → `BLOCK_PARTIAL`;
- insufficient impact reserve → `BLOCK_BROKEN`.

This mapping is intentionally replaceable when Guard Stability/Might/equipment formulas become validated. Transaction identity/resource ownership must remain stable when balance changes.

## Final automated evidence

Workflow `33933869555` passed:
- authoritative manifest / production projection;
- all current static/source gates including Hunter defense consequence;
- Godot 4.7.2 import/parse;
- AppShell smoke;
- Region-01 smoke;
- Hunt-01 production integration;
- combat turn shell + tactical movement;
- Hunter reaction regression;
- Mudcrest Head Sweep regression;
- dedicated Hunter defense-consequence headless;
- Mudcrest anatomy headless;
- Hunter attack headless;
- Android debug export;
- artifact upload.

Artifact:
- ID `9959508072`;
- name `UnnamedHuntRPG-Hunt01-HunterDefense-debug`;
- size `57,342,853` bytes;
- digest `sha256:8eacdaa455574046381c7f153f20dceef59a3d4a9071e091f9c9b2b0691fa51d`;
- APK output `UnnamedHuntRPG-Hunt01-HunterDefense-debug.apk`.

## Retained boundaries

Final Hunter Max Health/damage arithmetic is not selected.
No authored gameplay armor/protection profile exists for the current Hunter; visual plates/clothing are presentation intent and cannot be converted into hidden gameplay numbers.
Final Block balance is not selected.
Status application, forced movement, structural crack/break/sever/detachment, remaining Mudcrest attacks, behavior/Berserk, defeat/escape/reacquisition and the harvest-to-settlement runtime loop remain incomplete.

Phone validation remains `DEFERRED_BATCH` and performance remains unverified.

## Exact next bounded piece

`FIRST_SLICE_HUNTER_HEALTH_INJURY_RUNTIME_IMPLEMENTATION`.

Generic owner:
`game/scripts/gameplay/combat/`.

Required next-slice boundary:
1. consume one stable `PENDING_HUNTER_HEALTH_INJURY_RUNTIME` transaction idempotently;
2. use a clearly named reversible normalized first-slice health/injury fixture because final balance is open;
3. preserve hit quality, damage channels, defense outcome and hostile resolution ID in the trace;
4. explicitly record the current absence of authored Hunter gameplay armor rather than inferring armor from art;
5. clamp health at zero and prohibit duplicate injury application;
6. emit deterministic status *requests* only where `COMBAT_ATTACK_PACKET.md` already authorizes them after a wound exists; do not apply statuses here;
7. when health reaches zero, emit only a pending defeat/outcome handoff;
8. integrate after defense consequence and before Monster activation completion;
9. add static/headless/regression/Android-build gates;
10. phone remains deferred.

Do not implement status stacking, structural break/sever, other Mudcrest attacks, defeat/retreat behavior or harvest in this bounded piece.