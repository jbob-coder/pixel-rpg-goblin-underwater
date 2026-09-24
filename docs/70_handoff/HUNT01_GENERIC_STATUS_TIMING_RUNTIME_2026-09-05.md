# Hunt-01 Generic Status Timing Runtime Handoff — 2026-09-05

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED

## Verified state

Repository: `jbob-coder/Chatgptjuegolpcal`
Branch: `worldlife-reference-docs`
Verified source head: `57c205e1b2fb1fc69219f44033ef527ea756a353`
Implementation parent: `d981b664ae603cfeacde0892f2891eae10ae612d`

Owner: `game/scripts/gameplay/combat/hunt01_status_timing_runtime.gd`
Schema: `uhr.hunt01.status_timing.v1`
Runtime note: `game/docs/HUNT01_GENERIC_STATUS_TIMING_RUNTIME.md`

## What is now real

- one registered generic status-timing driver under the combat shell;
- deterministic `TURN_START_PRE_RECOVERY`, `TURN_END`, and `ROUND_END` hooks in contract order;
- stable/idempotent hook delivery;
- Off-Balance arms only when active at target TURN_START and naturally clears at that completed activation's TURN_END;
- a skipped/ineligible slot does not grant Off-Balance recovery;
- Bleeding waits until `first_tick_round` and then emits at most one pending periodic Health consequence per stable actor/status/round;
- periodic events carry intensity/source/round context but no invented damage amount;
- timing does not mutate Health, spend/refresh resources, change Initiative, reroll qualification, mutate anatomy or move actors.

## Automated evidence

Production workflow: `33937504389` — SUCCESS.
Job: `101228175010` — SUCCESS.

Dedicated gates:
- `HUNT01_GENERIC_STATUS_TIMING_SOURCE_STATIC_VERIFIED`;
- `HUNT01_GENERIC_STATUS_TIMING_RUNTIME_VERIFIED`.

The production run also passed the existing manifest/projection, source preflights, Godot 4.7.2 parse/import, AppShell/Region smoke, production integration and combat regressions, then exported the Android debug APK.

Artifact:
- ID `9960678247`;
- name `UnnamedHuntRPG-Hunt01-StatusTiming-debug`;
- size `57,428,913` bytes;
- SHA-256 `f275b27c4f0f08a9ba0a45a6dd6c8bbb91a6410a564f947cee4efaed4fc88520`.

## Deferred evidence

`PHONE_VERIFIED = NO / DEFERRED_BATCH`.
`PERFORMANCE_VERIFIED = NO`.

No Google Drive save is claimed by this handoff.

## Authority boundaries discovered for continuation

`docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md` selects horn/plate/tail structural states but explicitly leaves numeric structural thresholds open. Therefore the next implementation must not invent break/sever threshold numbers.

`docs/20_gameplay/combat/DEFEAT_RETREAT_BASELINE_CONTRACT.md` already selects the player-Hunter zero-Health path, and `game/scripts/gameplay/combat/hunt01_hunter_health_injury_runtime.gd` already emits the stable `PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME` boundary at zero Health.

## Exact next bounded piece

`FIRST_SLICE_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_IMPLEMENTATION`.

Scope:
1. generic outcome owner under `game/scripts/gameplay/combat/`;
2. exactly-once consumption of the pending zero-Health defeat handoff;
3. player Hunter `DOWNED` and terminal `HUNTERS_DEFEATED` commitment after the authoritative resolution boundary;
4. stop/freeze the existing scheduler through its owner and prevent new activations/reactions;
5. preserve the living Mudcrest instance and current anatomy/status/world state;
6. dedicated static/headless/regression/Android-build verification;
7. documentation promotion after green.

Explicitly exclude recovery/respawn, voluntary withdrawal, Monster escape/death, structural threshold selection, harvest and Bleeding periodic HP magnitude.
