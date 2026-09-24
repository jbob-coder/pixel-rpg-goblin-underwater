# Unnamed Hunt RPG — Model Creation and PNG Reference Pipeline

Status: SELECTED PRODUCTION WORKFLOW + REFERENCE-ASSET CONTRACT / NO 3D IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how game models should actually be designed and created, which PNG images are useful at each stage, which PNGs are only references, which PNGs can become runtime texture assets, and how generated visual references must be validated before they influence production.

This document is intentionally bounded to the **model creation/reference pipeline**. It does not create the final hunter, final monster, final settlement art pack, engine import settings, or production polygon/texture budgets.

It refines:
- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`;
- `DESIGN_QUALITY_GATES_AND_DEPENDENCY_MATRIX.md`;
- `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `FIRST_SETTLEMENT_BLUEPRINT.md`.

---

# 1. Primary quality fix — separate reference images from game-ready assets

A major production risk is treating every attractive PNG as if it were already a usable game asset.

The project now separates PNGs into two classes:

## A. Reference PNG
Used to communicate design intent.

Examples:
- concept sheet;
- turnaround;
- silhouette sheet;
- anatomy map;
- damage-state sheet;
- material/palette reference;
- building modularity sheet;
- scale comparison.

Reference PNGs are **not automatically imported as final textures**.

They guide modeling, topology, rigging, materials and validation.

## B. Runtime texture PNG
Created specifically for UV-mapped game assets and validated for the selected engine.

Examples:
- base-color/albedo map;
- normal map;
- roughness/metallic/AO maps or a packed mask texture;
- emissive mask;
- wound/damage mask;
- decal/atlas texture;
- billboard/impostor texture where deliberately used.

Runtime texture PNGs require proper UV layout, color-space/channel rules, compression testing and device profiling.

**Generated concept art must never silently become a final runtime texture merely because the file extension is PNG.**

---

# 2. Model creation pipeline

Preferred sequence for a new important model:

`GAMEPLAY PURPOSE`
→ `SCALE + SILHOUETTE`
→ `REFERENCE PNG PACK`
→ `GRAYBOX / BLOCKOUT`
→ `GAMEPLAY ANATOMY / FUNCTION CHECK`
→ `LOW/MID DETAIL MODEL`
→ `RIG / DEFORMATION PROOF`
→ `UV / MATERIAL PLAN`
→ `TEXTURE BAKE / PAINT`
→ `DAMAGE / MODULAR STATES`
→ `LOD + COLLISION PROXIES`
→ `AERIAL READABILITY CHECK`
→ `FIRST-PERSON CHECK`
→ `ANDROID PERFORMANCE CHECK`
→ `PRODUCTION APPROVAL`

Do not start by sculpting micro-detail.

The first questions are always:
- What does this model do in gameplay?
- What must the player recognize from above?
- What must remain readable up close?
- Which parts can break/sever/change?
- Which pieces are modular?
- What is allowed to degrade at distance?

---

# 3. PNG Pack 01 — Orthographic Turnaround

This is the most important first PNG for a character or monster model.

Recommended layout:
- front;
- left or right side;
- back;
- 3/4 front;
- optional 3/4 rear;
- consistent neutral pose;
- consistent apparent scale;
- flat/neutral lighting;
- minimal perspective distortion;
- plain background;
- visible scale marker.

For humans, include a meter reference and body-height line.

For monsters, include hunter/human silhouette for scale.

## Why it exists

It helps establish:
- proportions;
- body mass;
- equipment placement;
- appendage length;
- silhouette consistency;
- asymmetry decisions;
- modeling blockout.

## Limitation

A generated turnaround is a **design reference**, not guaranteed exact orthographic geometry. The 3D modeler must reconcile inconsistencies between views rather than blindly tracing impossible forms.

---

# 4. PNG Pack 02 — Silhouette and Distance Readability Sheet

Show the same asset at multiple viewing sizes/distances.

