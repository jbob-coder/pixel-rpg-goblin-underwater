# REGION_01 — Streaming, Simulation Fidelity and Performance

Status: SELECTED REGION PERFORMANCE ARCHITECTURE / UNMEASURED PROTOTYPE TARGETS
Last reconciled: 2026-09-02

## Purpose

Apply the project streaming/performance rules to Region 01 so continuous wilderness does not mean the whole region is fully loaded/simulated at once.

Global authority remains `/WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md` and `/PERFORMANCE_BUDGETS_AND_CAPS.md`.

## Core quality rule

The player experiences one continuous hunting region while the runtime maintains **bounded presentation/simulation fidelity**.

Technical sector boundaries should be invisible during normal traversal.

## Region runtime rings

Conceptual fidelity:

### Ring 0 — Current sector
Highest required exploration fidelity:
- traversable terrain/collision;
- player;
- relevant persistent monster(s);
- nearby evidence;
- encounter footprints;
- critical audio/lighting;
- required interactables;
- local behavior/event evaluation.

### Ring 1 — Required neighboring sectors
Prepared enough for seamless crossing and visible continuity:
- core terrain/LOD;
- collision/navigation required for incoming actors;
- important persistent actor state;
- required evidence/state;
- essential audio/landmark representation;
- preloaded critical assets where needed.

### Ring 2 — Next-hop / visible distant context
Low-cost presentation/logical state:
- far landmark LOD;
- aggregate ecology;
- persistent actor logical location/path progress;
- no hero-detail animation unless specifically visible/required.

### Off-region / inactive
- aggregate region state only;
- no full per-creature behavior/pathfinding/rendering;
- persistent important monsters retain logical state.

Exact engine implementation waits for engine selection.

## Adjacency-driven preload

Preload priority should use:
- player distance/direction;
- canonical sector adjacency;
- visible sight lines;
- current persistent monster route;
- active hunt/escape context;
- predicted camera need only as optimization, never gameplay authority.

Example:
If player is in `R01_S03` and a hunted monster retreats toward `R01_S05`, S05 becomes high-priority even if player momentarily faces S04.

This prevents the presentation system from losing the active hunt because of a simplistic camera-only loader.

## Transition grace zone

Sector edges should have enough spatial overlap/buffer to:
- preload destination essentials;
- prevent pop-in at the exact boundary;
- keep monster crossing continuous;
- avoid rapid load/unload thrashing when the player moves back and forth.

Exact meter width is engine/device dependent.

## Hysteresis rule

Do not unload a sector immediately when the player crosses one centimeter out of it.

Use a bounded hysteresis/cooldown/reference rule so border movement does not repeatedly destroy/recreate assets.

This is a technical implementation requirement, not a gameplay timer.

## Persistent monster crossing

When a persistent monster crosses a sector boundary:
- instance ID remains unchanged;
- authoritative state remains in world/region domain;
- only its presentation/runtime representation changes fidelity;
- wounds/anatomy/crystal/status/behavior phase remain;
- movement destination remains legal according to region graph;
- track/evidence generation remains coherent.

Presentation unload may never imply creature deletion.

## Ecology simulation tiers

### Active relevant monster
Full required deterministic behavior/state for current hunt.

### Nearby relevant ecology
Reduced/event-driven simulation sufficient to produce believable nearby world state.

### Distant region ecology
Aggregate population/pressure updates at coarse boundaries/ticks/events.

Do not evaluate full behavior trees/pattern sets for every off-screen creature every frame.

## Evidence presentation tiers

Tracking data can be authoritative/logical while only nearby evidence is rendered.

Preferred approach:
- current/nearby evidence rendered as bounded decals/objects/audio;
- farther known evidence stored logically;
- old/irrelevant ambient evidence cleaned first;
- unique active-hunt evidence gets higher persistence priority.

## Terrain/vegetation degradation order

If performance is insufficient, reduce in this approximate region-specific order before harming hunt readability:
1. tiny ambient particles/insects;
2. small decorative plants/debris;
3. distant decorative wildlife;
4. expensive transparent foliage layers;
5. shadow distance/resolution/count;
6. far vegetation/rock LOD detail;
7. decorative wind/secondary animation;
8. noncritical ambient audio emitters;
9. post effects.

Protect:
- player input;
- terrain collision;
- tracks/evidence relevant to active hunt;
- monster silhouette/anatomy;
- cover/encounter geometry;
- telegraphs;
- sector continuity;
- critical audio cues.

## Water/mud risk budget

`R01_S01` is deliberately included as a performance test because water, transparency, reflections, wetness, footprints and mud can become expensive together.

Prototype should separately toggle/measure:
- water material;
- reflection/refraction if used;
- shore transparency;
- wetness decals;
- footprints;
- reeds/foliage;
- particles/splashes.

The shared effect rule for mud/water must remain functional even if decorative presentation is reduced.

## Deepwood risk budget

`R01_S05` is a foliage/occlusion stress case.

Measure:
- visible vegetation instances;
- overdraw/transparency;
- shadows;
- collision count;
- monster visibility/readability;
- streaming from multiple connected neighbors.

Dense appearance should come from strong grouped forms/LOD, not thousands of unique hero-detail leaves.

## Rocky-rise sightline risk

`R01_S04` can see farther than most sectors.

It needs:
- aggressive distant LOD;
- terrain occlusion/folds;
- controlled landmark visibility;
- no requirement to render full deep sectors at close quality just because their silhouette is visible.

## First-person encounter promotion

When combat begins:
- local encounter footprint/monster presentation promotes to highest required detail;
- irrelevant distant wilderness presentation can demote;
- authoritative world state remains connected;
- returning to exploration reconstructs required region presentation from state.

Do not keep every surrounding sector at combat hero detail.

## Instrumentation requirements

Future Admin/performance overlay should show for Region 01:
- current sector;
- promoted/preloaded/logical neighbors;
- sector load/unload timestamps;
- resident memory by sector;
- visible instances;
- draw calls/render objects if engine exposes them;
- skinned meshes/bones;
- active collision/physics bodies;
- behavior evaluations;
- evidence/decal counts;
- particles;
- lights/shadow casters;
- audio voices;
- hitches during crossing;
- persistent monster representation/fidelity tier.

## Artificial slow-stream test

Development build should eventually support intentionally delayed asset readiness to expose:
- missing fallback representation;
- boundary pop-in;
- monster disappearance;
- duplicate instance spawning;
- input stalls;
- invalid encounter creation while destination sector is incomplete.

This is a high-value robustness test.

## Prototype verification route

At minimum profile repeated loops:

`S00 → S01 → S03 → S04 → S05 → S02 → S00`

and

`S03 encounter → monster escape to S05 → pursue → S06 → return through S04/S03`.

Cross boundaries repeatedly in both directions to detect thrashing/leaks.

## Status language

Current sector counts/LOD distances/memory budgets are **UNMEASURED PROTOTYPE TARGETS**.

Do not label Region 01 PERFORMANCE_VERIFIED until tested on the chosen Android target with real/representative assets.
