# Unnamed Hunt RPG — Visual World & Behavior Bible

Status: DESIGN CONTRACT / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## 1. Purpose

This document is the primary visual-and-runtime behavior contract for the new game.

It defines how the game should look, how the world should read from the exploration camera, how environments should behave, how the transition into combat should feel, how first-person tactical combat should present authoritative state, and how visual design must stay synchronized with the domain simulation.

This is not an implementation claim. No gameplay source is authorized yet.

## 2. Core visual premise

The game should borrow the readability philosophy of an angled Paper-Mario-like overview without using a literal paper/craft aesthetic.

The intended identity is:

**an illustrated hunting world brought to life**

The player should feel as if they are looking down into a living miniature wilderness during exploration, then physically entering that same space when combat begins.

The world is not flat 2D and it is not a conventional third-person 3D action game.

Preferred presentation:
- angled aerial / elevated 2.5D exploration;
- real depth, elevation, occlusion, terrain, water, cliffs and structures;
- stylized 3D player and monsters so the same creature can transition naturally into first-person combat;
- 2D/billboard/impostor layers only where they improve Android performance and remain visually coherent;
- limited camera freedom so composition remains readable on a phone;
- first-person tactical combat using the exact encounter context from exploration.

## 3. Theme

Primary theme target:

**grounded stylized wilderness / frontier monster-hunting fantasy**

The game should not be cheerful paper-craft comedy, generic grimdark, or photorealism.

It should support both beauty and danger:
- forests can be lush and inviting while still containing dangerous signs;
- settlements feel lived-in and practical;
- monster carcasses, broken anatomy and harvested materials can feel consequential without making the entire world visually miserable;
- the wilderness should often look more powerful and older than human civilization.

The tone should allow calm exploration, tension while tracking, and intense close-range confrontation.

## 4. Exploration camera contract

Preferred prototype camera:
- landscape orientation;
- approximately 40–50° downward viewing angle;
- elevated enough to show terrain ahead, nearby monsters, tracks, cover and landmarks;
- player positioned slightly below screen center so more forward space is visible;
- long-focal perspective or orthographic-like projection to be compared during engine probe;
- limited zoom range;
- camera rotation either discrete or tightly bounded if unrestricted rotation reduces readability;
- no constant over-the-shoulder camera.

The camera should make the world resemble a dimensional illustrated diorama rather than a flat map.

## 5. Exploration readability rules

From the aerial view, the player should understand important terrain without opening a menu.

Readable world cues include:
- clear paths and natural routes;
- cliffs and elevation steps;
- rivers/streams and crossing points;
- tall grass and concealment areas;
- large rocks and defensive cover;
- fallen trees and chokepoints;
- monster tracks and environmental damage;
- nests/dens;
- camps and safe spaces;
- gatherable plants/minerals only when close enough or already learned;
- region landmarks visible from useful distances.

Avoid excessive glowing markers when the physical environment can communicate the same information.

## 6. Environmental composition

Nature should dominate most hunting regions.

World building should use strong large forms before tiny detail:
- tree trunks/canopies;
- roots;
- boulders;
- cliffs;
- water;
- ruins;
- large vegetation masses;
- cave mouths;
- fallen trees;
- visible monster-made damage;
- nests and territorial signs.

Small decorative props are secondary.

This improves both mobile performance and visual comprehension.

## 7. World layering

Each region is visually and technically layered.

### Layer A — gameplay-critical geometry
Always authoritative/readable:
- traversable ground;
- blocked boundaries;
- cliffs/drop-offs;
- water/hazards when mechanically relevant;
- cover objects;
- encounter spaces;
- camps;
- important interactables;
- monsters/player;
- exits/transitions.

### Layer B — navigation and hunting cues
- paths;
- tracks;
- broken branches;
- footprints;
- blood/signs where applicable;
- nests;
- feeding sites;
- scratch marks;
- territorial damage;
- landmarks.

### Layer C — atmosphere
- grass clumps;
- leaves;
- insects;
- drifting particles;
- small debris;
- flowers/fungi;
- distant wildlife;
- ambient decorative motion.

Layer C may be aggressively pooled, billboarded, simplified or disabled before Layer A/B clarity is sacrificed.

## 8. Player and monster proportions