Recommended panels:
- close/hero silhouette;
- normal exploration silhouette;
- aerial gameplay silhouette;
- very small/distant silhouette;
- dark-background and light-background checks;
- optional cluttered-environment check.

For the hunter, verify:
- head/shoulders;
- weapon family;
- legs/boots;
- loadout silhouette.

For a monster, verify:
- primary body mass;
- head orientation;
- major limbs;
- horn/tail/wing/plate identity;
- readable damaged/severable structures.

This PNG is required before spending time on micro-detail.

---

# 5. PNG Pack 03 — Anatomy / Functional Region Sheet

Required for major monsters.

Use a clean side/3/4/front view with gameplay regions color-coded and labeled by stable design IDs.

Example labels:
- `HEAD`;
- `HORN_L`;
- `HORN_R`;
- `FORELEG_L`;
- `FORELEG_R`;
- `HINDLEG_L`;
- `HINDLEG_R`;
- `TAIL_BASE`;
- `TAIL_TIP`;
- `PLATE_GROUP_A`;
- `CORE_CAVITY` only if direct core targeting is later approved.

This sheet is not the game hitbox itself.

It is a bridge between:
- design anatomy;
- model topology;
- rig bones;
- break/sever boundaries;
- eventual dedicated hit regions;
- damage-state art.

Quality rule:
**if a body region matters mechanically, the reference/model must make it visually understandable.**

---

# 6. PNG Pack 04 — Damage and Mutation State Sheet

Required before final monster production expands.

Recommended state examples:
- intact;
- wounded;
- broken structure;
- severed structure;
- destroyed structure;
- one mutation expression;
- berserk expression while preserving existing injuries.

Purpose:
- prove that damage remains readable;
- avoid requiring a complete replacement model for each state;
- plan mesh swaps, sever caps, wound masks and material parameters;
- prevent mutation/berserk visuals from hiding anatomy.

Do not approve a damage state that only works by covering the monster in glowing VFX.

---

# 7. PNG Pack 05 — Material and Color Reference Sheet

Reference only at first.

Show large, controlled material/color groups such as:
- skin/hide;
- scales/plate;
- bone/horn;
- crystal influence;
- cloth/leather;
- iron/steel;
- wood/stone;
- dirt/mud/wetness.

The sheet should answer:
- which materials are lighter/darker;
- which surfaces are rough/smooth;
- where color contrast helps anatomy readability;
- where emissive is permitted;
- which colors belong to mutations/elements;
- what must remain visually restrained.

Do not use rarity-color neon as the main material language.

---

# 8. PNG Pack 06 — Modular Construction Sheet

Important for humans/equipment/buildings.

## Hunter/NPC version
Show separable visual components:
- base body;
- head/hair;
- torso/coat;
- shoulder piece;
- gloves/arms;
- belt/waist;
- legs;
- boots;
- weapon;
- back/tool slot.

This helps prove combinations do not clip badly and still preserve silhouette.

## Building version
Show reusable pieces at a common scale:
- wall;
- corner;
- door;
- window;
- roof sections;
- beam/post;
- foundation;
- stair;
- balcony;
- awning;
- chimney;
- fence;
- gate/tower pieces.

The PNG communicates kit logic; the actual geometry remains modular 3D assets.

---

# 9. PNG Pack 07 — Scale Comparison Sheet

Required before finalizing major model proportions.

Useful lineup:
- adult hunter;
- civilian/service NPC;
- door;
- small building facade;
- large monster;
- major prop/cover object.

Use the selected rule:
**1 world unit = 1 meter.**

The purpose is to catch errors such as:
- a monster that looks large in concept art but is physically tiny in game;
- giant doors caused by aerial-camera readability problems;
- weapons too large to animate believably;
- building entrances inconsistent with character scale.

---

# 10. Runtime texture PNGs

Once a real UV-mapped model exists, runtime textures can be created.

Preferred conceptual set:

## Base Color / Albedo
- color information;
- no baked dramatic directional lighting;
- avoid painted highlights that fight real lighting.

## Normal
- surface direction/detail;
- must follow engine tangent/normal convention once selected;
- never create by simply recoloring a concept image.

