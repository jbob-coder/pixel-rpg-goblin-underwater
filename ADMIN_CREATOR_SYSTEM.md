# Unnamed Hunt RPG — Admin / Creator / Debug System

Status: DESIGN TARGET / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define an in-game development/admin system that makes creation, balancing, testing and debugging faster without turning UI state into gameplay authority.

This system is for development/creator workflows first. Any player-facing sandbox/editor feature is a separate future decision.

## 1. Core law

Admin tools may inspect and request controlled mutations, but they never become a second game engine.

`ADMIN UI → ADMIN COMMAND → VALIDATE → AUTHORITATIVE DOMAIN/CONTENT SERVICE → RESULT → TEST STATE → UI READBACK`

Intentional debug bypasses must still preserve structural invariants.

## 2. Modes

### Inspector mode
Read-only.

Can view:
- player base/derived/final stats;
- modifier/effect sources;
- region/terrain/weather state;
- monster/NPC instances;
- deterministic behavior profile/rule state;
- anatomy graph/state;
- tactical nodes;
- cover/hazards;
- statuses;
- equipment/inventory/materials;
- knowledge/progression;
- encounter/RNG identifiers;
- performance metrics;
- recent domain events.

### Debug mutation mode
Controlled developer mutations.

Examples:
- set health/stamina/AP;
- set a test attribute value;
- equip/unequip test equipment;
- give/remove item/material;
- apply/remove/set intensity of status;
- override terrain/weather test context;
- teleport to valid region anchor;
- force encounter;
- set monster part condition;
- force break/sever;
- advance/restart turn;
- set knowledge stage;
- spawn validated test actor;
- force/evaluate a specific behavior rule for diagnostic purposes.

### Creator mode
Data/content authoring and validation.

Examples:
- create/edit monster or NPC definition;
- edit base attributes;
- edit anatomy;
- edit attacks/capability requirements;
- edit deterministic behavior patterns/conditions;
- edit effects/statuses;
- edit equipment/terrain/weather definitions;
- edit harvest sources/materials/recipes;
- edit encounter nodes/cover;
- edit region metadata/anchors;
- validate/export content package.

Creator mode edits explicit definitions and does not directly modify released production content without validation/versioning.

## 3. Development-build access

Preferred:
- absent/inaccessible in production builds unless explicitly enabled;
- guarded by development flag/profile;
- obvious DEV/ADMIN indicator;
- separate test save/profile.

## 4. Admin command architecture

Conceptual commands:

`PlayerAdminCommand`
- SetHealth;
- SetStamina;
- SetAttribute;
- GiveItem;
- GiveMaterial;
- EquipItem;
- SetKnowledge;
- TeleportToAnchor.

`EncounterAdminCommand`
- StartEncounterPreset;
- SetTurnActor;
- SetAP;
- ApplyStatus;
- RemoveStatus;
- SetTerrainContext;
- SetPartIntegrity;
- BreakPart;
- SeverPart;
- EvaluateBehaviorNow;
- ForceBehaviorRuleForTest;
- EndEncounter;
- ResetEncounter.

`WorldAdminCommand`
- SpawnMonster/NPC;
- DespawnActor;
- MoveActorToAnchor;
- SetWeather/Time where relevant;
- RevealTrack;
- ResetRegionState.

Every command returns success/rejection, normalized result, warnings, affected IDs and domain events where applicable.

## 5. Stats / modifier debugger

