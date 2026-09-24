# Unnamed Hunt RPG — Content and Data Guide

Status: PLANNING CONTRACT / NO CONTENT PIPELINE IMPLEMENTED
Last reconciled: 2026-09-02

## Purpose

Define how monsters, anatomy, attacks, weapons, equipment, attributes, effects, statuses, terrain, materials, recipes, regions, encounters and deterministic behavior patterns should eventually be authored so the project scales structurally rather than through hard-coded special cases.

## 1. Data-first rule

Reusable gameplay content belongs in validated definitions wherever practical.

Do not hard-code one monster's body-part values directly inside combat UI or animation scripts.

Do not hard-code individual NPC/monster behavior as giant nested scripts when reusable rule data can represent it.

Do not use display names as identity.

Every persistent/referenced content entity receives a stable ID.

## 2. Stable ID families

Recommended prefixes:
- `region_`
- `encounter_layout_`
- `species_`
- `monster_` for runtime instance IDs only;
- `npc_`
- `part_`
- `attack_`
- `behavior_`
- `behavior_rule_`
- `damage_profile_`
- `effect_`
- `status_`
- `terrain_`
- `weather_`
- `weapon_`
- `technique_`
- `armor_`
- `tool_`
- `item_`
- `material_`
- `harvest_`
- `recipe_`
- `cover_`
- `contract_`.

Rules:
- lowercase machine-readable IDs;
- immutable once used by released saves;
- unique globally within their type;
- never recycle a retired ID for unrelated content;
- display names/localization remain separate.

## 3. Species definition

A species definition should eventually include:
- stable species ID;
- display/localization key;
- ecology tags;
- scale/body plan;
- base attributes;
- anatomy definition reference;
- attack list;
- behavior profile;
- movement/terrain capabilities;
- resistances/protection model;
- status interactions;
- harvest source references;
- region/habitat tags;
- presentation references;
- bestiary knowledge stages.

## 4. NPC definition

NPC definitions may eventually include:
- stable NPC/archetype ID;
- display/localization key;
- role/faction;
- base attributes only where gameplay needs them;
- schedule profile;
- behavior profile;
- interaction/dialogue references;
- location/home/work anchors;
- relationship/reputation conditions;
- quest/event references;
- presentation references.

NPC autonomy uses deterministic schedules/patterns/conditions described in `BEHAVIOR_PATTERN_SYSTEM.md`.

## 5. Primary attribute schema

