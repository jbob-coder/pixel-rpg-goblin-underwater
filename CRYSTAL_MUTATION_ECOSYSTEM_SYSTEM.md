# Unnamed Hunt RPG — Crystal Life-Force, Mutation and Ecosystem System

Status: CORE DESIGN DECISION + EXPANSION PLAN / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how creature life crystals, mutation, elemental affinity, desperation/berserker behavior and ecosystem adaptation fit together as one coherent system.

This document distinguishes:
- **USER-DECIDED CORE** — explicitly requested design;
- **STRUCTURAL DECISION** — implementation architecture chosen to make that design reliable;
- **BALANCE CANDIDATE** — useful proposal that remains adjustable during playtesting.

# 1. User-decided core

The following are current locked design decisions unless the user changes them:

- the ecosystem is strongly shaped by creature mutation;
- creatures contain an internal crystal;
- the crystal is part of the creature's life force;
- a creature can consume crystal energy in desperation to enter a berserker state;
- when the crystal's usable life-force reserve is completely depleted, the creature dies;
- crystals have tiers/ranks;
- crystals have quality;
- crystals have elemental properties;
- these crystal properties must have real gameplay/ecology consequences rather than existing only as loot labels.

# 2. Central model

Every relevant creature can conceptually have a `CrystalCoreState`.

Separate intrinsic crystal identity from temporary resource state.

```text
CrystalDefinition / intrinsic identity
- crystal family/type
- tier
- rank rules
- quality
- elemental profile
- stability rules
- mutation support rules

CrystalCoreState / runtime condition
- current life-force reserve
- maximum life-force reserve
- structural condition/integrity
- current strain
- berserk state
- temporary elemental overload/state
- recovery state
```

Important distinction:

**Tier, rank, quality and element are not the same thing as current energy.**

A high-quality crystal can be nearly empty. A low-quality crystal can temporarily be full. This prevents one vague rarity number from controlling every mechanic.

# 3. Crystal property axes

## 3.1 Tier — evolutionary/potency class

Tier represents the broad ceiling of what the crystal/core can support.

Potential consequences:
- maximum sustainable life-force capacity range;
- maximum mutation complexity/budget;
- maximum elemental output class;
- possible mutation families;
- ceiling for rank development;
- core durability range;
- berserk output ceiling;
- ecological position/rarity.

Tier should not directly guarantee that an individual is stronger in every situation.

A lower-tier creature with excellent adaptation, favorable terrain and a good mutation package can remain dangerous.

Exact tier names/count are OPEN.

Implementation recommendation:
Use stable tier IDs internally and allow setting-specific display names later.

## 3.2 Rank — current development inside a tier

Rank represents how far that particular crystal/core has developed within its tier.

Potential consequences:
- current output capacity;
- current mutation stages unlocked;
- current reserve ceiling within tier bounds;
- elemental technique intensity;
- recovery efficiency;
- possible berserk thresholds/effects;
- harvest/crafting requirements.

Rank can increase through age/growth, survival, ecological adaptation or other setting-specific progression once those rules are chosen.

Tier and rank remain separate so a mature low-tier creature is not identical to an immature high-tier creature.

## 3.3 Quality — purity/stability/efficiency

Quality represents how cleanly and efficiently the crystal operates.

Potential consequences:
- energy conversion efficiency;
- recovery efficiency;
- mutation stability;
- resistance to overload/strain;
- reliability of elemental expression;
- structural durability;
- crafting value;
- chance of mutation defects/instability if that mechanic is adopted.

Recommended internal representation:
- bounded numerical quality, such as 0–100;
- player-facing quality bands can map onto that number later.

This allows fine balancing while keeping UI understandable.

## 3.4 Element — energy expression/affinity

Element determines what kind of energy the core naturally expresses and which environmental/mutation relationships it supports.

Elemental identity may influence:
- creature resistances/vulnerabilities;
- available mutation families;
- attack techniques;
- habitat preference;
- crystal recovery conditions;
- terrain interaction;
- visual/audio effects;
- harvest/crafting properties;
- behavior-pattern conditions.

Exact element roster is OPEN.

Possible families to discuss later:
- neutral/untyped;
- heat/fire;
- cold/ice;
- water;
- earth/mineral;
- wind;
- storm/lightning;
- plant/nature;
- toxin/decay;
- other setting-specific elements.

Do not automatically build a universal `fire > plant > water` damage chart. Element interactions should come from explicit attack/material/terrain/resistance definitions unless a global relationship is intentionally adopted.

