# Stage 1 Control / Camera Refinement — 2026-09-03

Status: SOURCE + PROTECTED REGRESSION GUARDS + APK BUILD VERIFIED / GALAXY A03s RETEST PENDING

## Trigger

Direct Galaxy A03s feedback on the camera-follow build:
- camera-follow concept worked, but turning was too aggressive;
- user requested a Settings button;
- Settings should use tabs;
- one tab should expose `Look Speed`;
- old four directional touch keys should be replaced by an analog joystick for better control;
- the setting/decision must be saved and documented so future work does not silently change it without warning.

This user feedback superseded the prior camera-retune waiting state for this bounded control/camera piece.

## Bounded scope completed

Implemented only the Stage-1 control/camera foundation refinement:
1. analog movement joystick;
2. calmer tunable camera/Hunter heading response;
3. Settings button + tabbed Settings overlay;
4. persisted Look Speed;
5. durable protected-behavior README;
6. executable static regression guards preventing silent reversion.

Not included:
- Monster placeholder collision repair;
- combat;
- Monster AI/damage/navigation;
- production settings architecture;
- production UI art;
- right-stick/free-look combat camera system;
- final accessibility tuning.

## Source changes

`probes/android_stage1/scripts/probe_world.gd`
- old four-button boolean movement removed;
- analog joystick vector added;
- joystick touch ownership/reset logic added;
- analog magnitude/deadzone handling added;
- Settings open state zeros movement;
- Look Speed persisted with Godot `ConfigFile`;
- settings path: `user://stage1_settings.cfg`;
- key: `controls/look_speed`;
- default Look Speed: `35%`;
- Hunter turn and aerial-camera follow response derive from Look Speed;
- aerial camera continues updating during first-person mode to avoid stale return framing.

`probes/android_stage1/scenes/probe_world.tscn`
- removed Up/Down/Left/Right Button nodes;
- added lower-left `MoveJoystick` + `Knob`;
- added top-right `SETTINGS` button;
- added tabbed `SettingsOverlay`;
- added `Controls` tab with `Look Speed` slider;
- added `Display` placeholder tab only;
- retained AERIAL/FIRST PERSON toggle.

## Protected continuity authority

Created:
`probes/android_stage1/docs/CONTROL_CAMERA_FOUNDATION_README.md`

Primary law:
**do not silently replace, remove or materially retune the approved joystick/settings/look-speed/camera behavior.**

A future change must state the reason, preserve prior behavior/value in the record, update regression guards, rebuild, and re-test on Galaxy A03s.

## Executable regression guard

`probes/android_stage1/tests/static_preflight.py` now checks for:
- MoveJoystick;
- joystick Knob;
- Settings button;
- tabbed Settings overlay;
- Controls tab;
- Look Speed slider/signal;
- stable persistence path/key;
- default Look Speed 35%;
- joystick handlers;
- camera synchronization;
- absence of the old four arrow Button nodes;
- existence of the protected control-camera README.

This turns the continuity requirement into an executable build guard.

## Verified CI/build evidence

Exact tested source revision:
`1a90569e4b625c929274dffbeaf4f9ede368fe43`

GitHub Actions run:
`33781148418`

Results:
- static preflight: `147 / 147 PASS`;
- Godot 4.7.2 import/parse: PASS;
- Boot headless smoke: PASS;
- ProbeWorld headless smoke: PASS;
- Android debug export: PASS;
- APK archive integrity: PASS;
- artifact upload: PASS.

Built APK for phone retest:
`UnnamedHuntRPG-Stage1Probe-joystick-settings.apk`

APK size:
`57,570,361 bytes`

APK SHA-256:
`afb007424b9abfc6108b5759b2bbe974ae1db754b45b71fab58ca927a227a3cd`

Build success does not establish phone control quality or persistence behavior.

## Phone acceptance test for this exact refinement

On the Galaxy A03s:
1. drag joystick partially and verify slower analog movement magnitude;
2. drag fully and verify full movement;
3. verify diagonal motion;
4. release joystick and verify immediate stop/no stuck input;
5. open Settings and verify movement is reset;
6. Controls tab → set Look Speed low/high and verify turn response changes;
7. choose preferred Look Speed and close Settings;
8. restart app and confirm value persists;
9. verify camera remains behind/follows Hunter heading without aggressive snapping at the chosen value;
10. verify first-person/aerial toggling still preserves position.

## Separate known next defect

The brown Monster placeholder still has no trustworthy solid collision and remains independently recorded as:
`MONSTER_PLACEHOLDER_SOLID_COLLISION_REPAIR`.

Do not repair it until this current control/camera build receives phone evidence, unless a new explicit user instruction supersedes that sequencing.

## Current gate truth

`ANALOG_JOYSTICK_SOURCE_IMPLEMENTED = YES`
`SETTINGS_TABS_SOURCE_IMPLEMENTED = YES`
`LOOK_SPEED_SOURCE_IMPLEMENTED = YES`
`LOOK_SPEED_PERSISTENCE_IMPLEMENTED = YES`
`CONTROL_CAMERA_PROTECTED_README = RECORDED`
`CONTROL_CAMERA_STATIC_GUARDS = 147_OF_147_PASS`
`GODOT_PARSE_VERIFIED_FOR_CONTROL_BUILD = YES`
`PROBEWORLD_SMOKE_VERIFIED_FOR_CONTROL_BUILD = YES`
`APK_BUILD_VERIFIED_FOR_CONTROL_BUILD = YES`
`CONTROL_CAMERA_PHONE_RUNTIME_VERIFIED = NO / RETEST_PENDING`
`MONSTER_PLACEHOLDER_SOLID_COLLISION = FAIL_EVIDENCE / NEXT_SEPARATE_REPAIR`
