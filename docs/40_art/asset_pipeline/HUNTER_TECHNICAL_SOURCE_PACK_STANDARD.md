# Hunter Technical Source Pack Standard

Status: ACTIVE ART/TECHNICAL REFERENCE CONTRACT
Last reconciled: 2026-09-02

## Purpose

Define how Hunter Base 01 reference imagery must be structured so it can support:
- DCC blockout;
- proportion checking;
- modular equipment design;
- possible image-to-3D experiments;
- later communication/contact sheets;
without sacrificing native subject resolution inside overloaded infographics.

Primary quality fix:

**technical source images and communication sheets are different asset classes.**

A polished infographic is never the primary technical source simply because it looks organized.

Hunter-specific scale/proportion/attachment authority:
`docs/30_content/hunters/HUNTER_BASE_01/PROPORTION_AND_ATTACHMENT_CONTRACT.md`.

H02A/H02B/H03 imagery must follow that contract. Generated views do not get to invent a different body, attachment layout or scale.

---

# 1. Source-pack architecture

Hunter H02 v003 should be split into task-specific source assets.

## H02A — Orthographic/multiview source
Purpose:
primary body/proportion reference.

Required content:
- front;
- left side;
- back;
- right side if generation budget permits;
- identical neutral modeling stance;
- same clothing/gear state across every view;
- same normalized body landmarks and attachment placement intent from `PROPORTION_AND_ATTACHMENT_CONTRACT.md`;
- no held weapon;
- no cape/large hanging object;
- plain neutral background or transparent isolated subjects;
- no large text panels;
- no monster comparison;
- no PBR swatches;
- no file-info/checksum blocks.

Composition rule:
**the hunter figures should consume most of the raster height.**

Target:
- approximately 75–90% of usable image height for full-body figures;
- minimal empty margin;
- enough separation to keep silhouettes isolated.

Text, if any:
- only small external labels such as FRONT / LEFT / BACK / RIGHT;
- labels must not touch the body;
- generated measurements are ignored; scale comes from Markdown.

Suggested filename:
`HUNTER_BASE_01_H02A_ORTHO_REF_v003.png`

Suggested stable asset ID:
`HUNTER01-H02A-REF-003`.

## H02B — 3/4 confirmation source
Purpose:
validate volume, layering and attachment interpretation after H02A.

Required:
- clean front 3/4;
- optional rear 3/4 if useful;
- same neutral base gear as H02A;
- same body landmarks and attachment identity as H02A;
- no dramatic pose;
- no weapon;
- no environment;
- high subject occupancy.

This view is secondary confirmation, not scale authority.

Suggested filename:
`HUNTER_BASE_01_H02B_3Q_REF_v003.png`

## H03 — Detail source pack
Purpose:
resolve areas too small in a full-body turnaround.

Separate detail panels/assets may cover:
- hands/gloves;
- boots;
- harness/shoulder attachment;
- belt/pouch attachment;
- collar/neck layering;
- knee/shin protection.

Important law:
a detail image must be treated as design intent until reconciled to H02A/DCC geometry. It cannot silently redesign the base.

Suggested grouped filename if one sheet is used:
`HUNTER_BASE_01_H03_DETAILS_REF_v001.png`

---

# 2. Communication/contact sheet

After source images exist, create a derived contact sheet for documentation.

Example:
`HUNTER_BASE_01_REFERENCE_CONTACT_v003.png`

It may contain:
- thumbnails of H02A/H02B/H03;
- material family;
- scale note;
- loadout notes;
- QA/status links.

But this contact sheet is classified as:
`REFERENCE_DERIVATIVE / COMMUNICATION`.

It is not copied to 3D-conversion input.

---

# 3. Hunter neutral-base visual contract

Current selected Hunter Base 01 direction:
- prototype height: 1.75 m;
- realistic adult humanoid proportions;
- grounded frontier clothing;
- layered cloth/leather foundation;
- limited removable protective plate;
- sturdy boots;
- modular harness/pouches/field-tool attachments;
- restrained color/material family;
- no giant fantasy armor;
- no glowing ornamentation;
- no fixed weapon family;
- final story identity/face/name remains OPEN.

The technical base should not be the heavy/reinforced loadout.

H04 later owns the major light/balanced/reinforced silhouette comparison.

---

# 4. Cross-view consistency requirements

