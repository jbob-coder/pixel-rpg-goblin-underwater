# MONSTER_01 — First-Slice Combat Attack Packet

Status: SELECTED FIRST-SLICE CONTENT CONTRACT / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/30_content/monsters/MONSTER_01/`
Species: `species_r01_mudcrest_raker`
Working display name: Mudcrest Raker

## Purpose

Define the smallest normal-combat attack packet required for Monster 01 to exercise the existing action-economy, contact/defense, Stamina, Initiative, status, terrain, anatomy and deterministic-behavior contracts without inventing a second combat system or bundling berserk into the same pass.

Primary rule:

**Monster 01 attacks are anatomy-gated, position-gated, terrain/cover-aware and deterministically resolved. Lost anatomy removes or changes the attack that depended on it.**

This file owns Monster 01's normal first-slice attack definitions.

It does not own:
- generic AP/RP/Stamina laws;
- generic hit-quality/defense resolution;
- generic status stacking/timing;
- generic terrain formulas;
- Region 01 geography;
- Monster 01 berserk behavior;
- party rules;
- defeat/retreat rules;
- final health/damage numbers;
- animation duration;
- production implementation.

Supporting authorities:
- `README.md`;
- `ANATOMY_AND_DAMAGE.md`;
- `BEHAVIOR_AND_REGION.md`;
- `/docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`;
- `/docs/20_gameplay/combat/COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `/docs/20_gameplay/combat/STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `/docs/20_gameplay/combat/INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `/docs/20_gameplay/combat/FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`;
- `/docs/20_gameplay/combat/FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`;
- `/docs/10_world/regions/REGION_01/ENCOUNTER_FOOTPRINTS.md`.

---

# 1. First-slice packet

Exactly five normal damaging attacks are selected:

1. `M01_HORN_CHARGE`;
2. `M01_HEAD_SWEEP_GORE`;
3. `M01_SHOULDER_RAM`;
4. `M01_FORELEG_STOMP`;
5. `M01_TAIL_SWEEP`.

Not selected in this packet:
- bite as a separate attack;
- projectile/magic attack;
- burrow attack;
- generic roar damage;
- berserk-only variants;
- multi-hit combo trees;
- unavoidable cinematic attacks.

The five attacks cover front-lane charge, close frontal pressure, body-force pressure, local forequarter control and rear/flank defense.

---

# 2. Monster 01 action-economy mapping

Monster 01 uses the existing combat activation framework.

Selected first-slice authoring model:
- one normal Monster 01 activation per round;
- internal normal activation budget `4 AP`;
- the monster does not need a player-facing AP UI;
- maximum normal damaging attacks per Monster 01 activation: `1`;
- unused AP after a damaging attack may only support separately legal non-damaging movement/reposition/warning/recovery behavior;
- a movement+attack sequence must fit the same 4-AP activation or be authored as one explicit attack action;
- no attack animation creates a hidden second action;
- no high Initiative value grants a second normal activation.

The one-damaging-attack cap is first-slice protection against unreadable multiattack spam while still allowing movement + attack tactical combinations.

## Reference exertion scale

Attack Stamina values below use the existing normalized 100-point reference scale for first-slice balance testing.

This does **not** lock the final species Max Stamina at 100. Final derived species capacity remains a later balance/content decision.

Monster Stamina:
- persists across activations;
- cannot become negative;
- uses the same affordability/commitment/trace principles as other actors;
- is not Crystal Energy;
- may not be converted into extra AP or turns.

Crystal Energy is not spent by these normal attacks unless a later explicit owner says otherwise. Berserk Energy consumption belongs to the next bounded packet.

---

# 3. Shared Monster 01 attack laws

All five attacks:
- require one authoritative action ID and sequence ID;
- validate anatomy/capability before commitment;
- validate range/bearing/clearance before commitment;
- freeze context before resolution;
- use Combat Resolution's single bounded seeded-variance boundary;
- do not roll a separate critical-hit chance;
- do not roll a separate random status-proc chance;
- have first-slice hit-quality ceiling `CLEAN`;
- open an authoritative reaction window before resolution;
- emit one complete attack/defense/status trace;
- cannot reroll because UI, camera or animation replayed;
- cannot resolve through invalid full cover or impossible geometry;
- cannot use destroyed anatomy simply because an animation exists.

No first-slice Monster 01 normal attack has `PRECISION` hit quality.

---

# 4. Anatomy capability flags

