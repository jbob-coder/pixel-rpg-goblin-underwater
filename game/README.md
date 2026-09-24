# Pixel RPG — Production Godot Root

Status: ACTIVE PIXEL RPG / FIRST-PERSON CREATOR REALIGNMENT
Last reconciled: 2026-09-23

This `game/` directory is the active Pixel RPG Godot 4.7.2 project on branch `pixel-rpg`.

## Current presentation authority

Creator directive dated 2026-09-23 makes normal exploration FIRST-PERSON.

This supersedes older Pixel RPG third-person chase-camera documentation and also supersedes older Unnamed Hunt/Region-01 presentation assumptions in this README. Historical files/tests may remain for deterministic domain regression and audit; they are not current presentation authority.

The abandoned standalone Shooter RPG is still not a source/runtime authority. Do not import its firearm-first identity, wall-jump systems, package identity or 115° HFOV constant.

## Preserve

- current Hunter CharacterBody3D movement/collision authority;
- current Pixel RPG world and enterable-building work;
- 800×360 low-resolution pixel render path and nearest scaling;
- mobile left-stick movement + independent right-side look;
- HUD safe-area behavior, Settings/minimap and contextual interaction;
- Mudcrest anatomy/target mapping;
- deterministic combat/anatomy/status domain files and verification suites.

## Current bounded piece

`PIXEL_RPG_FIRST_PERSON_REALIGNMENT_001`:
- direct eye-height Camera3D under current yaw/pitch pivots;
- no active SpringArm chase distance;
- no third-person body obstruction in normal view;
- preserve interactions/targeting;
- dedicated first-person regression;
- exact-source Godot/Android build evidence.

Phone runtime, visual quality, sustained performance and installed-footprint verification remain separate evidence layers.
