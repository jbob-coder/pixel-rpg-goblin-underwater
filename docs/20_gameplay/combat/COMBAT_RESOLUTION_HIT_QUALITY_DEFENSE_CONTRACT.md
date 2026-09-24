# Combat Resolution / Hit Quality / Defense Contract

Status: SELECTED FIRST-SLICE DESIGN / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define the authoritative resolution path between a committed combat action and the resulting contact, body-part outcome, defense result, protection interaction and hit quality.

Primary quality fix:

**one committed attack must produce one explainable resolution trace instead of layering unrelated accuracy rolls, dodge rolls, critical-hit rolls, cover rolls and anatomy rolls.**

This contract owns:
- attack contact resolution;
- body-part acquisition/exposure;
- directional cover interaction;
- dodge/block/parry/brace resolution boundaries;
- hit-quality classification;
- bounded seeded-randomness boundaries;
- protection/anatomy ordering;
- miss/off-target/deflect outcomes;
- debug/calculation traces.

It does not own:
- AP/RP timing and costs (`ACTION_ECONOMY_CONTRACT.md` owns those);
- final weapon roster;
- final damage numbers;
- one monster's exact attacks;
- animation timing;
- renderer/UI implementation;
- final balance constants.

Supporting authorities:
- `ACTION_ECONOMY_CONTRACT.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `/MECHANICAL_SYSTEMS_GUIDE.md`;
- `/docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md`.

---

# 1. Core resolution law

A combat action resolves through a fixed authoritative sequence.

```text
ACTION ALREADY COMMITTED
        ↓
FREEZE RESOLUTION CONTEXT
        ↓
VALIDATE TARGET / RANGE / BEARING / CAPABILITY
        ↓
VALIDATE TARGET PART VISIBILITY + EXPOSURE
        ↓
APPLY REACTION DECISION IF WINDOW EXISTS
        ↓
RESOLVE MOVEMENT/DEFENSE CONSEQUENCE
        ↓
RESOLVE COVER / LINE OF EFFECT
        ↓
BUILD ATTACK CONTROL SCORE
        ↓
BUILD DEFENSE CONTROL SCORE
        ↓
APPLY ONE BOUNDED SEEDED VARIANCE SAMPLE
        ↓
CLASSIFY CONTACT + TARGET-PART OUTCOME
        ↓
CLASSIFY HIT QUALITY
        ↓
ROUTE THROUGH GUARD/COVER/ARMOR/ANATOMY PROTECTION
        ↓
HAND OFF TO DAMAGE/BREAK/SEVER/STATUS RESOLUTION
        ↓