Implementation-facing capability concepts:

`CAP_M01_HORN_CHARGE_FULL`
- both horn structures intact enough for full charge use;
- both forelegs support full charge planting/propulsion;
- actor is not Staggered/Off-Balance at commit;
- valid charge lane exists.

`CAP_M01_HEAD_ATTACK`
- head/neck functional enough to sweep/gore.

`CAP_M01_FOREQUARTER_RAM`
- shoulder/forequarter present;
- both forelegs are not in a severe/broken support state;
- required local clearance exists.

`CAP_M01_STOMP_L` / `CAP_M01_STOMP_R`
- selected foreleg remains functional enough to plant/strike.

`CAP_M01_TAIL_SWEEP`
- `TAIL_DISTAL` remains attached;
- hindquarter pivot remains physically legal;
- sweep arc has enough clearance.

Capability values are derived from anatomy/runtime state. They are not independent buffs that can ignore anatomy.

---

# 5. Attack summary

| Attack | AP | Stamina | Core role | Main channel | Standard Block impact drain |
|---|---:|---:|---|---|---:|
| `M01_HORN_CHARGE` | 4 | 30 | long frontal commitment | Piercing + Impact | normal Poleblade Block incompatible |
| `M01_HEAD_SWEEP_GORE` | 2 | 14 | close front/front-flank pressure | Piercing + Impact, or Impact if hornless | 10 |
| `M01_SHOULDER_RAM` | 3 | 22 | close body-force displacement | Impact | 18 when special Braced+Guarded Block is legal |
| `M01_FORELEG_STOMP` | 2 | 12 | local forequarter control | Impact | direct normal Block incompatible |
| `M01_TAIL_SWEEP` | 3 | 18 | rear/flank arc defense | Impact | 14 |

Impact drain is separate from the Poleblade's normal Block commitment cost `6 Stamina`.

A physically incompatible Block remains illegal regardless of available Stamina.

---

# 6. `M01_HORN_CHARGE`

## Role

Highest normal frontal commitment. It teaches the player to respect the horn/forequarter lane, use lateral movement/cover and damage the anatomy that enables the attack.

## Requirements

Requires:
- `CAP_M01_HORN_CHARGE_FULL`;
- target in authored `CHARGE_RANGE`;
- target generally in `FRONT_LANE` bearing;
- a continuous legal body-clearance lane;
- no solid cover/obstacle blocking the required path at validation;
- terrain/geometry able to support the body's charge path.

`NARROW` can make the action illegal when the Raker's body cannot physically clear the lane.

Mud and Shallow Water do not automatically make the action illegal; Monster 01 is physically adapted to wet basin terrain. Exact species locomotion-cost mitigation remains separate balance data.

## Commitment

- `4 AP`;
- `30 Stamina`;
- consumes the full normal activation opportunity;
- embedded charge movement + contact count as one authored attack, not movement plus a hidden second attack.

## Telegraph

Authoritative telegraph communicates:
- head drops and horns align;
- forequarters plant/scrape;
- shoulders square to the lane;
- threatened frontal lane/direction;
- full-charge intent if player knowledge/perception supports that detail.

Animation/audio visualize this event but do not create reaction legality.

## Legal reactions

First slice:
- `Dodge` — legal when a valid destination exists;
- `Reactive Brace` — legal, primarily reducing displacement/stagger consequence; it does not make the body/horns miss by itself;
- emergency movement-to-cover — only when an explicit legal reaction/action exists;
- normal Field Poleblade `Block` — **incompatible**;
- normal Field Poleblade `Parry` — **incompatible**.

A massive full-body horn charge is not safely blockable merely because the hunter has enough Stamina.

## Contact / consequences

Damage channels:
- primary `PIERCING` through horn contact;
- major `IMPACT` through forequarter/body momentum.

First-slice deterministic status requests after protection/anatomy resolution:
- `SOLID` horn/tissue penetration may request `status_bleeding +1`;
- `CLEAN` contact may request `status_staggered` when Brace/other defense did not prevent the disruption consequence;
- no independent status roll.

Exact health damage remains open.

## Cover / obstacle interaction

Solid boulder/root/trunk/bank geometry can:
- make the charge lane illegal before commitment;
- intercept the charge if a legal reaction changes the line after commitment.

First slice does not require destructible environment simulation. If solid cover intercepts and no destruction rule exists, the attack terminates against the cover rather than phasing through it.

## Anatomy degradation

