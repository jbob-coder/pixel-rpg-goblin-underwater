# Initiative and Turn-Order Prototype Pass — 2026-09-03

Status: BOUNDED DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## Bounded piece

`INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT`

This pass was executed as the active non-phone design lane after Stage-1 performance-evidence preparation closed.

Stage-1 phone implementation remains blocked on direct Galaxy A03s evidence and was not falsely marked PASS.

## Authorities reread

Before selecting the prototype, this pass reread current repository copies of:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `docs/20_gameplay/combat/README.md`;
- `docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`;
- `docs/20_gameplay/combat/COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `docs/20_gameplay/combat/STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `docs/20_gameplay/combat/FIRST_WEAPON_FAMILY_CONTRACT.md`;
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `CONTENT_DATA_GUIDE.md`;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`.

The pass intentionally did not combine statuses, terrain values, Monster 01 attacks, berserk, party design or defeat/retreat behavior.

## Completed authority

New contract:
`docs/20_gameplay/combat/INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`.

## Primary quality fix

The scheduler now has one explicit design authority for actor order instead of leaving Initiative as an open formula that could later become:
- a random opener roll;
- a second AP/extra-turn system;
- an animation/UI-driven sequence;
- a mid-round reorder source;
- a save/reload duplication bug.

Selected law:

**Initiative controls ordering only. It does not create additional ordinary activations.**

## Selected prototype formula

```text
InitiativeRating =
    (2 × EffectiveAgility)
  + EffectivePerception
  + ExplicitInitiativeModifier
