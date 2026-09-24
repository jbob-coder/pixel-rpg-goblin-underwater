# Monster 01 Combat Attack Packet Pass — 2026-09-03

Status: BOUNDED CONTENT/DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## Bounded piece

`MONSTER_01_COMBAT_ATTACK_PACKET_CONTRACT`

This pass advances the game itself while the direct Galaxy A03s Stage-1 phone gate remains deferred. Documentation is used only to preserve ownership, testability, current truth and exact continuation.

## Authorities reread

Before authoring the packet this pass reread current repository copies of:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `docs/70_handoff/FIRST_SLICE_TERRAIN_EFFECT_SET_PASS_2026-09-03.md`;
- `docs/20_gameplay/combat/README.md`;
- `ACTION_ECONOMY_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`;
- `FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`;
- `docs/30_content/monsters/MONSTER_01/README.md`;
- `ANATOMY_AND_DAMAGE.md`;
- `BEHAVIOR_AND_REGION.md`;
- Region 01 encounter-footprint authority.

The pass intentionally did not define berserk, party composition, defeat/retreat resolution, final damage/health scales, animation timing or production code.

## New authority

`docs/30_content/monsters/MONSTER_01/COMBAT_ATTACK_PACKET.md`.

This file lives in the Monster 01 content package because the five attacks are species-specific configuration of generic combat rules. It is not an eighth generic combat-system contract.

## Selected normal attack set

Exactly five damaging attacks:
1. `M01_HORN_CHARGE`;
2. `M01_HEAD_SWEEP_GORE`;
3. `M01_SHOULDER_RAM`;
4. `M01_FORELEG_STOMP`;
5. `M01_TAIL_SWEEP`.

Not selected:
- separate bite filler;
- projectiles/magic;
- burrow attack;
- damaging roar;
- berserk-only variants;
- multi-hit combo trees.

## Monster activation/economy mapping

Selected first-slice model:
- one normal activation per round;
- hidden/internal 4-AP activation budget using the existing Action Economy model;
- maximum one damaging Monster 01 attack per normal activation;
- remaining AP may only support separately legal non-damaging movement/reposition/warning/recovery;
- movement embedded in Charge/Ram is part of that action, not a hidden extra action;
- no attack creates extra turns.

Attack exertion uses the existing normalized Stamina scale for authoring:
- Horn Charge `4 AP / 30 Stamina`;
- Head Sweep/Gore `2 AP / 14`;
- Shoulder Ram `3 AP / 22`;
- Foreleg Stomp `2 AP / 12`;
- Tail Sweep `3 AP / 18`.

The final species Max Stamina is not frozen by this pass.

Normal attacks do not spend Crystal Energy by default. Berserk Energy/strain belongs to the next pass.

## Anatomy-driven capability changes

Selected:
- full Horn Charge requires intact full horn capability + supporting forelegs + clear charge lane;
- broken horn state disables full Horn Charge rather than allowing the animation to ignore anatomy;
- Head Sweep/Gore becomes an impact-only head sweep when both horns are broken;
- severe forequarter support loss removes full Charge/Ram capability;
- each foreleg Stomp is side-specific to a functional foreleg;
- distal tail sever immediately and persistently disables Tail Sweep;
- no invisible severed-tail hitbox.

## Reaction/guard relationships

### Horn Charge
Legal: Dodge, Reactive Brace, explicit emergency movement/cover where separately supported.
Normal Field Poleblade Block/Parry: incompatible.

### Head Sweep/Gore
Legal: Dodge, compatible Block, compatible Parry only for a plausible horn/linear trajectory, Reactive Brace.
Block impact drain: `10 Stamina` after the normal Block commitment cost.

### Shoulder Ram
Legal: Dodge, Reactive Brace.
Parry: incompatible.
Standard Block: incompatible unless `Braced + Guarded` and bearing/physical interposition make the special force-management Block legal.
Conditional Block impact drain: `18`.

### Foreleg Stomp
Legal: Dodge, Reactive Brace.
Normal Block/Parry: incompatible for the direct downward/body-mass strike.

### Tail Sweep
Legal: Dodge, compatible Guarded Block, compatible Field Poleblade Parry, Reactive Brace.
Block impact drain: `14`.

