# Unnamed Hunt RPG — Master Design Plan

Status: DISCUSSION / DESIGN RECORDED / NO IMPLEMENTATION AUTHORIZED
Last reconciled: 2026-09-02

## 1. Core identity

This is a new game replacing WorldLife in the same project area without inheriting WorldLife gameplay design.

Core loop:
`TRACK → PREPARE → ENGAGE → POSITION → TARGET ANATOMY → BREAK/SEVER → SURVIVE → HARVEST → CRAFT/EQUIP/UPGRADE → HUNT HARDER PREY`

Presentation modes:
1. aerial/top-down angled 2.5D/3D hybrid exploration;
2. first-person turn-based tactical combat.

## 2. Design pillars

- observation, preparation, anatomy knowledge, positioning and equipment matter;
- important body parts have gameplay function;
- break/sever/destroy changes capability and harvest;
- harvest derives from surviving anatomy;
- combat includes movement, terrain, cover, posture, body targeting, tools, reactions and retreat;
- equipment/status/terrain effects are mechanically real and explainable;
- autonomous NPCs/creatures use deterministic authored patterns/conditions, not AI;
- exploration/combat share authoritative actor/world state;
- presentation never decides gameplay outcomes;
- one complete hunt loop is proven before broad expansion.

## 3. Exploration mode

Preferred direction:
- elevated 40–50° dimensional overview;
- fixed/lightly rotatable camera;
- 3D terrain/major geometry;
- selective 2D/billboard/impostor detail for Android efficiency;
- physical traversal;
- readable terrain, elevation, cover, hazards, tracks, gathering, camps and roaming creatures;
- environmental clues before excessive HUD markers.

Candidate systems:
- movement/collision;
- camera pan/limited rotation/zoom;
- region/sector streaming;
- deterministic roaming/schedules;
- tracks/signs;
- gathering;
- terrain/weather effects;
- camps/safe zones;
- hunt objectives;
- hub/town;
- inventory/map/bestiary/quest access;
- encounter initiation preserving world context.

## 4. Encounter transition

Combat derives from exploration state:
- encounter ID/seed;
- exact monster instance/injuries;
- player/party state;
- range/bearing;
- cover;
- elevation;
- terrain tags;
- hazards;
- escape routes;
- relevant weather/time.

The combat monster is not a duplicate with unrelated health/state.

## 5. Turn-based combat actions

Movement/position:
- left/right/forward/back;
- close/create distance;
- flank/circle;
- enter/leave cover;
- climb/descend where legal;
- sprint reposition;
- move toward escape;
- hold.

Posture/defense:
- stand;
- crouch;
- brace;
- guard;
- dodge;
- block;
- parry where legal;
- peek;
- prepare reaction.

Offense:
- basic/quick/heavy/precision attack;
- slash/thrust/blunt;
- ranged/aimed/charged;
- weapon technique;
- select body part;
- target exposed wound/broken armor;
- use terrain/hazard;
- interrupt/contest telegraph where rules permit.

Support:
- inspect/analyze;
- focus/aim;
- recover stamina;
- use item/tool/trap/bait;
- reload where relevant;
- mark target/part;
- interact with environment;
- assist ally if party adopted;
- wait/pass;
- escape.

Reaction candidates:
- dodge;
- block;
- parry;
- brace;
- counter;
- dive to cover;
- protect ally if applicable.

## 6. Action economy

Current prototype candidate:
- small fixed AP budget;
- stamina separate/persistent;
- limited reaction resource;
- heavy actions may consume most/all turn;
- initiative can react to conditions.

Locked constraint:
Attributes/equipment cannot create uncontrolled AP/extra-turn scaling.

Exact values remain open.

## 7. Tactical space

Recommended first implementation:
- nodes/lanes/range bands;
- explicit bearing;
- cover/elevation/terrain tags;
- body-part exposure depends on spatial context;
- first-person camera animates between authoritative positions.

Initial useful-node range candidate: roughly 6–12 per encounter, subject to playtesting.

## 8. Core player attributes

