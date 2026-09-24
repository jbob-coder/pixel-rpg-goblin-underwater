# Unnamed Hunt RPG — Model Art Direction and Asset Standard

Status: SELECTED ART DIRECTION + PROTOTYPE ASSET TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how player characters, NPCs, monsters, buildings, props and terrain models should look and how they should be constructed so the same assets remain readable in angled aerial exploration, believable in walkable settlements, useful in first-person combat, and affordable on Android.

This guide refines:
- `VISUAL_WORLD_BEHAVIOR_BIBLE.md`;
- `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `DESIGN_QUALITY_GATES_AND_DEPENDENCY_MATRIX.md`.

It does not authorize asset production yet.

---

# 1. Selected visual model direction

The preferred asset style is:

**grounded stylized 3D / illustrated realism**

The target is not:
- photorealistic realism;
- low-poly abstraction;
- chibi/cartoon proportions;
- literal paper/cardboard/craft aesthetics;
- glossy generic mobile-game assets;
- hyper-detailed noisy materials that disappear at aerial scale.

The intended feeling is:

**the illustrated hunting world from the concept map brought into coherent 3D.**

Models should use:
- believable proportions and mass;
- strong readable silhouettes;
- slightly exaggerated gameplay-important shapes;
- simplified secondary detail;
- restrained stylized PBR/material response;
- color/value grouping that reads on a phone;
- enough close-range quality for first-person monster encounters.

---

# 2. Three-distance readability rule

Every important model must succeed at three distances.

## Distance A — Aerial recognition
The player should recognize category/species/function quickly.

Examples:
- hunter versus civilian;
- large monster versus harmless wildlife;
- smithy versus residence;
- horned head versus tail/wing/body mass;
- usable gate versus decorative wall.

At this distance, silhouette and large value/color blocks matter more than tiny texture detail.

## Distance B — Exploration proximity
The player should read:
- equipment family;
- NPC profession cues;
- monster major anatomy;
- wounds/broken parts;
- building entrances and services;
- interactable props.

## Distance C — First-person / close inspection
The model must still hold up when:
- targeting anatomy;
- viewing armor plates/hide/bone;
- seeing wounds and sever states;
- harvesting;
- entering important interiors;
- inspecting equipment.

Important assets therefore cannot be designed only for the aerial camera.

---

# 3. Scale convention

Current selected measurement convention:

**1 world unit = 1 meter.**

Physical collision scale should remain believable.

Stylization can exaggerate visible forms, not world measurements.

Do not solve readability by making:
- humans unnaturally giant;
- doors 4–5 meters tall;
- weapons impossible to hold;
- monster limbs disconnected from believable mass.

Use camera, lighting, silhouette and controlled proportion exaggeration instead.

---

# 4. Human character model direction

## 4.1 General proportions

Preferred human style:
- broadly realistic adult proportions;
- approximately 7–7.5 heads tall as an art-direction target rather than a strict rig equation;
- hands, boots, shoulder shapes and equipment may be mildly enlarged for aerial readability;
- heads may be very slightly larger than strict realism, but never chibi;
- stance should read clearly from above;
- clothing layers should produce strong silhouette changes.

Player/NPC height should remain within believable human scale unless the setting later establishes another human-like lineage.

## 4.2 Player hunter silhouette

The player should remain identifiable without a glowing outline.

Use:
- readable shoulder profile;
- clear weapon silhouette;
- strong boots/legs under the aerial camera;
- cloak/scarf/coat/tabard shapes only when they do not hide weapon/stance information;
- controlled color separation between body, equipment and background;
- recognizable loadout silhouette.

The hunter should look prepared and practical, not like an ornamental fantasy prince.

## 4.3 NPC visual hierarchy

NPC importance should affect uniqueness, not simulation rules.

Recommended visual tiers:

### Ambient civilian
- shared base bodies/rigs;
- modular heads/hair/clothes;
- lower close-up requirement;
- simple profession/color cues.

### Service NPC
- stronger profession silhouette;
- unique accessories/tools;
- more face/clothing detail;
- recognizable from normal settlement camera.

### Important/story NPC
- unique face/hair/outfit combinations;
- stronger silhouette;
- higher close-up quality;
- still built from compatible technical standards where practical.

This prevents every civilian from requiring hero-asset production cost.

---

# 5. Clothing and equipment construction

Prefer modular equipment rather than one complete unique body mesh per loadout.

Potential modular slots later:
- head;
- torso/coat;
- shoulders;
- arms/gloves;
- waist/belt;
- legs;
- boots;
- back gear;
- weapon;
- selected hunting tool.

Exact gameplay equipment slots remain governed by the equipment design documents and are not locked by this art guide.

Technical/art rule:
- modular pieces should share compatible body/rig standards;
- hidden body geometry under heavy armor may be culled when safe;
- equipment silhouettes should differ by function;
- avoid dozens of tiny layered accessories that create draw-call/rigging cost without meaningful readability.

---

# 6. Monster model philosophy

Monsters are the primary hero assets of the game.

A major monster must communicate:
- species identity;
- physical mass;
- major attack anatomy;
- locomotion type;
- crystal/mutation influence where visible;
- current injury state;
- potential harvest structures.

The monster should look dangerous because its body explains what it can do.

Examples:
- massive forelimbs imply charge/grapple/impact;
- long weighted tail implies sweep/balance;
- horn structure implies gore/charge capability;
- plate geometry implies armor;
- wing structure implies flight/glide capability;
- sensory organs should support perception-related behavior.

Do not add anatomy only as decoration if it visually promises mechanics the monster never uses.

---

# 7. Monster three-layer silhouette design

Every large monster should be designed in this order.

## Layer 1 — Primary mass
Readable from far away:
- quadruped/biped/serpentine/avian/etc.;
- body length/height;
- dominant head/body/tail/wing relationship.

## Layer 2 — Gameplay anatomy
Readable during exploration and combat:
- horns;
- tail;
- wings;
- armor plates;
- large limbs;
- exposed sacs/glands where appropriate;
- claws/jaws;
- major mutation structures.

## Layer 3 — Surface identity
Visible closer:
- scale/hide patterns;
- scars;
- small spikes;
- wrinkles;
- pores;
- chipped plates;
- crystal veining;
- dirt/moss/wetness.

Layer 3 must never destroy Layer 1/2 readability.

---

# 8. Anatomy-to-model binding

Major monster models must be constructed around the authoritative anatomy graph.

Each gameplay-relevant body part should map to a stable visual region or mesh/bone group.

Examples:
- `HEAD`;
- `HORN_L` / `HORN_R`;
- `FORELEG_L` / `FORELEG_R`;
- `HINDLEG_L` / `HINDLEG_R`;
- `TAIL_BASE` / `TAIL_TIP` when segmentation matters;
- `WING_L` / `WING_R`;
- `DORSAL_PLATE_GROUP`;
- `CORE_CAVITY` only if direct core exposure/targeting is eventually approved.

The model must not invent a visual breakable part that the domain cannot identify.

Likewise, if the domain tracks a major breakable part, presentation needs a reliable visual representation for it.

---

# 9. Damage-state construction

Avoid building a completely separate full monster model for every injury state.

Preferred layered solution:

## Intact
Base mesh/material.

## Wounded
- wound masks/decals where affordable;
- material parameter changes;
- limited local mesh variants where necessary.

## Broken
- mesh swap or bone/attachment change;
- cracked/missing armor/horn geometry;
- animation posture consequences.

## Severed
- attached part hidden/detached;
- sever-cap geometry revealed;
- detached physical/harvest object created only from authoritative state.

## Destroyed
- ruined variant;
- cannot visually look pristine;
- harvest presentation reflects loss.

Damage presentation is event-driven, not an every-frame geometry-generation system.

---

# 10. Crystal and mutation visual language

Crystal/mutation visuals should be biologically integrated rather than pasted-on glowing gems everywhere.

Potential expressions:
- subtle mineral veining beneath hide;
- hardened crystalized plates;
- altered horn structure;
- elemental sacs/organs;
- changed eye/skin pigmentation;
- reinforced claws;
- heat vents;
- water-adapted membranes;
- mutation-specific skeletal changes.

Important rule:
Element does not require constant neon glow.

Use emissive effects sparingly for:
- active energy discharge;
- berserk overload;
- exposed crystal structures;
- specific elemental organs.

This protects the grounded style and Android rendering budget.

---

# 11. Berserk model presentation

Berserk should look like the same damaged creature pushing its body beyond safe limits.

Potential visual changes:
- stronger breathing/chest motion;
- aggressive posture;
- muscle/limb tension;
- controlled crystal-vein emission;
- heat/frost/electrical/element-specific secondary effects;
- damaged anatomy remaining damaged;
- animation cadence becoming more forceful or desperate.

Do not:
- transform every monster into an unrelated super-form;
- regrow severed body parts by default;
- hide existing injuries;
- require a completely separate hero model unless a specific species genuinely transforms.

---

# 12. Monster topology and deformation priorities

When production begins, topology budget should prioritize deformation and readable anatomy rather than evenly distributing polygons.

Higher topology priority:
- face/jaw;
- shoulders/hips;
- elbows/knees/ankles;
- wing roots;
- tail base;
- large membrane joints;
- break/sever boundaries;
- first-person target anatomy.

Lower priority:
- permanently rigid hidden surfaces;
- flat armor interiors;
- unseen underside areas unless combat exposes them;
- tiny repeated spikes that can use simpler geometry/normal detail.

Exact triangle budgets remain OPEN until engine/device profiling.

---

# 13. Human/monster rig philosophy

## Humans
Prefer one or a small number of compatible humanoid skeleton standards so:
- animations can be reused;
- modular equipment works;
- NPC production remains affordable.

## Monsters
Use species/body-plan rigs rather than forcing every creature onto one universal skeleton.

A rig should expose meaningful bones for:
- locomotion;
- attack telegraphs;
- damaged posture;
- severable/breakable structures;
- head/eye tracking where used;
- tail/wing/large appendage motion.

Do not add hundreds of bones because a DCC tool allows it.

Rig complexity must be justified by visible movement or gameplay state.

---

# 14. Building model direction

Settlement buildings should look practical, defensible and built from local materials.

Preferred visual language:
- timber frames;
- stone foundations;
- plaster/wood wall sections where setting supports;
- canvas/awnings;
- iron fittings;
- rope;
- tile/wood/shingle roofs;
- monster bone/shell/hide used as accents or functional material where culturally appropriate.

Buildings should communicate function by silhouette.

Examples:
- smithy: broad chimney/furnace mass, open work frontage, material racks;
- hunter lodge: larger roofline, banners/signage, trophy/preparation architecture;
- processing yard: open covered work area, hooks/tables/storage;
- residence: smaller/quieter silhouette;
- watchtower/gate: vertical defensive mass visible from several streets away.

---

# 15. Modular building kit

Do not model every settlement building as one unique monolithic mesh.

Preferred reusable kit categories:
- wall sections;
- corners;
- foundations;
- roof modules;
- doors;
- windows;
- beams/posts;
- stairs;
- balconies;
- awnings;
- fences;
- gates;
- bridges;
- chimneys;
- market stalls;
- defensive wall/tower pieces.

Unique service buildings should combine reusable modules with a small number of signature pieces.

Benefits:
- faster settlement creation;
- consistent scale;
- easier LOD generation;
- simpler collision;
- fewer texture/material families;
- easier future settlements.

---

# 16. Building interiors

Important small/medium interiors should visually belong to their exterior building.

Preferred approach:
- real walkable volume;
- exterior/interior geometry separated for visibility control;
- roof/wall cutaway, fade, hide or occlusion behavior as required by aerial camera;
- simple collision proxies;
- interior props grouped by gameplay value.

Do not model an entire inaccessible decorative upstairs room at hero detail if the player can never enter or see it meaningfully.

Large interiors may use controlled threshold streaming per `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`.

---

# 17. Props and clutter hierarchy

Props use three levels.

## Gameplay-critical
Highest readability:
- doors;
- crafting stations;
- storage;
- cover objects;
- harvest tables;
- contract board;
- camp equipment;
- interactable resources.

## Story/function props
Moderate priority:
- weapon racks;
- carts;
- barrels;
- tanning frames;
- drying racks;
- trophies;
- tools.

## Decorative clutter
Lowest priority:
- small bottles;
- loose papers;
- tiny utensils;
- debris;
- minor baskets.

Decorative clutter is pooled/instanced/simplified first when performance requires.

---

# 18. Terrain model language

Terrain should combine broad natural forms with modular reusable detail.

Primary forms:
- slopes;
- cliffs;
- riverbeds;
- banks;
- ridges;
- cave mouths;
- large roots;
- boulder formations;
- fallen trees.

Secondary detail:
- grass;
- reeds;
- shrubs;
- small stones;
- branches;
- flowers/fungi.

Do not build the environment as thousands of unique high-detail objects.

Use:
- terrain/mesh blending where engine permits;
- repeated natural modules with variation;
- instancing;
- billboards/impostors for distant vegetation when visually acceptable;
- decals/masks for tracks/wounds/wetness only under explicit budgets.

---

# 19. Material direction

Preferred material style:

**stylized physically believable materials with controlled roughness/value/color grouping.**

Materials should read clearly as:
- wood;
- stone;
- iron;
- leather;
- cloth/canvas;
- hide;
- scale;
- shell;
- bone;
- crystal;
- mud;
- water;
- vegetation.

Avoid:
- extreme photoreal micro-detail;
- constant high-frequency noise;
- overly reflective surfaces;
- every asset using a unique shader;
- excessive transparency.

Texture/detail density should support phone viewing and first-person monster inspection, not desktop cinematic rendering.

---

# 20. Color/value design

Use broad color/value hierarchy to preserve readability.

Player:
- enough separation from common terrain values;
- equipment families identifiable without neon rarity colors.

NPCs:
- profession/status may influence controlled color grouping.

Monsters:
- base palette fits habitat;
- major anatomy remains distinguishable through value/material/form differences;
- mutations may alter palette selectively;
- wounds need enough contrast to read but should not become glowing target paint.

Buildings:
- service buildings gain silhouette/signage/material distinctions rather than relying only on floating icons.

---

# 21. LOD strategy

Important 3D assets should be authored with a degradation path.

Conceptual model levels:

## LOD0 — hero/close
Used for:
- first-person monster combat;
- close player/NPC views;
- important nearby interiors.

## LOD1 — normal exploration
Retains silhouette and major anatomy/equipment.

## LOD2 — distant exploration
Simplifies:
- small loops/details;
- material complexity;
- minor accessories;
- internal unseen geometry.

## LOD3 / impostor where appropriate
For:
- distant buildings;
- vegetation;
- noncritical distant creatures where silhouette is sufficient.

Never simplify away combat-relevant anatomy while the monster can still become a target at that distance.

Exact switch distances are prototype/device decisions.

---

# 22. Model performance priorities

When optimization is needed, reduce in this order where possible:
1. invisible/covered geometry;
2. tiny geometric detail;
3. accessory density;
4. material/shader complexity;
5. distant geometry through LOD;
6. decorative bones/secondary motion;
7. texture resolution beyond visible need.

Protect:
- silhouette;
- body-part boundaries;
- weapon readability;
- attack telegraph deformation;
- settlement entrance readability;
- collision correctness.

---

# 23. Collision standard

Visual meshes should generally not be used directly as complex gameplay collision when simpler proxies can preserve behavior.

Use simplified collision for:
- buildings;
- walls;
- terrain blockers;
- large props;
- monster navigation/body occupancy where appropriate.

Combat body-part targeting may require dedicated hit regions bound to authoritative anatomy rather than raw render triangles.

This improves:
- performance;
- predictability;
- testing;
- body-part ownership.

---

# 24. Asset pivot/origin discipline

When implementation begins, every model family needs consistent pivot/origin rules.

Examples:
- humans: ground/root at feet;
- monsters: stable locomotion root at body/ground reference;
- doors: hinge pivot;
- modular walls: grid-compatible base/corner origin;
- props: stable placement base;
- severable monster parts: explicit attachment/break reference.

Inconsistent pivots create placement, animation and streaming bugs.

Exact file conventions will be written only after engine/toolchain selection.

---

# 25. Asset reuse versus uniqueness

Spend uniqueness where players notice it.

High uniqueness:
- major monsters;
- player equipment silhouettes;
- key NPCs;
- hunter lodge/gate/major landmarks;
- biome-defining large forms.

High reuse/modularity:
- civilian bodies;
- common clothing;
- ordinary houses;
- fences;
- crates/barrels;
- vegetation;
- rocks;
- small tools;
- background structures.

This gives the game visual identity without making content production impossible.

---

# 26. First-person compatibility requirement

Any monster model used in exploration must be designed from the beginning with first-person use in mind.

Do not create:
- low-detail aerial monster first;
- unrelated high-detail battle duplicate later.

Preferred asset lineage:

`ONE MONSTER IDENTITY`
→ hero source model/rig
→ LOD0 close combat
→ LOD1 exploration
→ LOD2 distance
→ optional impostor/distant representation

All representations bind to the same authoritative creature state.

---

# 27. Quality gate for a model asset

Before an important model can be accepted later, verify:

## Visual
- readable silhouette at intended aerial distance;
- believable scale;
- correct material family;
- no unnecessary visual noise;
- clear gameplay-important anatomy/function.

## Gameplay
- collision proxy exists where needed;
- body-part hit regions map correctly;
- break/sever state is supportable;
- entrances/interactions are physically readable;
- model does not imply mechanics that do not exist.

## Technical
- pivot/origin correct;
- LOD/degradation path defined;
- material count controlled;
- texture use justified;
- hidden geometry removable where safe;
- rig complexity justified;
- no unbounded secondary effects.

## Continuity
- exploration and combat representations refer to the same identity;
- damage states persist visually across mode transitions;
- equipment changes update visual representation consistently.

## Android
- real target-device performance checked before production scale-up.

---

# 28. Prototype targets, not final budgets

Because engine and target Android device are not selected, exact production budgets remain OPEN.

Do not lock final values yet for:
- triangle counts;
- texture resolution;
- material count per hero asset;
- skeleton bone count;
- blend-shape count;
- LOD switch distances;
- maximum skinned characters in view.

The first engine/device probe should measure these with placeholder assets representing the expected visual complexity.

---

# 29. First modeling proof after authorization

The first modeling/art proof should remain small.

Create only:
- one hunter placeholder with final-ish silhouette proportions;
- one modular civilian variant;
- one large monster graybox with 6–8 mapped anatomy regions;
- one breakable horn/plate;
- one severable tail segment;
- one basic mutation visual change;
- one small modular building exterior/interior;
- one settlement gate module;
- one rock/tree/cover set;
- LOD/proxy versions sufficient to test aerial and first-person views.

Prove:
- aerial readability;
- first-person close-up viability;
- anatomy targeting;
- damage-state swap;
- seamless settlement interior readability;
- LOD behavior;
- Android frame/memory impact.

Only then establish real production budgets and create the first final art pack.

---

# 30. Current decisions and open questions

## Current/selected
- grounded stylized 3D / illustrated realism;
- same major monster asset lineage supports aerial and first-person use;
- realistic physical scale with mild silhouette exaggeration;
- modular humanoid/equipment strategy;
- species/body-plan monster rigs;
- anatomy-linked monster model regions;
- layered damage-state presentation instead of complete duplicate models;
- modular settlement building kits;
- stylized physically believable materials;
- explicit LOD/degradation path;
- simplified collision proxies;
- quality-critical silhouette/anatomy protected before decorative detail.

## Open
- exact human customization scope;
- exact final player proportions;
- exact armor/equipment slot visuals;
- exact first monster body plan;
- exact crystal exposure/visibility;
- exact mutation visual intensity;
- gore intensity;
- exact material/texture workflow;
- exact triangle/texture/bone budgets;
- final LOD distances;
- final DCC/engine import conventions.

---

# 31. Stop rule

This guide defines the modeling/art standard only.

Do not begin production modeling, rigging, texturing or engine import until implementation/art production is explicitly authorized and the engine/device probe establishes real budgets.
