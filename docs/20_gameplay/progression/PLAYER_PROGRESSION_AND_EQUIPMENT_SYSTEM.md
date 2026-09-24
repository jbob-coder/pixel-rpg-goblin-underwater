# Player Progression and Equipment System

Status: SELECTED DESIGN DIRECTION + PROTOTYPE TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how the hunter becomes more capable over time without turning the game into a pure level/gear-score treadmill that invalidates anatomy, terrain, preparation, monster patterns or player decision-making.

Primary quality fix:

**power growth is distributed across equipment, mastery, knowledge, preparation and slow bounded base growth rather than concentrated into one endlessly scaling character level.**

The system must preserve:
- meaningful body-part targeting;
- break/sever decisions;
- terrain advantages/disadvantages;
- status/equipment interactions;
- monster-specific preparation;
- harvesting value;
- crafting choices;
- deterministic and explainable stat/effect calculations.

This document works with `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`; it does not replace its modifier pipeline.

---

# 1. Selected progression model

Selected direction:
**HYBRID / EQUIPMENT + MASTERY + KNOWLEDGE WEIGHTED.**

The hunter improves through several bounded vectors:

1. `BASE ATTRIBUTES` — slow long-term growth;
2. `WEAPON MASTERY` — familiarity/technique access and handling improvements;
3. `EQUIPMENT` — largest practical combat-expression vector;
4. `HUNTER KNOWLEDGE` — tracking, anatomy, mutation/crystal and behavior understanding;
5. `HARVEST/CRAFT PROFICIENCY` — better recovery/use of materials without creating impossible yield;
6. `RANK / REPUTATION / ACCESS` — contracts, services, regions and recipes rather than direct combat-stat multiplication;
7. `PREPARATION` — tools, consumables, loadout and environment-specific choices.

No single vector should dominate all others.

---

# 2. Anti-power-creep laws

LOCKED design principles:

- No universal item-level number decides whether equipment is objectively better.
- No exponential damage/health inflation as the primary progression model.
- Early monsters must remain mechanically understandable later; their anatomy cannot become irrelevant because the player outlevels it.
- Strong equipment can improve efficiency but should not remove the need to respect dangerous attacks.
- AP is not a normal progression stat.
- Permanent extra turns/reactions are rare exceptional mechanics, not routine upgrades.
- Equipment bonuses use the shared modifier/cap system.
- Duplicate effects cannot stack without explicit stack rules.
- Progression may reduce penalties or unlock capabilities, but cannot bypass impossible anatomy/harvest constraints.
- One physical tail cannot become multiple intact tails because harvest skill increased.
- Knowledge reveals or interprets information; it does not retroactively alter monster anatomy.
- Rank/reputation unlocks opportunity/access, not hidden universal combat multipliers.

---

# 3. Power budget concept

Treat hunter power as a budget distributed across categories rather than one total score.

Conceptual categories:
- offense;
- defense;
- mobility;
- stamina/sustain;
- targeting/precision;
- break/sever specialization;
- environmental resistance;
- tracking/information;
- harvesting;
- utility/control.

A loadout should usually gain in some categories by spending cost/burden/opportunity in others.

Example:
heavy protective equipment may improve defense/stagger resistance while increasing movement/stamina burden.

A precision hunting set may improve target acquisition and controlled severing while providing less impact protection.

A mud-region loadout may sacrifice generic protection to reduce terrain penalties and preserve stamina.

---

# 4. Base attributes

The six existing attribute roles remain:
- Might;
- Finesse;
- Agility;
- Endurance;
- Perception;
- Resolve.

Progression law:
**base attributes grow slowly and are not the main source of late-game power.**

Prototype direction:
- base attributes can improve through deliberate progression/training/milestones;
- increases should be relatively infrequent;
- attribute growth should stay within a narrower practical human/hunter range even though the technical hard range may be 1–100;
- an attribute increase should improve relevant tendencies rather than multiplying every related stat.

Do not automatically award a large package of attribute points every character level.

Exact starting values, practical soft caps and training rates remain OPEN until the first combat balance slice.

---

# 5. Character level / hunter level

Recommended direction:
avoid making a conventional character level the primary mechanical authority.

If a visible hunter level exists later, it should mainly summarize progression or gate milestone systems rather than directly feeding huge damage/health formulas.

Preferred alternatives/companions:
- Hunter Rank;
- weapon mastery ranks;
- knowledge/research completion;
- equipment capability;
- contract reputation;
- story/access milestones.

A single visible number must never become the hidden owner of every calculation.

---

# 6. Weapon mastery

Weapon mastery represents learned handling and technique familiarity with a weapon family.

It may affect:
- technique access;
- handling penalties;
- stamina efficiency within caps;
- precision windows/requirements;
- guard/parry options where the weapon supports them;
- recovery/reposition efficiency;
- advanced contextual actions.

