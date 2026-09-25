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

- `documentation`: **84 commits ahead** of `main` at the latest verified comparison;
- `documentation`: **0 commits behind** `main`;
- changed files: **67**;
- non-documentation paths changed: **0**.

The current diff contains Markdown/documentation paths only.

No gameplay/runtime source, scene, asset resource, test code, workflow, CI script, or probe runtime file is part of the diff. Documentation-only Markdown under `game/` is now intentionally included for runtime-adjacent readme/evidence reconciliation.

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


## Additional reconciliation completed

Current-status notices were added to remaining pre-implementation design contracts that could otherwise overstate or understate present runtime state:

- `CONTENT_DATA_GUIDE.md`;
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `BEHAVIOR_PATTERN_SYSTEM.md`;
- `CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md`;
- `ADMIN_CREATOR_SYSTEM.md`.

These notices preserve the useful design laws while directing implementation claims back to current source/tests.

Handoff classification was also audited structurally:

- handoff records: **74**;
- primary A–G classifications: **74**;
- missing primary classifications: **0**;
- multiply classified primary records: **0**.

The coverage result is recorded in `docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md`.

## Remaining documentation reconciliation

Remaining work is now narrower:

1. bounded readback of deeper package/content documents that still present old status as current;
2. continue classifying old package-local design files without rewriting historical evidence;
3. final merge-readiness review against live production `main`;
4. reconcile any production changes if `main` advances before merge.

Package front-door README review is complete for the major world/gameplay/content/art/technical/persistence/quality/handoff packages.

The earlier broad branch-wide stale-reference sweep exceeded the connector per-script call ceiling before returning a complete result and is not evidence. It was replaced by two valid bounded scans covering 24 current authority/navigation files.

## Current navigation validation — 2026-09-25

Bounded validation completed after the package/root/handoff reconciliation:

### Stale-pointer scan

Scanned **24 current authority/navigation documents** in two valid 12-file batches.

Checked for active stale patterns including:

- old repository as an active repository declaration;
- `pixel-rpg` as the active/current branch;
- old “fetch pixel-rpg HEAD” continuation instructions;
- obsolete issue #28/#29/#30 work split;
- removed `pixel-rpg-prototype-android.yml` workflow;
- obsolete “canonical hands integration not complete” state.

Result:

- stale active-pointer hits: **0**.

Historical documents may still contain old branch/workflow/issue references as preserved provenance. This result applies only to the current authority/navigation set.

### Navigation-link audit

Audited Markdown file references across seven primary navigation/classification documents:

- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `PIXEL_RPG_AUTHORITY_LOCK.md`;
- `docs/README.md`;
- `docs/00_project/ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md`;
- `docs/00_project/PACKAGE_AUTHORITY_MATRIX_2026-09-25.md`;
- `docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md`.

References checked: **174**.

Initial missing references: **2**, both persistence paths in the package-authority matrix.

Those two paths were corrected to:

- `docs/50_technical/persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`;
- `docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`.

Re-audit result:

- unresolved Markdown file references: **0**.

### Latest verified branch comparison

At the comparison immediately before this status update:

- production `main`: `9dd3aa67a714027d66fd428f669d8d240d788626`;
- documentation HEAD: `5fd59379ed24739c64e7e766d7cd79cb8e5e7483`;
- ahead: **84 commits**;
- behind: **0 commits**;
- changed files: **67**;
- changed runtime/build paths: **0**.

Every changed path in that comparison was Markdown/documentation.


## Merge policy
Pre-merge audit snapshot:

`docs/00_project/DOCUMENTATION_PRE_MERGE_AUDIT_2026-09-25.md`


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

Package-front-door reconciliation is now substantially complete.

Continue with:

1. runtime-adjacent Markdown classification/readback under `game/`;
2. bounded review of deeper package-local documents only where old status can still misdirect current work;
3. final documentation merge-readiness audit against live production `main`;
4. rebase/reconcile documentation if `main` advances;
5. preserve historical evidence rather than rewriting old proof records.

Do not modify gameplay/runtime code on this branch.

## Progress update — relationship/package pass

Additional verified work completed on the documentation branch:

- added `PIXEL_RPG_SYSTEM_RELATIONSHIP_AND_FLOW_MAP_2026-09-25.md`;
- linked the relationship map from the global index, project-governance README, and package-authority matrix;
- verified root-document classification completeness: **33 / 33 root Markdown files classified**;
- verified historical handoff classification completeness: **74 / 74 handoff records classified**;
- reconciled or status-guarded the current/legacy boundary for:
  - Region package front door;
  - Region-01 historical integration baseline;
  - settlement package;
  - shared spatial package;
  - combat package;
  - Monster-01 package;
  - harvest package;
  - inventory package;
  - crafting package;
  - progression package;
  - Hunter Base 01 presentation history;
  - quality package.

Current relationship map now explicitly documents:

- input → touch state → camera/movement intent;
- movement intent → player motor → authoritative Hunter transform;
- world builders and collision ownership;
- interaction/context ownership;
- targeting → Combat Bridge → deterministic domain boundary;
- Region-01 legacy integration relationship;
- Monster visual ↔ anatomy owner boundary;
- state-owner/readers/adapters relationship;
- future persistence snapshot flow;
- asset promotion lineage;
- test/build/device evidence flow;
- current issue/dependency order;
- anti-duplication rules.

Latest verified branch comparison during this pass:

- production `main`: `9dd3aa67a714027d66fd428f669d8d240d788626`;
- documentation HEAD at comparison time: `3d53a850b60b5491283e52abf0d6a5a144823676`;
- documentation was **82 commits ahead / 0 behind**;
- every changed path in the comparison was Markdown/documentation;
- documentation-only Markdown under `game/` is included; no gameplay/runtime source, scene, asset resource, test code, workflow, CI script, or probe runtime file was changed.

The branch has been concurrently receiving additional documentation-only reconciliation commits. Every write must continue to re-fetch the current file/blob SHA immediately before editing to avoid overwriting newer documentation work.

## Progress update — runtime-adjacent documentation pass

Additional work completed:

- reconciled `game/README.md` repository/first-person/current-slice status;
- classified `game/assets/README.md` as a historical stylized-kit checkpoint where its old non-pixel/illustrated-realism language conflicts with current visual authority;
- reconciled `game/scripts/gameplay/combat/README.md` so Basic Runtime Autorun is no longer described as future work;
- clarified `game/scripts/gameplay/encounter/README.md` so old aerial/first-person camera wording cannot restore old presentation authority;
- added `game/docs/README.md` as the front door for Hunt-01 runtime evidence notes;
- verified `game/docs/README.md` covers **12 / 12** runtime evidence notes.

Latest verified branch comparison during this pass:

- production `main`: `9dd3aa67a714027d66fd428f669d8d240d788626`;
- documentation was **93 commits ahead / 0 behind** at the latest comparison;
- all changed files remained Markdown/documentation;
- documentation-only Markdown under `game/` is intentional;
- no gameplay/runtime source, scene, asset resource, test code, workflow, CI script, or probe runtime file changed.
