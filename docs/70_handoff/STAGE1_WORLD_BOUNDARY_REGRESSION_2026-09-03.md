# Stage 1 World-Boundary Regression Guard — 2026-09-03

Status: STATIC + GODOT + APK BUILD VERIFIED / CURRENT-APK PHONE REGRESSION DEFERRED

## Bounded piece

`WORLD_BOUNDARY_REGRESSION_GUARD_AND_BUILD_VERIFICATION`

Purpose:
protect the existing Stage-1 outer-boundary containment behavior from accidental regression without retuning the boundary or turning the probe into production world architecture.

## Existing evidence

Earlier Galaxy A03s testing produced positive user evidence that the invisible outer boundary contained the Hunter well.

That is evidence for the earlier tested APK only. It does not automatically verify the current build lineage.

## Owning source

`probes/android_stage1/scripts/probe_world.gd`

Current contract:
- `PROBE_BOUNDS = 8.5` meters;
- movement resolves through `hunter.move_and_slide()` first;
- then Hunter X and Z are clamped to `[-PROBE_BOUNDS, +PROBE_BOUNDS]`;
- Y is not hard-clamped by this boundary path;
- the bounded position is written back before aerial-camera synchronization.

Scene geometry used by the guard:
- floor footprint: `20 m × 20 m`;
- Hunter collision radius: `0.32 m`;
- boundary leaves `1.5 m` from Hunter-center limit to each floor edge, greater than the Hunter collision radius.

## Change decision

No movement/source retune was justified by current evidence.

This piece adds a regression guard only.

Added:
`probes/android_stage1/tests/world_boundary_preflight.py`

It verifies:
1. `PROBE_BOUNDS` still exists and remains the phone-positive prototype value `8.5`;
2. `move_and_slide()` remains before the clamp;
3. both X and Z are clamped with `PROBE_BOUNDS`;
4. the bounded position is assigned back to the Hunter;
5. Y is not silently added to the hard clamp;
6. the boundary remains geometrically inside the floor footprint with at least one Hunter collision radius of margin.

The Stage-1 Android CI workflow executes this guard after the existing protected-control and Monster-collision static guards.

## Automated verification evidence

Source commit:
`2fee61830c8d9357ea0bc254beba64a7d60123c9`

Workflow run:
`33807117767`

Results:
- Stage-1 static preflight `154 / 154 PASS`;
- Monster collision preflight `8 / 8 PASS`;
- world-boundary guard `12 / 12 PASS`;
- Godot 4.7.2 import/parse PASS;
- Boot headless smoke PASS;
- ProbeWorld headless smoke PASS;
- Android debug export PASS;
- APK archive integrity PASS;
- artifact upload PASS.

APK:
`UnnamedHuntRPG-Stage1Probe-debug.apk`

Size:
`57,570,361 bytes`

SHA-256:
`997df9672eec09811e56d09e24d6866e01305e35d0f150f3a7e6fe8008d24d7d`

Artifact ID:
`9913388938`

Automated boundary:
`WORLD_BOUNDARY_STATIC_VERIFIED = YES`
`WORLD_BOUNDARY_APK_BUILD_VERIFIED = YES`
`WORLD_BOUNDARY_CURRENT_APK_PHONE_VERIFIED = NO / DEFERRED_PENDING_USER_PHONE_EVIDENCE`

## Scope exclusions

This piece did not:
- change `PROBE_BOUNDS`;
- change movement speed;
- change joystick behavior;
- change camera behavior;
- change Monster collision;
- add production world barriers;
- add Region 01 streaming/navigation;
- add combat or domain systems.

## Deferred Galaxy A03s acceptance

Current-build phone regression remains deferred under the user's instruction not to stop development waiting for phone reports.

Later acceptance:
- press continuously toward each X/Z outer direction;
- verify the Hunter remains inside the intended playable square;
- test diagonal pressure into all four corners;
- verify collision with the Monster does not allow escaping the world clamp;
- verify view toggling does not move the Hunter outside the boundary;
- verify no stuck movement/input appears at the edge.

## Testability note discovered during this pass

The current Monster collider center is `z = -5.5` with length `5.8 m`, so its rear extent reaches approximately `z = -8.4`, only `0.1 m` inside the `-8.5` Hunter-center boundary.

Therefore a full Hunter approach from behind the Monster is not physically available in the current probe layout. The collision phone test should use front + both accessible sides + edge/corner pressure unless a separate bounded test-layout pass later repositions the placeholder.

This does not change collision geometry or boundary size.

## Next piece

`AERIAL_FIRST_PERSON_STATE_CONTINUITY_REGRESSION_GUARD_AND_BUILD_VERIFICATION`
