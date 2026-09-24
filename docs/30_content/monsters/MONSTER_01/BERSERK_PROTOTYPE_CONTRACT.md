# MONSTER_01 — Berserk Prototype Contract

Status: SELECTED FIRST-SLICE CONTENT CONTRACT / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/30_content/monsters/MONSTER_01/`
Species: `species_r01_mudcrest_raker`
Working display name: Mudcrest Raker

## Purpose

Define the first-slice desperation/berserk behavior for Monster 01 using the existing Crystal life-force, anatomy, combat, status, terrain and deterministic-behavior systems.

Primary rule:

**Berserk converts remaining Crystal life force into a short, readable increase in attack commitment/aggression. It never repairs lost anatomy, creates a second action economy, grants extra normal activations or bypasses attack legality.**

This file owns Monster 01's first-slice berserk entry, Energy/strain costs, state lifetime, bounded attack-cost/priority changes, exit/critical/death rules, persistence and test requirements.

It does not own:
- generic Crystal semantics or zero-Energy death law;
- generic AP/RP/Stamina timing;
- generic hit/contact/defense resolution;
- generic status stacking/timing;
- Monster 01 normal attack anatomy/range/reaction definitions;
- Region 01 geography;
- party composition/control;
- defeat/retreat resolution;
- final absolute Crystal capacity;
- final health/damage values;
- production implementation.

Supporting authorities:
- `README.md`;
- `ANATOMY_AND_DAMAGE.md`;
- `COMBAT_ATTACK_PACKET.md`;
- `BEHAVIOR_AND_REGION.md`;
- `CRYSTAL_AND_MUTATION.md`;
- `/CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md`;
- `/BEHAVIOR_PATTERN_SYSTEM.md`;
- `/docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`;
- `/docs/20_gameplay/combat/COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `/docs/20_gameplay/combat/STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `/docs/20_gameplay/combat/INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `/docs/20_gameplay/combat/FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`;
- `/docs/20_gameplay/combat/FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`.

---

# 1. Runtime state fields

First-slice Monster 01 runtime state needs at least:
- `berserk_active: bool`;
- `berserk_episode_used: bool`;
- `berserk_entry_round_id`;
- `berserk_activation_count`;
- `core_energy_current`;
- `core_energy_max`;
- `core_strain` normalized first-slice trace scale `0..100`;
- current anatomy capability state;
- current behavior state;
- current retreat/nest-pressure facts.

`berserk_episode_used` persists through encounter escape/reacquisition during the same hunt. Encounter/camera reload does not reset it.

It may reset only through a later explicit ecological recovery/rest lifecycle owner. The first slice does not invent that recovery here.

---

# 2. Core Energy normalization

Berserk costs are percentages of the creature's authoritative `core_energy_max` so this packet can be exact without prematurely fixing one absolute Crystal-capacity number.

Use:

`core_energy_ratio = core_energy_current / core_energy_max`.

Locked generic law remains:

`core_energy_current <= 0 → creature death`.

Every percentage cost resolves to an implementation-defined deterministic Energy unit amount from the authoritative maximum. Rounding must use one documented deterministic rule; UI never rounds independently.

Crystal Energy is separate from Stamina.

---

# 3. Exact first-slice entry gate

Monster 01 may select `M01_ENTER_BERSERK` only when every hard gate passes:

1. creature is alive;
2. `berserk_active == false`;
3. `berserk_episode_used == false`;
4. `core_energy_ratio > 0.20`;
5. `core_energy_ratio <= 0.60`;
6. creature is not already in a terminal/removal state;
7. at least one desperation pressure predicate is true.

The Energy window means the Raker does not berserk while still comfortably resourced and does not begin an overdrive it is too depleted to sustain.

## Desperation pressure predicates

At least one must be true:

### `PRESSURE_RETREAT_DENIED`
The existing behavior/Region route filter finds no legal preferred retreat route from the current encounter state.

### `PRESSURE_NEST_DEFENSE`
The Raker is in the authored nest/core-territory defense context and the hunter is an active threat to that territory.

### `PRESSURE_SEVERE_ANATOMY`
At least two major capability-loss facts caused by real anatomy state are true:
- full Horn Charge capability lost from horn/forequarter damage;
- Forequarter Ram capability lost from severe support damage;
- Tail Sweep capability lost from distal-tail sever/pivot failure;
- severe locomotor support state affecting at least two legs.

