# Stamina Prototype Scale and Recovery Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define one bounded first-slice Stamina model that makes repeated attacks, reactions, guarding and demanding movement matter across several turns without duplicating AP, creating infinite recovery loops, or producing a low-Stamina death spiral.

Primary quality fix:

**Stamina should constrain sustained exertion through affordability and recovery opportunity cost, not through a pile of hidden global accuracy/evasion penalties.**

This contract owns:
- first-slice Stamina scale;
- Stamina spend/validation timing;
- passive recovery timing;
- deliberate recovery behavior;
- reserve/readability bands;
- ordinary cost-reduction floors;
- first-slice movement/reaction exertion candidates;
- Field Poleblade Stamina costs;
- anti-loop and anti-zero-cost invariants;
- Stamina traces/test requirements.

It does not own:
- AP/RP timing (`ACTION_ECONOMY_CONTRACT.md` owns that);
- Initiative;
- status-effect definitions;
- Region 01 terrain numbers;
- Monster 01 attack packet;
- final Endurance progression formula;
- final equipment/mastery balance;
- final production numbers beyond the first-slice prototype.

Supporting authorities:
- `ACTION_ECONOMY_CONTRACT.md`;
- `FIRST_WEAPON_FAMILY_CONTRACT.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `../progression/PLAYER_PROGRESSION_AND_EQUIPMENT_SYSTEM.md`.

---

# 1. Resource identity

Stamina answers:

**how much physical exertion can this actor sustain across several actions, reactions and turns before they must reduce commitment or recover?**

Stamina is not:
- AP;
- RP;
- health;
- initiative;
- animation time;
- a generic damage multiplier;
- a universal speed stat.

AP controls current-turn tactical opportunity.
RP controls limited out-of-turn response permission.
Stamina controls sustained exertion.

This separation remains mandatory even if later balance changes the numeric scale.

---

# 2. First-slice normalized scale

Selected test-profile baseline:

`BASELINE_MAX_STAMINA = 100`

The number 100 is selected because:
- costs are readable as portions of a full reserve;
- balance changes can be reasoned about without fractions;
- player/debug UI can show both exact value and percentage naturally;
- it is large enough for differentiated attack/reaction costs without becoming an inflated RPG stat.

Important:

**100 is the first-slice baseline test profile, not a promise that every hunter in the final game has exactly 100 Max Stamina.**

Future Endurance/equipment/progression can modify derived Max Stamina through the shared modifier pipeline, but the first combat prototype should begin with a 100-point reference actor so costs can be validated coherently.

Hard runtime laws:
- current Stamina is clamped to `0..MaxStamina`;
- ordinary Stamina cannot be negative;
- ordinary recovery cannot exceed Max Stamina;
- reducing Max Stamina below current Stamina clamps current Stamina to the new maximum;
- increasing Max Stamina does not automatically refill the newly created capacity unless an explicit effect says so.

---

# 3. Reserve/readability bands

First-slice reserve bands:

| Band | Current Stamina | Generic consequence |
|---|---:|---|
| `READY` | 50–100 | normal affordability; no generic penalty |
| `LOW` | 25–49 | warning/readability state; no hidden global accuracy/evasion penalty |
| `CRITICAL` | 1–24 | severe reserve warning; expensive actions/reactions naturally become unaffordable |
| `EMPTY` | 0 | Stamina-cost actions/reactions are illegal until recovery occurs |

The bands are primarily:
- player-facing information;
- debug classification;
- authoring conditions for future explicit mechanics.

They do **not** automatically apply generic penalties to:
- AttackControl;
- DefenseControl;
- accuracy;
- evasion;
- damage;
- movement;
- hit quality.

Reason:
a universal low-Stamina penalty can create a feedback loop where the player becomes less capable at the exact moment they need a recovery decision, and it duplicates later `Exhausted`/injury/status mechanics.

If a later status such as `EXHAUSTED` introduces penalties, that status must be explicit, traceable and separately balanced.

---

# 4. Affordability law

Default first-slice rule:

**an action/reaction with a Stamina cost may be committed only when current Stamina is at least its final validated cost.**

Conceptually:

```text
BASE STAMINA COST
→ Endurance/equipment/mastery/status/terrain modifiers
→ caps/floors
→ FINAL STAMINA COST
→ compare with CURRENT STAMINA
→ legal or INSUFFICIENT_STAMINA
```

If insufficient:
- the action remains uncommitted;
- no AP/RP/Stamina is spent;
- UI receives the authoritative rejection reason;
- the player may choose another legal action.

First-slice overexertion below zero is **not selected**.

A future explicit overexertion mechanic can be designed later, but normal actions cannot borrow Stamina from future turns or health.

---

# 5. Spend timing

For normal committed actions:
- final Stamina cost is frozen during authoritative action validation;
- Stamina is spent at the defined commitment point with AP/resource commitment;
- cancellation before legal commitment costs nothing;
- cancellation/interruption after commitment follows the action's recorded refund policy;
- UI never refunds Stamina independently.

For reactions:
- reaction base cost is validated when the reaction is committed;
- that cost is spent once;
- any separate guard-impact drain occurs during defense/contact resolution;
- the same reaction cannot spend its base cost twice because animation replayed.

Every spend must emit an inspectable source/action ID.

---

# 6. Passive recovery

Selected first-slice baseline:

`BASE_PASSIVE_RECOVERY = 10 Stamina`

Timing:
**once at the start of the hunter's normal activation.**

Recommended authoritative order:

```text
TURN START
→ apply/validate persistent states that modify recovery/capacity
→ apply passive Stamina recovery once
→ clamp to Max Stamina
→ refresh normal AP/RP according to Action Economy
→ action selection
```

The exact internal ordering may be adjusted during implementation if standardized event hooks require it, but these invariants must remain:
- passive recovery occurs at most once per normal activation;
- animation/UI cannot trigger it;
- ending a turn early does not trigger a second recovery;
- round end does not trigger another copy;
- save/reload does not trigger another copy;
- reaction windows do not trigger passive recovery;
- encounter camera transitions do not trigger passive recovery.

At 0 Stamina, the next normal activation's baseline passive recovery gives the hunter enough reserve to make some low-cost choices instead of entering a permanent soft-lock.

---

# 7. Deliberate recovery — Catch Breath

Selected first-slice recovery action:

`CATCH_BREATH`

Prototype:
- AP cost: `1`;
- Stamina cost: `0`;
- recovery: `+20 Stamina` at the actor's turn-end recovery point if the recovery commitment remains valid;
- maximum uses: `1` per normal activation;
- does not heal health;
- does not restore RP;
- does not restore AP;
- cannot exceed Max Stamina.

## Anti-financing rule

`CATCH_BREATH` is intentionally **not an immediate Stamina battery for another attack in the same activation**.

Selected conditions:
- it is illegal if the actor has already committed a damaging weapon/attack technique during the current activation;
- after committing `CATCH_BREATH`, committing a damaging attack, sprint/major exertion, or another explicitly incompatible high-exertion action cancels the pending recovery before it is granted;
- normal low-exertion reposition/inspection and compatible defensive preparation may remain legal if their own rules allow it;
- canceled pending recovery does not refund the 1 AP.

This lets the player make a real choice such as:

`reposition → Catch Breath → defensive setup`

instead of:

`precision attack → free refill → precision attack rhythm forever`.

The recovery is granted once at the defined turn-end point, then the pending flag clears.

---

# 8. Why recovery is delayed rather than immediate

Immediate 1-AP recovery creates a dangerous exploit under the current 4-AP economy.

Example failure mode:
- a 3-AP precision attack;
- 1 AP remains;
- immediate recovery restores more Stamina than the precision attack cost;
- player repeats this every turn;
- Stamina stops functioning as a long-horizon limiter.

The delayed/pending model prevents recovery from financing the same activation's offensive exertion while still allowing tactical retreat/recovery turns.

This is a structural anti-loop rule, not merely a balance number.

---

# 9. First-slice generic exertion costs

These are prototype authoring targets for the first combat slice.

## Movement

### Normal adjacent reposition on stable ground
`0 Stamina` baseline.

It still costs AP.

Reason:
ordinary tactical movement should not make basic repositioning impossible simply because the player is low on Stamina.

Terrain/status/equipment can add explicit exertion later.

### Sprint / large reposition
`8 Stamina` baseline plus its AP cost.

Difficult terrain can later modify this through the shared pipeline.

## Defensive actions/reactions

### Deliberate Brace
`6 Stamina` baseline.

### Reactive Brace
`10 Stamina` baseline plus RP.

### Dodge reaction
`14 Stamina` baseline plus RP.

Dodge remains a meaningful reserve commitment because it can avoid body contact and reposition.

### Generic weapon Parry baseline
`10 Stamina` plus RP when the equipped weapon/attack matchup allows Parry.

Weapon definitions may modify this within caps.

### Guard preparation
`4 Stamina` baseline where an action explicitly prepares Guard.

### Block reaction / guard commitment
`6 Stamina` baseline plus RP where applicable, **before any incoming-force impact drain**.

Guard-impact drain remains separate because absorbing a light swipe and absorbing a severe monster impact should not cost the same amount merely because both are called `Block`.

---

# 10. Guard-impact Stamina drain

The Combat Resolution contract distinguishes contact/guard outcomes.

This Stamina contract adds one invariant:

**guarding can have both a reaction/commitment cost and an impact drain based on the resolved incoming force/profile.**

The exact Monster 01 impact values remain owned by the future attack packet.

First-slice authoring bands for incoming-force drain may use:
- `LIGHT_IMPACT_DRAIN`;
- `MEDIUM_IMPACT_DRAIN`;
- `HEAVY_IMPACT_DRAIN`;
- `OVERWHELMING / INCOMPATIBLE` where normal block is illegal or expected to break.

Exact numeric drain per Monster 01 attack remains open until that packet exists.

Resolution law:
- impact drain cannot reduce current Stamina below zero;
- if the required guard stability/Stamina cannot be met, defense can degrade toward `BLOCK_BROKEN` according to Combat Resolution;
- spending all remaining Stamina does not create negative Stamina debt;
- a massive body charge does not become safely blockable merely because the player has 100 Stamina.

Physical legality still outranks resource availability.

---

# 11. Field Poleblade Stamina costs

The first weapon family now receives concrete first-slice prototype exertion costs.

| Technique | AP | Stamina | Notes |
|---|---:|---:|---|
| `POLEBLADE_MEASURED_CUT` | 2 | **12** | normal controlled cutting |
| `POLEBLADE_DRIVING_THRUST` | 2 | **10** | efficient linear thrust |
| `POLEBLADE_PLACED_HEW` | 3 | **18** | controlled selected-part precision cut |
| `POLEBLADE_COMMITTED_CLEAVE` | 4 | **30** | full-turn high-exertion commitment |
| `POLEBLADE_HAFT_CHECK` | 2 | **8** | bounded close-range spacing/control |
| Poleblade Guard preparation | action-dependent | **4** | prepares directional guard where rules require |
| Poleblade Block commitment | reaction | **6 + impact drain** | not shield-level protection |
| Poleblade Parry | reaction | **10** | only against compatible attacks |

These values are selected prototype targets, not production-final balance.

They are intended to produce distinct rhythms under a 100-point reserve:
- two normal cuts in one turn cost 24 Stamina;
- passive recovery returns only 10 next activation;
- repeated double-attack turns therefore drain the reserve over time;
- a 30-Stamina Committed Cleave cannot be repeated indefinitely just because AP refreshes;
- a player who spends heavily on offense may lack Stamina for Dodge/Parry during the monster's response.

That last tradeoff is intentional.

---

# 12. Offense vs defensive reserve

The system does not reserve a protected amount of Stamina automatically for reactions.

A player may choose to spend down their reserve offensively.

Example:
- current Stamina: 34;
- Committed Cleave cost: 30;
- remaining Stamina: 4;
- normal Dodge cost: 14;
- Dodge is now unaffordable until recovery occurs.

This is valid tactical risk, not a bug.

However:
- UI should preview projected remaining Stamina before commitment;
- reaction-capable HUD should make low reserve obvious;
- the system must not hide that a heavy action leaves the player unable to afford normal defense.

Information quality should support deliberate risk.

---

# 13. Ordinary cost-modifier floor

Equipment, mastery, Endurance-related rules and statuses may later modify Stamina costs through the shared modifier pipeline.

Structural first-slice guardrail:

For an action with a positive base Stamina cost, ordinary modifiers cannot reduce final cost below:

`max(1, ceil(BASE_COST × 0.50))`

unless an explicitly authored exceptional capability overrides the ordinary floor.

Examples:
- 30-cost Cleave ordinary floor: 15;
- 12-cost Measured Cut ordinary floor: 6;
- 10-cost Parry ordinary floor: 5.

This is a hard anti-zero-cost safety floor, not a target for normal progression.

Normal mastery/equipment should usually produce much smaller efficiencies.

Actions deliberately defined as `0 Stamina`—such as ordinary stable-ground reposition—remain 0 because they do not enter the positive-cost reduction rule.

---

# 14. Recovery modifiers and caps

Recovery can be modified later by:
- Endurance;
- equipment;
- injuries/statuses;
- environment;
- deliberate camp/support effects.

First-slice structural rules:
- all recovery modifiers pass through the shared modifier pipeline;
- passive recovery is calculated once per normal activation;
- Catch Breath recovery is calculated once when granted;
- no duplicate source may apply twice without an explicit stacking rule;
- recovery is clamped at Max Stamina;
- negative recovery cannot silently drain Stamina unless it is actually defined as a separate drain/status effect;
- UI does not add recovery independently.

Prototype balance guardrail:
ordinary modifiers should not routinely multiply passive or Catch Breath recovery enough to erase the weapon-family exertion identity.

Exact ordinary recovery caps remain balance-open until Endurance/equipment test profiles exist.

---

# 15. Endurance relationship

Existing stats authority states Endurance can affect:
- Max Stamina;
- Stamina Recovery;
- exhaustion/environmental strain resistance.

This contract preserves that role without inventing a permanent final formula before starting attributes are selected.

First-slice implementation recommendation later:
- create a neutral test profile whose derived Max Stamina is exactly 100;
- expose calculation traces for Max Stamina and recovery;
- test lower/higher Endurance profiles as bounded variants;
- do not let Endurance grant AP, RP or extra turns through Stamina.

Potential final formulas remain `BALANCE_OPEN`.

---

# 16. Encounter and mode-transition continuity

Stamina is authoritative actor state.

Therefore:
- entering first-person combat does not automatically refill Stamina merely because the camera/mode changed;
- exiting first-person presentation does not automatically refill it;
- monster escape/reacquisition does not duplicate/refill Stamina unless an explicit world-time/recovery rule occurs;
- opening menus does not recover Stamina;
- save/load does not refill Stamina by default;
- respawn/defeat recovery policy remains owned by the future failure/retreat contract.

Exploration-wide exertion is not designed in this packet.

For an isolated first combat prototype, the test scenario may explicitly initialize the hunter at 100 Stamina. That is test setup, not a hidden encounter-transition refill rule.

---

# 17. Stamina and statuses

This packet intentionally does **not** define the first status set.

It only reserves clear integration points.

A later status could modify:
- Max Stamina;
- passive recovery;
- action costs;
- specific reaction costs;
- Catch Breath legality/effectiveness.

It must not:
- secretly add another independent Stamina variable;
- bypass cost floors without explicit capability;
- trigger duplicate recovery hooks;
- make UI the owner of resource truth.

An `EXHAUSTED` status may be evaluated later if testing proves affordability-only pressure is insufficient.

Do not preemptively add it merely because the Stamina meter becomes low.

---

# 18. Terrain relationship

This packet intentionally does not freeze Region 01 terrain numbers.

Terrain can later add or modify Stamina costs for:
- movement;
- Dodge;
- Sprint;
- bracing/footing-related actions;
- selected techniques where physical footing genuinely matters.

Examples that remain candidates, not values:
- mud can increase movement/sprint/dodge exertion;
- shallow water can increase reposition exertion;
- stable ground can preserve baseline costs.

All terrain modifiers use the shared effect pipeline and the ordinary cost floor.

Terrain must not create a second hidden Stamina meter.

---

# 19. No Stamina-to-AP conversion

Hard invariant:

**ordinary Stamina can never be converted directly into extra AP, an extra normal activation, or additional RP.**

Likewise:
- unused AP does not become Stamina except through an explicit recovery action;
- unused RP does not become Stamina;
- high Endurance does not grant extra turns;
- Stamina regeneration does not refresh AP/RP.

This preserves the resource separation established by Action Economy.

---

# 20. No free offensive-recovery loop

The first-slice system must reject loops such as:

```text
3 AP precision attack
→ 1 AP instant recovery
→ net-positive or neutral Stamina every turn
→ repeat indefinitely
```

Selected safeguards:
- Catch Breath recovery is delayed;
- Catch Breath is incompatible with a damaging attack in the same activation;
- one Catch Breath use per activation;
- passive recovery occurs once;
- AP cannot be converted directly to immediate repeated Stamina grants;
- recovery cannot exceed Max Stamina.

Any future technique that restores Stamina must be audited against these invariants.

---

# 21. No zero-Stamina soft-lock

The system must also avoid the opposite failure:

```text
Stamina reaches 0
→ every action costs Stamina
→ player cannot move/recover/defend
→ encounter becomes unrecoverable regardless of tactics
```

First-slice safeguards:
- normal adjacent stable-ground reposition has 0 Stamina baseline;
- Catch Breath itself costs 0 Stamina;
- passive recovery occurs at the next normal activation;
- informational/UI actions remain 0-resource where Action Economy allows;
- Stamina cannot become negative debt.

Being empty is dangerous because reactions/attacks are restricted, but it is not intended to be an automatic permanent lock.

---

# 22. Preview and player-facing readability

Before committing an action, the UI should eventually be able to show:
- current Stamina / Max Stamina;
- action Stamina cost;
- projected Stamina after the action;
- whether normal reaction costs are likely to remain affordable;
- LOW/CRITICAL warning when relevant;
- explicit `INSUFFICIENT_STAMINA` rejection.

Do not promise future incoming attack costs that are not known.

For example, the UI can say:
`Committed Cleave: 30 Stamina → 4 remaining`

and visibly warn that the normal 14-Stamina Dodge is no longer affordable.

This makes risk inspectable rather than hidden.

---

# 23. Authoritative trace requirements

Every Stamina mutation should eventually produce a development/debug trace containing at least:
- actor ID;
- current/max before;
- source action/effect ID;
- base cost/recovery;
- modifier contributors;
- cap/floor applied;
- final cost/recovery;
- current/max after;
- reason/timing hook;
- action/round/turn sequence ID where relevant;
- rejection reason if unaffordable;
- pending Catch Breath state/cancel reason if applicable.

Example:

```text
STAMINA_SPEND
actor=hunter_01
source=POLEBLADE_COMMITTED_CLEAVE
base=30
modifiers=[]
final=30
before=34
→ after=4
```

Or:

```text
ACTION_REJECTED
source=DODGE
required_stamina=14
current_stamina=4
reason=INSUFFICIENT_STAMINA
```

---

# 24. Future data ownership

Recommended future domain data/state separation:

## Actor/derived definition inputs
- base/profile Stamina contribution;
- Endurance contribution rules;
- equipment/mastery modifiers;
- passive recovery definition;
- cost/recovery floors/caps.

## Runtime actor state
- `current_stamina`;
- `max_stamina` derived/cache as architecture requires;
- pending Catch Breath flag/source;
- once-per-activation recovery-use marker;
- exact event/sequence metadata needed for deterministic resolution.

## Action/technique definition
- base Stamina cost;
- cost tags;
- whether cost occurs at commitment/reaction/impact;
- compatibility with Catch Breath;
- exceptional cost-floor override if one exists.

UI never stores the authoritative Stamina balance.

---

# 25. Required validation/tests later

At minimum, future unit/domain tests should cover:

1. neutral test hunter initializes with 100/100 Stamina;
2. passive recovery grants exactly once per normal activation;
3. passive recovery clamps at Max Stamina;
4. opening UI cannot recover Stamina;
5. end-turn cannot duplicate passive recovery;
6. save/load cannot duplicate passive recovery;
7. action requiring more Stamina than current is rejected without spending AP/Stamina;
8. positive Stamina costs cannot be reduced below ordinary 50% floor without exceptional capability;
9. 0-cost stable reposition remains 0 and is not forced to 1 by the positive-cost floor;
10. Measured Cut spends 12 before modifiers;
11. Driving Thrust spends 10;
12. Placed Hew spends 18;
13. Committed Cleave spends 30;
14. Haft Check spends 8;
15. Dodge baseline spends 14 + RP exactly once;
16. Parry baseline spends 10 + RP exactly once when legal;
17. Guard commitment and impact drain do not double-fire;
18. Stamina never becomes negative;
19. Stamina never exceeds Max Stamina;
20. Catch Breath costs 1 AP and grants no immediate Stamina;
21. Catch Breath is limited to once per activation;
22. damaging attack before Catch Breath makes Catch Breath illegal;
23. damaging/high-exertion incompatible action after Catch Breath cancels pending recovery;
24. canceled Catch Breath does not refund AP;
25. valid Catch Breath grants 20 exactly once at turn end;
26. Catch Breath cannot create Stamina above maximum;
27. reaching 0 does not permanently soft-lock the hunter;
28. encounter camera transition does not refill Stamina;
29. identical authoritative state/actions reproduce identical Stamina traces;
30. UI preview matches domain final cost.

Additional integration tests later should verify terrain/status/mastery/equipment modifiers and Monster 01 guard-impact drains once those packets exist.

---

# 26. Prototype rhythm checks

These are design sanity checks, not runtime-verified balance claims.

With baseline 100 Stamina and +10 passive recovery per normal activation:

### Repeated Committed Cleave
A 30-cost Cleave should rapidly consume reserve despite AP refreshing every turn.

The player can perform several high-commitment turns, but cannot treat heavy attack as permanently free.

### Repeated double Measured Cut
Two Measured Cuts cost 24 Stamina in one turn.
Passive recovery restores only 10 next activation.
The sequence therefore trends downward over sustained use.

### Precision pressure
Placed Hew costs 18.
Because Catch Breath cannot be paired with an attack in the same activation, a 3-AP precision attack cannot use the leftover AP as an immediate Stamina battery.

### Defensive reserve
A player at 34 Stamina can choose a 30-cost Cleave, but doing so leaves only 4 and makes the baseline Dodge/Parry unavailable.

This creates the intended offense-vs-survival decision.

These rhythms must be measured in the combat prototype before production balance is frozen.

---

# 27. What remains open

Still `BALANCE_OPEN`:
- final Endurance→Max Stamina formula;
- final Endurance→recovery formula;
- final equipment/mastery efficiency values;
- final terrain Stamina modifiers;
- final status interactions;
- Monster 01 guard-impact drain per attack;
- exploration stamina/recovery model;
- camp/food/rest recovery outside combat;
- whether later exceptional overexertion mechanics exist;
- final production cost tuning after combat playtests.

Do not infer those values from this prototype packet.

---

# 28. Current selected state

`BASELINE_MAX_STAMINA = 100`
`BASE_PASSIVE_RECOVERY = 10_PER_NORMAL_ACTIVATION`
`CATCH_BREATH = 1_AP / +20_DELAYED / ONCE_PER_ACTIVATION`
`CATCH_BREATH_ATTACK_PAIRING = PROHIBITED`
`LOW_STAMINA_GLOBAL_ACCURACY_PENALTY = NO`
`OVEREXERTION_BELOW_ZERO = NOT_SELECTED_FIRST_SLICE`
`NORMAL_STABLE_REPOSITION_STAMINA = 0`
`SPRINT_STAMINA = 8`
`BRACE_STAMINA = 6`
`REACTIVE_BRACE_STAMINA = 10`
`DODGE_STAMINA = 14`
`PARRY_BASELINE_STAMINA = 10`
`GUARD_PREP_STAMINA = 4`
`BLOCK_COMMIT_STAMINA = 6_PLUS_IMPACT_DRAIN`
`POSITIVE_COST_ORDINARY_REDUCTION_FLOOR = 50_PERCENT_OF_BASE_MIN_1`

Field Poleblade:
- `MEASURED_CUT = 12`;
- `DRIVING_THRUST = 10`;
- `PLACED_HEW = 18`;
- `COMMITTED_CLEAVE = 30`;
- `HAFT_CHECK = 8`.

`STAMINA_PROTOTYPE_CONTRACT = RECORDED`
`COMBAT_IMPLEMENTATION = BLOCKED_BY_REMAINING_READINESS_GATES`
