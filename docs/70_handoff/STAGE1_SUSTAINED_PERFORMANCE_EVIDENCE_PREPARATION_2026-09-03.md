# Stage 1 Sustained Performance Evidence Preparation — 2026-09-03

Status: PREPARATION + SOURCE/HEADLESS/ANDROID BUILD VERIFIED / GALAXY A03s EXECUTION DEFERRED

## Bounded piece

`STAGE1_SUSTAINED_PERFORMANCE_EVIDENCE_PREPARATION`

This bounded piece is complete at the highest available non-phone verification level.

The target-device performance gate itself is **not** complete because the 24-minute Galaxy A03s run has not been executed.

## Why this piece existed

The prior Stage-1 probe exposed engine FPS and reciprocal frame time plus debug static memory. That was sufficient for a quick smoke screenshot but not sufficient to characterize:
- short frame-pacing spikes;
- repeatable view-transition hitches;
- sustained degradation during a representative run;
- cumulative hitch behavior;
- a reproducible comparison between two builds.

The previous one-frame Galaxy A03s evidence (`60 FPS / ~16.7 ms / 40.9 MiB`) therefore could not legitimately close `PERFORMANCE_VERIFIED`.

The smallest correct preparation was to add low-overhead probe-local rolling telemetry and define one exact target-phone evidence procedure. No production profiler architecture or speculative quality downgrade was justified.

## Source implementation

Owner:
`probes/android_stage1/scripts/probe_world.gd`.

Source commit:
`89394067971120df43b184a8509934f5458185f2`.

Added probe-local measurement state for:
- rolling approximately one-second actual `_process(delta)` average frame duration;
- rolling approximately one-second max frame duration;
- cumulative process frames above `34.0 ms`;
- cumulative process frames at/above `50.0 ms`;
- cumulative worst process-frame delta.

Existing displayed evidence remains:
- engine FPS;
- debug static memory;
- renderer;
- current view mode.

The `34 ms` and `50 ms` values are diagnostic thresholds, not universal final-game budgets.

The telemetry pass intentionally did **not** retune:
- analog joystick behavior;
- heading reset;
- Look Speed;
- aerial camera;
- first-person camera;
- Monster collision/geometry;
- world boundary;
- shadows;
- render scale;
- gameplay systems.

## Executable telemetry regression

New test:
`ci/stage1/performance_telemetry_test.gd`.

The test instantiates the real ProbeWorld, disables automatic `_process()` during deterministic injection, seeds known frame deltas and verifies:
- 25 × `40 ms` frames produce the expected rolling average/max;
- the >34 ms diagnostic counter increments;
- 40 ms does not increment the >=50 ms hitch counter;
- one injected `60 ms` sample increments both relevant counters;
- worst-frame tracking updates;
- HUD text exposes FPS, rolling average/max, slow/hitch counts and worst frame;
- debug static-memory label remains present;
- telemetry does not move or rotate the Hunter;
- telemetry does not change first-person state;
- telemetry does not change camera ownership;
- telemetry does not change Settings state;
- telemetry does not change Look Speed.

Successful deterministic definition:
`20 / 20 PASS`.

Gate:
`STAGE1_PERFORMANCE_TELEMETRY_RUNTIME_VERIFIED`.

The headless test proves telemetry calculation/non-mutation only. It does not prove Galaxy A03s sustained performance.

## First source-build verification

Workflow:
`33810956117`.

Head:
`89394067971120df43b184a8509934f5458185f2`.

Conclusion:
`SUCCESS`.

Verified:
- protected static preflight `154 / 154 PASS`;
- Monster collision `8 / 8 PASS`;
- world boundary `12 / 12 PASS`;
- Godot 4.7.2 import/parse PASS;
- Boot smoke PASS;
- ProbeWorld smoke PASS;
- aerial↔first-person `17 / 17 PASS`;
- lifecycle transient input `47 / 47 PASS`;
- performance telemetry `20 / 20 PASS`;
- Android export PASS;
- APK integrity PASS;
- artifact upload PASS.

## Sustained-performance phone protocol

New authority:
`probes/android_stage1/docs/SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md`.

The protocol was integrated into:
- `probes/android_stage1/README.md`;
- `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md` Test 6.

The fixed Galaxy A03s run is approximately `24` uninterrupted minutes:
1. `T+00–02` cold/normal launch and baseline stabilization;
2. `T+02–07` sustained aerial analog movement;
3. `T+07–09` exactly `20` controlled aerial↔first-person transitions;
4. `T+09–14` mixed movement/view interaction;
5. `T+14–24` sustained representative thermal/frame-pacing soak;
6. checkpoints at `T+02`, `T+07`, `T+09`, `T+14`, `T+19`, `T+24`.

