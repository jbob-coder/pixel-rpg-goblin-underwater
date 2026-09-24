# Unnamed Hunt RPG — Stats, Attributes, Equipment, Status and Terrain System

Status: DESIGN DECISION + BALANCE CANDIDATES / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define one coherent numerical/effect framework so player attributes, equipment, injuries, statuses, terrain, weather, posture, cover and tactical conditions all have real mechanical consequences without becoming scattered special-case code.

The system must be:
- bounded;
- explainable;
- deterministic/reproducible where possible;
- data-driven;
- inspectable in Admin tools;
- testable without rendering;
- resistant to modifier stacking bugs;
- meaningful enough that gear/terrain/status choices change tactics.

## 1. Central law: one modifier pipeline

All gameplay effects feed a shared contextual evaluation pipeline rather than each feature editing unrelated values directly.

Conceptual flow:

```text
BASE ACTOR / WEAPON / ACTION DATA
        ↓
PERMANENT PROGRESSION
        ↓
EQUIPMENT
        ↓
PERSISTENT INJURIES / ANATOMY
        ↓
CURRENT STATUS EFFECTS
        ↓
POSTURE / DEFENSIVE STATE
        ↓
TERRAIN / ELEVATION / FOOTING
        ↓
WEATHER / ENVIRONMENT
        ↓
COVER / RANGE / BEARING / EXPOSURE
        ↓
ACTION-SPECIFIC MODIFIERS
        ↓
TARGET-SPECIFIC PROTECTION / RESISTANCE
        ↓
CAPS / CLAMPS / LEGALITY
        ↓
FINAL EXPLAINABLE RESULT
```

Every important calculated result should be able to produce a breakdown for Admin/debug tools and, where useful, simplified player-facing explanations.

## 2. Locked design principles

- Attributes create tendencies, not automatic victory.
- Equipment is a major source of combat identity.
- Tactical position/anatomy/terrain remain important even with strong equipment.
- Action Point economy must not scale wildly from attributes or gear.
- A player cannot stack unlimited bonuses from duplicate sources.
- Status effects use explicit stacking rules.
- Terrain/weather effects use reusable tags and modifiers.
- No hidden UI-only bonuses.
- No generic random critical-hit system is required; strong hits should primarily come from positioning, target condition, technique and hit quality.
- Exact numbers remain balance candidates until the first vertical slice is playable.

# 3. Core player attributes

Recommended first design uses six primary attributes. The names can still be renamed with the setting, but their mechanical roles should remain separated.

## 3.1 Might
Represents force production, leverage and physical power.

Potential effects:
- heavy-weapon handling;
- blunt/impact contribution;
- break/stagger contribution;
- guard stability with suitable equipment;
- carrying/crafting-tool requirements where meaningful;
- some physically demanding interactions.

Might should not directly make precision attacks more accurate.

## 3.2 Finesse
Represents controlled weapon technique and precise physical execution.

Potential effects:
- precision attack effectiveness;
- cutting/sever efficiency with suitable weapons;
- weapon handling;
- difficult body-part targeting contribution;
- parry/technique requirements;
- reduced penalties for complex techniques.

Finesse should not replace Perception for actually identifying/readily seeing targets.

## 3.3 Agility
Represents movement speed, balance and rapid repositioning.

Potential effects:
- initiative contribution;
- dodge effectiveness;
- tactical reposition cost modifiers within strict caps;
- recovery from off-balance;
- footing on difficult terrain;
- some reaction effectiveness.

Agility should not create unlimited extra turns/AP.

## 3.4 Endurance
Represents sustained exertion and physical resilience.

Potential effects:
- maximum stamina;
- stamina recovery;
- exhaustion resistance;
- environmental strain resistance;
- some bleed/toxin/physical status tolerance where appropriate;
- long-hunt sustain.

Endurance may contribute modestly to health, but armor and tactical defense should still matter.

## 3.5 Perception
Represents sensory awareness, target reading and tracking skill.

Potential effects:
- tracking clue interpretation;
- ranged/precision target acquisition;
- body-part identification when knowledge allows it;
- telegraph readability;
- detecting concealed/ambush threats;
- inspection effectiveness;
- reducing some visibility penalties.

Perception does not magically reveal undiscovered bestiary knowledge.

## 3.6 Resolve
Represents composure, pain tolerance and resistance to disruption.

