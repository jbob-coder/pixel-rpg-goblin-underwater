# Handoff — Stage 1 Galaxy A03s Shooter-Style Mobile Controls Repair

Date: 2026-09-04
Status: USER FEEDBACK RECEIVED / SHOOTER-STYLE CONTROLS IMPLEMENTED / FINAL AUTOMATION GREEN / GALAXY A03s FEEL RETEST REQUIRED

## User requirement

The adaptive/latching joystick still felt janky. The user clarified that an unchanged held direction means the desired direction has already been reached; unchanged input must not keep accumulating turn. The user asked for an Apex Legends Mobile-like control structure.

## Research result

Public descriptions of Apex Legends Mobile show the standard mobile-shooter split: left joystick for movement and right thumb/right side for camera/view. No proprietary Apex source code was accessed; this project adopts the public control architecture only.

## Current implementation

Runtime implementation commit:
`6079c95f90a6329b2685f4c078527ae4a0dc1523`.

Final tested source/UI head:
`5af416f48a7542b964084f83301de0a5f826bb46`.

Owner:
`probes/android_stage1/docs/CONTROL_CAMERA_FOUNDATION_README.md`.

Current model:
- left joystick = direct camera-relative movement;
- right-side drag = independent view yaw;
- first-person vertical look = pitch, clamped ±80°;
- fixed joystick direction never accumulates additional camera turn;
- movement and look use independent touch owners;
- no adaptive hold timer, alignment dot, latch, forward cone, or rebase state;
- first-person FOV `115°`;
- Look Speed default `35%`, persisted at `controls/look_speed`.

Arena remains `120×120 m` with Hunter bound `±56 m` X/Z.

## Final automated evidence

Dedicated shooter-style workflow:
`33834916358` — SUCCESS.

Full Android workflow:
`33834916327` — SUCCESS.

Full pipeline passed static preflight, Monster collision, enlarged world boundary, Godot parse, Boot/ProbeWorld smoke, aerial↔first-person continuity, lifecycle transient-input regression, performance telemetry regression, Android export, APK ZIP integrity and upload.

Final artifact:
- ID `9922965651`
- ZIP size `57,126,005 bytes`
- ZIP SHA-256 `a9e61564d13d2be0ba84a052e990e9b9772a82d46a6070e0f9bdf551412ac873`

Final APK:
`UnnamedHuntRPG-Stage1-ShooterStyle-FinalRetest.apk`
- size `57,574,457 bytes`
- SHA-256 `e45e854951ff8a3cca9c93a20575aa967f824d86981ce3ba268372a0b19f6a6f`
- APK archive integrity PASS.

Google Drive:
- folder `Unnamed Hunt RPG`
- file `UnnamedHuntRPG-Stage1-ShooterStyle-FinalRetest.apk`
- Drive ID `1r62HYqQkZGyAj8h7zPzFm68Au31dqxzy`
- Drive file was replaced in place with the exact final APK.

## Required Galaxy A03s test

1. Hold LEFT or RIGHT without right-side look. Movement must remain stable; camera yaw must not continue rotating.
2. Sweep the left stick continuously around the circle. Movement must follow the actual stick angle directly with no hidden latch/rebase transition.
3. Hold movement and swipe on the right side. View must rotate independently; movement stays camera-relative.
4. Use left movement and right look simultaneously.
5. In first person, test horizontal and vertical look; FOV remains 115° and pitch clamps normally.
6. Verify Settings and view-toggle taps are not stolen by look input.
7. Verify Monster collision, outer boundary, pause/resume, Settings reset and no stuck movement/look.

## Verification boundary

`STAGE1_SHOOTER_STYLE_CONTROLS_AUTOMATED_VERIFIED = YES`
`STAGE1_SHOOTER_STYLE_CONTROLS_PHONE_ACCEPTED = NO / RETEST REQUIRED`
`ENGINE_PHONE_PROBE_VERIFIED = NO / PENDING USER FEEL ACCEPTANCE`
`PERFORMANCE_VERIFIED = NO / SUSTAINED SOAK SEPARATE`
`FINAL_ENGINE_SELECTED = NO`.

If the user reports PASS, close the Stage-1 functional phone-control gate and begin `FIRST_SLICE_REGION01_HUNT01_MINIMAL_ENGINE_GRAYBOX_IMPLEMENTATION`.