Physical incompatibility outranks Stamina availability.

## Status consequence requests

No independent random status-proc roll exists.

After normal contact/protection/anatomy resolution:
- Horn Charge can request Bleeding on a real horn wound and Staggered on CLEAN disruptive contact;
- Head Sweep/Gore can request Bleeding with surviving-horn wound or Off-Balance on CLEAN impact-dominant contact;
- Shoulder Ram can request Off-Balance on SOLID and Staggered on CLEAN/BLOCK_BROKEN;
- Foreleg Stomp can request Off-Balance on SOLID and Staggered on CLEAN;
- Tail Sweep can request Off-Balance on SOLID and Staggered on CLEAN.

Generic status ownership still controls application/stacking/timing/removal.

## Terrain/cover mapping

The packet consumes, but does not redefine, the existing terrain contract.

- Meadow Edge is the clearest full Horn Charge proving ground.
- Riverbank Ford supports all close attacks and only lane-validated Charge/Sweep.
- Root/Boulder Hollow often invalidates Charge/Sweep through `NARROW` or physical roots/boulders.
- Deep Nest Shelf uses actual stone/elevation/clearance; High Ground gives no generic damage bonus.
- Brush is visibility context, not physical armor/cover.
- solid obstacles can block/intercept; attacks never phase through them.
- Mud/Water never add a random slip/status roll.

## Behavior-system boundary

`COMBAT_ATTACK_PACKET.md` owns attack legality/profiles.
`BEHAVIOR_AND_REGION.md` owns deterministic selection/priority from the currently legal set.

The behavior system may not select a disabled attack.

Example trace:
`M01_HORN_CHARGE: FAIL — HORN_CHARGE_CAPABILITY_DISABLED`
`M01_TAIL_SWEEP: FAIL — TAIL_DISTAL_SEVERED`
`M01_FORELEG_STOMP: PASS`
`SELECTED_BY_BEHAVIOR: M01_FORELEG_STOMP`.

No runtime generative AI is introduced.

## Cooldown/repetition decision

No arbitrary cooldown is selected yet.

Repetition is bounded first by:
- one damaging attack per activation;
- AP;
- persistent Stamina;
- position/bearing;
- terrain/clearance;
- anatomy capability;
- deterministic behavior rules.

If later playtesting proves repetition degenerate, cooldown/recovery becomes a separate explicit tested rule rather than an animation delay.

## Future implementation verification

The packet records 35 minimum tests covering:
- action count/economy;
- anatomy disabling/variant behavior;
- charge/clearance/cover legality;
- reaction compatibility;
- impact drain once-only behavior;
- status request boundaries;
- no separate status RNG;
- deterministic replay;
- behavior rejection of illegal attacks;
- telegraph/presentation non-authority;
- save/reload anti-duplication.

No runtime verification is claimed because combat source does not yet exist.

## Documentation/navigation reconciliation required in this pass

Map/update:
- `docs/30_content/monsters/MONSTER_01/COMBAT_ATTACK_PACKET.md`;
- Monster 01 `README.md`;
- Monster 01 `BEHAVIOR_AND_REGION.md` reference boundary;
- `docs/30_content/README.md`;
- `docs/20_gameplay/combat/README.md`;
- `docs/20_gameplay/README.md`;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`;
- root `README.md`;
- `DOCUMENTATION_INDEX.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `EVOLVE_ALIGNMENT.md`;
- this handoff.

## Verification boundary

`MONSTER_01_ATTACK_PACKET_RECORDED = YES`
`MONSTER_01_ATTACK_RUNTIME_IMPLEMENTED = NO`
`MONSTER_01_ATTACK_RUNTIME_VERIFIED = NO`

Stage-1 phone truth remains unchanged:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next active non-phone action

`MONSTER_01_BERSERK_PROTOTYPE_CONTRACT`

The next pass must stay bounded to entry conditions, Crystal Energy/strain drain, visible tells, deterministic priority/commitment changes to existing anatomy-legal attacks, stop/critical/death behavior and future tests.

It may not restore destroyed anatomy, create unrelated magic attacks, design party systems or define defeat/retreat resolution.