# 60_quality — Verification, Performance, Debug and Creator Quality

Status: ACTIVE QUALITY PACKAGE / HUNT-01 MANIFEST STATIC VERIFIED / PHONE RETEST ACTIVE
Last reconciled: 2026-09-04

## Purpose

Own executable validation, test fixtures, regression evidence, performance budgets/device ledgers and bounded debug/creator quality requirements.

## Hunt-01 manifest static validation

Owner contract:
`../10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.

Executable package:
`../../tests/quality/hunt01/`.

Workflow:
`.github/workflows/hunt01-graybox-manifest-static.yml`.

Workflow run:
`33830978945` SUCCESS.

Result:
- 13/13 MANIFEST_STATIC rules PASS;
- 0 errors;
- 0 warnings;
- invalid fixture/mutation correctly rejected with 5 errors;
- observation ramp measured 6.607 m;
- segment grades 15.2% / 15.38%.

`HUNT01_GRAYBOX_MANIFEST_STATIC_VALIDATOR_IMPLEMENTED = YES`
`HUNT01_GRAYBOX_MANIFEST_STATIC_VERIFIED = YES / 13_OF_13`.

Higher levels remain:
`SCENE_STATIC_FUTURE = NOT_EXECUTED`
`RUNTIME_FUTURE = NOT_EXECUTED`
`PHONE_FUTURE = NOT_EXECUTED`.

## Stage-1 control/camera QA

User phone feedback generated one repair pass.

Repair commit:
`02459116216d3ac75ddd3d90c80f32bcbaa9662b`.

Dedicated headless regression:
`.github/workflows/stage1-control-camera-feedback.yml`.

Run:
`33831517381` SUCCESS.

Checks include:
- 115° first-person FOV;
- first-person response lower than aerial at same Look Speed;
- held off-center joystick basis remains stable;
- same-finger neutral crossing recaptures current Hunter heading;
- up after neutral follows recaptured heading;
- reset clears touch state.

Full Android build run:
`33831517331` SUCCESS.

Phone acceptance remains required for the corrected feel.

## Verification law

- static PASS is not scene PASS;
- headless PASS is not phone PASS;
- compile/APK PASS is not performance PASS;
- direct user/device evidence may verify the exact behavior observed, but must not be generalized beyond it.

Exact current quality action:
`STAGE1_FINAL_GALAXY_A03S_CONTROL_CAMERA_RETEST`.
