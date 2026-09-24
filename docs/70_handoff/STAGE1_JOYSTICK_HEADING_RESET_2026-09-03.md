# Stage 1 Joystick Heading-Reset Pass — 2026-09-03

Status: SOURCE + BUILD VERIFIED / GALAXY A03s RETEST REQUIRED

## Trigger

Direct Galaxy A03s feedback on the analog-joystick build:
- control/settings direction was good;
- after turning toward east, the player still had to keep holding the joystick toward east just to continue moving straight east;
- user asked whether the joystick could align/reset so the next forward input follows the Hunter's new direction;
- user asked to continue foundation-first game development.

## Root cause

The previous joystick produced an analog vector that was mapped directly to fixed world X/Z axes.

Therefore joystick screen-up always meant the same world direction even after Hunter/camera heading changed.

This was a movement-reference-frame defect, not a Look Speed defect.

## Selected repair

Use a **per-touch heading-relative movement reference**.

On every new joystick touch:
1. capture current Hunter forward;
2. derive current Hunter right;
3. keep that basis frozen for the active gesture;
4. map joystick X/Y through that captured basis;
5. release resets movement/knob;
6. next touch captures the latest Hunter heading again.

Example:
`face north → push right → turn/move east → release → touch again → push up → continue east/forward`.

## Why the basis is frozen during the active gesture

Do not continuously rotate the joystick basis while the player is still holding the same direction.

If a right-stick direction were continuously interpreted against a Hunter basis that is itself rotating toward the resulting movement, the movement direction could keep rotating and produce curved/circling behavior.

Per-touch capture makes the gesture stable while still letting release/re-touch redefine forward naturally.

## Source

Owning source:
`probes/android_stage1/scripts/probe_world.gd`

Source commit:
`9d9e83898616e16c902d0d3caf8e9c82253bf8a7`

Added:
- `_joystick_reference_forward`;
- `_joystick_reference_right`;
- `_capture_joystick_reference_heading()`;
- `_joystick_world_vector()`;
- reference capture when a touch first claims the joystick.

## Protected contract update

Updated:
`probes/android_stage1/docs/CONTROL_CAMERA_FOUNDATION_README.md`

The protected control contract now explicitly includes:
- joystick is not permanently world-axis-relative;
- each new touch captures Hunter heading;
- active touch uses a stable basis;
- release/re-touch resets forward to current Hunter heading;
- future changes to this behavior require warning/documentation + Galaxy A03s regression testing.

## Regression guard

Updated:
`probes/android_stage1/tests/static_preflight.py`

The preflight now requires:
- heading-reference capture function;
- heading-relative world-vector mapping function;
- captured Hunter forward used for joystick forward intent;
- reference capture invocation remains present.

## Build evidence

Exact build revision:
`2e112210c60b62335f94adfd1a1573afb81426f6`

Workflow run:
`33783404093`

Results:
- static preflight `151 / 151 PASS`;
- Godot 4.7.2 import/parse PASS;
- Boot headless smoke PASS;
- ProbeWorld headless smoke PASS;
- Android debug export PASS;
- APK archive integrity PASS.

APK:
`UnnamedHuntRPG-Stage1Probe-heading-reset.apk`

Size:
`57,570,361 bytes`

SHA-256:
`1727750c3fc1f8385ed8c9bf1e4ccc3c559cede156e750380a1ff462c2bcfa8c`

## Galaxy A03s acceptance test

Test this specific sequence:
1. begin facing the initial direction;
2. push joystick right until Hunter faces/moves east;
3. release joystick fully;
4. touch joystick again and push upward;
5. Hunter should continue east/forward rather than returning to the original world-forward direction;
6. repeat for south/west/north headings;
7. verify an active held gesture remains stable rather than spiraling/circling;
8. verify partial/diagonal analog input still works;
9. verify Settings and saved Look Speed still work;
10. verify aerial ↔ first-person toggle still preserves physical position.

## Next separate foundation work

The already-confirmed brown Monster placeholder collision defect remains next after this control retest:
`MONSTER_PLACEHOLDER_SOLID_COLLISION_REPAIR`.

Do not combine it with combat, AI, damage, navigation, harvesting, production monster physics, or content expansion.
