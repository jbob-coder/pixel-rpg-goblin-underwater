# Stage 1 Android Lifecycle Transient-Input Reset — 2026-09-03

Status: SOURCE + HEADLESS RUNTIME + ANDROID BUILD VERIFIED / GALAXY A03s LIFECYCLE EVIDENCE DEFERRED

## Bounded piece

`ANDROID_LIFECYCLE_TRANSIENT_INPUT_RESET_IMPLEMENTATION_AND_HEADLESS_REGRESSION`

This bounded piece is complete at the highest currently available automated verification level.

## Root cause

The Stage-1 analog joystick owns transient active-touch state in `_joystick_touch_id` and `_joystick_vector`.

A normal matching release calls `_reset_joystick()`, but Android pause/defocus can interrupt the active touch before that release reaches ProbeWorld. Without a lifecycle boundary, stale touch ownership/vector state can survive and cause stuck movement or prevent a new touch from acquiring the joystick.

The prior lifecycle review correctly rejected broad lifecycle/save reconstruction because current source has no evidence of a duplicate-scene creation path, and Look Speed already persists independently.

## Implemented source behavior

Owner:
`probes/android_stage1/scripts/probe_world.gd`.

Source commit:
`9bcde8404d787180e399b9e44e89cc6760d31c3c`.

Added `_notification(what)` and routed these boundaries to the existing `_reset_joystick()`:
- `NOTIFICATION_APPLICATION_PAUSED`;
- `NOTIFICATION_APPLICATION_RESUMED`;
- `NOTIFICATION_APPLICATION_FOCUS_OUT`;
- `NOTIFICATION_APPLICATION_FOCUS_IN`.

No second reset implementation was introduced.

The lifecycle reset intentionally does not mutate:
- Hunter transform;
- `_first_person`;
- camera tuning/ownership beyond existing state;
- `_settings_open` / Settings visibility;
- `_look_speed` or persisted Look Speed;
- Monster collision;
- world-boundary behavior;
- production save/load state.

## Executable regression

New test:
`ci/stage1/lifecycle_transient_input_test.gd`.

The real ProbeWorld is instantiated and deliberately placed in non-default first-person + Settings-open state. For each lifecycle/focus notification the test:
1. seeds an active touch ID and nonzero joystick vector;
2. injects the notification through `Object.notification()`;
3. verifies touch ID clears to `-1`;
4. verifies joystick vector clears to zero;
5. verifies Hunter position/rotation are unchanged;
6. verifies first-person/camera ownership remains unchanged;
7. verifies Settings state remains unchanged;
8. verifies Look Speed remains unchanged;
9. verifies only one ProbeWorld exists;
10. repeats the notification to verify idempotence and non-transient state preservation.

Deterministic test definition executes `47` checks in the successful path.

Gate:
`ANDROID_LIFECYCLE_TRANSIENT_INPUT_RUNTIME_VERIFIED`.

## CI integration and verification

Workflow:
`.github/workflows/stage1-android-probe-apk.yml`.

Run:
`33809412041`.

Head revision:
`9bcde8404d787180e399b9e44e89cc6760d31c3c`.

Conclusion:
`SUCCESS`.

Verified steps:
- protected static preflight PASS (`154 / 154` existing suite);
- Monster collision guard `8 / 8 PASS`;
- world-boundary guard `12 / 12 PASS`;
- Godot 4.7.2 import/parse PASS;
- Boot headless smoke PASS;
- ProbeWorld headless smoke PASS;
- aerial↔first-person continuity runtime regression `17 / 17 PASS`;
- Android lifecycle transient-input runtime regression `47 / 47 PASS` by deterministic test definition;
- Android debug export PASS;
- APK archive integrity PASS;
- build evidence/APK artifact upload PASS.

Workflow artifact:
- name `UnnamedHuntRPG-Stage1Probe-debug`;
- artifact ID `9914228633`;
- artifact archive size `57,122,507 bytes`;
- artifact archive digest `sha256:7ccf8396616f85d582ec325e3c3b92829153864b1777eb2d170f0e222ef75687`.

Important:
these artifact size/digest values describe the uploaded ZIP artifact archive, not the inner APK. The inner APK size/hash are not copied here without direct readback of those exact build-evidence files.

## Regression inspection

No automated regression failure was observed in:
- protected controls/settings/heading-reset static guard;
- representative Monster collider guard;
- world-boundary guard;
- Godot parse;
- Boot/ProbeWorld smoke;
- aerial↔first-person continuity;
- lifecycle transient-input regression;
- Android export/integrity.

The lifecycle source change is intentionally orthogonal to camera tuning, Hunter movement geometry, Monster collision and boundary constants.

## Owning documentation reconciled

Updated in this pass:
- `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md`;
- `probes/android_stage1/README.md`;
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- this specialized handoff.

## Verification boundary / remaining unverified evidence

Automated lifecycle verification does **not** prove:
- Android OS actually delivers every lifecycle/focus notification in every interruption order;
- Galaxy A03s background/resume behavior;
- Galaxy A03s lock/unlock behavior;
- real touch cancellation/system gesture behavior;
- crash/ANR absence over the phone lifecycle loop;
- sustained frame pacing or thermal behavior.

Those remain deferred phone evidence by explicit user instruction and must not be marked PASS without device evidence.

## Exact next implementation piece

`STAGE1_SUSTAINED_PERFORMANCE_EVIDENCE_PREPARATION`

Scope:
prepare one reproducible Galaxy A03s sustained frame-pacing/thermal evidence packet from the current performance budget and Probe Test 6 contract. Define exact run sequence, evidence fields, pass/fail/stop conditions, and only add non-invasive instrumentation if the existing probe metrics are insufficient.

Do not preemptively tune rendering/gameplay costs and do not claim the sustained phone test has executed.

Independent design lane remains:
`INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT`.
