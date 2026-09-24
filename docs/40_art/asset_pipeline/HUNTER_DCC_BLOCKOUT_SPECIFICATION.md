# Hunter Base 01 — DCC Blockout Specification

Status: DOCUMENTATION READY / IMPLEMENTATION NOT AUTHORIZED
Last reconciled: 2026-09-02

## Purpose

Define the smallest controlled 3D blockout needed to replace unreliable independent generated multiview imagery with one geometric source of truth.

This document does **not** authorize creation of the DCC model. It records what must be done when art-production implementation is explicitly authorized.

Primary quality fix:

**one neutral 3D mannequin should become the geometric source for future orthographic views, attachment placement, rig-clearance checks and equipment fitting.**

## 1. Inputs

The blockout must read and obey:
- `docs/30_content/hunters/HUNTER_BASE_01/README.md`;
- `PROPORTION_AND_ATTACHMENT_CONTRACT.md`;
- `HUNTER_TECHNICAL_SOURCE_PACK_STANDARD.md`;
- `ASSET_QA_GATES.md`;
- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`.

Generated Hunter H02 v001/v002/v003 sheets are discussion references only and cannot override recorded numeric/proportion contracts.

## 2. World and scene scale

Authoritative convention:
`1 world unit = 1 meter`.

Hunter Base 01 prototype body height:
`1.75 m` from ground plane to top-of-skull reference.

DCC scene must include:
- metric units or equivalent exact unit conversion;
- ground plane at Y=0 in the project-neutral convention;
- one visible 1 m reference object/grid;
- one 1.75 m vertical verification guide;
- no arbitrary export scaling hidden in object transforms.

Before export, object scale must be normalized according to the chosen DCC/engine pipeline.

## 3. Minimum mannequin geometry

The first blockout is deliberately simple.

Required masses:
- head/skull envelope;
- neck;
- ribcage/chest;
- abdomen/waist;
- pelvis;
- upper/lower arms;
- hands as simplified mitt/hand forms initially;
- upper/lower legs;
- feet/boot-envelope forms.

Do not sculpt:
- pores;
- facial identity;
- detailed fingers;
- stitching;
- decorative armor;
- hair strands;
- final boots;
- final pouches.

Goal:
prove proportions, silhouette, joint placement and equipment clearances first.

## 4. Prototype landmark checks

The mannequin should be checked against the normalized landmark scaffold in `PROPORTION_AND_ATTACHMENT_CONTRACT.md`.

At minimum verify:
- ground contact;
- ankle band;
- knee band;
- hip/pelvis band;
- waist/belt band;
- lower-rib/sternum band;
- elbow band;
- wrist/hand-root band;
- shoulder band;
- neck/collar band;
- chin;
- eye line;
- skull-top reference.

These are prototype anchors and may be revised only by an explicit documented decision after blockout/animation/camera testing.

## 5. Neutral stance

The blockout source pose must use the existing neutral stance contract:
- feet on same ground plane;
- slight natural toe-out only;
- centered weight;
- neutral knees and pelvis;
- upright neutral spine;
- level shoulders;
- arms slightly away from torso;
- elbows mildly flexed or neutral enough for rigging;
- hands visible;
- head level;
- no weapon;
- no cape/large pack.

This is not an in-game idle animation.

## 6. Skeleton/rig placeholder

Exact final bone count remains open.

For the blockout test, use only enough joints to validate:
- root/pelvis;
- spine/chest;
- neck/head;
- clavicle/shoulder;
- upper/lower arm;
- wrist/hand;
- upper/lower leg;
- ankle/foot.

Optional twist/helper bones wait until a real deformation need appears.

The blockout should not lock the final animation rig.

## 7. Attachment guides

Create non-rendering empties/locators/guides using the stable vocabulary:
- `ATT_CHEST_CENTER`;
- `ATT_CHEST_L/R`;
- `ATT_SHOULDER_L/R`;
- `ATT_BACK_UPPER/CENTER/LOWER`;
- `ATT_FOREARM_L/R`;
- `ATT_WRIST_L/R`;
- `ATT_BELT_FRONT/L/R/REAR`;
- `ATT_THIGH_L/R`;
- `ATT_SHIN_L/R`;
- provisional carry anchors only if needed for clearance testing.

At this stage these are guides, not final gameplay sockets.

## 8. Clearance test poses

Before clothing/armor detail is accepted, the blockout must pass a minimal pose set:

1. neutral stand;
2. full walking stride approximation;
3. deep crouch;
4. arms-forward interaction/harvest reach;
5. shoulder raise / overhead reach;
6. guard/brace posture;
7. dodge-side lean/reposition pose;
8. first-person hand-reach approximation if that presentation layer is pursued.

Check for:
- shoulder collision;
- elbow/pouch collision;
- knee/coat conflict;
- thigh/belt clipping;
- boot/shin interference;
- back equipment intersection;
- neck/shoulder armor interference.

## 9. Clothing blockout order

Only after the mannequin passes proportion checks:

1. underlayer envelope;
2. trousers/boot envelope;
3. simple tunic/lower panels;
4. harness straps as simplified bands;
5. belt;
6. basic pouches;
7. limited shoulder/forearm/shin protective shells;
8. compact back attachment if required.

Do not begin with the reinforced H04 loadout.

## 10. Camera/reference outputs

Once the same geometric model exists, generate controlled technical renders from it.

Required H02A replacement renders:
- front orthographic;
- left orthographic;
- back orthographic;
- right orthographic;
- identical camera scale and framing;
- neutral plain background;
- no perspective distortion;
- body occupies most of raster height.

H02B later:
- front 3/4 perspective or long-lens confirmation;
- optional rear 3/4;
- same exact model state.

These DCC-derived images can finally prove that multiple views describe the same geometry.

## 11. First-person implications

The blockout should expose an eye/camera reference derived from the recorded eye-line band, but exact game camera height remains an engine/runtime tuning decision.

Do not:
- move the whole body scale to fix camera comfort;
- treat hair/helmet height as camera height;
- assume world-body arms must be the final first-person arms.

A separate first-person presentation rig remains allowed later.

## 12. Collision implications

Do not author final collision in the art blockout.

But create measurement notes needed later for a simplified humanoid collider:
- standing total height;
- shoulder breadth;
- torso breadth/depth;
- approximate hip breadth;
- foot clearance;
- crouched envelope.

Exact capsule radius/height remains blocked until engine probe.

## 13. NPC reuse implications

Hunter Base 01 should be compatible with a shared humanoid production standard where practical.

The base should not contain story-specific geometry that prevents reuse for:
- service NPCs;
- guards/hunters;
- civilians with body/head/clothing variants.

Final NPC variation strategy remains separate.

## 14. Android/performance implications

The blockout itself is not the final performance mesh.

However it should avoid design decisions that inherently create unnecessary cost:
- excessive dangling pieces;
- dozens of rigid armor fragments;
- geometry only visible as sub-pixel detail;
- layered shells that create constant transparency/overdraw needs.

Final triangle/material/bone budgets wait for engine/device evidence.

## 15. Deliverables when authorized

Minimum DCC blockout package:
- source DCC file;
- neutral mannequin;
- simple clothing/harness shells;
- attachment guides;
- minimal test rig or joint scaffold;
- eight clearance-pose screenshots or equivalent pose review;
- front/left/back/right orthographic renders;
- 3/4 confirmation render only after ortho review;
- scale verification screenshot;
- blockout QA notes.

No final texture/sculpt is required at this gate.

## 16. Approval gates

`BLOCKOUT_PROPORTION_PASS` requires:
- 1.75 m scale correct;
- landmark scaffold acceptable;
- believable adult silhouette;
- no major cross-view contradiction because one geometry source is used.

`BLOCKOUT_CLEARANCE_PASS` requires:
- minimum pose set evaluated;
- no severe attachment/clothing obstruction;
- problems documented.

`ORTHO_SOURCE_PASS` requires:
- front/left/back/right generated from the same model;
- framing/scale consistent;
- enough raster occupancy/detail for modeling reference.

Only after these may H02A become a technical selected reference.

## 17. Stop conditions

Do not continue to detail if:
- height is wrong;
- limbs are visibly misproportioned;
- shoulder/hip joint placement causes major deformation failure;
- clothing cannot clear crouch/arm motion;
- attachment layout blocks locomotion/interactions;
- camera/body scale conflict is unresolved.

Return to blockout instead of hiding problems with textures or armor.

## 18. Current gate

`H02A_V003_GENERATED = YES`
`H02A_V003_DRIVE_VERIFIED = YES`
`H02A_V003_DECISION = REVISE_METHOD`
`REPEATED_AI_MULTIVIEW_REGENERATION = PAUSED`
`DCC_BLOCKOUT_SPECIFICATION = RECORDED`
`DCC_IMPLEMENTATION = NOT AUTHORIZED`
`SELECTED_HUNTER_TECHNICAL_REFERENCE = NONE`
`HUNTER_CONVERSION_INPUT = NONE`

Next bounded documentation action after reconciliation:
**define the Hunter/NPC shared humanoid variation boundaries only if needed, or return to another independent design packet while DCC implementation remains blocked. Do not generate another H02A with the same failed method.**