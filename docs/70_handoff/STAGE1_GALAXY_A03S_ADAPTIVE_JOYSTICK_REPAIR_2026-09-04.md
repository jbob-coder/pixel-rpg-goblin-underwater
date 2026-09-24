# Handoff — Stage 1 Galaxy A03s Adaptive Joystick Repair

Date: 2026-09-04
Status: USER FEEDBACK RECEIVED / ADAPTIVE STEERING IMPLEMENTED / ENLARGED ARENA IMPLEMENTED / AUTOMATED APK VERIFIED / GALAXY A03s FEEL RETEST REQUIRED

## Direct user evidence

User rejected both earlier recenter interaction models:
1. release-to-recenter;
2. neutral/deadzone-crossing-to-recenter.

Required behavior:
- do not force finger release;
- do not force return to 0/center;
- automatically recognize a sustained new movement direction;
- after the Hunter/camera turns into that movement direction, the same held stick can be straightened toward up/forward while preserving that new world heading;
- the test arena must be substantially larger for sustained steering tests.

Prior phone evidence still stands for the previously tested build unless contradicted by the new retest:
- general runtime worked correctly;
- no reported clipping/general issue;
- aerial camera behavior acceptable.

## Implementation

Adaptive implementation commit:
`be38c84ff5951a7fa3826a9f7aaed5a78eed91cc`.

Final tested source head:
`e9b89912f1c80e90114a68a6de9de4ffbcdd6777`.

Owner:
`probes/android_stage1/docs/CONTROL_CAMERA_FOUNDATION_README.md`.

Current adaptive steering:
- current world movement intent is latched while an off-center direction is held;
- after Hunter facing aligns with sustained movement for the prototype hold period, the joystick reference rebases to that heading without altering current movement;
- the same finger may then slide from the old side direction toward screen-up/forward;
- movement remains on the committed world heading during that straightening gesture;
- entering the forward cone completes the rebase and normal heading-relative mapping continues;
- no release or deadzone crossing is required;
- unchanged off-center input cannot continuously rotate the movement basis into a circle;
- deliberate non-straightening movement remains a valid new steering request.

Prototype adaptive values:
- hold `0.18 s`;
- alignment dot `0.985`;
- raw-change dot `0.985`;
- strength-change threshold `0.12`;
- forward completion dot `0.90`.

First-person remains:
- FOV `115°`;
- turn-response scale `0.55`;
- aerial behavior intentionally unchanged.

## Enlarged test arena

Previous floor/bound was too small for sustained steering evidence.

Current probe:
- floor `120 m × 120 m`;
- horizontal Hunter-center bound `±56 m` X/Z;
- usable bounded span approximately `112 m × 112 m`;
- floor margin beyond bound `4 m` per outer side.

This is Stage-1 test geometry only and does not override Region 01/Hunt-01 production coordinates.

## Dedicated adaptive regression

Workflow:
`33833083005`

Result:
SUCCESS.

Verified automatically:
- 120×120 m floor / 56 m bound / 112 m usable span;
- Godot 4.7.2 parse;
- FOV 115°;
- first-person response remains damped relative to aerial;
- north start + held RIGHT resolves east;
- sustained aligned east movement rebases the reference without release;
- rebase leaves the held east world intent unchanged;
- RIGHT -> diagonal-up -> UP keeps east movement without deadzone entry;
- same touch pointer remains owner throughout;
- a second adaptive turn also succeeds in the same touch gesture;
- reset clears world intent/touch ownership.

Gate:
`STAGE1_ADAPTIVE_JOYSTICK_RUNTIME_VERIFIED` — headless evidence only.

## Full Android APK pipeline

Workflow:
`33833083007`

Result:
SUCCESS.

Passed:
- static probe preflight;
- Monster collision preflight;
- enlarged world-boundary preflight;
- Godot import/parse;
- Boot smoke;
- ProbeWorld smoke;
- aerial↔first-person continuity;
- lifecycle transient-input regression;
- performance telemetry regression;
- Android export;
- APK ZIP integrity;
- artifact upload.

APK:
`UnnamedHuntRPG-Stage1-AdaptiveJoystick-Retest.apk`

Size:
`57,574,457 bytes`.

SHA-256:
`88b53cb20cac97751f30cc79033ed0e715544e8e26446b06e887e8ea894a5cf1`.

GitHub artifact:
- ID `9922375605`;
- ZIP size `57,127,235 bytes`;
- ZIP SHA-256 `56b5892ae19715ecbf03e05c356d179b1e914a3b27317b76930c219327602ea8`.

Google Drive:
- folder `Unnamed Hunt RPG`;
- file `UnnamedHuntRPG-Stage1-AdaptiveJoystick-Retest.apk`;
- Drive ID `1anJ1sY4ajJuJsID62pvgNKZYBvyYi3QV`.

## Required Galaxy A03s retest

1. Start facing roughly north.
2. Hold joystick RIGHT until movement/facing stabilizes to the right/east.
3. Keep the same finger down.
4. Do **not** return the stick to center/deadzone.
5. Slide RIGHT -> diagonal-up -> UP.
6. Hunter should continue moving along the established right/east heading while the physical stick is straightened.
7. Once UP, UP should now behave as forward on that new heading.
8. Make another turn and repeat without releasing the same touch.
9. Hold one off-center direction for several seconds and confirm no circular drift.
10. Use the larger arena for long straight runs and repeated turns.
11. Confirm 115° first-person FOV and reduced first-person snappiness remain acceptable.
12. Confirm no regression to Monster collision, outer boundary, Settings, aerial/first-person toggle, Android pause/resume, or stuck movement.

## Verification boundary

`STAGE1_ADAPTIVE_JOYSTICK_AUTOMATED_VERIFIED = YES`
`STAGE1_ENLARGED_ARENA_AUTOMATED_VERIFIED = YES`
`STAGE1_ADAPTIVE_JOYSTICK_PHONE_ACCEPTED = NO / RETEST REQUIRED`
`ENGINE_PHONE_PROBE_VERIFIED = NO / PENDING ADAPTIVE FEEL RETEST`
`PERFORMANCE_VERIFIED = NO / SUSTAINED SOAK REMAINS SEPARATE`
`FINAL_ENGINE_SELECTED = NO`.

If the user reports this retest PASS, close the Stage-1 functional phone gate and begin the smallest production Hunt-01 engine graybox implementation. Sustained performance remains its own evidence gate.
