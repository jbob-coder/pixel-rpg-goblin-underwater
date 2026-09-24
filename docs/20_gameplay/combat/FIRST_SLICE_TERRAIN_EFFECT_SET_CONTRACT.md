# First-Slice Terrain Effect Set Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO COMBAT IMPLEMENTATION
Last reconciled: 2026-09-03

## Purpose

Define the smallest concrete terrain-effect packet required to make Region 01 combat positioning mechanically meaningful without creating a broad biome catalog, hidden terrain RNG, invisible cover bonuses, or a second movement/defense system.

Primary quality rule:

**Terrain changes explicit costs, legality, footing, visibility and exposure through the shared combat/effect pipeline; it never grants hidden random slips, hidden damage bonuses, extra turns or presentation-owned gameplay.**

This contract owns:
- first-slice combat terrain tags/effects;
- primary-surface vs contextual-tag separation;
- concrete first-slice movement/Sprint/Dodge Stamina surcharges;
- footing classifications;
- brush/high-ground/narrow-ground semantics;
- terrain stacking/precedence rules;
- interaction boundaries with cover, statuses, Initiative and Stamina;
- Region 01 first-footprint mapping;
- future implementation tests/traces.

It does not own:
- Region 01 geography/sector placement;
- tracking/evidence math;
- weather values;
- Monster 01 terrain adaptations or attacks;
- final AttackControl/DefenseControl numeric formulas;
- final animation/meter distances;
- environment destruction;
- production terrain rendering/physics implementation.

Supporting authorities:
- `/STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `/docs/10_world/regions/REGION_01/README.md`;
- `/docs/10_world/regions/REGION_01/TERRAIN_ECOLOGY_MUTATION.md`;
- `/docs/10_world/regions/REGION_01/ENCOUNTER_FOOTPRINTS.md`;
- `ACTION_ECONOMY_CONTRACT.md`;
- `STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`;
- `INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `FIRST_WEAPON_FAMILY_CONTRACT.md`.

---

# 1. Selected first-slice terrain packet

The first combat prototype uses exactly four **primary surfaces** and three **context tags**.

## Primary surfaces

Exactly one effective primary combat surface is selected per tactical node:
1. `terrain_stable_ground` / `STABLE_GROUND`;
2. `terrain_mud` / `MUD`;
3. `terrain_shallow_water` / `SHALLOW_WATER`;
4. `terrain_rough_ground` / `ROUGH_GROUND`.

## Context tags

Zero or more may coexist with the primary surface when physically justified:
5. `terrain_brush` / `BRUSH`;
6. `terrain_high_ground` / `HIGH_GROUND`;
7. `terrain_narrow` / `NARROW`.

This set is deliberately sufficient for:
- Riverbank Ford;
- Meadow Edge;
- Root/Boulder Hollow;
- Deep Nest Shelf.

Not selected now:
- deep water;
- sand;
- ice;
- ash;
- loose gravel as a separate ruleset;
- heat/cold environmental strain;
- weather-specific combat values;
- elemental terrain fields;
- destructible terrain;
- broad hazard catalogs.

---

# 2. Primary-surface exclusivity

A combat node may visually contain several materials, but it must expose one **effective primary surface** for first-slice movement-cost evaluation.

Examples:
- ankle-deep water over a muddy bed uses `SHALLOW_WATER` for combat movement surcharge rather than stacking Water + Mud costs;
- a dry root-filled lane can use `ROUGH_GROUND`;
- open meadow grass with normal footing uses `STABLE_GROUND`;
- a muddy bank uses `MUD`.

No implicit additive stacking of multiple primary surfaces is allowed.

If later content needs a genuinely different combined surface, it receives an explicit validated definition rather than silently summing every nearby tag.

---

# 3. Existing base action costs remain authoritative

From current combat authorities:
- normal adjacent reposition: `1 AP`;
- stable-ground adjacent reposition: `0 Stamina` baseline;
- Sprint: `8 Stamina` baseline;
- Dodge: `14 Stamina` baseline.