Potential effects:
- stagger/shock resistance;
- fear/panic resistance if those statuses exist;
- concentration under pressure;
- maintaining aim/guard after disruption;
- some recovery from severe negative combat states.

Resolve should not simply duplicate Endurance.

# 4. Attribute scale and caps

Recommended implementation model:
- store primary attributes as bounded integers;
- suggested internal design range: `1–100`;
- ordinary trained humans/hunters occupy a narrower practical band;
- content and progression should use soft ranges well below the hard cap;
- reaching the hard cap should be unusual and not required for normal content.

Exact starting values and growth rates are OPEN until combat testing.

Important rule:
A 20% attribute advantage should create a meaningful edge, not multiply total damage by 20% across every system.

Use attributes as one input among weapon, action, target, terrain and condition factors.

# 5. Derived combat stats

Derived stats should be computed from authoritative sources rather than independently leveled unless later justified.

Candidates:
- Max Health;
- Max Stamina;
- Stamina Recovery;
- Initiative;
- Accuracy/Targeting contribution;
- Evasion;
- Guard Stability;
- Stagger Resistance;
- Carry Capacity if used;
- Tracking Rating;
- Inspection Rating;
- Harvest Skill/Recovery efficiency if progression adopts it;
- specific status tolerances;
- environmental strain tolerance.

## 5.1 Action Points

Action Points are strategically dangerous to scale because one extra AP can equal an entire additional action.

Locked principle:
- AP has a small fixed baseline;
- attributes do not provide unlimited AP scaling;
- rare gear/perks may affect AP only through tightly capped rules;
- temporary AP manipulation must be visible, testable and capped.

Suggested first-slice candidate:
- fixed small AP budget per turn;
- no permanent attribute-based AP increase during the first prototype.

## 5.2 Reaction resource

Same principle as AP:
- small fixed baseline;
- usually refreshed by turn/round rules;
- rare modifiers affect cost/availability rather than creating many extra reactions.

# 6. Weapon and attack contribution

Final attack behavior is not `attribute = damage`.

Conceptually:

```text
AttackResult =
Weapon Base Profile
+ Technique Profile
+ Relevant Attribute Contribution
+ Position / Exposure / Hit Quality
+ Equipment Effects
+ Status / Terrain Context
- Target Protection / Resistance
```

Examples:
- heavy hammer strike: Might matters strongly, Finesse less;
- surgical tail sever: Finesse + weapon cutting profile + exposure matter strongly;
- ranged eye shot: Perception + weapon accuracy + range + visibility matter;
- defensive bash: Might + guard equipment + posture may matter.

Each technique declares which attributes it uses and at what bounded contribution.

# 7. Equipment effect model

Equipment may provide different categories of effects instead of only `+damage`.

## 7.1 Base equipment properties

Weapon examples:
- base damage profile;
- cutting/piercing/blunt distribution;
- reach/range;
- accuracy/handling;
- break/sever efficiency;
- stamina/AP costs;
- guard/parry support;
- status application where appropriate;
- terrain/environment compatibility;
- technique list.

Armor examples:
- physical protection profile;
- coverage;
- weight/burden;
- mobility penalty;
- elemental/environment resistance if setting supports it;
- stagger resistance;
- status resistance;
- special conditional traits.

Tool examples:
- tracking bonus;
- harvesting recovery;
- trap effectiveness;
- environmental interaction;
- status treatment;
- material preservation.

## 7.2 Equipment modifier types

Standard modifier families:
- `FLAT` — adds/subtracts fixed value;
- `PERCENT_ADD` — additive percentage within a category;
- `PERCENT_MULTIPLY` — rare multiplicative modifier;
- `CONDITIONAL` — active only when explicit conditions are true;
- `COST_MODIFIER` — changes AP/stamina/ammo/tool cost within caps;
- `CAPABILITY` — grants/removes a defined capability;
- `RESISTANCE` — modifies a defined damage/status/environment channel;
- `THRESHOLD` — changes a threshold such as stagger/break resistance;
- `ACTION_RULE` — modifies a specific technique/action in a bounded way.

Avoid arbitrary executable scripts embedded in gear data.

# 8. Modifier stacking rules

Every modifier requires:
- source ID;
- target stat/effect key;
- operation;
- magnitude;
- stack group;
- stack rule;
- conditions;
- duration if temporary;
- priority/order where necessary;
- cap/clamp.

