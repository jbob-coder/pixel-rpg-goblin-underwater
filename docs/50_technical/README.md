# 50_technical — Architecture, Persistence, Code and Platform Mapping

Status: ACTIVE TECHNICAL MAP / GODOT PRODUCTION ACTIVE / STATE OWNERSHIP IMPLEMENTED / BROAD PERSISTENCE NOT IMPLEMENTED  
Last reconciled: 2026-09-25

## Purpose

Own implementation-facing technical documentation: engine/platform, decomposition, state ownership, persistence boundaries, Android/build mapping, and technical architecture.

## Current production engine

Godot 4.7.2 is the active production engine/build baseline.

Production project:

`game/`

Current canonical workflow:

`.github/workflows/pixel-rpg-ci.yml`

The old Stage-1 engine-selection/probe period is historical.

`probes/android_stage1/`

remains useful probe/device provenance but is not production architecture.

## Current first-person technical decomposition

Current production source has extracted bounded owners for:

- camera math;
- camera yaw/pitch state;
- player motion math;
- player motor;
- touch math;
- touch mutable state;
- HUD layout;
- minimap math;
- world construction slices.

Current source:

`game/scripts/presentation/pixel_rpg/`

## State ownership

Current executable authority:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Current technical document:

`persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`

Focused test:

`game/tests/pixel_rpg_state_ownership_contract_test.gd`

Primary law:

one authoritative owner per mutable datum.

## Persistence

Broad current-world save/load is not implemented.

Older first-slice persistence design remains under:

`persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`

Use it for safe-point, anti-replay, and snapshot-design provenance only where compatible.

Do not treat old Region-01 coordinates or `UHR_SAVE_SCHEMA_1` as current implemented Pixel RPG persistence.

## Android/build

Canonical CI currently verifies:

- static preflights;
- Godot import/parse;
- AppShell smoke;
- discovered `game/tests/*_test.gd`;
- Android debug export;
- APK integrity;
- SHA-256;
- package-size recording.

Build success is not phone acceptance.

Stable production signing/update identity remains a separate unresolved technical concern.

## Technical authority law

Technical docs may define:

- ownership;
- interfaces;
- persistence boundaries;
- platform/build constraints.

They must not silently redefine gameplay or content ownership.

Current implementation truth comes from live source/tests/evidence.
