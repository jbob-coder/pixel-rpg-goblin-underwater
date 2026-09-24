# First-Slice Status Set Prototype Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Define the smallest reusable first-slice set of combat statuses/tactical states needed to prove the existing combat architecture without creating a large status catalog, hidden timing system, duplicate injury model, or random status-proc layer.

Primary quality rule:

**Statuses modify authoritative combat state through explicit timing, ownership, stacking and removal rules; they never create hidden extra turns, hidden rerolls, or presentation-owned gameplay.**

This contract owns:
- the first-slice selected status/tactical-state set;
- status vs tactical-state classification;
- deterministic application/stacking/removal rules;
- first-slice timing hooks;
- interaction with Initiative/turn order, AP/RP/Stamina and defense;
- save/reload continuity requirements;
- future implementation tests.

It does not own:
- health/damage-scale numbers;
- terrain-effect values;
- Monster 01 attack definitions/status-application strengths;
- berserk behavior;
- party composition;
- defeat/retreat rules;
- animation/VFX timing;
- UI implementation;
- broad environmental/psychological status catalogs.

Supporting authorities:
- `ACTION_ECONOMY_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `FIRST_WEAPON_FAMILY_CONTRACT.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `/CONTENT_DATA_GUIDE.md`.

---

# 1. Selected minimal first-slice set

The first slice records exactly five reusable states:

1. `status_bleeding` — persistent physical condition;
2. `status_staggered` — short transient disruption;
3. `status_off_balance` — temporary unstable-footing condition;
4. `tactical_braced` — positive defensive/stability state;
5. `tactical_guarded` — positive directional weapon-guard state.

This is intentionally small.

Not selected in this pass:
- Exhausted;
- generic Wounded;
- Focused/Aimed;
- Concealed;
- Wet/Mud-Caked/Chilled/Overheated;
- Poisoned/Toxined;
- Fear/Shaken/Panic;
- broad elemental/status catalogs.

Those remain deferred until a first-slice mechanic actually consumes them.

---

# 2. Status vs tactical-state separation

The runtime effect layer must distinguish persistent/negative **statuses** from short-lived **tactical states** even when both use the same validated modifier/event infrastructure.

## Status

A `StatusInstance` represents a condition applied to an actor/body context that can persist independently of one selected action.

First-slice statuses:
- `status_bleeding`;
- `status_staggered`;
- `status_off_balance`.

They can participate in:
- application validation;
- stacking/refresh rules;
- status resistance/immunity where later explicitly authored;
- save/reload persistence;
- removal/treatment rules.

## Tactical state

A tactical state represents deliberate/current combat posture or preparation.

First-slice tactical states:
- `tactical_braced`;
- `tactical_guarded`.

They do **not** behave like diseases/poisons/injuries:
- no generic cure item;
- no status-resistance roll;
- no long-duration stack catalog;
- expiration/removal is primarily driven by action, movement, force and turn timing.

The first implementation may reuse a shared effect-instance structure internally, but the domain type/category must remain explicit so UI, cure logic and stacking do not treat `Braced` like `Bleeding`.

---

# 3. Deterministic application law

First-slice status application does not add a new random proc roll.

Selected rule:

```text
AUTHORITATIVE ACTION/CONTACT RESOLUTION
→ determine whether a status/state consequence is valid
→ emit explicit application event
→ status owner validates target/immunity/stack rule
→ apply/refresh/replace deterministically
→ emit trace
```

Requirements:
- no UI-side status application;
- no animation callback applies gameplay independently;
- no separate hidden `status chance` roll in the first slice;
- no status re-roll on save/reload;
- no repeated application because an animation event fires twice;
- if a future action needs chance-based application, it must use a documented reproducible randomness boundary rather than unseeded runtime randomness.

Monster/weapon/content owners later decide **which successful consequences request which status applications**. This contract owns what happens after a valid application request exists.

---

# 4. First-slice processing hooks

The root status architecture already defines standardized hooks. The first combat prototype narrows them to a deterministic subset:

