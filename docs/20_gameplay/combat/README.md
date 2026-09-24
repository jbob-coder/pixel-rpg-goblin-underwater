# 20_gameplay/combat — Tactical Combat Package

Status: ACTIVE DESIGN PACKAGE / NINE GENERIC FIRST-SLICE CONTRACTS RECORDED / MONSTER 01 NORMAL ATTACK + BERSERK CONTENT RECORDED / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Own reusable first-person turn-based combat rules. Monster/content packages consume these rules without redefining timing, resolution, resources, status, terrain, party-control, scheduler or encounter-outcome laws.

The game is the objective. This README maps generic ownership, current content consumers, readiness and exact continuation.

## Generic combat authorities

1. `ACTION_ECONOMY_CONTRACT.md` — 4 AP / 1 RP / persistent Stamina / bounded reactions / one normal activation max.
2. `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md` — hard legality, contact/defense/cover, bounded seeded variance and hit-quality pipeline.
3. `FIRST_WEAPON_FAMILY_CONTRACT.md` — Field Poleblade.
4. `STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md` — normalized 100-point reference, +10 passive, Catch Breath and explicit costs.
5. `INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md` — deterministic snapshot/no random opener/no ordinary extra turns.
6. `FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md` — Bleeding/Staggered/Off-Balance/Braced/Guarded, no independent status RNG.
7. `FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md` — Stable/Rough/Shallow Water/Mud + Brush/High Ground/Narrow, no terrain slip RNG.
8. `SOLO_PARTY_BASELINE_CONTRACT.md` — solo-capable optional parties, max three active Hunters, player controls own Hunter only, deterministic companion behavior/orders.
9. `DEFEAT_RETREAT_BASELINE_CONTRACT.md` — Downed/defeat, spatial voluntary withdrawal, Monster escape/death, encounter termination and hunt-state continuity.

## Solo / party baseline

Selected:
- `FIRST_SLICE_PARTY_MODE = SOLO_CAPABLE_WITH_OPTIONAL_COMPANIONS`;
- `MAX_ACTIVE_HUNTERS_IN_PARTY = 3`;
- player + zero to two companions;
- `PLAYER_DIRECT_CONTROL = PLAYER_HUNTER_ONLY`;
- no shared party AP/RP/Stamina;
- all actors use the same Initiative/RoundRoster;
- companions use deterministic authored behavior;
- player may issue one successful 1-AP companion order per own activation;
- companion reactions use their own RP/Stamina;
- absent companions do not teleport into encounters;
- late entrants wait until next round.

## Defeat / retreat baseline

Authority:
`DEFEAT_RETREAT_BASELINE_CONTRACT.md`.

Selected first-slice outcome laws:
- Hunter Health `<=0` -> `DOWNED`, not permanent death;
- Downed Hunters cannot activate/react/command and are excluded from later rosters;
- no in-combat revive is selected;
- player Hunter Downed commits `HUNTERS_DEFEATED` after the current authoritative resolution boundary;
- companion Downed alone does not end combat while player remains Active;
- escape is physical/deterministic through legal world-connected escape nodes, not a random percentage roll;
- `WITHDRAW_FROM_ENCOUNTER` = 1 AP from a legal escape node;
- party retreat declaration = player 1 AP and companions withdraw on their own scheduler slots/resources;
- player exits last after all non-Downed companions have withdrawn;
- Monster behavior selects retreat route; outcome owner validates final Monster withdrawal;
- Monster escape -> `HUNT_ACTIVE_REACQUIRE` with same persistent Monster instance;
- Hunter voluntary withdrawal -> `HUNT_ACTIVE_DISENGAGED`;
- Monster death remains owned by Crystal/body terminal rules; current hard example is zero Core Energy;
- Monster death preserves final anatomy/part state for harvest;
- simultaneous Monster death + player Downed -> deterministic `MUTUAL_TERMINAL`;
- terminal encounter stops scheduler advancement and closes remaining pending slots.

