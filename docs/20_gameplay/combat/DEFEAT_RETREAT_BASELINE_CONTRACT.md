# Defeat / Retreat Baseline Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/20_gameplay/combat/`

## Purpose

Define one first-slice outcome model for hunter defeat, companion downing, voluntary withdrawal, Monster defeat/death, Monster escape, encounter termination and hunt continuation without creating a second scheduler, random escape roll, combat-only duplicate actors or an unrelated game-over system.

Primary rule:

**Combat ends by authoritative actor/world state. Retreat is spatial and deterministic. Escape/death never recreates the hunter party or Monster as unrelated copies.**

This contract owns:
- first-slice Hunter Downed semantics;
- player/companion defeat boundaries;
- voluntary Hunter withdrawal;
- Monster withdrawal completion;
- encounter terminal outcomes;
- hunt continuation/failure/completion state;
- scheduler termination/removal boundaries;
- persistence/readback requirements;
- future implementation tests.

It does not own:
- final Hunter Health formulas;
- permanent Hunter death/permadeath;
- in-combat revive/treatment;
- final recovery penalties/time loss;
- reward/XP/material sharing;
- harvest quantities/methods;
- Monster Crystal/body death rules beyond consuming their terminal result;
- Region 01 topology;
- production implementation.

Supporting authorities:
- `ACTION_ECONOMY_CONTRACT.md`;
- `INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `SOLO_PARTY_BASELINE_CONTRACT.md`;
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `/GAME_EXPERIENCE_BIBLE.md`;
- `/docs/30_content/monsters/MONSTER_01/BEHAVIOR_AND_REGION.md`;
- `/docs/30_content/monsters/MONSTER_01/BERSERK_PROTOTYPE_CONTRACT.md`;
- `/CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md`.

---

# 1. First-slice actor participation states

Hunter combat participation uses these outcome-relevant states:
- `ACTIVE`;
- `DOWNED`;
- `WITHDRAWN`;
- `REMOVED_FROM_ENCOUNTER` where another authoritative terminal rule requires it.

Monster 01 consumes its existing authoritative states and adds only encounter outcome labels here:
- active/present;
- withdrawing;
- escaped;
- dead/terminal according to Crystal/body authorities.

These states are combat participation/outcome states. They do not replace Health, anatomy, statuses, Crystal Energy, world position or persistent instance identity.

---

# 2. Hunter zero-Health baseline

Selected first-slice rule:

`hunter_health <= 0 -> DOWNED`

For the first slice, `DOWNED` is **not permanent death**.

A Downed Hunter:
- cannot start a normal activation;
- cannot spend AP;
- cannot spend RP or choose a normal reaction;
- cannot issue companion orders;
- cannot move voluntarily;
- remains a persistent actor/body in the encounter state until the encounter outcome resolves;
- does not automatically recover because a round changed;
- is excluded from future RoundRosters while still Downed.

No in-combat revive action is selected for the first slice.

Permanent Hunter death, revive consumables, rescue/carry simulation and recovery penalties are later systems.

## Scheduler interaction

If a Hunter becomes Downed before its current-round slot is consumed:
- when that slot is reached, mark it `SKIPPED_INELIGIBLE`;
- do not reinsert the Hunter later in the same round;
- exclude the Downed Hunter from subsequent round-roster construction until another later owner legally changes that state.

If the Hunter already acted, its current slot remains terminal as already recorded.

Downing never refunds AP/RP/Stamina already spent and never creates a replacement slot.

---

# 3. Player Hunter defeat trigger

Selected first-slice rule:

`PLAYER_HUNTER_DOWNED -> HUNTERS_DEFEATED`

Reason:
- Solo/Party baseline gives direct player control only to the player Hunter;
- first slice does not body-switch into companions;
- first slice does not require spectator-only automated combat after the player's avatar becomes unable to act.

Procedure:
1. finish the currently authoritative action/reaction/status resolution sequence;
2. freeze further new action commitments;
3. set encounter outcome `HUNTERS_DEFEATED` unless the same resolution boundary also made the Monster terminal-dead under section 13;
4. stop the combat scheduler;
5. transition through the first-slice forced-recovery outcome.

Surviving companions are not declared dead by this transition. They are removed from the current encounter through the outcome transition. Exact rescue/recovery cost remains later design.

The defeated hunt does not magically heal or reset the living Monster.

---

# 4. Companion Downed behavior

A companion becoming Downed does **not** by itself end combat while the player Hunter remains Active.

Selected:
- companion becomes `DOWNED`;
- pending slot uses `SKIPPED_INELIGIBLE`;
- companion is excluded from future RoundRosters;
- no automatic replacement companion enters;
- player does not gain the companion's AP/RP/Stamina;
- no body switching occurs;
- no in-combat revive is selected.

The player may continue the encounter solo or with any other still-Active companions.

If the player Hunter later becomes Downed, section 3 resolves the encounter as Hunter defeat.

---

# 5. Encounter outcome states

First-slice terminal encounter outcomes:

`MONSTER_DEAD`
- current Monster instance is authoritatively dead/terminal;
- encounter ends;
- hunt objective becomes complete;
- carcass/body-part state is preserved for later harvest ownership.

`MONSTER_ESCAPED`
- Monster successfully leaves the encounter through a legal world-connected route;
- encounter ends;
- hunt remains active in reacquisition state;
- same Monster instance persists.

`HUNTERS_WITHDREW`
- player party voluntarily exits the encounter successfully;
- encounter ends;
- hunt remains active but disengaged;
- Monster persists in the world.

`HUNTERS_DEFEATED`
- player Hunter becomes Downed without a simultaneous Monster-death completion;
- current hunt fails/ends for the party;
- first-slice forced recovery transition begins;
- living Monster persists.

`MUTUAL_TERMINAL`
- same authoritative resolution boundary produces Monster death and player-Hunter Downed;
- encounter ends;
- hunt objective counts as Monster defeated;
- party is forced into recovery/extraction;
- carcass state persists;
- immediate harvest is not auto-granted by this contract.

Only one terminal encounter outcome may commit for an encounter ID.

---

# 6. Encounter-terminal scheduler law

When a terminal encounter outcome commits:
- `encounter_terminal = true`;
- no new normal activation may start;
- no new reaction window may open from presentation callbacks;
- remaining current-round `PENDING` slots become `REMOVED` with reason `ENCOUNTER_TERMINATED`;
- already `ACTED`/`SKIPPED_INELIGIBLE`/`REMOVED` slots remain terminal;
- AP/RP/Stamina do not refresh because combat ended;
- round advancement stops;
- UI/animation may finish presentation but cannot resume gameplay resolution.

`REMOVED` here means removed from this encounter scheduler, not necessarily dead in the persistent world.

---

# 7. Hunter escape geometry

Voluntary withdrawal uses authored world-connected escape positions rather than a random escape percentage.

A Hunter may complete withdrawal only from a legal `HUNTER_ESCAPE_NODE` / equivalent encounter boundary that:
- maps to a real outward route in the current Region/encounter footprint;
- is reachable through authoritative movement;
- is not blocked by an impossible body-fit/hazard/route state;
- accepts the Hunter's current physical state;
- has not been invalidated by world changes.

No generic `enemy adjacent -> escape impossible` rule is invented.

If a Monster or obstacle physically blocks the route, the spatial/route owner makes the node/path illegal. There is no hidden random tackle roll.

Movement toward an escape node uses normal movement AP/Stamina/terrain rules.

---

# 8. Individual withdrawal action

Selected action:

`WITHDRAW_FROM_ENCOUNTER`

Requirements:
- actor is Active;
- actor owns a normal activation;
- actor is currently on a legal Hunter escape node;
- legal outward route still exists at validation;
- actor is not in a state that forbids normal actions.

Prototype cost:
- `1 AP`;
- no additional Stamina cost by default beyond the movement/exertion already required to reach the escape node.

On successful commitment:
- actor becomes `WITHDRAWN`;
- actor is removed from the current encounter scheduler;
- any remaining AP/RP are discarded;
- no replacement slot is created;
- the actor's persistent world identity/resources/statuses remain.

No opportunity-attack subsystem is invented here. A future interception mechanic must be explicit and cannot arise from animation timing.

---

# 9. Solo voluntary retreat

For a solo hunt:
1. player moves through normal tactical space toward a legal Hunter escape node;
2. player commits `WITHDRAW_FROM_ENCOUNTER` for 1 AP;
3. player becomes `WITHDRAWN`;
4. encounter outcome becomes `HUNTERS_WITHDREW`;
5. return to the same persistent Region/exploration state through the encounter-transition owner.

The Monster remains the same instance with its current injuries/anatomy/Core/status/behavior memory.

The hunt becomes:
`HUNT_ACTIVE_DISENGAGED`.

The player may later reacquire/continue or abandon/return through later world/hunt owners.

---

# 10. Party voluntary retreat

Party retreat needs coordination because the player directly controls only the player Hunter.

Selected encounter action:

`DECLARE_PARTY_RETREAT`

Requirements:
- player Hunter is Active and owns the current normal activation;
- at least one companion remains an encounter participant;
- retreat has not already been declared.

Prototype cost:
- `1 AP` from the player Hunter;
- no Stamina cost by default.

Effect:
- sets authoritative `party_retreat_intent = true`;
- ordinary companion directives are temporarily superseded by the emergency withdrawal priority;
- does not move any actor;
- does not change Initiative order;
- does not create extra turns;
- does not guarantee escape.

## Companion withdrawal priority

While `party_retreat_intent == true`, each Active companion deterministically prioritizes:
1. legal movement toward a valid Hunter escape node;
2. necessary legal defensive/reposition actions supporting that withdrawal;
3. `WITHDRAW_FROM_ENCOUNTER` when escape-ready.

Companions still use their own AP/RP/Stamina and normal scheduler slots.

## Player exits last

For first-slice camera/control continuity, the player Hunter's final `WITHDRAW_FROM_ENCOUNTER` is legal only when every non-Downed companion has already become `WITHDRAWN`.

Downed companions do not block the final player withdrawal in the first-slice prototype. They are treated as recoverable/extracted by the post-encounter withdrawal outcome abstraction; exact rescue injury/time/resource penalties remain later design.

When the player successfully withdraws last:
- encounter outcome becomes `HUNTERS_WITHDREW`;
- the hunt becomes `HUNT_ACTIVE_DISENGAGED`.

No companion is automatically declared dead because it was Downed during a successful withdrawal.

---

# 11. Monster retreat route ownership

Monster 01 behavior remains the owner of **whether** Wounded Retreat / Exhausted Critical retreat is selected and which legal Region route it prefers.

This contract owns the final encounter-withdrawal completion boundary.

Monster retreat must:
- use the same persistent Monster instance;
- follow legal current encounter/Region connectivity;
- obey anatomy locomotion/body-fit restrictions;
- obey physical blockers/terrain route legality;
- preserve current injuries/anatomy/Core/strain/statuses that persist;
- never teleport to an unrelated sector;
- never duplicate detached anatomy/evidence.

---

# 12. Monster withdrawal completion

Selected final action concept:

`MONSTER_WITHDRAW_FROM_ENCOUNTER`

Requirements:
- behavior has selected a retreat state through its owner;
- Monster is alive/nonterminal;
- Monster has reached a legal Monster escape boundary/route handoff;
- body/route remains legal at validation.

First-slice commitment target:
- consumes the Monster's remaining/full normal activation opportunity for that withdrawal completion;
- no damaging attack is resolved in the same activation after successful withdrawal commitment;
- no extra turn is created.

On success:
- Monster leaves current combat participation;
- current encounter outcome becomes `MONSTER_ESCAPED`;
- hunt state becomes `HUNT_ACTIVE_REACQUIRE`;
- world/Region behavior receives the same Monster instance plus route intent/state;
- aerial exploration resumes from the same physical hunt continuity.

Tracking evidence such as blood/scuffs/changed gait remains owned/emitted by Monster behavior/world systems.

---

# 13. Monster defeat / death boundary

This contract does **not** invent a generic `monster_hp <= 0 -> dead` rule that bypasses Crystal/anatomy ownership.

Monster 01 is dead only when the current owning Crystal/body terminal rules say it is dead.

Current locked example:

`core_energy_current <= 0 -> creature death`.

When Monster death becomes authoritative:
- stop any further action commitment immediately;
- clear/stop Berserk as its owner requires;
- mark Monster removed from future scheduler participation;
- preserve final anatomy/part condition;
- preserve detached parts already created;
- commit `MONSTER_DEAD` after the current authoritative resolution boundary closes;
- transition hunt state to `HUNT_COMPLETE_MONSTER_DEAD`.

Death animation does not decide death timing.

The next harvest owner consumes the final body/part state; this contract does not generate loot.

---

# 14. Simultaneous terminal outcome rule

Outcome checks happen after one authoritative resolution/event boundary applies all of its owned state changes.

If that same boundary results in:
- Monster terminal-dead; and
- player Hunter Downed;

commit:
`MUTUAL_TERMINAL`.

Selected first-slice meaning:
- Monster-defeat objective counts as complete;
- player party is force-extracted/recovered;
- no additional combat turns occur;
- carcass/part state persists;
- immediate harvest is not automatically credited;
- later harvest/world persistence rules decide whether/when the carcass can be reached again.

This prevents event-order accidents from turning the same deterministic resolution into different outcomes.

---

# 15. Outcome -> hunt-state mapping

| Encounter outcome | Hunt state | Immediate destination |
|---|---|---|
| `MONSTER_DEAD` | `HUNT_COMPLETE_MONSTER_DEAD` | post-combat/harvest eligibility state |
| `MONSTER_ESCAPED` | `HUNT_ACTIVE_REACQUIRE` | aerial Region exploration/tracking |
| `HUNTERS_WITHDREW` | `HUNT_ACTIVE_DISENGAGED` | aerial Region exploration at party withdrawal route |
| `HUNTERS_DEFEATED` | `HUNT_FAILED_HUNTER_DOWNED` | forced recovery/return transition |
| `MUTUAL_TERMINAL` | `HUNT_COMPLETE_FORCED_EXTRACTION` | forced recovery with persistent carcass state |

Exact recovery location/time/fees/material loss after Hunter defeat are intentionally not selected here.

No encounter outcome duplicates the Monster or resets its persistent injuries merely because perspective changed.

---

# 16. Encounter transition continuity

When combat ends without Monster death:
- exploration/combat use the same actor IDs;
- Monster position/sector/route state is handed back to world behavior;
- Hunter/companion positions are handed back through the appropriate escape/transition route;
- statuses/injuries/resources persist according to their own owners;
- no combat-only clone is destroyed and replaced with a fresh world clone;
- camera transition is presentation only.

When Monster dies:
- final carcass/part state belongs to that same instance/death record;
- the later harvest layer reads it rather than spawning unrelated randomized loot.

---

# 17. Defeat recovery boundary

First-slice Hunter defeat uses a safe recovery transition rather than permanent death.

Selected ownership boundary:
- this contract emits `HUNT_FAILED_HUNTER_DOWNED`;
- it preserves party/Monster outcome state;
- a later recovery/economy/world owner decides exact time loss, treatment state, item/material loss (if any), fees, reputation or settlement recovery location.

This contract deliberately does **not** invent punitive loss numbers.

The living Monster remains in the world with its authoritative state unless another world lifecycle rule later changes it.

---

# 18. Save/reload continuity

Future persistence must save enough state to prevent duplicated escape/death/outcome resolution.

Minimum fields:
- encounter ID;
- `encounter_terminal`;
- committed encounter outcome if any;
- hunt state;
- player/companion participation states;
- `party_retreat_intent`;
- which companions already withdrew;
- current RoundRoster/slot states;
- actor positions/escape-node context;
- Monster persistent instance ID;
- Monster route/sector intent;
- Monster anatomy/Crystal/Berserk/status state;
- sequence ID of the action/event that committed the terminal outcome.

Reload must not:
- revive a Downed Hunter inside the same encounter;
- reopen an already terminal encounter;
- recreate a withdrawn actor's slot;
- rerun the withdrawal action cost;
- duplicate Monster escape evidence;
- respawn a fresh uninjured Monster after escape;
- replay zero-Core death;
- duplicate a carcass or severed part;
- reroll a previously committed outcome.

---

# 19. Debug / trace contract

Development trace should show:
- encounter ID / hunt ID;
- current hunt state;
- current actor participation states;
- player Health/downed transition;
- current legal Hunter escape nodes and rejection reasons;
- party retreat declaration and 1-AP commitment;
- companion withdrawal priority state;
- each withdrawal validation/result;
- Monster retreat behavior state/route;
- Monster escape-boundary validation;
- terminal Monster death source;
- final encounter outcome;
- scheduler slot closures/removals;
- outcome sequence ID;
- persistence handoff target.

Example:

```text
PLAYER: ACTIVE
COMPANION_A: WITHDRAWN
PARTY_RETREAT_INTENT: TRUE
PLAYER_ESCAPE_NODE: PASS
WITHDRAW_FROM_ENCOUNTER: COMMIT 1 AP
OUTCOME: HUNTERS_WITHDREW
HUNT_STATE: HUNT_ACTIVE_DISENGAGED
MONSTER_INSTANCE: species_r01_mudcrest_raker#0042 PRESERVED
```

---

# 20. Presentation boundary

Presentation may:
- show Downed state;
- show escape route availability;
- show retreat intent;
- animate actors leaving the encounter;
- transition camera back to aerial exploration;
- show outcome messaging.

Presentation may not:
- down/revive an actor independently;
- choose a terminal outcome;
- create an escape node;
- make an illegal route legal;
- remove a scheduler slot independently;
- heal/reset the Monster on transition;
- duplicate a carcass/part;
- grant harvest/rewards;
- continue combat after `encounter_terminal`.

---

# 21. Explicitly deferred

Not selected in this packet:
- permanent Hunter death/permadeath;
- in-combat revive;
- dragging/carrying a Downed ally node-by-node;
- exact rescue/recovery penalties;
- opportunity attacks on withdrawal;
- surrender/capture;
- Monster capture/subdual;
- multi-hostile encounter end rules beyond first-slice single-Monster proof;
- retreat reward/XP calculations;
- loot/material sharing;
- insurance/fees/reputation loss;
- friendly fire;
- PvP/multiplayer escape rules.

These do not block the first-slice outcome baseline unless a later implementation gate genuinely consumes them.

---

# 22. Future implementation verification

Before runtime verification, tests must cover at least:

1. Hunter Health at/below zero transitions to Downed once;
2. Downed Hunter cannot start a normal activation;
3. Downed Hunter cannot react or issue companion orders;
4. pending Downed slot becomes `SKIPPED_INELIGIBLE`;
5. Downed Hunter is excluded from later round rosters;
6. companion Downed does not end combat while player remains Active;
7. player Downed commits Hunter defeat after current resolution;
8. player Downed does not transfer control to a companion;
9. Hunter defeat stops new actions/round advancement;
10. solo withdrawal requires a legal escape node;
11. solo withdrawal costs exactly 1 AP once;
12. invalid escape route rejects before commitment;
13. withdrawal removes actor from future encounter slots;
14. withdrawal does not refresh/refund resources;
15. party retreat declaration costs player exactly 1 AP once;
16. retreat declaration does not reorder Initiative;
17. companions use own AP/RP/Stamina while withdrawing;
18. companions follow deterministic withdrawal priority;
19. player final withdrawal rejects while a non-Downed companion remains Active in encounter;
20. player final withdrawal succeeds after all non-Downed companions withdrew;
21. Downed companion does not deadlock successful first-slice withdrawal;
22. successful Hunter withdrawal yields `HUNTERS_WITHDREW`;
23. Hunter withdrawal keeps living Monster instance/state unchanged;
24. Monster withdrawal requires legal behavior route/boundary;
25. Monster withdrawal cannot also resolve a damaging attack afterward;
26. Monster escape yields `MONSTER_ESCAPED` + `HUNT_ACTIVE_REACQUIRE`;
27. escaped Monster keeps same instance ID/anatomy/Core/Berserk state;
28. zero Core Energy death stops further Monster action;
29. Monster death yields `MONSTER_DEAD` + hunt completion;
30. Monster death preserves final anatomy/part state for harvest;
31. same-boundary Monster death + player Downed yields `MUTUAL_TERMINAL` deterministically;
32. terminal encounter closes remaining pending scheduler slots;
33. terminal outcome commits at most once;
34. save/reload preserves retreat intent/withdrawn/downed states;
35. save/reload does not duplicate withdrawal costs;
36. save/reload after Monster escape does not spawn a new healthy Monster;
37. save/reload after death does not duplicate carcass/severed parts;
38. UI/animation cannot change terminal outcome or reopen combat;
39. identical authoritative state/sequence reproduces identical outcome trace;
40. defeat recovery transition does not silently apply unowned reward/loss rules.

These are future domain/runtime tests. This document itself is design-recorded, not runtime-verified.

---

# 23. First-slice acceptance

Design-complete when:
- [x] Hunter Downed semantics selected;
- [x] player defeat trigger selected;
- [x] companion Downed boundary selected;
- [x] solo withdrawal path selected;
- [x] party withdrawal path selected;
- [x] Monster withdrawal completion boundary selected;
- [x] Monster death ownership preserved;
- [x] encounter terminal outcomes selected;
- [x] hunt-state mapping selected;
- [x] scheduler termination rules selected;
- [x] persistence/anti-duplication requirements recorded;
- [x] no reward/harvest/recovery-number expansion bundled into scope;
- [x] future tests recorded.

`DEFEAT_RETREAT_BASELINE_RECORDED = YES`
`DEFEAT_RETREAT_RUNTIME_IMPLEMENTED = NO`
`DEFEAT_RETREAT_RUNTIME_VERIFIED = NO`

## Exact next independent design dependency

`FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT`

That next pass should define anatomical harvest capacity, surviving usable mass/condition, clean sever versus damaged-part consequences, carcass/severed-part depletion, tool/knowledge modifiers and anti-duplication rules without bundling crafting/economy implementation.