Detailed mechanical authority: `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

Inspector should show:
- base primary attributes;
- progression contribution;
- equipment contribution;
- injury contribution;
- active statuses;
- posture;
- terrain/weather effects;
- cover/range/bearing context;
- action modifiers;
- target protection/resistance;
- cap/clamp operations;
- final derived stat/action result.

Critical requirement: show the same calculation trace the resolver used.

Example:

```text
Movement Cost
Base 2 AP
Heavy armor +1
Mud +1
Agility mitigation -0.5
Mud-grip boots -0.5
Minimum floor applied
Final 3 AP
```

Tools:
- compare two loadouts;
- toggle one modifier source;
- test a cap boundary;
- test duplicate stack group;
- inspect status timing;
- inspect resistance channel;
- export calculation trace.

## 6. Status/effect creator

Fields:
- stable ID;
- target selector;
- stat/effect key;
- operation;
- magnitude;
- condition;
- stack group/policy;
- duration/intensity;
- timing hook;
- resistance channel;
- caps;
- explanation/debug key.

Validation catches undefined stat keys, invalid stack policy, negative/illegal durations, impossible cap relationships and missing references.

Simulation controls:
- apply once;
- stack repeatedly;
- advance turns;
- change terrain/equipment;
- save/reload test;
- compare expected versus actual trace.

## 7. Terrain/weather debugger

Show:
- node/surface terrain tags;
- effective movement cost;
- footing/evasion modifiers;
- visibility/concealment;
- tracking effects;
- actor capability exceptions;
- weather transformations/effects.

Test controls:
- apply/remove terrain tag;
- switch weather/intensity;
- compare different actors/equipment;
- preview resulting legal actions/costs;
- highlight all nodes with selected terrain tag.

## 8. Creature/NPC creator

Creator form can expose:
- stable ID;
- display key;
- role/species;
- body scale where relevant;
- base attributes;
- ecology/role tags;
- behavior profile;
- anatomy for monsters;
- attacks/techniques where relevant;
- statuses/resistances;
- terrain capabilities;
- harvest sources for huntable creatures;
- region/schedule compatibility;
- visual/animation/audio references.

Creature workflow:
1. create draft;
2. assign attributes;
3. build anatomy;
4. validate graph;
5. add attacks;
6. add behavior rules;
7. add effects/resistances/terrain capabilities;
8. add harvest;
9. validate;
10. simulate encounter;
11. spawn in test region;
12. export/version after checks.

## 9. Deterministic behavior pattern editor/debugger

Detailed authority: `BEHAVIOR_PATTERN_SYSTEM.md`.

There is no AI scoring screen.

Editor supports:
- pattern state/phase list;
- explicit condition groups;
- priorities;
- cooldowns;
- range/bearing/terrain requirements;
- capability requirements;
- action request;
- phase transition;
- tie policy;
- seeded variation group only if explicitly used.

Live debugger displays:
- current profile/phase;
- every candidate rule;
- PASS/FAIL per condition;
- cooldown state;
- capability state;
- priority;
- selected rule;
- submitted domain action;
- validation result;
- recent rule history.

Controls:
- set test facts;
- evaluate once;
- step one decision;
- simulate N decision points;
- disable one rule;
- force one rule only for diagnostic testing;
- export deterministic behavior trace.

## 10. Anatomy editor

Support:
- tree view;
- parent/child relationships;
- targetable/breakable/severable toggles;
- integrity/threshold values;
- capability tags;
- harvest capacities;
- visual target anchors;
- per-part test damage.

Validation:
- cycles;
- orphans;
- duplicate IDs;
- impossible thresholds;
- missing visual target refs;
- broken attack/harvest/behavior dependencies.

## 11. Attack editor

Fields:
- ID/name;
- actor/species/weapon association;
- AP/stamina cost;
- range/bearing;
- target rules;
- relevant attribute contributions;
- damage profile;
- required capabilities;
- status/effect references;
- telegraph;
- reaction windows;
- behavior-rule compatibility tags;
- presentation references.

Test buttons:
- resolve once against selected target/context;
- run deterministic repeated simulations where useful;
- show illegal conditions;
- show modifier trace;
- show expected/observed state transitions.

## 12. Harvest simulator

Select:
- species/instance;
- part condition;
- damage history category;
- sever/break/destroy state;
- tool;
- harvesting skill/method;
- knowledge state.

Output:
- recoverable materials;
- quantity;
- quality;
- lost-material explanation;
- invariant warnings.

## 13. Encounter builder

Creator UI can define:
- tactical nodes;
- adjacency;
- terrain tags;
- cover;
- elevation;
- hazards;
- range/bearing;
- escape routes;
- spawn anchors;
- visual mapping.

Views:
- aerial layout;
- first-person preview;
- connectivity graph;
- line-of-sight/cover debug;
- terrain overlay;
- monster-size fit check.

Validation rejects unreachable/contradictory layouts.

## 14. Region debug tools

Overlays:
- traversal bounds;
- collision;
- sector boundaries;
- terrain tags;
- monster territory/path;
- NPC schedule anchors;
- tracking evidence;
- gathering nodes;
- encounter zones;
- tactical cover anchors;
- streaming state;
- behavior update tiers;
- spawn rules.

## 15. Live combat debugger

Display:
- turn/round;
- actor resources;
- attributes/final derived stats;
- legal actions;
- current behavior rule candidates for autonomous actor;
- range/bearing;
- terrain/cover;
- anatomy integrity;
- capabilities;
- statuses;
- pending telegraph;
- modifier trace for selected action;
- RNG seed/sequence marker where used;
- recent events.

Allow pause/step one resolved action at a time.

## 16. Deterministic replay

Capture enough to replay bugs:
- content version/hash;
- encounter definition;
- initial state;
- seed where randomness is used;
- player/admin actions;
- behavior rule evaluations/selected actions or reproducible initial facts;
- modifier/effect-relevant state;
- domain events;
- final state.

## 17. Save inspector

Features:
- schema version;
- object IDs/references;
- invariant validation;
- attribute/equipment/status state;
- behavior state where persisted;
- sanitized diagnostic export;
- duplicate into test slot;
- repair preview;
- never silently modify normal save.

## 18. Performance dashboard

Display bounded metrics:
- FPS/frame time;
- memory;
- active/rendered actors;
- behavior evaluation counts/update tiers;
- loaded sectors;
- engine render metrics;
- particle count;
- audio voice count;
- transition timings;
- hitch markers;
- derived-stat recalculation counts;
- effect/status processing counts.

Isolation toggles:
- particles;
- shadows;
- foliage;
- decals;
- ambient wildlife;
- roaming behavior updates;
- music;
- high-detail monster renderer;
- combat VFX;
- debug proxies;
- calculation tracing.

## 19. Content lifecycle

States:
- DRAFT;
- VALIDATION_FAILED;
- VALIDATED;
- PLAYTEST_READY;
- TESTED;
- APPROVED;
- RELEASED.

Validation does not equal TESTED.

## 20. Import/export

Later creator data should support deterministic text/data export suitable for source control:
- human-inspectable where practical;
- stable ordering;
- explicit schema version;
- validation before activation;
- no arbitrary executable scripts in content by default.

## 21. Undo/rollback

Creator edits need draft state, undo/redo where practical, explicit save/export, versioned content and source-control rollback.

Runtime mutations can use reset/reload test-state actions rather than unlimited undo.

## 22. Safety against accidental corruption

- separate dev profile;
- destructive commands explicit;
- creator content validates before activation;
- stable released ID edits trigger migration warnings;
- opening inspectors never mutates state.

## 23. Highest-value creation workflow

`DEFINE → VALIDATE → SPAWN TEST → INSPECT → SIMULATE/PLAY → TRACE RULES/MODIFIERS → IDENTIFY ROOT CAUSE → EDIT DATA → REVALIDATE → REPLAY`

This avoids rebuilding hard-coded source for every numerical/content change.

## 24. Build order

Do not build the giant editor first.

Recommended sequence:
1. read-only state/stat/modifier inspector;
2. performance/debug overlay;
3. bounded encounter preset loader;
4. anatomy/part debug controls;
5. behavior-rule trace viewer;
6. status/effect/terrain test controls;
7. harvest simulator;
8. content validators;
9. simple definition editors;
10. visual encounter-layout editor;
11. broader region/content creation tools.

Creator UI follows validated domain/content schemas; it does not define gameplay rules.