This terrain contract adds only the selected terrain surcharge.

It does not change:
- `MAX_AP = 4`;
- `MAX_RP = 1`;
- Stamina max/recovery;
- reaction ownership;
- action commitment/refund laws.

---

# 4. Concrete primary-surface surcharges

First-slice neutral actor values:

| Primary surface | Adjacent move Stamina surcharge | Sprint Stamina surcharge | Dodge Stamina surcharge | Footing |
|---|---:|---:|---:|---|
| `STABLE_GROUND` | `+0` | `+0` | `+0` | `FOOTING_STABLE` |
| `ROUGH_GROUND` | `+1` | `+2` | `+2` | `FOOTING_UNSTEADY` |
| `SHALLOW_WATER` | `+2` | `+4` | `+3` | `FOOTING_UNSTEADY` |
| `MUD` | `+3` | `+5` | `+4` | `FOOTING_COMPROMISED` |

Therefore neutral first-slice examples are:
- adjacent move onto Mud: `1 AP + 3 Stamina`;
- Sprint ending on Mud: normal Sprint AP rule + `13 Stamina` total before other legal modifiers;
- Dodge where Mud is the controlling surface: `1 RP + 18 Stamina` total before other legal modifiers;
- Dodge where Shallow Water controls: `1 RP + 17 Stamina`;
- Dodge where Rough Ground controls: `1 RP + 16 Stamina`.

These are prototype balance values, not final production promises.

## Why Stamina rather than routine AP inflation

Under a 4-AP economy, adding `+1 AP` to every ordinary difficult-terrain step doubles a normal movement action's tactical-time cost. The first slice instead makes ordinary difficult terrain primarily an exertion/footing problem while preserving readable node movement.

Terrain may still make a route or action illegal through explicit geometry/clearance rules.

---

# 5. Movement surcharge timing

## Normal adjacent movement

Terrain surcharge comes from the **destination primary surface**.

```text
VALIDATE DESTINATION
→ read destination primary surface
→ compute AP + Stamina cost
→ apply legal modifiers/caps/floors
→ freeze final cost
→ commit movement
→ update authoritative node/terrain context
```

## Sprint / larger voluntary reposition

For the first slice, a Sprint/larger reposition uses the selected destination surface surcharge **once per committed reposition action**.

If later implementation introduces multi-node continuous paths inside one Sprint, that path-specific accounting requires a bounded extension rather than silently multiplying this prototype value.

## Dodge

Dodge footing depends on both launch and landing.

Selected first-slice rule:

`DODGE_TERRAIN_SURCHARGE = max(origin_surface_dodge_surcharge, destination_surface_dodge_surcharge)`.

This prevents dodging from deep mud onto dry ground for free while also avoiding double-charging both surfaces.

## Forced displacement

Forced movement/knockback does not automatically charge voluntary movement Stamina.

After forced movement resolves:
- the destination primary surface becomes authoritative;
- contextual tags update;
- future actions use the new terrain state;
- any explicit collision/fall/status consequence remains owned by the action/defense system.

---

# 6. No random slip/fall rule

First-slice terrain uses:

`TERRAIN_RANDOM_SLIP_ROLL = NONE`.

Mud, water and rough ground do not independently roll a random chance to knock the actor down or apply Off-Balance.

Terrain pressure comes from:
- explicit resource cost;
- footing context;
- movement/clearance legality;
- visibility/exposure relationships;
- authored action consequences.

If a future technique or hazard can force Off-Balance because of terrain, that consequence must be deterministic or use an already-approved reproducible resolution source owned by that action. Terrain presentation cannot roll it independently.

---

# 7. Footing classifications

Selected first-slice classes:
- `FOOTING_STABLE`;
- `FOOTING_UNSTEADY`;
- `FOOTING_COMPROMISED`.

They are explicit context inputs, not hidden percentage modifiers.

Current mapping:
- Stable Ground → `FOOTING_STABLE`;
- Rough Ground → `FOOTING_UNSTEADY`;
- Shallow Water → `FOOTING_UNSTEADY`;
- Mud → `FOOTING_COMPROMISED`.

