# Unnamed Hunt RPG — Documentation Folder Guide

Status: ACTIVE DOCUMENTATION STRUCTURE / STAGE 1 PROBE ACTIVE / PACKAGE + HANDOFF DISCIPLINE REQUIRED
Last reconciled: 2026-09-03

## Purpose

This folder is the package-oriented documentation layer for the new game.

The repository contains authoritative design documents both at repository root and under `/docs`. Root authorities remain valid and must **not** be moved, renamed or duplicated casually. New work should use the package structure below, while any future migration of root authorities must happen as its own bounded verified pass.

This guide owns the rules for **where documentation belongs and how local README/front-door files map it**. Current project state and exact next work are owned by root `EVOLVE_ALIGNMENT.md`, `PROJECT_HANDOFF.md`, `START_HERE_NEW_CHAT.md` and `DOCUMENTATION_INDEX.md`.

## Primary quality rule

**Folders organize ownership. Content packages organize one playable thing. Owning system documents define reusable rules; package documents apply those rules without redefining them.**

Example:
- the stats/effects authority defines how terrain modifiers work;
- a region package may say that a mud sector applies `terrain_mud`;
- the region package must not invent a second mud formula.

## Directory map

```text
docs/
├── README.md                     # this guide
├── 00_project/                   # governance, scope, authority, readiness
├── 10_world/                     # atlas, settlements, regions, camps, spatial packages
│   └── regions/                  # one folder per hunting region
├── 20_gameplay/                  # combat, stats, effects, harvest, progression, behavior
├── 30_content/                   # hunters, monsters, equipment and content packages
├── 40_art/                       # model/art/reference/animation/audio asset guidance
├── 50_technical/                 # engine, Android, architecture, persistence, build mapping
├── 60_quality/                   # tests, performance, debug/admin quality gates
└── 70_handoff/                   # bounded-pass continuity/readback/verification records
```

Every top-level folder should contain a local `README.md` stating what belongs there and what does not.

The complete cross-project navigation map is root `DOCUMENTATION_INDEX.md`. Local READMEs are front doors for their own folder/package, not replacements for the global index.

## Root authorities

Current root authorities such as `README.md`, `EVOLVE_ALIGNMENT.md`, `PROJECT_HANDOFF.md`, `START_HERE_NEW_CHAT.md`, `DOCUMENTATION_INDEX.md`, `DESIGN_QUALITY_GATES_AND_DEPENDENCY_MATRIX.md`, `MAP_WORLD_SETTLEMENT_STRUCTURE.md`, `FIRST_SETTLEMENT_BLUEPRINT.md`, `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`, `CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md`, `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`, `CODE_GUIDE.md`, `PERFORMANCE_BUDGETS_AND_CAPS.md` and other planning files remain authoritative according to their ownership scope.

Do not create second full copies under `/docs` just to make the folder look complete.

A future documentation migration may move selected root authorities only after:
1. inbound links are inventoried;
2. new paths are prepared;
3. references are updated coherently;
4. navigation/read-order files are reconciled;
5. readback confirms no stale path remains.

## Package rule

A playable content package gets its own folder when it has enough identity/state to require several coordinated documents.

Examples:
- `docs/10_world/regions/REGION_01/`;
- future `docs/10_world/settlements/SETTLEMENT_02/`;
- `docs/30_content/monsters/MONSTER_01/`;
- future `docs/30_content/monsters/SPECIES_002/`.

Each package should have one `README.md` as its local front door.

The package README must state where relevant:
- technical ID;
- status;
- owning authorities;
- purpose/player value;
- package file map;
- selected decisions;
- prototype targets;
- open questions;
- dependencies;
- verification/acceptance gates;
- what the package explicitly does **not** own.

## README/front-door rule

When a folder or package gains a durable new authority:
1. determine whether the local README/file map must link it;
2. keep the README focused on navigation/ownership rather than copying the child document;
3. update root `DOCUMENTATION_INDEX.md` when the authority matters to cross-project navigation/read order;
4. update current-state front doors only when current state or next action actually changes.

An important new file that cannot be discovered from either its local README or `DOCUMENTATION_INDEX.md` is incompletely integrated documentation.

## Authority rule

When documents disagree, use current evidence and the narrowest owning authority according to root EVOLVE. In general:
1. current explicit user instruction;
2. current verified source/tests for implementation truth;
3. current owning root/system authority;
4. package-level application;
5. direct device/build evidence according to the claim;
6. prototype/reference material;
7. old/superseded notes or chat summaries.