Checkpoint evidence records:
- exact run/build identity;
- FPS;
- rolling average/max frame time;
- >34 ms count;
- >=50 ms count;
- worst frame;
- debug static memory;
- renderer/view mode;
- battery percentage;
- qualitative thermal feel;
- input responsiveness;
- visible hitch notes;
- evidence reference.

The transition checkpoint additionally records how many of the 20 controlled transitions show a repeatable obvious freeze and whether input remains immediately responsive.

The protocol defines explicit PASS / FAIL / REVIEW / STOP conditions and a copy/paste return record.

It does not pretend to have numeric CPU/GPU temperature, OS thermal-headroom, GPU utilization or Android frame-timeline data that the current probe does not expose.

## Protocol/documentation-head verification

Protocol/documentation commit:
`c02971996e35770bbaaaf9bf6c460af208db4f83`.

Because the modified probe-local documentation is inside the Stage-1 workflow trigger path, the exact documentation-head revision was rebuilt.

Workflow:
`33811355891`.

Conclusion:
`SUCCESS`.

Current exact verified gates:
- protected static preflight `154 / 154 PASS`;
- Monster collision guard `8 / 8 PASS`;
- world-boundary guard `12 / 12 PASS`;
- Godot 4.7.2 import/parse PASS;
- Boot smoke PASS;
- ProbeWorld smoke PASS;
- aerial↔first-person `17 / 17 PASS`;
- lifecycle transient input `47 / 47 PASS`;
- performance telemetry `20 / 20 PASS`;
- Android debug export PASS;
- APK archive integrity PASS;
- artifact upload PASS.

Exact inner APK from workflow `33811355891`:
- file `UnnamedHuntRPG-Stage1Probe-debug.apk`;
- size `57,570,361 bytes`;
- SHA-256 `f9cc00019f31fc7942c309b7178db3967cc1ecc726e6cc2a07d6b3d5ec32af59`.

Uploaded workflow artifact ZIP:
- name `UnnamedHuntRPG-Stage1Probe-debug`;
- artifact ID `9914945271`;
- archive size `57,124,301 bytes`;
- archive digest `sha256:a02d8a1b79f3d0b87f4694c72f897beaf925016f86495a264bd72303563a6188`.

The inner APK and uploaded artifact ZIP are different files. Their size/hash identities must never be exchanged.

The artifact was downloaded/read back after the workflow. `performance-telemetry.log` recorded `Failures: 0` and gate `STAGE1_PERFORMANCE_TELEMETRY_RUNTIME_VERIFIED`.

## Regression inspection

No automated regression failure was observed in:
- protected controls/settings/heading-reset guard;
- Monster representative collision guard;
- world-boundary guard;
- Godot parse;
- Boot/ProbeWorld smoke;
- aerial↔first-person continuity;
- lifecycle transient input;
- performance telemetry;
- Android export/integrity.

A nonblocking missing-icon warning remains unrelated to this bounded performance piece and was not mixed into it.

## Documentation reconciliation

This pass updates/maps:
- `probes/android_stage1/scripts/probe_world.gd`;
- `ci/stage1/performance_telemetry_test.gd`;
- `.github/workflows/stage1-android-probe-apk.yml`;
- `probes/android_stage1/docs/SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md`;
- `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md`;
- `probes/android_stage1/README.md`;
- `PERFORMANCE_BUDGETS_AND_CAPS.md`;
- root `README.md`;
- `docs/README.md`;
- `DOCUMENTATION_INDEX.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `EVOLVE_ALIGNMENT.md`;
- this specialized handoff.

The documentation map now explicitly treats README/front-door maintenance and `DOCUMENTATION_INDEX.md` integration as part of durable work rather than optional notes.

## Verification boundary

Still not verified:
- the 24-minute Galaxy A03s sustained run;
- current-build phone FPS/frame pacing;
- real phone thermal behavior;
- current-build phone input responsiveness;
- current-build transition hitch behavior;
- current Monster solidity on phone;
- current boundary behavior on phone;
- current aerial↔first-person visual/clipping behavior on phone;
- Android background/resume + lock/unlock behavior;
- absence of crash/ANR across the phone bundle;
- final engine selection.

`SUSTAINED_PERFORMANCE_PHONE_EXECUTED = NO / DEFERRED`.
`PERFORMANCE_VERIFIED = NO`.
`ENGINE_PHONE_PROBE_VERIFIED = NO`.
`FINAL_ENGINE_SELECTED = NO`.

## Exact continuation

Implementation blocker:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

Next implementation action when the phone is available:
`DEFERRED_GALAXY_A03S_PERFORMANCE_AND_REGRESSION_EXECUTION_WHEN_DEVICE_AVAILABLE`.

The user explicitly instructed development not to stop waiting for phone evidence. Therefore the next bounded action that can proceed now is:
`INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT`.

This next action is design-only and must not be combined with statuses, terrain-number finalization, Monster 01 attack authoring, berserk, party design or defeat/retreat behavior.
