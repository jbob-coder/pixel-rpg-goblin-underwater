# HUNT-01 Hunter Health / Injury Runtime — Verified Handoff

Date: 2026-09-04
Project: Unnamed Hunt RPG
Branch: `worldlife-reference-docs`
Production root: `game/`

## Completed bounded layer

`FIRST_SLICE_HUNTER_HEALTH_INJURY_RUNTIME_IMPLEMENTATION`

Verification status:
- IMPLEMENTED: YES
- STATIC VERIFIED: YES
- GODOT 4.7.2 PARSE/IMPORT: PASS
- HEADLESS VERIFIED: YES
- ANDROID BUILD VERIFIED: YES
- APK/EVIDENCE ARTIFACT UPLOAD: PASS
- PHONE VERIFIED: NO / DEFERRED_BATCH
- PERFORMANCE VERIFIED: NO

Implementation commit:
`057928b30ddef3eac83a316a62c48b5e3fa22632`.

Same-layer QA/documentation compatibility repairs:
- `da2ee5698a7b7c640b8d848fc0cde3d9f877921e` restored combat ownership/provisional-fixture assertions expected by the existing combat-shell source gate;
- `06bd3e6ee039bc0f975918d6cf5fef232bf36cdc` restored the reaction package's explicit out-of-turn ownership wording expected by the existing reaction source gate.

Neither repair changed gameplay source, coordinates, combat costs, health arithmetic or runtime behavior.

Verified production head:
`06bd3e6ee039bc0f975918d6cf5fef232bf36cdc`.

Production workflow `33934988066`: SUCCESS.
Workflow job `101221044355`: SUCCESS.

## Implemented ownership

Generic owner:
`game/scripts/gameplay/combat/hunt01_hunter_health_injury_runtime.gd`.

Schema:
`uhr.hunt01.hunter_health_injury.v1`.

The runtime:
- consumes one stable `PENDING_HUNTER_HEALTH_INJURY_RUNTIME` transaction exactly once;
- handles `NO_HUNTER_HEALTH_INJURY_CONSEQUENCE` without mutation;
- starts the reversible first slice at normalized Health 100;
- maps GRAZE/SOLID/CLEAN to provisional base loads 4/8/12;
- applies provisional Strong/Partial/Broken/No-Guard residual percentages 25/60/90/100;
- ceiling-rounds requested load, caps application by remaining Health and clamps Health at zero;
- preserves attack ID/profile, `PIERCING + IMPACT`, hit quality, defense outcome and hostile resolution identity;
- records the absence of authored Hunter gameplay armor instead of deriving armor from art;
- keeps actual status requests empty because the current handoff does not establish horn penetration or impact dominance;
- records only candidate/prerequisite metadata for Bleeding/Off-Balance;
- emits `PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME` at zero Health but does not implement defeat;
- uses no RNG and is replay-idempotent.

Fixture:
`PROVISIONAL_FIRST_SLICE_HUNTER_HEALTH_INJURY_FIXTURE`.

Protection boundary:
`PROVISIONAL_NO_AUTHORED_HUNTER_GAMEPLAY_ARMOR_PROFILE_RESIDUAL_FORCE_BASELINE`.

## Final automated evidence

Workflow `33934988066` passed:
- authoritative manifest / production projection;
- all current static/source gates;
- Godot 4.7.2 import/parse;
- AppShell smoke;
- Region-01 smoke;
- Hunt-01 production integration;
- combat turn shell + tactical movement;
- Hunter reaction regression;
- Mudcrest Head Sweep regression;
- Hunter defense consequence regression;
- dedicated Hunter health/injury headless;
- Mudcrest anatomy headless;
- Hunter attack headless;
- Android debug export;
- artifact upload.

Artifact:
- ID `9959871663`;
- name `UnnamedHuntRPG-Hunt01-HunterHealth-debug`;
- size `57,365,013` bytes;
- digest `sha256:ebb15c4b124e9b046e4194951414bc01cdcd5c28a8136d7ebb2f8b694fcf1f66`;
- APK output `UnnamedHuntRPG-Hunt01-HunterHealth-debug.apk`.

## Retained boundaries

Final Hunter Max Health/damage/armor balance is not selected. The normalized values are reversible prototype tuning.
No authored gameplay armor profile exists for the current Hunter.
Status qualification/application is not owned by health. Structural break/sever, forced movement, remaining Mudcrest attacks, behavior/Berserk, defeat/escape/reacquisition and the harvest-to-settlement runtime loop remain incomplete.

Phone validation remains `DEFERRED_BATCH` and performance remains unverified.

## Exact next bounded piece

`FIRST_SLICE_MUDCREST_HEAD_SWEEP_WOUND_CONTACT_CLASSIFICATION_RUNTIME_IMPLEMENTATION`.

Species/content owner under `game/scripts/gameplay/monsters/monster_01/`.

Required boundary:
1. consume the already-resolved Head Sweep contact/defense/health consequence once;
2. do not reroll attack/contact and do not mutate Health;
3. establish whether the Monster packet's horn-penetration or CLEAN impact-dominance prerequisites actually qualify;
4. use an explicitly named reversible classification fixture if executable mapping is needed because current mixed channels do not provide dominance/penetration directly;
5. emit an explicit valid status application request only when all content prerequisites are met;
6. otherwise record an explicit no-request/blocked-prerequisite classification;
7. leave status stacking/timing/application to the generic status owner;
8. add static/headless/regression/Android-build gates;
9. phone remains deferred.

Do not implement status ticking, defeat, structural break/sever, other Mudcrest attacks or harvest in this bounded piece.