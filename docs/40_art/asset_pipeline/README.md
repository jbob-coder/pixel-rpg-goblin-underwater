# Unnamed Hunt RPG — Asset Production Pipeline

Status: ACTIVE DESIGN/PRODUCTION CONTRACT / NO ENGINE IMPORT YET
Last reconciled: 2026-09-02

## Purpose

Separate asset classes that must never be confused and define the documentation that controls movement between them.

Primary classes:
1. **Modeling references** — visual/technical references used to create 3D assets.
2. **2D runtime working assets** — images intentionally being prepared for in-game use.
3. **3D conversion inputs** — clean PNG/multiview sources optimized for reconstruction tools.
4. **Approved exports** — technically verified game-ready 2D/3D outputs.
5. **Rejected/superseded history** — retained only for provenance/debugging where useful.

A source image may appear in more than one lane only through an explicit derived/copy record. Folder location alone never proves technical validity.

---

# Drive storage map

Project root: `Unnamed Hunt RPG`
- Folder ID: `1N3FbZhLE9ZfEy1Og-iNiB2B7nyyfangt`

## Asset manifests
`00_Asset_Manifests`
- ID: `1cg-zesn5QTcSIm63pnt1FeH7TYvxKlfo`

Purpose:
- human-readable/machine-readable manifest exports later;
- integrity/provenance records;
- release/export lists;
- never store ordinary concept images here.

## Modeling references
`01_Modeling_References`
- ID: `1qsF_JUYBs9ZQ-1lZPHsTCwWn87W46VIs`
- Hunter: `1XM-kcLfxD3Af-HAPRu4zlO691RgDJLlE`
- Monster_01: `1klaz1KEefbWZ2cMMH3N6m--lbQqf9CUe`

## 2D runtime working assets
`02_2D_Runtime_Assets`
- ID: `1PJ7uzt8oZBE5jFPXoBeldGVVv9Dy1Ko_`
- UI_Icons: `1lB-X102Z804LpQw5SBuDMibHHqtWVQzR`
- Bestiary_Portraits_Illustrations: `1Qz3XZYmsYP-BtXmmdVHnMxBe_-lk7h2Q`
- Decals_VFX_Sprites: `1oAkamHy_0AZtDksTOAyA_BrNHpdOmiMY`
- Maps_Billboards_Impostors: `1d14laLOIaHoL9ydx75IBWGfh0i_xqYbe`

## 3D conversion inputs
`03_3D_Conversion_Inputs`
- ID: `1hs-qJiiF6R-1NLBmlChvSK4rlQilONLz`
- Hunter: `1fbVPHHyVmGuqAxaKsUXSKAYdYk-BeJy4`
- Monster_01: `19iD9tQXEtQEL-Io8Y5MD5h-WPRVKYjEa`

## Approved exports
`04_Approved_Exports`
- ID: `1yrS6vXQElSahDUtFJjjst25gq8RIGm2P`
- 2D_Runtime: `1S7q8hBrcFoI2iPSJqWXPWJrGmxfPu3A_`
- 3D_Game_Ready: `1rA4FTPUfX1VXdU3QlhVMEShr5gzn7Z_g`

Approved folders are not dumping grounds. A file only enters after its matching QA/verification gates pass.

---

# Primary authorities

## `ASSET_LINEAGE_AND_APPROVAL_MANIFEST.md`
Owns:
- stable asset IDs;
- parent/master lineage;
- actual Drive IDs/locations;
- asset class;
- review state;
- permitted use;
- current verified persistence state;
- promotion rules;
- supersession/rejection lineage.

This is the authority when a filename/folder/status description disagrees.

## `GENERATED_SHEET_REGISTRY.md`
Owns:
- Hunter/Monster sheet sequence;
- sheet-specific requirements;
- current generation/review order.

It does not replace the cross-lane manifest.

## `ASSET_QA_GATES.md`
Owns:
- native-pixel/zoom review;
- scale/turnaround checks;
- conversion/reconstruction QA;
- anatomy/sever/rig/LOD checks;
- runtime 2D and Android approval gates.

## `RASTER_RESOLUTION_AND_ZOOM_QUALITY.md`
Owns raster master/derivative/upscale/zoom policy.

## `RUNTIME_2D_ASSET_GUIDE.md`
Owns actual game-shipped 2D image rules.

## `PNG_TO_3D_AUTOMATION_PIPELINE.md`
Owns image-reference → reconstruction → DCC → game-ready orchestration.

