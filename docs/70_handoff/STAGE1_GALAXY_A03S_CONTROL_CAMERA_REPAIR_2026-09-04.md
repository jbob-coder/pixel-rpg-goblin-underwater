# Handoff — Stage 1 Galaxy A03s Control / Camera Repair

Date: 2026-09-04
Status: USER PHONE FEEDBACK RECEIVED / REPAIR IMPLEMENTED / AUTOMATED BUILD VERIFIED / FINAL PHONE RETEST REQUIRED

## Direct user phone evidence

User reported the prior Stage-1 APK otherwise worked correctly on phone with no clipping or other reported problems.

Remaining issues:
1. joystick required lifting the finger before a new forward reference could be captured after turning;
2. first-person left/right turning felt too snappy;
3. first-person FOV needed to be 110–120 degrees.

User stated Stage 1 may be treated as passed after this corrected behavior is retested successfully.

## Repair

Commit:
`02459116216d3ac75ddd3d90c80f32bcbaa9662b`

Implemented:
- joystick reference remains frozen while stick is outside deadzone;
- crossing back through neutral/deadzone recaptures latest Hunter heading once without requiring finger release;
- pushing up after neutral follows the new heading;
- aerial response unchanged;
- first-person Hunter turn response uses `0.55` multiplier;
- first-person FOV set to `115°`.

Owner:
`probes/android_stage1/docs/CONTROL_CAMERA_FOUNDATION_README.md`.

## Dedicated regression

Workflow:
`33831517381`

Result:
SUCCESS

Automated checks PASS:
- FOV 115°;
- first-person response lower than aerial (`2.64` vs `4.80` at 35% Look Speed);
- held off-center basis remains stable;
- same-finger neutral crossing recaptures current heading;
- neutral zeroes movement;
- up after neutral uses recaptured heading;
- reset clears touch/transient state.

This headless PASS does not replace phone acceptance.

## Full Android APK pipeline

Workflow:
`33831517331`

Result:
SUCCESS

All existing Stage-1 gates passed again:
- static preflight;
- Monster collision preflight;
- world boundary preflight;
- Godot parse/import;
- Boot smoke;
- ProbeWorld smoke;
- aerial↔first-person continuity;
- lifecycle transient-input regression;
- performance telemetry regression;
- Android debug export;
- APK integrity;
- artifact upload.

Fresh APK:
- file `UnnamedHuntRPG-Stage1-Phone-Retest.apk`;
- size `57,570,361 bytes`;
- SHA-256 `09b1faf49a4f7ca41d0a0926497e8c11469f5882bf6eba2f8799792f8e9d9c71`.

GitHub artifact:
- ID `9921862513`;
- ZIP size `57,124,750 bytes`;
- ZIP SHA-256 `37b51ca380b06a7617536a4591ee65543950469abc6f0aed04dbe17ec8fb6c47`.

Google Drive:
- folder `Unnamed Hunt RPG`;
- file `UnnamedHuntRPG-Stage1-Phone-Retest.apk`;
- Drive ID `1X86K00hKsvPorcUKXO4b-UIBHBHtwXoc`.

## Final phone retest

Required minimum:
1. hold joystick right until Hunter/camera faces right;
2. without lifting finger, drag through center/deadzone;
3. push up; Hunter should continue along the newly faced direction;
4. verify first-person left/right feel is no longer too snappy;
5. verify 115° FOV is acceptable;
6. confirm no regression to clipping, collision, Settings, view toggle, boundary or stuck input.

If this passes, close the Stage-1 functional phone gate per user direction and begin the first production Hunt-01 graybox implementation slice.

`PERFORMANCE_VERIFIED` remains a separate sustained-device evidence label and must not be inferred solely from this functional retest.
