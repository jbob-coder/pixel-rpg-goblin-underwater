# MONSTER_01 — Mudcrest Raker

Status: SELECTED FIRST-MONSTER PROTOTYPE DESIGN / ANATOMY-INTEGRITY RUNTIME BUILD VERIFIED / ATTACK + BERSERK + HARVEST PACKETS RECORDED / DISPLAY NAME PROVISIONAL
Last reconciled: 2026-09-04

## Identity

Technical package ID: `MONSTER_01`
Species ID: `species_r01_mudcrest_raker`
Working display name: **Mudcrest Raker**

The display name may change. Stable package/species IDs and current mechanical body design are the authority.

## Why this is the first Monster

Monster 01 must prove the complete first hunt relationship:
- Region 01 ecology/tracking/escape;
- deterministic authored behavior;
- horn/plate/leg/tail functional anatomy;
- anatomy-dependent attack loss/change;
- Crystal-life-force Berserk;
- persistent injury through escape/reacquisition;
- condition-based finite harvesting;
- readable aerial silhouette + first-person anatomy.

## Body plan

Prototype:
- ~6.6 m nose-to-tail;
- ~3.0 m shoulder/main-body height;
- front-loaded quadrupedal mass;
- paired mineralized horn/crest structures;
- dorsal/shoulder armor plates;
- four mud-adapted legs;
- muscular tail with severable distal section;
- deep forward-torso internal Crystal core, not normally targetable.

Player-facing groups:
Head / Horn Crest / Foreleg L / Foreleg R / Hindleg L / Hindleg R / Dorsal Plates / Tail + general torso contact.

Anatomy authority:
`ANATOMY_AND_DAMAGE.md`.

Production anatomy runtime owner:
`/game/scripts/gameplay/monsters/monster_01/`.

Current runtime status:
- per-target normalized integrity is implemented;
- committed Hunter attack handoffs are consumed without rerolling contact/hit quality;
- stable resolution IDs prevent duplicate integrity application;
- mismatch/collision rejection is implemented;
- the numeric integrity fixture is explicitly provisional;
- crack/break thresholds, sever/detachment, statuses and global health/death are not implemented yet.

Verified source head:
`a70b7680f3a7d552a08fc9080a04bc40617c916b`.
Production workflow `33853607287`: SUCCESS.

## Normal combat packet

Authority:
`COMBAT_ATTACK_PACKET.md`.

Attacks:
- Horn Charge;
- Head Sweep/Gore;
- Shoulder Ram;
- Foreleg Stomp;
- Tail Sweep.

Hard laws:
- one normal activation per round;
- internal 4-AP budget;
- max one damaging attack per activation;
- anatomy/range/bearing/terrain/cover remain authoritative;
- no hidden multiattack/status RNG;
- damaged anatomy disables or changes dependent attacks;
- reactable attacks open the shared reaction-window owner rather than creating Monster-specific reaction logic.

The normal Monster attack runtime is not implemented yet. The current combat scheduler still uses `WAIT_NO_ATTACK_RUNTIME` for the Monster activation until reaction-window infrastructure and the first attack slice are integrated.

## Berserk

Authority:
`BERSERK_PROTOTYPE_CONTRACT.md`.

Berserk:
- is deterministic desperation, not a random rage roll;
- spends Crystal life force/strain;
- may reduce AP costs of existing legal attacks;
- never grants another normal turn or second damaging attack;
- never restores broken horns, damaged legs or severed tail;
- never removes reaction windows;
- can burn the Monster toward zero-Energy death.

## Deterministic behavior and Region use

Authority:
`BEHAVIOR_AND_REGION.md`.

Behavior selects only currently legal actions/routes from authored deterministic rules.

Monster escape preserves this exact persistent instance for reacquisition.

## Harvest packet

Authority:
`HARVEST_CAPACITY_PACKET.md`.

Generic owner:
`/docs/20_gameplay/harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`.

