# Hunt-01 Hunter Downed Encounter-Outcome Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED
Last reconciled: 2026-09-06

Owner: `game/scripts/gameplay/combat/hunt01_encounter_outcome_runtime.gd`.
Schema: `uhr.hunt01.encounter_outcome.v1`.

## Purpose

Consume the already-authoritative zero-Health `PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME` boundary and execute only the selected first-slice player-Hunter defeat path:

`Health <= 0 → DOWNED → HUNTERS_DEFEATED → existing combat scheduler terminal`.

The owner does not calculate damage or decide whether Health should reach zero.

## Resolution order

For the production Mudcrest Head Sweep path, terminal outcome consumption occurs only after:
1. defense consequence;
2. Hunter Health/injury resolution;
3. Mudcrest wound/contact + status qualification/application;
4. reaction-window closure.

Only then may the outcome owner consume the pending defeat handoff. This preserves the defeat contract's requirement to finish the current authoritative resolution boundary before terminal commitment.

## Scheduler boundary

The generic outcome owner delegates scheduler termination to `hunt01_combat_turn_shell_runtime.gd` through one `commit_terminal_outcome` authority.

The shell:
- ends the current authoritative activation, including its TURN_END timing hook;
- commits `encounter_terminal = true`;
- marks any remaining current-round PENDING slots `REMOVED` with `ENCOUNTER_TERMINATED`;
- clears the current actor;
- stops round advancement;
- rejects new normal/reaction resource commitments after terminal state.

No second scheduler is created.

## Participation / persistence boundary

The player Hunter transitions from `ACTIVE` to `DOWNED`. The living Mudcrest remains `ACTIVE` as a persistent actor. This runtime does not heal, reset, recreate, move, or otherwise mutate Mudcrest anatomy, statuses, world position, or identity.

Exact defeat handoff replay is idempotent and cannot commit the terminal result twice.

## Automated evidence

Verified source head: `f363998334bb752b037ed524cb909ad12634b71f`.
Implementation commit: `a6476483c7f187f5e4904d7901c28e1abe0f9996`.
Static-contract repair commits: `31d046b19a984c8234af788a09b3d0b6f8f8716b`, `f363998334bb752b037ed524cb909ad12634b71f`.

Production workflow `33985410020`: SUCCESS.
Job `101357889357`: SUCCESS.

Dedicated gates:
- `HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_SOURCE_STATIC_VERIFIED`;
- `HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_VERIFIED`.

The same run passed the prior production manifest/projection and source gates, Godot 4.7.2 parse/import, AppShell/Region smoke, production integration and combat regressions, then exported the Android debug APK.

Artifact:
- ID `9975014310`;
- name `UnnamedHuntRPG-Hunt01-HunterDownedOutcome-debug`;
- size `57,446,932` bytes;
- SHA-256 `ab431361b3be3b325300d7d2242cd622afdb376f6426d8d2228fab0388cae196`.

## Explicitly excluded

This bounded slice does not implement:
- forced recovery destination/timing/costs or respawn behavior;
- voluntary Hunter withdrawal;
- Monster escape/death or mutual-terminal paths;
- structural crack/break/sever thresholds or detachment;
- harvest/rewards/inventory/crafting;
- Bleeding periodic HP magnitude/application;
- final Hunter Health/damage/armor balance;
- phone acceptance or sustained-performance verification.

`PHONE_VERIFIED = NO / DEFERRED_BATCH`.
`PERFORMANCE_VERIFIED = NO`.

No Google Drive save is claimed by this record.