It should not simply be:
`+5% damage per mastery rank`.

Preferred progression pattern:

`UNFAMILIAR / BASIC`
→ `TRAINED`
→ `PROFICIENT`
→ `ADVANCED`
→ later mastery bands if needed.

Exact names/number of ranks remain OPEN.

Mastery advancement should require meaningful use/training/milestones rather than repetitive low-risk grinding alone.

Anti-grind rule:
repeated trivial actions against irrelevant targets should have diminishing or zero mastery value.

---

# 7. Knowledge progression

Knowledge is a major non-stat power vector.

Knowledge may reveal or improve interpretation of:
- tracks/signs;
- likely territory;
- feeding/resting behavior;
- body-part identity;
- armor/protection observations;
- known break/sever consequences;
- elemental/mutation traits;
- crystal behavior;
- berserk warning signs;
- harvesting requirements;
- known material uses.

Knowledge tiers should control **information quality**, not magically change the underlying creature.

Example progression:

`UNKNOWN`
→ `OBSERVED`
→ `DOCUMENTED`
→ `WELL_STUDIED`
→ `MASTERED/COMPLETE` if a final tier is useful.

Exact labels remain OPEN.

Sources of knowledge can include:
- field observation;
- successful hunts;
- tracking evidence;
- harvested samples;
- settlement researchers;
- contracts/records;
- deliberate inspection actions.

---

# 8. Hunter rank / reputation

Hunter Rank is primarily an access/trust system.

Potential unlocks:
- higher-risk contracts;
- restricted regions;
- specialist services;
- advanced recipes;
- special training;
- improved field-camp support;
- settlement privileges;
- difficult monster licenses/contracts.

Rank should not directly grant generic `+damage`, `+defense`, `+AP` or `+loot` unless an explicit separate reward explains it.

This keeps narrative/social progression distinct from combat math.

---

# 9. Equipment progression philosophy

Equipment is the largest practical combat-expression vector, but progression is not strictly vertical.

Equipment should improve through:
- new material families;
- better construction;
- specialized properties;
- new technique compatibility;
- better environmental adaptation;
- different protection coverage;
- lower burden for similar protection;
- improved break/sever/handling profiles;
- more specialized utility.

Avoid endless sequence:
`Sword 10 → Sword 20 → Sword 30` with identical behavior.

Preferred progression:
`different tool for different hunt/problem` plus bounded refinement.

---

# 10. Equipment slot architecture

Do not freeze the final UI slot count before prototype usability testing.

Selected logical component families:
- primary weapon;
- head protection/accessory;
- torso protection;
- arm/hand protection;
- leg/foot protection;
- field tool;
- utility/consumable loadout;
- optional accessory/charm/research device only if later justified.

First-slice UI may combine some armor families to reduce complexity.

Important:
logical content components and visible UI slots do not have to be one-to-one.

---

# 11. Equipment properties

Weapons can define:
- damage-channel profile;
- reach/range;
- handling;
- AP/stamina costs;
- break efficiency;
- sever efficiency;
- guard/parry capabilities;
- technique compatibility;
- terrain constraints;
- status/tool interactions.

Armor can define:
- protection by channel;
- body coverage;
- burden;
- mobility/stamina effects;
- stagger stability;
- environmental resistance;
- status resistance;
- conditional capabilities.

Tools can define:
- tracking support;
- trap capability;
- harvest preservation;
- field treatment;
- environmental adaptation;
- camp/support functions.