## Roughness
Controls surface roughness.

## Metallic
Used only where physically/materially appropriate.

## Ambient Occlusion
Can be separate or packed depending final engine pipeline.

## Packed ORM-style Mask
Possible later optimization:
- one channel AO;
- one channel roughness;
- one channel metallic;
- exact channel convention locked only after engine selection.

## Emissive
For controlled crystal/elemental energy, not constant whole-body glow.

## Damage/Wound Masks
Can drive:
- blood/wound overlays;
- cracks;
- burn/frost effects;
- crystal strain;
- broken-state material changes.

Exact texture formats/resolutions/compression remain OPEN until engine/device profiling.

---

# 11. What image generation can create reliably for this project

Image generation is useful for:
- concept direction;
- turnaround inspiration;
- silhouette studies;
- anatomy-region visual planning;
- mutation/damage exploration;
- clothing/equipment variations;
- building/module concept sheets;
- material/color boards;
- scale-composition ideas.

These images are **reference assets**.

They can substantially accelerate planning and give the future modeler a concrete target.

---

# 12. What image generation should NOT be trusted to create as final technical truth

Do not assume generated images provide:
- mathematically exact orthographic views;
- perfect matching geometry between front/side/back;
- production UV maps;
- physically correct normal maps;
- exact roughness/metallic maps;
- guaranteed seamless tile textures;
- correct skeleton topology;
- exact bone placement;
- valid collision geometry;
- exact break/sever topology;
- engine-ready LOD meshes;
- legally clean third-party derivative assets if prompts intentionally imitate protected designs.

Those require actual model/content tools and verification.

---

# 13. How a generated PNG is applied to the model pipeline

A generated PNG can be **applied as a reference**, not automatically as the final 3D surface.

Recommended workflow:

1. generate/reference PNG;
2. save with stable reference ID;
3. label it `REFERENCE_ONLY` unless it was created specifically as a runtime texture;
4. extract approved proportion/silhouette/material decisions;
5. create 3D blockout using meter scale;
6. compare blockout against reference in front/side/3/4 views;
7. resolve impossible/inconsistent reference details;
8. bind major gameplay anatomy;
9. test aerial readability;
10. test first-person readability;
11. only then proceed to topology/rig/UV/material production.

The model is authoritative for geometry after approval; the concept PNG remains provenance/reference.

---

# 14. Temporary direct PNG use in-game

Some PNGs may intentionally appear directly in-game, but only for appropriate presentation roles.

Possible examples:
- UI icons;
- bestiary/anatomy illustrations;
- map illustrations;
- signs/emblems;
- decals;
- foliage billboards;
- distant impostors;
- temporary prototype cards/placeholders.

A hunter/monster concept-art PNG should not replace the intended 3D model for normal production gameplay unless the project deliberately changes art direction.

---

# 15. File-role naming convention

Recommended reference naming before engine-specific asset structure exists:

`REF_<ASSET_ID>_<ROLE>_v###.png`

Examples:
- `REF_HUNTER_BASE_TURNAROUND_v001.png`
- `REF_HUNTER_BASE_SILHOUETTE_v001.png`
- `REF_MONSTER_01_ANATOMY_v001.png`
- `REF_MONSTER_01_DAMAGE_STATES_v001.png`
- `REF_SETTLEMENT_KIT_MODULES_v001.png`

Runtime textures later use a different convention tied to the actual asset/material ID so references cannot be confused with production textures.

---

# 16. Reference approval states

Use:
- `DRAFT` — exploratory image;
- `SELECTED_REFERENCE` — approved direction for blockout;
- `REVISED_REFERENCE` — updated after blockout problems;
- `SUPERSEDED` — no longer current;
- `RUNTIME_TEXTURE_CANDIDATE` — specifically designed for texture use but not yet verified;
- `RUNTIME_VERIFIED` — imported/tested successfully after implementation begins.

A beautiful PNG is not automatically `SELECTED_REFERENCE`.

