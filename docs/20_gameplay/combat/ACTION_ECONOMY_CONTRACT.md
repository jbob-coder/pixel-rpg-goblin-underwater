# Exact Combat Action-Economy Contract

Status: SELECTED FIRST-SLICE DESIGN + PROTOTYPE COST TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define one bounded, readable tactical turn economy for first-person combat so movement, cover, defense, targeting, tools and attacks compete for meaningful resources without creating infinite-action loops, opaque timing, or progression-driven turn inflation.

Primary quality fix:

**separate tactical time, defensive interruption, and exertion into three different resources instead of letting one stat do everything.**

Selected first-slice resources:
- `AP` — Action Points: current-turn tactical time/opportunity;
- `RP` — Reaction Point: limited out-of-turn defensive response capacity;
- `STAMINA` — persistent exertion resource spanning turns.

Supporting authorities:
- `/MECHANICAL_SYSTEMS_GUIDE.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `../progression/PLAYER_PROGRESSION_AND_EQUIPMENT_SYSTEM.md`.

This document owns action-economy timing. It does not own weapon damage formulas, monster-specific attacks, animation duration, or engine implementation.

---

# 1. Selected first-slice economy

## Hunter baseline

Prototype target:
- `MAX_AP = 4` per normal hunter turn;
- `MAX_RP = 1` normal reaction point;
- stamina is a separate persistent derived resource;
- AP refreshes at the start of the hunter's normal turn;
- normal AP does not carry/bank into future turns;
- RP refreshes to its allowed cap at the start of the hunter's normal turn;
- unused RP can remain available between the hunter's turn and the next refresh, but can never exceed the current cap;
- ordinary progression/attributes do not increase `MAX_AP` in the first slice;
- ordinary progression does not create additional normal turns;
- ordinary progression does not create multiple normal reactions per incoming attack.

The 4 AP / 1 RP values are **prototype balance targets**, not production-verified constants. The architectural separation and anti-loop laws are selected even if later testing changes the exact AP count.

## Why 4 AP

Four points create readable combinations without requiring fractions or very large numbers.

Examples:
- move `1` + standard attack `2` + brace `1`;
- aim `1` + precision attack `3`;
- move `1` + move `1` + quick attack `2`;
- heavy attack `4` and accept no normal follow-up;
- inspect `1` + reposition `1` + standard attack `2`.

The player can understand the opportunity cost directly.

---

# 2. Resource ownership

## AP — tactical opportunity

AP answers:
**what can I deliberately do during my current turn?**

AP is used by:
- tactical movement;
- changing cover/posture when defined as an action;
- attacks/techniques;
- aiming/focusing;
- tools/items;
- inspection/analysis actions;
- deliberate recovery actions;
- escape progress actions where applicable.

AP is not health, stamina, initiative, or animation time.

## RP — defensive interruption

RP answers:
**how many normal out-of-turn responses can I commit before my next refresh?**

Prototype baseline:
`1 RP`.

Typical RP consumers:
- dodge reaction;
- block reaction;
- parry reaction;
- brace reaction;
- dive/take-emergency-cover reaction where legal;
- explicitly defined counter reaction.

A reaction can also cost stamina, require equipment/capabilities, and depend on telegraph/position.

RP does not guarantee success. It grants permission to attempt a legal reaction.

## Stamina — persistent exertion

Stamina answers:
**how much physical exertion can I sustain across several turns?**

Stamina:
- persists between turns;
- does not automatically refill to full each turn;
- can recover through passive rules, deliberate recovery, equipment, statuses, terrain or encounter state;
- is spent by demanding movement, attacks, guards, dodges, bracing and other exertion-heavy actions;
- can restrict action effectiveness or legality when critically low;
- cannot be converted into unlimited AP.

This separation prevents high Endurance from becoming extra turns.

---

# 3. Turn/round model

Selected first-slice structure:
**discrete actor activations inside rounds, with one normal activation per eligible actor per round.**

Conceptual flow:

```text
ROUND START
  ↓
round-start effects / ordering validation
  ↓
ACTOR ACTIVATION
  ↓
turn-start effects
  ↓
refresh normal AP/RP according to actor rules
  ↓