Characters must remain readable on a phone.

Player rules:
- slightly exaggerated silhouette;
- readable head/shoulder/weapon shapes;
- boots, hands and major equipment should not disappear at aerial scale;
- equipment can be somewhat oversized for readability, but should still feel physically usable.

Monster rules:
- major monsters must be visually recognizable from aerial distance;
- combat-relevant anatomy should influence silhouette;
- horns, tails, wings, armor plates, claws and large limbs should be identifiable before combat when the creature is visible;
- creatures can use stylized proportions to emphasize anatomy and behavior;
- major monsters should feel larger than ordinary wildlife.

## 9. Region visual themes

Regions must be distinguishable without HUD labels.

### Temperate starter wilderness
- rich but controlled greens;
- warm earth/wood/stone;
- streams and moss;
- readable dirt paths;
- medium vegetation density;
- strong daylight readability.

### Swamp/wetland candidate
- dark water;
- reeds, roots and mud;
- low visibility pockets;
- saturated plant life;
- dangerous footing;
- fog/humidity where performance allows.

### Highland/mountain candidate
- exposed stone;
- stronger elevation;
- narrow routes and ledges;
- wind-exposed vegetation;
- long sightlines mixed with chokepoints.

### Snow candidate
- pale value structure;
- dark rocks/trees for contrast;
- tracks preserved clearly;
- weather affecting visibility where gameplay supports it.

### Volcanic/ash candidate
- black/charcoal rock;
- ash and sparse vegetation;
- bright heat/emissive accents used sparingly;
- harsh silhouettes;
- visible hazard zones.

### Coastal candidate
- slate/stone coastline;
- dark or cold blue water;
- pale grasses;
- fog/wind;
- cliffs, caves and tidal spaces.

These are visual language candidates, not approved biome production scope.

## 10. Civilization / frontier visual identity

Settlements should look built by people who survive through hunting and local materials.

Material language:
- wood;
- leather;
- canvas;
- stone;
- iron/steel;
- rope;
- ceramic;
- bone;
- shell/plate;
- harvested monster material where culturally appropriate.

Buildings should communicate purpose through shape and props.

Examples:
- smith/crafter area with furnaces, racks, anvils and large material storage;
- hunter lodge with maps, trophies, preparation tables and contract boards;
- apothecary using plants, glands, fluids and drying racks;
- processing/harvest area using tools, hooks, worktables and storage;
- homes that are smaller and more ordinary than service buildings.

Monster materials can become part of architecture and equipment, making successful hunting visibly affect civilization.

## 11. Exploration behavior

Exploration is physical, not menu-driven.

The player should:
- walk through the region;
- follow tracks/signs;
- observe monster behavior from distance;
- decide approach direction;
- use terrain for line-of-sight/concealment where later mechanics support it;
- gather resources;
- discover camps/landmarks;
- choose whether to initiate, avoid or continue tracking an encounter.

Roaming monsters should exist in authoritative exploration state before combat.

A creature seen near a river must not magically become a fresh unrelated monster in a generic battle arena.

## 12. Exploration-to-combat transition

This transition should become a signature feature.

Preferred visual sequence:
1. exploration detects/commits an encounter;
2. world input temporarily locks;
3. camera begins lowering from the aerial angle;
4. camera moves toward the player/encounter origin;
5. nearby terrain/cover remains visible and spatially consistent;
6. viewpoint settles around hunter eye level;
7. first-person tactical HUD appears;
8. authoritative encounter state becomes the active interaction mode.

The transition should feel like entering the same physical moment, not loading a disconnected minigame.

Preserve:
- monster identity;
- existing wounds;
- player approach direction;
- nearby rocks/trees/walls usable as cover;
- elevation;
- range;
- hazards;
- escape route;
- time/weather when mechanically relevant.

## 13. First-person combat visual contract

Combat is first person but turn-based and spatial.

The monster should normally occupy enough of the screen for body-part targeting to feel physical.

Approximate visual principle:
- close range: monster may occupy a majority of view;
- medium range: enough surrounding environment remains visible to reason about cover and movement;
- long range: silhouette and telegraphs remain readable.

Combat must not become a static portrait with menus layered on top.

## 14. Tactical viewpoint behavior

The camera follows authoritative tactical state.

