# Stage 1 Probe Static QA

Status: STATIC PREFLIGHT ACTIVE / CONTROL-CAMERA FOUNDATION GUARDS ADDED / GODOT + PHONE EVIDENCE STILL REQUIRED
Last reconciled: 2026-09-03

## Purpose

Catch repository-level regressions in the isolated Stage 1 Android probe before runtime testing.

Primary command from the probe root:

```bash
python tests/static_preflight.py
```

The checker uses only the Python standard library.

## What a PASS means

`STATIC_PREFLIGHT_VERIFIED` means the static invariants owned by this checker passed. It includes:
- required probe/docs files exist;
- main-scene/resource paths resolve;
- Godot 4.7 / GL Compatibility / 1600×720 / Android frame-pacing settings remain present;
- scene resource declarations/uses are valid at the static-text level;
- duplicate resource IDs and duplicate node paths are rejected;
- scene parent paths, root scripts, signals and current `@onready` paths resolve;
- Boot/ProbeWorld retain intended root/script pairings;
- the probe contains only the authorized GDScript source boundary.

## Protected control-camera guard

User-approved continuity authority:
`../docs/CONTROL_CAMERA_FOUNDATION_README.md`.

The preflight now intentionally fails if a future change silently removes or reverts the Stage-1 control baseline.

It verifies static evidence for:
- analog `MoveJoystick`;
- joystick knob;
- `SETTINGS` button;
- tabbed Settings overlay;
- `Controls` tab;
- `Look Speed` slider and signal;
- stable persistence path `user://stage1_settings.cfg`;
- persistence key `controls/look_speed`;
- default Look Speed `35%`;
- joystick update/reset handlers;
- camera synchronization call;
- absence of the old Up/Down/Left/Right arrow Button nodes.

This is deliberate. If a later evidence-based change legitimately alters one of those protected behaviors, update the protected README, explain the reason, update the guard in the same bounded pass, and re-test on the Galaxy A03s.

**Do not weaken the guard merely to make a red build green.**

## What a PASS does NOT mean

The checker is not Godot and is not Android.

A PASS never substitutes for:
- Godot import/parse;
- scene runtime smoke;
- Android export/APK integrity;
- phone installation;
- joystick touch behavior;
- Look Speed persistence behavior;
- camera quality;
- sustained performance/thermal verification.

## Current expected source boundary

Authorized GDScript files remain:
- `scripts/boot.gd`;
- `scripts/probe_world.gd`.

The joystick/settings refinement intentionally stays in `probe_world.gd`; it does not create a production input/settings architecture inside this disposable probe.

## Required workflow

1. Read current repository `EVOLVE_ALIGNMENT.md`.
2. Read `../docs/CONTROL_CAMERA_FOUNDATION_README.md` for camera/control work.
3. Make one bounded source/configuration change.
4. Run static preflight.
5. Fix static failures at their cause.
6. Run Godot import/parse.
7. Run Boot and ProbeWorld smoke.
8. Export and integrity-check Android APK.
9. Test the exact APK on Galaxy A03s.
10. Record phone evidence separately from build evidence.

## Current gate

The harness has previously proven it can catch missing resources, unexpected GDScript and duplicate resource IDs. The current joystick/settings extension adds protected-behavior checks; the exact new check count is determined by the next real-checkout CI run and must not be guessed here.

`STATIC_PREFLIGHT_HARNESS = ACTIVE`
`CONTROL_CAMERA_PROTECTED_GUARDS = RECORDED`
`GODOT_RUNTIME_VERIFICATION = REQUIRED_AFTER_EACH_RELEVANT_CHANGE`
`PHONE_RUNTIME_VERIFICATION = REQUIRED_FOR_PLAYER_FACING_CONTROL/CAMERA_CHANGES`