EMIT DOMAIN EVENTS + FULL TRACE
```

Presentation may visualize these stages but may not reorder or independently reroll them.

---

# 2. Resolution context snapshot

When a committed attack reaches resolution, create an immutable or effectively immutable resolution snapshot containing the values relevant to that attack.

Minimum context:
- action/technique ID;
- attacker ID;
- defender ID;
- selected target group/part if any;
- attacker node/position;
- defender node/position;
- range band/distance;
- bearing/flank;
- elevation relationship;
- attacker posture/state;
- defender posture/state;
- terrain tags for both actors;
- relevant weather/visibility;
- cover relationship and direction;
- attacker attributes/derived combat values;
- defender attributes/derived combat values;
- weapon/technique profile;
- active statuses/injuries affecting the action;
- target-part state/exposure/protection;
- selected reaction result if one was committed;
- deterministic encounter seed + action sequence ID.

Do not allow later animation frames or UI updates to silently change the values after resolution begins.

---

# 3. Hard legality vs contest resolution

Separate **hard legality** from **contested success**.

## Hard illegality examples

The attack does not enter the normal hit contest when:
- attacker lacks the required weapon/capability;
- target no longer exists/is valid;
- range is outside the technique's legal range;
- required line of effect is fully blocked;
- selected target part is structurally impossible to target and the action does not allow body fallback;
- attack requires a capability disabled by anatomy/status;
- reaction moved the target to a position where the attack definition no longer has legal contact and the action cannot track/follow;
- resource/commit validation failed before commitment.

These produce explicit failure reasons, not fake `0% accuracy`.

## Contested resolution

If the action remains legal, the system resolves the attack using attack control, defense control, cover/exposure and one bounded seeded variance source.

---

# 4. Attack control score

`AttackControl` represents how well this committed technique can place its intended contact under the current context.

Inputs can include:
- weapon handling/accuracy profile;
- technique control profile;
- relevant bounded attribute contribution;
- Finesse where controlled weapon placement matters;
- Perception where target acquisition/visibility matters;
- Aim/Focus states;
- range suitability;
- flank/bearing advantage;
- elevation/line-of-sight context;
- attacker footing/terrain;
- attacker injuries/statuses;
- target-part size/exposure;
- visibility/weather;
- explicit equipment modifiers;
- action-specific bonuses/penalties from the shared modifier pipeline.

AttackControl does **not** include raw damage power.

Might should not automatically increase targeting accuracy merely because it increases force.

---

# 5. Defense control score

`DefenseControl` represents the defender's ability to prevent clean contact through movement, posture and contextual difficulty.

Inputs can include:
- Evasion derived primarily from Agility/context;
- active movement state;
- burden/armor mobility penalties;
- terrain footing;
- defender injury/status;
- reaction result;
- body-part movement/exposure difficulty;
- concealment/visibility effects where applicable;
- technique-specific defensive matchup;
- directional context.

DefenseControl does not include armor's ability to absorb damage. Armor/protection occurs after contact classification.

This separation prevents heavy armor from simultaneously making the wearer harder to hit and harder to damage unless the equipment explicitly has both effects.

---

# 6. Body contact vs selected-part contact

A large creature should not be treated as if failing to hit a small selected body part means the attack always misses the entire creature.

Resolution distinguishes:
1. `NO_CONTACT`;
2. `BODY_CONTACT_OFF_TARGET`;
3. `SELECTED_PART_CONTACT`.

A selected body part has a targeting/exposure requirement based on:
- size;
- current angle/bearing;
- movement;
- obstruction by other anatomy;
- cover;
- posture;
- knowledge/identification requirements;
- technique suitability.

If the attack achieves body contact but not enough control for the selected part, the action may become `BODY_CONTACT_OFF_TARGET` when the technique allows fallback.

Fallback behavior must be declared by the technique:
- `ALLOW_BODY_FALLBACK`;
- `REQUIRE_SELECTED_PART`;
- future specialized alternatives if justified.

Precision techniques should commonly use `REQUIRE_SELECTED_PART` or stricter quality requirements so they cannot cheaply convert every failed precision attempt into full normal damage.

For Monster 01, target-group selection must preserve the eight recorded groups without inventing micro-parts in UI resolution.

---

# 7. Exposure state

Target parts use explicit exposure states rather than generic hidden difficulty alone.

First-slice generic states:
- `EXPOSED` — normal targetability from current context;
- `PARTIALLY_EXPOSED` — legal but more difficult / cover or anatomy interferes;
- `OBSCURED` — only suitable techniques/angles can target;
- `NOT_TARGETABLE` — hard illegal from current context.

Exposure can change when:
- actor moves/flanks;
- monster changes posture;
- cover changes;
- a plate/horn/limb breaks;
- another body part is severed;
- a reaction moves the target;
- terrain/elevation changes line of effect.

Breaking dorsal armor, for example, should expose the relevant underlying region rather than applying a magical global defense reduction.

---

# 8. Cover contract

Cover is directional physical context, not a universal percentage buff.

First-slice categories:
- `NO_COVER`;
- `PARTIAL_COVER`;
- `FULL_COVER`.

## Full cover

If the cover blocks the technique's required line of effect to the legal target area:
- normal direct attack is illegal;
- no hit roll is performed;
- attack can proceed only if the technique explicitly supports penetration, arcing, area effects, destruction or another legal interaction.

## Partial cover

Partial cover can:
- mask specific target groups;
- lower their exposure state;
- increase control requirement;
- physically intercept an attack when the contact path overlaps the cover object;
- remain irrelevant to body areas that are genuinely exposed.

Do not give a leg hidden cover because a rock only covers the head, and do not protect the entire monster because one section is behind a tree.

## Cover interception ordering

When cover physically intercepts contact:
`ATTACK → COVER OBJECT → remaining penetration/energy if technique supports it → target protection/anatomy`.

The target cannot simultaneously receive full unmodified contact and full cover interception from the same trajectory.

---

# 9. Reaction resolution boundaries

The Action Economy Contract owns whether a reaction window exists and whether RP/stamina can be spent.

This contract owns what a successful/partial/failed defense means for hit resolution.

## Dodge

Purpose:
avoid or degrade contact through displacement/evasion.

Possible outcomes:
- `DODGE_CLEAR` — target leaves the legal contact path; attack misses unless technique explicitly tracks/sweeps into the new position;
- `DODGE_PARTIAL` — contact remains possible but hit quality/selected-part acquisition is reduced;
- `DODGE_FAIL` — no defensive benefit beyond costs already committed.

A dodge that moves to another tactical node updates authoritative position before the original attack's final contact resolution.

Dodge does not grant invulnerability frames as an independent presentation rule.

## Block

Purpose:
interpose defensive equipment/body structure and reduce/redirect incoming force.

Block generally does **not** convert the attack into a normal miss.

Possible outcomes:
- `BLOCK_STRONG` — contact routed primarily through guard equipment/guarding structure with strong quality reduction;
- `BLOCK_PARTIAL` — contact redirected/reduced but some force reaches actor/anatomy;
- `BLOCK_BROKEN` — guard fails due to force/stamina/stability and attack continues at reduced or near-normal quality according to the technique.

Block resolution must declare:
- directional guard coverage;
- guard item/structure;
- stamina/guard stability consequences;
- whether specific anatomy remains exposed.

## Parry

Purpose:
high-control timing defense that redirects/deflects suitable attacks.

Parry is not universally legal.

Requirements can include:
- compatible weapon/tool;
- reactable attack category;
- bearing/range;
- sufficient stamina/state;
- technique/capability requirement.

Possible outcomes:
- `PARRY_CLEAN` — attack becomes deflected/no normal body contact and may create a bounded attacker vulnerability/state;
- `PARRY_GLANCING` — hit quality substantially reduced or redirected;
- `PARRY_FAIL` — original attack remains dangerous and the defender has spent the reaction cost.

A clean parry does not automatically create a free recursive counter-turn. Any later counter opportunity must be a separately defined bounded state/action under the action-economy rules.

## Brace

Purpose:
absorb/withstand force and preserve stability.

Brace normally:
- improves Guard Stability/Stagger Resistance;
- can reduce displacement/knockdown;
- may improve block outcome;
- does not by itself make the actor harder to physically contact.

Brace is therefore primarily a consequence/protection modifier, not an evasion bonus.

---

# 10. Seeded randomness boundary

Randomness is allowed only where it improves uncertainty without making the combat system opaque.

Selected first-slice rule:
**use one deterministic seeded variance source per committed attack resolution, with fixed labeled use in the trace.**

The source derives from stable combat context such as:
`encounter_seed + round/turn/action sequence + attacker ID + action ID`.

Requirements:
- identical authoritative state + identical seed/action sequence → identical resolution;
- re-rendering/replaying animation does not reroll;
- UI reopening does not reroll;
- save/reload cannot reroll an already committed/resolved action;
- tests can force zero/min/max variance or a known seed;
- no unseeded random critical-hit roll;
- no separate hidden luck roll for every subsystem unless a later mechanic explicitly requires it.

## Deterministic stages

These are deterministic and are not random rolls:
- action legality;
- capability requirements;
- range legality;
- directional cover classification;
- current target-part exposure state;
- current anatomy state;
- whether a part is already broken/severed;
- protection profile lookup;
- modifier stacking/caps;
- reaction availability;
- impossible/automatic states explicitly created by mechanics.

## Why bounded variance remains

A small seeded variance preserves uncertainty between similarly matched control states while allowing position, aim, equipment and anatomy exposure to dominate the decision.

Exact variance amplitude and score scaling remain `PROTOTYPE_BALANCE_OPEN`.

Ordinary modifier stacking must be capped so the contest does not become numerically absurd. Explicit hard states may still create automatic results, such as a fully blocked line of effect or a deliberately immobilized/exposed target under a technique that defines automatic contact.

---

# 11. Hit-quality model

Selected generic tiers:
1. `MISS / NO_CONTACT`;
2. `GRAZE`;
3. `SOLID`;
4. `CLEAN`;
5. `PRECISION`.

These are contact-quality classes, not generic critical-hit rarity tiers.

## MISS / NO_CONTACT

No target-body contact.

Potential causes:
- failed contest;
- clean dodge;
- clean parry;
- target moved outside legal path;
- line of effect became illegal after reaction.

## GRAZE

Marginal contact.

Characteristics:
- reduced delivered effect;
- weak break/sever contribution;
- selected-part acquisition may be lost unless the technique explicitly preserves it;
- may create superficial injury/status only when supported by damage profile.

## SOLID

Normal intended contact.

Characteristics:
- standard technique effectiveness;
- normal damage/protection resolution;
- ordinary break/sever contribution according to damage channel.

## CLEAN

Strong controlled contact produced by favorable context and execution.

Can improve:
- delivered damage effectiveness within caps;
- structural break/sever contribution;
- status application reliability where relevant;
- guard penetration/stagger according to technique.

It is not automatically a critical hit or guaranteed part break.

## PRECISION

Highest controlled placement class.

Requirements:
- technique must allow Precision quality;
- selected part must actually be acquired;
- exposure/targeting requirements must be satisfied;
- sufficient control margin/context.

Possible benefits:
- strongest selected-part effectiveness;
- best controlled cutting/piercing placement;
- efficient use of vulnerable exposed structures;
- improved clean sever/break conditions when damage type and thresholds support them.

Precision does not bypass armor, anatomy or physical thresholds unless the technique explicitly has such a capability.

---

# 12. Hit-quality determination philosophy

Hit quality is primarily derived from explainable tactical context:
- control margin;
- target-part exposure;
- technique precision ceiling;
- aim/focus preparation;
- flank/bearing;
- range suitability;
- defender reaction outcome;
- attacker/defender injuries and footing;
- bounded seeded variance.

Do not add a second independent `critical chance` roll on top.

A powerful outcome should usually be explainable as:

`good position + exposed part + suitable technique + sufficient control + favorable contact`

rather than:

`random 5% CRIT happened`.

Exact numeric margin bands remain open until the first combat balance prototype.

---

# 13. Protection and anatomy ordering

Once contact and hit quality are known, protection is resolved from outside inward.

Generic order:

```text
COVER INTERCEPT (if any)
→ ACTIVE GUARD/BLOCK STRUCTURE (if any)
→ EXTERNAL EQUIPMENT / NATURAL ARMOR AT CONTACT LOCATION
→ TARGET BODY-PART PROTECTION / STRUCTURE
→ TISSUE / STRUCTURAL INTEGRITY
→ WOUND / BREAK / SEVER / STATUS CONSEQUENCES
→ CAPABILITY CHANGES
→ HARVEST-CONDITION CHANGES
```

Do not subtract one global armor value before the body part is known.

Protection is local to the contacted region whenever the content model supports local protection.

Examples:
- Mudcrest dorsal plates protect the relevant dorsal region;
- broken/opened plate changes that region's protection/exposure;
- horn material uses hard-structure protection/break behavior;
- tail distal sever requires the legal sever zone and suitable cutting/sever conditions;
- torso core remains deep/non-default-targetable in first slice.

---

# 14. Damage-channel handoff

This contract does not freeze final damage arithmetic, but the handoff to damage must preserve:
- contacted body part;
- hit quality;
- weapon/technique damage-channel profile;
- remaining cover/guard effect;
- local armor/protection profile;
- relevant resistances;
- break/sever efficiency modifiers;
- status payloads;
- resolution trace ID.

Typical channels can include cutting, piercing and blunt/impact where defined by equipment/content.

Physical intent already recorded for Monster 01 remains:
- blunt/impact supports horn/plate breaking;
- controlled cutting can support legal tail sever;
- piercing can exploit suitable exposed softer regions;
- destructive overkill can reduce harvest quality.

Final numeric formulas remain a later bounded packet or first-weapon implementation dependency.

---

# 15. Off-target body contact

`BODY_CONTACT_OFF_TARGET` is important for large-monster readability.

When allowed:
- attack misses the selected specialized part but still contacts a legal body region;
- hit quality is capped/reduced relative to selected-part success;
- special selected-part effects do not trigger;
- damage routes through the actual fallback body's protection;
- UI/log must explain that the attack hit the monster but not the intended part.

Do not silently count an off-target torso hit as a successful tail/horn hit.

Fallback target selection must be deterministic from geometry/target map rules, not arbitrary loot-friendly redirection.

---

# 16. Miss/failure consequences

A miss is not necessarily free of tactical consequence.

Technique data may define bounded post-miss consequences such as:
- stamina already spent;
- AP already spent;
- recovery/vulnerability state;
- weapon position/recovery;
- movement endpoint for lunging attacks;
- collision with cover/terrain when explicitly modeled;
- telegraph/reaction opportunity already consumed.

No refund is implied merely because contact failed.

Miss consequences must come from the technique/action definition, not UI code.

---

# 17. Automatic results

Avoid using probability for physically absolute conditions.

Examples:
- full opaque cover with no penetration path → hard blocked/illegal direct contact;
- already-severed tail distal target → invalid target;
- attack requiring intact horn after both horns break → invalid monster action;
- explicitly immobilized and fully exposed adjacent target under a technique that defines automatic contact → may bypass ordinary contact contest;
- clean parry result → original normal body contact prevented according to parry definition.

Automatic outcomes require explicit state/capability rules and must appear in the trace.

---

# 18. Calculation trace contract

Every resolved attack in development builds should be reconstructable.

Minimum trace fields:
- encounter/round/turn/action sequence;
- seed/resolution sample identifier;
- attacker/defender/action IDs;
- initial target group/part;
- range/bearing/elevation;
- target-part exposure state;
- cover state/direction;
- attacker control components;
- defender control components;
- relevant modifier source IDs;
- reaction selected;
- reaction outcome;
- bounded seeded variance value/label;
- final contact class;
- intended part vs actual contacted part;
- hit quality;
- cover/guard interception;
- local protection profile used;
- damage-channel handoff values;
- final damage/break/sever/status result IDs when that subsystem resolves;
- capability changes caused;
- any failure/refund/recovery result.

The trace should answer questions such as:
- Why did I miss the horn but hit the torso?
- Why did a dodge only reduce the hit to a graze?
- Why did full cover make the shot illegal?
- Why did armor reduce damage but not accuracy?
- Why was Precision unavailable?
- Which modifier moved the result from Solid to Clean?

---

# 19. Player-facing explanation requirements

The player does not need the full debug trace, but the game should communicate the important result.

Examples:
- `TAIL — PARTIALLY EXPOSED`;
- `FULL COVER — DIRECT ATTACK BLOCKED`;
- `DODGE AVAILABLE`;
- `PARRY NOT LEGAL — ATTACK TOO HEAVY / WRONG ANGLE` where content rules support it;
- `OFF-TARGET — TORSO HIT`;
- `GRAZE`;
- `CLEAN HORN HIT`;
- `DORSAL PLATE BROKEN — UNDERLAYER EXPOSED`.

UI may summarize authoritative state but never calculate the result independently.

---

# 20. First-slice anti-regression invariants

1. one committed attack cannot reroll because animation/UI replays;
2. one attack does not perform an unrelated hidden random crit roll;
3. legality is checked before contested resolution;
4. full blocking cover is handled physically/directionally, not as generic defense percentage;
5. selected-part failure does not automatically mean whole-monster miss when the technique allows body fallback;
6. off-target contact cannot trigger selected-part break/sever effects;
7. armor/protection is resolved after actual contact location is known;
8. armor does not automatically increase Evasion unless explicitly defined;
9. Dodge movement updates position before final contact resolution;
10. Block does not normally masquerade as a miss;
11. Brace does not normally add generic evasion;
12. Parry legality is explicit and cannot apply to every attack;
13. clean parry does not recursively create a free extra turn;
14. hit quality cannot bypass physical sever/break requirements by itself;
15. already-broken/severed anatomy cannot be broken/severed again for duplicate rewards;
16. body-part exposure updates when relevant anatomy/position changes;
17. deterministic state + same seed/action sequence reproduces the same result;
18. save/reload cannot reroll an already resolved/committed action;
19. presentation cannot change target, seed, quality or protection result;
20. debug/Admin mutation must preserve structural invariants unless explicitly in a marked bypass test.

---

# 21. Required tests later

## Unit/domain
- illegal range rejects before hit contest;
- full cover rejects direct line-of-effect attack;
- partial cover affects only relevant exposure/path;
- same seed/state reproduces same result;
- changed seed can change bounded variance but not legality/anatomy truth;
- body fallback cannot trigger selected-part effects;
- `REQUIRE_SELECTED_PART` precision attack fails correctly when acquisition fails;
- Dodge clear moves defender and prevents legal contact;
- partial Dodge degrades result rather than always producing miss;
- Block routes through guard/protection;
- Parry legality restrictions enforced;
- Brace improves stability without generic evasion;
- local protection profile selected from actual contacted region;
- broken dorsal plate changes only relevant region protection/exposure;
- severed tail cannot be targeted as intact distal tail;
- no second random critical roll;
- trace reproduces component ordering.

## Integration
- Aim → precision tail attempt;
- flank → exposed leg/horn attempt;
- telegraph → Dodge → changed node → original attack resolution;
- telegraph → Block → guard damage/stamina consequence;
- telegraph → Parry → deflection state;
- partial cover → off-target body contact;
- break dorsal plate → later attack reaches exposed underlayer;
- tail sever → capability loss → later tail-sweep action rejected;
- save/reload after resolved attack preserves result without reroll.

## Balance/readability
- targeting small parts is harder but not frustratingly equivalent to missing a huge monster every time;
- tactical position meaningfully improves results;
- armor matters after contact without making accuracy opaque;
- reactions differ in purpose rather than becoming cosmetic names for the same defense bonus;
- seeded variance adds uncertainty but does not dominate good decisions;
- Precision is uncommon/earned through setup rather than random crit behavior.

---

# 22. First-slice prototype variables still open

The architecture above is selected; these remain balance-open:
- exact AttackControl/DefenseControl numeric scale;
- exact bounded seeded variance amplitude;
- exact Graze/Solid/Clean/Precision margin thresholds;
- exact ordinary score caps/floors;
- exact Dodge/Block/Parry numerical modifiers;
- exact local armor/protection values;
- exact weapon handling values;
- exact first-weapon technique profiles;
- exact stamina costs;
- exact initiative formula;
- exact first status modifiers.

Do not freeze these before the first domain combat prototype provides evidence.

---

# 23. First weapon dependency exposed by this contract

The next combat-content packet must define one weapon family with enough data to instantiate this resolution model.

Minimum weapon-family requirements:
- stable weapon-family ID;
- physical damage-channel profile;
- handling/control profile;
- reach/range;
- normal attack;
- precision attack;
- heavy/committed attack;
- AP cost mapping to existing 4 AP economy;
- stamina costs;
- hit-quality ceiling per technique;
- body fallback policy;
- break/sever identity;
- Block/Parry support where applicable;
- guard profile if applicable;
- target-part suitability.

Do not create a large weapon roster yet.

---

# 24. Current gate result

`COMBAT_RESOLUTION_CONTRACT = RECORDED`
`HIT_QUALITY_MODEL = MISS_GRAZE_SOLID_CLEAN_PRECISION`
`RANDOM_CRITICAL_ROLL = REJECTED`
`SEEDED_VARIANCE = SELECTED_BOUNDED_ARCHITECTURE`
`COVER = DIRECTIONAL_PHYSICAL_CONTEXT`
`DODGE_BLOCK_PARRY_BRACE = DISTINCT_RESOLUTION_ROLES`
`OFF_TARGET_BODY_CONTACT = SUPPORTED_WHEN_TECHNIQUE_ALLOWS`
`LOCAL_PROTECTION_ORDERING = SELECTED`
`COMBAT_IMPLEMENTATION = STILL BLOCKED BY READINESS GATES`

Next bounded combat-design dependency:
**First Weapon Family Contract**, unless EVOLVE/current implementation evidence reprioritizes another prerequisite first.
