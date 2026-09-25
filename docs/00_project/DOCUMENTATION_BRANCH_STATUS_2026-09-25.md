# Pixel RPG Documentation Branch Status — 2026-09-25

Status: ACTIVE DOCUMENTATION RECONCILIATION  
Branch: `documentation`  
Base production branch: `main`  
Base production SHA: `9dd3aa67a714027d66fd428f669d8d240d788626`  
Current documentation HEAD before this status note: `ec3d2ffd7fe82922a1c1806976b8bba56615c63b`

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

## Reconciled files so far

- `START_HERE_NEW_CHAT.md`
- `DOCUMENTATION_INDEX.md`
- `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`
- `PROJECT_HANDOFF.md`
- `EVOLVE_ALIGNMENT.md`
- `README.md`
- `PIXEL_RPG_VISUAL_DIRECTION.md`

Added:

- `docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`

Inherited from production base:

- `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

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
- automated/build versus physical-device evidence separation.

## Current branch delta

Before this status note, `documentation` was 8 commits ahead of `main` and 0 behind.

Changed files were documentation-only.

## Remaining documentation reconciliation

High-priority remaining review:

1. `docs/00_project/PIXEL_RPG_MASTER_WORK_REGISTER_2026-09-21.md` — historical issue map/status;
2. `docs/00_project/BUILD_READINESS_GATE_MATRIX.md` — older Hunt-01 “current” baseline;
3. `docs/40_art/asset_pipeline/README.md` — old “NO ENGINE IMPORT” status relative to current runtime assets;
4. `docs/40_art/asset_pipeline/ASSET_LINEAGE_AND_APPROVAL_MANIFEST.md` — older lane/status language that must be preserved as provenance where appropriate;
5. handoffs in `docs/70_handoff/` — classify current dependency versus historical evidence, do not mass-rewrite;
6. any remaining stale repository/branch/issue/workflow pointers discovered by direct readback.

## Merge policy

Do not merge the documentation branch merely because the files read better.

Before merge:

1. re-fetch production `main`;
2. compare `main...documentation`;
3. confirm no runtime files changed;
4. verify each corrected current-state claim against current source/tests/issues;
5. resolve any production changes that landed after the documentation branch base;
6. merge only corroborated documentation changes.

## Next action

Continue with the old master work register and build-readiness matrix, converting obsolete “current” claims into explicitly historical evidence while preserving useful verified Hunt-01 records.