Supported stack policies should be explicit:
- `STACK` — allowed to add with other valid sources;
- `UNIQUE_SOURCE` — same source cannot duplicate itself;
- `HIGHEST_ONLY` — strongest value in group wins;
- `LOWEST_ONLY` — strongest penalty in group wins;
- `REFRESH_DURATION` — reapplication refreshes time but not intensity;
- `STACK_INTENSITY_CAPPED` — intensity stacks to a defined maximum;
- `REPLACE` — new effect replaces old effect in same group.

No status/equipment effect may silently choose its own stacking behavior in UI code.

# 9. Recommended caps

Exact values are balance candidates, but architecture requires caps from day one.

Suggested first-slice guardrails:
- derived accuracy/evasion final probability never reaches guaranteed success/failure from ordinary modifiers alone;
- movement/AP cost reductions have a minimum floor;
- stamina-cost reduction has a minimum floor;
- status resistance has a maximum ordinary cap below complete immunity unless an explicit immunity capability exists;
- equipment percentage bonuses in the same stack group have a defined maximum;
- action speed/initiative does not grant repeated turns without explicit turn-system support;
- negative movement effects cannot reduce legal movement cost below/above impossible bounds;
- harvest efficiency cannot exceed anatomical remaining capacity;
- damage reduction cannot make damage negative;
- body-part integrity cannot exceed max or drop below normalized minimum state;
- duplicate unique capabilities do not stack.

Numerical cap values will be frozen only after the first combat balance pass.

# 10. Status effect architecture

Statuses are data-driven definitions plus runtime instances.

`StatusDefinition` may include:
- stable status ID;
- category/tags;
- duration model;
- stack group/rule;
- maximum intensity;
- application conditions;
- resistance channel;
- modifiers;
- periodic effects;
- action restrictions/capability changes;
- cure/removal rules;
- terrain/weather interactions;
- presentation indicators;
- persistence rules.

`StatusInstance` stores:
- source ID;
- target actor/part;
- remaining duration;
- current intensity/stacks;
- applied-turn/order metadata;
- any bounded deterministic state needed by the effect.

# 11. Status categories and examples

The final list should stay small at first.

## 11.1 Physical condition
- Bleeding — periodic health loss / tracking evidence; anatomy-aware where useful.
- Wounded — contextual penalty tied to injury rather than generic damage.
- Exhausted — reduced stamina recovery / increased exertion cost.
- Staggered — temporarily disrupts action/reaction options.
- Off-Balance — worse dodge/guard/reposition until recovered.

## 11.2 Environmental
- Wet — affects footing/temperature and only interacts with elemental systems if the setting later supports them.
- Mud-Caked — movement/footing burden; may alter tracking/visibility.
- Chilled — stamina recovery/exertion penalties if cold regions use temperature.
- Overheated — stamina/exertion penalties if heat regions use temperature.
- Poisoned/Toxined — bounded periodic or stat effect with explicit resistance/cure rules.

## 11.3 Tactical positive states
- Braced — improved stability/guard; reduced mobility.
- Focused — improved next precision/inspection action; may cost AP/time.
- Aimed — ranged/precision preparation state that can be broken by movement/damage.
- Concealed — conditional detection/targeting state from terrain/behavior.
- Guarded — active defensive posture with clear costs/benefits.

## 11.4 Psychological only if setting uses them
- Shaken;
- Fear;
- Panic.

These are optional until tone/design confirms them.

# 12. Status timing and event hooks

Status logic must run at standardized points to avoid order bugs.

Potential hooks:
1. `ON_APPLY`;
2. `TURN_START`;
3. `BEFORE_ACTION_VALIDATION`;
4. `BEFORE_ACTION_RESOLUTION`;
5. `ON_HIT / ON_DAMAGE`;
6. `AFTER_ACTION`;
7. `ON_MOVE`;
8. `TURN_END`;
9. `ENCOUNTER_END`;
10. `ON_REMOVE`.

The engine must define a stable processing order. Presentation never executes status damage independently.

# 13. Terrain system

Terrain is authoritative gameplay context, not just visuals.

