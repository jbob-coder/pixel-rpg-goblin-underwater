# Monster 01 Berserk Prototype Pass — 2026-09-03

Status: BOUNDED CONTENT/DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## Bounded piece

`MONSTER_01_BERSERK_PROTOTYPE_CONTRACT`

This pass advances Monster 01's first-slice combat/content design while direct Galaxy A03s Stage-1 evidence remains deferred. The game is the objective; documentation records ownership, verification boundaries and exact continuation.

## Authorities reread

Current repository copies reread before the design was recorded:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `docs/70_handoff/MONSTER_01_COMBAT_ATTACK_PACKET_PASS_2026-09-03.md`;
- Monster 01 `README.md`;
- `ANATOMY_AND_DAMAGE.md`;
- `COMBAT_ATTACK_PACKET.md`;
- `BEHAVIOR_AND_REGION.md`;
- `CRYSTAL_AND_MUTATION.md`;
- `/CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md`;
- generic combat/status/terrain/Initiative/Stamina owners needed by the packet.

The pass did not define party composition, defeat/retreat resolution, final health/damage numbers, final Crystal capacity or production code.

## New authority

`docs/30_content/monsters/MONSTER_01/BERSERK_PROTOTYPE_CONTRACT.md`.

This is Monster 01 content configuration of the generic Crystal/combat/behavior systems, not a new generic combat contract.

## Selected entry gate

Berserk entry requires all hard gates:
- alive;
- not already Berserk;
- episode not already used this hunt;
- `core_energy_ratio > 0.20`;
- `core_energy_ratio <= 0.60`;
- nonterminal state;
- at least one desperation pressure: Retreat Denied, Nest Defense or Severe Anatomy.

Severe Anatomy requires at least two major capability-loss facts; one broken part alone is not enough.

No HP-only trigger and no random berserk roll exist.

## Entry transition

`M01_ENTER_BERSERK`:
- consumes all 4 AP of the normal activation;
- cannot also attack in that activation;
- costs `10% of core_energy_max`;
- adds `+20 core_strain`;
- sets active + episode-used;
- ends the activation.

The transition is deliberately visible/readable before Berserk attack pressure begins.

## Energy/strain cadence

Every later Berserk normal activation that remains active:
- pays `5% of core_energy_max` before action selection;
- adds `+10 strain`;
- dies immediately if Energy reaches zero.

Berserk attack surcharges:
- Horn Charge: `5% max Energy / +12 strain`;
- Head Sweep/Gore: `2% / +5`;
- Shoulder Ram: `4% / +8`;
- Foreleg Stomp: `2% / +4`;
- Tail Sweep: `3% / +6`.

Attack surcharge is paid once at commitment and cannot reduce Energy to zero/below; otherwise the attack is illegal.

Core strain is a normalized `0..100` trace/state scale. `>=80` participates in critical-exit evaluation; it does not secretly buff/nerf damage or Initiative.

## Berserk action changes

Existing attacks remain the only damaging attack set.

Berserk AP costs:
- Horn Charge `3`;
- Head Sweep/Gore `2`;
- Shoulder Ram `2`;
- Foreleg Stomp `2`;
- Tail Sweep `2`.

Existing Stamina costs remain unchanged.

Hard invariants:
- one normal activation per round;
- one damaging attack max per activation;
- AP savings can support legal reposition/setup only, not a second attack;
- no Initiative reroll/extra turn;
- all existing telegraph/reaction windows remain;
- no new Precision/crit/status-proc layer.

## Anatomy remains absolute

Berserk never repairs or substitutes anatomy.

- broken full Horn Charge capability remains broken;
- hornless Head Sweep remains impact-only;
- disabled forequarter Ram/Charge remains disabled;
- damaged-side Stomp remains illegal;
- severed Tail Sweep remains illegal;
- Narrow/cover/clearance still block attacks normally.

## Critical exit

Before each Berserk activation drain:

`BERSERK_CRITICAL = core_energy_ratio <= 0.12 OR core_strain >= 80`.

If critical + legal retreat + no active nest-defense pressure:
- Berserk ends;
- state becomes `EXHAUSTED_CRITICAL`;
- no 5% drain that activation;
- episode-used stays true.

If critical but retreat unavailable or nest-defense pressure persists:
- Berserk continues and keeps consuming life force, potentially to death.

The exact retreat action/resolution remains owned elsewhere.

## Status/reaction boundary

Berserk grants no blanket immunity.
Bleeding/Staggered/Off-Balance continue to function.
Existing attack reaction compatibility is unchanged.

## Persistence

Save/load and encounter escape/reacquisition preserve:
- Energy/max;
- strain;
- Berserk active/episode-used;
- entry round/activation count;
- anatomy capabilities;
- behavior state.

No reload may duplicate entry/drain/surcharge or restore anatomy.

## Future implementation verification

The contract records 35 minimum tests covering:
- Energy-window/pressure entry gating;
- one-episode rule;
- entry activation/readability;
- exact Energy/strain costs;
- AP discounts without multiattack;
- Stamina separation;
- anatomy/terrain/cover legality;
- status/reaction preservation;
- critical exit;
- zero-Energy death;
- persistence/save-load;
- deterministic replay.

No runtime verification is claimed because the required production Crystal/combat/behavior source does not yet exist.

## Documentation/navigation reconciliation

This pass requires reconciliation of:
- Monster 01 `README.md`;
- `CRYSTAL_AND_MUTATION.md`;
- `BEHAVIOR_AND_REGION.md`;
- `docs/30_content/README.md`;
- gameplay/combat front doors;
- build-readiness matrix;
- root README;
- global documentation index;
- project/new-chat handoffs;
- EVOLVE;
- this specialized handoff.

## Verification boundary

`MONSTER_01_BERSERK_PROTOTYPE_RECORDED = YES`
`MONSTER_01_BERSERK_RUNTIME_IMPLEMENTED = NO`
`MONSTER_01_BERSERK_RUNTIME_VERIFIED = NO`

Stage-1 phone truth remains unchanged:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next active non-phone action

`SOLO_PARTY_BASELINE_CONTRACT`

That next pass must define only first-slice solo-vs-party participation, control authority, party-size assumptions and turn/scheduler ownership. It must not simultaneously define defeat/retreat resolution or production combat implementation.