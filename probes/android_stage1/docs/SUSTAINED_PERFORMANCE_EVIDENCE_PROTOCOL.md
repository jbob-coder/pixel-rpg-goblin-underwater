# Galaxy A03s Sustained Performance Evidence Protocol

Status: PREPARED / TELEMETRY BUILD VERIFIED / GALAXY A03s EXECUTION DEFERRED / PERFORMANCE NOT VERIFIED
Last reconciled: 2026-09-03

## Purpose

Define one reproducible Stage-1 sustained-performance run for the Samsung Galaxy A03s so engine viability is judged from comparable evidence rather than a one-frame FPS screenshot or subjective feel.

This protocol prepares the measurement gate. It does **not** claim the Galaxy A03s run has been executed.

## Ownership and authorities

Performance budget authority:
`../../../PERFORMANCE_BUDGETS_AND_CAPS.md`

Probe gate authority:
`PROBE_TEST_PROTOCOL.md` — Test 6.

Telemetry source owner:
`../scripts/probe_world.gd`

Executable telemetry regression:
`../../../ci/stage1/performance_telemetry_test.gd`

Telemetry source revision:
`89394067971120df43b184a8509934f5458185f2`

Verified workflow for that source revision:
`33810956117` — `SUCCESS`.

Primary representative target:
stable `30 FPS` minimum on Galaxy A03s.

## What the current telemetry means

ProbeWorld displays:

- `FPS` — Godot `Engine.get_frames_per_second()`;
- `1s avg` — average actual `_process(delta)` frame duration over the most recently completed approximately one-second telemetry window;
- `1s max` — largest actual `_process(delta)` frame duration in that same completed window;
- `>34ms` — cumulative count of process frames above `34.0 ms` since ProbeWorld loaded;
- `>50ms` — cumulative count of process frames at or above `50.0 ms` since ProbeWorld loaded;
- `worst` — largest process-frame delta observed since ProbeWorld loaded;
- `Debug static memory` — `Performance.MEMORY_STATIC` converted to MiB;
- renderer and current view mode — existing Stage-1 labels.

The `34 ms` and `50 ms` values are diagnostic thresholds. They are not by themselves a product-level PASS/FAIL decision.

All cumulative counters restart when ProbeWorld/app state is recreated. Record one uninterrupted run for comparable counts.

## What this telemetry does not measure

The probe does not directly read:
- CPU temperature;
- GPU temperature;
- Android thermal-headroom APIs;
- per-core CPU utilization;
- GPU utilization;
- battery current draw;
- OS-level frame timeline/jank classification.

Thermal evidence in this Stage-1 phone pass is therefore a combination of sustained frame behavior, battery percentage, user-observed device warmth, and any Android thermal warning. Do not invent numeric temperature claims.

## Automated telemetry verification already completed

Workflow `33810956117` on source `89394067971120df43b184a8509934f5458185f2` verified:
- protected static preflight `154 / 154 PASS`;
- Monster collision guard `8 / 8 PASS`;
- world-boundary guard `12 / 12 PASS`;
- Godot 4.7.2 import/parse PASS;
- Boot smoke PASS;
- ProbeWorld smoke PASS;
- aerial↔first-person runtime regression `17 / 17 PASS`;
- lifecycle transient-input runtime regression `47 / 47 PASS`;
- performance telemetry runtime regression `20 / 20 PASS`;
- Android debug export PASS;
- APK archive integrity PASS;
- artifact upload PASS.

The telemetry regression deterministically proved the calculation/display contract and non-mutation of Hunter transform, camera/view ownership, Settings state, and Look Speed. It does not prove target-phone frame pacing.

Exact inner APK produced by that source workflow:
- size `57,570,361 bytes`;
- SHA-256 `6d1d5da79b350c15bab89aebea27bacf8eb38f44ff0ddf5943c56dd195670610`.

Uploaded workflow artifact archive:
- name `UnnamedHuntRPG-Stage1Probe-debug`;
- artifact ID `9914806265`;
- archive size `57,124,305 bytes`;
- archive SHA-256 `fbcef13d4a95102caa679aedd2ac15f6eb4123e80c3c2c9b32455f917569f4b7`.

The inner APK and the uploaded artifact ZIP are different files; never exchange their size/hash labels.

## Phone preconditions

Use one fixed setup for the full run and record deviations.

