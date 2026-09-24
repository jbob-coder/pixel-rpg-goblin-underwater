# Unnamed Hunt RPG — Asset Lineage and Approval Manifest

Status: ACTIVE ASSET AUTHORITY / NO ENGINE IMPORT
Last reconciled: 2026-09-02

## Purpose

Provide one authoritative record for asset identity, lineage, storage, review state, permitted use and promotion gates.

Primary law:
**every derived asset must be traceable to a known parent/master, and every promotion must be explicit.**

Folder location, filename, upload success and visual polish do not prove approval.

---

# 1. Core laws

1. Uploading does not approve.
2. Copying/moving between Drive lanes does not change technical validity.
3. Derivatives never silently replace masters.
4. Upscaling does not create authoritative missing geometry/detail.
5. Runtime sizes derive independently from a recorded master/clean source.
6. A generated GLB/FBX is not game-ready until topology/anatomy/rig/sever/LOD/engine/phone gates pass.
7. Manifest state outranks status-like words embedded in filenames/images.
8. Rejected/superseded revisions remain traceable.
9. Stable asset IDs are independent of Drive IDs and display names.
10. Approved exports receive integrity records/checksums when the real export pipeline exists.
11. Generated text inside concept/reference images is not project authority.
12. Technical source images and communication infographics are separate asset classes.
13. Repeated generation using the same method must stop when the same architectural failure repeats across reviewed revisions.

---

# 2. Asset dimensions

Every important asset records four independent dimensions.

## Asset class
- `REFERENCE_MASTER`
- `REFERENCE_DERIVATIVE`
- `TECHNICAL_OVERLAY`
- `RUNTIME_2D_WORKING`
- `RUNTIME_2D_EXPORT`
- `CONVERSION_INPUT`
- `RECONSTRUCTION_3D_CANDIDATE`
- `DCC_WORKING_3D`
- `GAME_READY_3D_EXPORT`
- `REJECTED_DRAFT`

## Review state
- `GENERATED_UNREVIEWED`
- `REVIEWED_WITH_ISSUES`
- `SELECTED_REFERENCE`
- `TECHNICALLY_VERIFIED`
- `REJECTED`
- `SUPERSEDED`

## Permitted-use flags
- `DISCUSSION_ONLY`
- `MODELING_REFERENCE_OK`
- `DETAIL_REFERENCE_OK`
- `CONVERSION_TEST_OK`
- `RUNTIME_2D_TEST_OK`
- `RUNTIME_2D_SHIP_OK`
- `ENGINE_3D_TEST_OK`
- `GAME_READY_3D_OK`

## Verification gates
Record only checks actually executed, such as:
- source integrity;
- native-pixel review;
- close-detail review;
- scale reconciliation;
- turnaround consistency;
- runtime-size/alpha/compression review;
- conversion preflight;
- topology/manifold report;
- anatomy/sever setup;
- rig/deformation;
- animation;
- LOD;
- engine import;
- Android visual/performance verification.

---

# 3. Stable ID / revision rule

Preferred stable ID:
`<ENTITY>-<SHEET_OR_ASSET>-<ROLE>-<REVISION>`

Examples:
- `HUNTER01-H02-REF-001`
- `HUNTER01-H02-REF-002`
- `HUNTER01-H02A-REF-003`
- `HUNTER01-H04-REF-001`
- `MONSTER01-M01M02-REF-001`

Materially changed pixels/geometry require a new revision/asset ID.

Avoid volatile filename words such as `FINAL`, `LATEST`, `CURRENT`, `APPROVED`.

---

# 4. Promotion state machines

## Modeling reference
`GENERATED_UNREVIEWED`
→ `REVIEWED_WITH_ISSUES` / `REJECTED`
→ `SELECTED_REFERENCE`
→ optional `TECHNICALLY_VERIFIED`.

## Runtime 2D
`SOURCE/REFERENCE`
→ `RUNTIME_2D_WORKING`
→ runtime-size/alpha/compression/device checks
→ `RUNTIME_2D_EXPORT`
→ `RUNTIME_2D_SHIP_OK`.

## 3D
`SELECTED_REFERENCE`
→ separate `CONVERSION_INPUT`
→ `RECONSTRUCTION_3D_CANDIDATE`
→ `DCC_WORKING_3D`
→ topology/anatomy/sever/rig/animation/LOD verification
→ engine import
→ Android verification
→ `GAME_READY_3D_EXPORT`.

No PNG-to-game-ready shortcut exists.

---

# 5. Current Drive lanes

