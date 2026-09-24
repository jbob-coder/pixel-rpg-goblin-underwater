# Stage 1 Android Engine Probe

Status: PERFORMANCE TELEMETRY BUILD VERIFIED / SUSTAINED-PERFORMANCE PROCEDURE PREPARED / PHONE EXECUTION DEFERRED
Last reconciled: 2026-09-03

## Purpose

This directory is intentionally isolated from future production game source.

It answers the Stage-1 question:
**Can Godot 4.7 + GDScript + GL Compatibility deliver the required aerial/first-person presentation, touch control, large-monster readability and stable Android behavior on the Samsung Galaxy A03s?**

This probe is disposable evidence-gathering source. It must not silently become production domain/gameplay architecture.

## Mandatory read order for probe changes

1. root `EVOLVE_ALIGNMENT.md`;
2. `PROJECT_HANDOFF.md`;
3. newest relevant Stage-1 handoff;
4. this README;
5. `docs/CONTROL_CAMERA_FOUNDATION_README.md` for control/camera work;
6. `docs/PROBE_TEST_PROTOCOL.md`;
7. `docs/SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md` for sustained-performance work;
8. exact source/tests being changed.

## Protected camera/control behavior

Authority:
`docs/CONTROL_CAMERA_FOUNDATION_README.md`.

Protected baseline:
- analog movement joystick;
- each new touch captures current Hunter heading as stable movement reference;
- release/re-touch captures latest heading;
- Hunter faces resolved movement;
- aerial camera follows/trails Hunter heading and stays synchronized during first person;
- Settings + Controls → Look Speed;
- default Look Speed `35%`;
- persistence `user://stage1_settings.cfg` / `controls/look_speed`;
- Settings opening resets movement;
- aerial/first-person toggle remains separate from movement.

Do not silently remove or materially retune this behavior.

## Current probe contents

- `project.godot` — Godot 4.7 probe configuration;
- `scenes/boot.tscn` — minimal entry;
- `scenes/probe_world.tscn` — representative 3D scene + touch/settings UI + fixed Monster placeholder collider;
- `scripts/boot.gd` — scene transition;
- `scripts/probe_world.gd` — movement, heading reset, cameras, settings, boundary, lifecycle transient-input reset, visual Monster motion and low-overhead performance telemetry;
- `tests/static_preflight.py` — repository/protected-control QA;
- `tests/monster_collision_preflight.py` — Monster collision source guard;
- `tests/world_boundary_preflight.py` — outer-boundary source/geometry guard;
- root `ci/stage1/state_continuity_test.gd` — executable Godot view-continuity regression;
- root `ci/stage1/lifecycle_transient_input_test.gd` — executable lifecycle/focus transient-input regression;
- root `ci/stage1/performance_telemetry_test.gd` — executable performance-telemetry calculation/non-mutation regression;
- `docs/ANDROID_EXPORT_SETUP.md`;
- `docs/PROBE_TEST_PROTOCOL.md`;
- `docs/SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md`;
- `docs/CONTROL_CAMERA_FOUNDATION_README.md`.

## Deliberate simplifications

Hunter:
- 1.75 m capsule placeholder;
- no final model/rig/equipment.

Monster:
- large primitive visual volume;
- fixed representative solid collider;
- visual-only small bob/yaw;
- no production skeleton, AI, combat, animation set, anatomy hitboxes or production physics.

Environment:
- one simple 20 m × 20 m lit ground plane;
- one directional shadow test;
- current Hunter-center boundary `±8.5 m` on X/Z;
- no production Region 01 assets.

Lifecycle:
- no production lifecycle manager;
- no production save/load architecture;
- only transient joystick/touch ownership is cleared on application pause/resume and focus-out/focus-in;
- Hunter transform, view state, Settings state and Look Speed remain owned by their existing systems.

Performance instrumentation:
- no production profiler subsystem;
- no rendering/gameplay cost retuning in the telemetry pass;
- ProbeWorld records rolling real process-frame average/max, diagnostic slow/hitch counts and worst frame;
- existing debug static memory, renderer and view labels remain available;
- phone thermal state is not numerically inferred from headless/CI data.

## Renderer/platform configuration

- Godot family: 4.7;
- CI/build version: 4.7.2 stable;
- renderer: `gl_compatibility` desktop/mobile;
- logical viewport: 1600 × 720 landscape;
- Android frame pacing enabled;
- baseline phone: Samsung Galaxy A03s;
- target: stable 30 FPS minimum representative frame.

## Prior Galaxy A03s evidence

Observed on earlier Stage-1 APKs:
- install/runtime smoke;
- landscape + GL Compatibility/OpenGL3;
- instantaneous `60 FPS / ~16.7 ms`;
- `40.9 MiB` debug static memory;
- basic movement;
- basic first-person entry;
- outer boundary worked well;
- analog joystick and heading-follow camera preferred;
- prior Monster pass-through defect identified.

The instantaneous sample is not sustained-performance verification. Current-build phone regression remains deferred by explicit user instruction; missing evidence is not PASS.

## Current telemetry implementation lineage

Source commit:
`89394067971120df43b184a8509934f5458185f2`

Workflow:
`33810956117`

Conclusion:
`SUCCESS`.