Examples:
- `STEP_LEFT` changes the player's bearing/position first in the domain, then camera animates to the new viewpoint;
- moving behind rock cover changes occlusion and available attacks;
- circling the monster may expose a flank, leg, tail or wound;
- closing distance changes apparent scale and attack legality;
- retreating changes apparent scale and possible escape state.

Free camera looking may be permitted for inspection within bounded limits, but looking alone must not change tactical position.

## 15. Body-part targeting presentation

Do not permanently outline every body part.

Normal combat view:
- clean creature/environment view;
- damage visible through model/material/posture changes;
- minimal status information.

Target-selection mode:
- valid target regions become subtly selectable;
- selected part receives clear reticle/highlight;
- known information is shown;
- unknown hidden statistics remain hidden;
- inaccessible/occluded parts explain why targeting is limited;
- chance/cost information appears without covering the creature.

Body-part labels should use readable names and optional anatomy diagram support, but the 3D creature remains the primary target surface.

## 16. Damage visual states

Visual state follows authoritative anatomy.

Possible presentation sequence:
- intact;
- visibly wounded;
- structurally damaged;
- broken;
- severed;
- destroyed.

Examples:
- broken horn visibly missing/cracked;
- injured leg changes stance/locomotion;
- damaged wing droops or cannot fully spread;
- cracked armor plate exposes underlying layer;
- damaged eye changes eye appearance and possibly head posture;
- severed tail disappears from the attached rig and becomes a detached encounter object if harvest-relevant.

No sever animation can occur unless the domain state says the part severed.

## 17. Gore and maturity direction

Current preferred tone is grounded and consequential rather than exaggerated splatter.

Default recommendation for discussion:
- visible wounds;
- blood where appropriate;
- breaks represented through posture/model damage;
- severing clearly shown when it occurs;
- carcass/harvest visuals readable but not designed primarily for shock value.

The exact intensity remains an explicit decision.

## 18. Harvest visual behavior

Harvest should feel connected to the exact creature the player fought.

After combat:
- carcass/severed parts preserve authoritative condition;
- the player can inspect available anatomy/materials;
- damaged/destroyed resources visibly communicate loss;
- selected harvest method/tool should be shown where practical;
- extracted materials are presented with quantity, quality and reason for losses/bonuses.

Example explanation:
`Tail Sinew — 2 units recovered. Reduced yield: tail suffered heavy blunt damage before severing.`

The harvest screen must never fabricate material independent of body state.

## 19. UI visual language

UI should look like practical hunter equipment and field documentation, not a generic glossy mobile game.

Preferred language:
- clean dark/neutral base;
- restrained leather/wood/metal influence rather than excessive ornamental borders;
- field notebook/bestiary pages for research;
- illustrated anatomy diagrams;
- map/contract screens inspired by field charts;
- large touch targets;
- high contrast;
- minimal permanent HUD.

Avoid:
- glowing neon rectangles everywhere;
- tiny PC-style buttons;
- excessive fake parchment covering the screen;
- permanent outlines around all interactive objects;
- cluttered floating damage-number spam.

## 20. Exploration HUD

Keep world visibility high.

Potential permanent/near-permanent elements:
- health/stamina only when useful;
- current hunt objective;
- compact interaction prompt;
- small directional/navigation element if needed;
- current selected field tool;
- awareness/danger state.

Secondary systems should open contextually:
- map;
- inventory;
- bestiary;
- contracts;
- crafting outside combat;
- detailed status.

## 21. Combat HUD

Landscape phone layout target.

Center:
- creature/environment view.

Lower left:
- health;
- stamina;
- AP;
- reaction resource;
- important statuses.

Lower/right action area:
- MOVE;
- ATTACK;
- DEFEND;
- ITEM/TOOL;
- INSPECT;
- ESCAPE.

Top/side:
- turn order;
- current range/bearing;
- cover state;
- known monster state;
- telegraphed threat.

Menus should expand only when selected so the monster remains visible.

## 22. Animation language

Exploration animation:
- readable walk/run cycles;
- monsters move with species-specific gait;
- large creatures communicate mass through acceleration, turns and stops;
- ambient behavior supports tracking/observation.

