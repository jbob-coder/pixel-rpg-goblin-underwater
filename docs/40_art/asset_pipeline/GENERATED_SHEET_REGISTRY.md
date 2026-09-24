# Generated Sheet Registry

Status: ACTIVE REFERENCE REGISTRY
Last reconciled: 2026-09-02

## Purpose

Track the Hunter Base 01 and Monster 01 visual-reference sequence without confusing generation, persistence, review, technical use or approval.

Cross-lane identity/lineage/permitted-use authority:
`ASSET_LINEAGE_AND_APPROVAL_MANIFEST.md`.

Per-asset QA records:
`docs/40_art/reviews/`.

Technical Hunter source-pack structure:
`HUNTER_TECHNICAL_SOURCE_PACK_STANDARD.md`.

Hunter geometry contract:
`docs/30_content/hunters/HUNTER_BASE_01/PROPORTION_AND_ATTACHMENT_CONTRACT.md`.

Future DCC escalation specification:
`HUNTER_DCC_BLOCKOUT_SPECIFICATION.md`.

Uploading does not approve an asset.

## Status vocabulary

- `PLANNED`
- `GENERATED_UNREVIEWED`
- `GENERATED_PERSISTENCE_UNVERIFIED`
- `REVIEWED_WITH_ISSUES`
- `SELECTED_REFERENCE`
- `CONVERSION_INPUT_CANDIDATE`
- `RUNTIME_2D_CANDIDATE`
- `TECHNICALLY_VERIFIED`
- `REJECTED`
- `SUPERSEDED`

---

# Existing selected general boards

### REF-MODEL-001
`Unnamed Hunt RPG - Art Direction Overview.png`
Status: `SELECTED_REFERENCE`
Use: art-direction communication only.
Runtime 2D: NO.
3D conversion: NO.

### REF-MODEL-002
`Unnamed Hunt RPG - Model Creation Pipeline and Visual Guide.png`
Status: `SELECTED_REFERENCE`
Use: pipeline communication only.
Runtime 2D: NO.
3D conversion: NO.

---

# Hunter Base 01

## H02 v001
File: `HUNTER_BASE_01_H02_TURNAROUND_SCALE_v001_DRAFT_REFERENCE.png`
Drive ID: `1U9vm0y7YSSGnEiPYO8C7M8QAq43FyibV`
Status: `REVIEWED_WITH_ISSUES`
Decision: `REVISE`
Use: `DISCUSSION_ONLY`
QA: `docs/40_art/reviews/HUNTER_BASE_01_H02_v001_QA.md`

## H02 v002
File: `HUNTER_BASE_01_H02_TURNAROUND_SCALE_REF_v002.png`
Drive ID: `1kkRFXV2Mtk1sWyhjxdnSGm7l6xQRMZE4`
Observed raster: `1536 × 1024`
Status: `REVIEWED_WITH_ISSUES`
Decision: `REVISE`
Use: `DISCUSSION_ONLY`
QA: `docs/40_art/reviews/HUNTER_BASE_01_H02_v002_QA.md`

Primary blocker:
source was still an overloaded infographic rather than high-occupancy technical source imagery.

## H02A v003 — orthographic source attempt
File: `HUNTER_BASE_01_H02A_ORTHO_REF_v003.png`
Stable ID: `HUNTER01-H02A-REF-003`
Drive ID: `1EjeitWONWZ2PHPbVkI-dvcVIoiL7bcfE`
Observed raster: `1536 × 1024`
Status: `REVIEWED_WITH_ISSUES`
Decision: `REVISE_METHOD`
Use: `DISCUSSION_ONLY`
QA: `docs/40_art/reviews/HUNTER_BASE_01_H02A_v003_QA.md`

Why v003 is not selected:
- generation again produced a dense infographic/contact sheet;
- orthographic figures do not dominate raster height as required;
- material, detail, loadout, monster-comparison, readability, note and metadata panels were added despite explicit exclusions;
- generated detail panels cannot prove exact identity with the main views;
- generated landmark/status/permission/checksum text is not authority;
- source is not isolated or conversion-safe;
- exact cross-view geometry still cannot be proven from independent generated illustrations.

Quality escalation:
**do not generate H02A v004 using the same independent image-generation approach.**

When DCC/art-production implementation is explicitly authorized, follow:
`HUNTER_DCC_BLOCKOUT_SPECIFICATION.md`
→ create one 1.75 m geometric mannequin
→ validate proportions/clearances
→ derive front/left/back/right renders from that single model.

