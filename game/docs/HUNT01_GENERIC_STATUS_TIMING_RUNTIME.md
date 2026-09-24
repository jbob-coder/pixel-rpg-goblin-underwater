# Hunt-01 Generic Status Timing Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED THROUGH TAIL SWEEP CLEAN→STAGGERED PRODUCER
Last reconciled: 2026-09-13

Owner: `game/scripts/gameplay/combat/hunt01_status_timing_runtime.gd`.
Schema: `uhr.hunt01.status_timing.v1`.

## Purpose

Execute deterministic lifecycle timing for already-applied generic status state without owning content qualification, external ON_APPLY, AP/RP/Stamina, Initiative order, presentation or unresolved Bleeding damage magnitude.

## Hook ordering

The combat shell exposes one registered status-timing driver. It calls:
- `TURN_START_PRE_RECOVERY` after selecting an eligible activation and before passive Stamina recovery/AP-RP refresh;
- `TURN_END` before the actor's roster slot becomes `ACTED` and before scheduler advancement;
- `ROUND_END` after the current roster is terminal and before the next round is created.

Hook IDs are deterministic and idempotent.

## Staggered lifecycle

If `status_staggered` is active when its target reaches the next `TURN_START_PRE_RECOVERY`, timing invokes the existing application owner exactly once to:
1. remove Staggered;
2. apply or refresh the single existing `status_off_balance` instance;
3. preserve `CONTINUE_SAME_NORMAL_ACTIVATION` — no hidden stun and no skipped activation.

After conversion, timing immediately arms the resulting Off-Balance for that same activation's `TURN_END`. Normal passive Stamina recovery and AP/RP refresh then proceed in the combat shell under their existing authority.

Duplicate delivery of the same `TURN_START_PRE_RECOVERY` hook returns the cached hook result, does not perform a second Staggered transition and does not refresh Off-Balance twice.

## Off-Balance lifecycle

If `status_off_balance` is active after Staggered conversion/current-state processing at `TURN_START_PRE_RECOVERY`, the application owner records `expiry_armed_round` for that activation. At the matching `TURN_END`, the timing owner requests one natural removal through the status owner.

A status applied after TURN_START during an already-running activation cannot expire at that same turn end. A skipped/ineligible slot never receives TURN_START and therefore cannot gain free natural recovery. Duplicate hook delivery cannot remove twice.

## Bleeding cadence boundary

At eligible `ROUND_END`, active Bleeding instances are processed in sorted stable actor/status identity order. No event occurs before `first_tick_round`. At most one event per actor/status/round is emitted.

The emitted event status is `PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE` and records intensity, source identity and round. `health_magnitude_status = NOT_SELECTED_PENDING_AUTHORITY`.

This timing layer does not select or apply periodic HP loss. Exact Bleeding magnitude remains a future content/health-consequence decision.

## Safety boundary

Timing contains no RNG, resource commitment/refresh, Initiative reordering, anatomy mutation, movement, content qualification reroll or presentation-owned gameplay. Generic Staggered changes status state only; Tail Sweep CLEAN producer wiring is now verified outside this owner and does not change timing ownership.

## Verification evidence

Verified source head / producer integration baseline:
`fbfd30fde0ad74bdb73d384533287b884341cd93`.

Static target: `HUNT01_GENERIC_STATUS_TIMING_SOURCE_STATIC_VERIFIED`.
Headless target: `HUNT01_GENERIC_STATUS_TIMING_RUNTIME_VERIFIED`.
Production workflow `34762775881`: SUCCESS.
Job `103738398857`: SUCCESS.
Artifact `10319377979`: `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`, 57,485,460 bytes, SHA-256 `1760956f76d2d908d64f6efc7da3fc7e409d23a26cb4ccd65402c83739d82273`.

The run also kept Tail Sweep and all preceding production regressions green and exported/uploaded the Android debug APK.

Phone/user acceptance remains deferred-batch. Performance remains unverified.

## Next owner

`FIRST_SLICE_HUNT01_BASIC_RUNTIME_AUTORUN_REGRESSION`.

That next piece verifies repeatable boot/run/teardown of already-implemented production basics. It must not become a second scheduler, normal-game autoplay or a source of new gameplay semantics.
