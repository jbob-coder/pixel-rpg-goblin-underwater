> **SUPERSEDED PRESENTATION NOTICE — 2026-09-25**
>
> This document is preserved as historical architecture/presentation evidence from the `shooter-rpg` / third-person pivot period. Its active-status header, branch, third-person camera direction, shooter visual references, and implementation-state claims are not current Pixel RPG authority.
>
> Current Pixel RPG presentation is first-person and is governed by live `main`, `PIXEL_RPG_VISUAL_DIRECTION.md`, `START_HERE_NEW_CHAT.md`, and current source/tests.
>
> Reusable architecture laws in this file—single authoritative gameplay owners, presentation not inventing outcomes, stable IDs, deterministic systems, versioned saves, and state/presentation separation—remain valuable unless a newer owner explicitly supersedes them.

# Unnamed Hunt RPG — Architecture and Visual Bible

Status: ACTIVE DESIGN AUTHORITY / SHOOTER-RPG VISUAL PIVOT / IMPLEMENTATION NOT YET CLAIMED
Last reconciled: 2026-09-15
Branch: `shooter-rpg`

## Authority

This document is reconciled with `SHOOTER_RPG_VISUAL_DIRECTION.md`.

If an older visual document conflicts with the selected third-person pixel direction, `SHOOTER_RPG_VISUAL_DIRECTION.md` wins. Historical build/test evidence remains valid only for what it actually verified.

## Purpose

Define how the game's code, data, presentation, art, scale, animation, saves, tools, and verification should behave while supporting the newly selected third-person pixel-style presentation.

## Architecture laws

1. One authoritative game state.
2. Exploration, combat, harvest, crafting, progression, NPC simulation and save systems operate on the same domain data.
3. Presentation requests actions and renders results; it does not invent outcomes.
4. Stable IDs exist for persistent/content entities.
5. Content definitions are data-driven where practical.
6. Save formats are versioned and repaired deliberately.
7. Randomness is seedable/loggable where reproducibility matters.
8. Every major system exposes validation/invariants.
9. Debug tools call the same authoritative domain paths or explicitly marked admin paths.
10. No hidden gameplay state lives only in UI nodes/widgets.
11. Visual style must remain separable from gameplay truth so presentation can evolve without corrupting saves/simulation.

## Proposed domain separation

- App/Game shell: lifecycle, navigation, platform integration.
- Exploration domain: region state, player position, roaming creatures, interactables, tracking.
- Encounter/combat domain: timing/turn state, resources, reactions, movement, cover, attacks, anatomy, statuses.
- Creature domain: species definitions, monster instances, anatomy, behavior parameters.
- NPC/SIM domain: identities, households, schedules, relationships, memories, aging, settlement roles.
- Time/calendar domain: world clock, day/date/year, schedules and time costs.
- Harvest domain: surviving material capacities, extraction methods, quantity/quality.
- Inventory/crafting domain: items, materials, recipes, equipment.
- Progression/research domain: level, attributes, mastery, bestiary knowledge, limit-break conditions.
- Settlement/faction domain: services, mining rights/licenses, groups, settlement state and consequences.
- Persistence domain: save schema, migration/repair, serialization.
- Presentation: third-person pixel-style world, HUD, animation, audio/VFX.
- Debug/creator tooling: inspectors, encounter presets, creature/anatomy validation, deterministic replay helpers.

## Authoritative state flow

`Input → ActionRequest → Validate → Resolve → DomainEvents + StateChange → Persist/Log → Presentation`

## Stable ID policy

Never use display names as persistent identity.

Example families:
- `region_*`;
- `settlement_*`;
- `route_*`;
- `encounter_*`;
- `species_*`;
- `monster_*`;
- `part_*`;
- `attack_*`;
- `weapon_*`;
- `item_*`;
- `material_*`;
- `recipe_*`;
- `cover_*`;
- `quest_*`;
- `npc_*`;
- `faction_*`;
- `license_*`;
- `relationship_*`;
- `memory_*`.

IDs are immutable after released saves depend on them.

## Selected camera / presentation architecture

Core gameplay uses a **third-person behind-the-character camera** in a real spatial world.