1. `ON_APPLY`;
2. `TURN_START_PRE_RECOVERY`;
3. `BEFORE_ACTION_VALIDATION`;
4. `BEFORE_ACTION_RESOLUTION`;
5. `ON_HIT_OR_DAMAGE_CONSEQUENCE`;
6. `AFTER_ACTION`;
7. `TURN_END`;
8. `ROUND_END`;
9. `ENCOUNTER_END`;
10. `ON_REMOVE`.

`ROUND_END` is explicitly selected because persistent periodic conditions such as Bleeding need a cadence independent of whether an actor's activation was skipped.

## Activation-start ordering

For a normal activation:

```text
TURN START
→ process status transitions/expiry at TURN_START_PRE_RECOVERY
→ Stamina owner applies passive recovery once
→ Action Economy owner refreshes AP/RP once
→ action selection
```

Status processing never independently refreshes AP/RP/Stamina.

## Round-end ordering

At authoritative round end:

```text
all current RoundRoster slots terminal
→ round-end status effects in deterministic target/status order
→ round-end domain hooks complete
→ Initiative owner advances round_id/builds next roster
```

Presentation timing cannot delay, repeat or suppress these hooks.

---

# 5. `status_bleeding`

Category:
`PERSISTENT_PHYSICAL_CONDITION`.

Purpose:
represent an ongoing wound consequence that can matter after the original hit without duplicating anatomy damage itself.

## Application boundary

Bleeding is not applied merely because HP decreased.

A damage/anatomy consequence must explicitly request Bleeding after:
- legal contact;
- protection/anatomy resolution;
- any wound/status application conditions owned by the action/content are satisfied.

The originating contact may record a body-part/source reference for traceability.

## Stacking

Selected stack rule:
`STACK_INTENSITY_CAPPED`.

Prototype maximum:
`BLEEDING_MAX_INTENSITY = 3`.

Laws:
- one authoritative Bleeding instance per actor for first-slice scheduling;
- valid new applications increase intensity only through the explicit application event;
- intensity clamps at 3;
- a single resolved application event cannot duplicate itself because presentation repeated;
- multiple wounded parts may be recorded as source/context metadata without creating multiple independent round-end ticks for the same actor.

This prevents multi-part bookkeeping from accidentally multiplying periodic ticks without bound.

## Periodic cadence

Selected cadence:
**at most one Bleeding periodic consequence per affected actor per round.**

When Bleeding is first applied during round `R`:
`first_tick_round = R + 1`.

Therefore a late hit immediately before round end does not receive an unintended instant extra tick.

At eligible `ROUND_END`:
- resolve one Bleeding periodic event;
- magnitude derives from authoritative Bleeding intensity/content balance data;
- exact HP value is intentionally not selected until the health/damage prototype scale exists;
- the tick is deterministic and traceable;
- intensity changes magnitude, not number of ticks.

## Removal/persistence

Bleeding does not auto-expire after an arbitrary number of turns in the first slice.

It persists until:
- an explicit treatment/removal rule succeeds;
- target reaches a terminal state where the condition is irrelevant;
- a future health/recovery owner explicitly resolves post-encounter persistence.

`ENCOUNTER_END` does **not** silently mean `healed`.

Post-encounter treatment/persistence is a later vertical-slice dependency and must not be invented by combat UI.

---

# 6. `status_staggered`

Category:
`TRANSIENT_PHYSICAL_DISRUPTION`.

Purpose:
represent a brief loss of control after a sufficiently disruptive consequence without implementing a full stun/turn-skip system.

## Application

Exact stagger thresholds/application strengths remain owned by future attack/content and resolution data.

If a valid `status_staggered` application succeeds:
- any incompatible `tactical_guarded` state clears;
- any incompatible deliberate `tactical_braced` state clears after the resolution has already determined that Brace did not prevent the stagger consequence;
- the status becomes active immediately.

## While active

