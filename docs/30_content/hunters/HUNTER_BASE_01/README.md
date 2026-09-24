# HUNTER_BASE_01 — Prototype Hunter Visual/Model Packet

Status: SELECTED PROTOTYPE BODY/GEAR LANGUAGE / NOT FINAL STORY PROTAGONIST
Last reconciled: 2026-09-02

## Purpose

Provide a stable humanoid target for model/reference generation, camera-scale tests, modular-equipment tests and later rigging without prematurely locking the player's final identity, face, biography or weapon family.

Technical ID:
`hunter_base_01`

This is a **production base**, not necessarily the final named protagonist.

## Owning technical references

Hunter-specific geometry/art consistency:
- `PROPORTION_AND_ATTACHMENT_CONTRACT.md`

Art/source-pack structure:
- `docs/40_art/asset_pipeline/HUNTER_TECHNICAL_SOURCE_PACK_STANDARD.md`

The proportion/attachment contract owns the current 1.75 m normalized landmark scaffold and attachment vocabulary. Generated images do not override those anchors.

## Selected visual direction

The hunter should read as:

**a practical frontier professional who survives by preparation, field knowledge and equipment rather than oversized fantasy armor.**

Core appearance:
- adult human proportions;
- grounded athletic build, not bodybuilder exaggeration;
- approximately 7–7.5 heads tall;
- prototype world height target: **1.75 m**;
- shoulders/hands/boots may be mildly emphasized for aerial readability;
- posture alert and balanced rather than heroic chest-out pose;
- clothing uses layered cloth, leather and limited protective plates;
- silhouette communicates field tools and preparedness.

The face/ethnicity/hair identity remains OPEN so the production base can be reused/refined before narrative protagonist decisions.

## Base clothing architecture

### Underlayer
- fitted durable cloth shirt/tunic;
- reinforced trousers;
- breathable joint areas;
- muted earth/charcoal palette.

### Torso/harness
- leather or similarly durable cross-body harness;
- compact chest/side utility attachments;
- no giant fantasy breastplate by default;
- optional small sternum/rib protection pieces.

### Shoulders/arms
- one slightly stronger shoulder silhouette allowed for aerial readability;
- forearm/bracer protection;
- gloves designed for weapon/tool grip;
- equipment remains modular.

### Waist
- belt with bounded utility pouches;
- harvest knife/tool sheath;
- field notes/map pouch or equivalent hunter-record tool;
- no excessive dangling objects that create animation/physics noise.

### Legs/boots
- reinforced knees/shins where useful;
- sturdy mid/high hunting boots;
- sole design suitable for mud/rock terrain;
- boots remain readable from aerial camera.

### Back
- optional compact field pack/tool roll;
- no permanently enormous backpack obscuring first-person transition or weapon silhouette;
- larger expedition storage is a loadout variant, not the default body.

## Material language

Preferred broad groups:
- matte woven cloth;
- worn leather;
- restrained brushed/dulled metal;
- wood/bone only where equipment requires it;
- crystal accents are not assumed on ordinary starting gear until human crystal technology is decided.

Avoid:
- polished full-body fantasy plate;
- glowing neon lines;
- giant pauldrons;
- modern military tactical styling;
- skin-tight superhero silhouettes;
- decorative parts with no field purpose.

## Color/value hierarchy

Prototype direction:
- dark/medium neutral underlayer;
- warmer brown/earth utility leather;
- controlled lighter accents on straps/edges;
- small high-contrast areas at hands, shoulders and equipment attachment points for readability.

Exact colors remain art-tunable.

## Modular silhouette variants for H04 sheet

These are **art/loadout silhouette tests**, not final gameplay equipment-slot decisions.

### Variant A — Light Field / Tracking
- minimal torso protection;
- lighter shoulder profile;
- small hip/field pouches;
- compact back roll;
- open silhouette around legs/arms.

Visual promise:
`mobile / observant / lightly burdened`.

### Variant B — Balanced Hunt
- moderate torso/shoulder/forearm protection;
- normal utility belt;
- compact pack;
- strongest default silhouette candidate.

Visual promise:
`prepared / versatile / professional`.

### Variant C — Reinforced / Dangerous-Hunt
- heavier shoulder/forearm/shin protection;
- stronger torso reinforcement;
- more robust field pack/tool attachments;
- still human-scaled and mobile.

Visual promise:
`protected / burdened / prepared for close danger`.

No final weapon family should appear as authoritative in this sheet. Neutral tool/weapon attachment positions may be shown, but exact sword/hammer/ranged weapon design waits for the weapon packet.

## Scale/readability requirements

Current technical turnaround work is split into task-specific sources rather than one overloaded infographic.

H02A technical source should show:
- front;
- left side;
- back;
- right side where practical;
- identical neutral modeling stance;
- same body/gear construction in every view;
- high subject occupancy;
- simple neutral/transparent background;
- no weapon or unrelated panels.

H02B later provides a separate 3/4 volume confirmation.

Scale/proportion authority comes from:
- 1.75 m prototype world height;
- normalized landmark scaffold in `PROPORTION_AND_ATTACHMENT_CONTRACT.md`.

At aerial distance, player readability should come from:
- shoulder/torso silhouette;
- boots/leg spacing;
- utility/pack silhouette;
- animation/posture;
- contrast against terrain.

Do not enlarge the actual human scale to solve camera readability.

## Rig/body standard intent

This base should later support:
- shared humanoid skeleton convention;
- modular clothing/armor attachment using the stable attachment vocabulary in `PROPORTION_AND_ATTACHMENT_CONTRACT.md`;
- swappable head/hair where final identity requires it;
- first-person hand/weapon presentation as a separate view/presentation layer where needed;
- locomotion over settlement and wilderness terrain;
- crouch/brace/guard/dodge/reaction animations;
- injury/status presentation.

Exact skeleton/bone count remains engine/DCC dependent.

## Relationship to stats

Visual body type does not directly set Might/Finesse/Agility/etc.

Do not infer gameplay attributes from how muscular or armored the model looks.

Equipment presentation can communicate burden/protection, while authoritative effects come from equipment definitions.

## Current selected vs open

SELECTED:
- 1.75 m prototype human scale target;
- practical layered frontier hunter;
- broadly realistic proportions;
- mild readability exaggeration only;
- modular equipment construction;
- stable prototype proportion/attachment vocabulary;
- three prototype loadout silhouettes without locking weapon family;
- restrained material/color language.

OPEN:
- final protagonist sex/gender/face/age/name;
- final hair/headgear;
- exact weapon family;
- final equipment slots;
- exact armor progression;
- human crystal technology/accessories;
- exact DCC skeleton/attachment transforms;
- exact collision dimensions.

## Current reference-production state

- H02 v001: reviewed with issues / revise / discussion only.
- H02 v002: reviewed with issues / revise / discussion only.
- H02A v003: next technical source, governed by `PROPORTION_AND_ATTACHMENT_CONTRACT.md` and `HUNTER_TECHNICAL_SOURCE_PACK_STANDARD.md`.
- H02B v003: blocked until H02A review.
- H03 details: conditional after H02A review.
- H04 equipment silhouettes: generated v001 but review/promotion blocked until the neutral base is selected.

## Drive

Modeling references:
`01_Modeling_References/Hunter`
ID: `1XM-kcLfxD3Af-HAPRu4zlO691RgDJLlE`

Conversion inputs:
`03_3D_Conversion_Inputs/Hunter`
ID: `1fbVPHHyVmGuqAxaKsUXSKAYdYk-BeJy4`

Only reviewed clean turnaround derivatives are copied into the conversion lane.