## 3.5 Crystal condition — separate from quality

Structural condition is a runtime damage state.

A pristine high-quality crystal can become cracked/damaged during a hunt without its original quality definition magically changing.

Potential states:
- intact;
- strained;
- cracked;
- fractured;
- collapsing/inert after death.

Exact names/rules remain balance candidates.

# 4. Life-force reserve

The crystal owns or supports a creature's finite life-force reserve.

Conceptual fields:
- `core_energy_current`;
- `core_energy_max`;
- `core_energy_recovery_rate`;
- `core_upkeep_cost` if needed;
- `core_strain`;
- `core_condition`.

Locked invariant:

`core_energy_current <= 0 → creature death`

No presentation system or behavior rule may ignore this.

## 4.1 Relationship to body health/anatomy

Do not replace the anatomy system with one crystal health bar.

The body and crystal interact:
- body-part damage changes locomotion, attacks, defense and harvesting;
- severe injury can increase the amount of life-force the core must spend to keep the creature functioning;
- bleeding/organ damage/statuses can create ongoing core drain if explicitly designed;
- broken anatomy remains broken during berserk;
- severed anatomy does not regrow merely because the crystal has energy unless a specific regeneration mutation explicitly allows it;
- catastrophic bodily failure can force rapid core depletion rather than bypassing the life-force rule.

This preserves the core body-part combat design.

## 4.2 Recovery

Recommended design principle:
Crystal energy should not regenerate like a fast combat mana bar.

Possible recovery sources:
- rest;
- food/metabolism;
- sleep;
- compatible habitat exposure;
- elemental environmental energy;
- species-specific feeding behavior;
- other ecological mechanisms later.

Combat recovery should be rare/limited unless a creature specifically has that mutation/ability.

This makes crystal depletion meaningful and ties energy to ecology.

# 5. Berserker / desperation mode

## 5.1 Core rule

A creature can deliberately consume its own life-force reserve when sufficiently desperate.

This is not free power.

The creature is converting remaining survival time into immediate combat capability.

## 5.2 Triggering

Berserk activation is controlled by the deterministic behavior-pattern system.

Possible rule inputs:
- health percentage;
- core energy percentage;
- number/severity of broken parts;
- trapped/no escape route;
- threat to offspring/nest/territory;
- opponent threat level;
- current phase;
- species temperament;
- current statuses;
- previous failed escape attempt;
- rank/tier requirements.

Example conceptual pattern:

```text
IF health_percent <= 30
AND core_energy_percent >= 20
AND no_safe_escape
AND berserk_cooldown_or_once_flag == READY
THEN activate BERSERK
```

Not every species must use berserk the same way.

Some creatures may:
- berserk early;
- berserk only when cornered;
- prefer escape and almost never berserk;
- spend energy in controlled bursts instead of one mode;
- enter a final irreversible overdrive state.

## 5.3 Berserk cost

Potential costs:
- activation energy cost;
- energy drain each turn/action;
- additional drain for high-output elemental techniques;
- core strain accumulation;
- reduced recovery afterward;
- crystal condition damage from overdraw.

The drain must be explicit and inspectable.

## 5.4 Berserk benefits

Potential effects, species-specific and bounded:
- increased physical force;
- increased movement/reposition aggression;
- reduced pain/stagger response;
- improved elemental output;
- new attack patterns;
- shorter attack preparation;
- resistance to some control effects;
- willingness to use dangerous attacks;
- temporary behavior phase change.

Berserk should not simply multiply every stat.

## 5.5 Berserk limitations

Locked principles:
- cannot restore severed parts by default;
- cannot use an attack whose required anatomy/capability no longer exists;
- cannot ignore zero core energy;
- cannot bypass normal action validation;
- does not make the creature immune to terrain, cover or status rules unless an explicit effect says so;
- should visibly/aurally telegraph its state.

## 5.6 Player tactical consequence

Berserk creates a hunt tradeoff:
- continue attacking aggressively and risk a dangerous final phase;
- create distance/cover and let the creature burn its own reserve;
- interrupt high-drain techniques;
- target anatomy needed by berserk attacks;
- force escape conditions;
- preserve valuable crystal structure by avoiding direct core damage where harvesting matters.

This turns the life crystal into a tactical system, not just lore.

# 6. Crystal and death

Death is tied to life-force exhaustion.

A dead creature's crystal can still retain intrinsic properties:
- tier;
- rank/development signature;
- quality;
- element;
- structural condition.

The stored life-force reserve itself is exhausted at true death under the current rule.

