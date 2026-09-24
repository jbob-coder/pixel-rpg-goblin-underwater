# Defeat / Retreat Baseline Pass — 2026-09-03

Status: BOUNDED GAMEPLAY-DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## Bounded piece

`DEFEAT_RETREAT_BASELINE_CONTRACT`

This pass advances the game-design lane while direct Galaxy A03s Stage-1 evidence remains deferred. The game is the objective; documentation records ownership, design truth, verification boundaries and exact continuation.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `docs/70_handoff/SOLO_PARTY_BASELINE_PASS_2026-09-03.md`;
- root `README.md` and `docs/README.md`;
- `ACTION_ECONOMY_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- current Initiative/Solo-Party scheduler rules;
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- Monster 01 `BEHAVIOR_AND_REGION.md`;
- Monster 01 `BERSERK_PROTOTYPE_CONTRACT.md`;
- current gameplay/combat/readiness front doors.

The pass did not define reward sharing, exact defeat penalties, permanent Hunter death, revive, harvest quantities, crafting/economy or production source.

## New authority

`docs/20_gameplay/combat/DEFEAT_RETREAT_BASELINE_CONTRACT.md`.

This is the ninth reusable first-slice combat/outcome contract.

## Hunter Downed

Selected:
`hunter_health <= 0 -> DOWNED`.

First slice:
- Downed is not permanent death;
- Downed actor cannot activate/react/command/move voluntarily;
- pending slot becomes `SKIPPED_INELIGIBLE`;
- Downed actor is excluded from later round rosters;
- no in-combat revive is selected.

## Player defeat

Selected:
`PLAYER_HUNTER_DOWNED -> HUNTERS_DEFEATED` after the current authoritative resolution boundary closes.

Reason:
- player directly controls only the player Hunter;
- no body switching is selected;
- first slice avoids spectator-only companion combat after player control is lost.

Surviving companions are not declared dead. Exact recovery penalties remain later design.

## Companion Downed

A Downed companion does not end combat while the player Hunter remains Active.

It loses future encounter activations and no replacement slot/resource transfer occurs.

## Terminal encounter outcomes

Selected:
- `MONSTER_DEAD`;
- `MONSTER_ESCAPED`;
- `HUNTERS_WITHDREW`;
- `HUNTERS_DEFEATED`;
- `MUTUAL_TERMINAL`.

Only one terminal outcome may commit for one encounter ID.

Terminal encounter state stops new activations/reactions/round advancement and closes remaining pending slots with `ENCOUNTER_TERMINATED` removal reason.

## Voluntary Hunter retreat

Escape is spatial/deterministic.

There is no generic random escape roll.

Actor must reach a legal world-connected Hunter escape node through normal movement.

Final action:
`WITHDRAW_FROM_ENCOUNTER` = `1 AP`, no extra Stamina by default beyond movement already spent.

Successful withdrawal removes that actor from the current scheduler without refreshing/refunding resources.

## Solo retreat

Solo player reaches legal escape node and commits withdrawal.

Outcome:
`HUNTERS_WITHDREW`.

Hunt state:
`HUNT_ACTIVE_DISENGAGED`.

The living Monster remains the same persistent instance/state.

## Party retreat

Selected player action:
`DECLARE_PARTY_RETREAT` = `1 AP`.

It sets an encounter-level retreat intent and temporarily overrides normal companion directives with deterministic emergency-withdrawal priority.

Companions:
- move/withdraw on their own normal Initiative slots;
- use their own AP/RP/Stamina;
- receive no extra turns;
- withdraw through the same `WITHDRAW_FROM_ENCOUNTER` legality.

Player exits last: final player withdrawal is legal only after every non-Downed companion has already withdrawn.

Downed companions do not deadlock successful first-slice withdrawal; post-encounter recovery is abstracted and exact rescue penalties remain later work.

## Monster retreat

Monster 01 behavior still decides when retreat is selected and which legal Region route is preferred.

This contract owns final escape completion.

`MONSTER_WITHDRAW_FROM_ENCOUNTER` requires a legal current world-connected escape boundary and consumes the Monster's remaining/full normal activation opportunity; no damaging attack follows in that activation.

Outcome:
`MONSTER_ESCAPED`.

Hunt state:
`HUNT_ACTIVE_REACQUIRE`.

Same Monster instance, injuries, anatomy, Core/Berserk state and route intent persist.

## Monster death

This pass does not create a generic HP-death shortcut.

Current Crystal/body owners remain authoritative. Existing hard example:
`core_energy_current <= 0 -> creature death`.

On authoritative Monster death:
- stop further action commitment;
- preserve final anatomy/parts;
- encounter outcome becomes `MONSTER_DEAD`;
- hunt state becomes `HUNT_COMPLETE_MONSTER_DEAD`;
- later harvest authority reads that state instead of generating disconnected loot.

## Simultaneous terminal boundary

If one authoritative resolution boundary produces both Monster death and player-Hunter Downed:
`MUTUAL_TERMINAL`.

The Monster objective counts complete, party is force-extracted/recovered, carcass state persists and immediate harvest is not automatically credited.

## Hunt-state map

- Monster dead -> `HUNT_COMPLETE_MONSTER_DEAD`;
- Monster escaped -> `HUNT_ACTIVE_REACQUIRE`;
- Hunters withdrew -> `HUNT_ACTIVE_DISENGAGED`;
- player defeated -> `HUNT_FAILED_HUNTER_DOWNED`;
- mutual terminal -> `HUNT_COMPLETE_FORCED_EXTRACTION`.

## Persistence

Save/load must preserve encounter terminal/outcome, hunt state, Downed/withdrawn party states, party retreat intent, scheduler state, Monster instance/route/anatomy/Core/Berserk/status state and terminal outcome sequence ID.

Reload may not duplicate withdrawal costs, revive Downed actors inside the same encounter, respawn a fresh Monster after escape, replay death, duplicate carcasses/parts or reopen a terminal encounter.

## Future implementation verification

The new contract records 40 minimum checks covering:
- Downed transitions/eligibility;
- player/companion defeat differences;
- spatial escape legality;
- solo/party retreat AP/scheduler behavior;
- Monster escape continuity;
- Crystal-owned death;
- mutual terminal ordering;
- terminal scheduler closure;
- persistence/anti-duplication;
- presentation non-authority.

No runtime verification is claimed because production combat/outcome source does not yet exist.

## Documentation/navigation reconciliation

This pass maps/updates:
- `docs/20_gameplay/combat/DEFEAT_RETREAT_BASELINE_CONTRACT.md`;
- combat/gameplay READMEs;
- Monster 01 behavior retreat-owner link;
- build-readiness matrix;
- root README;
- `DOCUMENTATION_INDEX.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `EVOLVE_ALIGNMENT.md`;
- this specialized handoff.

## Verification boundary

`DEFEAT_RETREAT_BASELINE_RECORDED = YES`
`DEFEAT_RETREAT_RUNTIME_IMPLEMENTED = NO`
`DEFEAT_RETREAT_RUNTIME_VERIFIED = NO`

The nine generic first-slice combat-design contracts are now recorded, but real combat implementation remains blocked by prior engine/domain implementation gates.

Stage-1 phone truth remains unchanged:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next independent non-phone action

`FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT`

That next pass should create/own the harvest gameplay package as needed and define anatomical capacity, surviving usable mass/condition, clean sever/damage consequences, carcass/severed-part depletion, tool/knowledge modifiers, deterministic yield traces and anti-duplication without bundling crafting/economy implementation.