Current design authority: `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

Current six-role model:
- Might;
- Finesse;
- Agility;
- Endurance;
- Perception;
- Resolve.

Content should store bounded base values. Exact starting ranges/caps are balance data, not hard-coded UI assumptions.

Derived stats should be calculated from authoritative inputs rather than copied redundantly into every content definition.

## 6. Anatomy definition

Each body part should define only mechanically useful detail.

Fields/concepts:
- stable part ID;
- display/localization key;
- parent ID;
- children;
- part category;
- targetable flag;
- breakable flag;
- severable flag;
- base integrity/structure;
- break threshold/rules;
- sever threshold/rules;
- armor/hide/bone/tissue layers only if used by mechanics;
- exposure rules;
- functional capability tags;
- damage modifiers;
- harvest source references;
- visual target/attachment references later;
- severed-object presentation reference later.

Avoid anatomy detail that neither combat nor harvesting uses.

## 7. Attack definition

Attack data should describe both legality and consequence.

Potential fields:
- attack ID;
- owner species/weapon category;
- capability requirements;
- valid range bands;
- valid bearings;
- AP/stamina costs;
- accuracy profile;
- relevant attribute contribution map;
- damage profile;
- break/sever contribution;
- effect/status application references;
- target constraints;
- telegraph definition;
- reaction opportunities;
- cooldown/usage constraints if adopted;
- behavior-pattern tags/compatibility;
- presentation references.

Behavior rules can request an attack, but attack legality remains owned by the combat domain.

## 8. Weapon definition

Potential fields:
- weapon ID;
- family/class;
- base damage profiles;
- reach/range;
- handling/accuracy profile;
- break/sever efficiency;
- available techniques;
- AP/stamina behavior;
- block/parry capability;
- effect references;
- terrain/environment compatibility if needed;
- harvest interaction only if intentionally designed;
- upgrade path reference;
- presentation/audio references;
- equipment requirements.

Weapon identity should come from tactical differences, not only larger numbers.

## 9. Armor/equipment definition

Potential fields:
- equipment ID;
- slot/category;
- protection/resistance channels;
- burden/weight behavior;
- capability grants/removals;
- effect-definition references;
- conditional traits;
- status/environment resistances;
- equipment requirements;
- upgrade path;
- presentation references.

Equipment effects use the shared effect/modifier system rather than custom per-item scripts.

## 10. Effect definition

Reusable effects can support equipment, status, terrain, weather, posture and creature traits.

Potential fields:
- effect ID;
- target selector;
- stat/effect key;
- operation (`FLAT`, `PERCENT_ADD`, `PERCENT_MULTIPLY`, `COST_MODIFIER`, `CAPABILITY`, `RESISTANCE`, `THRESHOLD`, `ACTION_RULE`);
- magnitude/value curve;
- condition expression;
- stack group;
- stack rule;
- duration/lifetime when temporary;
- timing hooks;
- resistance channel;
- hard/soft cap;
- tags;
- explanation/localization key;
- debug label.

Validator should reject undefined stat/effect keys, stack rules or illegal operations.

## 11. Status definition

Potential fields:
- status ID;
- category/tags;
- duration model;
- stack group;
- stack behavior;
- maximum intensity;
- application/resistance rules;
- effect references;
- periodic/timing hooks;
- action restrictions/capability changes;
- removal/cure rules;
- terrain/weather interactions;
- visual/audio indicators;
- persistence across encounters if applicable.

Avoid status proliferation before the base combat loop is proven.

## 12. Terrain definition

Terrain gameplay data is separate from decorative meshes/materials.

Potential fields:
- terrain ID/tag;
- movement AP modifier;
- stamina/exertion modifier;
- footing/evasion modifier;
- visibility/concealment behavior;
- tracking behavior;
- actor-size/capability exceptions;
- effect-definition references;
- weather transformation rules;
- audio/footstep profile;
- presentation references.

Examples of reusable tags:
- stable ground;
- mud;
- shallow water;
- rough ground;
- loose gravel;
- brush;
- high ground;
- slope;
- narrow;
- ice;
- ash.

A region uses these shared definitions rather than inventing unique movement math per biome.

## 13. Weather/environment definition

Potential fields:
- weather ID;
- region compatibility;
- intensity tiers;
- visibility effect;
- tracking effect;
- terrain transformations/effects;
- stamina/environmental strain effects;
- behavior-pattern condition tags;
- audio/lighting/VFX references.

Weather only modifies gameplay where explicit effect definitions exist.

## 14. Material definition

Potential fields:
- material ID;
- display/localization key;
- category;
- stack behavior;
- quality model;
- weight/capacity only if inventory rules use it;
- crafting tags;
- trade value later;
- spoilage rules only if adopted;
- provenance/source metadata.

## 15. Harvest source definition

Every harvest source should link physical anatomy to material output.

Potential fields:
- harvest source ID;
- source part ID;
- material ID;
- original anatomical capacity;
- discrete or continuous type;
- minimum condition;
- quality mapping;
- preferred/required tool;
- damage-type penalties;
- clean-sever bonus/preservation rule;
- destroyed-state behavior;
- extraction time/difficulty;
- knowledge requirement if hidden.

Validator invariants:
- capacity cannot be negative;
- source part must exist;
- material must exist;
- unique physical structures cannot output impossible counts;
- destroyed-state rules cannot award an intact unique component unless explicitly justified.

## 16. Recipe definition

Potential fields:
- recipe ID;
- output item/upgrade ID;
- material requirements;
- quantity;
- minimum quality where meaningful;
- prerequisite research/rank;
- service/tool requirement;
- upgrade branch/predecessor;
- presentation references.

Recipes should create hunting goals that correspond to real monster anatomy.

## 17. Region definition

Potential fields:
- region ID;
- biome/theme;
- scene/presentation reference;
- playable bounds/sectors;
- traversal/collision data reference;
- terrain profile references;
- monster habitat/spawn definitions;
- NPC/schedule anchors where relevant;
- camps/safe points;
- gathering definitions;
- track/evidence locations/rules;
- encounter layout references;
- hazards;
- weather/time profiles;
- exits/connections;
- audio/lighting profile.

The render scene is not the sole source of traversal or encounter rules.

## 18. Encounter layout definition

Potential fields:
- layout ID;
- source region/area tag;
- tactical nodes;
- node adjacency;
- range relationships;
- bearing relationships;
- terrain tags;
- cover nodes;
- elevation;
- hazards;
- escape nodes;
- visual anchors;
- allowed creature scale/categories.

This is how aerial terrain becomes first-person tactical space without duplicating unrelated battle arenas.

## 19. Behavior profile

Detailed authority: `BEHAVIOR_PATTERN_SYSTEM.md`.

Species/NPC behavior is authored as explicit deterministic patterns, not AI scoring.

Potential fields:
- behavior profile ID;
- valid actor types/species;
- initial state/phase;
- schedule reference for NPCs where relevant;
- behavior rule list;
- phase transitions;
- bounded pattern memory fields;
- tie policy;
- seeded variation groups only where explicitly used.

A `BehaviorRule` may contain:
- rule ID;
- required behavior state;
- conditions;
- priority;
- cooldown;
- capability requirements;
- forbidden statuses;
- range/bearing/terrain requirements;
- action request reference;
- state transition;
- debug explanation key.

Behavior still operates only through normal legal domain actions.

## 20. Knowledge/bestiary stages

Content should support staged knowledge.

Possible levels:
- unknown;
- observed;
- identified;
- researched;
- mastered.

Each stage can reveal subsets of:
- species name;
- habitat;
- tracks;
- anatomy labels;
- weaknesses;
- attack tells;
- behavior patterns;
- harvest sources;
- preferred hunting methods.

## 21. Asset/content linkage

Data references assets through stable resource keys/paths appropriate to the selected engine.

Examples:
- species model/rig;
- animation set;
- body-part target anchor;
- damage visual variant;
- severed part mesh;
- material textures;
- sounds;
- VFX;
- UI icon.

Missing presentation assets should be caught by validation for production content, but domain tests should not require heavyweight rendering assets.

## 22. Content validation pipeline

Before content enters a playable build, validators should check:
- duplicate IDs;
- broken references;
- anatomy cycles;
- missing parents;
- invalid thresholds;
- attack requiring nonexistent capability;
- effect referencing nonexistent stat/channel;
- invalid stack groups/rules;
- status with invalid timing hooks;
- terrain with invalid effect reference;
- behavior rule referencing nonexistent state/action/capability/status/terrain;
- unreachable behavior states where detectable;
- harvest source missing anatomy/material;
- recipe missing material/output;
- region missing terrain/encounter references;
- impossible quantities;
- missing required production presentation references;
- save compatibility implications for changed released IDs.

## 23. Content package rule

A new monster is not complete because its model exists.

Minimum monster package eventually includes:
1. species definition;
2. base attributes;
3. anatomy graph;
4. targetable parts;
5. attacks;
6. deterministic behavior profile/rules;
7. resistances/status interactions;
8. terrain capabilities;
9. harvest sources;
10. knowledge/bestiary data;
11. visual model/rig;
12. body target anchors/collision volumes;
13. damage/sever presentation references;
14. animation set;
15. audio cues;
16. validation tests;
17. at least one encounter test.

## 24. First-slice content limit

The first vertical slice should intentionally contain:
- 1 region;
- small reusable terrain tag/effect set;
- 1 weather state with no or limited mechanics unless needed;
- 1 monster species;
- 1 monster instance flow;
- 1 deterministic monster behavior profile;
- 1 weapon family;
- small equipment set;
- 6–8 meaningful targetable parts;
- small attack set;
- small status set;
- small material set;
- 1–3 recipes, with at least one upgrade needed for the loop;
- small set of cover/hazard definitions.

Do not build a content factory before these definitions survive real gameplay and target-device testing.