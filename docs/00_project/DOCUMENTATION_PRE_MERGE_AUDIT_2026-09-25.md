# Pixel RPG — Documentation Pre-Merge Audit Snapshot

Status: PRE-MERGE AUDIT SNAPSHOT / NOT MERGE AUTHORIZATION  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Snapshot identity

Production `main` at audit:

`9dd3aa67a714027d66fd428f669d8d240d788626`

Documentation HEAD at audit:

`0fcc2d70f536847e4e55f01d89b63e9f650a39f9`

Comparison:

- documentation ahead of main: **94 commits**;
- documentation behind main: **0 commits**;
- changed paths: Markdown/documentation only.

This is a snapshot. It must be refreshed before any actual merge.

## Runtime evidence boundary

Audited runtime implementation baseline:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical workflow:

`36082533109` — SUCCESS

Verification job:

`107907382620` — SUCCESS

Android export job:

`107907562399` — SUCCESS

Documentation work after that runtime SHA does not create a newer runtime verification state.

## What the documentation branch now establishes

### Repository/authority identity

Current documentation consistently routes active work to:

`jbob-coder/pixel-rpg-goblin-underwater@main`

and treats:

`jbob-coder/Chatgptjuegolpcal@pixel-rpg`

as migration/provenance history.

### Current presentation identity

Current documentation consistently treats Pixel RPG as:

- first-person;
- Android landscape-first;
- pixel-styled real 3D;
- current direct Camera3D path;
- hidden third-person presentation body;
- current canonical hands/ViewModel;
- compact physical world.

### Current implementation boundaries

Documentation now distinguishes:

- current compact first-person boot/world;
- Region-01 legacy/tested integration path;
- deterministic Hunt-01 domain;
- current first-person Combat Bridge no-attack boundary;
- presentation versus collision authority;
- transient controls versus durable state;
- implemented versus design-only systems.

### Classification coverage

Verified:

- root Markdown classification: **33 / 33**;
- historical handoff classification: **74 / 74**;
- `game/docs/` runtime evidence classification: **12 / 12**.

### Navigation/reference artifacts

Current branch contains:

- repository where-is-what map;
- full repository scan master reference;
- root-document classification index;
- package authority matrix;
- handoff classification index;
- system relationship/flow map;
- documentation branch status;
- game runtime-evidence index.

## Changed-path policy

Current diff includes documentation-only Markdown at:

- repository root;
- `docs/**`;
- selected runtime-adjacent README/evidence paths under `game/**`.

No gameplay/runtime source, Godot scenes, asset resources, GDScript tests, Python tests, workflows, CI scripts, or probe runtime files are intentionally changed.

Before merge, verify this again mechanically.

## Current high-risk historical claims now guarded

Examples now explicitly reconciled/classified:

- old repository/branch pointers;
- old #28/#29/#30 issue ownership;
- removed workflow names;
- old aerial/third-person presentation authority;
- old “canonical hands pending” state;
- old “no engine import” art state;
- old “no combat implementation” state;
- old “basic autorun next” state;
- old Region-01 phone-retest/next-work statements;
- old “no graybox runtime” spatial state;
- old generic-building/service design-only status;
- old Hunter Base aerial-readability framing.

Historical evidence is retained rather than rewritten away.

## Merge blockers / required rechecks

This snapshot does **not** authorize merge.

Before merge:

1. fetch live production `main`;
2. record exact new production HEAD;
3. compare `main...documentation`;
4. if `main` advanced, reconcile documentation against new source/tests/issues;
5. confirm changed paths remain documentation-only;
6. re-run bounded stale-pointer scan over current authority/navigation docs;
7. re-run navigation-link audit;
8. verify root/handoff/runtime-note classification completeness still holds;
9. read back the current issue register;
10. confirm workflow path and boot path still match production source;
11. confirm no documentation statement claims physical-device verification that does not exist;
12. only then open/review/merge the documentation branch.

## Current merge-readiness assessment

### Structurally ready

- authority hierarchy documented;
- active repository/branch corrected;
- current boot/runtime relationships documented;
- package ownership documented;
- historical documents classified;
- handoffs classified;
- runtime evidence notes classified;
- major stale package fronts guarded;
- documentation-only scope maintained.

### Still requires final live-state reconciliation

- production `main` may change before merge;
- current issues may change;
- current runtime source may move;
- current CI workflow/build evidence may advance;
- additional concurrent documentation commits may land.

Therefore the branch is **PRE-MERGE ORGANIZED**, not “merge verified.”

## Preservation law

Do not squash historical evidence conceptually into one current narrative.

Current navigation should be concise.

Historical records should remain available for:

- provenance;
- exact old SHA/workflow/device evidence;
- regression rationale;
- design evolution;
- migration traceability.

The documentation branch should improve interpretation without falsifying history.
