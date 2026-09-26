# Pixel RPG — Documentation Folder Guide

Status: ACTIVE DOCUMENTATION STRUCTURE / MIGRATION-RECONCILED  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Purpose

`docs/` is the package-oriented documentation layer for Pixel RPG.

Folders organize scope and ownership. Documentation explains contracts, design, evidence, and history; it does not replace live source/tests.

Current global navigation:

- root `DOCUMENTATION_INDEX.md`;
- `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`;
- `docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`;
- `docs/00_project/PACKAGE_AUTHORITY_MATRIX_2026-09-25.md`.

## Primary rule

**Use the narrowest current owner.**

A package may apply a global rule but must not silently redefine it.

Example:

- generic combat owns attack/resource/status laws;
- Monster 01 may define Mudcrest-local attacks/anatomy;
- presentation may visualize Mudcrest state;
- HUD may display it;
- none may create a second independent combat truth.

## Directory map

```text
docs/
├── README.md
├── 00_authority/   # authority barriers + migration/stale-doc audit
├── 00_project/     # governance, maps, classification, readiness/history
├── 10_world/       # world, region, settlement, spatial packages
├── 20_gameplay/    # reusable gameplay contracts
├── 30_content/     # concrete Hunter/Monster/content packages
├── 40_art/         # current runtime-art records + historical asset pipeline
├── 50_technical/   # engine, Android, decomposition, state/persistence
├── 60_quality/     # quality/testing/performance protocols
└── 70_handoff/     # historical continuity/evidence records
```

## Current authority resolution

When documents disagree:

1. current creator instruction;
2. live production `main`;
3. exact implementation owner;
4. exact tests;
5. exact same-SHA build/device evidence;
6. current GitHub issue register;
7. current authority/navigation documents;
8. narrow package documentation;
9. historical handoffs/provenance.

Folder location or an `ACTIVE` label does not override newer implementation evidence.

## Root-document rule

The root contains current authority files plus historical design generations.

Use:

`docs/00_project/ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md`

before treating a broad root “Bible,” “Master Plan,” “Roadmap,” or “Architecture” document as current authority.

## Handoff rule

`docs/70_handoff/` is historical.

Read:

`docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md`

before opening individual handoffs.

Do not rewrite old handoffs to pretend they implemented newer design.

## Package README rule

Each substantial package should have a local `README.md` that states:

- purpose;
- what belongs there;
- what does not;
- local file map;
- owning global/system authorities;
- implementation relationship;
- open questions;
- evidence boundary.

A local README is a front door, not a copy of every child document.

## Package versus implementation

Documentation package:

describes intent/contract/provenance.

Runtime source:

implements authoritative behavior.

Tests:

verify claims.

Build evidence:

proves exact automated/export state.

Device evidence:

proves physical-device claims.

Do not let a design document promote itself to an implementation claim.

## Status vocabulary

Useful design/status labels:

- CURRENT / LOCKED;
- SELECTED ARCHITECTURE;
- PROTOTYPE TARGET;
- OPEN;
- FUTURE OPTION;
- HISTORICAL;
- SUPERSEDED PRESENTATION;
- DEFERRED;
- NOT VERIFIED.

Verification layers:

`DESIGNED → IMPLEMENTED → STATIC_VERIFIED → HEADLESS_VERIFIED → ANDROID_BUILD_VERIFIED → PHONE_RUNTIME_VERIFIED → VISUAL_QUALITY_VERIFIED → PERFORMANCE_VERIFIED`

Do not collapse them.

## Reference-image rule

Reference/concept images define visual intent and lineage unless separately technically validated.

Do not infer from generated imagery:

- exact scale;
- collision;
- UVs;
- hidden geometry;
- anatomy thresholds;
- final text/names;
- technical dimensions.

Current runtime image-derived assets are tracked through their current Pixel RPG art/source manifests and tests.

## Cross-link rule

Prefer links to owning authorities instead of copying full rules into every package.

A package should record:

- its local selected value;
- why it applies;
- which authority it follows;
- package-specific acceptance conditions.

## Durable change rule

For a documentation-affecting implementation change:

1. fetch live `main`;
2. identify the exact runtime owner;
3. identify the exact tests;
4. make the bounded implementation change;
5. verify it;
6. update only the documentation whose current claims actually changed;
7. preserve historical evidence;
8. read back the resulting authority chain.

For documentation-only reconciliation, use `documentation` and do not claim a new runtime verification state.
