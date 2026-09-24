# First-Slice Terrain Effect Set Pass — 2026-09-03

Status: BOUNDED DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT`

This pass advances the game-design lane while direct Galaxy A03s Stage-1 evidence remains deferred. The game remains the objective; documentation exists to preserve ownership, design decisions, verification boundaries and exact continuation.

## Authorities reread

Before selecting terrain values this pass reread current repository copies of:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `docs/70_handoff/FIRST_SLICE_STATUS_SET_PASS_2026-09-03.md`;
- `docs/20_gameplay/combat/README.md`;
- the six existing combat contracts;
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md` terrain/effect ownership;
- `docs/10_world/regions/REGION_01/README.md`;
- `docs/10_world/regions/REGION_01/TERRAIN_ECOLOGY_MUTATION.md`;
- `docs/10_world/regions/REGION_01/ENCOUNTER_FOOTPRINTS.md`;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`.

The pass did not author Monster 01 attacks, berserk, party rules, defeat/retreat behavior or production source.

## New authority

`docs/20_gameplay/combat/FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`.

## Selected minimal terrain packet

Primary combat surfaces:
1. `STABLE_GROUND`;
2. `ROUGH_GROUND`;
3. `SHALLOW_WATER`;
4. `MUD`.

Context tags:
5. `BRUSH`;
6. `HIGH_GROUND`;
7. `NARROW`.

This is enough to support the current Region 01 Riverbank Ford, Meadow Edge, Root/Boulder Hollow and Deep Nest Shelf footprints without building a broad biome system.

## Concrete prototype surcharges

Existing owners remain authoritative for base action costs:
- adjacent move `1 AP / 0 Stamina` on Stable Ground;
- Sprint base `8 Stamina`;
- Dodge base `14 Stamina`.

Terrain adds:

| Surface | Move | Sprint | Dodge | Footing |
|---|---:|---:|---:|---|
| Stable | +0 | +0 | +0 | Stable |
| Rough | +1 | +2 | +2 | Unsteady |
| Shallow Water | +2 | +4 | +3 | Unsteady |
| Mud | +3 | +5 | +4 | Compromised |

Examples:
- move into Mud = `1 AP + 3 Stamina`;
- neutral Sprint ending in Mud = `13 Stamina` before other modifiers;
- neutral Dodge controlled by Mud = `1 RP + 18 Stamina`.

Values are first-slice prototype targets, not final production balance.

## Terrain cost/stack law

Exactly one effective primary surface controls movement surcharge per node.

Water-over-mud does not automatically sum Water + Mud costs. The node declares the effective primary combat surface.

Normal movement/Sprint use destination surface surcharge.

Dodge uses:
`max(origin_surface_dodge_surcharge, destination_surface_dodge_surcharge)`.

This accounts for launch/landing footing without double charging.

Forced displacement does not automatically spend voluntary movement Stamina; the destination terrain becomes authoritative after displacement resolves.

## No terrain RNG

Selected:
`TERRAIN_RANDOM_SLIP_ROLL = NONE`.

Mud, Water and Rough Ground do not independently roll a chance to fall, Stagger or become Off-Balance.

Terrain pressure comes from explicit cost, footing, visibility, exposure and clearance. Any future terrain-linked status consequence must come from an authored action/hazard and the existing deterministic/reproducible resolution boundaries.

## Brush

Brush affects visibility/selected-part exposure only where sight actually crosses vegetation.

First-slice Brush may degrade exposure by at most one normal step.

Brush alone never:
- becomes physical armor;
- grants physical Partial/Full Cover;
- intercepts an attack.

Solid roots, trunks and boulders use Combat Resolution's physical cover system.

## High Ground

No generic:
- damage bonus;
- Initiative bonus;
- free hit-quality tier;
- automatic accuracy bonus.

Actual elevation may change line of effect, range and part exposure. The trace must report the concrete geometry/exposure reason rather than a generic `HIGH_GROUND_BONUS`.

## Narrow

Narrow ground controls physical clearance/adjacency only.

It may reject actor movement or techniques with explicit clearance requirements when geometry cannot support them.

It does not apply generic accuracy/damage penalties or invisible cover.

## Status/Initiative compatibility

Terrain never automatically applies Off-Balance/Staggered/Bleeding.

Braced/Guarded can coexist with difficult terrain; Brace stabilizes the actor but does not convert Mud into Stable Ground.

Selected:
`TERRAIN_INITIATIVE_MODIFIER = NONE`.

The frozen Initiative snapshot/order is unchanged by moving between terrain types.

## Region 01 proof mapping

`R01_EF01 Riverbank Ford`:
Stable / Mud / Shallow Water + real rock/log cover.

`R01_EF02 Meadow Edge`:
Stable Ground + Brush edge context + real tree/rock cover.

`R01_EF03 Root/Boulder Hollow`:
Rough Ground + Brush + Narrow + real root/boulder cover.

`R01_EF04 Deep Nest Shelf`:
Stable/Rough stone + High Ground + authored Narrow approaches/physical cover.

This preserves the rule that combat is a tactical interpretation of the real region location, not a generic arena.

## Future implementation tests

The contract records 35 required checks, including:
- exact movement/Sprint/Dodge terrain surcharges;
- Dodge max(origin,destination) rule;
- insufficient-Stamina rejection before commit;
- no terrain RNG;
- no primary-surface double stacking;
- forced-movement non-charge;
- Brush visibility vs solid cover separation;
- High Ground no hidden bonuses;
- Narrow hard-legality behavior;
- status/Initiative non-mutation;
- deterministic terrain traces;
- save/reload no duplicate costs;
- Region 01 footprint representation.

No runtime test is claimed because combat source does not yet exist.

## Documentation/navigation reconciliation

This pass updates/maps:
- `docs/20_gameplay/combat/FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`;
- `docs/20_gameplay/combat/README.md`;
- `docs/20_gameplay/README.md`;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`;
- `README.md`;
- `DOCUMENTATION_INDEX.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `EVOLVE_ALIGNMENT.md`;
- this handoff.

## Verification boundary

`FIRST_SLICE_TERRAIN_EFFECT_SET = RECORDED`.
`TERRAIN_RUNTIME_IMPLEMENTED = NO`.
`TERRAIN_RUNTIME_VERIFIED = NO`.

Stage-1 phone truth remains unchanged:
- `PERFORMANCE_VERIFIED = NO`;
- `ENGINE_PHONE_PROBE_VERIFIED = NO`;
- `FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

Implementation action when phone evidence exists:
`DEFERRED_GALAXY_A03S_PERFORMANCE_AND_REGRESSION_EXECUTION_WHEN_DEVICE_AVAILABLE`.

## Exact next active non-phone action

`MONSTER_01_COMBAT_ATTACK_PACKET_CONTRACT`

That next pass must define only Monster 01's minimal legal combat attack packet: capability requirements, ranges/bearings, commitment, telegraphs, legal reactions, status consequences, terrain/cover constraints and guard-impact behavior.

Do not combine it with berserk, party design, defeat/retreat behavior or production implementation.