A tactical/exploration surface or node may carry reusable tags such as:
- `STABLE_GROUND`;
- `ROUGH_GROUND`;
- `MUD`;
- `SHALLOW_WATER`;
- `DEEP_WATER`;
- `SAND`;
- `LOOSE_GRAVEL`;
- `ROOTS`;
- `ICE`;
- `ASH`;
- `BRUSH`;
- `HIGH_GROUND`;
- `LOW_GROUND`;
- `SLOPE`;
- `NARROW`;
- `COVER_PARTIAL`;
- `COVER_FULL`;
- `EXPOSED`;
- `HAZARD`;
- other biome-specific tags later.

Do not create a new hard-coded code path for every region.

# 14. Terrain effects

Terrain can modify only explicit mechanics.

Examples:

### Mud
- increased movement AP/stamina cost;
- reduced dodge/reposition effectiveness;
- heavier actors may be affected differently if size/mass rules justify it;
- creates/retains tracks well;
- may combine with rain/weather.

### Shallow water
- increased movement cost;
- can reduce/alter tracks;
- splashing/noise can affect concealment;
- may reduce some fire effects only if such systems exist;
- large creatures may ignore some penalties through capability tags.

### Loose gravel
- footing penalty;
- some movement can generate noise;
- steep gravel can make retreat/reposition harder.

### Brush
- visual concealment;
- can obstruct some ranged targeting;
- can hide tracks or provide tracking clues;
- may be unusable as concealment for very large creatures.

### High ground
- changes line of sight/exposure;
- may improve some ranged/inspection contexts;
- does not automatically grant a generic damage multiplier.

### Narrow ground
- restricts movement/node adjacency;
- can limit large-monster attack options;
- can create tactical chokepoints.

### Ice
- higher risk/cost for rapid movement;
- agility/balance can mitigate within caps;
- some large/stable creatures may resist through locomotion capability.

# 15. Terrain resistance / locomotion capabilities

Actors can have terrain-related capabilities:
- `SURE_FOOTED`;
- `MUD_RESISTANT`;
- `SWIMMER`;
- `CLIMBER`;
- `ICE_ADAPTED`;
- `BURROWER`;
- `LARGE_BODY_IGNORES_LIGHT_BRUSH`;
- etc.

Capabilities reduce or alter terrain rules but should be explicit in species/equipment definitions.

# 16. Weather/environment layer

Weather only matters mechanically when an explicit rule exists.

Candidate effects:

### Rain
- reduces visibility at range;
- changes track freshness/readability;
- creates wet/mud conditions;
- affects sound/ambience;
- can modify some terrain tags.

### Fog
- reduces long-range target acquisition/inspection;
- may create approach/ambush opportunities;
- should not make nearby anatomy unreadable.

### Strong wind
- affects ranged attack context;
- changes sound direction/track clue reliability if adopted;
- can alter flying creature behavior patterns.

### Heat/cold
- changes stamina/exertion/environmental strain;
- equipment can provide resistance;
- camps/items can provide recovery.

Weather must not become random punishment with no readable counterplay.

# 17. Terrain + status + equipment interaction examples

Example 1:
Heavy armor + mud:
- armor gives protection;
- armor burden increases movement cost;
- mud adds terrain movement penalty;
- high Endurance reduces stamina impact within cap;
- `MUD_RESISTANT` boots may reduce mud-specific penalty;
- final movement cost is computed once through the modifier pipeline.

Example 2:
Aimed ranged shot in fog:
- weapon base accuracy;
- Perception contribution;
- Aimed status bonus;
- fog range penalty;
- target movement/evasion;
- cover/exposure;
- body-part target difficulty;
- final hit-quality calculation.

Example 3:
Hammer attack against armored horn:
- weapon blunt profile;
- Might contribution;
- heavy technique modifier;
- current stamina/exhaustion;
- target horn armor/structure;
- angle/exposure;
- break threshold;
- resulting part integrity/break state.

Example 4:
Tail sever attempt:
- cutting weapon/sever profile;
- Finesse contribution;
- tail exposure from bearing;
- target movement;
- existing wound/break state;
- status/terrain footing;
- hit result;
- sever progress and actual threshold.

# 18. Resistance model

Separate resistance channels instead of one universal defense number.

Potential channels:
- cutting;
- piercing;
- blunt;
- stagger;
- bleed;
- poison/toxin;
- heat;
- cold;
- environmental strain;
- setting-specific elemental channels only if later approved.

Protection can come from:
- body/anatomy material;
- armor;
- equipment;
- status;
- terrain/posture/cover;
- species capability.

Avoid dozens of resistance types before content needs them.

# 19. Hit quality instead of generic critical chance