---

# 17. First bounded reference target

Do not create every PNG pack at once.

The first useful generated reference should be:

**`REF_HUNTER_BASE_TURNAROUND_v001.png`**

Why first:
- establishes human meter scale;
- establishes proportion/stylization language;
- establishes shoulder/hand/boot readability;
- establishes practical frontier clothing language;
- becomes a scale anchor for doors/buildings/monster comparison;
- can later support the shared humanoid rig and NPC modularity system.

This first reference should show:
- adult hunter;
- practical neutral base clothing rather than final legendary armor;
- no protected franchise design language;
- front, side, back and 3/4 views;
- neutral A-pose or relaxed modeling pose;
- simple weapon-free silhouette for body proportion clarity;
- meter scale marker;
- grounded stylized 3D / illustrated-realism appearance;
- readable boots/hands/shoulders;
- neutral lighting/background.

It is a **reference-only PNG**.

---

# 18. Second reference target after the hunter base is reviewed

Do not generate it automatically in the same bounded piece.

Recommended next reference:

**`REF_MONSTER_01_MASS_ANATOMY_v001.png`**

It should establish:
- monster primary mass;
- human scale comparison;
- 6–8 gameplay anatomy regions;
- one breakable structure;
- one severable structure;
- one biologically integrated crystal/mutation feature.

Only after its functional anatomy is accepted should we create damage-state and material sheets.

---

# 19. Quality gates before a model enters production

A model reference package should eventually pass:

## Design
- gameplay role clear;
- silhouette approved;
- scale approved;
- anatomy/function approved;
- material direction approved.

## Modeling
- blockout matches gameplay scale;
- three-distance readability works;
- no impossible concept geometry retained blindly;
- modular/breakable parts separated where needed.

## Technical
- pivots/origins defined;
- rig requirements defined;
- collision proxy plan defined;
- LOD plan defined;
- UV/material plan defined;
- runtime texture needs defined.

## Gameplay
- anatomy regions map to domain IDs;
- break/sever presentation supported;
- mutation/damage states preserve identity;
- equipment/modular pieces do not hide critical information.

## Performance
- final budgets determined by target-device profiling;
- unnecessary materials/bones/geometry removed before critical silhouette/anatomy;
- lower LODs preserve important gameplay readability.

---

# 20. Admin / Creator support later

When implementation begins, development tools should eventually support:
- model ID and reference-image provenance display;
- current LOD display/force override;
- anatomy hit-region overlay;
- skeleton/bone debug view where useful;
- break/sever attachment state;
- material/mask preview;
- collision proxy display;
- approximate draw/material/bone cost;
- aerial and first-person preview cameras;
- automatic screenshot capture at standard reference distances.

This lets model quality be measured repeatedly instead of approved once by eye.

---

# 21. Current decisions vs open details

## Current selected workflow
- reference PNGs and runtime texture PNGs are distinct asset classes;
- generated art is reference-only by default;
- important models begin with gameplay purpose, scale and silhouette before detail;
- orthographic turnaround is the first reference pack;
- silhouette/distance sheet follows;
- monsters additionally require anatomy and damage-state sheets;
- runtime PBR textures are created only after UV/model structure exists;
- references use stable IDs/versioning/approval state;
- first generated reference target is the base hunter turnaround;
- one bounded reference/model package is reviewed before generating the next.

## Still open
- engine/DCC application;
- exact texture resolution;
- exact texture packing/channel convention;
- exact triangle/bone/material budgets;
- final hunter face/sex/body variation system;
- final clothing/equipment slot count;
- first monster final body plan;
- asset source-control folder structure after implementation begins;
- exact image dimensions for final production reference sheets.

---

# 22. Current bounded next step

Create and review only:

`REF_HUNTER_BASE_TURNAROUND_v001.png`

Then evaluate:
- proportions;
- style;
- readability;
- practical clothing;
- whether the body is a suitable reusable humanoid base;
- whether the reference needs revision before any monster reference work.

Do not generate the entire art bible in one pass.
