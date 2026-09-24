# Stage 1 Galaxy A03s Runtime Evidence — 2026-09-03

Status: TARGET-DEVICE VISUAL SMOKE PASS / FULL PHONE PROTOCOL PENDING

## Scope

This record captures only evidence directly supported by the user-provided Galaxy A03s runtime screenshot for the Stage 1 Android probe. It does not infer touch reliability, first-person behavior, lifecycle stability, sustained performance, thermal behavior, or final engine suitability.

Tested APK lineage:
- branch: `worldlife-reference-docs`;
- successful Android build commit: `b6ca288380f81b03a69f0f33533c34d54600856e`;
- artifact: `UnnamedHuntRPG-Stage1Probe-debug.apk`;
- Godot build tooling: 4.7.2 stable;
- APK build/integrity gate: PASS before device delivery.

## Direct screenshot evidence

The screenshot shows the probe running on the target-device test path with:
- landscape orientation active;
- `ProbeWorld` visibly rendered rather than a black screen;
- Hunter placeholder visible;
- large Monster placeholder visible;
- ground/light/shadows visible;
- aerial camera active;
- touch directional controls visible;
- aerial/first-person toggle visible;
- metrics HUD visible and legible;
- runtime FPS display: `60`;
- approximate displayed frame time: `16.7 ms/frame`;
- renderer display: `gl_compatibility / opengl3`;
- debug static memory display: `40.9 MiB`;
- current view display: `AERIAL`.

## Gates supported by this evidence

`GALAXY_A03S_INSTALL_VERIFIED = YES`

Reason: the user installed the delivered APK and supplied a screenshot from the running application.

`PHONE_COLD_OR_NORMAL_LAUNCH_TO_PROBEWORLD = PASS_EVIDENCE`

Reason: the application reached the 3D probe scene without a visible crash, ANR, or black-screen failure in the supplied evidence.

`LANDSCAPE_VISUAL_SMOKE = PASS_EVIDENCE`

`GL_COMPATIBILITY_OPENGL3_RUNTIME_PATH = OBSERVED`

`AERIAL_RENDER_VISUAL_SMOKE = PASS_EVIDENCE`

`METRICS_HUD_VISUAL_SMOKE = PASS_EVIDENCE`

`PHONE_RUNTIME_VERIFIED = PARTIAL`

Reason: one screenshot proves basic target-device execution but not the full phone runtime contract.

`PERFORMANCE_VERIFIED = NO`

Reason: `60 FPS / ~16.7 ms` is a valuable instantaneous sample, but a screenshot cannot establish sustained frame pacing, movement responsiveness, transition hitches, memory trend, or thermal degradation.

`ENGINE_PHONE_PROBE_VERIFIED = NO`

## Non-blocking observation

Android system status/navigation bars remain visible around the probe. This is not a Stage 1 engine blocker, but it should be treated as a later presentation/safe-area/fullscreen decision rather than silently becoming the final game presentation.

## Remaining phone tests

The next bounded target-device pass should execute only the existing protocol, with no new probe features:

1. Hold each directional control and confirm movement starts/stops correctly.
2. Rapidly alternate directions and confirm no stuck movement flag.
3. Toggle AERIAL ↔ FIRST PERSON repeatedly and confirm no position drift or severe clipping.
4. Confirm the Monster remains readable in first person.
5. Run the probe continuously for at least 10 minutes while observing FPS, stutter, input latency and device heat.
6. Background/resume the app and lock/unlock once; verify no duplicate scene, crash, or stuck input.
7. Report any repeatable issue with a screenshot/video and exact action sequence.

## Current evidence boundary

Do not claim from this screenshot alone:
- final visual quality;
- touch-input verification;
- camera-transition verification;
- stable 60 FPS;
- stable 30 FPS under representative sustained load;
- thermal safety;
- lifecycle correctness;
- final Godot engine selection.

The correct next action is to finish Tests 4–7 from `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md` against this exact APK before adding Stage 2 gameplay systems.
