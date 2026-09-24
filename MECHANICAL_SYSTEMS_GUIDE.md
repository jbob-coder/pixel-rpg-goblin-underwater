# Unnamed Hunt RPG — Mechanical Systems Guide

Status: DESIGN CONTRACT / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how the game's mechanics behave and connect. It is not source code. It prevents future implementation from becoming a collection of disconnected features.

Central law:

`WORLD STATE → PLAYER OR AUTHORED PATTERN DECISION → VALIDATED ACTION → RESOLUTION → AUTHORITATIVE CONSEQUENCE → PRESENTATION → PERSISTENCE`

Autonomous actors use deterministic authored patterns/conditions. There is no AI behavior system.

Every mechanic must identify its authoritative owner, inputs, outputs, invariants and downstream consequences.

# 1. Core gameplay loop

`ACCEPT/PREPARE → ENTER REGION → TRACK → OBSERVE → APPROACH → ENGAGE → POSITION → TARGET ANATOMY → BREAK/SEVER/SURVIVE → MONSTER FLEES OR FALLS → HARVEST → RETURN/PROCESS → CRAFT/UPGRADE/RESEARCH → PREPARE FOR HARDER HUNT`

No individual subsystem should become deeper than the complete loop can support.

# 2. Player state

Authoritative player state can include:
- six primary attributes: Might, Finesse, Agility, Endurance, Perception, Resolve;
- derived health/stamina and other derived stats;
- combat Action Points or equivalent;
- reaction availability;
- current tactical position/bearing;
- equipped weapon/tool/armor;
- consumables/ammunition where applicable;
- statuses/injuries;
- inventory/materials;
- hunter knowledge/bestiary progress;
- progression/mastery/rank once approved;
- world position and current region/hunt state.