All effects use the typed modifier system from `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

---

# 12. Equipment quality vs tier vs refinement

Do not overload one rarity field.

Recommended separation:

## Material/Construction Tier
Represents broad technological/material capability band.

## Item Quality
Represents construction quality/condition/stability within that design.

## Refinement/Upgrade Level
Represents bounded improvements applied to the same item/design.

## Variant/Specialization
Represents a different functional branch, not simply a stronger number.

Example:
one monster-derived chest piece may branch toward:
- heavier plate protection;
- lighter articulated protection;
- mud/environment resistance;
- crystal/element resistance later if human crystal technology is approved.

This is more interesting than one linear `+1 → +2 → +3 → +20` path.

Exact tier/quality names remain OPEN.

---

# 13. Upgrade/refinement rules

Refinement must be bounded.

Recommended first principles:
- small number of meaningful refinement steps;
- diminishing returns or escalating material cost;
- refinement cannot erase an item's core tradeoff;
- heavy armor does not become light armor merely through upgrades;
- a blunt weapon does not become a top sever weapon through generic enhancement;
- environmental specialization remains distinct;
- final refinement limits are explicit in data.

Upgrade effects should favor:
- modest efficiency;
- durability/condition if durability is adopted;
- burden optimization;
- handling;
- specialized property improvement;
- technique support;
over pure damage inflation.

---

# 14. Material-to-equipment identity

Monster materials should carry understandable functional identity when practical.

Examples:
- dense horn/bone may support impact/break-oriented components;
- flexible tendon/sinew may support tension/flex systems;
- durable hide/scale may support protection;
- membrane may support light/flexible construction;
- specialized gland/organ materials may support status/elemental tools if setting rules justify it;
- crystal material use by humans remains OPEN until explicitly decided.

Do not create arbitrary recipe outputs unrelated to the harvested source merely to fill a loot table.

The player should often be able to understand why a material is useful.

---

# 15. Crafting recipe architecture

Recipes should reference stable IDs and explicit quantities.

Conceptual recipe definition:
- stable recipe ID;
- output item/design ID;
- required materials;
- quantity per material;
- minimum material quality/condition if relevant;
- service/station requirement;
- knowledge/rank requirement if relevant;
- currency/service cost if economy uses it;
- optional branch/refinement target;
- validation rules.

Crafting consumes real inventory quantities.

No recipe can consume a material that does not exist in the inventory or produce duplicate unique equipment through UI desynchronization.

---

# 16. Harvest proficiency

Harvest proficiency can improve:
- recovery efficiency within remaining anatomical capacity;
- quality preservation;
- reduced waste;
- tool handling;
- identification of usable material;
- extraction of difficult material when condition allows it.

It cannot:
- create material mass;
- recover pristine material from a destroyed unique part;
- duplicate organs/tails/horns;
- ignore required tools/conditions without an explicit capability.

Progression here should make the player more efficient, not violate physical conservation.

---

# 17. Preparation progression

Preparation should remain meaningful throughout the game.

A stronger hunter should still benefit from choosing:
- correct terrain footwear;
- status treatment;
- traps/tools;
- suitable weapon profile;
- protection against known attack channels;
- tracking support;
- enough consumables/resources;
- field-camp configuration later.

Late-game progression must not collapse preparation into one universal best loadout.

---

# 18. Loadout identity / no universal best build

A healthy equipment system should create several viable answers to a problem.

Examples:
- high defense / high burden;
- mobile precision;
- break-focused;
- sever-focused;
- ranged observation/control;
- terrain-adapted;
- status-resistant;
- harvest/preservation-focused support.

No build should dominate every axis simultaneously.

If one item/loadout wins offense, defense, mobility, stamina, terrain resistance and utility at once, it violates the progression quality gate unless it has an exceptional temporary/story reason.

---

# 19. Equipment acquisition

Preferred sources:
- crafting from harvested materials;
- settlement services;
- contract rewards that unlock designs/services rather than replacing crafting constantly;
- research unlocks;
- rare authored discoveries where appropriate.

Avoid primary dependence on randomized colored-loot showers.

Randomness may exist for material condition/variant/ecology outcomes if explicitly designed, but equipment identity should remain understandable and reproducible enough for planning.

---

# 20. Failure/death interaction

Do not decide punitive material loss until the failure/death system is designed.

Current rule:
progression systems must preserve durable player investment unless a later explicit failure model says otherwise.

Avoid accidentally creating:
- permanent loss of rare crafted gear from ordinary defeat;
- irreversible mastery loss;
- hidden attribute degradation;
without a deliberate design decision.

---

# 21. Respec / experimentation

The game should encourage trying equipment and weapon families.

Preferred philosophy:
- equipment can be changed normally;
- mastery specialization may take time but should not permanently trap the player early;
- base-attribute changes should be rarer/more meaningful;
- any irreversible choice must be clearly signaled.

Exact respec mechanics remain OPEN.

---

# 22. Progression pacing structure

A hunt cycle should usually provide at least one meaningful form of progress even when it does not yield a direct equipment upgrade.

Possible progress:
- materials;
- monster knowledge;
- weapon mastery;
- rank/reputation;
- crafting/research unlock;
- settlement/resource access;
- player learning/route knowledge.

This reduces the pressure to inflate raw loot numbers after every hunt.

---

# 23. First-slice progression scope

Do not prototype the entire endgame.

First vertical-slice progression should prove only:
- one weapon family;
- one base Hunter loadout;
- one alternative/specialized equipment decision;
- Monster 01 materials;
- one crafted upgrade or branch;
- at least one knowledge improvement from observation/hunt;
- bounded mastery progression evidence;
- one terrain/equipment interaction;
- one harvest-quality consequence;
- save/reload persistence of progression.

The slice should demonstrate that different progression vectors interact without needing dozens of ranks/items.

---

# 24. Data ownership

Recommended future definitions:
- `AttributeProgressionDefinition` or equivalent bounded progression data;
- `WeaponMasteryDefinition`;
- `KnowledgeEntryDefinition`;
- `HunterRankDefinition`;
- `EquipmentDefinition`;
- `EquipmentVariantDefinition`;
- `RefinementDefinition`;
- `RecipeDefinition`;
- `MaterialDefinition`;
- `HarvestProficiencyDefinition` if kept as its own progression track.

Runtime state stores only mutable progress/current equipment/inventory state.

Definitions own design values and stable IDs.

UI never owns progression truth.

---

# 25. Admin/debug requirements

Future Admin tools should be able to inspect:
- base attributes vs derived stats;
- mastery per weapon family;
- knowledge entries/tier;
- Hunter Rank/access flags;
- equipped items;
- active modifiers from each item;
- burden/protection breakdown;
- recipe eligibility and missing requirements;
- material inventory and source IDs;
- refinement state;
- exact calculation trace for equipment effects.

Useful bounded mutation commands later:
- set mastery for test profile;
- grant/remove item/material;
- set knowledge state;
- set Hunter Rank;
- preview refinement;
- compare two loadouts;
- reset test progression.

Admin commands must preserve structural invariants.

---

# 26. Required tests later

Unit/content validation should eventually cover:
- duplicate progression/item/recipe IDs;
- invalid material references;
- refinement beyond cap;
- illegal duplicate unique capability stacking;
- AP/reaction cap violations;
- crafting without materials;
- crafting duplication;
- harvest progression exceeding anatomical capacity;
- rank/knowledge unlock references;
- save/reload preservation;
- equipment modifier trace consistency;
- loadout swap correctly adds/removes modifiers;
- no stale modifiers after unequip;
- deterministic result with same state/definitions where RNG is not involved.

Balance tests should detect:
- one loadout dominating every category;
- exponential health/damage inflation;
- late gear making terrain effectively irrelevant;
- late gear making anatomy targeting irrelevant;
- mastery grinding on trivial actions;
- refinement erasing equipment identity/tradeoffs.

---

# 27. Quality admission gate for new progression features

Before adding a perk, progression track, equipment rarity layer or upgrade system, answer:

1. What player decision does it create?
2. Which existing progression vector cannot already represent it?
3. Does it create raw power inflation or meaningful specialization?
4. Does it preserve anatomy/terrain/preparation relevance?
5. What are its caps and stack rules?
6. Can Admin tools explain its effect?
7. How is it saved/versioned?
8. What regression test proves it does not duplicate/stack incorrectly?
9. Does it create grind without meaningful decision-making?
10. Can it be omitted from the first slice?

If those answers are weak, do not add the system yet.

---

# 28. Current selected vs open

SELECTED:
- hybrid progression;
- equipment + mastery + knowledge weighted;
- slow bounded base-attribute growth;
- Hunter Rank primarily controls access/trust;
- equipment progression emphasizes specialization/tradeoffs;
- no universal gear score as primary truth;
- no exponential stat treadmill;
- bounded refinement;
- harvest proficiency cannot violate material conservation;
- first slice proves only a small progression loop.

PROTOTYPE TARGET:
- equipment is the largest practical combat-expression vector;
- one weapon family + one meaningful crafted branch/upgrade in first slice;
- mastery ranks remain few/bounded initially;
- progression should produce meaningful non-loot gains after hunts.

OPEN:
- final visible character-level system;
- exact attribute starting/soft-cap values;
- exact mastery rank names/counts;
- final Hunter Rank names/counts;
- exact armor UI slot count;
- exact equipment quality/tier terminology;
- durability/sharpness;
- exact respec system;
- exact failure/material-loss rules;
- final human crystal use;
- exact endgame progression ceiling.

---

# 29. Current gate

`PLAYER_PROGRESSION_MODEL = SELECTED_HYBRID`
`EQUIPMENT_WEIGHT = HIGH / BOUNDED`
`MASTERY_WEIGHT = HIGH / SPECIALIZATION`
`KNOWLEDGE_WEIGHT = HIGH / INFORMATION`
`BASE_ATTRIBUTE_GROWTH = SLOW / BOUNDED`
`HUNTER_RANK = ACCESS_FIRST`
`UNIVERSAL_GEAR_SCORE = NOT PREFERRED`
`EXPONENTIAL_POWER_TREADMILL = REJECTED`
`AP_AS_NORMAL_PROGRESSION_REWARD = REJECTED`
`FIRST_SLICE_PROGRESSION_SCOPE = DEFINED`
`FINAL_NUMERIC_BALANCE = OPEN`
`IMPLEMENTATION = NOT AUTHORIZED`

## Next bounded gameplay piece

After continuity reconciliation, the highest-value dependent packet is:
**Exact Combat Action-Economy Contract** — decide the first-slice AP/reaction structure, action categories, cost rules, movement/cover/reaction timing and anti-loop invariants without yet implementing combat code.
