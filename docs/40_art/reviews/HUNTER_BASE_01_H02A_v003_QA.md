# Hunter Base 01 — H02A Orthographic Source v003 QA

Status: REVIEWED / SOURCE-GENERATION ROUTE BLOCKED
Decision: `REVISE_METHOD`
Last reconciled: 2026-09-02

## Asset identity

Stable asset ID: `HUNTER01-H02A-REF-003`
File: `HUNTER_BASE_01_H02A_ORTHO_REF_v003.png`
Drive file ID: `1EjeitWONWZ2PHPbVkI-dvcVIoiL7bcfE`
Drive lane: `01_Modeling_References/Hunter`
Observed raster dimensions: `1536 × 1024` pixels.
Class: `REFERENCE_MASTER` for generated revision v003.
Owning contracts:
- `docs/30_content/hunters/HUNTER_BASE_01/README.md`;
- `PROPORTION_AND_ATTACHMENT_CONTRACT.md`;
- `docs/40_art/asset_pipeline/HUNTER_TECHNICAL_SOURCE_PACK_STANDARD.md`;
- `ASSET_QA_GATES.md`.

## Intended role

H02A v003 was supposed to be a source-only orthographic/multiview reference with:
- front;
- left;
- back;
- right where practical;
- figures occupying most of raster height;
- no infographic panels;
- no material chart;
- no monster comparison;
- no loadout examples;
- no fake metadata or approval fields;
- minimal labels only.

The generated result did not obey that source architecture.

## Decision summary

The visual direction remains usable for discussion, but this output fails the primary technical-source contract.

Decision: `REVISE_METHOD`, not merely `REVISE_IMAGE`.

Reason:
three consecutive generations have converged on polished infographic/contact-sheet behavior rather than a clean source pack. Continuing to regenerate the same way is now considered low-value repetition.

## Gate 1 — source integrity
Result: `PASS WITH WARNING`.

Verified:
- file is persisted in the correct Hunter modeling-reference Drive folder;
- v003 has a distinct Drive identity;
- previous revisions remain preserved.

Generated text embedded in the image is not authority.

Visible generated metadata/claims that must be ignored include:
- generated date;
- generated asset/status fields;
- generated permissions;
- generated `3D Conversion Input` claims;
- generated PBR/file recommendations;
- generated checksum/verification placeholders;
- generated landmark values that differ from the recorded proportion contract.

## Gate 2 — native-pixel/source-occupancy review
Result: `FAIL`.

The source contract required the orthographic bodies to dominate the raster.

Instead, the output again allocates substantial pixels to:
- material charts;
- design-intent copy;
- close-up detail panels;
- landmark table;
- equipment progression;
- attachment map;
- monster comparison;
- distance-readability panel;
- modeler notes;
- file/permissions/revision/checksum panels.

The four turnaround figures therefore occupy too little of the raster for a technical source.

This repeats the v001/v002 root cause.

## Gate 3 — close-detail review
Result: `NOT A VALID SOURCE TEST`.

Close-up panels exist, but they are independently generated presentation content rather than proven crops of the same exact body instance.

They may communicate broad material/equipment ideas only.

They cannot establish exact:
- glove construction;
- strap routing;
- buckle geometry;
- boot closure;
- harness seams;
- attachment transforms.

## Gate 6 — cross-view consistency
Result: `INSUFFICIENT FOR TECHNICAL APPROVAL`.

The front/left/back/right views are broadly similar in silhouette, which is useful directional evidence.

However they are still generated illustrations embedded in an infographic and are not controlled orthographic renders from one geometric source.

The QA standard therefore cannot prove that the views describe exactly one body/gear construction.

The recorded proportion/attachment contract remains authoritative over generated imagery.

## Gate 7 — 3D conversion preflight
Result: `FAIL`.

Do not copy v003 into `03_3D_Conversion_Inputs/Hunter`.

Reasons:
- subject views are not isolated;
- multiple unrelated panels and figures exist in the same image;
- generated text is present;
- orthographic source occupancy is too low;
- no proof of exact cross-view geometric identity;
- generated close-ups may redesign the subject;
- generated metadata falsely implies permissions/technical readiness.

## Contract violations

H02A v003 violates the source-pack contract by including content explicitly excluded from H02A:
- material/PBR chart;
- detail panels;
- proportion table;
- equipment progression;
- attachment visualization;
- monster scale comparison;
- distance views;
- technical notes;
- file/status/permissions/revision/checksum blocks.

This is an architectural failure of the current image-generation route, not a reason to keep adding more prompt instructions indefinitely.

## Useful content retained only as discussion direction

The output still supports broad discussion of:
- grounded practical frontier clothing;
- layered cloth/leather construction;
- restrained protective pieces;
- clear hunter silhouette;
- modular utility language;
- approximate overall human proportion.

It does not become technical geometry authority.

## Quality escalation decision

The project now invokes the stop rule already described in the Hunter source-pack/proportion contracts:

**Do not keep regenerating independent AI multiview sheets once repeated outputs fail to become controlled geometry.**

The next technical path should be:
`documented 1.75 m mannequin specification → controlled DCC blockout when explicitly authorized → front/side/back orthographic renders from that one model → H02A technical source derived from real geometry`.

This is expected to produce better downstream quality than a fourth independent image-generation attempt.

## Permitted use

v003:
- `DISCUSSION_ONLY`;
- broad visual-direction reference only.

Not permitted:
- `MODELING_REFERENCE_OK` for exact geometry — NO;
- `DETAIL_REFERENCE_OK` — NO;
- `CONVERSION_TEST_OK` — NO;
- `RUNTIME_2D_TEST_OK` — NO.

## Next bounded action

Do not generate H02A v004 with the same image-generation method.

Next documentation piece:
create/finalize a **Hunter DCC Blockout Specification** defining the minimum mannequin geometry, scale checks, rig-clearance poses, attachment empties/guides, orthographic camera setup, and exact outputs required before art-detail modeling.

Actual DCC implementation remains blocked until the user explicitly authorizes implementation/art-production tooling.