Footing may later feed bounded values for:
- DefenseControl;
- Guard Stability;
- displacement resistance;
- difficult movement validation.

Those numeric mappings remain `COMBAT_NUMERIC_IMPLEMENTATION_OPEN` because current Combat Resolution deliberately leaves final score scales open.

Footing does not by itself:
- change Initiative snapshot/order;
- create a status;
- skip a turn;
- alter AP cap;
- deal damage.

---

# 8. `BRUSH` context

`BRUSH` is primarily visibility/target-acquisition context in the first slice.

It is not invisible armor and does not physically intercept a melee attack merely because the tag exists.

Selected rules:
- light/dense vegetation can lower visible selected-part exposure when the sight line actually crosses it;
- authored exposure may degrade by at most one normal step because of first-slice Brush alone: `EXPOSED → PARTIALLY_EXPOSED` or `PARTIALLY_EXPOSED → OBSCURED`;
- Brush cannot turn physical body armor into stronger armor;
- Brush does not create `PARTIAL_COVER` or `FULL_COVER` unless a real solid object also provides that cover relation;
- trunks, boulders and thick roots are physical cover geometry handled through Combat Resolution;
- Brush can be ignored/altered later by an explicit size/terrain capability, but no first-slice actor receives such a capability here.

No generic movement Stamina surcharge is assigned to Brush in this first packet; dense movement obstruction is represented through node/route legality or `NARROW`/primary-surface context rather than double-charging tags.

---

# 9. `HIGH_GROUND` context

`HIGH_GROUND` is an elevation relationship, not a universal damage buff.

Selected rules:
- no generic `+damage`;
- no generic `+Initiative`;
- no free hit-quality tier;
- no automatic accuracy bonus;
- actual elevation can change line of effect, range, physical cover and target-part exposure;
- an authored footprint may expose anatomy that is genuinely more visible from the elevated node;
- a low body part can likewise become harder to contact from some elevated angles;
- melee reach/technique legality still obeys physical range/geometry.

The resolution trace must identify the specific exposure/line-of-effect consequence rather than reporting an unexplained `HIGH_GROUND_BONUS`.

---

# 10. `NARROW` context

`NARROW` represents physical clearance/adjacency restriction.

Selected rules:
- node links may be unavailable to actors whose body/locomotion capability cannot fit;
- large displacement actions can be illegal where the authored lane cannot physically support them;
- techniques with explicit clearance/arc requirements can be rejected when geometry does not support them;
- Narrow does not apply a generic damage/accuracy debuff;
- Narrow does not create cover by itself;
- a failed clearance validation is a hard legality result, not a hidden penalty roll.

Field Poleblade attacks remain governed by their weapon contract. This terrain contract does not automatically declare every cleave illegal in a narrow location; the technique/footprint geometry must actually fail its clearance requirement.

---

# 11. Physical cover remains separate

Combat Resolution owns:
- `NO_COVER`;
- `PARTIAL_COVER`;
- `FULL_COVER`;
- directional interception;
- local target-part exposure/protection ordering.

Terrain context may help determine where cover exists, but it does not replace the physical cover relation.

Examples:
- boulder on Stable Ground → physical Partial/Full Cover as geometry warrants;
- Brush with no solid trunk → visibility effect only;
- raised bank → may provide elevation and physical cover if geometry actually blocks line of effect;
- Mud alone → no cover.

This prevents invisible percentage-cover zones.

---

# 12. Status/tactical-state interactions

## Off-Balance

Terrain does not automatically apply `status_off_balance`.

If Off-Balance already exists:
- terrain surcharges still apply normally;
- deliberate Brace may clear Off-Balance according to the status contract;
- the underlying terrain remains Mud/Water/Rough afterward.

Brace stabilizes the actor; it does not magically convert the ground to Stable Ground.

## Braced

`tactical_braced` can coexist with any selected primary surface.

Its stability benefit is evaluated against current footing through Combat Resolution. No terrain tag removes Braced automatically unless a movement/displacement/action rule already says so.

