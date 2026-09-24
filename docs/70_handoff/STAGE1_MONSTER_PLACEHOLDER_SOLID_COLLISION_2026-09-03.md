# Stage 1 Monster Placeholder Solid Collision Repair — 2026-09-03

Status: SOURCE + STATIC + GODOT + APK BUILD VERIFIED / PHONE COLLISION RETEST DEFERRED

## Trigger

Direct Samsung Galaxy A03s evidence from the prior Stage-1 build established that the Hunter could move through the brown Monster placeholder.

Current user instruction on 2026-09-03 explicitly says not to stop development waiting for phone reports. Missing phone checks must be recorded for later while foundation work continues one bounded piece at a time.

## Bounded piece

`MONSTER_PLACEHOLDER_SOLID_COLLISION_REPAIR`

Scope is limited to making the representative brown Monster volume a solid obstacle in the isolated Stage-1 engine probe.

Explicitly out of scope:
- combat;
- Monster AI/behavior;
- damage;
- navigation;
- harvesting;
- production Monster physics;
- production anatomy/hitboxes;
- Region 01 implementation.

## Root cause

Before this repair, `probes/android_stage1/scenes/probe_world.tscn` represented the Monster only as a `MeshInstance3D` with a `BoxMesh`.

A visual mesh is not a physics collision body, so the Hunter `CharacterBody3D` had nothing solid to collide against.

## Selected repair

Added a separate `StaticBody3D` named `MonsterCollider` at the Monster's base position with a `BoxShape3D` matching the representative Monster volume:

- position: `Vector3(0, 1.2, -5.5)`;
- size: `Vector3(2.5, 2.4, 5.8)`.

The existing `Monster` visual node remains a `MeshInstance3D` and retains its small procedural bob/yaw presentation motion.

The collider intentionally stays fixed because the current Stage-1 placeholder does not translate through the world; its motion is cosmetic around a fixed footprint. This keeps the repair smaller than introducing moving-body physics and avoids silently turning probe behavior into production Monster physics.

## Regression guard

Added:
`probes/android_stage1/tests/monster_collision_preflight.py`

It checks that:
- `Shape_monster` exists;
- representative visual/collision dimensions remain aligned;
- `MonsterCollider` remains a `StaticBody3D`;
- the collision shape is parented to that body;
- the Monster visual node remains intact.

The Stage-1 Android workflow runs this collision preflight immediately after the existing repository static preflight.

## Source commit

Commit:
`c5e8fc8ceb5633d574ef49cd684a9d39a5bd643f`

## Automated verification evidence

Workflow run:
`33806628904`

Results:
- existing Stage-1 static preflight: `154 / 154 PASS`;
- dedicated Monster collision preflight: `8 / 8 PASS`;
- Godot import/parse: PASS;
- Boot headless smoke: PASS;
- ProbeWorld headless smoke: PASS;
- Android debug export: PASS;
- APK archive integrity: PASS.

APK:
`UnnamedHuntRPG-Stage1Probe-debug.apk`

Size:
`57,570,361 bytes`

SHA-256:
`0d2fa6c0accf1964d5a98dae07a2d03a2e59fa00ee0b0a10c9781c507a89a523`

Automated result boundary:
`MONSTER_PLACEHOLDER_SOLID_COLLISION_SOURCE_IMPLEMENTED = YES`
`MONSTER_PLACEHOLDER_SOLID_COLLISION_STATIC_VERIFIED = YES`
`MONSTER_PLACEHOLDER_SOLID_COLLISION_APK_BUILD_VERIFIED = YES`

These results do **not** prove target-phone solidity.

## Deferred Galaxy A03s acceptance test

Phone collision acceptance remains required later.

Valid current-layout checks:
1. approach the brown Monster from the front and both accessible sides;
2. press continuously into it;
3. verify the Hunter cannot cross through the solid representative volume;
4. slide along accessible edges/corners and verify no obvious tunneling-through behavior;
5. verify outer world-boundary containment still works;
6. verify joystick/settings/look-speed and aerial ↔ first-person behavior are not regressed.

Layout constraint discovered during the later world-boundary guard pass:
the Monster rear extent reaches approximately `z = -8.4` while the Hunter-center boundary is `z = -8.5`; a full rear approach is therefore not physically available in this probe layout. Rear approach is not a valid required phone acceptance step unless a separate bounded test-layout pass later repositions the placeholder.

Until phone evidence exists:
`MONSTER_PLACEHOLDER_SOLID_COLLISION_PHONE_VERIFIED = NO / DEFERRED_PENDING_USER_PHONE_EVIDENCE`.

The heading-reset joystick phone retest is likewise still deferred, not passed.

## Regression inspection

The repair did not change:
- `probe_world.gd` movement/control code;
- joystick reference-frame behavior;
- Look Speed values or persistence;
- aerial-camera geometry/response;
- first-person toggle logic;
- outer `PROBE_BOUNDS` clamp;
- Monster visual mesh dimensions or base position.

## Next foundation state

Monster collision source/build work is closed at the automated boundary. Current implementation work has advanced to the world-boundary guard and then to the aerial ↔ first-person continuity guard as recorded by EVOLVE.