First-slice restrictions:
- normal `Parry` is illegal;
- normal `Dodge` is illegal;
- `Block`/reactive `Brace` may remain legal if equipment, bearing, RP and Stamina permit;
- Staggered does not create a new reaction window;
- Staggered does not independently cancel an already resolved action;
- Staggered does not automatically skip the next normal activation.

This keeps disruption meaningful without turning every stagger into a hidden stun lock.

## Stacking/refresh

Selected rule:
`REFRESH_DURATION` with no intensity stacking.

Repeated application before the target's next activation:
- keeps one Staggered instance;
- does not queue multiple recovery penalties;
- does not create multiple Off-Balance applications;
- does not move or duplicate the target's Initiative slot.

## Transition

At the target's next `TURN_START_PRE_RECOVERY`:
1. remove `status_staggered`;
2. apply/refresh `status_off_balance`;
3. continue the same normal activation;
4. then run Stamina recovery/AP/RP refresh through their existing owners.

The activation is not skipped merely because Staggered existed.

---

# 7. `status_off_balance`

Category:
`TEMPORARY_STABILITY_CONDITION`.

Purpose:
represent unstable footing/control that persists through one normal activation unless deliberately stabilized sooner.

## While active

Selected hard rule:
- normal `Parry` is illegal.

Selected modifier boundary:
- Off-Balance may feed explicit AttackControl/DefenseControl/stability modifiers through the shared effect pipeline;
- exact scalar values remain balance-open until first combat-domain tests;
- UI may display the condition but may not invent additional penalties.

Dodge remains potentially legal so the state does not automatically create an unavoidable death spiral.

## Removal

Two first-slice removal paths:

### Deliberate stabilization
A successful deliberate Brace action:
- clears `status_off_balance`;
- then applies `tactical_braced` through its normal rule;
- still pays the AP/Stamina costs owned by Action Economy/Stamina;
- does not refund previous costs.

### Natural recovery
If not cleared sooner:
- Off-Balance remains active during the target's next normal activation;
- it clears at that activation's authoritative `TURN_END`.

If the actor's slot is skipped/ineligible, it does not receive a free recovery turn; the condition remains until a later normal activation completes or an explicit removal succeeds.

## Stacking

Selected rule:
`REFRESH_DURATION`.

No intensity stacking in the first slice.

Repeated application does not:
- increase AP loss;
- create extra turns;
- queue multiple turn-end removals.

---

# 8. `tactical_braced`

Category:
`POSITIVE_TACTICAL_STATE`.

Purpose:
represent deliberate/reactive physical stabilization already defined by Action Economy and Combat Resolution.

Brace costs remain owned by existing contracts:
- deliberate Brace: `1 AP` plus first-slice Stamina cost `6`;
- reactive Brace: `1 RP` plus first-slice Stamina cost `10`.

This status contract does not spend/refund those resources independently.

## Mechanical boundary

While Braced, the state may improve:
- Guard Stability;
- Stagger Resistance;
- displacement/knockdown resistance;
- compatible Block outcomes.

It does **not**:
- increase Evasion merely because it exists;
- make physical contact less likely by itself;
- auto-Block attacks;
- grant free RP;
- grant extra turns.

Exact stability/resistance numbers remain balance-open and use the shared modifier pipeline.

## Deliberate Brace lifetime

A deliberate Braced state normally protects the actor between its preparation and the start of its next normal activation.

It clears earlier on:
- voluntary movement that leaves the prepared footing;
- forced displacement;
- commitment of an incompatible damaging attack;
- successful Staggered application;
- terminal encounter removal.

At the actor's next `TURN_START_PRE_RECOVERY`, any remaining deliberate Braced state expires before new-turn action selection.

Continuing to Brace in a later turn therefore requires another legal preparation/action rather than becoming a permanent free stance.

## Reactive Brace lifetime

Reactive Brace applies only for the current reaction/original hostile-action resolution unless an owning action explicitly says otherwise.

It clears after that resolution and cannot silently become a free between-turn Brace.

## Stacking

Selected rule:
`REPLACE` / one Braced state.

Repeated Brace does not stack multiple Guard Stability bonuses.