Project root: `Unnamed Hunt RPG`
ID: `1N3FbZhLE9ZfEy1Og-iNiB2B7nyyfangt`

Manifest folder:
- `00_Asset_Manifests` — `1cg-zesn5QTcSIm63pnt1FeH7TYvxKlfo`

Modeling references:
- `01_Modeling_References` — `1qsF_JUYBs9ZQ-1lZPHsTCwWn87W46VIs`
- Hunter — `1XM-kcLfxD3Af-HAPRu4zlO691RgDJLlE`
- Monster_01 — `1klaz1KEefbWZ2cMMH3N6m--lbQqf9CUe`

Runtime 2D working:
- `02_2D_Runtime_Assets` — `1PJ7uzt8oZBE5jFPXoBeldGVVv9Dy1Ko_`

3D conversion inputs:
- `03_3D_Conversion_Inputs` — `1hs-qJiiF6R-1NLBmlChvSK4rlQilONLz`

Approved exports:
- `04_Approved_Exports` — `1yrS6vXQElSahDUtFJjjst25gq8RIGm2P`

---

# 6. Current Hunter records

## HUNTER01-H02-REF-001
File: `HUNTER_BASE_01_H02_TURNAROUND_SCALE_v001_DRAFT_REFERENCE.png`
Drive ID: `1U9vm0y7YSSGnEiPYO8C7M8QAq43FyibV`
Review state: `REVIEWED_WITH_ISSUES`
Decision: `REVISE`
Permitted use: `DISCUSSION_ONLY`
QA: `docs/40_art/reviews/HUNTER_BASE_01_H02_v001_QA.md`

## HUNTER01-H02-UPSCALEREF-001
File: `HUNTER_BASE_01_H02_TURNAROUND_SCALE_v001_DRAFT_UPSCALED_REFERENCE.png`
Drive ID: `1hcxXoOH6xsy-CXh2EoyhnjgIH_etizOc`
Parent/Master: `HUNTER01-H02-REF-001`
Review state: `REVIEWED_WITH_ISSUES`
Permitted use: `DISCUSSION_ONLY`
Restriction: enlarged pixels do not become new technical detail.

## HUNTER01-H02-REF-002
File: `HUNTER_BASE_01_H02_TURNAROUND_SCALE_REF_v002.png`
Drive ID: `1kkRFXV2Mtk1sWyhjxdnSGm7l6xQRMZE4`
Observed dimensions: `1536 × 1024`
Review state: `REVIEWED_WITH_ISSUES`
Decision: `REVISE`
Permitted use: `DISCUSSION_ONLY`
QA: `docs/40_art/reviews/HUNTER_BASE_01_H02_v002_QA.md`
Primary blocker: overloaded infographic/contact-sheet architecture and insufficient native subject occupancy.

## HUNTER01-H02A-REF-003
Entity: `HUNTER_BASE_01`
Purpose: clean high-occupancy orthographic/multiview technical source attempt
Class: `REFERENCE_MASTER`
File: `HUNTER_BASE_01_H02A_ORTHO_REF_v003.png`
Drive ID: `1EjeitWONWZ2PHPbVkI-dvcVIoiL7bcfE`
Drive lane: `01_Modeling_References/Hunter`
Observed dimensions: `1536 × 1024`
Parent design lineage: H02 v002 QA + Hunter technical source-pack standard + proportion/attachment contract
Master: SELF for v003 pixels
Review state: `REVIEWED_WITH_ISSUES`
Decision: `REVISE_METHOD`
Permitted use: `DISCUSSION_ONLY`
QA: `docs/40_art/reviews/HUNTER_BASE_01_H02A_v003_QA.md`

What it proved:
- the current image-generation route continues to produce infographic/contact-sheet content despite the source-only contract;
- the four primary views are broadly visually coherent enough for discussion;
- the output still allocates most raster area to non-source panels rather than technical body views;
- generated detail panels cannot prove exact magnification of the same construction;
- generated embedded dates, permissions, technical claims, landmark tables and checksums are not authority;
- conversion preflight fails.

Explicitly NOT permitted:
- exact modeling geometry authority;
- detail authority;
- 3D conversion testing;
- runtime 2D use.

Escalation:
**do not generate H02A v004 with the same method.**

Next geometric path when explicitly authorized:
`1.75 m controlled DCC mannequin → blockout/landmark/clearance review → orthographic renders from one model → technical H02A source derived from real geometry`.

Blockout specification:
`docs/40_art/asset_pipeline/HUNTER_DCC_BLOCKOUT_SPECIFICATION.md`.