## Monster 01 content consumers

Package:
`/docs/30_content/monsters/MONSTER_01/`.

Normal attack authority:
`COMBAT_ATTACK_PACKET.md`.

Selected attacks:
- Horn Charge 4 AP / 30 Stamina;
- Head Sweep/Gore 2 / 14;
- Shoulder Ram 3 / 22;
- Foreleg Stomp 2 / 12;
- Tail Sweep 3 / 18.

Normal laws:
- internal 4-AP budget;
- max one damaging attack per activation;
- anatomy/range/bearing/clearance/cover are hard legality;
- authoritative telegraph/reaction windows;
- no separate status-proc RNG;
- normal attacks do not spend Crystal Energy by default.

Berserk authority:
`BERSERK_PROTOTYPE_CONTRACT.md`.

Selected Berserk content:
- deterministic desperation entry;
- explicit Core Energy/strain drain;
- bounded AP discounts to existing anatomy-legal attacks;
- existing Stamina costs unchanged;
- max one damaging attack remains;
- no Initiative reroll/extra turn/reaction removal/anatomy repair;
- critical exit can transition into retreat;
- zero Core Energy means death.

## Ownership

- Action Economy owns AP/RP/timing.
- Stamina owns Stamina rules/base costs.
- Initiative owns scheduler/order/late-entry/slot semantics.
- Status owner owns status lifetime/stacking/removal.
- Terrain owner owns generic terrain costs/tags.
- Combat Resolution owns contact/defense/cover/hit quality.
- Field Poleblade owns Hunter weapon capabilities.
- Solo/Party baseline owns party participation/control/companion-command boundaries.
- Defeat/Retreat baseline owns first-slice Downed/outcome/withdrawal/encounter-terminal/hunt-state boundaries.
- Behavior Pattern System owns generic deterministic actor behavior architecture.
- Monster 01 attack packet owns normal attack profiles/legality.
- Monster 01 Berserk packet owns Berserk state/Energy/strain/action modifiers.
- Monster 01 behavior selects legal action/retreat route candidates.
- Region 01 owns physical terrain/cover/escape-route placement.

No lower-level content or presentation file may silently override a generic owner.

## Presentation boundary

UI/animation may visualize state, telegraphs, resources, companions, commands, Downed/escape/outcome state and camera transitions but never:
- advances turns;
- creates/removes scheduler slots independently;
- spends/refunds resources independently;
- selects companion/Monster actions;
- changes escape-route legality;
- commits terminal outcome;
- reopens terminal combat;
- resurrects/duplicates escaped/dead actors;
- grants harvest/rewards independently.

## Current combat-design gate

Recorded generic first-slice contracts:
Action Economy / Resolution / First Weapon / Stamina / Initiative / Status / Terrain / Solo-Party / Defeat-Retreat.

Recorded Monster 01 content:
- normal attack packet;
- Berserk prototype.

`SOLO_PARTY_BASELINE_RECORDED = YES`
`DEFEAT_RETREAT_BASELINE_RECORDED = YES`
`MONSTER_01_ATTACK_PACKET_RECORDED = YES`
`MONSTER_01_BERSERK_PROTOTYPE_RECORDED = YES`
`COMBAT_DESIGN_BASELINE_COMPLETE = YES`
`COMBAT_RUNTIME_IMPLEMENTED = NO`
`COMBAT_RUNTIME_VERIFIED = NO`

Real combat production implementation remains blocked by the Stage-1 phone gate and subsequent production domain/stats/Crystal/content implementation gates.

## Exact next independent gameplay dependency

`FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT`

That pass should create the harvest gameplay package/front door as needed and define per-anatomy capacity, surviving usable mass/condition, clean sever versus damaged-part outcomes, carcass/severed-part depletion, tool/knowledge modifiers, deterministic yield traces and anti-duplication.

Do not bundle crafting/economy implementation into that pass.