---

# 9. `tactical_guarded`

Category:
`POSITIVE_DIRECTIONAL_TACTICAL_STATE`.

Purpose:
represent the prepared directional Guard required by weapon-supported Block behavior.

The Field Poleblade is the current first-slice consumer.

Existing Stamina authority supplies:
- Poleblade Guard preparation Stamina `4`;
- Poleblade Block commitment `6 + incoming-force impact drain`.

AP preparation cost remains owned by Action Economy/weapon action definition; this contract does not create a second AP price.

## Required state data

A Guarded instance must record at least:
- source weapon/equipment ID;
- authoritative guard bearing/directional coverage reference;
- application sequence/round;
- any compatible guard capability tags.

Camera facing alone does not alter authoritative guard direction after commitment unless the combat domain accepts a legal guard-orientation update.

## Mechanical boundary

Guarded:
- enables compatible directional Block attempts when Action Economy/Combat Resolution say they are legal;
- does not automatically Block;
- does not grant extra RP;
- does not protect bearings outside its recorded coverage;
- does not become shield-level omnidirectional protection;
- still pays Block Stamina/impact drain when a Block is committed/resolved.

## Lifetime

A deliberate Guarded state normally lasts until the start of the actor's next normal activation, unless cleared earlier by:
- voluntary movement incompatible with the guard posture;
- forced displacement that invalidates orientation;
- commitment of an incompatible attack;
- `BLOCK_BROKEN`;
- successful Staggered application;
- weapon/capability loss;
- terminal encounter removal.

At next `TURN_START_PRE_RECOVERY`, remaining Guarded expires before normal action selection.

A player who wants another guarded interval must prepare it again through a legal action.

## Brace interaction

`Guarded` and deliberate `Braced` may coexist because they represent different decisions:
- Guarded interposes directional weapon structure;
- Braced improves stability/force resistance.

Their resource/opportunity costs remain explicit.

The combination still does not guarantee a Block or survive massive force; Combat Resolution decides `BLOCK_STRONG / BLOCK_PARTIAL / BLOCK_BROKEN`.

## Stacking

Selected rule:
`REPLACE` / one Guarded state per actor.

Preparing guard again replaces orientation/state data rather than stacking multiple guard bonuses.

---

# 10. Selected interaction matrix

| Existing state | New event/state | First-slice result |
|---|---|---|
| Bleeding | Bleeding application | increase intensity up to 3; no extra periodic tick count |
| Staggered | Staggered application | refresh one instance; no intensity/turn stacking |
| Off-Balance | Off-Balance application | refresh one instance |
| Off-Balance | successful deliberate Brace | clear Off-Balance, then apply Braced |
| Braced | voluntary move / forced displacement | clear Braced |
| Guarded | incompatible move/displacement | clear Guarded |
| Guarded | `BLOCK_BROKEN` | clear Guarded |
| Braced | successful Staggered application | clear Braced |
| Guarded | successful Staggered application | clear Guarded |
| Braced + Guarded | compatible incoming attack | both may contribute through their separate owners; neither guarantees defense |
| Staggered | next normal activation start | convert once to Off-Balance; activation still occurs |
| Off-Balance | completed normal activation | clear at TURN_END if not removed earlier |

No selected interaction changes Initiative order or creates a second normal activation.

---

# 11. Scheduler / Initiative integration

Initiative contract remains authoritative.

Statuses/tactical states may affect **eligibility or action legality only when their own rule explicitly says so**; they do not edit the RoundRoster directly.

For this first-slice set:
- Bleeding does not skip activations;
- Staggered does not skip the next activation;
- Off-Balance does not skip activations;
- Braced does not alter Initiative;
- Guarded does not alter Initiative.

Therefore the five selected states do not exercise `SKIPPED_INELIGIBLE` by themselves.

That scheduler path remains available for a future explicit incapacitation status/mechanic, but no generic `Stunned`/turn-skip status is selected now.

This is deliberate anti-lock design.

---

# 12. AP / RP / Stamina integration