## Guarded

`tactical_guarded` remains directional and can coexist with terrain tags.

Terrain never rotates guard direction or grants a free Block/RP.

## Staggered / Bleeding

Terrain does not change their timing/stacking rules in the first slice.

---

# 13. Initiative boundary

Terrain never modifies an already-captured Initiative snapshot in the first slice.

`TERRAIN_INITIATIVE_MODIFIER = NONE`.

Moving from Stable Ground into Mud during combat cannot reorder the current or future normal round roster under the current Initiative contract.

A future explicit order-changing terrain mechanic would require its own bounded scheduler extension.

---

# 14. Terrain adaptation/capability hook

The global stats/effect system already permits explicit terrain capabilities such as `MUD_RESISTANT` or `SURE_FOOTED`.

This contract does not assign them to Hunter or Monster 01.

Future explicit capability behavior must:
- identify its source;
- identify exactly which surcharge/footing rule it modifies;
- use the shared modifier/cap trace;
- not grant hidden AP/turns;
- not silently erase unrelated action Stamina costs.

Ordinary action Stamina cost floors remain governed by the Stamina contract.

---

# 15. Region 01 footprint mapping

## R01_EF01 — Riverbank Ford
Required first-slice terrain proof:
- Stable Ground dry-bank nodes;
- Mud nodes;
- Shallow Water nodes;
- optional High Ground bank node;
- real boulder/log cover handled separately.

This footprint validates:
- destination movement surcharge;
- Dodge origin/destination rule;
- visible change from dry bank to mud/water;
- physical cover separation.

## R01_EF02 — Meadow Edge
Required first-slice terrain proof:
- mostly Stable Ground;
- open center with no fake terrain defense;
- Brush at selected edge locations only where vegetation exists;
- real rock/tree cover handled separately.

This footprint validates that open terrain can be tactically dangerous because it lacks concealment/cover without requiring an arbitrary negative status.

## R01_EF03 — Root/Boulder Hollow
Required first-slice terrain proof:
- Rough Ground;
- Brush where sight is actually interrupted;
- Narrow lanes where clearance/adjacency is physically limited;
- boulders/roots as real physical cover.

This footprint validates constrained movement and target visibility without turning the area into an invisible debuff zone.

## R01_EF04 — Deep Nest Shelf
First-slice-compatible mapping:
- Rough Ground / Stable stone nodes as authored;
- High Ground relationships;
- Narrow approach lanes only where geometry warrants;
- physical stone/nest cover separately.

Crystal/mutation pressure has no generic combat-stat bonus in this terrain packet.

---

# 16. Authoritative terrain trace

Every terrain-sensitive action should be able to expose:
- actor ID;
- action/reaction ID;
- origin node ID;
- destination node ID if any;
- origin/destination primary surfaces;
- active context tags;
- base AP/RP/Stamina cost;
- selected terrain surcharge source/value;
- final validated cost;
- footing classification;
- clearance legality result;
- brush/elevation exposure changes if any;
- physical cover relation separately;
- capability/modifier sources;
- final result/rejection reason.

Example:

```text
ACTION: DODGE
ORIGIN: node_river_mud_02 / MUD
DESTINATION: node_bank_dry_03 / STABLE_GROUND
BASE: 1 RP + 14 Stamina
TERRAIN: max(MUD +4, STABLE +0) = +4
FINAL: 1 RP + 18 Stamina
FOOTING: FOOTING_COMPROMISED
RESULT: LEGAL
```

Presentation may summarize this but never recompute it independently.

---

# 17. Save/reload continuity

Future encounter persistence must restore:
- current tactical node;
- primary surface/context tags derived from that node;
- authoritative physical cover/elevation relationships;
- committed action costs/state if saving mid-resolution;
- terrain capability/modifier sources.

Reload may not:
- charge terrain cost again for an already-resolved move;
- reroll a slip/fall event (none exists in first slice);
- change Initiative because terrain reloaded;
- duplicate statuses;
- change guard direction because camera restored differently.