```

Interpretation:
- Agility is the primary ordering input;
- Perception is a meaningful secondary awareness/readiness input;
- `ExplicitInitiativeModifier` is `0` unless another owning authority explicitly supplies a bounded traceable source;
- this pass does not invent status/terrain/ambush/equipment Initiative values.

This is a first-slice prototype target, not final production balance.

## No random Initiative roll

Selected:
`INITIATIVE_RANDOM_ROLL = NONE`.

Reason:
- stable encounter state should reproduce the same order;
- random Initiative is not needed to create tactical uncertainty because combat already has positional, anatomy, reaction and bounded resolution uncertainty;
- removing an opener roll makes replay/debug traces simpler;
- no separate Initiative RNG stream is needed.

## Snapshot timing

Selected:
`INITIATIVE_SNAPSHOT = ON_ENCOUNTER_ENTRY`.

Each actor freezes:
- EffectiveAgility;
- EffectivePerception;
- explicit Initiative modifier sources;
- final rating;
- tie-break values;
- stable combatant instance identity.

Ordinary mid-encounter changes do not silently rerun Initiative.

This prevents order oscillation and pseudo-extra turns around round boundaries.

A future explicit reorder/delay/haste mechanic requires its own bounded rule and may not be smuggled in through generic stat updates.

## Deterministic tie rule

Selected comparator:

`RATING DESC → AGILITY DESC → PERCEPTION DESC → STABLE_COMBATANT_ID ASC`.

The stable-ID guide already requires persistent/referenced entities to use stable machine identities, and runtime monster IDs are an explicit supported ID family.

The final tie may not use scene-tree order, array insertion accident, memory address, frame time or UI order.

## Round scheduler

Selected first-slice structure:
- one authoritative `RoundRoster` per round;
- one slot per current participant;
- slot states `PENDING / ACTED / SKIPPED_INELIGIBLE / REMOVED`;
- round ends only when every slot is terminal;
- current actor revalidates eligibility when its slot arrives;
- the combat domain alone selects/advances slots.

Normal activation flow respects existing owners:
1. scheduler selects the actor;
2. mark normal activation started for this `round_id`;
3. turn-start hooks execute once;
4. Stamina owner performs passive recovery once;
5. Action Economy owner refreshes AP/RP once;
6. actions/reactions resolve through their existing contracts;
7. turn-end hooks execute once;
8. slot becomes `ACTED`.

Turn Order does not independently edit AP/RP/Stamina/health/statuses/damage.

## No-extra-turn invariant

Hard law:

`NORMAL_ACTIVATIONS_PER_ELIGIBLE_ACTOR_PER_ROUND = 1`.

High Initiative, Agility, Perception, unused AP/RP, Stamina, reactions, counters, Catch Breath, UI, camera, animation, save/load and repeated input do not create another normal activation.

An implementation must reject/log a second normal-activation start for the same actor + round.

## Reaction boundary

Reactions remain out-of-turn interruptions owned by Action Economy / Combat Resolution.

They:
- do not consume the reacting actor's normal activation slot;
- do not create another normal slot;
- do not refresh resources;
- do not recursively create unlimited turns/reactions.

## Late-entry rule

Selected:
`LATE_ENTRY_NORMAL_ACTIVATION = NEXT_ROUND_EARLIEST`.

An actor accepted after the current roster is finalized:
- receives its Initiative snapshot immediately;
- gets `first_eligible_round = current_round + 1`;
- does not gain a surprise normal activation in the already-running round;
- joins the next roster in deterministic Initiative order.

No generic free ambush/opening activation was introduced.

## Incapacitated / temporarily ineligible scheduling

This pass does not define a status set.

Generic scheduling rule only:
- if actor cannot take a normal activation when its pending slot arrives, mark `SKIPPED_INELIGIBLE`;
- it cannot be reinserted later in the same round;
- it may participate next round if its owning state system says it is eligible then.

## Dead / escaped / terminal removal

Terminally removed actors:
- leave future rosters;
- pending current-round slot becomes `REMOVED`;
- an already-consumed slot stays terminal;
- no replacement/bonus slot appears.

Monster escape/reacquisition world behavior remains outside this contract.

## Save/reload anti-duplication requirements

Future persistence must preserve:
- encounter/round ID;
- Initiative snapshots;
- current roster order;
- per-slot terminal state;
- current acting actor/activation state;
- late entrants/first eligible round;
- deterministic sequence counters.

Reload may not:
- reroll Initiative;
- resurrect consumed slots;
- rerun passive Stamina recovery;
- refresh AP/RP again for an already-started activation.

## Presentation boundary

UI/animation may display order and animate transitions but may not:
- choose next actor;
- add/remove slots;
- change Initiative;
- advance round ID;
- retry skipped slots;
- refresh resources;
- generate another activation when animation/input repeats.

## Reproducible trace/test requirements

The contract records future tests for:
- formula ordering;
- all tie layers;
- no RNG/reproducibility;
- one activation per actor/round;
- reaction separation;
- late-entry next-round behavior;
- dead/escaped removal;
- ineligible skip behavior;
- round completion;
- save/reload continuity;
- presentation non-authority;
- stable-ID final tie;
- complete scheduling traces.

This is design-recorded only. No combat runtime exists, so no runtime verification is claimed.

## Package/readiness updates

Updated owners/navigation in this pass:
- `docs/20_gameplay/combat/README.md` — five core contracts recorded;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md` — Initiative dependency moves from OPEN to RECORDED and Stage-1 stale status is reconciled;
- `DOCUMENTATION_INDEX.md` — new authority/handoff mapped;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- root `README.md`;
- `EVOLVE_ALIGNMENT.md`;
- this handoff.

## Current combat gate

`ACTION_ECONOMY_CONTRACT = RECORDED`
`COMBAT_RESOLUTION_CONTRACT = RECORDED`
`FIRST_WEAPON_FAMILY_CONTRACT = RECORDED`
`STAMINA_PROTOTYPE_CONTRACT = RECORDED`
`INITIATIVE_TURN_ORDER_PROTOTYPE = RECORDED`
`COMBAT_DESIGN_READINESS = PARTIAL / FIVE_CORE_CONTRACTS_RECORDED`
`COMBAT_IMPLEMENTATION = BLOCKED_BY_READINESS_GATES`

## Stage-1 implementation lane remains unchanged

`IMPLEMENTATION_BLOCKER = GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`

`NEXT_IMPLEMENTATION_ACTION = DEFERRED_GALAXY_A03S_PERFORMANCE_AND_REGRESSION_EXECUTION_WHEN_DEVICE_AVAILABLE`

`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`

## Exact next active non-phone action

`FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT`

That next pass must stay bounded to the smallest reusable first-slice status/tactical-state set and its timing/stacking/removal/trace contract. Do not combine it with terrain values, Monster 01 attacks, berserk, party design or defeat/retreat behavior.