Every orthographic source must preserve the body/gear invariants owned by:
`docs/30_content/hunters/HUNTER_BASE_01/PROPORTION_AND_ATTACHMENT_CONTRACT.md`.

At minimum preserve:
- total body height;
- shoulder width;
- pelvis/waist height;
- arm length;
- leg length;
- hand scale;
- boot height/sole thickness;
- collar height;
- harness path;
- pouch count and side;
- shoulder/forearm/shin protection placement;
- lower garment panel count/length.

If generated views contradict:
1. do not average contradictions silently;
2. choose/revise the intended construction in documentation;
3. regenerate if the contradiction is severe;
4. DCC blockout becomes geometric truth only after deliberate review.

Do not modify normalized body landmarks merely to make one generated view look better.

---

# 5. Resolution and zoom contract

Do not specify a fake universal pixel number before actual generation/tool constraints are known.

Instead enforce measurable subject occupancy.

For a technical full-body source:
- body should occupy at least ~75% of image height where practical;
- hands/boots should contain materially more real pixels than H02 v001/v002;
- avoid packing material charts, monsters, equipment progression and file metadata into the same source raster.

If important parts remain under-resolved:
create H03 detail sources.

Upscaling:
- permitted for inspection/reference restoration;
- cannot invent authoritative detail;
- never substitutes for a native-detail source.

---

# 6. Image-to-3D conversion rule

Only a cleaned derivative of a selected source may become `CONVERSION_INPUT`.

Conversion copy must:
- isolate subject/views;
- remove labels/panel borders;
- remove unrelated figures/content;
- use plain/transparent background;
- preserve full extremities;
- avoid dramatic perspective;
- have reviewed cross-view consistency;
- preserve the selected proportion/attachment contract.

The technical source remains in Modeling References.
The clean conversion derivative receives a separate asset ID and Drive record.

---

# 7. DCC blockout handoff

When implementation/art-production tooling is authorized, the first DCC task is not sculpting detail.

It is:
`1.75 m base mannequin → normalized landmark check → proportion blockout → H02A silhouette comparison → H02B volume check → attachment guides → neutral rig-clearance check`.

The initial DCC blockout should explicitly carry the stable attachment vocabulary from the Hunter proportion/attachment contract.

Only after blockout passes:
- clothing layers;
- modular protection;
- hands/boots refinement;
- retopology/rig concerns;
- loadout modules.

This prevents high-detail work from hiding a wrong base proportion.

---

# 8. QA gates for H02A selection

Required before `SELECTED_REFERENCE`:
- correct Drive/asset ID;
- native-pixel review;
- body occupies sufficient image area;
- no severe limb/hand/foot artifact;
- front/side/back consistency acceptable;
- normalized body landmarks reasonably agree across views;
- harness/gear contradictions documented;
- attachment-side identity remains stable;
- scale reconciled to 1.75 m authority;
- generated text ignored;
- no strong final protagonist identity required for geometry interpretation;
- source suitable to guide DCC blockout.

Required before `CONVERSION_TEST_OK`:
- separate clean conversion derivative;
- multiview isolation;
- reconstruction preflight;
- no infographic clutter.

---

# 9. Why this is better for the game

This source-pack architecture improves more than art quality.

It reduces downstream risk in:
- collision proportions;
- first-person camera height/hand framing;
- equipment fit;
- NPC rig reuse;
- animation clearance;
- settlement door/stair scale;
- aerial silhouette readability;
- Android LOD generation;
- future armor modularity.

A wrong humanoid base would contaminate many systems, so it is cheaper to fix here.

---

# 10. Current gate

`H02_V001 = REVIEWED_WITH_ISSUES / REVISE`
`H02_V002 = REVIEWED_WITH_ISSUES / REVISE`
`TECHNICAL_SOURCE_PACK_STANDARD = RECORDED`
`HUNTER_PROPORTION_ATTACHMENT_CONTRACT = RECORDED`
`H02A_V003 = NEXT`
`H02B_V003 = AFTER H02A OR SAME CONTROLLED REVISION SET`
`H03_DETAILS = ONLY IF NEEDED AFTER H02A REVIEW`
`H04_EQUIPMENT_REVIEW = BLOCKED UNTIL NEUTRAL BASE SELECTED`
`HUNTER_CONVERSION_INPUT = NONE`

Next bounded action:
**generate H02A v003 only, with the hunter figures dominating the raster, no infographic content, and shared landmark/attachment consistency; then review it before generating H02B/H03.**
