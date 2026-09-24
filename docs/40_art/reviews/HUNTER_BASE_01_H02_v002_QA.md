# Hunter Base 01 — H02 Turnaround + Scale v002 QA

Status: REVIEWED / REVISION REQUIRED
Decision: `REVISE`
Last reconciled: 2026-09-02

## Asset identity

Stable asset ID: `HUNTER01-H02-REF-002`
File: `HUNTER_BASE_01_H02_TURNAROUND_SCALE_REF_v002.png`
Drive file ID: `1kkRFXV2Mtk1sWyhjxdnSGm7l6xQRMZE4`
Drive lane: `01_Modeling_References/Hunter`
Observed raster dimensions: `1536 × 1024` pixels.
Class: `REFERENCE_MASTER` for generated revision v002.
Owning hunter design: `docs/30_content/hunters/HUNTER_BASE_01/README.md`.
Parent design revision: v001 QA/revision request in `HUNTER_BASE_01_H02_v001_QA.md`.

## Intended role

v002 attempted to correct v001 by adding:
- front;
- left side;
- back;
- right side;
- 3/4 confirmation;
- scale reference;
- close-up hands/boots/harness;
- modular equipment concepts.

It is materially better organized than v001, but it still does not pass as a technical turnaround/conversion source.

# What improved from v001

Preserve these improvements:
- five primary body views are now present rather than only an incomplete illustrative set;
- 1.75 m is visibly used as the intended human scale;
- base clothing/protection reads more modular and less like one solid armor suit;
- the silhouette is clear at thumbnail/aerial-reference size;
- hands, boots, torso/harness and belt/pouch areas receive dedicated visual attention;
- front/side/back overall body mass is more coherent than v001;
- the art remains grounded and practical rather than chibi, heroic-proportion or neon-fantasy.

These improvements justify another targeted revision rather than abandoning the design direction.

# QA results

## Gate 1 — source integrity
Result: `PASS WITH GENERATED-METADATA WARNING`.

Verified:
- v002 is saved in the correct Hunter modeling-reference Drive lane;
- exact Drive file identity is recorded;
- v002 remains separate from v001 and does not overwrite history.

Generated text inside the image is **not** authority.

Known generated/incorrect metadata inside the PNG includes:
- date `2025-05-22` rather than project date;
- generated asset/status labels;
- a claimed `3D Conversion Input: YES` permission;
- generated file-format/resolution recommendations;
- checksum/verification placeholders;
- modeling/PBR guidance that was not independently technically authored.

Those embedded statements must be ignored. Repository Markdown + manifest + executed QA gates remain authority.

## Gate 2 — native-pixel review
Result: `FAIL FOR TECHNICAL TURNAROUND DETAIL`.

The full raster is only 1536 × 1024.

Because the page contains many panels, each full-body turnaround figure occupies only a fraction of the available pixels. The sheet therefore repeats the central v001 failure in a more polished layout:

**the canvas is information-dense, but the actual orthographic subject is still too small.**

At technical inspection scale:
- fingers/glove structure remain too coarse;
- boot seams/closures are still not authoritative;
- harness and armor attachment edges are partly painterly;
- small pouch/buckle geometry cannot be trusted as exact;
- facial/hair detail is visually strong enough to imply identity but not technically useful enough to model precisely.

## Gate 3 — close-detail review
Result: `PARTIAL / NOT AUTHORITATIVE`.

The dedicated close-up panels are useful visual concepts, but they cannot automatically be treated as exact magnifications of the body views.

Reason:
AI-generated close-ups may independently redesign:
- fingers;
- glove seams;
- buckle shape;
- belt layering;
- boot construction;
- harness stitching.

Therefore the detail panels are `DETAIL_DIRECTION` only until reconciled against a real DCC blockout or controlled reference pipeline.

## Gate 5 — derivative/scale behavior
Result: `PASS AS DIRECTIONAL REFERENCE`.

The sheet reads clearly when fit to screen and at ordinary documentation scale.

It does not solve technical zoom quality because native full-body figure resolution remains low.

No upscale may be promoted as a replacement for missing native detail.

## Gate 6 — turnaround consistency
Result: `IMPROVED BUT FAILS TECHNICAL MULTIVIEW STANDARD`.

Improvements:
- front/left/back/right/3-4 views are all represented;
- overall height and body mass appear broadly coherent;
- major garment/harness language is more consistent than v001.

Remaining problems:
- views are still rendered/illustrative rather than strict controlled orthographic captures;
- belt/pouch/strap geometry cannot be proven identical across every view;
- hand orientation differs naturally between views and lacks enough pixels for overlay-grade matching;
- collar/shoulder/arm protection is not sufficiently exact for direct reconstruction;
- 3/4 view remains a visual confirmation view, not geometric proof.

## Gate 7 — 3D conversion preflight
Result: `FAIL`.

Do not copy v002 into `03_3D_Conversion_Inputs/Hunter`.

Reasons:
- conversion subject is embedded in a dense infographic rather than isolated;
- multiple figures/text/panels compete with reconstruction tools;
- no transparent/clean isolated multiview source;
- per-view figure resolution is too low;
- cross-view geometric identity remains illustrative rather than verified;
- close-up panels are not guaranteed to be exact derivatives of the same body instance.

## Gate 11 — three-distance art suitability
Result: `PASS DIRECTIONALLY / NOT PRODUCTION VERIFIED`.

Aerial readability:
- good broad hunter silhouette;
- boots, shoulders, layered lower garment and belt mass remain visible.

Nearby exploration:
- clothing/equipment families read well.

First-person/close technical use:
- source detail is still not trustworthy enough for final production decisions.

# Identity and armor reconciliation

v002 improves modularity but still depicts a fairly specific adult male face/hair/beard identity.

Hunter Base 01 remains a reusable production base. Final protagonist identity is still OPEN.

For the neutral technical source pack:
- reduce identity specificity further;
- face/hair can remain simple/neutral;
- do not spend generation budget on portrait personality;
- keep base protection practical and modular;
- reserve heavier protection for H04/equipment-layer studies.

# Core quality fix discovered by v002

The problem is now architectural, not merely stylistic:

**a technical turnaround should not be generated as an infographic.**

Infographics are good for communication but inefficient for source pixels and unsafe for image-to-3D input.

The next revision must separate:
1. clean technical source views;
2. detail references;
3. communication/contact-sheet layout.

The communication sheet becomes a derivative assembled from the source pack, not the source pack itself.

# Decision

Primary decision: `REVISE`.

Review state:
`REVIEWED_WITH_ISSUES`.

Permitted use:
- `DISCUSSION_ONLY`;
- visual direction may inform v003.

Not permitted:
- `CONVERSION_TEST_OK` — NO;
- `RUNTIME_2D_TEST_OK` — NO;
- exact modeling dimensions/details from generated imagery — NO.

The numeric 1.75 m prototype height remains authoritative from Markdown.

# Next bounded action

Create the Hunter H02 v003 **source pack architecture** described in:
`docs/40_art/asset_pipeline/HUNTER_TECHNICAL_SOURCE_PACK_STANDARD.md`.

Do not review H04 or Monster 01 until the neutral Hunter source pack has a usable selected turnaround source.