## `EXTERNAL_3D_TOOL_EVALUATION.md`
Tracks external/current-tool candidates separately from durable architecture.

---

# Classification law

## MODEL_REFERENCE
May guide:
- silhouette;
- color/material intent;
- proportion candidate;
- anatomy-region intent;
- damage-state appearance;
- equipment modularity;
- mood/presentation.

Does not prove:
- exact dimensions;
- topology;
- UVs;
- rigging;
- texture-map correctness;
- collision/hit proxies;
- LOD/device performance.

## RUNTIME_2D
Must be intentionally authored/derived for runtime use and pass:
- native-size readability;
- intended display-size review;
- transparency/edge check;
- compression check;
- mip/filter behavior where applicable;
- memory budget;
- device visual check.

A modeling reference is never automatically a runtime 2D asset.

## CONVERSION_INPUT
Must prioritize reconstruction quality over beauty composition:
- isolated subject;
- neutral background/alpha;
- neutral pose;
- minimal perspective distortion;
- complete unobstructed silhouette;
- consistent multiview proportions where available;
- no text over subject;
- no dramatic effects/particles;
- high source resolution;
- recorded scale/spec source.

## APPROVED_EXPORT
Only after technical validation. Approval is recorded in manifest and QA evidence, not inferred from folder location.

---

# Source/master/derivative law

Preferred chain:

`ORIGINAL/GENERATED SOURCE → CLEAN/SELECTED MASTER → TASK-SPECIFIC DERIVATIVES → VERIFIED EXPORT`

Never overwrite the master with a smaller runtime derivative.

Every derivative records:
- stable Asset ID;
- Parent Asset ID;
- Master Asset ID;
- revision;
- purpose;
- permitted-use flags.

Upscaled references remain derivatives. They cannot create new authoritative measurement/anatomy/texture truth.

---

# Filename/version law

Going forward, stable asset ID + manifest status is preferred over embedding volatile words like `FINAL`, `LATEST`, `APPROVED`, or `CURRENT` in filenames.

Existing v001 files with `DRAFT_REFERENCE`/`VISUAL_CANDIDATE` are retained as historical names; their current state comes from the manifest.

Material pixel/geometry changes increment revision.

Status-only changes update the manifest rather than forcing unnecessary duplicate files.

---

# Current reconciled Drive state

As of the latest readback:

Hunter modeling-reference folder contains:
- H02 turnaround/scale v001 draft reference;
- H02 upscaled inspection derivative;
- H04 modular silhouettes v001 draft reference.

Monster_01 modeling-reference folder currently contains:
- M01/M02 hero + turnaround v001 visual candidate.

The generated anatomy, damage, mutation and three-distance Monster sheets have not yet been verified as persisted in the current Monster_01 Drive folder. Treat them as persistence-unverified until uploaded/read back.

No first-sheet reference has been promoted to `SELECTED_REFERENCE` during the current lineage pass.

---

# Current bounded quality order

Do not generate more art simply because generation is available.

Current next sequence:
1. review Hunter H02 against `ASSET_QA_GATES.md`;
2. choose SELECT / REVISE / REJECT;
3. update manifest + sheet registry;
4. review Hunter H04;
5. review Monster hero/turnaround;
6. restore/verify later Monster sheet persistence;
7. then review those sheets individually.

This prevents quantity from outrunning quality control.

---

# Related root/package authorities

- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`
- `MODEL_REFERENCE_IMAGE_AND_CREATION_PIPELINE.md`
- `PERFORMANCE_BUDGETS_AND_CAPS.md`
- `DESIGN_QUALITY_GATES_AND_DEPENDENCY_MATRIX.md`
- `docs/30_content/hunters/HUNTER_BASE_01/README.md`
- `docs/30_content/monsters/MONSTER_01/*`

---

# Current gate

`STORAGE_TAXONOMY = CREATED`
`ASSET_MANIFEST_FOLDER = CREATED`
`ASSET_LINEAGE_AUTHORITY = RECORDED`
`DRIVE_REFERENCE_CONTENTS = RECONCILED`
`REFERENCE_SHEET_GENERATION = PAUSED_FOR_QA_REVIEW`
`SELECTED_REFERENCE_PROMOTION = NONE THIS PASS`
`APPROVED_RUNTIME_2D = NONE`
`GAME_READY_3D = NONE`
`ENGINE_IMPORT = NOT AUTHORIZED / NOT EXECUTED`