---

# 18. Future implementation-test packet

At minimum test:
1. Stable Ground adjacent move remains `1 AP + 0 Stamina` terrain surcharge.
2. Rough Ground adjacent move adds `1 Stamina`.
3. Shallow Water adjacent move adds `2 Stamina`.
4. Mud adjacent move adds `3 Stamina`.
5. Sprint Stable adds `0` terrain Stamina.
6. Sprint Rough adds `2`.
7. Sprint Shallow Water adds `4`.
8. Sprint Mud adds `5`.
9. Dodge Stable/Stable adds `0`.
10. Dodge Mud→Stable adds `4` once.
11. Dodge Stable→Mud adds `4` once.
12. Dodge Water→Rough uses max `3` rather than sum `5`.
13. insufficient final Stamina rejects before commit.
14. no terrain random slip RNG is called.
15. forced displacement does not charge voluntary move Stamina.
16. forced destination terrain becomes authoritative after movement.
17. one effective primary surface only is used for cost.
18. Water-over-mud does not double-stack primary surcharges.
19. Brush changes only valid sight/exposure context.
20. Brush alone never grants physical cover/protection.
21. High Ground gives no generic damage bonus.
22. High Ground gives no Initiative bonus/reorder.
23. Narrow rejects only explicitly incompatible clearance/adjacency.
24. Narrow alone gives no cover.
25. Braced can coexist with Mud/Water/Rough.
26. Brace does not remove the terrain surface/surcharge.
27. Guarded direction is unchanged by terrain/camera.
28. terrain never auto-applies Off-Balance.
29. terrain never changes Bleeding/Staggered timing.
30. deterministic identical terrain/action state produces identical cost/legality trace.
31. save/reload does not double-charge a resolved terrain move.
32. Region Ford footprint can represent Stable/Mud/Water simultaneously across different nodes.
33. Meadow open center has no invented defense bonus.
34. Root/Boulder footprint separates Brush visibility from solid cover.
35. no new Android/probe runtime claim is inferred from this design contract.

---

# 19. Verification boundary

This is a design contract only.

`FIRST_SLICE_TERRAIN_EFFECT_SET = RECORDED`
`TERRAIN_RUNTIME_IMPLEMENTED = NO`
`TERRAIN_RUNTIME_VERIFIED = NO`

No combat runtime exists yet.
No phone/runtime/engine claim changes because of this document.

---

# 20. Exact selected values summary

Primary surfaces:
- `STABLE_GROUND`: Move `+0`, Sprint `+0`, Dodge `+0`, Stable footing;
- `ROUGH_GROUND`: Move `+1`, Sprint `+2`, Dodge `+2`, Unsteady footing;
- `SHALLOW_WATER`: Move `+2`, Sprint `+4`, Dodge `+3`, Unsteady footing;
- `MUD`: Move `+3`, Sprint `+5`, Dodge `+4`, Compromised footing.

Context tags:
- `BRUSH`: visibility/exposure only; no invisible physical cover;
- `HIGH_GROUND`: actual geometry/exposure/line-of-effect only; no generic damage/Initiative bonus;
- `NARROW`: clearance/adjacency legality only; no generic accuracy/damage penalty.

Hard laws:
- exactly one primary surface for first-slice movement-cost evaluation;
- no additive primary-surface stacking;
- no random terrain slip roll;
- Dodge surcharge uses max(origin, destination);
- forced displacement does not charge voluntary movement Stamina;
- physical cover remains separate;
- terrain does not change Initiative snapshot/order;
- terrain does not auto-apply status effects;
- presentation never owns terrain gameplay.

## Exact next combat-design dependency

After this contract is recorded and mapped, the next bounded design piece is:

`MONSTER_01_COMBAT_ATTACK_PACKET_CONTRACT`

That next pass must define only Monster 01's minimum legal combat attack packet, capability requirements, telegraphs, commitment/reaction profiles, status consequences and guard-impact behavior.

Do not combine it with berserk, party design, defeat/retreat behavior or production implementation.