This distinction allows the crystal to remain a valuable physical material/artifact after the creature dies without contradicting the life-force rule.

# 7. Crystal harvesting

Recommended system addition:
The internal crystal is a major harvest source, but not automatically a free perfect reward.

Potential harvest outcome depends on:
- crystal tier;
- rank;
- intrinsic quality;
- element;
- structural condition;
- whether surrounding anatomy was destroyed;
- whether the core was directly struck;
- overdraw/berserk strain;
- extraction method/tool;
- hunter knowledge/skill.

Important distinction:
- `quality` = intrinsic quality;
- `condition` = damage suffered;
- `energy_current` = temporary life-force reserve.

A high-quality crystal can be harvested in poor condition if shattered during the fight.

## 7.1 Direct core attacks

BALANCE CANDIDATE:
Do not make the crystal an easy universal instant-kill target.

Preferred approach:
- core is protected/internal;
- exact location may be unknown until research;
- some anatomy may need to be broken/exposed;
- special attacks/tools may reach it;
- direct damage can cause severe core drain/strain;
- shattering the core can ruin or reduce crystal harvest value.

This creates a choice between fastest kill and best harvest.

# 8. Mutation system

Mutation is a major source of ecological variation.

Do not represent mutation as arbitrary random stat inflation.

A mutation should be a defined trait with:
- stable mutation ID;
- family/category;
- prerequisites;
- incompatible mutations;
- anatomy changes;
- stat/effect modifiers;
- capability additions/removals;
- behavior-pattern additions/changes;
- elemental requirements;
- crystal tier/rank/quality requirements;
- ecological triggers/pressure tags;
- presentation changes;
- harvest consequences;
- mutation load/cost if used.

# 9. Mutation categories

Potential categories:

## 9.1 Structural/anatomical
Examples:
- thicker armor plates;
- enlarged horn;
- reinforced tail;
- longer limbs;
- wing changes;
- extra protective tissue;
- specialized claws/teeth;
- crystal shielding anatomy.

## 9.2 Physiological
Examples:
- toxin resistance;
- heat tolerance;
- cold tolerance;
- improved stamina;
- faster wound clotting;
- more efficient core recovery;
- improved night perception.

## 9.3 Elemental
Examples:
- elemental gland/organ;
- elemental coating;
- charged breath/attack;
- terrain-specific energy absorption;
- elemental resistance/conversion.

## 9.4 Behavioral
A mutation can unlock or alter deterministic patterns.

Example:
A burrowing adaptation can add:
`IF threatened AND terrain == SOFT_GROUND → BURROW_ESCAPE`

## 9.5 Sensory
Examples:
- heat sensing;
- vibration sensing;
- improved smell;
- low-light vision;
- crystal-energy sensing.

# 10. Mutation support budget

STRUCTURAL DECISION:
Use a bounded mutation-support concept so high-tier creatures do not accumulate unlimited traits.

Potential model:
- tier defines broad mutation capacity ceiling;
- rank unlocks portions of that capacity;
- quality affects how stably complex mutations can be supported;
- each mutation has a support/load cost;
- incompatible mutations cannot coexist;
- some mutations replace earlier stages rather than stack with them.

This prevents uncontrolled combinatorial growth and keeps creatures readable.

Exact numerical budget is OPEN.

# 11. Mutation progression

Possible progression model:

`BASE SPECIES → ADAPTATION PRESSURE → MUTATION PROGRESS → MUTATION STAGE → STABILIZED TRAIT`

Mutation should generally be gradual enough that ecology remains understandable.

Potential triggers:
- repeated environmental exposure;
- diet/prey source;
- elemental habitat;
- injury survival;
- age;
- competition;
- predation pressure;
- crystal resonance;
- inherited lineage tendencies;
- region-level pressure.

Exact biological/lore mechanism remains to be discussed.

# 12. Ecosystem model

The ecosystem should react to mutation and environment without simulating every creature at full fidelity off-screen.

## 12.1 Region ecological pressures

Each region can define pressure tags/values such as:
- temperature;
- moisture;
- altitude;
- terrain hardness;
- vegetation density;
- prey availability;
- predator pressure;
- toxin/disease exposure;
- elemental saturation;
- crystal resource profile;
- human hunting pressure later.

These pressures influence which mutation profiles are plausible/common.

## 12.2 Population aggregate

Performance-friendly off-screen simulation should use region/species population aggregates rather than thousands of full actors.