Required properties:
- character remains visible during normal exploration and combat;
- left-stick direct movement;
- independent right-side camera/look;
- simultaneous move/look;
- landscape mobile layout;
- camera framing prioritizes forward readability and monster scale;
- camera system remains configurable so pitch/distance/FOV can be tuned from phone evidence.

The previous mandatory aerial-exploration → first-person-combat presentation is superseded on `shooter-rpg`.

## Pixel-style rendering architecture

The target is **pixel-styled third-person 3D**.

Preferred implementation family:
- real 3D geometry/collision/navigation;
- pixel-authored or pixel-consistent textures/materials;
- controlled low-resolution internal rendering where useful;
- nearest-neighbor/crisp upscale treatment where appropriate;
- pixel-consistent HUD and iconography;
- restrained shader/material complexity;
- silhouette/readability prioritized over micro-detail.

Do not assume that applying a single full-screen pixel shader is sufficient. The art pipeline, texture density, lighting, UI and animation must all support the style.

Exact internal resolution/pixel scale/shadow method is OPEN until prototype/device testing.

## World traversal architecture

Normal exploration is physical and continuous within local connected spaces.

Avoid menu-only teleportation as the primary traversal loop.

Use **world compression**:
- keep playable routes compact;
- remove long empty stretches;
- preserve landmarks, encounters, resources, NPC movement, clues, hazards and meaningful choices;
- allow lore distance to exceed literal player walking time.

Regions may still stream in bounded chunks/scenes for performance. Seamless-looking traversal does not require the entire future world to be loaded simultaneously.

## Combat data rules

Attacks define:
- resource costs;
- range/bearing legality;
- timing/turn legality;
- accuracy profile;
- damage profile;
- body-part targeting constraints;
- status/break/sever interactions;
- weapon/tool requirements;
- telegraph/reaction relationships.

Body parts define:
- integrity/structure;
- parent attachment;
- armor/tissue/bone layers as needed;
- target difficulty/exposure;
- break/sever rules;
- functional consequences;
- material capacities.

Monster behavior consumes authoritative combat facts. It must not depend on animation completion to decide strategy.

## Third-person combat presentation

Combat stays in the same third-person spatial presentation family.

The player should be able to:
- reposition;
- use terrain/cover where supported;
- attack selected anatomy;
- defend/block/react where equipment/rules allow;
- dodge/evade where rules allow;
- use items/tools;
- inspect/read monster behavior;
- withdraw when legal.

Body-part targeting should be contextual, not a permanent neon overlay. The camera/UI can assist selecting anatomy without turning the encounter into a flat menu portrait.

This visual decision does not by itself rewrite the already-implemented deterministic combat rules. Timing model changes require separate design/verification authority.

## Harvest rules

Each material source links to anatomy.

Harvest result must be explainable from:
- original anatomical capacity;
- remaining part condition/mass;
- damage method;
- sever/break/destruction state;
- contamination/status;
- harvesting tool;
- harvesting skill/perk;
- harvesting method/time choice.

The result screen should explain major losses/bonuses in plain language.

## NPC / relationship / generation architecture

Important NPCs use persistent state rather than runtime generative AI.

Recommended core data:
- stable ID;
- birth date/age;
- household/family links;
- profession/role;
- home/current location;
- schedule;
- settlement/faction membership;
- relationship dimensions;
- selected meaningful memories;
- injuries/status;
- current goals/priorities.

NPCs may form relationships with each other. New NPCs can be generated from settlement/population rules, but important generated people must receive stable identity and persistent history once promoted into persistent simulation.

Simulation can update inactive populations in coarse steps while preserving deterministic/state-consistent outcomes. Active nearby characters use higher-fidelity behavior.

## Time / aging architecture

World time is authoritative.

Gameplay actions consume time. The clock supports:
- NPC schedules;
- monster activity windows;
- travel/exploration costs;
- weather/daylight hooks;
- contracts/events;
- aging and generational change.

Do not simulate every distant NPC every frame. Long-horizon updates can use scheduled/coarse simulation steps.

## Progression architecture