A package cannot override a global invariant silently.

## Naming rules

Use stable machine-oriented package IDs and human-readable titles separately.

Recommended IDs include:
- `REGION_01`, `REGION_02`;
- `SETTLEMENT_01`;
- `HUNTER_BASE_01`;
- `MONSTER_01`;
- `SPECIES_001`;
- `WEAPON_FAMILY_001`.

Use descriptive uppercase filenames for durable documents, for example:
- `REGION_TOPOLOGY.md`;
- `TRACKING_AND_ESCAPE.md`;
- `STREAMING_AND_PERFORMANCE.md`;
- `SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md`.

Do not use filenames such as `final2.md`, `newideas.md`, `misc.md` or `stuff.md`.

## Status vocabulary

Design/status vocabulary includes:
- LOCKED / CURRENT;
- SELECTED ARCHITECTURE;
- PROTOTYPE TARGET;
- OPEN;
- FUTURE OPTION;
- REJECTED / NOT PREFERRED;
- DEFERRED / NOT VERIFIED.

Implementation verification uses separate gates such as:
`DESIGNED → IMPLEMENTED → STATIC_VERIFIED → CONTENT_VALIDATED → UNIT_TESTED → INTEGRATION_TESTED → COMPILED → APK_BUILD_VERIFIED → PHONE_RUNTIME_VERIFIED → VISUAL_QUALITY_VERIFIED → PERFORMANCE_VERIFIED`.

Never write `VERIFIED` when only design documentation exists. Never convert CI/headless evidence into phone evidence.

## Reference-image rule

PNG/concept references belong under the art/reference workflow or are linked from a content package. They establish visual intent unless separately technically verified.

Never treat generated concept-image text, dimensions, normal-map-looking art, collision, UVs or hit zones as technical truth without validation.

## Cross-link rule

Prefer links to the owning authority rather than copying its full rules into every package.

Package documents should contain:
- the local value selected for that package;
- why it was chosen;
- the authority being applied;
- any package-specific acceptance condition.

## Bounded-pass handoff rule

Substantial implementation/design/QA passes should leave a specialized record under `docs/70_handoff/` when continuity would otherwise depend on chat history.

A handoff should state where relevant:
- bounded piece name;
- owner/source/files changed;
- root cause or design question;
- exact implementation/decision;
- tests/build/device evidence;
- revision/workflow/artifact identity;
- regressions inspected;
- what remains unverified;
- documentation reconciled;
- exact next bounded action/blocker.

A handoff records a completed pass; it must not become a competing owner of system rules.

## Change rule

For any durable change:
1. read current root EVOLVE/current-state authorities;
2. identify the owning file/package/source;
3. classify impact/readiness gate;
4. update the smallest relevant owner;
5. test/review at the highest available level;
6. update local README when package status/file map changed;
7. update `DOCUMENTATION_INDEX.md` when important authority/navigation changed;
8. update `PROJECT_HANDOFF.md`, `START_HERE_NEW_CHAT.md` and EVOLVE when state/next action changed;
9. write/update a specialized handoff when needed;
10. save/commit and read back the stored result.

## Current examples of owners/packages

World package:
`docs/10_world/regions/REGION_01/` — first hunting region beyond Settlement 01's hunter gate.

Combat system package:
`docs/20_gameplay/combat/` — action economy, resolution, first weapon family and Stamina prototype contracts.

Stage-1 Android evidence package:
`probes/android_stage1/` — isolated disposable engine/device probe. Its local front doors include:
- `probes/android_stage1/README.md`;
- `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md`;
- `probes/android_stage1/docs/SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md`;
- `probes/android_stage1/docs/CONTROL_CAMERA_FOUNDATION_README.md`.

The Stage-1 probe contains implementation source but is intentionally **not** production gameplay architecture.

## Current documentation gate

`DOCS_FOLDER_STRUCTURE = ACTIVE`
`GLOBAL_DOCUMENTATION_INDEX = ACTIVE`
`LOCAL_README_FRONT_DOOR_RULE = ACTIVE`
`SPECIALIZED_HANDOFF_RULE = ACTIVE`
`ROOT_AUTHORITY_MIGRATION = NOT STARTED / NOT REQUIRED FOR CURRENT STAGE`
`STAGE1_PERFORMANCE_PROTOCOL_MAPPED = YES`

Current exact work/next-action truth belongs in `EVOLVE_ALIGNMENT.md`; do not copy an old current-piece statement here and allow it to become stale again.
