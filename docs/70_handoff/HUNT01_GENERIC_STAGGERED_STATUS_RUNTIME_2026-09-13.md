# Hunt-01 Generic Staggered Status Runtime Handoff — 2026-09-13

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED

## Objective completed

`FIRST_SLICE_GENERIC_STAGGERED_STATUS_RUNTIME_IMPLEMENTATION` is complete at the automated production-build boundary.

The work extended the existing generic status owners rather than creating a second system.

## Implemented behavior

`status_staggered` now exists in `hunt01_status_application_runtime.gd` with:
- category `TRANSIENT_PHYSICAL_DISRUPTION`;
- `REFRESH_DURATION`;
- exactly one actor-level instance;
- intensity fixed at 1;
- nonzero `intensity_delta` rejected;
- repeated valid applications refresh the same instance and remain request-idempotent;
- persistence snapshot/rehydration of instance/application/transition state without ON_APPLY replay;
- no status proc RNG.

At the target's next `TURN_START_PRE_RECOVERY`, `hunt01_status_timing_runtime.gd` now:
1. invokes one stable Staggered→Off-Balance timing transition through the existing application owner;
2. removes Staggered exactly once;
3. applies or refreshes existing `status_off_balance` exactly once;
4. arms that Off-Balance for the same normal activation's `TURN_END`;
5. continues the activation with no hidden stun/skip; shell Stamina recovery and AP/RP refresh then proceed normally.

Duplicate TURN_START delivery does not repeat the transition or refresh Off-Balance twice. Existing Bleeding ROUND_END cadence and Off-Balance natural expiry remain green.

## Files changed in implementation commit

- `game/scripts/gameplay/combat/hunt01_status_application_runtime.gd`
- `game/scripts/gameplay/combat/hunt01_status_timing_runtime.gd`
- `game/tests/hunt01_status_application_runtime_test.gd`
- `game/tests/hunt01_status_timing_runtime_test.gd`
- `tests/quality/hunt01/hunt01_status_application_preflight.py`
- `tests/quality/hunt01/hunt01_status_timing_preflight.py`

No Tail Sweep attack/classifier file, scheduler file or workflow file was changed by the implementation commit.

## Verification evidence

Implementation commit:
`29623181bfb758b322e47d83a1c2f652b225561a`.

Latest full production-verified revision after promotion/reconciliation repair:
`a3fdbe6f42475f86785ed63e0786c56221a1d025`.

Production workflow `34762031809`: SUCCESS.
Job `103736439931`: SUCCESS.

The job passed:
- current static/manifest verification chain;
- Godot 4.7.2 import/parse;
- production AppShell smoke;
- production Region-01 smoke;
- production Hunt-01 integration;
- combat turn shell/reaction/Head Sweep/Tail Sweep/defense/health/wound-contact regressions;
- Generic Status Application headless gate;
- Generic Status Timing headless gate;
- Hunter Downed, Mudcrest anatomy and Hunter attack regressions;
- Android debug APK export and artifact upload.

Artifact:
- ID `10319347130`;
- name `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`;
- size `57,484,070` bytes;
- SHA-256 `2408c9853794e32e9db0ed7c3766a2c5ac98ef77ac686e9a012ab41bd1e01fcb`.

## Promotion reconciliation history

Run `34761795095` failed before Godot because the promotion rewrite of `game/scripts/gameplay/combat/README.md` dropped two static-governance ownership statements. Run `34761927841` verified the restored species delegation but still failed the tactical-movement wording requirement. Commit `a3fdbe6f42475f86785ed63e0786c56221a1d025` restored only the missing explicit tactical-movement authority (`1 AP`, terrain surcharge, footing/POOR) and changed no gameplay logic. Run `34762031809` then passed the complete production pipeline.

The failed interim runs are retained as evidence of the promotion/documentation defect; they do not supersede the successful implementation run or final successful promoted run.

## Evidence limits

`PHONE_VERIFIED = NO / DEFERRED_BATCH`.
`PERFORMANCE_VERIFIED = NO`.
Android export/build success is not phone acceptance or sustained-performance evidence.

## Intentionally preserved boundary / known stale source marker

Tail Sweep CLEAN remains source-coded as `TAIL_SWEEP_CLEAN_IMPACT_STAGGERED_PENDING` with `staggered_request_pending_unimplemented`. That wording is stale with respect to generic owner existence, but it was intentionally protected by this bounded slice: Generic Staggered implementation did **not** wire a content producer.

This is not silently reinterpreted as implemented. It becomes the next bounded integration.

## Exact next bounded piece

`FIRST_SLICE_MUDCREST_TAIL_SWEEP_CLEAN_STAGGERED_PRODUCER_INTEGRATION`.

Read and preserve:
- `docs/20_gameplay/combat/FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`;
- `game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd`;
- `game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd`;
- `game/tests/hunt01_mudcrest_tail_sweep_runtime_test.gd`;
- `tests/quality/hunt01/hunt01_mudcrest_tail_sweep_preflight.py`;
- Generic Status Application/Timing owners/tests as protected consumers;
- `.github/workflows/production-hunt01-graybox-android.yml`.

The next piece may emit exactly one valid Staggered request for the already-qualified CLEAN Tail Sweep consequence. It must preserve SOLID→Off-Balance, Strong Block→no status, deterministic contact/economy/geometry, no new RNG, no structural thresholds, no Bleeding HP magnitude, no forced displacement and no unrelated Braced/Guarded implementation.