Detailed authority: `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

Current six-role direction:
- Might — force/heavy handling/break/stagger;
- Finesse — precision execution/sever/technique;
- Agility — movement/dodge/initiative/footing;
- Endurance — stamina/sustain/environmental strain;
- Perception — tracking/target acquisition/inspection/telegraph reading;
- Resolve — composure/stagger/shock/fear resistance where used.

Recommended internal bounded scale: 1–100, with actual practical ranges/growth still open.

Derived stats may include health, stamina, recovery, initiative, targeting, evasion, guard stability, stagger resistance, tracking/inspection and status/environment tolerances.

## 9. Shared effect/modifier system

One effect pipeline combines:
`BASE → PROGRESSION → EQUIPMENT → INJURY/ANATOMY → STATUS → POSTURE → TERRAIN/WEATHER → COVER/RANGE/BEARING → ACTION → TARGET DEFENSE → CAPS`

Locked principles:
- explicit stack groups/policies;
- caps/clamps/floors;
- no unlimited duplicate bonuses;
- development calculation traces;
- cached derived stats;
- equipment/status/terrain do not implement independent math engines;
- contextual hit quality is preferred over generic hidden critical chance.

## 10. Equipment

Weapons can define:
- cutting/piercing/blunt profile;
- handling/accuracy;
- reach/range;
- break/sever efficiency;
- AP/stamina behavior;
- guard/parry support;
- techniques;
- status/effect application.

Armor can define:
- protection channels;
- coverage;
- burden/mobility cost;
- stagger/status/environment resistance;
- conditional traits.

Tools can influence tracking, harvest, traps, treatment and environmental interaction.

Equipment should change tactics, not only raise damage numbers.

## 11. Status effects

Statuses are data-driven authoritative runtime states.

Candidate small initial set:
- Bleeding;
- Exhausted;
- Staggered;
- Off-Balance;
- Wet;
- Mud-Caked;
- Poisoned/Toxined if setting uses it;
- Braced;
- Focused;
- Aimed;
- Concealed;
- Guarded.

Cold/heat and psychological statuses remain setting-dependent.

Every status has explicit duration, stack policy, intensity cap, timing hooks, resistance/cure and effect definitions.

## 12. Terrain and weather

Terrain is mechanical context, not decoration.

Reusable tags can include:
- stable/rough ground;
- mud;
- shallow water;
- sand/gravel;
- roots/brush;
- high/low ground;
- slopes;
- narrow terrain;
- ice/ash;
- cover/exposed/hazard.

Effects may change movement AP/stamina, footing/evasion, visibility/concealment, tracks, legal movement and actor-size interactions.

Weather only matters mechanically through explicit rules:
- rain can create wet/mud and alter visibility/tracks;
- fog affects long-range acquisition;
- wind affects ranged/flying contexts;
- heat/cold can affect stamina/environmental strain.

Weather must provide readable counterplay rather than arbitrary punishment.

## 13. Monster anatomy

`MonsterDefinition` contains species ID, base attributes, behavior profile, attacks, anatomy, resistances, capabilities, ecology and harvest definitions.

`MonsterInstance` contains stable instance ID, variant/condition, per-part condition, statuses, behavior phase/pattern memory and persistent injury where relevant.

`BodyPartDefinition` can define integrity, structure, exposure, break/sever rules, function tags and harvest capacities.

`BodyPartState` tracks integrity plus wounded/broken/severed/destroyed state, status, exposure and remaining harvest condition.

Targetable structures may include head, neck, torso, limbs, wings, tail, horns, armor, sensory/special organs where useful.

## 14. Functional anatomy

Examples:
- broken leg reduces movement/escape;
- damaged wing limits/prevents flight;
- severed tail removes tail actions and affects balance;
- broken horn weakens/removes charge/gore;
- damaged eye affects perception/targeting;
- broken armor exposes vulnerable layer;
- damaged breathing structure affects stamina/special attacks.

Capability tags connect anatomy to legal actions and behavior conditions.

## 15. Attack resolution

Sequence:
1. validate actor/resources;
2. validate target/range/exposure/terrain;
3. build contextual stats/effect modifiers;
4. resolve accuracy/evasion/cover/hit quality;
5. resolve armor/structure/resistance;
6. apply part integrity;
7. apply break/sever/destroy;
8. apply wounds/statuses;
9. recompute functional capabilities;
10. update deterministic behavior facts/phase;
11. update harvest condition;
12. emit domain events;
13. consume resources/end action.

Potential physical damage channels:
- cutting;
- piercing;
- blunt;
- environmental;
- setting-specific elemental/energy only if later approved.

## 16. Deterministic NPC/creature behavior

Detailed authority: `BEHAVIOR_PATTERN_SYSTEM.md`.

Locked: no AI behavior system.

Actors use authored patterns made from:
- states/phases;
- `IF / ELSE IF / ELSE` conditions;
- priority;
- cooldowns;
- capability requirements;
- situation flags;
- deterministic/tie policies;
- optional seeded variation groups;
- explicit transitions.

Simple NPCs use few rules and schedules. Hunt monsters use combat/environment/anatomy conditions. Bosses can use layered phases and complex chains, but all decisions remain inspectable/reproducible.

Behavior requests normal domain actions and cannot bypass combat/world rules.

## 17. Cover/environment interaction

Cover can define partial/full directional protection, durability, height, actor-size restrictions, LOS and movement cost.

Environment can include rocks, trees, ruins, ledges, water/mud, hazards, chokepoints, climbable/narrow positions and later breakable terrain.

Rendered geometry must map to mechanical definitions when gameplay depends on it.

## 18. Harvest

Harvest derives from actual anatomy condition.

Conceptual:
`available_yield = anatomical_capacity × remaining_usable_mass × condition × method/tool/skill`

Rules:
- no impossible duplicate unique anatomy;
- clean sever preserves more;
- shattered/burned/crushed parts can lose/change material;
- tools/skill improve recovery but cannot create mass.

Resources may include hide, meat, bone, horn, claw, fang, tail material, tendon, membrane, shell, gland, organ, venom/fluid and rare internal components.

## 19. Crafting/progression

Harvested material may feed weapons, armor, tools, ammo, traps, consumables, upgrades, research and later economy/contracts.

Preferred progression principle:
Equipment + knowledge + mastery matter more than raw level inflation.

Candidates:
- equipment progression;
- weapon mastery;
- tracking/research;
- harvest proficiency;
- hunter rank/reputation;
- selective perks.

Do not let stat growth invalidate anatomy/terrain/positioning.

## 20. Information/research

Knowledge can come from observation, hunts, tracking, research, NPC knowledge, inspection and harvesting.

Unlockable information can include anatomy, resistances, behavior patterns/tells, habitat and harvest methods.

Perception helps interpret information but does not reveal undiscovered facts automatically.

## 21. Visual direction

- grounded stylized wilderness/frontier monster-hunting fantasy;
- illustrated dimensional overview rather than literal paper art;
- strong silhouettes/vertical readability;
- first-person monster scale/anatomy readability;
- coherent 2D/3D lighting/material language;
- touch-readable restrained UI;
- exact gore intensity remains open.

## 22. Architecture laws

`Input/Pattern Intent → Domain Request → Validate/Resolve → Authoritative State + Events → Persistence/Debug → Presentation`

Rules:
- UI/animation do not decide hits/loot/position;
- combat/exploration share persistent actors;
- stable IDs;
- data-driven definitions;
- deterministic logging/seed where useful;
- new save schema lineage;
- shared effect/modifier engine;
- deterministic behavior patterns instead of AI.

## 23. Engine decision

No engine locked.

Candidates:
1. Godot 4.7 + GDScript + Compatibility renderer;
2. LibGDX + Kotlin;
3. native Android stack only if evidence justifies rebuilding engine functionality.

A tiny target-device compatibility probe comes before real gameplay implementation.

## 24. First vertical slice

After explicit authorization only:
- one compact wilderness region;
- aerial exploration;
- one roaming creature using deterministic patterns;
- one encounter transition;
- first-person tactical combat;
- six primary attributes with prototype values;
- shared modifier/effect engine;
- one weapon/equipment set;
- small status/terrain set;
- 6–8 meaningful body parts;
- approved action economy;
- movement + cover + terrain + targeted attacks + defense;
- one break and sever interaction;
- behavior changes from anatomy/status/context;
- condition-based harvest;
- one craft/equipment upgrade;
- save/reload;
- Android verification.

Do not scale large world/bestiary/crafting before this works.

## 25. Open decisions

- permanent name;
- setting/time/technology/magic;
- player role/story;
- solo/party;
- weapon families;
- exact AP/action economy;
- exact starting attribute numbers/growth/caps;
- exact equipment slots;
- exact first status list;
- exact first terrain/weather mechanics;
- behavior complexity of first monster/boss;
- node/range complexity;
- gore intensity;
- harvesting interaction depth;
- progression/failure;
- hubs/contracts/story;
- multiplayer assumed out unless requested;
- engine/Android baseline/controller;
- monetization/distribution assumptions if any.

## 26. Stop condition

No gameplay implementation begins until the user finishes design discussion and explicitly authorizes creation.