actor selects legal action
  ↓
action validation
  ↓
telegraph / reaction window if applicable
  ↓
resolve reaction if chosen
  ↓
resolve committed action
  ↓
apply authoritative consequences/events
  ↓
repeat action selection while AP/resources/legal state permit
  ↓
turn-end effects
  ↓
next eligible actor
  ↓
ROUND END
```

The exact initiative formula remains a balance/implementation detail, but the following are selected:
- every eligible normal combat actor gets at most one normal activation per round unless an explicit exceptional mechanic says otherwise;
- initiative may affect order, not multiply ordinary turns;
- animations/VFX cannot delay or advance authoritative turn ownership;
- stagger/status effects can alter legality/cost/state but cannot silently inject recursive turns.

---

# 4. First-slice action-cost bands

These are prototype authoring targets.

## 0 AP — informational/UI-only

Allowed only when no tactical state changes.

Examples:
- inspect already-known visible status text;
- rotate/look camera within allowed presentation limits;
- open tactical information UI;
- view bestiary knowledge already possessed;
- cancel an uncommitted menu selection.

0 AP actions may not:
- move the actor;
- change posture mechanically;
- apply a buff/debuff;
- reload;
- heal;
- attack;
- reveal new information through an active check;
- manipulate inventory in a way that changes combat state;
- trigger free loops.

## 1 AP — minor tactical commitment

Typical candidates:
- one normal adjacent-node step/reposition;
- enter/leave nearby valid cover;
- brace;
- aim/focus setup;
- inspect/analyze an uncertain target/part;
- prepare a simple tool;
- deliberate stamina recovery action with bounded result;
- change between simple compatible postures where not free by definition.

Terrain/equipment/status can modify cost only through explicit bounded rules.

## 2 AP — standard action

Typical candidates:
- standard/quick attack;
- simple ranged attack;
- common defensive setup;
- use a normal combat item;
- larger reposition/sprint segment where supported;
- reload cycle for suitable weapons if later used;
- basic hunting tool deployment.

## 3 AP — committed/precision action

Typical candidates:
- precision body-part attack;
- strong technique;
- substantial reposition plus embedded tactical benefit when a specific action defines it;
- complex tool/trap action;
- stronger recover/prepare action with clear vulnerability/opportunity cost.

## 4 AP — full-turn commitment

Typical candidates:
- heavy attack;
- major charged technique;
- highly committed defensive preparation;
- emergency long reposition/escape push where legal;
- exceptional tool action intentionally consuming the turn.

A 4 AP action should feel meaningfully committed and must not routinely be followed by another ordinary AP action.

---

# 5. Movement economy

Tactical movement uses authoritative nodes/lanes/range/bearing.

Baseline prototype:
- standard legal adjacent-node move: `1 AP`;
- difficult terrain may add stamina cost, increase AP cost, or reduce movement effectiveness through the modifier pipeline;
- movement cannot cost less than the defined minimum floor;
- movement cannot be repeated after AP reaches zero;
- one movement resolution must finish before another starts;
- the camera follows successful authoritative movement; camera movement itself is not locomotion.

## Position changes can matter immediately

Movement can change:
- range;
- bearing/flank;
- exposed anatomy;
- cover direction;
- terrain tags;
- elevation;
- escape adjacency;
- attack legality;
- reaction legality.

Those consequences update after movement resolves, not after the animation finishes.

## Sprint/reposition

A larger reposition may cost:
- `2 AP`;
- additional stamina;
- reduced defense/reaction quality where defined.

It must not become a free teleport across several tactical nodes.

---

# 6. Cover/posture economy

Cover and posture are authoritative states.

## Cover

Selected first-slice direction:
- moving into a nearby cover node normally uses the movement cost of reaching it;
- no second hidden AP charge merely because the destination is cover unless a specific action requires climbing/sliding/settling;
- `peek` or attack-from-cover rules can have their own explicit cost/accuracy/exposure behavior;
- leaving cover is movement unless a specific emergency reaction defines otherwise.

This avoids double-charging `move + take cover` for the same spatial action.

## Brace

Prototype:
- deliberate brace on own turn: `1 AP`;
- creates a bounded defensive/stability state;
- may restrict movement or expire under defined conditions;
- reactive brace can instead consume `1 RP` plus applicable stamina when a legal reaction window exists.

## Guard

Guard is not a free permanent toggle.

A weapon/shield/technique can define:
- AP cost to enter/prepare guard;
- stamina upkeep or hit cost;
- compatible reactions;
- directional coverage;
- movement restrictions.

## Dodge

Normal dodge is primarily a reaction, not a free omnidirectional passive stat check.

Prototype:
- consumes `1 RP`;
- usually consumes stamina;
- requires a valid destination/space or defined in-place evasive rule;
- terrain, burden and Agility modify effectiveness/cost within caps;
- may move the actor to another node if the reaction definition succeeds.

---

# 7. Attack economy

Every attack definition must declare at least:
- AP cost;
- stamina cost;
- range/bearing requirements;
- target rules;
- weapon/capability requirements;
- whether it opens a reaction window;
- reaction types allowed;
- hit/damage profile owner;
- post-action state/recovery if any.

## Standard attack

Prototype cost target:
`2 AP` plus weapon-specific stamina.

Purpose:
normal reliable attack that leaves room for movement/preparation.

## Precision attack

Prototype cost target:
`3 AP` plus stamina where relevant.

Expected benefits can include:
- improved difficult-part targeting;
- better hit-quality ceiling;
- different sever/break efficiency through technique rules.

It is not a generic guaranteed critical hit.

## Heavy attack

Prototype cost target:
`4 AP` plus meaningful stamina.

Expected characteristics:
- high commitment;
- strong break/stagger or weapon-specific payoff;
- clearer telegraph/recovery vulnerability where relevant;
- cannot be spammed indefinitely because both turn opportunity and stamina matter.

## Quick attack

If used, prototype:
`2 AP`, lower commitment/payoff than standard/heavy alternatives.

Do not introduce 1 AP damaging attacks casually. A repeatable 1 AP attack under a 4 AP economy can create four-hit spam and becomes a balance/animation/readability burden.

---

# 8. Targeting and anatomy economy

Selecting a visible already-known legal body part inside an attack command is not automatically an extra AP tax.

Reason:
body-part targeting is a core combat decision, not a menu surcharge.

AP may be spent when the player performs a distinct preparation action such as:
- `Aim`;
- `Focus`;
- `Inspect/Analyze` unknown anatomy;
- create exposure through movement/tool use.

The attack then resolves against the selected target with the resulting context.

Unknown/unreadable parts remain constrained by knowledge/visibility rules.

---

# 9. Reaction-window contract

A hostile action opens a reaction window only if its definition says it is reactable and the defender has a legal response.

Conceptual sequence:

```text
ACTION COMMITTED
→ authoritative telegraph/event
→ determine legal reactions
→ defender may choose at most one normal reaction for this window
→ spend RP/stamina/costs
→ resolve reaction
→ resolve or modify original action
→ close window
```

Selected first-slice rules:
- baseline defender has `1 RP`;
- one reaction window cannot recursively open an unlimited second reaction window;
- a reaction caused by another reaction does not normally create another normal reaction opportunity;
- counters are explicit actions/results, not recursive new turns;
- no reaction can be selected after the original action has already authoritatively resolved;
- UI animation latency cannot extend a closed authoritative window.

## Reaction priority

If multiple reaction types are legal, the defender chooses one normal reaction.

Examples:
- dodge;
- block;
- parry;
- brace;
- emergency cover.

The system does not automatically execute several because the actor qualifies for all of them.

---

# 10. Telegraph contract

Telegraphing is gameplay information, not decoration.

Every major reactable monster attack should expose enough authoritative information for the player to make a decision appropriate to their knowledge/perception.

Telegraph data can communicate:
- attack intent/category;
- likely direction;
- threatened range/area;
- relevant body capability;
- reaction legality;
- known special consequence.

Exact detail shown depends on knowledge and perception.

A telegraph event is created by the combat domain. Animation/audio visualize it but do not decide whether the attack became reactable.

Fast/simple attacks can have limited/no normal reaction window if deliberately designed and balanced.

---

# 11. Stamina interaction

Stamina is the long-horizon limiter that AP alone cannot provide.

Selected principles:
- AP refresh alone does not erase exertion;
- repeated heavy attacks/dodges/guards can drive stamina low across turns;
- low stamina should change decisions before becoming total helplessness;
- a deliberate recovery option should exist so the player can trade AP/opportunity for stamina;
- passive recovery can occur at a bounded timing point when not prevented by statuses/actions;
- Endurance and equipment can modify stamina capacity/recovery/costs within caps;
- no effect reduces stamina costs below the global floor;
- stamina cannot become negative without an explicit overexertion mechanic;
- no ordinary effect converts stamina directly into extra AP/extra turns.

Exact stamina values/formulas remain balance-open.

---

# 12. Recovery action

Prototype deliberate recovery:
- cost target: `1 AP`;
- restores a bounded stamina amount or improves turn-end recovery;
- cannot be repeated infinitely for net-positive AP/resources;
- may be limited to once per activation if tests show repeated use is degenerate;
- does not heal health by default;
- can be interrupted/modified by statuses or threat conditions if later justified.

The exact recovery amount remains open until the stamina scale is selected.

---

# 13. Action commitment, cancellation and refunds

Every action passes through states such as:

`SELECTING → VALIDATING → COMMITTED → REACTION_WINDOW (optional) → RESOLVING → RESOLVED/FAILED`.

## Before commitment

The player may cancel menu selection without resource cost if authoritative state has not changed.

## After commitment

Default rule:
**no free cancellation.**

If an action becomes impossible because the world changes during a legal reaction/resolution sequence, the action definition must state its failure/refund policy.

Preferred policy:
- AP/stamina are spent at a defined commit/resolution point;
- no ad hoc UI refunds;
- full refunds are rare and only occur when the action never legally committed due to validation failure;
- interrupted committed actions may consume all or a defined portion of cost depending on technique data;
- the result is logged/explainable.

This prevents cancel/refund exploits.

---

# 14. End-turn rules

The hunter can explicitly end the turn before AP reaches zero.

Selected rules:
- unused normal AP does not bank;
- ending turn does not convert AP into RP;
- ending turn does not automatically grant bonus stamina beyond normal recovery rules;
- if a later ability rewards holding AP, it must be an explicit bounded mechanic and cannot raise next-turn AP above cap unless a separately approved exceptional rule exists.

This keeps the economy predictable.

---

# 15. Monster action economy

Monsters use deterministic authored behavior patterns, not AI.

They do not need to expose a player-style AP UI, but their action resolution must obey the same timing/invariant framework.

First-slice recommendation:
- one normal monster activation per round;
- a bounded internal action/commitment budget or authored action structure;
- movement + attack combinations must be explicitly authored and costed/validated;
- large multi-part sequences count as one defined action/technique, not hidden extra turns;
- phase/berserk changes can change available actions/cost profiles, but not bypass turn/reaction invariants silently;
- disabled anatomy removes actions requiring that capability.

Example:
if the Mudcrest Raker's horn is broken, a horn-charge action requiring `HORN_CHARGE_CAPABLE` is illegal regardless of remaining turn budget.

---

# 16. Initiative/order safeguards

Initiative may use Agility/status/encounter context, but first-slice safeguards are:
- no ordinary actor receives two normal activations in one round from high initiative alone;
- initiative cannot become an infinite speed loop;
- ties use deterministic resolution;
- order changes are explicit events;
- stagger/delay effects cannot recursively push an actor forever without an explicit bounded status rule;
- surprise/ambush, if later supported, modifies starting state/order rather than granting uncontrolled permanent turn advantage.

Exact initiative formula remains OPEN.

---

# 17. Status timing interaction

Status processing must use standardized hooks.

Recommended combat-order compatibility:
- `ROUND_START`;
- `TURN_START`;
- `BEFORE_ACTION_VALIDATION`;
- `ON_ACTION_COMMIT`;
- `REACTION_WINDOW`;
- `BEFORE_ACTION_RESOLUTION`;
- `ON_HIT/ON_DAMAGE`;
- `AFTER_ACTION`;
- `TURN_END`;
- `ROUND_END`;
- `ENCOUNTER_END`.

A status cannot independently create extra AP/turns outside this timing model unless an explicitly approved exceptional mechanic exists.

Periodic damage/effects must not tick multiple times merely because UI/animation repeats an event.

---

# 18. Escape/flee timing

Player escape and monster flee must be authoritative tactical actions/state transitions.

Player:
- must reach/qualify for a valid escape route/state;
- escape progress can cost AP/movement;
- cannot exit solely by pressing a UI button while spatially trapped.

Monster:
- deterministic behavior may select flee intent when conditions are met;
- monster must use a legal retreat route/node;
- leaving the local encounter returns the persistent monster to wilderness state with the same anatomy/crystal/injury identity.

No escape creates a fresh monster instance.

---

# 19. First-slice anti-loop invariants

These are hard quality gates.

1. `AP <= current MAX_AP` unless an explicitly approved exceptional test mechanic says otherwise.
2. normal AP does not bank between turns.
3. ordinary attributes/mastery/equipment do not grant extra normal turns.
4. baseline normal RP cap is one.
5. one reaction window permits at most one normal defender reaction.
6. reactions do not recursively create unlimited reactions.
7. counters do not become hidden extra turns.
8. 0 AP actions cannot mutate tactical state in ways that create value loops.
9. canceling an uncommitted selection is free; canceling a committed action is not an exploit path.
10. stamina cannot be converted into unlimited AP.
11. AP cannot be converted into unlimited permanent stamina/health.
12. movement cannot be executed after its cost cannot legally be paid.
13. body-part selection itself cannot be repeatedly charged/refunded to manipulate resources.
14. UI/animation cannot spend/refund resources.
15. a monster pattern cannot execute a disabled-anatomy action.
16. initiative cannot create repeated ordinary activations in one round.
17. turn-start/end/status hooks fire once per authoritative event.
18. save/reload during combat cannot duplicate AP/RP/items/status ticks.
19. encounter transition cannot refresh resources unless the contract explicitly says it should.
20. admin/debug commands must preserve structural caps unless explicitly running a marked invariant-bypass test.

---

# 20. Player-facing UI requirements

The combat HUD should make resource consequences legible before commitment.

At minimum show:
- current/max AP;
- RP availability;
- stamina;
- selected action AP cost;
- selected action stamina cost when applicable;
- invalid-action reason;
- target/body part;
- relevant cover/posture state;
- whether a reaction is currently available during a reaction window.

Useful preview:
`4 AP → Move (-1) → Precision Strike (-3) = 0 AP`.

The UI may preview costs but does not own the authoritative values.

---

# 21. Admin/debug requirements

Development combat inspector should expose:
- round/turn index;
- current actor;
- initiative/order;
- AP current/max;
- RP current/max;
- stamina current/max;
- legal actions and rejection reasons;
- action cost breakdown;
- current action state;
- open/closed reaction window;
- reaction candidates;
- recent resource spend/refund events;
- turn/status hook history;
- node/range/bearing/cover state;
- deterministic behavior rule selected by monster.

Required debug assertions/counters:
- AP overspend attempts;
- RP overspend attempts;
- duplicate turn-start/end hooks;
- recursive reaction depth;
- illegal extra activation;
- action committed after actor turn ended;
- duplicate item consumption;
- negative stamina/resource underflow;
- unexpected refund.

---

# 22. Required tests later

## Unit/domain
- 4 AP refresh behaves deterministically;
- unused AP does not bank;
- 1 RP cap enforced;
- standard costs reject when insufficient;
- movement updates spatial context before next action validation;
- body-part selection does not cost unintended AP;
- reaction consumes RP exactly once;
- reaction cannot recursively reopen itself;
- heavy 4 AP action ends ordinary AP options;
- stamina persists across turns;
- recovery cannot produce a resource loop;
- validation failure does not consume committed cost;
- committed interruption follows explicit cost policy;
- disabled anatomy removes dependent monster actions;
- initiative grants no unintended extra turns.

## Integration
- move → cover → attack sequence;
- aim → precision attack;
- telegraph → dodge/block/parry choice;
- low stamina alters legal/effective actions correctly;
- status hooks tick exactly once;
- monster flee preserves instance state;
- save/reload preserves AP/RP/stamina/turn ownership without duplication;
- combat UI cost preview matches domain result.

## Balance/quality
- movement is not so expensive that standing still dominates;
- heavy attack is not always optimal;
- precision targeting has meaningful opportunity cost;
- reactions matter without becoming mandatory automatic success;
- stamina matters over several turns but does not force constant waiting;
- 4 AP creates multiple meaningful turn plans;
- equipment/mastery do not collapse the economy into free actions.

---

# 23. First-slice example turns

These examples demonstrate economy shape, not final weapon balance.

## Example A — reposition and strike

Start:
`4 AP / 1 RP`

- Step to flank: `-1 AP`;
- Standard targeted attack: `-2 AP`;
- Brace: `-1 AP`.

End:
`0 AP`, RP remains available unless spent.

## Example B — precision commitment

- Aim: `-1 AP`;
- Precision attack: `-3 AP`.

End:
`0 AP`.

## Example C — aggressive movement

- Move: `-1 AP`;
- Move: `-1 AP`;
- Standard attack: `-2 AP`.

End:
`0 AP` and likely greater stamina expenditure than Example A.

## Example D — heavy commitment

- Heavy attack: `-4 AP` plus substantial stamina.

End:
no ordinary follow-up AP action. Defensive survival depends on remaining RP, positioning and prior preparation.

## Example E — information before commitment

- Analyze anatomy: `-1 AP`;
- Move into better bearing: `-1 AP`;
- Standard attack: `-2 AP`.

The player traded immediate damage for better information/position.

---

# 24. Selected vs prototype vs open

## SELECTED/CURRENT
- AP/RP/Stamina are separate resources;
- AP is small and refreshes per normal turn;
- no normal AP banking;
- ordinary progression does not grant extra normal turns;
- reactions use explicit reaction windows;
- baseline normal defender reaction count is tightly capped;
- movement/cover/posture are authoritative state changes;
- body-part selection inside an attack is not automatically an extra AP tax;
- committed actions use explicit spend/refund policies;
- UI/animation cannot own timing/resources;
- monster deterministic patterns obey action legality/capability rules.

## PROTOTYPE TARGETS
- hunter `MAX_AP = 4`;
- hunter normal `MAX_RP = 1`;
- standard move `1 AP`;
- standard attack `2 AP`;
- precision attack `3 AP`;
- heavy attack `4 AP`;
- aim/brace/analyze/recovery commonly `1 AP`;
- larger reposition commonly `2 AP` plus stamina.

These require actual combat testing.

## OPEN
- exact stamina scale/recovery formula;
- exact initiative formula;
- final weapon-specific action costs;
- block/parry/dodge formulas;
- guard upkeep rules;
- ammo/reload economy;
- exact item/tool costs;
- exact status durations;
- whether any rare endgame mechanic may alter AP/RP caps;
- party/ally activation rules if party play is later approved.

---

# 25. Current gate

`COMBAT_ACTION_ECONOMY = RECORDED`
`FIRST_SLICE_AP_TARGET = 4`
`FIRST_SLICE_RP_TARGET = 1`
`AP_BANKING = NO`
`NORMAL_ATTRIBUTE_AP_GROWTH = NO`
`NORMAL_EXTRA_TURNS_FROM_PROGRESSION = NO`
`STAMINA_SEPARATE_PERSISTENT_RESOURCE = YES`
`REACTION_WINDOWS = EXPLICIT`
`REACTION_RECURSION = BLOCKED`
`BODY_PART_SELECTION_EXTRA_AP_TAX = NO_BY_DEFAULT`
`COMBAT_IMPLEMENTATION = NOT AUTHORIZED`
`COMBAT_RUNTIME_VERIFICATION = NOT EXECUTED`

Next bounded documentation candidate after continuity reconciliation:
**Combat Resolution / Hit Quality and Defense Contract** — define accuracy/evasion, cover, block/parry/dodge resolution, hit-quality tiers and deterministic/randomness boundaries without yet implementing formulas.