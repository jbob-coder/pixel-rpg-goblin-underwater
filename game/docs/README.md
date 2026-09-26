# game/docs — Runtime Evidence and Domain Notes

Status: CURRENT NAVIGATION / HUNT-01 DOMAIN PROVENANCE  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Purpose

This directory contains implementation/evidence notes for the deterministic Hunt-01 runtime stack.

These files are closer to executable domain history than broad design documents, but they are still documentation. Their recorded status, source SHA, workflow ID, “next slice,” or “pending” language applies to the checkpoint when each note was written.

Current source/tests win when later implementation has advanced.

## Current relationship to Pixel RPG

The runtime descendants documented here remain important and largely live under:

- `game/scripts/gameplay/combat/`;
- `game/scripts/gameplay/monsters/monster_01/`;
- `game/scripts/gameplay/tracking/`;
- `game/scripts/gameplay/encounter/`;
- `game/tests/`.

The current first-person Pixel RPG boot scene does **not** expose the full Hunt-01 stack yet.

Current first-person boundary:

Observe/Engage
→ targeting preview
→ anatomy target selection/lock
→ Combat Bridge 002
→ initialize Mudcrest anatomy + combat turn shell
→ no attack yet.

The domain/runtime evidence here should be adapted into current-world combat through an explicit spatial/current-world adapter rather than duplicated or directly transplanted with old Region-01 coordinates.

## File classification

### Basic integrated autorun

`HUNT01_BASIC_RUNTIME_AUTORUN_REGRESSION.md`

Use for:
- deterministic integrated regression path;
- repeatability;
- tracking→engage→combat exchanges;
- terminal Hunter defeat;
- status/anatomy regression history.

Current note:
this autorun already exists; older READMEs that call it “next” are stale.

### Hunter attack

`HUNT01_FIRST_HUNTER_ATTACK_RUNTIME.md`

Use for:
- Measured Cut runtime provenance;
- attack transaction/resource/targeting handoff;
- anatomy-damage bridge.

Its old “re-verification pending” field is checkpoint-specific.

### Generic status application

`HUNT01_GENERIC_STATUS_APPLICATION_RUNTIME.md`

Use for:
- Bleeding/Staggered/Off-Balance authoritative application;
- idempotency;
- transition identity;
- status-state ownership.

### Generic status timing

`HUNT01_GENERIC_STATUS_TIMING_RUNTIME.md`

Use for:
- TURN_START_PRE_RECOVERY;
- TURN_END;
- ROUND_END hooks;
- Staggered→Off-Balance timing;
- pending Bleeding cadence.

### Hunter defense consequence

`HUNT01_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME.md`

Use for:
- deterministic defense-result consequence;
- Block impact drain;
- no-contact boundary;
- separation from Hunter health owner.

### Hunter health/injury

`HUNT01_HUNTER_HEALTH_INJURY_RUNTIME.md`

Use for:
- authoritative first-slice Hunter health/injury mutation;
- stable/idempotent injury transactions;
- pending defeat boundary.

### Hunter reaction window

`HUNT01_HUNTER_REACTION_WINDOW_RUNTIME.md`

Use for:
- generic out-of-turn reaction ownership;
- stable reaction-window identity;
- RP/Stamina commitment;
- decline/close lifecycle.

### Hunter Downed / encounter outcome

`HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME.md`

Use for:
- Health <= 0 → DOWNED;
- HUNTERS_DEFEATED;
- terminal scheduler freeze;
- outcome ordering/idempotency.

### Mudcrest anatomy

`HUNT01_MUDCREST_ANATOMY_INTEGRITY_RUNTIME.md`

Use for:
- per-target anatomy integrity;
- committed damage-handoff consumption;
- replay protection;
- separation from generic attack resolution.

Its old “automated verification pending” status is historical; current source/test lineage has advanced beyond that checkpoint.

### Mudcrest Head Sweep

`HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME.md`

Use for:
- first hostile Mudcrest attack;
- reaction-window integration;
- attack resource commitment;
- telegraph/presentation boundary;
- damage handoff.

### Mudcrest Tail Sweep

`HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME.md`

Use for:
- rear/flank attack integration;
- Tail capability boundary;
- Block consequence;
- Staggered/Off-Balance producer behavior;
- provisional geometry fixture.

### Mudcrest wound/contact classification

`HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME.md`

Use for:
- species/content contact classification;
- status-request qualification;
- separation between hit result, health consequence, and generic status application.

## Ownership map

Generic combat owners:

`game/scripts/gameplay/combat/`

Species owners:

`game/scripts/gameplay/monsters/monster_01/`

Tracking owner:

`game/scripts/gameplay/tracking/`

Encounter owner:

`game/scripts/gameplay/encounter/`

Current-world first-person compatibility/bridge:

`game/scripts/presentation/pixel_rpg/pixel_rpg_world_combat_compat.gd`

and current prototype orchestration.

## Evidence law

A note may record:

- IMPLEMENTED;
- STATIC VERIFIED;
- HEADLESS VERIFIED;
- ANDROID BUILD VERIFIED.

Those claims apply to the exact source/workflow recorded in that note.

Do not automatically promote them to:

- current production HEAD;
- current phone runtime;
- current visual acceptance;
- current sustained performance.

For current build evidence, use the current canonical workflow and exact tested SHA.

## Spatial firewall

Many Hunt-01 runtime notes depend on Region-01 tactical nodes or authored fixtures.

Those nodes are valid for the legacy Region-01 integration path.

They are not current compact-world positioning authority.

Future current-world combat must:

current physical state
→ current-world spatial adapter
→ deterministic domain intent/resolution.

Do not teleport the current Hunter to old tactical nodes merely to reuse domain code.

## Presentation firewall

Historical notes may mention aerial/first-person or old production presentation states.

Current presentation authority is first-person.

Domain mechanics remain reusable even when their original presentation checkpoint is superseded.

## Verification coverage

Current canonical CI executes the current `game/tests/*_test.gd` set.

The strongest current integrated regression reference is:

`game/tests/hunt01_basic_runtime_autorun_test.gd`

along with focused combat/anatomy/status tests.

## Preservation rule

Do not rewrite these historical runtime notes to pretend they were authored for the current compact-world first-person integration.

Instead:

- keep their exact old evidence;
- use this README to interpret them;
- update live source/tests/current handoffs for new implementation work;
- add a new bounded note only when a new runtime slice genuinely needs its own evidence record.

## Completeness verification

Directory readback on 2026-09-25 found 12 Hunt-01 runtime/evidence Markdown notes under `game/docs/`, excluding this README.

All 12 are explicitly classified in this index.

Completeness result: **12 / 12 runtime notes classified**.