Results:
- static preflight PASS (`154 / 154` existing suite);
- Monster collision `8 / 8 PASS`;
- world boundary `12 / 12 PASS`;
- Godot 4.7.2 parse PASS;
- Boot + ProbeWorld smoke PASS;
- aerial↔first-person executable regression `17 / 17 PASS`;
- lifecycle transient-input executable regression `47 / 47 PASS`;
- performance telemetry executable regression `20 / 20 PASS`;
- Android export PASS;
- APK archive integrity PASS;
- artifact upload PASS.

Exact inner APK:
- `UnnamedHuntRPG-Stage1Probe-debug.apk`;
- `57,570,361 bytes`;
- SHA-256 `6d1d5da79b350c15bab89aebea27bacf8eb38f44ff0ddf5943c56dd195670610`.

Workflow artifact archive:
- `UnnamedHuntRPG-Stage1Probe-debug`;
- artifact ID `9914806265`;
- archive size `57,124,305 bytes`;
- archive digest `sha256:fbcef13d4a95102caa679aedd2ac15f6eb4123e80c3c2c9b32455f917569f4b7`.

The artifact ZIP and the inner APK are different files; do not exchange their size/hash labels.

## Current performance telemetry source piece

Owner:
`scripts/probe_world.gd`.

Instrumentation:
- `FPS` from Godot engine FPS;
- rolling approximately one-second average/max process-frame duration from actual `_process(delta)`;
- cumulative frames above `34 ms`;
- cumulative frames at/above `50 ms`;
- cumulative worst process-frame duration;
- existing debug static-memory display.

Executable verification:
`ci/stage1/performance_telemetry_test.gd`.

The deterministic test verifies telemetry calculations/display and confirms that telemetry does not mutate Hunter transform, camera/view state, Settings state or Look Speed.

`PERFORMANCE_TELEMETRY_HEADLESS_VERIFIED = YES / 20_OF_20`.

This does not prove Galaxy A03s performance.

## Sustained-performance phone procedure

Authority:
`docs/SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md`.

Prepared procedure:
- one uninterrupted `24` minute Galaxy A03s run;
- fixed preconditions;
- baseline, aerial movement, 20 controlled view transitions, mixed interaction, and ten-minute thermal/frame-pacing soak;
- checkpoints at `T+02`, `T+07`, `T+09`, `T+14`, `T+19`, `T+24`;
- exact evidence fields;
- PASS/FAIL/REVIEW/STOP rules;
- copy/paste evidence return record.

Phone execution remains deferred. Do not mark `PERFORMANCE_VERIFIED` until direct target-device evidence exists.

## Current lifecycle source piece

Owner:
`scripts/probe_world.gd`.

Implemented behavior:
`_notification()` routes application pause/resume and focus-out/focus-in to existing `_reset_joystick()`.

Reason:
if the OS interrupts an active touch before the release event reaches the node, stale `_joystick_touch_id` / `_joystick_vector` state must not survive resume.

Executable verification:
`ci/stage1/lifecycle_transient_input_test.gd` — `47 / 47 PASS`.

Phone background/resume, lock/unlock and crash/ANR behavior remain deferred and unverified until direct Galaxy A03s evidence exists.

## Current gate truth

`IMPLEMENTATION_AUTHORIZED = YES`
`STATIC_PREFLIGHT_VERIFIED = YES / 154_OF_154`
`MONSTER_COLLISION_STATIC_VERIFIED = YES / 8_OF_8`
`WORLD_BOUNDARY_STATIC_VERIFIED = YES / 12_OF_12`
`VIEW_CONTINUITY_HEADLESS_VERIFIED = YES / 17_OF_17`
`LIFECYCLE_TRANSIENT_INPUT_HEADLESS_VERIFIED = YES / 47_OF_47`
`PERFORMANCE_TELEMETRY_HEADLESS_VERIFIED = YES / 20_OF_20`
`SUSTAINED_PERFORMANCE_PROTOCOL_PREPARED = YES`
`GODOT_PARSE_VERIFIED = YES`
`HEADLESS_BOOT_SMOKE_VERIFIED = YES`
`HEADLESS_PROBEWORLD_SMOKE_VERIFIED = YES`
`APK_BUILD_VERIFIED = YES`
`JOYSTICK_HEADING_RESET_PHONE_VERIFIED = NO / DEFERRED`
`MONSTER_COLLISION_PHONE_VERIFIED = NO / DEFERRED`
`WORLD_BOUNDARY_CURRENT_APK_PHONE_VERIFIED = NO / DEFERRED`
`VIEW_CONTINUITY_PHONE_VERIFIED = NO / DEFERRED`
`LIFECYCLE_PHONE_VERIFIED = NO / DEFERRED`
`SUSTAINED_PERFORMANCE_PHONE_EXECUTED = NO / DEFERRED`
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`

## Exact next probe action

`DEFERRED_GALAXY_A03S_PERFORMANCE_AND_REGRESSION_EXECUTION_WHEN_DEVICE_AVAILABLE`

The sustained-performance measuring contract is prepared. The remaining Stage-1 implementation gate requires direct phone evidence and must not be inferred from CI.

Independent non-phone design work may continue as its own bounded pass under root EVOLVE without changing this probe.

## Scope stop

Do not add real combat, harvesting, crafting, save architecture, production Hunter/Monster models, full Region 01, settlement source or production lifecycle architecture to this probe.
