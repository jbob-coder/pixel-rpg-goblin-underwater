# 60_quality — Verification, Performance, Debug and Creator Quality

Status: ACTIVE QUALITY MAP / CURRENT CANONICAL CI + HISTORICAL HUNT-01/STAGE-1 EVIDENCE  
Last reconciled: 2026-09-25

## Purpose

Own quality/verification protocols, evidence vocabulary, performance/testing guidance, and historical QA references.

## Current canonical automated verification

Workflow:

`.github/workflows/pixel-rpg-ci.yml`

Current automated layers include:

- Python static/preflight tests;
- Godot import/parse;
- AppShell smoke;
- all discovered `game/tests/*_test.gd`;
- Android debug export;
- APK integrity;
- SHA-256;
- byte-size recording;
- evidence/artifact upload.

## Current test locations

Godot runtime/regression:

`game/tests/`

Static/preflight:

- `tests/quality/hunt01/`;
- `tests/quality/pixel_rpg/`;
- `probes/android_stage1/tests/`.

The current canonical GDScript discovery loop runs `game/tests/*_test.gd`.

Do not assume `ci/stage1/*.gd` is a current canonical gate unless current invocation is proven.

## Historical QA evidence

This package may reference older:

- Hunt-01 manifest/static verification;
- Stage-1 control/camera tests;
- Galaxy A03s probe evidence;
- older workflow IDs.

Those results remain valid only for the exact revisions/device evidence they identified.

They are not the current project baseline.

## Evidence law

Keep separate:

- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

A passing Android build does not prove:

- touch feel;
- safe areas;
- first-person composition;
- no black screen on the target phone;
- sustained FPS;
- heat;
- lifecycle behavior;
- installed footprint.

## Current runtime reference

Audited implementation baseline from the repository scan:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical run:

`36082533109` — SUCCESS.

This remains automated/build evidence only.

## Quality ownership

Quality documentation may define acceptance protocols.

Actual verification status comes from current logs/workflows/device evidence.