Required:
1. Galaxy A03s baseline device;
2. exact current Stage-1 APK lineage being tested recorded by commit/SHA;
3. phone unplugged from charger for the sustained run;
4. battery between `40%` and `90%` at start when practical;
5. Battery Saver/Power Saving disabled;
6. brightness fixed near `50%` and the actual setting recorded;
7. case state fixed and recorded (`CASE ON` or `CASE OFF`);
8. close nonessential foreground/recent apps where practical;
9. begin after the phone has returned close to normal room-temperature feel rather than immediately after charging/heavy use;
10. keep the game foregrounded and screen awake for this performance run;
11. do not intentionally lock/background the app during this run because lifecycle evidence is a separate gate.

Avoid screen recording by default because recording can change rendering/thermal load. External-camera photos/video are preferred. If an Android screenshot is used, record when it was taken so a screenshot-induced hitch is not misclassified as game behavior.

## Fixed 24-minute representative run

### T+00:00 to T+02:00 — cold launch / baseline stabilization

- cold/normal launch the app;
- enter ProbeWorld;
- leave the Hunter mostly idle;
- confirm renderer and metrics are visible;
- do not reset/relaunch once the timed run starts unless the run has failed.

At `T+02:00`, record Checkpoint A.

### T+02:00 to T+07:00 — sustained aerial movement

For five minutes:
- use the analog joystick continuously for representative movement;
- include forward, diagonal and curved/heading-changing paths;
- move around the Monster placeholder and toward world-boundary areas without intentionally trying to exploit collision;
- keep normal aerial-camera behavior active.

At `T+07:00`, record Checkpoint B.

### T+07:00 to T+09:00 — transition-hitch isolation

Keep the Hunter stationary except for minimal correction.

Execute exactly `20` aerial↔first-person transitions, approximately one transition every six seconds.

Observe:
- visible freeze/stutter;
- input response after each transition;
- changes in cumulative `>50ms` count;
- `worst` frame time.

Do not take a screenshot during a transition.

At `T+09:00`, record Checkpoint C and the number of transitions with an obvious repeatable freeze.

### T+09:00 to T+14:00 — mixed interaction

For five minutes:
- resume analog movement;
- use direction changes and diagonal input;
- occasionally switch view while moving/after stopping;
- keep interaction representative rather than deliberately stress-spamming controls.

At `T+14:00`, record Checkpoint D.

### T+14:00 to T+24:00 — sustained thermal/frame-pacing soak

For ten uninterrupted minutes, repeat a representative interaction rhythm:
- roughly one minute of aerial movement and turns;
- brief first-person entry/exit;
- continue movement;
- repeat without backgrounding the app.

Record Checkpoint E at `T+19:00` and Checkpoint F at `T+24:00`.

The run is complete only after Checkpoint F unless a STOP condition is reached.

## Checkpoint evidence fields

Record these fields at A/B/C/D/E/F:

| Field | Required value |
|---|---|
| Run ID | date/time + short identifier |
| Elapsed time | `02:00`, `07:00`, `09:00`, `14:00`, `19:00`, `24:00` |
| Branch/commit | exact tested revision |
| APK SHA-256 | exact inner APK hash when known |
| FPS | current displayed FPS |
| 1s avg ms | current telemetry value |
| 1s max ms | current telemetry value |
| >34ms count | cumulative value |
| >50ms count | cumulative value |
| worst ms | cumulative worst value |
| Debug static memory | MiB |
| Renderer | displayed renderer/driver |
| View mode | AERIAL / FIRST PERSON |
| Battery | percentage |
| Thermal feel | `COOL / WARM / HOT / OS_WARNING` |
| Input response | `NORMAL / DELAYED / STUCK` |
| Visible hitch notes | concise observation |
| Evidence ID | photo/video/log reference or `NONE` |

For Checkpoint C additionally record:
- `20` transitions completed: YES/NO;
- transitions with a repeatable obvious freeze;
- whether input remained responsive immediately after every transition.

## PASS / FAIL / REVIEW / STOP classification

### PASS candidate

The sustained-performance phone gate may be marked PASS only when direct Galaxy A03s evidence shows all of the following:
- the full `24` minute run completes without crash, ANR, renderer corruption or forced restart;
- no repeatable steady-state period of approximately five seconds or longer remains below `30 FPS`;
- representative checkpoints B, D, E and F are at or above `30 FPS` (equivalently the current one-second average is not persistently above about `33.3 ms`);
- input remains usable with no stuck movement and no repeatable control stall of approximately `0.5 s` or longer;
- the 20-transition segment does not produce a repeatable severe transition freeze attributable to the game;
- no Android thermal warning appears;
- the final thermal-soak segment does not fall persistently below the 30 FPS target;
- memory checkpoints do not show obvious monotonic runaway growth requiring investigation.

