# Pixel RPG Documentation Branch Status — 2026-09-25

Status: ACTIVE DOCUMENTATION RECONCILIATION  
Branch: `documentation`  
Base production branch: `main`  
Base production SHA: `9dd3aa67a714027d66fd428f669d8d240d788626`

## Purpose

The `documentation` branch exists to reconcile migrated/stale documentation without mixing documentation cleanup into gameplay/runtime implementation.

No gameplay, scene, asset, test, workflow, CI, probe, or Godot runtime code should be changed on this branch.

## Audited runtime baseline

Runtime implementation audited during the five-round repository scan:

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
- `NEW_CHAT_CONTINUATION_PROMPT.md`
- `DOCUMENTATION_INDEX.md`
- `PIXEL_RPG_AUTHORITY_LOCK.md`
- `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`
- `PROJECT_HANDOFF.md`
- `EVOLVE_ALIGNMENT.md`
- `README.md`
- `PIXEL_RPG_VISUAL_DIRECTION.md`
- `docs/README.md`
- `docs/00_project/README.md`

## Added current navigation/reference documents

- `docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`
- `docs/00_project/ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md`
- `docs/00_project/PACKAGE_AUTHORITY_MATRIX_2026-09-25.md`
- `docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md`
- `docs/00_project/DOCUMENTATION_BRANCH_STATUS_2026-09-25.md`

Inherited from production base:

- `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

## Root-document classification completed

Root documents are now navigated through:

`docs/00_project/ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md`

Classes distinguish:

- current authority/navigation;
- reusable architecture/governance laws with historical status sections;
- future-system design provenance;
- asset/model-pipeline provenance;
- superseded presentation/game-identity history.

High-risk aerial/third-person or pre-engine documents now either have explicit 2026-09-25 status notices or are classified so they cannot silently override current first-person authority.

## Handoff classification completed

All 74 handoff records under `docs/70_handoff/` were classified exactly once, with no omissions or duplicates, in:

`docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md`

Classes distinguish:

- current-lineage Pixel RPG technical evidence;
- superseded Pixel RPG presentation checkpoints;
- live Hunt-01 deterministic-domain provenance;
- Region-01 / legacy spatial provenance;
- future/partial-system design provenance;
- Stage-1 probe/device history;
- bootstrap/asset-generation history.

The handoff README now routes readers through this classification.

## Package authority map completed

Cross-package ownership is now recorded in:

`docs/00_project/PACKAGE_AUTHORITY_MATRIX_2026-09-25.md`

It distinguishes:

- what `docs/00_authority` may own;
- what `docs/00_project` may own;
- world/gameplay/content/art/technical/quality package scope;
- historical handoff scope;
- production `game/` implementation authority;
- Godot tests versus static preflights;
- Stage-1 probes versus production runtime;
- canonical CI versus physical-device evidence.

## Historical-status clarification completed

Historical files are being preserved rather than rewritten.

Explicit current-status/supersession notices have been added where old “current” language could mislead, including examples across:

- old project work/readiness reports;
- pre-engine architecture/design plans;
- aerial/third-person presentation bibles;
- old settlement/world maps;
- old asset/model pipeline status;
- visual-reference interpretation;
- old discussion checklist;
- Stage-1 or Shooter-era planning.

Historical SHA/workflow/device evidence remains valid only for the exact revision/evidence it identifies.

## Current branch delta

Latest verified comparison:

- `documentation`: **47 commits ahead** of `main`;
- `documentation`: **0 commits behind** `main`;
- changed files: **41**;
- non-documentation paths changed: **0**.

The current diff contains Markdown/documentation paths only.

No `game/`, `tests/`, `.github/workflows/`, `ci/`, or `probes/` runtime/build file is part of the diff.

## Corrections now represented consistently

The reconciled documentation now reflects:

- active repository `jbob-coder/pixel-rpg-goblin-underwater`;
- production branch `main`;
- documentation-only branch `documentation`;
- old `Chatgptjuegolpcal@pixel-rpg` as migration/provenance only;
- current master issue #20;
- current priority tracks #1, #2, #9, and #21;
- current workflow `.github/workflows/pixel-rpg-ci.yml`;
- canonical hands already live in current ViewModel source;
- current first-person boot path;
- current Combat Bridge 002 no-attack boundary;
- current state-ownership model;
- current runtime-art integration;
- Region-01 as a tested legacy integration path, not current boot/spatial authority;
- historical build/device evidence separated from current runtime claims;
- automated/build versus physical-device evidence separation.

## Issue tracking

Issue #21 contains documentation-branch progress evidence.

Additional progress should be recorded there when a bounded documentation layer is completed.

## Remaining documentation reconciliation

Remaining work is now narrower:

1. bounded readback of remaining future-system and asset/model documents for misleading top-level status fields;
2. package-local README review under `docs/10_world`, `20_gameplay`, `30_content`, `40_art`, `50_technical`, and `60_quality`;
3. bounded stale repository/branch/issue/workflow pointer sweeps in batches small enough for connector limits;
4. check links/navigation for newly added classification files;
5. final merge-readiness audit against live production `main`.

The earlier broad branch-wide stale-reference sweep exceeded the connector per-script call ceiling before returning a complete result. It is not evidence that stale references are absent.

## Merge policy

Do not merge `documentation` merely because the files read better.

Before merge:

1. re-fetch production `main`;
2. compare `main...documentation`;
3. confirm the diff remains documentation-only;
4. verify corrected current-state claims against current source/tests/issues;
5. reconcile any production changes that landed after the documentation branch base;
6. preserve historical evidence while preventing it from masquerading as current authority;
7. run bounded stale-pointer/link readback;
8. merge only corroborated documentation changes.

## Next action

Continue with package-local README/status review, beginning with `docs/10_world`, `docs/20_gameplay`, `docs/30_content`, `docs/40_art`, `docs/50_technical`, and `docs/60_quality`.

Do not modify gameplay/runtime code on this branch.
