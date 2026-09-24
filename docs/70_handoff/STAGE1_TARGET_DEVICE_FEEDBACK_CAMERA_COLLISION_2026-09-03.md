# Stage 1 Galaxy A03s Feedback — Camera / Collision — 2026-09-03

Status: TARGET-DEVICE FEEDBACK RECORDED / CAMERA ROOT CAUSE PATCHED + REBUILT / PHONE RETEST PENDING / COLLISION DEFECT NEXT

## Purpose

Capture the user's direct Galaxy A03s feedback from the verified Stage 1 APK and convert it into exact implementation/test state without overclaiming untested behavior.

Tested prior APK lineage:
- successful build commit: `b6ca288380f81b03a69f0f33533c34d54600856e`;
- target device: Samsung Galaxy A03s;
- Godot: 4.7.2 stable build tooling;
- renderer observed previously: GL Compatibility / OpenGL3.

## Direct user feedback

User reported:
- probe runs well;
- basic first-person mode works;
- all four directional touch controls can be used to move;
- outer edge/invisible boundary behavior works well;
- aerial camera remains visually fixed toward one forward direction instead of following the Hunter's movement heading as desired;
- Hunter can move inside/through the brown Monster placeholder.

## Evidence classification

Supported on the prior APK:
- `BASIC_TOUCH_DIRECTIONAL_MOVEMENT = PASS_EVIDENCE`;
- `FIRST_PERSON_BASIC_ENTRY = PASS_EVIDENCE`;
- `OUTER_PROBE_BOUNDARY_CONTAINMENT = PASS_EVIDENCE`;
- `AERIAL_CAMERA_HEADING_FOLLOW = FAIL_EVIDENCE`;
- `MONSTER_PLACEHOLDER_SOLID_COLLISION = FAIL_EVIDENCE`.

Not yet proven:
- rapid alternating touch input / stuck-state resistance;
- repeated AERIAL ↔ FIRST PERSON position-drift stability;
- sustained 10+ minute performance and thermal behavior;
- background/resume and lock/unlock lifecycle;
- collision response after repair;
- camera-follow behavior on the revised APK.

## Camera root cause

Source inspection showed the old camera implementation used a world-fixed look target:

`hunter.global_position + Vector3(0.0, 0.7, -1.0)`

The Hunter also had no movement-facing rotation. Therefore the aerial framing could follow position while still behaving as though world `-Z` were always forward.

## Camera bounded repair

Camera repair commit:
`af83b5451996fba46f584a7fd8091cdee6d49b47`

Repair direction:
- Hunter now rotates toward non-zero movement direction;
- aerial camera derives forward from the Hunter's actual transform;
- camera trails behind that heading;
- camera look target includes heading-based forward look-ahead;
- camera position uses bounded smoothing rather than a fixed world-axis offset;
- first-person camera remains a child of the Hunter, so it inherits the same physical heading instead of remaining permanently world-forward.

Prototype camera values are explicitly Stage-1 tuning only, not final production camera values.

## Camera rebuild verification

GitHub Actions run:
`33778332943`

Result for camera repair commit `af83b5451996fba46f584a7fd8091cdee6d49b47`:
- checkout: PASS;
- static preflight: `123 / 123 PASS`;
- Godot 4.7.2 import/parse: PASS;
- Boot headless smoke: PASS;
- ProbeWorld headless smoke: PASS;
- Android debug export: PASS;
- APK archive integrity: PASS;
- artifact upload: PASS.

Revised APK:
`UnnamedHuntRPG-Stage1Probe-camera-follow.apk`

APK size:
`57,566,265 bytes`

APK SHA-256:
`33b6a98063393c1916455cf3c740bc0a938d3ab9a8b2e664342b61852dbfd3a0`

Gate truth:
- `CAMERA_FOLLOW_SOURCE_IMPLEMENTED = YES`;
- `CAMERA_FOLLOW_GODOT_PARSE_VERIFIED = YES`;
- `CAMERA_FOLLOW_APK_BUILD_VERIFIED = YES`;
- `CAMERA_FOLLOW_PHONE_RUNTIME_VERIFIED = NO / RETEST_PENDING`.

## Deferred collision defect

The brown Monster placeholder is currently visually present but is not yet a solid authoritative obstacle for the Hunter.

This is a starting-element defect because future terrain, monsters, props and combat positioning require trustworthy collision ownership.

Next bounded implementation piece after the camera repair is phone-verified:
**MONSTER_PLACEHOLDER_SOLID_COLLISION_REPAIR**.

That piece should:
1. inspect current Monster node/collision ownership;
2. add the smallest correct solid collision representation;
3. verify Hunter cannot penetrate the Monster placeholder;
4. preserve Monster visual motion without collider/mesh drift;
5. add regression coverage for obstacle collision;
6. rebuild APK and re-test on Galaxy A03s.

Do not use the collision repair as an excuse to introduce real monster combat, navigation, damage, AI, or production physics yet.

## Foundation-first sequencing rule

Before broad game construction, Stage 1 should prove these starting elements in order:
1. input starts/stops reliably;
2. Hunter movement and facing are coherent;
3. camera follows/frames the Hunter coherently;
4. solid world/creature obstacles block movement correctly;
5. world boundaries are trustworthy;
6. aerial ↔ first-person transition preserves physical state;
7. lifecycle survives background/resume;
8. sustained phone performance remains acceptable.

Only after these foundational behaviors are verified should the probe gate be closed and Stage 2 domain/gameplay implementation be considered.
