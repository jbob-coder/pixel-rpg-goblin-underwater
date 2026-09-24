# Stage 1 Control / Camera Foundation — Protected Behavior README

Status: USER-DIRECTED FOUNDATION CONTRACT / SHOOTER-STYLE MOBILE CONTROL REVISION IMPLEMENTED / GALAXY A03s RETEST REQUIRED
Last reconciled: 2026-09-04

## Why this file exists

This file protects the current user-approved control/camera direction from silent later replacement or retuning.

If a future implementation changes the movement-stick model, right-side look, Settings/Look Speed persistence, first-person FOV, aerial camera geometry, lifecycle reset, or touch ownership, the change and reason must be recorded and re-tested through source/Godot/APK and Galaxy A03s evidence.

## Latest direct phone evidence

The user reported that the prior adaptive/latching implementation was getting closer but still felt buggy/janky because too many hidden variables affected when a direction became the new reference.

The user clarified the intended semantic:
- if the player is holding one direction and has not changed that stick direction, that means the desired extent/direction has already been reached;
- the control must not keep accumulating additional turn merely because the stick remains held;
- use a control structure similar in feel to Apex Legends Mobile rather than another threshold-heavy rebase state machine.

This supersedes all prior movement-reference models:
1. release-to-recenter — superseded;
2. deadzone/center-crossing recenter — superseded;
3. adaptive hold/alignment/latch/rebase — superseded.

## Research basis

Public descriptions of Apex Legends Mobile consistently describe the standard mobile-shooter split:
- left-side joystick controls movement forward/backward/side-to-side;
- the right thumb/right side of the screen adjusts camera/view;
- control layouts can use fixed or free/floating movement controls.

This project does NOT claim access to Apex Legends Mobile proprietary source code. We adopted the public control architecture/pattern, not copied implementation code.

References reviewed 2026-09-04:
- Tom's Guide, `Apex Legends Mobile is flawed — but it has still consumed my life` — left movement joystick, right thumb adjusts view.
- GamingOnPhone, `Apex Legends Mobile Guide: How to enable and customize Gyroscope` — left joystick moves forward/backward/side-to-side; right-side swipe turns camera.
- Pro Game Guides, `Best HUD settings for Apex Legends Mobile` — fixed/free movement control layouts.

## Current protected movement contract — shooter-style direct analog

Phone controls now use two independent touch roles.

### Left thumb — movement

1. The lower-left fixed joystick owns movement only.
2. Stick direction is a direct analog movement vector.
3. Stick magnitude controls movement magnitude after the deadzone.
4. Input is camera/view-relative.
5. Holding a fixed joystick direction keeps a fixed movement direction while the camera is unchanged.
6. Holding RIGHT does not accumulate yaw or silently change the stick basis.
7. Moving RIGHT -> DIAGONAL -> UP continuously changes movement according to the actual stick angle; no release, center crossing, timer, latch, or rebase event exists.
8. If the camera changes while movement is held, the movement vector follows the updated camera-relative basis, matching normal mobile-shooter behavior.
9. The left joystick cannot rotate the camera by itself.
10. Release zeroes movement and releases the movement touch owner.

Prototype movement deadzone:
`0.12` normalized radius.

### Right thumb — look/view

1. A touch beginning on the right-side look region may own camera look.
2. View yaw changes from horizontal drag.
3. In first person, view pitch changes from vertical drag and is clamped to ±80°.
4. The movement joystick and look gesture can be active simultaneously with different touch IDs.
5. The view-toggle and Settings button rectangles cannot be stolen by the look gesture.
6. Releasing the look touch stops look input without stopping movement.

Right-side look region begins at approximately:
`45%` of viewport width from the left.

## Look Speed

Settings -> Controls -> Look Speed.

Range:
`0–100%` in `5%` increments.

Default:
`35%`.

Persistence:
`user://stage1_settings.cfg`

Key:
`controls/look_speed`.

Look Speed now controls direct right-side view sensitivity rather than a hidden Hunter-turn response state machine.

Prototype sensitivity mapping:
- minimum `0.04°/pixel`;
- maximum `0.20°/pixel`;
- default 35% resolves to approximately `0.096°/pixel`.

Movement speed remains independent from Look Speed.

## Hunter/view relationship

The Hunter yaw follows the authoritative view yaw when the right-side look gesture changes yaw.

This allows normal shooter-style forward/back/strafe movement relative to the current view.

The left movement stick does not automatically rotate Hunter/view yaw toward its own movement vector.

## Aerial camera

Aerial camera remains elevated/angled and follows Hunter position, but its horizontal orientation is now view-owned rather than movement-stick-owned.

Prototype geometry retained:
- height `8.6 m`;
- trail `8.4 m`;
- look-ahead `2.2 m`;
- position follow response `7.0`.

Horizontal right-side drag rotates the aerial view around the Hunter.

Aerial pitch remains fixed in Stage 1; first-person owns vertical look proof.

## First-person camera

Current FOV:
`115°`.

User-requested acceptable range:
`110–120°`.

First-person horizontal view uses the same right-side drag architecture as aerial mode.

First-person vertical look is clamped to ±80°.

The previous `0.55` movement-driven turn-response multiplier is removed because movement no longer drives view yaw at all. This eliminates that source of first-person snap/jank instead of masking it with another multiplier.

## Enlarged Stage-1 steering arena

Current test floor:
`120 m × 120 m`.

Hunter-center horizontal bound:
`±56 m` X/Z.

Usable span:
approximately `112 m × 112 m`.

This remains Stage-1 evidence geometry only and does not override Region 01/Hunt-01 production coordinates.

## Settings / lifecycle safety

Opening Settings:
- zeroes movement;
- releases movement touch ownership;
- releases look touch ownership;
- preserves Hunter world position and persistent settings.

Android pause/resume/focus transitions also clear both transient touch owners so neither movement nor camera look can remain stuck after interruption.

## Automated acceptance

Dedicated workflow:
`Stage 1 Shooter-Style Joystick Camera Regression`.

Required checks include:
- FOV 115°;
- fixed RIGHT input stays fixed without accumulating yaw;
- diagonal and forward input map directly from actual stick angle;
- right-side drag changes view yaw independently;
- a held movement vector follows the updated camera basis when the player deliberately changes view;
- movement-stick input alone never changes view yaw;
- first-person pitch clamp;
- separate movement/look touch ownership;
- transient reset clears both controls;
- unchanged side deflection remains the same desired movement direction over sustained frames.

## Current Galaxy A03s acceptance test

1. Hold the left joystick RIGHT for several seconds without touching the right side.
2. The Hunter should keep moving in one stable rightward direction; camera yaw must not continue turning.
3. Move the left stick through diagonals and forward. Movement should follow the stick smoothly and immediately with no hidden transition.
4. Keep movement held and drag on the right side. The camera/view should rotate while movement remains camera-relative.
5. Use left movement + right look simultaneously.
6. In first person, test horizontal and vertical look. Confirm 115° FOV and no old movement-driven snap.
7. Verify buttons on the right still work and are not stolen by look input.
8. Verify Settings, view toggle, collision, world boundary, pause/resume, and stuck-input behavior.

## Verification boundary

Automated/headless validation can prove mapping/state invariants, but only Galaxy A03s evidence can establish touch feel/acceptance.

Do not call Stage 1 phone-verified until the user accepts this shooter-style revision.
