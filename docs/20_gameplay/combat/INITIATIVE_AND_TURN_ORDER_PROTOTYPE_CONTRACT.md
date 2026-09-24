# Initiative and Turn-Order Prototype Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Define one deterministic first-slice initiative and round scheduler that decides **who receives the next normal combat activation** without creating random opener rolls, speed-stat extra turns, mid-round reordering exploits, save/reload duplication, or a second timing authority outside the combat domain.

Primary quality fix:

**Initiative controls ordering only. It never creates additional ordinary activations.**

This contract owns:
- first-slice Initiative inputs and prototype formula;
- encounter-entry Initiative snapshots;
- deterministic sort/tie rules;
- round roster creation;
- late-entry timing;
- incapacitated/dead/escaped actor handling for scheduling;
- activation-consumption/no-extra-turn invariants;
- turn-order trace and future implementation tests.

It does not own:
- AP/RP/Stamina values or refresh rules (`ACTION_ECONOMY_CONTRACT.md` / Stamina contract own those);
- status definitions;
- terrain-effect numbers;
- Monster 01 attack definitions;
- berserk behavior;
- party composition/control;
- defeat/retreat resolution;
- animation duration;
- UI implementation;
- final production balance.

Supporting authorities:
- `ACTION_ECONOMY_CONTRACT.md`;
- `STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `/CONTENT_DATA_GUIDE.md` for stable identity conventions where applicable.

---

# 1. Selected first-slice model

The first slice uses:

**one normal activation per eligible combat actor per round, ordered by a deterministic Initiative snapshot captured when that actor enters the encounter.**

Selected laws:
- no Initiative die roll;
- no hidden random opener roll;
- no ordinary stat/gear effect grants a second normal activation;
- no mid-round resorting because an attribute/status/context changed;
- reactions are not normal activations;
- counters are not normal activations;
- camera/UI/animation never advance the schedule;
- save/reload resumes the same authoritative round/activation state rather than replaying turn-start hooks.

The snapshot model is selected for the first slice because it is easy to explain, replay and test, and it prevents order oscillation from producing pseudo-extra turns around round boundaries.

A future explicit reorder/delay/haste mechanic requires its own bounded contract extension and must preserve the one-normal-activation-per-round invariant unless a separately approved exceptional mechanic says otherwise.

---

# 2. Prototype Initiative inputs

The shared stats/effects system already assigns Initiative contribution primarily to Agility and awareness contribution to Perception.

Selected prototype inputs for any normal combat actor:
- `EffectiveAgility` — authoritative Agility after legal persistent/contextual modifiers at snapshot time;
- `EffectivePerception` — authoritative Perception after legal persistent/contextual modifiers at snapshot time;
- `ExplicitInitiativeModifier` — optional bounded/traceable modifier from an authored source.

For the first prototype:

`ExplicitInitiativeModifier = 0` unless another current owning authority explicitly supplies a legal source/value.

This contract does **not** invent status, terrain, ambush or equipment Initiative bonuses merely to populate that hook.

Monsters and hunters participating in the same scheduler must expose compatible authoritative Initiative inputs through the combat/stat data boundary. Monster 01's concrete values remain content/balance work, not owned here.

---

# 3. Prototype formula

Selected first-slice formula:

```text
InitiativeRating =
    (2 × EffectiveAgility)
  + EffectivePerception
  + ExplicitInitiativeModifier