## HUNTER01-H04-REF-001
File: `HUNTER_BASE_01_H04_MODULAR_SILHOUETTES_v001_DRAFT_REFERENCE.png`
Drive ID: `1j2eQCUfUzc-kgt4egH15dzPK-5Gv6OAF`
Review state: `GENERATED_UNREVIEWED`
Permitted use: `DISCUSSION_ONLY`
Review blocked until neutral Hunter technical source is selected.

---

# 7. Current Monster 01 records

## MONSTER01-M01M02-REF-001
Working species: Mudcrest Raker
File: `MONSTER_01_M01_M02_HERO_TURNAROUND_v001_VISUAL_CANDIDATE.png`
Drive ID: `1yMLP6lcO4Us4uJO2CMNUCusiXlWpwI2m`
Review state: `GENERATED_UNREVIEWED`
Permitted use: `DISCUSSION_ONLY`

Authoritative design remains:
- ~6.6 m length;
- ~3.0 m shoulder/main-body height;
- front-heavy quadruped;
- paired mineral horn crest;
- breakable dorsal plates;
- mud-adapted feet;
- legal distal tail sever;
- eight first-slice target groups.

## MONSTER01-M03-TECHOVERLAY-001
Expected file: `MONSTER_01_M03_ANATOMY_v001_TECHNICAL_OVERLAY.png`
Drive persistence: NOT VERIFIED
Review state: `GENERATED_PERSISTENCE_UNVERIFIED`
Permitted use: `DISCUSSION_ONLY`.

## MONSTER01-M04-REF-001
Expected file: `MONSTER_01_M04_DAMAGE_STATES_v001_DRAFT_REFERENCE.png`
Drive persistence: NOT VERIFIED
Review state: `GENERATED_PERSISTENCE_UNVERIFIED`.

## MONSTER01-M05-TECHCONCEPT-001
Expected file: `MONSTER_01_M05_CRYSTAL_MUTATION_VARIANTS_v001_TECHNICAL_CONCEPT.png`
Drive persistence: NOT VERIFIED
Review state: `GENERATED_PERSISTENCE_UNVERIFIED`.

## MONSTER01-M08-REF-001
Expected file: `MONSTER_01_M08_THREE_DISTANCE_v001_VISUAL_CANDIDATE.png`
Drive persistence: NOT VERIFIED
Review state: `GENERATED_PERSISTENCE_UNVERIFIED`.

---

# 8. Approval checklist

Before `SELECTED_REFERENCE`:
- stable ID + Drive ID recorded;
- native dimensions recorded;
- native-pixel/critical-detail review completed;
- generated labels ignored/reconciled;
- numeric scale reconciled;
- cross-view contradictions documented;
- no severe anatomy/limb artifacts that would mislead modeling;
- intended use explicit;
- parent/master lineage recorded.

Before `CONVERSION_TEST_OK`, additional conversion preflight is mandatory.

---

# 9. Machine-readable manifest later

Do not create a fake operational JSON/YAML schema before validators/tooling exist.

When asset automation begins, this Markdown authority should produce/align with a machine-readable manifest containing stable IDs, lineage and gates.

---

# 10. Current gate

`ASSET_LINEAGE_AUTHORITY = RECORDED`
`HUNTER_H02_V001 = REVIEWED_WITH_ISSUES / REVISE`
`HUNTER_H02_V002 = REVIEWED_WITH_ISSUES / REVISE / DRIVE_VERIFIED`
`HUNTER_H02A_V003 = REVIEWED_WITH_ISSUES / REVISE_METHOD / DRIVE_VERIFIED`
`REPEATED_HUNTER_AI_MULTIVIEW_REGENERATION = PAUSED`
`HUNTER_DCC_BLOCKOUT_SPECIFICATION = RECORDED`
`DCC_BLOCKOUT_IMPLEMENTATION = NOT AUTHORIZED`
`HUNTER_H04 = GENERATED_UNREVIEWED / BLOCKED`
`MONSTER_M01M02 = GENERATED_UNREVIEWED / DRIVE_VERIFIED`
`MONSTER_M03_M04_M05_M08_DRIVE_PERSISTENCE = NOT VERIFIED`
`SELECTED_HUNTER_TECHNICAL_REFERENCE = NONE`
`HUNTER_CONVERSION_INPUT = NONE`
`APPROVED_RUNTIME_2D = NONE`
`GAME_READY_3D = NONE`

Next bounded quality action while implementation remains blocked:
**do not generate H02A v004 with the same method. Reconcile continuity, then choose another independent documentation/design packet rather than repeating a failed generation path.**