### H02B v003
Status: `BLOCKED`.
Reason: H02A has no selected technical source.

### H03 details
Status: `BLOCKED/CONDITIONAL`.
Reason: generated detail references should not expand until one geometric base exists.

## H04 v001 — modular equipment silhouettes
File: `HUNTER_BASE_01_H04_MODULAR_SILHOUETTES_v001_DRAFT_REFERENCE.png`
Drive ID: `1j2eQCUfUzc-kgt4egH15dzPK-5Gv6OAF`
Status: `GENERATED_UNREVIEWED`.
Review blocked until a neutral Hunter technical base is selected.

---

# Monster 01 — Mudcrest Raker

## M01/M02 hero + turnaround
File: `MONSTER_01_M01_M02_HERO_TURNAROUND_v001_VISUAL_CANDIDATE.png`
Drive ID: `1yMLP6lcO4Us4uJO2CMNUCusiXlWpwI2m`
Status: `GENERATED_UNREVIEWED`.

Must later reconcile against:
- ~6.6 m length;
- ~3.0 m shoulder/main-body height;
- front-heavy quadruped;
- paired mineral horn crest;
- breakable dorsal plates;
- mud-adapted feet;
- long tail with legal distal sever boundary;
- eight authoritative first-slice target groups.

No conversion copy yet.

## M03 anatomy overlay
Expected file: `MONSTER_01_M03_ANATOMY_v001_TECHNICAL_OVERLAY.png`
Drive persistence: NOT VERIFIED.
Status: `GENERATED_PERSISTENCE_UNVERIFIED`.

## M04 damage/break/sever
Expected file: `MONSTER_01_M04_DAMAGE_STATES_v001_DRAFT_REFERENCE.png`
Drive persistence: NOT VERIFIED.
Status: `GENERATED_PERSISTENCE_UNVERIFIED`.

## M05 crystal/mutation variants
Expected file: `MONSTER_01_M05_CRYSTAL_MUTATION_VARIANTS_v001_TECHNICAL_CONCEPT.png`
Drive persistence: NOT VERIFIED.
Status: `GENERATED_PERSISTENCE_UNVERIFIED`.

## M08 three-distance readability
Expected file: `MONSTER_01_M08_THREE_DISTANCE_v001_VISUAL_CANDIDATE.png`
Drive persistence: NOT VERIFIED.
Status: `GENERATED_PERSISTENCE_UNVERIFIED`.

No Monster visual asset is selected/technical/conversion-approved yet.

---

# Current review/order decision

The Hunter AI-multiview generation branch is paused because v001, v002 and v003 repeated the same technical-source problem.

Do not consume more generation attempts by producing H02A v004 with the same method.

Current safe order:
1. preserve/reconcile H02A v003 as `REVISE_METHOD`;
2. keep DCC blockout specification ready but unimplemented until explicit authorization;
3. while DCC remains blocked, move only to an **independent** documentation/design packet that does not rely on a selected Hunter geometry source;
4. do not approve H04 against an unresolved base;
5. do not claim M03/M04/M05/M08 are Drive-safe until persistence is restored/read back.

## Current gate

`H02_V001 = REVIEWED_WITH_ISSUES / REVISE`
`H02_V002 = REVIEWED_WITH_ISSUES / REVISE`
`H02A_V003 = REVIEWED_WITH_ISSUES / REVISE_METHOD / DRIVE_VERIFIED`
`H02A_V004_SAME_METHOD = DO_NOT_GENERATE`
`HUNTER_DCC_BLOCKOUT_SPEC = RECORDED / IMPLEMENTATION_BLOCKED`
`H02B_V003 = BLOCKED`
`H03_DETAILS = BLOCKED/CONDITIONAL`
`H04_V001 = GENERATED_UNREVIEWED / BLOCKED BY NEUTRAL BASE`
`MONSTER_M01M02 = GENERATED_UNREVIEWED / DRIVE_VERIFIED`
`MONSTER_M03 = GENERATED / DRIVE_PERSISTENCE_UNVERIFIED`
`MONSTER_M04 = GENERATED / DRIVE_PERSISTENCE_UNVERIFIED`
`MONSTER_M05 = GENERATED / DRIVE_PERSISTENCE_UNVERIFIED`
`MONSTER_M08 = GENERATED / DRIVE_PERSISTENCE_UNVERIFIED`
`SELECTED_HUNTER_TECHNICAL_REFERENCE = NONE`
`HUNTER_CONVERSION_INPUT = NONE`
`APPROVED_RUNTIME_2D = NONE`
`GAME_READY_3D = NONE`