Preferred design:
Strong outcomes arise from context.

Possible hit-quality states:
- GRAZE;
- NORMAL;
- CLEAN;
- EXCELLENT/PRECISION.

Factors:
- accuracy versus target difficulty;
- body-part exposure;
- aim/focus;
- range;
- posture;
- movement;
- terrain;
- visibility;
- weapon handling;
- target impairment.

A clean exposed weak-point hit can be powerful because the player created the condition, not because a hidden random `CRIT 5%` fired.

Randomness may still create uncertainty, but outcome bands should be bounded and reproducible with seeded tests.

# 20. Effect definition schema

Conceptual reusable `EffectDefinition`:
- effect ID;
- source type/source ID;
- target selector;
- stat/effect key;
- operation;
- magnitude/value curve;
- condition expression;
- stack group;
- stack policy;
- hard/soft cap;
- duration/lifetime;
- timing hooks;
- resistance channel;
- tags;
- player-facing explanation key;
- debug explanation key.

This same framework can support:
- equipment bonuses;
- statuses;
- terrain modifiers;
- weather;
- posture;
- temporary buffs/debuffs;
- monster traits.

Do not duplicate separate math engines for each source type.

# 21. Calculation trace / explainability

Every major calculation should optionally return a trace in development builds.

Example:

```text
DODGE COST
Base: 2 AP
Heavy armor burden: +1
Mud: +1
Agility mitigation: -0.5
Boot trait Mud Grip: -0.5
Minimum movement cost clamp: 2
Final: 3 AP
```

Or:

```text
TAIL TARGET ACCURACY
Weapon handling: 68
Perception contribution: +8
Aimed: +10
Rear exposure: +12
Fog: -8
Tail moving: -7
Final contextual score: 83
```

Exact formulas/numbers are not locked, but this trace capability is locked.

# 22. Admin / creator tools

The Admin system should eventually provide:
- live base/final stat inspector;
- modifier source list;
- calculation trace;
- status add/remove/intensity controls;
- terrain tag override/test;
- weather override;
- equipment compare preview;
- resistance matrix;
- action-cost preview;
- hit-quality simulator;
- break/sever simulator;
- status stacking simulator;
- cap/clamp warnings;
- invalid circular dependency detection where possible.

Creator mode should edit data definitions, not arbitrary code.

# 23. Testing requirements

Tests must cover:
- modifier order stability;
- cap/clamp behavior;
- duplicate source prevention;
- each stack policy;
- status duration/refresh;
- resistance application;
- terrain tag effects;
- equipment + terrain + status combinations;
- AP/stamina minimum floors;
- hit-quality boundaries;
- break/sever modifier effects;
- save/reload of statuses and equipment;
- deterministic seeded calculations;
- explainability trace matching actual result.

A major bug risk is modifier interaction, so combination tests are required rather than testing each modifier only in isolation.

# 24. Performance rules

- cache derived stats until an input changes;
- do not recalculate the entire equipment/status graph every frame;
- event-driven invalidation on equip/status/terrain/context change;
- action-specific context is calculated when validating/resolving the action;
- use stable IDs/tags instead of expensive dynamic searches;
- unloaded/distant actors do not evaluate full combat modifier contexts;
- Admin traces can be disabled in production builds.

# 25. Locked decisions versus open balance values

## Locked
- one shared modifier/effect architecture;
- six-role attribute model as current design direction: Might, Finesse, Agility, Endurance, Perception, Resolve;
- bounded attributes and derived stats;
- equipment provides tactical effects, not only raw damage;
- AP/reaction scaling is tightly restricted;
- explicit status stack rules;
- terrain/weather can produce real gameplay modifiers;
- anatomy, equipment, statuses, terrain and action context combine through one pipeline;
- no ordinary hidden unlimited stacking;
- development calculation traces are required;
- performance uses cached/event-driven recalculation;
- contextual hit quality is preferred over a generic random crit system.

## Open / to tune through prototype
- exact starting attribute numbers;
- exact attribute hard/soft caps;
- exact formulas/weights;
- exact status list;
- exact equipment slots;
- exact resistance list beyond physical core;
- exact AP/stamina values;
- exact cap percentages;
- whether psychological statuses are used;
- detailed heat/cold system depth;
- final character progression method.

These numerical questions should be tuned only after one real monster, one weapon and one complete encounter can be tested.