Status/tactical-state code must not directly own resource refresh/spend already assigned elsewhere.

Examples:
- deliberate Brace costs are requested/validated by Action Economy + Stamina;
- reactive Brace spends RP/Stamina through those owners;
- Guard preparation/Block costs are not charged by the status instance;
- clearing Off-Balance via deliberate Brace does not refund the Brace cost;
- Staggered does not arbitrarily zero AP/RP/Stamina;
- Bleeding does not drain Stamina unless a later explicit effect says so.

This preserves the current 4 AP / 1 RP / persistent-Stamina architecture.

---

# 13. Defense / hit-resolution integration

Combat Resolution remains authoritative for whether an incoming action creates a legal status consequence.

Ordering stays:

```text
contact / defense / cover
→ hit quality
→ protection / anatomy
→ damage / break / sever consequence
→ status-application consequences
→ capability/state updates
```

Important boundaries:
- Braced modifies stability/consequence resolution, not contact probability by itself;
- Guarded enables/defines directional Block context but does not auto-resolve Block;
- Staggered application is a consequence after resolution, not a separate random roll;
- Bleeding application is anatomy/damage consequence data, not a generic every-hit proc;
- Off-Balance can be created by an explicit consequence but is not silently inferred from every movement/terrain event.

---

# 14. Save/reload continuity

Future persistence must save enough status/state data to resume without duplicate effects.

Minimum fields where relevant:
- state/status ID;
- target actor ID;
- source ID/action sequence ID;
- application round/sequence;
- stack/intensity;
- first eligible periodic-tick round;
- pending expiry/transition hook;
- Guarded orientation/capability data;
- Braced scope (`DELIBERATE_BETWEEN_TURNS` or `REACTION_WINDOW`);
- any body-part/source metadata required for Bleeding trace.

On reload:
- do not re-run `ON_APPLY` for already-applied instances;
- do not duplicate a Bleeding round tick;
- do not convert one Staggered instance to Off-Balance twice;
- do not restore expired Braced/Guarded state;
- do not change Initiative order because a status was rehydrated;
- do not refresh AP/RP/Stamina through status loading.

---

# 15. Presentation boundary

UI/VFX/audio may:
- show status icons/text;
- show Bleeding intensity;
- show Staggered/Off-Balance/Braced/Guarded state;
- visualize guard direction;
- display removal/transition events;
- display simplified reasons for action illegality.

Presentation may not:
- increment/decrement stacks;
- tick Bleeding damage;
- clear status because an animation ended unless the domain emitted the removal event;
- apply Staggered from a VFX callback;
- create Braced/Guarded because an animation pose looks correct;
- spend/refund resources;
- advance turns/rounds;
- reroll application.

---

# 16. Explicitly deferred states

## Exhausted

Not selected.

The Stamina contract intentionally uses affordability/recovery pressure without automatic generic low-Stamina penalties. `Exhausted` should be added only if testing proves the existing Stamina model insufficient.

## Generic Wounded

Not selected.

Anatomy/injury already owns local structural/body damage. A generic Wounded status would risk duplicating that state unless a later explicit need appears.

## Focused / Aimed

Not selected in this bounded pass.

Action Economy permits Aim/Focus preparation, but no first-slice consumer currently requires a persistent Focus/Aim state to prove the core architecture. Add it only when a concrete action packet needs it.

## Concealed

Deferred to terrain/behavior/visibility work.

## Environmental / toxin / psychological states

Deferred until their corresponding terrain/content/system packet exists.

---

# 17. First implementation data shape

A future implementation should be data-driven and compatible with the root status/effect guide.

Minimum `StatusDefinition`/tactical-state definition concepts:
- stable ID;
- category;
- stack group/rule;
- max intensity if any;
- valid target scope;
- standardized hook handlers/effect references;
- action/capability restrictions;
- modifier references;
- removal rules;
- persistence policy;
- trace/debug label.

Runtime instance concepts:
- source ID;
- target ID;
- application sequence;
- intensity;
- pending timing/expiry fields;
- source-part metadata where useful;
- deterministic state-specific data such as guard bearing.