Power growth is multi-layered:
- level;
- attributes;
- weapon mastery;
- equipment;
- monster knowledge;
- crafting/harvesting skill;
- relationships/access;
- tactical options.

Level alone must not allow the player to trivialize the ecosystem.

A species/race soft or hard cap may exist. Human level 20 is a provisional design anchor, not immutable balance authority. Beyond-cap progression can require rare materials/conditions and uncertain breakthrough attempts. Failed attempts should preserve meaningful partial progress/adaptation rather than erase core advancement.

## Crystal / diamond / mining architecture

Energy-bearing crystals/diamonds may exist in:
- geological deposits/mines;
- selected monster anatomy/ecology;
- rare environmental formations.

Systems may include:
- mining licenses/permissions;
- settlements built around protected resources;
- factions/survivor groups;
- energy/economy consequences;
- risk/reward around legal/illegal extraction.

These systems should feed the same world economy and consequence model rather than becoming isolated currencies.

## Diamond Watch architecture

The recurring Diamond Watch concept may act as a diegetic player-information device.

Potential modules:
- time/date;
- map;
- contracts;
- hunter journal/bestiary;
- notes;
- discovered locations;
- licenses;
- faction/settlement notices;
- relationship/world information expressed without exposing raw simulation numbers.

## Save rules

The game uses its own schema lineage.

Save must eventually preserve:
- player progression/equipment/inventory;
- world/region position/state;
- time/calendar;
- active hunt/contract state;
- persistent monster condition where needed;
- NPC identities/relationships/memories/age state;
- settlement/faction state;
- bestiary/research knowledge;
- materials/crafting progression;
- settings;
- RNG/sequence information where necessary for deterministic continuity.

Before changing save shape:
- define defaults;
- define migration/repair;
- add round-trip/legacy tests;
- increment schema when contract changes materially.

## HUD architecture

HUD must be safe-area and aspect-ratio aware.

Preferred zones inspired by the selected visual reference:
- upper-left: health/stamina/essential player state;
- upper-right: mini-map/compass/time access;
- collapsible objective panel;
- lower-left: bounded quick-item area;
- lower-right: contextual action controls;
- world-space interaction markers only when relevant.

Use anchors/containers/layout rules rather than fixed pixel placement that causes overlap on different phones.

## Animation authority

Animation represents state.

Examples:
- injured leg state selects limp locomotion;
- severed tail removes tail animation branch;
- stagger event triggers stagger presentation;
- attack event plays after action resolution inputs are fixed;
- NPC schedule transition selects locomotion/activity presentation.

Animation events may control presentation timing but must not secretly determine authoritative hit/loot/relationship results.

## Mobile performance principles

- design for actual target phones;
- profile CPU/GPU/memory/frame pacing on device;
- use bounded visible NPC/creature/prop/effect counts;
- use streaming/chunk activation;
- pool/reuse effects;
- use LOD/impostors/atlases where appropriate;
- keep inactive simulation cheaper than nearby simulation;
- reduce cosmetic detail before gameplay readability;
- prefer stable frame pacing over uncontrolled visual complexity;
- keep total player-required game footprint under the selected 2 GB cap.

## Content scaling principle

First prove one complete, visually accepted slice.

NOW:
- one settlement gate/street;
- one player controller;
- one NPC interaction;
- one route outside the settlement;
- one monster/proxy;
- one third-person combat/readability interaction;
- selected pixel rendering treatment;
- responsive phone HUD.

NEXT:
- one complete hunt/harvest/return loop using the accepted presentation.

LATER:
- additional regions, monsters, settlements, factions, relationships, mining, generations and broader story content.

## Creator/debug tooling target

Eventually provide:
- creature/anatomy inspector;
- NPC/relationship inspector;
- time/calendar inspector;
- settlement state inspector;
- encounter preset builder;
- attack/body-part validator;
- harvest simulator;
- item/material/recipe inspector;
- deterministic replay/log viewer;
- save-state inspector;
- stable ID validator;
- performance/debug overlay;
- camera/HUD safe-area debug tools.

## Verification vocabulary

Use distinct states:
- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

Never promote one gate into another without evidence.

Current third-person pixel direction: `DESIGNED` only.
