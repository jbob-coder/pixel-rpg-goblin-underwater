# 00_project — Project Governance

Status: ACTIVE GOVERNANCE PACKAGE / MIGRATION-RECONCILED  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation reconciliation branch: `documentation`

## Purpose

This package owns project-level governance and navigation:

- current authority/read order;
- repository/location maps;
- project scope/identity;
- readiness/evidence classification;
- dependency/ownership maps;
- dated status snapshots;
- documentation reconciliation records;
- global change discipline.

It does not own one Region's geometry, one Monster's anatomy, one combat rule, one asset's technical details, or runtime source implementation.

## Current pre-work contract

Before implementation work:

1. fetch live production `main`;
2. record exact HEAD;
3. read `START_HERE_NEW_CHAT.md`;
4. use the repository map/master scan to locate the owner;
5. read exact source/tests;
6. inspect the current GitHub issue;
7. make one bounded change;
8. run focused + required regression gates;
9. use exact same-SHA CI/build evidence;
10. read back the result.

## Current package authorities

Primary current navigation:

- `PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`;
- `PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`;
- `PIXEL_RPG_SYSTEM_RELATIONSHIP_AND_FLOW_MAP_2026-09-25.md` — runtime owner/adapter/presentation/test/build relationship map;
- `DOCUMENTATION_BRANCH_STATUS_2026-09-25.md`.
- `DOCUMENTATION_PRE_MERGE_AUDIT_2026-09-25.md` — pre-merge snapshot/checklist; not merge authorization.

Classification/navigation:

- `ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md` — classifies root authority/design/history documents;
- `../70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md` — classifies every historical handoff by current relevance.

Migration audit:

`../00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md`

Historical project snapshots remain useful only for the exact period/revision they describe.

## Current implementation distinction

Production Godot project:

`game/`

Current boot:

`game/project.godot`
→ app shell
→ current first-person prototype.

The old Stage-1 engine-selection/probe period is historical. Godot 4.7.2 is already the active production engine/build baseline.

## Current runtime verification reference

Audited runtime SHA:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical workflow:

`36082533109` — SUCCESS

This does not establish physical-device acceptance.

## Current work register

Master issue:
- #20.

Important active tracks:
- #1 prototype decomposition;
- #2 geometry/collision ownership;
- #9 player/touch/camera separation;
- #21 documentation migration cleanup.

## Historical files in this package

The following are retained snapshots/history and are not current master authority:

- `PROJECT_STATUS_REPORT_2026-09-03.md`;
- `PIXEL_RPG_MASTER_WORK_REGISTER_2026-09-21.md`;
- older build-readiness records where current-language has been superseded.

Do not delete useful historical evidence. Label it clearly.

## Documentation branch law

Use `documentation` only for documentation reconciliation.

A docs-only commit does not create a new runtime verification state.

Before merging documentation:

1. re-fetch production `main`;
2. compare `main...documentation`;
3. confirm only documentation paths changed;
4. corroborate current-state claims against live source/tests/issues;
5. reconcile any new production commits;
6. merge only verified documentation updates.
