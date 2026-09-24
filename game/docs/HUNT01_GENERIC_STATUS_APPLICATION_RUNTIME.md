# Hunt-01 Generic Status Application Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED THROUGH TAIL SWEEP CLEAN→STAGGERED PRODUCER
Last reconciled: 2026-09-13

## Purpose

Consume already-valid content-owned status application requests and mutate authoritative generic combat status instances exactly once. This layer never decides whether a hit/wound qualified and does not execute scheduler hooks itself.

Owner: `game/scripts/gameplay/combat/hunt01_status_application_runtime.gd`.
Schema: `uhr.hunt01.status_application.v1`.
Input: `uhr.status_application_request.v1`, consumer `PENDING_GENERIC_STATUS_APPLICATION_RUNTIME`.

## Verified behavior

`status_bleeding`: actor-level `STACK_INTENSITY_CAPPED`, max 3, first application records `first_tick_round = R + 1`, later applications cannot move that original first eligible tick. Periodic hook metadata remains `ROUND_END` / `PENDING_STATUS_TIMING_RUNTIME`.

`status_staggered`: actor-level `REFRESH_DURATION`, category `TRANSIENT_PHYSICAL_DISRUPTION`, one instance, intensity fixed at 1. Reapplication refreshes the same instance and increments application history without intensity stacking. The instance records `TURN_START_PRE_RECOVERY` as its pending transition hook, `status_off_balance` as its transition target, and `CONTINUE_SAME_NORMAL_ACTIVATION` as its activation policy. Nonzero `intensity_delta` is rejected.

The application owner exposes the deterministic timing mutation `transition_staggered_to_off_balance_for_timing`. That mutation removes the one Staggered instance, applies or refreshes the existing Off-Balance instance once, records a stable transition ID, and is replay/idempotency safe. The timing owner decides when to invoke it.

`status_off_balance`: actor-level `REFRESH_DURATION`, one instance, reapplication updates last-application state without intensity stacking. Natural expiry metadata is `TURN_END` after the target completes its next normal activation.

Each stable external application request ID commits ON_APPLY once. Re-read returns `STATUS_APPLICATION_READBACK_IDEMPOTENT` without another stack/refresh/trace event. Staggered timing transitions use their own stable transition map rather than masquerading as a second external request transaction.

In-memory persistence snapshot/rehydration preserves instances, consumed request identity and committed timing-transition identity without replaying ON_APPLY. This is a continuity contract, not the final game save system.

The owner has no status proc RNG and does not spend/refresh AP/RP/Stamina, reorder Initiative, mutate Hunter Health/anatomy, move actors or give presentation gameplay authority.

## Integration boundary

Mudcrest wound/contact classification remains species/content-owned. It creates/reuses one generic status application node under the combat shell and dispatches qualified requests.

Tail Sweep CLEAN is now a verified Staggered producer: the species classifier emits exactly one `status_staggered` request for the already-qualified CLEAN consequence, the generic owner applies it synchronously, and stable resolution replay does not duplicate ON_APPLY or refresh it twice. SOLID Tail Sweep remains Off-Balance and Strong Block remains no-status.

## Verification evidence

Verified source head / producer integration commit:
`fbfd30fde0ad74bdb73d384533287b884341cd93`.

Production workflow `34762775881`: SUCCESS.
Job `103738398857`: SUCCESS.
Static gate `HUNT01_GENERIC_STATUS_APPLICATION_SOURCE_STATIC_VERIFIED`.
Headless gate `HUNT01_GENERIC_STATUS_APPLICATION_RUNTIME_VERIFIED`.
Artifact `10319377979`: `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`, 57,485,460 bytes, SHA-256 `1760956f76d2d908d64f6efc7da3fc7e409d23a26cb4ccd65402c83739d82273`.

The same run passed Godot 4.7.2 import/parse, all current production smokes/integration and combat regressions, Android debug export and artifact upload.

## Deferred boundary

This layer does not execute Bleeding periodic Health consequences or select their HP magnitude; does not implement Braced/Guarded state owners, structural damage, withdrawal/recovery, defeat/harvest extensions, phone acceptance or sustained performance verification.