First-slice selected materials/capacities:
- left horn: 4 `material_m01_horn` units;
- right horn: 4;
- dorsal plate group: 8 `material_m01_dorsal_plate` units;
- torso hide: 12 `material_m01_hide` units;
- distal-tail ridge: 5 `material_m01_tail_ridge` units;
- distal-tail tendon: 4 `material_m01_tail_tendon` units;
- dense structural bone: 8 `material_m01_dense_bone` units.

Pristine authored selected-source total:
`45` prototype harvest-capacity units.

This is not guaranteed yield.

Final combat condition determines surviving capacity. Extraction efficiency then determines how much of that surviving capacity the Hunter actually recovers.

Important physical rules:
- a shattered horn yields less/bad material than an intact or cleaner break;
- broken plate can still yield fragments but at reduced capacity/quality;
- a clean distal-tail sever can preserve more ridge/tendon value;
- sever transfers the same tail-source lineage to a detached-tail container;
- later Monster death cannot recreate those tail sources on the carcass;
- save/load/reacquisition cannot restore consumed or destroyed harvest capacity.

This is the direct implementation of the core player-facing rule:
**what you damage determines what you can harvest and how much remains.**

## Crystal/mutation

Authority:
`CRYSTAL_AND_MUTATION.md`.

Provisional expression: Mineral/Earth-type biological adaptation.

Core Energy is life force. Zero usable Energy means death. The core remains internal and is not automatically a harvest target in this first packet.

## Region 01 relationship

Primary sectors:
S01 River Ford / S02 Rootwood Thicket / S03 Feeding Meadow / S04 Rocky Rise / S05 Deepwood Basin / S06 Nesting Shelf-Crystal Fault.

Combat/escape/harvest consequences remain connected to the same physical Monster instance and Region state.

## Package file map

- `README.md` — local front door;
- `ANATOMY_AND_DAMAGE.md` — target groups/break/sever/impairment design authority;
- `COMBAT_ATTACK_PACKET.md` — normal attacks;
- `BERSERK_PROTOTYPE_CONTRACT.md` — Crystal desperation state;
- `BEHAVIOR_AND_REGION.md` — deterministic activity/combat/retreat route selection;
- `CRYSTAL_AND_MUTATION.md` — Crystal/mutation context;
- `HARVEST_CAPACITY_PACKET.md` — first-slice concrete harvest materials/capacities/condition application;
- `/game/scripts/gameplay/monsters/monster_01/` — current production species runtime owner.

## Current decision state

RECORDED:
- anatomy/body plan;
- Region relationship;
- deterministic behavior;
- normal attacks;
- Berserk;
- defeat/escape continuity;
- first-slice finite harvest packet.

IMPLEMENTED + BUILD VERIFIED:
- first species-owned normalized anatomy-integrity runtime slice.

OPEN/LATER:
- final display name/mass/absolute health/Stamina/Core capacity;
- structural crack/break thresholds;
- sever/detachment runtime;
- status consequences;
- Monster reaction/attack/behavior runtime;
- broader materials/organs/meat;
- final art/audio;
- inventory/crafting linkage;
- remaining runtime implementation/tests.

`MONSTER_01_ANATOMY_INTEGRITY_RUNTIME_IMPLEMENTED = YES`
`MONSTER_01_ANATOMY_INTEGRITY_ANDROID_BUILD_VERIFIED = YES`
`MONSTER_01_ATTACK_PACKET_RECORDED = YES`
`MONSTER_01_BERSERK_PROTOTYPE_RECORDED = YES`
`MONSTER_01_HARVEST_PACKET_RECORDED = YES`
`MONSTER_01_NORMAL_ATTACK_RUNTIME_IMPLEMENTED = NO`
`MONSTER_01_BEHAVIOR_RUNTIME_IMPLEMENTED = NO`
`MONSTER_01_HARVEST_RUNTIME_IMPLEMENTED = NO`.

## Exact next runtime dependency

Before the recorded normal attack packet can replace the combat scheduler's Monster wait placeholder, generic combat needs:
`FIRST_SLICE_HUNTER_REACTION_WINDOW_RUNTIME_IMPLEMENTATION`.

That owner must provide stable reaction-window identity and legal out-of-turn Hunter RP/Stamina commitment. It must not be implemented inside this species package.