One broken part by itself does not automatically force berserk.

No HP-percentage-only trigger is selected.

## Deterministic priority

When the exact entry gate passes, behavior may select berserk above ordinary attack/recovery choice according to the species' desperation branch. No random berserk roll exists.

---

# 4. `M01_ENTER_BERSERK` transition action

Entering berserk is intentionally readable and costs a normal activation.

Selected transition:
- AP commitment: all `4 AP` of the current Monster 01 normal activation;
- damaging attacks during that same activation: `0`;
- Crystal Energy cost: `10% of core_energy_max`;
- Crystal strain: `+20`;
- Stamina cost: `0` for the transition itself;
- marks `berserk_episode_used = true`;
- sets `berserk_active = true` after successful Energy payment;
- records `berserk_entry_round_id`;
- ends the normal activation after the transition resolves.

If the Energy payment would reduce Energy to `<= 0`, entry is illegal and behavior must choose another legal critical-state option.

This prevents a surprise free power-up followed by an immediate attack in the same activation.

---

# 5. Entry telegraph

The authoritative transition emits a berserk-state telegraph before the state becomes active.

Required readable cues:
- posture stiffens/lowers into aggressive forequarter loading;
- breathing/pulse becomes visibly stronger;
- restrained warm mineral seam response appears around viable plate/horn-root/core-linked areas;
- dust/mud/mineral shedding or ground vibration may reinforce the state;
- audio cadence changes;
- UI/bestiary may identify Berserk only to the level current player knowledge supports.

The Crystal core remains internal. Do not expose a glowing targetable core merely because Berserk began.

Presentation cannot shorten/skip the committed transition or apply gameplay state early.

---

# 6. Berserk activation drain

On each later normal activation while `berserk_active == true`, before action selection:

1. revalidate alive/Energy/state;
2. evaluate critical-exit rule in section 11;
3. if still Berserk, spend `5% of core_energy_max`;
4. add `+10 core_strain`;
5. increment `berserk_activation_count` once;
6. if Energy reaches `<= 0`, die immediately and do not continue the activation;
7. otherwise continue through normal Stamina/AP/action hooks.

The entry activation does not also pay this 5% activation drain. Its cost is the separate 10% entry payment.

No camera, save/load or animation event may duplicate the drain.

---

# 7. Per-attack Crystal surcharge

Normal attack Stamina costs remain unchanged unless another explicit owner modifies them.

While Berserk, committing one of the five existing Monster 01 attacks also requires a Crystal Energy surcharge and strain addition:

| Existing attack | Berserk AP | Existing Stamina | Extra Crystal Energy | Extra strain |
|---|---:|---:|---:|---:|
| `M01_HORN_CHARGE` | `3` | `30` | `5% max` | `+12` |
| `M01_HEAD_SWEEP_GORE` | `2` | `14` | `2% max` | `+5` |
| `M01_SHOULDER_RAM` | `2` | `22` | `4% max` | `+8` |
| `M01_FORELEG_STOMP` | `2` | `12` | `2% max` | `+4` |
| `M01_TAIL_SWEEP` | `2` | `18` | `3% max` | `+6` |

Rules:
- the surcharge is validated at authoritative attack commitment;
- if paying it would reduce core Energy to `<= 0`, that attack is illegal with `INSUFFICIENT_CORE_ENERGY_FOR_BERSERK_SURCHARGE`;
- Energy never becomes negative to finance an attack;
- no Crystal surcharge is paid for an attack that fails validation before commitment;
- no duplicate surcharge occurs because animation/VFX replayed;
- attack's normal Stamina affordability remains separately required.

The AP reductions are explicit Berserk action-rule modifiers. They do not alter the generic Action Economy contract.

---

# 8. No extra attacks / no extra turns

Berserk retains all of these laws:
- one normal Monster 01 activation maximum per round;
- maximum one damaging attack per normal activation;
- Initiative snapshot/order is not rerolled or recomputed;
- reactions/counters do not become extra normal activations;
- AP saved by Berserk attack discounts can support legal reposition/non-damaging setup only;
- AP saved may never purchase a second damaging attack;
- no Crystal Energy can be converted into AP, RP, Stamina or another turn.

This is mandatory anti-action-inflation behavior.

---

# 9. Anatomy and legality remain absolute

