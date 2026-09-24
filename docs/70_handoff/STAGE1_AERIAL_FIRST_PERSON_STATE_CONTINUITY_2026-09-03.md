# Stage 1 Aerial ↔ First-Person State Continuity Regression — 2026-09-03

Status: EXECUTABLE HEADLESS RUNTIME + GODOT + APK BUILD VERIFIED / PHONE VISUAL RETEST DEFERRED

## Bounded piece

`AERIAL_FIRST_PERSON_STATE_CONTINUITY_REGRESSION_GUARD_AND_BUILD_VERIFICATION`

Purpose:
verify that the Stage-1 view toggle changes camera/presentation state without mutating the authoritative Hunter transform, and that the aerial camera continues synchronizing while first person is active so return-to-aerial does not revive stale state.

## Owning source

`probes/android_stage1/scripts/probe_world.gd`

Current source intends:
- `_on_toggle_view_pressed()` only flips `_first_person` and calls `_update_view_state()`;
- `_update_view_state()` switches current cameras, Hunter body visibility and HUD mode text;
- `_physics_process()` calls `_update_aerial_camera(delta)` regardless of active view;
- Hunter authoritative position is not explicitly changed by the view-toggle handler.

No camera/control retune was needed for this piece.

## Executable regression

Added:
`ci/stage1/state_continuity_test.gd`

The workflow runs this as a real Godot `SceneTree` test against `probes/android_stage1/`.

Runtime assertions:
1. initial mode is aerial;
2. Hunter body is visible;
3. toggle enters first person;
4. Hunter body hides;
5. entry preserves Hunter position;
6. entry preserves Hunter rotation;
7. moved Hunter position remains authoritative while first person is active;
8. moved Hunter heading remains authoritative;
9. hidden aerial camera continues synchronizing;
10. toggle returns to aerial;
11. Hunter body restores;
12. return preserves Hunter position;
13. return preserves Hunter rotation;
14. return does not revive stale aerial-camera position;
15. twenty repeated toggles end in aerial mode;
16. repeated toggles do not drift Hunter position;
17. repeated toggles do not drift Hunter rotation.

## Automated verification evidence

Source commit:
`c218b273a49dbdce78ce143698fd87d07bdd2643`

Workflow run:
`33807677829`

Results:
- Stage-1 static preflight `154 / 154 PASS`;
- Monster collision preflight `8 / 8 PASS`;
- world-boundary preflight `12 / 12 PASS`;
- Godot 4.7.2 import/parse PASS;
- Boot smoke PASS;
- ProbeWorld smoke PASS;
- aerial/first-person continuity runtime `17 / 17 PASS`;
- Android debug export PASS;
- APK integrity PASS;
- artifact upload PASS.

Representative runtime evidence:
- Hunter moved to `(2.0, 0.875, 0.0)` while first person was active and retained that position;
- Hunter yaw `0.75` remained authoritative;
- hidden aerial camera advanced to `(3.564535, 9.475, 8.706672)`;
- returning to aerial preserved that synchronized camera state;
- twenty additional toggles produced zero Hunter transform drift.

APK:
`UnnamedHuntRPG-Stage1Probe-debug.apk`

Size:
`57,570,361 bytes`

SHA-256:
`db046d03d778228e6343b5ada35f2fa9392a8c79c519d1e7cd58d632e701c6da`

Artifact ID:
`9913594654`

Automated state:
`AERIAL_FIRST_PERSON_STATE_CONTINUITY_HEADLESS_VERIFIED = YES / 17_OF_17`
`AERIAL_FIRST_PERSON_STATE_CONTINUITY_APK_BUILD_VERIFIED = YES`
`AERIAL_FIRST_PERSON_STATE_CONTINUITY_PHONE_VERIFIED = NO / DEFERRED_PENDING_USER_PHONE_EVIDENCE`

## Scope exclusions

This piece did not:
- modify camera tuning;
- modify Look Speed;
- modify joystick/reference-frame behavior;
- add first-person free-look/right stick;
- add combat aiming;
- modify Monster collision;
- modify world boundary;
- create production camera architecture.

## Deferred Galaxy A03s acceptance

Later phone checks:
- toggle aerial → first person → aerial repeatedly while stationary;
- repeat after moving/turning in each view;
- verify Hunter does not teleport or drift;
- verify returned aerial framing follows current Hunter location/heading;
- verify first-person framing has no severe clipping;
- verify joystick/settings/Look Speed remain usable.

## Next piece

`ANDROID_LIFECYCLE_BACKGROUND_RESUME_FOUNDATION_REVIEW`