Do not hard-code these five states inside combat UI scripts.

---

# 18. Required future implementation tests

When combat-domain implementation is authorized, tests must prove at least:

## Generic status engine
1. stable ID lookup;
2. deterministic `ON_APPLY` exactly once;
3. explicit stack-policy enforcement;
4. no UI/presentation authority;
5. save/reload does not duplicate application hooks;
6. deterministic trace includes source/target/status/sequence.

## Bleeding
7. one actor-level instance;
8. intensity caps at 3;
9. first tick occurs no earlier than next round;
10. exactly one periodic tick per eligible round;
11. intensity changes magnitude, not tick count;
12. reload cannot duplicate a round tick;
13. encounter end does not silently mark treatment/healing.

## Staggered
14. no intensity stacking;
15. Dodge/Parry legality blocked while active;
16. next normal activation still starts;
17. transition to Off-Balance occurs once before recovery/AP-RP refresh;
18. repeated application cannot queue duplicate transitions/turn loss.

## Off-Balance
19. Parry rejected while active;
20. deliberate Brace clears it and then applies Braced;
21. natural removal occurs after one completed normal activation;
22. skipped/ineligible slot does not grant free expiry.

## Braced
23. deliberate vs reactive scope behaves differently;
24. movement/displacement/incompatible attack clears as defined;
25. no Evasion/auto-Block bonus is invented;
26. repeat Brace does not stack multiple copies.

## Guarded
27. directional guard data is authoritative;
28. camera rotation alone does not change committed guard direction;
29. Guarded does not auto-Block or grant RP;
30. `BLOCK_BROKEN`/displacement/incompatible actions clear state;
31. one state only / reprepare replaces orientation;
32. Braced + Guarded can coexist without duplicating their modifier categories.

## Cross-system invariants
33. no selected state changes Initiative order;
34. no selected state creates extra normal activations;
35. status hooks do not double passive Stamina recovery/AP/RP refresh;
36. identical authoritative input produces identical status/state result trace.

No runtime verification is claimed until these tests and their owning combat source exist.

---

# 19. Current selected values / laws

`FIRST_SLICE_STATUS_SET = BLEEDING / STAGGERED / OFF_BALANCE / BRACED / GUARDED`

`BLEEDING_STACK_RULE = STACK_INTENSITY_CAPPED`
`BLEEDING_MAX_INTENSITY = 3`
`BLEEDING_TICK_CADENCE = ROUND_END / MAX_ONCE_PER_ACTOR_PER_ROUND`
`BLEEDING_FIRST_TICK = APPLICATION_ROUND_PLUS_1`

`STAGGERED_STACK_RULE = REFRESH_DURATION`
`STAGGERED_NEXT_TURN = TRANSITION_TO_OFF_BALANCE / DO_NOT_SKIP_ACTIVATION`

`OFF_BALANCE_STACK_RULE = REFRESH_DURATION`
`OFF_BALANCE_PARRY = ILLEGAL`
`OFF_BALANCE_RECOVERY = DELIBERATE_BRACE_OR_COMPLETED_NORMAL_ACTIVATION`

`BRACED_STACK_RULE = REPLACE`
`BRACED_CONTACT_EVASION_BONUS = NONE_BY_DEFAULT`

`GUARDED_STACK_RULE = REPLACE`
`GUARDED_AUTO_BLOCK = NO`
`GUARDED_DIRECTIONAL = YES`

`FIRST_SLICE_STATUS_RANDOM_PROC = NONE`
`STATUS_SYSTEM_EXTRA_NORMAL_ACTIVATIONS = FORBIDDEN`

## Verification boundary

This contract is design-recorded and cross-checked against current combat/status authorities.

`STATUS_SET_DESIGN_RECORDED = YES`
`STATUS_SET_RUNTIME_IMPLEMENTED = NO`
`STATUS_SET_RUNTIME_VERIFIED = NO`

Combat implementation remains blocked by readiness gates.