Berserk does not grant substitute anatomy.

Examples:
- lost full Horn Charge capability → Berserk Horn Charge remains illegal;
- both horns broken → Head Sweep/Gore remains the impact-only Head Sweep variant;
- severe forequarter support loss → Charge/Ram remain unavailable as defined by `COMBAT_ATTACK_PACKET.md`;
- selected severely damaged foreleg cannot Stomp;
- severed distal tail cannot Tail Sweep;
- narrow/blocked geometry can still invalidate Charge/Sweep;
- physical full cover can still block/intercept according to normal resolution.

Berserk never reconstructs horns, plates, legs or tail.

---

# 10. Berserk behavior priority

While active, behavior becomes more aggressive but remains deterministic and context-aware.

First-slice priority after legality filtering:

```text
IF rear/flank threat AND Tail Sweep legal → M01_TAIL_SWEEP
ELSE IF front-lane Charge legal → M01_HORN_CHARGE
ELSE IF close front/front-flank Ram legal → M01_SHOULDER_RAM
ELSE IF close head attack legal → M01_HEAD_SWEEP_GORE
ELSE IF side-specific Stomp legal → M01_FORELEG_STOMP
ELSE → aggressive legal reposition toward a usable existing attack
```

Berserk does not randomly select an attack and does not choose an illegal attack because it has higher aggression priority.

Ordinary Wounded Retreat is suppressed while Berserk remains active, except through the explicit critical-exit rule below.

---

# 11. Critical-exit rule

Before paying the 5% Berserk activation drain, evaluate:

`BERSERK_CRITICAL = (core_energy_ratio <= 0.12) OR (core_strain >= 80)`.

If not critical:
- remain Berserk.

If critical and a legal retreat route exists and the Raker is not in active nest-defense pressure:
- set `berserk_active = false`;
- transition to `EXHAUSTED_CRITICAL` behavior state;
- do not pay that activation's 5% Berserk drain;
- do not receive Berserk AP discounts/surcharges on that activation;
- `berserk_episode_used` remains true.

The exact retreat/escape action is owned by the existing/future retreat system, not this contract.

If critical but retreat is unavailable or nest-defense pressure remains active:
- Berserk continues;
- pay the normal 5% activation drain;
- the creature may burn itself toward death.

This makes Berserk a survival trade instead of a free permanent phase.

---

# 12. Core strain scale

First-slice Monster 01 uses a normalized trace scale:

`core_strain = clamp(core_strain, 0, 100)`.

Sources in this packet:
- entry `+20`;
- each active Berserk activation `+10`;
- attack surcharge from section 7.

Bands:
- `0–39` normal/low strain;
- `40–69` elevated;
- `70–79` high;
- `80–100` critical for Berserk exit evaluation.

Strain bands do not secretly modify damage, accuracy, Initiative or status immunity in the first slice.

They are authoritative state used for:
- Berserk exit logic;
- readable pulse/seam/breathing presentation;
- debug trace;
- later recovery/Crystal-condition/harvest integration.

This contract does not define post-hunt strain recovery.

---

# 13. Status interaction

Berserk does not create blanket status immunity.

Existing status laws remain:
- Bleeding continues its deterministic cadence;
- Staggered can still apply;
- Off-Balance can still apply;
- Staggered/Off-Balance may make specific attacks illegal through existing capability rules;
- Berserk does not clear Bleeding, Staggered or Off-Balance on entry;
- Berserk does not grant free Braced/Guarded states.

A future explicit species mutation could modify resistance through the shared effect system, but no such immunity is selected here.

---

# 14. Telegraph/reaction preservation

Berserk never removes the reaction window from the five selected normal attacks.

Existing reaction compatibility remains exactly owned by `COMBAT_ATTACK_PACKET.md`.

The AP discount means the monster can reposition more aggressively before a legal attack, not that the player loses warning/reaction rights.

No first-slice Berserk attack receives `PRECISION` hit quality or an independent critical roll.

---

# 15. Death boundary

At every Energy spend/drain boundary:

```text
APPLY AUTHORIZED CORE ENERGY COST
→ clamp/update authoritative Energy
→ IF core_energy_current <= 0
     → DIE immediately
     → clear berserk_active
     → prevent further action commitment/resolution
```

A creature at zero Energy cannot finish an attack merely because its animation already started.

