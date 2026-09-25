# Pixel RPG Documentation Branch Status — 2026-09-25

Status: ACTIVE DOCUMENTATION RECONCILIATION  
Branch: `documentation`  
Base production branch: `main`  
Base production SHA: `9dd3aa67a714027d66fd428f669d8d240d788626`

## Purpose

The `documentation` branch exists to reconcile migrated/stale documentation without mixing documentation cleanup into gameplay/runtime implementation.

No gameplay, scene, asset, test, workflow, or Godot runtime code should be changed on this branch.

## Audited runtime baseline

Runtime implementation audited during the five-round scan:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical workflow:

`36082533109` — SUCCESS

Verification job:

`107907382620` — SUCCESS

Android export job:

`107907562399` — SUCCESS

Documentation commits after that SHA do not create a new runtime verification state.

## Reconciled current-control documents

- `START_HERE_NEW_CHAT.md`
- `DOCUMENTATION_INDEX.md`
- `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`
- `PROJECT_HANDOFF.md`
- `EVOLVE_ALIGNMENT.md`
- `README.md`
- `PIXEL_RPG_VISUAL_DIRECTION.md`

## Added current navigation/reference documents

- `docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`
- `docs/00_project/DOCUMENTATION_BRANCH_STATUS_2026-09-25.md`

Inherited from the production base:

- `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

## Historical-status clarification completed

The following files were preserved but given explicit current-status banners so their old “current” wording cannot override live Pixel RPG state:

- `docs/00_project/PIXEL_RPG_MASTER_WORK_REGISTER_2026-09-21.md`
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`
- `docs/40_art/asset_pipeline/README.md`
- `docs/40_art/asset_pipeline/ASSET_LINEAGE_AND_APPROVAL_MANIFEST.md`

Their historical Hunt-01 evidence, asset-lineage rules, and prior verification records remain intact.

## Corrections made

The reconciled control documents now consistently reflect:

- active repository `jbob-coder/pixel-rpg-goblin-underwater`;
- production branch `main`;
- documentation-only staging branch `documentation`;
- old `Chatgptjuegolpcal@pixel-rpg` as migration/provenance only;
- current master issue #20;
- current priority tracks #1, #2, #9, and #21;
- current workflow `.github/workflows/pixel-rpg-ci.yml`;
- canonical hands already integrated in live ViewModel source;
- current first-person boot path;
- current Combat Bridge 002 no-attack boundary;
- current state-ownership model;
- current runtime-art integration;
- automated/build versus physical-device evidence separation.

## Current branch delta

At the latest verified comparison before this status update:

- `documentation` was 13 commits ahead of `main`;
- `documentation` was 0 commits behind `main`;
- every changed path was documentation/Markdown only;
- no `game/`, `tests/`, `.github/workflows/`, `ci/`, or `probes/` runtime/build file was changed.

## Issue tracking

Issue #21 contains a progress comment recording:

- documentation branch/base identity;
- audited runtime SHA/build evidence;
- reconciled files;
- current issue/workflow corrections;
- confirmation that runtime/gameplay files were not modified.

## Remaining documentation reconciliation

High-priority remaining review:

1. selected root/project documents not yet directly corroborated after migration;
2. `docs/70_handoff/` classification — current dependency vs historical evidence, without mass-rewriting history;
3. other older asset/model documents whose status banners may imply pre-runtime conditions;
4. any stale repository/branch/issue/workflow pointers found by bounded readback;
5. final merge-readiness audit against whatever production `main` becomes at review time.

The attempted broad branch-wide automated stale-reference scan exceeded the connector per-script call ceiling before returning a complete result. It is therefore **not evidence** that stale references are absent. Remaining review must continue in bounded batches.

## Merge policy

Do not merge `documentation` merely because the files read better.

Before merge:

1. re-fetch production `main`;
2. compare `main...documentation`;
3. confirm the diff remains documentation-only;
4. verify each corrected current-state claim against current source/tests/issues;
5. reconcile any production changes that landed after the branch base;
6. preserve historical evidence while preventing it from masquerading as current authority;
7. merge only corroborated documentation changes.

## Next action

Continue bounded documentation readback/classification, prioritizing remaining root/project authority-like documents and then handoff classification. Do not modify gameplay/runtime code on this branch.