If either horn becomes broken enough to invalidate full charge capability, `M01_HORN_CHARGE` becomes illegal.

If a foreleg reaches the severe support-loss state, full charge becomes illegal.

There is no hidden horn-charge animation fallback that ignores the capability failure.

---

# 7. `M01_HEAD_SWEEP_GORE`

## Role

Reliable close frontal/front-flank attack and the primary head attack after the player closes distance.

## Requirements

Requires:
- `CAP_M01_HEAD_ATTACK`;
- close/front or close/front-flank target relation;
- legal head/neck sweep arc;
- no full solid cover preventing contact.

## Commitment

- `2 AP`;
- `14 Stamina`;
- counts as the activation's one damaging attack.

## Horn-state variant

If at least one usable horn remains:
- profile is `GORE_SWEEP`;
- channels `PIERCING + IMPACT`.

If both horns are broken:
- same action ID resolves as `HEAD_SWEEP`;
- channel becomes primarily `IMPACT`;
- horn-dependent Bleeding request is unavailable;
- the monster does not magically regain horn reach.

This avoids proliferating a second nearly identical action ID while preserving anatomy truth.

## Telegraph

- head/neck cocks toward sweep side;
- surviving horn orientation is readable;
- weight shifts into the forequarter;
- sweep direction is an authoritative telegraph field.

## Legal reactions

- Dodge — legal with valid space;
- Block — legal if Guarded, correct bearing and physical interposition is plausible;
- Parry — legal only for a compatible horn/linear edge trajectory, not a broad skull/body sweep;
- Reactive Brace — legal.

Standard successful Block impact drain:
`10 Stamina` after the normal `6` Block commitment cost.

## Status requests

- `SOLID/CLEAN` horn penetration may request `status_bleeding +1` after protection/anatomy says a wound exists;
- `CLEAN` impact-dominant sweep may request `status_off_balance`;
- no random proc.

---

# 8. `M01_SHOULDER_RAM`

## Role

Horn-independent close body-force attack. It ensures breaking horns reduces the monster without making it harmless.

## Requirements

Requires:
- `CAP_M01_FOREQUARTER_RAM`;
- close front/front-flank relation;
- body clearance for a short committed lunge;
- no full cover occupying the body path.

## Commitment

- `3 AP`;
- `22 Stamina`;
- short embedded lunge/contact is part of this action;
- counts as the activation's one damaging attack.

## Telegraph

- shoulder turns into the threat line;
- head pulls away from the impact side;
- forelegs compress/plant;
- short body-lunge direction becomes authoritative.

## Legal reactions

- Dodge — legal when space exists;
- Reactive Brace — legal;
- normal Parry — incompatible;
- standard Poleblade Block without Brace — incompatible;
- `Braced + Guarded` correct-bearing Block — conditionally legal as an exceptional force-management attempt, not a guaranteed stop.

When that special Block is legal, impact drain:
`18 Stamina` after normal Block commitment cost.

Combat Resolution may still produce `BLOCK_BROKEN` when force/stability is insufficient.

## Status requests

- `SOLID` body contact may request `status_off_balance`;
- `CLEAN` impact or `BLOCK_BROKEN` may request `status_staggered` when the status owner validates it;
- no Bleeding request by default from pure shoulder impact.

---

# 9. `M01_FORELEG_STOMP`

## Role

Close local control attack that punishes remaining directly beside the forequarter without requiring horn capability.

## Requirements

Requires:
- one valid `CAP_M01_STOMP_L` or `CAP_M01_STOMP_R` corresponding to the striking side;
- target in the close local foreleg threat zone;
- foot-plant/impact node physically reachable;
- sufficient overhead/side clearance for the strike animation proxy, but animation never expands legal range.

A severely damaged selected foreleg cannot perform the stomp. The opposite foreleg may remain usable when geometry/bearing supports it.

## Commitment

- `2 AP`;
- `12 Stamina`;
- no free extra shove/attack follows automatically.

## Telegraph

- weight transfers to opposite foreleg/hindquarters;
- striking foreleg visibly unloads and lifts;
- threatened local node/side is authoritative.

## Legal reactions

- Dodge — legal with valid destination;
- Reactive Brace — legal to resist displacement/stagger consequence;
- normal Poleblade Block — incompatible against the direct downward/body-mass stomp;
- Parry — incompatible.

## Damage / status requests

Damage channel:
`IMPACT`.