Death presentation follows authoritative state; it does not decide death timing.

---

# 16. Persistence/save-load

Save/reload/encounter transition must preserve at least:
- current/max core Energy;
- core strain;
- Berserk active flag;
- episode-used flag;
- entry round;
- activation count;
- current anatomy/capability state;
- current behavior state.

Reload may not:
- replay the entry 10% cost;
- duplicate the 5% activation drain;
- duplicate an attack surcharge;
- clear episode-used;
- restore anatomy;
- reroll Initiative;
- grant a second activation.

If the creature escapes/reappears during the same hunt, the same Monster instance retains Berserk/core/anatomy state according to these rules.

---

# 17. Debug/authoritative trace

Minimum Berserk trace fields:
- monster instance ID;
- round/activation ID;
- current/max Energy + ratio;
- current strain;
- entry-gate facts;
- desperation-pressure facts;
- episode-used/active flags;
- transition/drain source;
- candidate attacks + anatomy/terrain/range legality;
- selected attack/AP/Stamina/Core surcharge;
- critical-exit evaluation;
- death check result;
- resulting behavior state.

Example:

```text
BERSERK_ENTRY: PASS
ENERGY_RATIO: 0.43
PRESSURE_RETREAT_DENIED: TRUE
ENTRY_COST: 10% MAX
STRAIN: 18 -> 38
STATE: BERSERK

NEXT_ACTIVATION_DRAIN: 5% MAX
M01_HORN_CHARGE: FAIL — HORN_CHARGE_CAPABILITY_DISABLED
M01_TAIL_SWEEP: PASS
TAIL_SWEEP_BERSERK_COST: 2 AP / 18 STAMINA / 3% CORE / +6 STRAIN
SELECTED: M01_TAIL_SWEEP
```

---

# 18. Future implementation verification

Minimum tests:
1. entry rejected above 60% Energy;
2. entry rejected at/below 20%;
3. entry accepted inside window with Retreat Denied;
4. entry accepted inside window with Nest Defense;
5. entry accepted with Severe Anatomy pressure;
6. one broken part alone does not satisfy Severe Anatomy;
7. second entry in same hunt rejected;
8. entry spends exactly 10% Max Energy once;
9. entry adds exactly 20 strain once;
10. entry consumes full activation and cannot attack same activation;
11. next Berserk activation spends exactly 5% Max once;
12. Berserk activation adds 10 strain once;
13. save/reload does not duplicate activation drain;
14. Charge uses 3 AP while Berserk;
15. Ram uses 2 AP while Berserk;
16. Tail Sweep uses 2 AP while Berserk;
17. Head Sweep/Stomp remain 2 AP;
18. Berserk still permits max one damaging attack/activation;
19. attack Core surcharge charged once;
20. attack rejected if surcharge would reduce Energy to zero/below;
21. Stamina affordability still required independently;
22. broken Horn Charge stays illegal;
23. severed Tail Sweep stays illegal;
24. damaged-side Stomp stays illegal;
25. Narrow/full-cover legality still applies;
26. Berserk does not clear Bleeding;
27. Berserk does not clear Staggered/Off-Balance;
28. attack reaction windows remain available per normal attack packet;
29. no independent Berserk crit/status roll;
30. core ratio <=12% + legal retreat + no nest pressure exits Berserk;
31. strain >=80 + legal retreat + no nest pressure exits Berserk;
32. critical + no retreat keeps Berserk active;
33. zero Energy causes immediate death before further action;
34. encounter transition preserves episode-used/core/anatomy state;
35. identical authoritative state produces identical entry/priority/drain trace.

No runtime verification is claimed until combat/Crystal/behavior source exists behind the prerequisite implementation gates.

---

# 19. Verification boundary

`MONSTER_01_BERSERK_PROTOTYPE_RECORDED = YES`
`MONSTER_01_BERSERK_RUNTIME_IMPLEMENTED = NO`
`MONSTER_01_BERSERK_RUNTIME_VERIFIED = NO`

This is first-slice design/content authority, not production balance proof.

---

# 20. Exact next dependency

After this packet, the next bounded combat-design dependency is:

`SOLO_PARTY_BASELINE_CONTRACT`

That pass must define only first-slice solo-vs-party participation/control/turn-ownership assumptions. It must not simultaneously define defeat/retreat resolution or production combat source.