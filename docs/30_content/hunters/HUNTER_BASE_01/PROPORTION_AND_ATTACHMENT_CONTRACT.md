# HUNTER_BASE_01 — Proportion and Attachment Contract

Status: ACTIVE PROTOTYPE GEOMETRY/ART CONTRACT / NO DCC MODEL YET
Last reconciled: 2026-09-02

## Purpose

Give every future Hunter Base 01 representation the same measurable scaffold before modeling begins.

This contract exists because front/side/back images can look individually convincing while describing different bodies, different gear placement or different camera assumptions.

Primary quality fix:

**all Hunter Base 01 visual/modeling work must share one normalized body reference and one attachment vocabulary.**

This improves:
- technical turnaround consistency;
- DCC blockout;
- modular armor/equipment fit;
- humanoid rig reuse;
- collision/capsule planning;
- first-person camera/hand framing;
- settlement door/stair scale checks;
- aerial silhouette checks;
- animation clearance;
- later LOD consistency.

This document does not create gameplay stats and does not lock the final protagonist identity.

---

# 1. Authority and status language

LOCKED/CURRENT for the prototype base:
- world height target: **1.75 m**;
- broadly realistic adult humanoid proportions;
- practical frontier-human body language;
- neutral production base, not reinforced/heavy loadout;
- same body scale across settlement, wilderness and first-person transitions;
- equipment is modular and cannot silently change body proportions.

PROTOTYPE TARGETS in this document:
- normalized landmark ratios;
- rough world-space landmark heights;
- attachment naming/placement bands;
- clearance rules.

These targets may be adjusted after a real DCC mannequin, rig and camera/device test.

OPEN:
- final protagonist sex/gender/face/age/name;
- exact muscularity/body-shape variant system;
- exact skeleton/bone count;
- final first-person arm implementation;
- exact collider dimensions;
- exact equipment-slot gameplay schema.

---

# 2. Coordinate convention for references

Use a simple engine-neutral local reference frame for documentation and DCC handoff:

- `+Y` = up;
- `+Z` = character forward;
- `+X` = character right;
- local origin = ground point centered between the feet in neutral stance;
- nominal body height `H = 1.75 m` from ground plane to top of head/hair-neutral skull envelope.

Generated images do not define axes. The DCC scene/model later must deliberately adopt/match the selected engine export convention.

All normalized vertical landmarks use:
`normalized_y = landmark_height / H`.

---

# 3. Prototype vertical landmark scaffold

These are **prototype alignment anchors**, not medical/anatomical claims.

They exist to stop image/model drift.

| Landmark | Normalized Y | Approx. height at H=1.75 m | Use |
|---|---:|---:|---|
| Ground/sole contact | 0.000 | 0.000 m | world origin |
| Ankle/boot articulation band | 0.050 | 0.088 m | boot/rig clearance |
| Knee center band | 0.285 | 0.499 m | leg proportion/armor |
| Upper-thigh/groin transition | 0.485 | 0.849 m | trouser/coat clearance |
| Hip joint/pelvis center band | 0.530 | 0.928 m | rig/body mass |
| Waist/belt center | 0.570 | 0.998 m | belt/pouch anchor |
| Lower rib/sternum utility band | 0.665 | 1.164 m | harness/chest attachment |
| Elbow center in neutral stance | 0.625 | 1.094 m | sleeve/bracer proportion |
| Wrist/hand-root band | 0.475 | 0.831 m | arm length check |
| Shoulder joint band | 0.825 | 1.444 m | upper-body width/armor |
| Base of neck/collar band | 0.855 | 1.496 m | collar/scarf |
| Chin/jaw band | 0.885 | 1.549 m | head proportion check |
| Eye-line band | 0.935 | 1.636 m | camera/reference only |
| Skull/top reference | 1.000 | 1.750 m | height authority |

Important:
- generated art may visually shift hair above the skull envelope; hair does not redefine body height;
- boots may add visible sole thickness, but the ground-contact origin remains fixed;
- equipment may extend above/below these bands without changing the underlying body landmarks;
- if a real DCC mannequin proves one ratio is awkward for rigging/animation, update this contract deliberately rather than silently changing each asset.

---

# 4. Head-count/proportion guardrail

