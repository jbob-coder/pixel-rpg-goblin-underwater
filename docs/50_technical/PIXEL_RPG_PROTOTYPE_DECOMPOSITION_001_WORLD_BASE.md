# Pixel RPG — Prototype Decomposition 001 — World Base

Status: IMPLEMENTED / BUILD VERIFICATION PENDING
Date: 2026-09-23
Issue: #6
Bounded slice: `PIXEL_RPG_PROTOTYPE_DECOMPOSITION_001_WORLD_BASE`

## Objective

Begin safe decomposition of `pixel_rpg_prototype_001.gd` without changing coordinates, runtime ownership, first-person presentation, collision behavior or gameplay-domain behavior.

This first sub-slice extracts only the terrain foundation:
- `Ground`.

It deliberately does **not** extract:
- `Street`;
- `Trail`;
- settlement buildings;
- enterable smith;
- gate/props;
- trail vegetation/rocks;
- Gate Warden;
- Mudcrest proxy/domain alias;
- player movement;
- input;
- first-person camera;
- HUD;
- targeting;
- combat bridge/domain runtime.

Paths are the next separate decomposition sub-slice.

## Mechanical extraction

New module:
`game/scripts/presentation/pixel_rpg/world_base_001.gd`

Schema:
`pixel_rpg.world_base_001.v1`

The prototype keeps `_build_prototype_world()` as the current orchestrator and replaces only the inline Ground construction call with:

`WorldBase001.add_world_base(world_geometry)`

The existing generic `_add_box()` helper remains in the prototype because later, not-yet-extracted world responsibilities still use it.

## Ground parity contract

The extracted module preserves:
- name: `Ground`;
- node type: `StaticBody3D`;
- position: `Vector3(0.0, -0.35, -18.0)`;
- mesh/collision size: `Vector3(46.0, 0.7, 78.0)`;
- albedo: `Color(0.19, 0.29, 0.16)`;
- roughness: `0.95`;
- per-vertex shading;
- nearest texture filtering;
- default collision layer/mask behavior.

No coordinate migration is authorized.

## Ownership preservation

State Ownership Contract 001 remains authoritative and unchanged.

This extraction creates a content-construction module. It does not become a new mutable gameplay-state owner.

Preserved owners:
- Hunter transform/physics: live Hunter CharacterBody3D;
- combat scheduler/resources: deterministic CombatTurnShellRuntime;
- anatomy: deterministic MudcrestAnatomyRuntime;
- camera/input/targeting: existing transient control owners;
- HUD/presentation: existing presentation owners.

## Regression gate

New focused test:
`game/tests/pixel_rpg_prototype_decomposition_001_world_base_test.gd`

Expected gate:
`PIXEL_RPG_PROTOTYPE_DECOMPOSITION_001_WORLD_BASE_VERIFIED`

It verifies:
- module schema/constants;
- ownership contract remains valid;
- Ground type/transform/mesh/collision/material parity;
- Hunter start position unchanged;
- first-person camera remains current;
- Street and Trail remain at existing positions;
- enterable smith remains at existing position;
- settlement gate remains at existing position;
- Gate Warden remains at existing position;
- Mudcrest proxy/domain alias remain co-located.

All pre-existing first-person/world/combat-domain gates remain mandatory in CI.

## Android checkpoint

Version:
`0.7-decomposition-001-world-base`

Expected APK:
`PixelRPG-decomposition-001-world-base-debug.apk`

BuildIdentity v1 remains mandatory.

## Non-goals

This slice does not:
- improve visuals;
- add content;
- change map scale;
- change collision design;
- add save/load;
- add combat attack/damage;
- integrate legacy tactical movement;
- modify camera/input/HUD ownership;
- prove physical-device behavior.

## Next sub-slice after verification

`PIXEL_RPG_PROTOTYPE_DECOMPOSITION_002_PATHS`

Extract Street/Trail path construction mechanically with exact coordinate/material parity, leaving settlement/gate/trail-environment/controller systems untouched.