PASS requires the whole evidence packet. A single good screenshot is not enough.

### FAIL trigger

Classify the run FAIL and preserve evidence if any of these occurs reproducibly:
- crash or ANR;
- renderer corruption that prevents normal play;
- sustained/repeatable steady-state performance below `30 FPS`;
- stuck input or repeatable control stalls of approximately `0.5 s` or longer;
- severe transition freezes of `100 ms` or more attributable to the same transition behavior on at least `3` of the `20` controlled transitions;
- sustained thermal degradation that takes representative play below the 30 FPS minimum.

The `100 ms / 3-of-20` transition condition is an investigation/failure trigger for this Stage-1 probe, not a universal final-game frame-time budget.

### REVIEW / thermal-risk trigger

Do not automatically FAIL the engine for:
- isolated `>=50 ms` hitches;
- a one-off OS notification/screenshot hitch;
- one anomalous checkpoint not reproduced in surrounding play;
- a persistent frame-time slowdown of approximately `20%` or more from the earlier representative baseline while the game still remains at/above `30 FPS`;
- monotonic memory growth that does not yet cause failure.

Record these as `REVIEW` / `THERMAL_RISK` / `MEMORY_RISK` and investigate one bounded cost/cause at a time.

### STOP condition

Stop the run safely and record `NOT PASS / STOPPED` if:
- Android displays a thermal/battery safety warning;
- the device becomes uncomfortably hot to hold;
- battery falls below `15%`;
- crash/ANR prevents continuing;
- any device-safety condition makes continuation inappropriate.

Do not continue a stress run merely to finish the timer.

## Comparison rule

When comparing two builds:
- use the same Galaxy A03s;
- use the same 24-minute sequence;
- keep brightness/case/power mode comparable;
- record both exact commits/APK hashes;
- compare representative checkpoints and cumulative counters;
- change only one major performance-cost family at a time.

If a failure is found, the visual-cost isolation order remains:
1. directional shadows;
2. decorative vegetation when it exists;
3. particles/VFX when they exist;
4. internal render scale;
5. Monster/distance detail.

Do not preemptively lower quality before evidence identifies a bounded problem.

## Copy/paste return record

```text
STAGE1_A03S_PERFORMANCE_RUN
Run ID:
Date/time:
Phone: Samsung Galaxy A03s
Branch/commit:
APK SHA-256:
Start battery:
End battery:
Brightness:
Case: ON/OFF
Power saving: OFF/OTHER

A T+02 | FPS= | avg_ms= | max_ms= | >34= | >50= | worst_ms= | mem_MiB= | battery= | thermal= | input= | evidence=
B T+07 | FPS= | avg_ms= | max_ms= | >34= | >50= | worst_ms= | mem_MiB= | battery= | thermal= | input= | evidence=
C T+09 | FPS= | avg_ms= | max_ms= | >34= | >50= | worst_ms= | mem_MiB= | battery= | thermal= | input= | frozen_transitions_of_20= | evidence=
D T+14 | FPS= | avg_ms= | max_ms= | >34= | >50= | worst_ms= | mem_MiB= | battery= | thermal= | input= | evidence=
E T+19 | FPS= | avg_ms= | max_ms= | >34= | >50= | worst_ms= | mem_MiB= | battery= | thermal= | input= | evidence=
F T+24 | FPS= | avg_ms= | max_ms= | >34= | >50= | worst_ms= | mem_MiB= | battery= | thermal= | input= | evidence=

Crash/ANR: YES/NO
Renderer corruption: YES/NO
OS thermal warning: YES/NO
Repeatable <30 FPS >=5s: YES/NO
Repeatable input stall >=0.5s: YES/NO
Notes:
```

## Current gate truth

`PERFORMANCE_TELEMETRY_SOURCE_IMPLEMENTED = YES`
`PERFORMANCE_TELEMETRY_HEADLESS_VERIFIED = YES / 20_OF_20`
`PERFORMANCE_TELEMETRY_APK_BUILD_VERIFIED = YES`
`SUSTAINED_PERFORMANCE_PROTOCOL_PREPARED = YES`
`SUSTAINED_PERFORMANCE_PHONE_EXECUTED = NO / DEFERRED`
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`

Preparation is complete only when this protocol, Test 6, probe README, project handoff/index, and EVOLVE all point to the same evidence contract and exact next gate.