```

Design intent:
- Agility is the primary ordering attribute;
- Perception matters materially for awareness/readiness without replacing Agility;
- integer arithmetic remains easy to inspect/test;
- Might, Endurance and raw damage do not make an actor act earlier by default;
- Finesse does not duplicate Agility's timing role;
- Resolve does not become a generic speed stat.

The formula is a **first-slice prototype target**, not a final production balance promise.

Any modifiers must come through the shared modifier/cap/trace system. Initiative may not read arbitrary UI values or presentation state.

---

# 4. Snapshot timing

Each combatant receives an `InitiativeSnapshot` exactly when it becomes an authoritative participant in the encounter.

Minimum frozen snapshot fields:
- encounter ID;
- combatant instance ID;
- entry sequence/entry round;
- EffectiveAgility;
- EffectivePerception;
- every explicit Initiative modifier source/value;
- final InitiativeRating;
- tie-break components;
- snapshot sequence ID.

For actors present at encounter creation, snapshots are captured before Round 1 order is finalized.

For a late entrant, the snapshot is captured when the combat domain accepts the actor into the encounter, but the actor receives no normal activation until the next round under the late-entry rule below.

## No ordinary mid-encounter recomputation

First-slice InitiativeRating does not automatically recompute because:
- Stamina changed;
- AP/RP changed;
- the actor moved;
- a body part was damaged;
- camera/view mode changed;
- a normal action started/ended;
- an ordinary status later modifies Agility/Perception.

Those changes can affect other mechanics immediately through their owners, but do not silently reshuffle turn order.

Reason:
a mid-round reorder system can let actors gain/lose activation timing in ways that resemble extra turns and is much harder to replay/debug.

A future explicit order-changing mechanic must mutate the authoritative scheduler through a dedicated rule, never by silently replacing the snapshot.

---

# 5. Deterministic ordering comparator

For each round, active participant snapshots are ordered using this exact comparator:

1. higher `InitiativeRating` first;
2. if tied, higher `EffectiveAgility` first;
3. if still tied, higher `EffectivePerception` first;
4. if still tied, normalized stable `combatant_instance_id` ascending.

No random sample is used for ties.

The final ID tie-break exists only to guarantee total deterministic ordering. It is not a gameplay bonus and must use a stable authoritative instance ID, not:
- scene-tree order;
- array insertion accident;
- memory address;
- current frame timestamp;
- UI list index;
- renderer/node creation order.

If two same-species actors exist, their combatant instance IDs must still be distinct.

## Example

```text
Hunter:  Agility 50, Perception 40 → 2(50)+40 = 140
Monster: Agility 45, Perception 50 → 2(45)+50 = 140
```

Both rate `140`; the Hunter acts first because `50 Agility > 45 Agility`.

If all numeric tie fields match, the stable combatant ID decides reproducibly.

---

# 6. Round roster and activation slots

At `ROUND_START`, the combat domain constructs an authoritative `RoundRoster` from combatants that:
- belong to the encounter;
- have an InitiativeSnapshot;
- have not been permanently removed from the encounter by death/escape/other terminal removal;
- are otherwise present in combat state.

The roster is sorted by the deterministic comparator.

Each roster entry has a terminal round-slot state:
- `PENDING`;
- `ACTED`;
- `SKIPPED_INELIGIBLE`;
- `REMOVED`.

A round ends only when every roster slot is terminal.

The scheduler chooses the first `PENDING` slot in authoritative order and revalidates normal-activation eligibility at that moment.

---

# 7. Normal activation start

When a pending actor is eligible:

```text
SELECT NEXT PENDING SLOT
→ REVALIDATE ACTOR EXISTS / IS PRESENT / CAN TAKE NORMAL ACTIVATION
→ MARK NORMAL ACTIVATION STARTED FOR THIS ROUND
→ RUN AUTHORITATIVE TURN-START HOOKS ONCE
→ APPLY STAMINA PASSIVE-RECOVERY HOOK ONCE THROUGH STAMINA OWNER
→ REFRESH NORMAL AP/RP ONCE THROUGH ACTION-ECONOMY OWNER
→ ACTION SELECTION / RESOLUTION
→ TURN-END HOOKS ONCE
→ MARK SLOT ACTED
→ ADVANCE TO NEXT PENDING SLOT
```

Turn order selects **who owns the activation**. It does not independently modify AP, RP, Stamina, statuses, health or damage.

Stamina passive recovery remains owned by `STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md` and occurs at most once at normal activation start.

---

# 8. No-extra-turn invariant

Hard first-slice invariant:

**A combatant may start at most one normal activation for a given `round_id`.**

Required implementation identity:
- `round_id` monotonically advances inside the encounter;
- each combatant/slot records whether its normal activation for that round has started/terminated;
- attempting to start a second normal activation for the same actor/round is rejected and logged as an invariant violation.

The following never create another normal activation:
- high Initiative;
- high Agility;
- high Perception;
- unused AP;
- unused RP;
- high Stamina;
- a reaction;
- a counter;
- ending a turn early;
- Catch Breath;
- changing camera/view;
- opening UI;
- saving/loading;
- animation completion callbacks;
- repeated input.

A future exceptional extra-activation mechanic is not selected for the first slice and would require explicit design, caps and anti-loop tests.

---

# 9. Reactions are outside the normal activation count

Reaction timing remains owned by Action Economy / Combat Resolution.

A reaction:
- occurs inside an explicit reaction window;
- consumes normal RP/Stamina/costs as defined;
- does not create a new normal activation;
- does not move the reacting actor's round slot to `ACTED` merely because it reacted;
- does not refresh AP/RP/Stamina;
- cannot recursively create unlimited reaction/turn chains.

A counter result is part of the reaction/action resolution path unless a future explicit contract defines otherwise.

---

# 10. Late-entry rule

Selected first-slice law:

**An actor accepted into the encounter after the current round roster has been finalized does not gain a normal activation in that current round.**

Procedure:
1. create the entrant's InitiativeSnapshot when it becomes an authoritative combat participant;
2. mark `first_eligible_round = current_round + 1`;
3. allow ordinary combat state/targetability only as owned by other systems;
4. include the entrant in the next `ROUND_START` roster;
5. sort it normally using its frozen InitiativeSnapshot.

This prevents a high-Initiative late entrant from appearing mid-round and taking a surprise extra slot that earlier actors could not anticipate.

No generic free ambush/opening activation is selected here. A future ambush/surprise system must be explicit and preserve activation-count invariants.

---

# 11. Incapacitated / temporarily ineligible actor

This contract does not define the status that makes an actor incapacitated.

Generic scheduler law:
- if a `PENDING` actor reaches its slot and cannot legally start a normal activation, mark the slot `SKIPPED_INELIGIBLE`;
- once skipped, that actor cannot be reinserted later in the same round even if it becomes eligible again;
- if it is eligible at the next round's start, it may participate normally there using its existing InitiativeSnapshot unless another owner removed it from the encounter.

This prevents recovery timing from creating two scheduling opportunities in one round.

---

# 12. Death / escape / terminal removal

If an actor becomes dead, escaped or otherwise terminally removed from the current encounter:
- remove it from future round rosters;
- if its current-round slot is still `PENDING`, mark that slot `REMOVED`;
- if it already acted, its slot remains terminal and no second slot appears;
- if it dies/is removed during its own activation, stop further actions as owned by action/death rules and terminate that activation once authoritative resolution permits;
- no resource refresh is granted because of removal.

Monster escape/reacquisition world behavior is not defined here. Reacquisition that creates a new combat encounter receives a new encounter/snapshot sequence under the relevant world/encounter authority.

---

# 13. Round-end and next-round construction

When all current slots are terminal:

```text
ROUND END HOOKS
→ advance round_id
→ collect current non-terminal encounter participants
→ exclude actors not eligible to belong to the encounter
→ include late entrants whose first_eligible_round has arrived
→ sort by frozen InitiativeSnapshot comparator
→ create new RoundRoster
→ ROUND START
```

Existing actors normally keep the same relative ordering because their snapshots are frozen.

The scheduler may not grant an activation by merely re-sorting an already-consumed current-round slot.

---

# 14. Save/reload continuity

Future combat persistence must save enough scheduler state to resume without duplicating activation hooks.

Minimum authoritative state when saving mid-combat:
- encounter ID;
- current `round_id`;
- participant InitiativeSnapshots;
- current RoundRoster order;
- each slot state;
- current acting combatant if an activation is open;
- action sequence/commit state owned by Action Economy/Resolution;
- late entrants and `first_eligible_round`;
- deterministic trace/sequence counters required for replay.

On reload:
- do not rebuild the current round from scratch if that would resurrect consumed slots;
- do not rerun turn-start recovery/AP/RP refresh if the current activation had already started;
- do not reroll Initiative or ties;
- resume from authoritative saved scheduler state.

Concrete persistence implementation remains blocked by prior implementation gates.

---

# 15. Presentation/UI boundary

Presentation may:
- display known turn order;
- highlight the current actor;
- animate turn changes;
- show Initiative breakdown/debug traces;
- hide information that other knowledge/visibility rules say the player should not know.

Presentation may not:
- choose the next actor;
- modify InitiativeRating;
- add/remove roster slots independently;
- refresh resources;
- advance `round_id`;
- retry a skipped turn;
- generate a new tie result;
- create an extra activation because an animation finished twice.

The combat domain is the sole turn-order authority.

---

# 16. Reproducible trace contract

Every encounter should be able to emit an inspectable scheduling trace in development builds.

Minimum trace fields:
- encounter ID;
- round ID;
- combatant ID;
- entry sequence/first eligible round;
- EffectiveAgility;
- EffectivePerception;
- Initiative modifier breakdown;
- final InitiativeRating;
- tie-break path used;
- final round order;
- slot state transition (`PENDING → ACTED/SKIPPED/REMOVED`);
- activation-start sequence ID;
- late-entry event;
- removal/skip reason;
- invariant violation if duplicate activation was attempted.

The same authoritative inputs must produce the same ordering and trace.

---

# 17. Required future implementation tests

Before real combat implementation can call this system verified, tests must cover at least:

1. higher InitiativeRating orders first;
2. exact numeric ties resolve by Agility then Perception then stable ID;
3. repeated identical inputs produce identical order with no RNG;
4. each eligible actor starts no more than one normal activation per round;
5. reactions do not consume/create normal activation slots;
6. ending a turn early does not create another slot;
7. late entrant never acts in the already-finalized round;
8. late entrant joins the next round at the correct deterministic position;
9. actor killed/escaped before its slot becomes `REMOVED` and never acts;
10. actor temporarily ineligible at its slot becomes `SKIPPED_INELIGIBLE` and cannot reinsert that round;
11. actor removed after acting does not create a replacement slot;
12. round cannot end while any valid slot remains `PENDING`;
13. next round includes each eligible participant exactly once;
14. save/reload preserves current round order and consumed slots;
15. save/reload mid-activation does not duplicate passive Stamina recovery or AP/RP refresh;
16. camera/UI/animation events cannot advance order;
17. stable combatant IDs—not array/node order—resolve the final tie;
18. trace output reproduces formula inputs, comparator path and slot transitions.

These are future domain/runtime tests; this document itself is design-recorded, not runtime-verified.

---

# 18. First-slice acceptance checklist

This contract is design-complete when:
- [x] Initiative inputs selected;
- [x] prototype formula selected;
- [x] no random initiative roll selected;
- [x] snapshot timing selected;
- [x] deterministic tie rule selected;
- [x] one-normal-activation-per-round invariant explicit;
- [x] reaction boundary explicit;
- [x] late-entry rule explicit;
- [x] incapacitated/ineligible skip rule explicit;
- [x] dead/escaped removal rule explicit;
- [x] save/reload anti-duplication requirements recorded;
- [x] presentation ownership boundary recorded;
- [x] reproducible trace fields recorded;
- [x] future implementation tests recorded;
- [x] statuses/terrain/Monster attacks/berserk/party/failure rules kept outside scope.

## Recorded first-slice prototype

`INITIATIVE_FORMULA = (2 × EffectiveAgility) + EffectivePerception + ExplicitInitiativeModifier`

`INITIATIVE_RANDOM_ROLL = NONE`

`INITIATIVE_SNAPSHOT = ON_ENCOUNTER_ENTRY`

`NORMAL_ACTIVATIONS_PER_ELIGIBLE_ACTOR_PER_ROUND = 1`

`TIE_ORDER = RATING_DESC → AGILITY_DESC → PERCEPTION_DESC → STABLE_COMBATANT_ID_ASC`

`MID_ROUND_REORDER = NOT_SELECTED`

`LATE_ENTRY_NORMAL_ACTIVATION = NEXT_ROUND_EARLIEST`

`TEMP_INELIGIBLE_AT_SLOT = SKIP_FOR_CURRENT_ROUND`

`TERMINAL_REMOVAL = REMOVE_FROM_CURRENT_PENDING_SLOT_AND_FUTURE_ROSTERS`

`REACTION_IS_NORMAL_ACTIVATION = NO`

`COMBAT_IMPLEMENTATION = BLOCKED_BY_READINESS_GATES`

## Exact next bounded combat-design dependency

`FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT`

That next pass should define only the smallest statuses/tactical states required to prove the existing architecture. Do not combine it with terrain numbers, Monster 01 attacks, berserk, party design or defeat/retreat behavior.