Conceptual `PopulationState`:
- species ID;
- approximate abundance;
- age/development distribution;
- tier/rank distribution;
- dominant element profiles;
- common mutation-family weights;
- migration pressure;
- reproductive/recovery pressure if adopted;
- recent hunting pressure;
- major ecological flags.

Fully instantiate individual mutation/anatomy/crystal state only for relevant spawned/persistent creatures.

## 12.3 Mutation distribution

A spawned creature can be created from:
- base species;
- region ecological pressure;
- population mutation distribution;
- allowed mutation definitions;
- crystal tier/rank/quality/element;
- deterministic seed;
- persistent lineage/instance data where applicable.

The result must pass content validation.

# 13. Ecosystem feedback loops

BALANCE/EXPANSION CANDIDATES:

Possible long-term feedback:
- heavy hunting can reduce a species population;
- removal of predators can increase prey;
- survivors with certain mutations can become more common;
- environmental shifts can favor new mutation families;
- elemental events can alter local crystal/mutation profiles;
- migration can introduce new mutation/element combinations;
- overhunting high-rank individuals can alter average population development;
- nests/breeding grounds can affect regional recovery.

Do not implement all of this in the first slice.

First prove that one region can generate coherent, understandable variation without performance or balance chaos.

# 14. Element and habitat connection

Elements should influence ecology rather than existing only in attack damage.

Examples:
- heat-aligned creatures may recover core energy better in volcanic/hot zones;
- cold-aligned creatures may gain footing/stamina advantages in snow/ice;
- water-aligned creatures may exploit rivers/swamps;
- earth/mineral-aligned creatures may develop heavy armor or burrowing patterns;
- storm/wind-aligned creatures may react differently to elevation/weather.

These are examples, not locked universal rules.

Every real effect must be represented through the shared stats/effects pipeline.

# 15. Interaction with stats/equipment/status/terrain

Crystal/mutation effects use the same contextual modifier system as everything else.

A mutation may provide:
- attribute modifier;
- derived-stat modifier;
- resistance;
- immunity/capability;
- terrain adaptation;
- status interaction;
- action modifier;
- life-force recovery modifier;
- berserk modifier;
- attack unlock;
- behavior rule unlock.

Do not implement a separate mutation-math engine.

# 16. Interaction with anatomy

Mutations can change anatomy definitions/profile composition.

Examples:
- reinforced horn changes integrity and harvest capacity;
- armored mutation adds/strengthens a targetable plate;
- wing mutation changes flight capability requirements;
- crystal shield mutation adds protective tissue around core;
- venom mutation adds a gland/harvest source and corresponding attack capability.

The resulting anatomy graph must still pass all structural validators.

# 17. Interaction with behavior patterns

Behavior remains deterministic.

Crystal/mutation facts become conditions/capabilities.

Examples:

```text
IF core_energy_percent <= 15
AND escape_route_available
THEN ESCAPE
```

```text
IF mutation == MUT_ARMORED_CHARGE
AND capability(CAN_CHARGE)
AND range == MEDIUM
THEN CHARGE
```

```text
IF berserk_active
AND core_energy_percent > 5
AND capability(ELEMENTAL_BREATH)
THEN OVERDRIVE_BREATH
```

No opaque AI is introduced.

# 18. Interaction with harvesting/crafting

Crystal and mutation traits can create specific harvest goals.

Examples:
- reinforced scale mutation yields different armor material;
- elemental gland mutation unlocks a special component;
- higher-tier crystal is required for higher-tier equipment architecture;
- quality affects crafting efficiency/reliability or upgrade ceiling;
- element determines compatible crafting effects;
- damaged crystal condition reduces usable crystal material.

Avoid arbitrary loot tables that ignore the monster actually fought.

# 19. Crystal equipment/crafting boundary

OPEN DESIGN DECISION:
Decide later how humans use harvested crystals.

Possible directions:
- power source for weapons/tools;
- socket/core in equipment;
- crafting catalyst;
- settlement energy/technology resource;
- alchemical/research material;
- limited-use elemental charge source.

Do not lock human crystal use until world technology/magic level is decided.

# 20. Visual/audio language

Crystal state should be readable without permanent HUD bars where possible.

Potential cues:
- subtle internal glow through cracks/scales;
- pulse rate;
- elemental color/material response;
- changes in breathing/vocalization;
- berserk flare/veins/particles kept performance-bounded;
- crystal-overload sound;
- fading pulse near depletion;
- distinct fracture sound if core condition worsens.

Presentation reflects authoritative state and never invents core energy changes.

