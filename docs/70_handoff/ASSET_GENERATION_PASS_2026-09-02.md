# Asset Generation / Lineage Pass — 2026-09-02

Status: ACTIVE HANDOFF / HUNTER AI MULTIVIEW ROUTE PAUSED / DCC SPEC READY / GAMEPLAY IMPLEMENTATION STILL NOT AUTHORIZED

## Current objective

Prevent repeated low-value visual regeneration from contaminating downstream modeling decisions.

Hunter H02 v001, H02 v002, and H02A v003 have all been reviewed.

Current decisions:
- `H02 v001 → REVISE`;
- `H02 v002 → REVISE`;
- `H02A v003 → REVISE_METHOD`.

The repeated root cause is now established:
**independent generated character-sheet imagery is converging on polished infographics/contact sheets rather than clean, high-occupancy, geometrically controlled source views.**

Therefore the project invokes the stop rule:
**do not generate H02A v004 with the same method.**

Reference-image generation remains generally authorized, but this specific repeated Hunter technical-multiview route is paused. Gameplay code, engine project, scenes, APK and final game-ready 3D implementation remain not authorized.

---

# Primary current authorities

Asset pipeline:
- `docs/40_art/asset_pipeline/README.md`
- `ASSET_LINEAGE_AND_APPROVAL_MANIFEST.md`
- `GENERATED_SHEET_REGISTRY.md`
- `ASSET_QA_GATES.md`
- `RASTER_RESOLUTION_AND_ZOOM_QUALITY.md`
- `HUNTER_TECHNICAL_SOURCE_PACK_STANDARD.md`
- `HUNTER_DCC_BLOCKOUT_SPECIFICATION.md`
- `RUNTIME_2D_ASSET_GUIDE.md`
- `PNG_TO_3D_AUTOMATION_PIPELINE.md`
- `EXTERNAL_3D_TOOL_EVALUATION.md`

Reviews:
- `docs/40_art/reviews/HUNTER_BASE_01_H02_v001_QA.md`
- `docs/40_art/reviews/HUNTER_BASE_01_H02_v002_QA.md`
- `docs/40_art/reviews/HUNTER_BASE_01_H02A_v003_QA.md`

Hunter design/geometry:
- `docs/30_content/hunters/HUNTER_BASE_01/README.md`
- `docs/30_content/hunters/HUNTER_BASE_01/PROPORTION_AND_ATTACHMENT_CONTRACT.md`

---

# Drive state

Project root:
`Unnamed Hunt RPG` — `1N3FbZhLE9ZfEy1Og-iNiB2B7nyyfangt`

Modeling references / Hunter:
`1XM-kcLfxD3Af-HAPRu4zlO691RgDJLlE`

Current Hunter source files:
- v001 — `1U9vm0y7YSSGnEiPYO8C7M8QAq43FyibV`;
- v001 upscale — `1hcxXoOH6xsy-CXh2EoyhnjgIH_etizOc`;
- v002 — `1kkRFXV2Mtk1sWyhjxdnSGm7l6xQRMZE4`;
- H02A v003 — `1EjeitWONWZ2PHPbVkI-dvcVIoiL7bcfE`.

3D conversion-input Hunter folder remains empty of approved conversion input:
`1fbVPHHyVmGuqAxaKsUXSKAYdYk-BeJy4`.

No Hunter file is technically selected for conversion.

---

# Hunter Base 01 authority

Current base design remains:
- prototype height 1.75 m;
- realistic adult humanoid proportions;
- practical frontier layered cloth/leather foundation;
- limited removable protective plate;
- modular harness/pouches/boots/field tools;
- no giant fantasy armor;
- no locked weapon family;
- final protagonist face/name/story identity OPEN.

Normalized prototype body anchors and stable technical attachment names are recorded in:
`PROPORTION_AND_ATTACHMENT_CONTRACT.md`.

---

# H02A v003 result

File:
`HUNTER_BASE_01_H02A_ORTHO_REF_v003.png`
Drive ID:
`1EjeitWONWZ2PHPbVkI-dvcVIoiL7bcfE`
Observed raster:
`1536 × 1024`.

State:
`REVIEWED_WITH_ISSUES / REVISE_METHOD / DISCUSSION_ONLY`.

What was requested:
- source-only front/left/back/right views;
- figures occupying most of raster height;
- no infographic panels;
- no material/PBR chart;
- no details/loadouts/monster comparison;
- no generated file/status/checksum metadata;
- same neutral body/gear construction.