Detailed numerical/effect authority: `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

Do not duplicate combat health/stamina/attributes in UI or animation state.

# 3. Shared stats/effects rule

Equipment, statuses, terrain, weather, posture and contextual bonuses use one shared modifier/effect pipeline.

Order concept:

`BASE → PROGRESSION → EQUIPMENT → INJURY/ANATOMY → STATUS → POSTURE → TERRAIN/WEATHER → COVER/RANGE/BEARING → ACTION → TARGET DEFENSE → CAPS`

Rules:
- bounded values;
- explicit stack groups;
- explicit stack policy;
- no unlimited duplicate bonuses;
- AP/reaction scaling tightly capped;
- derived stats cached and invalidated when inputs change;
- development builds can explain every important calculation through a trace;
- tactical hit quality is preferred over a generic hidden critical-hit chance.

# 4. Exploration mechanics

## 4.1 Movement

Exploration is continuous physical traversal from the angled aerial view.

Movement authority owns:
- player world position;
- collision legality;
- traversal surfaces;
- elevation transitions;
- blocked terrain;
- terrain/status/equipment movement modifiers.

Presentation follows authoritative position.

## 4.2 Camera

Camera is presentation, not gameplay position.

Current target:
- elevated angled overview around 40–50 degrees downward;
- restrained movement/zoom;
- exact projection tested later;
- framing prioritizes forward terrain and nearby hunting information.

Rotating/moving camera cannot teleport the player or alter tactical position by itself.

## 4.3 Tracking

Tracking creates information, not merely glowing waypoints.

Evidence may include:
- footprints;
- broken branches;
- scratches;
- dung/shedding;
- blood;
- feeding remains;
- nests;
- calls/noise;
- displaced vegetation;
- territorial markings.

Tracking can reveal direction, freshness, approximate size/species, injury clues, behavior clues and likely destination depending on learned knowledge and Perception/tracking proficiency.

## 4.4 Roaming monsters/NPCs

World actors are authoritative instances, not battle-only portraits.

A roaming monster may own:
- species/variant;
- instance ID;
- region position/path;
- awareness state;
- injuries/body-part condition;
- behavior pattern state;
- hunt relevance;
- persistence requirements.

NPCs can own deterministic schedules/pattern states appropriate to their role.

Detailed behavior authority: `BEHAVIOR_PATTERN_SYSTEM.md`.

## 4.5 Encounter initiation

Combat creates `EncounterState` from actual world context.

Transfer at minimum:
- player state/loadout/statuses;
- monster instance/anatomy state;
- encounter location;
- approach direction/bearing;
- distance;
- tactical cover;
- elevation;
- terrain tags;
- hazards;
- escape routes;
- weather/time modifiers only when mechanically meaningful.

# 5. Tactical combat mechanics

## 5.1 Turn authority

One combat system owns:
- round/turn index;
- initiative/order;
- available action resources;
- reaction resources;
- legal actors;
- action queue/resolution state;
- encounter outcome.

No animation advances the turn independently.

## 5.2 Action economy

Current candidate:
- small AP budget each turn;
- stamina as separate persistent tactical resource;
- limited reaction resource reserved between turns;
- movement/attack/defense/tool actions consume different resources;
- heavy actions may consume most/all of a turn.

Locked principle: attributes/gear do not create uncontrolled extra AP or turns.

## 5.3 Tactical space

First implementation should use authoritative nodes/lanes/range/bearing rather than free real-time FPS locomotion.

A node may define:
- node ID;
- relative position;
- range band;
- bearing/flank relation;
- cover;
- elevation;
- terrain tags;
- occupancy;
- movement cost;
- visibility/exposure;
- escape adjacency.

First-person camera movement represents successful node changes.

## 5.4 Movement actions

Candidate actions:
- step left/right;
- advance;
- retreat;
- close/open range;
- flank/circle;
- move into/out of cover;
- climb/descend where legal;
- sprint reposition;
- move toward escape;
- hold.

Terrain, status, armor burden and Agility can alter movement cost/effectiveness through the shared modifier pipeline.

## 5.5 Cover

Cover is directional and authoritative.

Cover may define:
- partial/full protection;
- protected directions;
- height;
- durability;
- destructibility;
- valid actor sizes;
- line-of-sight effects;
- attack restrictions;
- movement costs.

The rendered rock/tree/wall is not sufficient; mechanical cover requires domain data.

## 5.6 Posture/defense

Candidate states/actions:
- stand;
- crouch;
- brace;
- guard;
- block;
- parry;
- dodge;
- take cover;
- peek;
- prepare reaction.

Posture contributes typed effects only where explicitly defined.

# 6. Attributes and derived stats

Current six-role attribute design:
- Might — force, heavy handling, break/stagger, some guard stability;
- Finesse — precision execution, cutting/sever efficiency, techniques/parry;
- Agility — movement, dodge, initiative, footing/recovery;
- Endurance — stamina/sustain/environmental strain;
- Perception — tracking, target acquisition, telegraph reading, inspection;
- Resolve — composure, stagger/shock/fear resistance where applicable.

Recommended bounded storage model is 1–100 internally, but actual starting ranges/growth are not locked.

Derived candidates:
- Max Health;
- Max Stamina;
- Stamina Recovery;
- Initiative;
- targeting contribution;
- Evasion;
- Guard Stability;
- Stagger Resistance;
- Tracking/Inspection;
- status/environment tolerances.

AP and reaction count remain mostly fixed/strictly capped because they have disproportionate action-economy power.

# 7. Equipment mechanics

Equipment must create tactical identity, not only larger numbers.

Weapons can affect:
- damage type/profile;
- handling;
- reach/range;
- break/sever efficiency;
- AP/stamina cost;
- guard/parry capability;
- techniques;
- status/effect application.

Armor can affect:
- protection channels;
- coverage;
- burden;
- movement/dodge cost;
- stagger/status/environment resistance;
- conditional effects.

Tools can affect:
- tracking;
- harvesting;
- traps;
- treatment;
- environmental interaction.

All bonuses use typed effects with source IDs, stack groups and caps.

# 8. Status effects

Statuses are authoritative runtime state using data-driven definitions.

Initial categories can include:
- physical: Bleeding, Exhausted, Staggered, Off-Balance;
- environmental: Wet, Mud-Caked, Chilled, Overheated, Poisoned/Toxined where supported;
- tactical positive states: Braced, Focused, Aimed, Concealed, Guarded;
- psychological statuses only if later approved by tone/design.

Every status defines:
- duration model;
- stack policy;
- max intensity;
- effect references;
- application/resistance;
- timing hooks;
- cure/removal;
- persistence rules.

Standard timing prevents order bugs: apply, turn start, before action, on hit/damage, after action, on move, turn end, remove.

# 9. Terrain/weather mechanics

Terrain is gameplay context, not decoration.

Reusable tags can include:
- stable/rough ground;
- mud;
- shallow water;
- sand;
- gravel;
- roots;
- brush;
- high/low ground;
- slope;
- narrow terrain;
- ice;
- ash;
- cover/exposed/hazard tags.

Terrain may change:
- AP/stamina movement cost;
- footing/evasion;
- concealment/visibility;
- tracking evidence;
- allowed movement;
- actor-size interactions.

Examples:
- mud increases movement burden and preserves tracks;
- brush provides concealment but may obstruct targeting;
- high ground changes line-of-sight/exposure, not generic damage;
- ice penalizes rapid movement unless mitigated;
- narrow terrain restricts node adjacency/large attacks.

Weather can modify visibility, tracks, terrain state and environmental strain only through explicit rules.

Examples:
- rain → wet/mud, track changes, range visibility penalty;
- fog → long-range acquisition penalty;
- wind → ranged context/flying-pattern conditions;
- heat/cold → stamina/environmental strain with equipment counterplay.

# 10. Targeting and anatomy

Every huntable monster has a stable anatomy graph.

Potential hierarchy:
- body/root;
- torso;
- head;
- neck;
- limbs;
- tail/segments;
- wings/sections;
- horns/antlers;
- armor plates;
- claws/fangs;
- special structures;
- internal harvestable organs where relevant.

Only mechanically meaningful structures become combat targets.

Part state may track:
- integrity;
- wounded;
- break progress/state;
- sever progress/state;
- destroyed state;
- structure/armor condition;
- capability tags;
- exposure;
- harvest capacity/quality.

State distinctions:
- INTACT;
- WOUNDED;
- BROKEN;
- SEVERED;
- DESTROYED.

Targetability can depend on bearing, posture, cover, range, attack type, broken armor, monster phase and visibility/terrain.

# 11. Attack mechanics

Every attack definition eventually specifies:
- stable ID;
- requirements;
- AP/stamina cost;
- range/bearing;
- accuracy/handling;
- relevant attribute contributions;
- damage profile;
- break/sever contribution;
- status/effect application;
- target constraints;
- telegraph/reaction;
- presentation references.

Resolution:
1. validate actor/action/resources;
2. validate target/range/exposure/terrain;
3. build contextual modifier calculation;
4. resolve accuracy/evasion/cover and hit quality;
5. resolve protection/armor/structure;
6. apply integrity damage;
7. apply break/sever/destroy transitions;
8. apply statuses/wounds;
9. update capabilities;
10. update behavior pattern facts/state;
11. update harvest condition;
12. emit events;
13. consume resources/end action.

# 12. Hit quality

Preferred over a generic random critical-hit chance.

Candidate result bands:
- GRAZE;
- NORMAL;
- CLEAN;
- PRECISION/EXCELLENT.

Hit quality derives from weapon handling, attributes, target exposure, aim/focus, range, terrain, movement, visibility and target impairment.

Random uncertainty may exist, but strong outcomes should largely reward created tactical conditions.

# 13. Monster capability dependencies

Monster actions depend on functional capabilities rather than scattered special cases.

Examples:
- tail sweep requires functional tail;
- horn charge requires functional horn/head + locomotion;
- flight requires sufficient wing function;
- pounce requires suitable hind limbs;
- bite requires functional head/jaw;
- venom action may require a gland/organ.

Breaking anatomy changes the legal action set/effectiveness.

# 14. Deterministic NPC/creature behavior

Detailed authority: `BEHAVIOR_PATTERN_SYSTEM.md`.

Behavior is not AI.

Pipeline:
`READ FACTS → EVALUATE AUTHORED CONDITIONS → FILTER CAPABILITIES/COOLDOWNS → PRIORITY/TIE POLICY → REQUEST NORMAL ACTION → RESOLVE`

Condition inputs can include:
- time/schedule;
- weather;
- danger/event flags;
- range/bearing;
- player cover/exposure;
- health/stamina;
- statuses;
- anatomy capabilities;
- terrain;
- escape routes;
- recent pattern/cooldown;
- species temperament;
- phase.

Simple NPCs use few patterns. Complex creatures/bosses can use layered phases and condition chains, but every rule is inspectable and reproducible.

# 15. Telegraphs and reactions

Monster attack patterns should provide readable cues when counterplay requires them.

Telegraph can include:
- posture;
- animation pose;
- sound;
- gaze/facing;
- environmental cue;
- UI cue only when necessary.

Telegraph corresponds to authoritative pending action/phase state.

Reaction candidates:
- dodge;
- block;
- parry;
- brace;
- counter;
- dive to cover;
- protect ally if party play is approved.

# 16. Injury and persistence

Possible persistent consequences:
- limp;
- inability to fly;
- removed tail/horn attack;
- exposed weak point;
- reduced perception;
- altered aggression/pattern selection;
- bleeding/trail evidence;
- easier tracking after escape;
- changed harvest quality.

Architecture must allow surviving monsters to return with injuries if adopted.

# 17. Harvest mechanics

Harvest links to physical anatomy, not generic loot rolls.

Each source may define:
- material;
- source part;
- original capacity;
- discrete/continuous;
- minimum condition;
- quality;
- tool/method;
- damage penalties;
- sever/break preferences;
- extraction time;
- knowledge requirement.

Invariants:
- yield ≤ anatomical capacity;
- one horn cannot produce multiple intact horns;
- destroyed organ cannot produce intact organ reward;
- clean sever can preserve value;
- crushing/burning/shattering can reduce/change recoverable form;
- harvest skill improves recovery, not matter creation.

# 18. Materials, inventory and crafting

Materials use stable IDs/properties.

Crafting consumes real material stacks/quality requirements.

Outputs may include weapons, armor, traps, ammunition, consumables, tools and upgrades.

Crafting should feed hunting strategy: preserve the anatomy needed for desired gear.

# 19. Knowledge / bestiary

Bestiary knowledge is progression, not flavor only.

Potential unlocks:
- anatomy names;
- target weaknesses;
- armor properties;
- behavior patterns/tells;
- habitat/tracking clues;
- harvest sources;
- preferred methods.

Sources:
- observation;
- fighting;
- harvesting;
- NPC research;
- tracks/signs;
- repeated hunts;
- inspection tools/actions.

Perception improves interpretation but does not reveal knowledge never learned.

# 20. Progression

Preferred principle:
Equipment/knowledge/mastery matter more than raw level inflation.

Candidates:
- equipment progression;
- weapon mastery;
- tracking/research proficiency;
- harvesting proficiency;
- hunter rank/reputation;
- selective perks/skills.

Do not implement a stat treadmill that makes anatomy, terrain and positioning irrelevant.

# 21. Failure / retreat

Outcomes can include:
- victory/kill;
- monster escape;
- player escape;
- incapacitation/defeat;
- contract failure;
- interrupted hunt.

Exact penalties remain open.

# 22. World-region mechanics

Region owns/references:
- geometry/traversal;
- terrain tags/effects;
- spawn/ecology;
- monster territories/pattern context;
- NPC schedule anchors where relevant;
- camps;
- gathering;
- tracking evidence;
- encounter tactical features;
- hazards;
- exits;
- weather/time profiles.

Regions should be streamable/sectorized.

# 23. Settlement/hub mechanics

Potential functions:
- contracts;
- crafting/blacksmith;
- harvesting/process services;
- research/bestiary;
- merchants;
- storage/loadout;
- deterministic NPC/story systems;
- training/testing later.

Hub supports the hunt loop rather than becoming an unrelated life simulator.

# 24. UI mechanical rule

UI exposes legal choices and known state.

It must not:
- directly change health;
- grant loot;
- alter body-part state;
- bypass resource costs;
- calculate hidden equipment/status/terrain bonuses independently;
- reveal undiscovered monster data;
- move the player via presentation-only camera tricks.

# 25. Mechanical expansion rule

For every new mechanic, answer:
1. What player decision does this create?
2. Which subsystem owns it?
3. What state is required?
4. Which action changes it?
5. Which stats/effects/terrain can modify it?
6. What invariant prevents impossible results?
7. What other systems consume it?
8. How is it tested?
9. How is it presented/explained?
10. What happens on save/reload?
11. Does it improve the complete hunt loop enough to justify complexity?

If these cannot be answered, the mechanic is not ready for implementation.