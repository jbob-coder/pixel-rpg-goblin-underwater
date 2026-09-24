# 50_technical — Architecture, Persistence, Code and Platform Mapping

Status: ACTIVE TECHNICAL MAP / STAGE 1 PHONE GATE DEFERRED / FIRST-SLICE PERSISTENCE DESIGN RECORDED
Last reconciled: 2026-09-03

## Purpose

Own technical/platform documentation, architecture mapping and persistence boundaries while keeping implementation claims tied to real source/build/device evidence.

Belongs here:
- engine/platform probe decisions;
- domain/module architecture mapping;
- persistence/save contracts and later schemas;
- streaming implementation mapping;
- Android lifecycle/platform notes;
- build/install documentation tied to real artifacts;
- implementation-facing subsystem READMEs once matching source exists.

## Current packages

Engine/Android candidate authority:
`ENGINE_ANDROID_PROBE_DECISION.md`.

Persistence front door:
`persistence/README.md`.

First-slice persistence authority:
`persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`.

## Stage-1 candidate truth

- Godot 4.7 family;
- CI/build Godot 4.7.2 stable;
- GDScript;
- GL Compatibility renderer;
- Samsung Galaxy A03s baseline;
- stable 30 FPS representative-scene target.

Current matching implementation is probe-only:
`/probes/android_stage1/`.

The Stage-1 probe is disposable evidence-gathering source and is not automatically production architecture.

Automated protocol/build evidence is recorded in current project/readiness handoffs. Direct Galaxy A03s regression + sustained-performance evidence remains deferred.

`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

## First-slice persistence baseline

Selected:
- schema `UHR_SAVE_SCHEMA_1`, version 1;
- one prototype player slot `save_slot_01`;
- monotonically increasing committed generations;
- state snapshot, not event sourcing;
- save requests commit only at persistence-safe domain boundaries;
- active encounter save allowed at stable combat decision/reaction points;
- exact scheduler/transaction sequence state survives reload;
- same Monster/anatomy/Crystal/harvest/bundle/Inventory/equipment identities survive reload;
- transaction IDs remain idempotent;
- presentation is reconstructed and never replayed as gameplay truth;
- incomplete new write cannot invalidate last committed generation;
- load validation precedes state activation.

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_RECORDED = YES`
`PERSISTENCE_RUNTIME_IMPLEMENTED = NO`
`PERSISTENCE_RUNTIME_VERIFIED = NO`.

## Spatial persistence interface

Persistence stores stable spatial context/sector/anchor references plus position in meters and orientation.

Existing world authority prefers `1 world unit = 1 meter`.

Exact coordinate axes/origins/bounds belong to the next world-design owner:
`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT`.

## Existing engine-neutral authorities

- `/SYSTEM_ARCHITECTURE_BLUEPRINT.md`;
- `/CODE_GUIDE.md`;
- `/DEVELOPMENT_REFERENCE.md`;
- `/IMPLEMENTATION_ROADMAP.md`;
- `/PERFORMANCE_BUDGETS_AND_CAPS.md`;
- `/WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`.

## Quality rules

- Do not create detailed class/API/scene claims for code that does not exist.
- Source readback is not runtime verification.
- Build success is not Galaxy A03s verification.
- Persistence design is not persistence implementation.
- UI/animation may request/display but never own persistent gameplay state.
- Current exact work/next action remains owned by root `EVOLVE_ALIGNMENT.md`.