What was generated instead:
- orthographic views plus material chart;
- design-intent panel;
- close-up details;
- landmark table;
- equipment progression;
- attachment map;
- monster scale comparison;
- distance-readability views;
- modeling notes;
- file/permissions/revision/checksum blocks.

This directly violates the technical source-pack contract.

Generated text also contains non-authoritative values/claims, including date, permissions, PBR guidance, asset status, technical readiness, landmark values and checksum placeholders.

The output may remain a discussion visual, but it is not geometric truth, detail authority or conversion input.

QA:
`docs/40_art/reviews/HUNTER_BASE_01_H02A_v003_QA.md`.

---

# Escalation decision

The project will not spend more generation quota trying H02A v004 using the same method.

The next trustworthy geometric path, when explicitly authorized, is:

`1.75 m DCC mannequin`
→ `normalized landmark check`
→ `neutral proportion blockout`
→ `attachment guides`
→ `clearance pose tests`
→ `simple clothing/harness shells`
→ `front/left/back/right orthographic renders from the same geometry`
→ `H02A technical source`
→ later `H02B 3/4 confirmation`.

Specification:
`docs/40_art/asset_pipeline/HUNTER_DCC_BLOCKOUT_SPECIFICATION.md`.

The specification records:
- metric/world scale;
- minimum mannequin masses;
- landmark validation;
- neutral stance;
- minimal joint scaffold;
- stable attachment guides;
- crouch/walk/reach/guard/dodge clearance tests;
- clothing blockout order;
- orthographic camera outputs;
- camera/collision implications;
- Android/performance cautions;
- explicit stop conditions.

Actual DCC creation remains **NOT AUTHORIZED** under the current implementation hold.

---

# H04 and Monster state

Hunter H04 remains:
`GENERATED_UNREVIEWED / BLOCKED`.

Do not approve equipment silhouettes against an unresolved neutral body.

Monster 01 hero/turnaround remains:
`GENERATED_UNREVIEWED / DRIVE_VERIFIED`.

Monster M03/M04/M05/M08 Drive persistence remains unverified.

The Hunter DCC block does not require the entire project to stop. While implementation is held, future bounded work should choose independent documentation/design areas rather than repeating this blocked source-generation path.

---

# Current gates

`HUNTER_BASE_01_DESIGNED = YES`
`HUNTER_PROPORTION_ATTACHMENT_CONTRACT = RECORDED`
`H02_V001 = REVIEWED_WITH_ISSUES / REVISE`
`H02_V002 = REVIEWED_WITH_ISSUES / REVISE`
`H02A_V003 = REVIEWED_WITH_ISSUES / REVISE_METHOD / DRIVE_VERIFIED`
`H02A_V004_SAME_METHOD = DO_NOT_GENERATE`
`REPEATED_HUNTER_AI_MULTIVIEW_REGENERATION = PAUSED`
`HUNTER_DCC_BLOCKOUT_SPECIFICATION = RECORDED`
`DCC_BLOCKOUT_IMPLEMENTATION = NOT AUTHORIZED`
`H02B_V003 = BLOCKED`
`H03_DETAILS = BLOCKED/CONDITIONAL`
`H04_V001 = GENERATED_UNREVIEWED / BLOCKED`
`MONSTER_M01M02 = GENERATED_UNREVIEWED / DRIVE_VERIFIED`
`MONSTER_M03_M04_M05_M08_DRIVE_PERSISTENCE = NOT VERIFIED`
`SELECTED_HUNTER_TECHNICAL_REFERENCE = NONE`
`HUNTER_CONVERSION_INPUT = NONE`
`APPROVED_RUNTIME_2D = NONE`
`GAME_READY_3D = NONE`
`GAMEPLAY_SOURCE = NOT CREATED`
`ENGINE = NOT SELECTED`
`PHONE_RUNTIME = NOT VERIFIED`

## Exact next bounded choice

Because the Hunter technical-image route is blocked by method and DCC implementation is not authorized, do **not** regenerate H02A again.

The next design/documentation pass should move to an independent high-value area, preferably one that does not require selected Hunter geometry. Strong candidates are:
1. player progression/equipment system packet;
2. exact combat action-economy packet;
3. settlement NPC population/schedule/load simulation contract;
4. Region 01 ecology/encounter population budget refinement;
5. Monster 01 non-visual mechanical balance packet.

Choose only one in the next bounded pass.