Current Hunter Base direction remains roughly **7–7.5 heads tall**.

This is an art guardrail, not the primary measurement system.

The 1.75 m world height and normalized landmarks are more useful for technical cross-view comparison.

Do not solve aerial readability by:
- enlarging the head disproportionately;
- making the hands/boots cartoon-scale;
- widening shoulders beyond believable human construction;
- increasing total body height.

Small silhouette emphasis is allowed through:
- boot shape;
- shoulder protection;
- harness/pack mass;
- clothing value contrast;
- animation posture.

---

# 5. Cross-view invariant checklist

H02A front/left/back/right sources must agree on the same underlying construction.

The following must remain invariant unless explicitly marked asymmetric:

## Body
- top-of-head height;
- eye-line height;
- shoulder height;
- shoulder breadth;
- ribcage depth;
- waist height;
- pelvis/hip height and breadth;
- elbow height;
- wrist/hand-root height;
- hand scale;
- knee height;
- boot height and sole thickness;
- arm/leg length.

## Clothing
- collar height;
- tunic/coat lower-edge length;
- number of lower garment panels;
- trouser break at boot;
- glove length;
- boot shaft height.

## Equipment
- harness path;
- belt height;
- pouch count;
- pouch side;
- bracer length;
- shoulder-protection side;
- shin-protection height;
- back attachment location.

If an intentionally asymmetric feature exists, record it once and preserve it in every view.

---

# 6. Neutral stance contract

H02A technical-source stance:
- feet on same ground plane;
- feet approximately parallel with only slight natural toe-out;
- weight visually centered, not contrapposto;
- knees neutral, not crouched;
- pelvis neutral;
- spine upright but not military-rigid;
- shoulders level;
- arms slightly separated from torso to expose armpit/harness/clothing boundaries;
- elbows only mildly flexed;
- palms/hands visible enough to establish scale;
- head level and looking forward in front view;
- no weapon;
- no large bag/cape hiding silhouette.

This stance exists for modeling/reference only. It is not the in-game idle animation.

---

# 7. Attachment vocabulary

These names are art/technical anchors, not final gameplay equipment slots.

Use stable names so generated references, DCC files and later definitions can communicate without ambiguous descriptions.

## Torso/back
- `ATT_CHEST_CENTER`
- `ATT_CHEST_L`
- `ATT_CHEST_R`
- `ATT_SHOULDER_L`
- `ATT_SHOULDER_R`
- `ATT_BACK_UPPER`
- `ATT_BACK_CENTER`
- `ATT_BACK_LOWER`

## Arms
- `ATT_FOREARM_L`
- `ATT_FOREARM_R`
- `ATT_WRIST_L`
- `ATT_WRIST_R`

## Waist
- `ATT_BELT_FRONT`
- `ATT_BELT_L`
- `ATT_BELT_R`
- `ATT_BELT_REAR`

## Legs
- `ATT_THIGH_L`
- `ATT_THIGH_R`
- `ATT_SHIN_L`
- `ATT_SHIN_R`

## Optional carry anchors for later design
- `ATT_HIP_CARRY_L`
- `ATT_HIP_CARRY_R`
- `ATT_BACK_CARRY_A`
- `ATT_BACK_CARRY_B`

Do not assign a weapon type to these carry anchors yet.

---

# 8. Attachment placement bands

Until a DCC skeleton exists, use bands instead of fake exact XYZ transforms.

### Shoulder anchors
Near the shoulder-joint band (~0.825H), offset laterally from torso.
Must not interfere with:
- arm elevation;
- first-person shoulder camera framing;
- neck rotation.

### Forearm anchors
Between elbow and wrist bands.
Must preserve:
- wrist flexion;
- weapon/tool grip clearance;
- glove visibility.

### Belt anchors
Centered around ~0.57H.
Pouches/tools must not:
- clip thighs during walking/crouch;
- block hand resting space;
- create excessive dangling-physics cost.

### Back anchors
Between lower-rib and shoulder bands.
Default pack/tool-roll mass should stay compact enough to preserve:
- aerial torso silhouette;
- first-person transition camera;
- doorway clearance;
- future carried-weapon silhouette.

### Thigh/shin anchors
Must preserve knee flexion and avoid bridging a joint with rigid geometry unless the item is deliberately articulated.