- `SOLID` contact may request `status_off_balance`;
- `CLEAN` contact may request `status_staggered`;
- mud/water terrain does not independently add another status roll.

This action is not a magical ground shockwave. It affects the authored local impact/contact area only.

---

# 10. `M01_TAIL_SWEEP`

## Role

Rear/flank defensive arc that makes tail positioning meaningful and creates a direct payoff for distal tail severing.

## Requirements

Requires:
- `CAP_M01_TAIL_SWEEP`;
- target in rear/flank sweep relation;
- valid hindquarter pivot;
- enough sweep-arc clearance.

`NARROW`, large roots, boulders or other solid geometry may make the sweep illegal or partially intercept the arc when physically appropriate.

## Commitment

- `3 AP`;
- `18 Stamina`;
- counts as the activation's one damaging attack.

## Telegraph

- hindquarters plant;
- torso begins visible counter-rotation;
- tail coils/loads opposite the sweep direction;
- sweep side/arc is authoritative.

## Legal reactions

- Dodge — legal with valid destination;
- Block — legal when Guarded and coverage/bearing match;
- Field Poleblade Parry — conditionally legal where tail trajectory, leverage and weapon angle are compatible;
- Reactive Brace — legal.

Standard Block impact drain:
`14 Stamina` after normal Block commitment cost.

## Damage / status requests

Damage channel:
`IMPACT`, strengthened by the mineralized distal ridge.

- `SOLID` contact may request `status_off_balance`;
- `CLEAN` contact may request `status_staggered`;
- no generic Bleeding request.

## Tail sever

If `TAIL_DISTAL` is severed:
- `CAP_M01_TAIL_SWEEP = false`;
- `M01_TAIL_SWEEP` becomes illegal immediately and persistently;
- no invisible tail hitbox remains;
- a future weak stump/body-turn action requires a separate explicit definition and is not selected here.

---

# 11. Terrain and footprint compatibility

The packet uses the current Region 01 terrain contract rather than inventing creature-specific arena rules.

## Riverbank Ford

Supported:
- Head Sweep/Gore;
- Shoulder Ram where body path is clear;
- Foreleg Stomp;
- Tail Sweep where bank/log/rock clearance allows;
- Horn Charge only on a validated charge lane.

Mud/Shallow Water do not create random slips/statuses.

## Meadow Edge

All five attacks can potentially be supported because the footprint has open movement/charge space, subject to real tree/rock cover.

This is the cleanest first-slice Horn Charge proving ground.

## Root/Boulder Hollow

`NARROW` and physical roots/boulders should frequently restrict Horn Charge and Tail Sweep arcs.

Close attacks remain viable where the monster physically fits.

## Deep Nest Shelf

Stone/high-ground geometry can change line of effect and clearance but grants no generic damage bonus.

The berserk-specific use of this footprint remains outside this packet.

---

# 12. Cover law

Monster attacks use Combat Resolution cover rules.

- Brush alone is not physical cover.
- Full solid cover can make a direct attack illegal.
- Partial solid cover protects/intercepts only the geometry actually covered.
- a charge/ram/tail arc does not ignore a boulder because the attack is large;
- a stomp cannot hit a target on another node through a wall/root simply because the animation overlaps visually.

Environment destruction remains OPEN and cannot be assumed to bypass cover.

---

# 13. Status law

All status consequences are **requests after authoritative contact/protection/anatomy resolution**.

This packet never directly ticks or stacks a status in presentation.

Selected first-slice mapping:

| Attack | Bleeding | Off-Balance | Staggered |
|---|---|---|---|
| Horn Charge | possible on penetrating SOLID/CLEAN horn wound | not default | possible on CLEAN disruptive contact |
| Head Sweep/Gore | possible with surviving-horn wound | possible on CLEAN impact-dominant sweep | not default |
| Shoulder Ram | none by default | possible on SOLID | possible on CLEAN/BLOCK_BROKEN |
| Foreleg Stomp | none | possible on SOLID | possible on CLEAN |
| Tail Sweep | none | possible on SOLID | possible on CLEAN |

No independent random status chance exists.

Bleeding still caps/stacks/ticks according to the generic status contract.

Staggered still transitions to Off-Balance according to the generic status contract rather than this packet inventing a custom duration.

---

# 14. Behavior-system boundary

This packet exposes legal attack candidates and failure reasons.

`BEHAVIOR_AND_REGION.md` remains the owner of deterministic action selection/priorities based on current state.

Typical trace examples:

```text
M01_HORN_CHARGE: FAIL — HORN_CHARGE_CAPABILITY_DISABLED
M01_TAIL_SWEEP: FAIL — TAIL_DISTAL_SEVERED
M01_SHOULDER_RAM: FAIL — NARROW_CLEARANCE
M01_FORELEG_STOMP: PASS — RIGHT_FORELEG_FUNCTIONAL + TARGET_CLOSE_RIGHT
SELECTED_BY_BEHAVIOR: M01_FORELEG_STOMP
```

The behavior layer may select only attacks this packet says are currently legal.

No runtime generative AI selects attacks.

---

# 15. Repetition/cooldown boundary

No arbitrary numeric cooldown is selected yet.

First-slice repetition pressure already comes from:
- one damaging attack maximum per activation;
- AP commitment;
- persistent Stamina;
- range/bearing;
- terrain/clearance;
- anatomy state;
- deterministic behavior rules.

If playtesting shows a valid attack repeats degenerately despite those constraints, a later bounded balance extension may add an explicit cooldown/recovery state with tests.

Do not hide cooldowns in animation length.

---

# 16. Save/reload requirements

Persistence must preserve enough authoritative state that reload cannot:
- restore broken horns/tail/legs;
- regain a disabled attack capability;
- refund a committed attack twice;
- reroll a committed/resolved attack;
- duplicate a status request;
- repeat a guard-impact drain;
- create another normal activation;
- forget Monster Stamina if that resource is active in the implementation slice.

Attack sequence/commit/resolution IDs must be traceable.

---

# 17. Future implementation-test packet

At minimum test:

## Packet/economy
1. exactly five normal damaging attack IDs exist;
2. maximum one damaging attack per normal Monster 01 activation;
3. all attacks fit/validate against the 4-AP internal activation budget;
4. Stamina affordability rejects before commitment;
5. attacks do not consume Crystal Energy by default;
6. no attack creates an extra normal activation.

## Anatomy
7. broken horn disables full Horn Charge;
8. both broken horns switch Head Sweep/Gore to impact-only head sweep profile;
9. severe foreleg support loss disables full charge/ram as defined;
10. selected damaged foreleg disables that side's Stomp;
11. distal tail sever disables Tail Sweep;
12. save/reload preserves disabled capabilities.

## Geometry/terrain
13. Horn Charge requires clear front lane;
14. Narrow can reject Charge/Ram/Sweep where clearance fails;
15. solid cover prevents/intercepts correctly;
16. Brush alone does not block physical contact;
17. High Ground adds no generic attack bonus;
18. Mud/Water add no random status/slip consequence.

## Reactions/guard
19. Horn Charge rejects normal Poleblade Block/Parry;
20. Head Sweep/Gore supports only physically compatible Parry;
21. Shoulder Ram standard Block requires Braced+Guarded special condition;
22. Stomp rejects normal Block/Parry;
23. Tail Sweep supports compatible Block/Parry;
24. impact drain is charged exactly once after Block commitment;
25. insufficient guard stability can still produce BLOCK_BROKEN.

## Status/resolution
26. no separate random status-proc roll;
27. Horn bleeding request requires actual wound consequence;
28. status requests follow hit-quality/content conditions exactly;
29. generic status owner performs stacking/timing;
30. no presentation callback duplicates status application;
31. same seed/context/action sequence reproduces same contact result.

## Behavior/presentation
32. behavior cannot select an illegal disabled attack;
33. telegraph exists before every selected normal attack's reaction window;
34. animation cannot enlarge range/bearing/clearance;
35. UI/camera cannot reroll, resolve or re-enable attacks.

No runtime test is claimed until combat source exists.

---

# 18. Current verification boundary

`MONSTER_01_ATTACK_PACKET_RECORDED = YES`
`MONSTER_01_ATTACK_RUNTIME_IMPLEMENTED = NO`
`MONSTER_01_ATTACK_RUNTIME_VERIFIED = NO`

This packet is a content/design authority, not production combat code.

---

# 19. Exact next dependency

`MONSTER_01_BERSERK_PROTOTYPE_CONTRACT`

The next bounded pass may define only:
- entry conditions;
- Crystal Energy/strain drain;
- visible tell;
- bounded changes to availability/commitment of existing anatomy-legal attacks;
- deterministic behavior priority changes;
- stop/critical/death behavior;
- future implementation tests.

It must not restore lost anatomy, invent unrelated magic attacks, design party systems or define defeat/retreat resolution.