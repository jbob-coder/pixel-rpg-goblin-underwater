# Hunt-01 Hunter Downed Encounter-Outcome Runtime Handoff — 2026-09-06

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED

## Verified state

Repository: `jbob-coder/Chatgptjuegolpcal`
Branch: `worldlife-reference-docs`
Verified source head: `f363998334bb752b037ed524cb909ad12634b71f`
Implementation commit: `a6476483c7f187f5e4904d7901c28e1abe0f9996`
Static-contract repair commits: `31d046b19a984c8234af788a09b3d0b6f8f8716b`, `f363998334bb752b037ed524cb909ad12634b71f`

Owner: `game/scripts/gameplay/combat/hunt01_encounter_outcome_runtime.gd`
Schema: `uhr.hunt01.encounter_outcome.v1`
Runtime note: `game/docs/HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME.md`

## What is now real

- one generic encounter-outcome owner under the combat package;
- exact validation of the stable `PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME` handoff;
- exactly-once resolution by source `resolution_id`;
- player Hunter participation transition `ACTIVE → DOWNED` at zero Health;
- encounter outcome `HUNTERS_DEFEATED`;
- terminal commitment delegated to the existing combat shell rather than a second scheduler;
- current authoritative activation/status boundary finishes before terminal freeze;
- remaining PENDING roster slots become `REMOVED` with `ENCOUNTER_TERMINATED`;
- scheduler advancement stops and new normal/reaction resource commitments are rejected;
- living Mudcrest remains `ACTIVE` and the same persistent instance;
- Hunter defeat does not heal/reset/recreate/move Mudcrest anatomy, statuses or world identity;
- exact handoff replay returns the stored result without a second terminal commit.

## Automated evidence

Production workflow: `33985410020` — SUCCESS.
Job: `101357889357` — SUCCESS.

Dedicated gates:
- `HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_SOURCE_STATIC_VERIFIED`;
- `HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_VERIFIED`.

The production run also passed existing manifest/projection and source gates, Godot 4.7.2 parse/import, AppShell/Region smoke, production integration, combat/reaction/Head Sweep/defense/health/status/anatomy/Hunter-attack regressions, then exported the Android debug APK.

Artifact:
- ID `9975014310`;
- name `UnnamedHuntRPG-Hunt01-HunterDownedOutcome-debug`;
- size `57,446,932` bytes;
- SHA-256 `ab431361b3be3b325300d7d2242cd622afdb376f6426d8d2228fab0388cae196`.

## Deferred evidence

`PHONE_VERIFIED = NO / DEFERRED_BATCH`.
`PERFORMANCE_VERIFIED = NO`.

No Google Drive save is claimed by this handoff.

## Boundaries preserved

This pass did not invent:
- forced recovery destination/timing/costs or respawn behavior;
- Hunter voluntary-withdrawal geometry;
- Monster escape/death or mutual-terminal execution;
- Bleeding periodic HP magnitude;
- Mudcrest structural crack/break/sever thresholds;
- Staggered/Braced/Guarded runtime;
- harvest/rewards/inventory/crafting.

## Continuation audit

The defeat/retreat contract already selects voluntary withdrawal, but current Hunt-01 geometry does not yet expose an explicit `HUNTER_ESCAPE_NODE`/equivalent marker suitable for implementation without a new authored spatial decision.

Mudcrest structural break/sever remains blocked because numeric thresholds are explicitly open.

`COMBAT_ATTACK_PACKET.md` already selects `M01_TAIL_SWEEP` at 3 AP / 18 Stamina, pure Impact, standard successful Block impact drain 14 Stamina, `CAP_M01_TAIL_SWEEP`, rear/flank relation and pivot/arc-clearance legality. `BEHAVIOR_AND_REGION.md` gives legal rear/flank Tail Sweep deterministic priority. Existing generic Block and Off-Balance systems are already verified.

## Exact next bounded piece

`FIRST_SLICE_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME_IMPLEMENTATION`.

Scope:
1. extend the existing Monster-01 attack owner/driver;
2. add intact-tail capability readback and deterministic rear/flank/pivot/arc/cover legality;
3. commit 3 AP / 18 Stamina through the existing shell;
4. open one current executable reaction window and preserve explicit decline;
5. apply 14 Stamina Block impact drain through existing defense-resource authority when Block is selected;
6. resolve pure Impact contact with one stable seeded variance boundary;
7. emit/apply only already-supported Off-Balance consequence; leave Staggered pending;
8. add a non-colliding Tail Sweep telegraph presentation asset;
9. add static/headless/regression/Android-build verification;
10. promote documentation only after green.

Explicitly exclude sever thresholds/detachment, Staggered behavior, Hunter withdrawal geometry, recovery/respawn, Monster escape/death, harvest and Bleeding periodic HP magnitude.