---

# 9. Equipment-fit law

Equipment changes visual mass and gameplay-defined burden/protection, but does not scale the base skeleton.

Forbidden shortcuts:
- making the torso wider by changing body geometry per armor set instead of fitting the armor;
- changing hand/foot scale to accommodate equipment;
- changing leg length between light/heavy loadouts;
- moving joints to fit generated clothing art;
- changing camera height because one helmet/hood is taller.

Preferred approach:
`stable body/rig → stable attachment anchors → modular clothing/protection shells → loadout-specific silhouette`.

---

# 10. Camera/collision implications

The future technical implementation should derive from the model/rig, not generated image coordinates.

However this contract establishes expectations:

## Exploration camera
- player world scale remains human-scale;
- aerial readability comes from silhouette/material/animation rather than enlarging the collision body.

## First-person
- eye/camera reference will likely begin near the eye-line band but must be tuned against actual head/rig/camera comfort;
- visible first-person hands may use a separate presentation rig/layer later;
- the world-body height remains 1.75 m regardless.

## Collision
- one simplified humanoid collision/capsule family is preferred over per-outfit collision;
- bulky equipment may need secondary interaction/visual handling, not a completely new locomotion body;
- exact collider radius/height remains OPEN until engine probe.

---

# 11. Settlement/environment scale implications

This human reference is the anchor for built-world scale.

Use it to validate:
- door clearances;
- stair riser/tread feel;
- counters/workbenches;
- railings;
- beds/seating;
- alley widths;
- gate proportions;
- interior camera clearance.

Do not scale buildings around whichever generated character image happens to look best.

Authoritative world-scale convention remains:
`1 world unit = 1 meter`.

---

# 12. Rig/animation implications

Future rigging must preserve the body scaffold while supporting:
- walk/run;
- crouch;
- brace/guard;
- dodge/reaction;
- climbing/terrain adaptation if implemented;
- harvesting interactions;
- tool/weapon handling;
- injury/status presentation.

Before high-detail armor is accepted, a neutral blockout should prove:
- shoulder elevation clearance;
- elbow/knee flexion;
- crouch without pouch/coat collision becoming severe;
- first-person hand reach;
- back/hip carry items do not catastrophically intersect limbs.

---

# 13. H02A v003 generation contract

The next generated technical source must obey:

- H02A only;
- front / left / back / right if practical;
- no 3/4 in the same source if it reduces body pixel occupancy too much;
- figures occupy approximately 75–90% of raster height;
- identical neutral stance;
- same base clothing and exact attachment layout in every view;
- no weapon;
- no material chart;
- no monster comparison;
- no progression/loadout examples;
- no checksum/file-info block;
- no fake `APPROVED` or conversion labels;
- plain neutral or transparent background;
- minimal external FRONT/LEFT/BACK/RIGHT labels only;
- use this document's landmark/attachment contract as the consistency target;
- final protagonist identity remains intentionally neutral.

If one image-generation system cannot maintain identical multiview construction, do not keep regenerating blindly.
Instead:
1. select the strongest consistent source;
2. use a controlled DCC blockout to establish geometry when authorized;
3. derive later orthographic renders from that same 3D blockout.

That DCC-derived route is ultimately more reliable than expecting independent generative views to become exact geometry.

---

# 14. Current gate

`HUNTER_WORLD_HEIGHT = 1.75_M_PROTOTYPE_TARGET`
`NORMALIZED_BODY_ANCHORS = RECORDED`
`ATTACHMENT_VOCABULARY = RECORDED`
`ATTACHMENT_EXACT_TRANSFORMS = OPEN_UNTIL_DCC_RIG`
`COLLIDER_DIMENSIONS = OPEN_UNTIL_ENGINE_PROBE`
`H02A_V003_GENERATION_CONTRACT = READY`
`H02B_V003 = BLOCKED_UNTIL_H02A_REVIEW`
`H03_DETAILS = BLOCKED_UNTIL_H02A_REVIEW_SHOWS_NEED`
`H04_EQUIPMENT_REVIEW = BLOCKED_UNTIL_NEUTRAL_BASE_SELECTED`

Next bounded action:
**generate H02A v003 only, then review it against this contract and the existing asset QA gates.**