# 21. Bestiary/research

Knowledge can reveal crystal information in stages.

Possible discoveries:
- creature has a crystal core;
- probable element;
- estimated tier;
- known berserk behavior;
- core location/anatomical protection;
- mutation traits;
- crystal extraction method;
- known quality indicators;
- region-specific mutation patterns.

The player should not automatically see exact hidden percentages without sufficient knowledge/tooling.

# 22. Admin/Creator requirements

Future Admin tools should support:
- inspect core tier/rank/quality/element;
- inspect current/max energy;
- inspect core condition/strain;
- force/set energy in test profile;
- activate/deactivate berserk;
- show per-turn/action energy drain;
- inspect berserk rule-selection trace;
- create/edit mutation definitions;
- show mutation prerequisites/incompatibilities/load;
- preview mutation effect on anatomy/stats/behavior/harvest;
- generate deterministic creature variants;
- inspect regional population mutation distribution;
- simulate ecosystem pressure changes;
- validate crystal/mutation content.

# 23. Validation invariants

At minimum validators/tests should enforce:
- core energy cannot exceed max after normalization;
- core energy <= 0 means dead;
- dead creature cannot perform actions;
- berserk cannot spend energy below zero without resolving death;
- berserk cannot restore missing capabilities without an explicit effect;
- mutation prerequisites must exist;
- incompatible mutations cannot coexist;
- mutation load cannot exceed allowed support budget;
- mutation cannot reference nonexistent anatomy/capabilities/statuses/elements;
- elemental references must be valid;
- crystal tier/rank/quality values must be bounded;
- crystal harvest cannot duplicate one physical core;
- direct core damage cannot silently create a second death system inconsistent with energy exhaustion;
- region mutation generation must produce validated creature profiles;
- behavior rules remain deterministic/reproducible under fixed state/seed.

# 24. Performance caps

Do not run full mutation/ecology calculations every frame.

Rules:
- crystal energy updates only when an action/state/environment event requires it;
- behavior rules evaluate at decision points;
- mutation generation happens at spawn/growth/event boundaries, not every frame;
- off-screen populations use aggregate state;
- mutation trait count per individual is capped;
- active elemental VFX are capped;
- ecosystem history/logs use bounded retention;
- Admin ecosystem simulations run as explicit tooling operations, not permanent expensive background loops.

# 25. First vertical-slice limits

For the first playable hunt, deliberately constrain the system.

Suggested scope:
- 1 species;
- 1 crystal element;
- 1 base crystal tier used in play;
- small rank range;
- small quality range/bands;
- 2–4 mutation traits maximum in test content;
- 1 meaningful terrain-linked mutation;
- 1 mutation that changes anatomy or attack capability;
- 1 berserk/desperation pattern;
- visible core-energy drain during berserk in debug tools;
- death at zero core energy;
- crystal harvest with tier/rank/quality/element/condition recorded;
- one crafting/research hook using crystal data only if world premise supports it by then.

Do not begin with dozens of elements, mutation combinations or ecological populations.

# 26. Open decisions

Still discuss:
- exact number/names of crystal tiers;
- exact rank scale;
- quality bands/display names;
- element roster;
- whether secondary/hybrid elements exist;
- how crystal energy normally recovers;
- whether all monsters have crystals or only crystal-bearing life;
- whether humans have crystals;
- whether direct crystal targeting is possible and under what conditions;
- exact effect of crystal fracture;
- exact berserk thresholds/costs/benefits;
- whether berserk can be voluntarily ended;
- how mutations arise biologically/lore-wise;
- inherited mutation rules;
- whether ecosystem changes persist strongly across the campaign;
- how much player hunting can shift mutation/population distributions;
- human uses for harvested crystals;
- economic/social consequences of crystal harvesting.

# 27. Implementation placement

When implementation is authorized, expected ownership is:
- `domain/crystal` — life-force reserve, core condition, berserk energy transactions;
- `domain/mutation` — mutation definitions/runtime trait composition and validation;
- `domain/ecology` — region/population aggregate simulation;
- `domain/behavior` — deterministic rules using crystal/mutation facts;
- `domain/anatomy` — mutation-derived anatomy/capability changes;
- `domain/effects` — all numerical modifiers;
- `domain/harvest` — crystal/mutation harvest consequences;
- `content` — crystal tiers/elements/mutations/ecology profiles;
- `presentation` — crystal/berserk/mutation visuals only;
- `admin` — inspectors/simulators/editors.

Do not create these modules until implementation is explicitly authorized.