Combat animation:
- telegraphs matter more than spectacle;
- attacks should clearly show origin body part;
- injuries alter animation choices;
- large moves can use short cinematic framing only if control/readability is preserved;
- camera shake must be bounded for mobile comfort.

Animation represents domain events; it does not decide outcomes.

## 23. Audio behavior

Audio is a gameplay information layer.

Exploration:
- region ambience;
- wind/water/foliage;
- distant creature calls;
- footsteps by surface;
- monster movement sounds;
- subtle threat cues.

Combat:
- attack telegraph sounds;
- breathing/strain;
- armor/bone/hide impact differences;
- environmental impacts;
- directional threat cues where supported.

Music should transition from calm exploration to tension/encounter without requiring every fight to use constant maximal intensity.

## 24. Lighting/time/weather

Presentation may include:
- daylight direction changes;
- warm/cool time-of-day shifts;
- fog/rain/snow/ash where region appropriate;
- wetness or snow accumulation only if budget allows.

If darkness, rain, fog or weather affects visibility, tracking, accuracy, movement or monster behavior, that consequence must exist in authoritative gameplay state rather than being a renderer-only surprise.

## 25. Scene/runtime structure

Exact engine paths are not locked, but visual/runtime responsibilities should separate cleanly.

Conceptual structure:

`GameShell`
- lifecycle/navigation/save loading;
- mode switching.

`RegionScene`
- authoritative region reference;
- terrain/collision representation;
- player visual;
- roaming monster visuals;
- tracking/environment presentation;
- exploration camera/HUD.

`EncounterScene`
- derived from EncounterState;
- first-person camera;
- tactical environment presentation;
- authoritative monster visual instance/state binding;
- action/target UI;
- combat VFX/audio.

`PresentationStateAdapter`
- translates authoritative domain state/events into visual instructions;
- never mutates gameplay truth.

`AssetCatalog`
- maps stable content IDs to models/sprites/materials/audio/effects.

## 26. World continuity rules

The game must preserve continuity between modes.

Examples:
- monster injuries persist;
- broken/severed parts persist;
- monster flee position can return to exploration state;
- player exits combat back into the real region context;
- harvested/detached objects cannot duplicate on mode transition;
- destroyed environmental cover remains destroyed if persistence rules say it should;
- encounter outcome can change local monster behavior or availability.

## 27. Performance visual hierarchy

When performance is insufficient, reduce in this order before sacrificing gameplay clarity:
1. tiny particles;
2. ambient decorative density;
3. distant decorative wildlife;
4. high-cost transparency;
5. shadow resolution/count;
6. texture/detail resolution;
7. decorative animation complexity;
8. distant LOD quality.

Do not first remove:
- body-part readability;
- tactical cover visibility;
- encounter telegraphs;
- player/monster silhouettes;
- input responsiveness;
- authoritative collision clarity.

## 28. First visual prototype target after authorization

The first engine/device visual probe should contain:
- one small forest clearing/route;
- angled aerial camera;
- player movement representation;
- one large monster moving in exploration;
- rock/tree cover;
- tracks/signs;
- aerial-to-first-person camera transition;
- same monster in first-person view;
- selectable body regions;
- one visible damaged/broken state;
- basic landscape mobile HUD;
- Android performance measurement.

No large biome, town or bestiary is required for this probe.

## 29. Design invariants

The following are now design-level constraints unless explicitly changed by the user:

1. Exploration should visually resemble a dimensional illustrated overview, not a flat map.
2. The game does not use a literal paper aesthetic.
3. Monsters/player are preferably 3D for continuity into first-person combat.
4. Nature and large readable forms dominate hunting regions.
5. The transition into combat preserves the same physical encounter context.
6. First-person combat remains spatial and tactical despite being turn-based.
7. Anatomy damage is visually persistent and tied to authoritative part state.
8. UI stays restrained and touch-readable.
9. Environment communicates information before HUD markers are added.
10. Android performance reductions target decorative complexity before tactical readability.

## 30. Implementation hold

VISUAL_BEHAVIOR_DESIGNED = YES
VISUAL_PROTOTYPE_IMPLEMENTED = NO
VISUAL_QUALITY_VERIFIED = NO
PERFORMANCE_VERIFIED = NO
IMPLEMENTATION_AUTHORIZED = NO

Next action remains design discussion and refinement.