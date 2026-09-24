# First-Slice World Coordinate / Dimension Framework Contract

Status: SELECTED FIRST-SLICE PROTOTYPE SPATIAL DESIGN / NO WORLD GRAYBOX IMPLEMENTATION
Last reconciled: 2026-09-03

Technical/world owner: `docs/10_world/spatial/`

## Purpose

Turn the project's existing scale ranges, Settlement 01 layout, Region 01 topology and encounter-footprint requirements into one coherent coordinate framework that later graybox scenes, persistence, tests, models and tools can reference without inventing independent origins or dimensions.

Primary law:

**Spatial coordinates are authoritative planning data only when they use the shared space/axis/anchor vocabulary. Prototype coordinates guide grayboxing; they are not production-final measurements or phone-runtime evidence.**

This contract owns:
- first-slice world measurement convention;
- engine-neutral world axis/cardinal vocabulary;
- major-area local-space/origin policy;
- coordinate/anchor ID conventions;
- Settlement 01 prototype extent/anchor layout;
- frontier-transition prototype dimensions/anchors;
- Region 01 sector-center/planning-envelope layout;
- route-anchor relationship to canonical topology;
- first encounter-footprint anchor/envelope layout;
- cross-system dimension reference table;
- prototype-coordinate change/validation rules;
- future spatial/graybox tests.

It does not own:
- final terrain meshes;
- final collision polygons;
- final camera altitude/FOV;
- exact navmesh/path geometry;
- production asset pivots;
- final building interiors;
- exact tactical-node coordinates;
- final sector streaming grace-zone width;
- phone performance;
- production implementation.

Supporting authorities:
- `/WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `/MAP_WORLD_SETTLEMENT_STRUCTURE.md`;
- `/FIRST_SETTLEMENT_BLUEPRINT.md`;
- `/docs/10_world/settlements/SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`;
- `/docs/10_world/regions/REGION_01/README.md`;
- `/docs/10_world/regions/REGION_01/REGION_TOPOLOGY.md`;
- `/docs/10_world/regions/REGION_01/ENCOUNTER_FOOTPRINTS.md`;
- `/docs/10_world/regions/REGION_01/STREAMING_AND_PERFORMANCE.md`;
- `/docs/30_content/hunters/HUNTER_BASE_01/PROPORTION_AND_ATTACHMENT_CONTRACT.md`;
- `/docs/30_content/monsters/MONSTER_01/README.md`;
- `/docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`.

---

# 1. Measurement standard

`LOCKED/CURRENT`

Preferred first-slice world measurement:

`1 world unit = 1 meter`

This is already selected by the world-scale authority and is adopted directly here.

Use meters for:
- player/Monster scale;
- building footprints;
- streets;
- terrain routes;
- sector planning spans;
- encounter footprints;
- positions saved through Persistence;
- future debug distance/path measurements.

Do not solve aerial readability by scaling authoritative physical objects arbitrarily.

---

# 2. World axis convention

`SELECTED PROTOTYPE FRAMEWORK`

Use the following right-handed world/map frame:

- `+X = EAST` / map right;
- `+Y = UP`;
- `-Z = NORTH` / outward from Settlement 01 toward Region 01;
- `+Z = SOUTH` / inward through Settlement 01.

Right-handed check:
`+X × +Y = +Z`.

Heading vocabulary:
- `0° = NORTH (-Z)`;
- `90° = EAST (+X)`;
- `180° = SOUTH (+Z)`;
- `270° = WEST (-X)`.

Headings increase clockwise when read from above using the project map convention.

## Hunter-local frame relationship

Hunter Base 01 already uses a model/local documentation frame:
- local `+Y = up`;
- local `+Z = character forward`;
- local `+X = character right`.

This is not a conflict.

A Hunter's local `+Z` is transformed into whichever world heading the actor currently faces. Model-local forward does not mean world South.

---

# 3. Major-area local-coordinate policy

Selected major spaces:
- `space_settlement_01`;
- `space_frontier_01`;
- `space_region_01`.

All share the axis orientation in section 2 but use separate local origins.

Why:
- matches the selected major-area streaming architecture;
- avoids requiring giant world coordinates;
- keeps authoring/debug values readable;
- supports clean persistence as `space_id + local_xyz`;
- lets engine implementations transform/rebase major areas without rewriting gameplay IDs;
- makes future additional settlements/regions independent packages.

A transition owns explicit source/destination anchor mapping.

Example:
```text
space_settlement_01 / anchor_set01_hunter_gate_outer
    -> space_frontier_01 / anchor_frontier_gate_outer

space_frontier_01 / anchor_frontier_region_handoff
    -> space_region_01 / anchor_r01_entry
```

Do not infer continuity from equal numbers across spaces. Stable anchor mapping owns continuity.

---

# 4. Coordinate notation

Coordinates are written:
`(x, y, z) m`

Example:
`anchor_set01_smith_workbench = (-22, 3, 40) m`.

World-layout prototype coordinates normally use whole meters.

Stable naming:
- spaces: `space_<package>`;
- anchors: `anchor_<package>_<purpose>`;
- existing sector IDs remain `R01_S00` etc.;
- existing footprint IDs remain `R01_EF01` etc.

Do not create a duplicate ID merely because a coordinate exists.

---

# 5. Settlement 01 planning extent

Current specific blueprint range:
approximately `220–280 m` long axis × `160–230 m` short axis.

Selected prototype planning extent:

- X bounds: `-100 .. +100 m`;
- Z bounds: `-10 .. +250 m`;
- characteristic footprint: `200 m east-west × 260 m north-south`;
- ordinary playable-ground elevations: approximately `Y = 0 .. +14 m`.

Classification:
`PROTOTYPE TARGET`.

Towers/chimneys/roof silhouettes may exceed +14 m; the Y range describes primary walkable terraces, not skyline clipping bounds.

Selected origin:
`anchor_set01_hunter_gate_inner = (0, 0, 0) m`.

Settlement 01 therefore extends primarily South (`+Z`) from the wilderness gate.

Reason:
- makes the hunter gate an intuitive technical/continuity origin;
- keeps the repeated service loop near low coordinate magnitudes;
- makes outbound Region direction consistently North/negative-Z;
- maps naturally to the frontier transition space.

---

# 6. Settlement 01 elevation bands

`PROTOTYPE TARGETS`

Use three broad walkable elevation bands:

### Lower/frontier terrace
Approx. `Y = 0 .. +3 m`
- Hunter Gate;
- processing yard;
- Smith/workshop lower service approach.

### Main/service terrace
Approx. `Y = +4 .. +8 m`
- storage/loadout;
- Hunter Lodge;
- market/civic core;
- main repeated-service route.

### Upper/recovery terrace
Approx. `Y = +10 .. +14 m`
- recovery/inn;
- residential layer.

Exact ramps/stairs/retaining walls remain graybox work.

Do not turn these bands into three perfectly flat slabs; they are authoring ranges.

---

# 7. Settlement 01 dimensional targets

The coordinate registry owns concrete anchor positions. This contract owns the scale envelope used around them.

`PROTOTYPE TARGETS`:

| Thing | Prototype dimension |
|---|---|
| Main Hunter Spine | ~8 m clear route width |
| Secondary street | ~5 m |
| Alley/service lane | ~3 m |
| Hunter Gate clear opening | ~7 m wide |
| Gate passage/tunnel | ~12 m long |
| Defensive wall | ~7 m high baseline |
| Smith/Workshop footprint | ~16 × 22 m |
| Smith main working clear height | ~5.5 m interior target |
| Smith service/material door | ~2.4 m clear width × ~3.0 m clear height |
| Processing yard | ~28 × 24 m working yard |
| Storage/Loadout building | ~16 × 20 m |
| Hunter Lodge main mass | ~28 × 32 m |
| Market/Civic plaza | ~28 × 24 m |
| Recovery/Inn | ~18 × 24 m |

These remain inside existing root dimensional guidance.

---

# 8. Gate-to-Smith quality geometry

The Smith-service contract requires future graybox validation of:
`Hunter Gate return threshold -> Smith workbench <= 25 seconds normal walking`.

Prototype coordinate layout places:
- Hunter Gate inner at `(0,0,0)`;
- Smith entry at approximately `(-16,3,34)`;
- Smith workbench at approximately `(-22,3,40)`.

Direct gate-to-workbench distance is approximately `45.7 m` in 3D straight-line planning space.

Interpretation:
- this is short enough to justify a compact repeated service route candidate;
- actual walking path will be longer than direct distance;
- implemented movement speed, ramp/street shape, collision and pathfinding determine elapsed time.

Therefore:
`GATE_TO_SMITH_TIME_VERIFIED = NO`.

Do not turn the <=25-second target into a claimed PASS until measured in the graybox.

---

# 9. Frontier transition space

Selected local space:
`space_frontier_01`.

Origin:
`anchor_frontier_gate_outer = (0,0,0) m`.

Source mapping:
`space_settlement_01 / anchor_set01_hunter_gate_outer -> space_frontier_01 / anchor_frontier_gate_outer`.

`PROTOTYPE TARGETS`:
- total centerline length: ~80 m;
- normal clear playable width: ~12 m;
- minimum choke width: ~8 m;
- supply/watch widening: up to ~18 m;
- total elevation change from Settlement outer gate to Region handoff: ~-4 m;
- route remains physically walkable/diegetic rather than a menu teleport.

The transition is long enough to support loading/ambience change candidates but remains a compact threshold rather than another region.

Exact streaming trigger points remain implementation/device-open.

---

# 10. Region 01 local-space policy

Selected local space:
`space_region_01`.

Origin:
`anchor_r01_entry = (0,0,0) m`.

Frontier mapping:
`space_frontier_01 / anchor_frontier_region_handoff -> space_region_01 / anchor_r01_entry`.

Region 01 extends primarily North (`-Z`) from the trailhead.

The seven current sector identities/topology remain unchanged.

---

# 11. Region sector coordinate model

Each sector records:
- canonical sector ID;
- center coordinate;
- characteristic X×Z planning span;
- center elevation;
- canonical adjacency through route anchors.

A planning span is **not** a visible box/arena.

It is used for:
- first graybox terrain budget;
- rough streaming bounds;
- landmark/route placement;
- path-length sanity checks;
- encounter-footprint containment;
- debugging.

Final sector technical shapes may be irregular polygons/cells.

Natural terrain must hide/soften technical transitions.

---

# 12. Region 01 size consistency

Selected prototype center layout yields canonical connected center-to-center distances of approximately `117–165 m`.

This sits inside the Region 01 local characteristic-span direction of roughly `100–180 m`.

The deepest sector center (`R01_S06`) is approximately `402 m` from Region entry in straight 3D distance.

With sector envelopes, the region occupies roughly a `~450 m` north-south playable planning footprint before distant/horizon geometry.

This is compatible with the existing several-hundred-meter first-region direction and remains far below a kilometer-scale empty map.

---

# 13. Canonical topology preservation

Coordinates may not silently rewrite Region 01 adjacency.

The only canonical first-slice links remain:
- S00↔S01;
- S00↔S02;
- S01↔S02;
- S01↔S03;
- S02↔S03;
- S02↔S05;
- S03↔S04;
- S03↔S05;
- S04↔S05;
- S04↔S06;
- S05↔S06.

Route-anchor coordinates in the registry identify planning locations along these physical connections.

A route anchor is not a teleport portal.

It means:
**the graybox route should physically pass through/near this planning point while connecting its two sector identities.**

No extra route becomes canonical because two technical envelopes happen to approach or overlap.

---

# 14. Sector envelope overlap/buffer rule

Streaming requires visual/technical grace near borders, but exact grace width is still engine/device-dependent.

Selected design rule:
- planning envelopes may touch/approach/partially overlap as necessary for continuous terrain authoring;
- canonical adjacency decides traversability, not raw AABB overlap;
- collision/nav/terrain later define the actual route;
- no player-visible sector wall follows the planning envelope;
- exact Ring-0/Ring-1 streaming hysteresis buffer remains `OPEN / DEVICE-DEPENDENT`.

---

# 15. Encounter footprint coordinates

The registry selects centers/envelopes for all four existing Region 01 prototype footprints:
- `R01_EF01` Riverbank Ford;
- `R01_EF02` Meadow Edge;
- `R01_EF03` Root/Boulder Hollow;
- `R01_EF04` Deep Nest Shelf.

Each envelope fits the current broad `30–90 m` encounter-footprint starting guidance.

The envelope is not a sealed arena boundary.

It identifies the real terrain volume from which later tactical nodes, cover, monster anchors and camera-transition paths will be authored.

Exact tactical node positions remain the next graybox/integration layer.

---

# 16. Physical actor dimension references

`LOCKED/CURRENT`:
- Hunter Base 01 world height: `1.75 m`.

`PROTOTYPE TARGET`:
- Monster 01 nose-to-tail: `~6.6 m`;
- Monster 01 shoulder/main-body height: `~3.0 m`.

`OPEN`:
- final Hunter collision capsule;
- Monster 01 exact body width/mass/collision decomposition;
- final Poleblade physical dimensions/center of mass;
- production rig/collider offsets.

Spatial grayboxes must leave appropriate clearance for the existing Monster size instead of resizing the Monster to fit bad routes.

---

# 17. Coordinate ownership in saves

Persistence stores:
`space_id + local coordinate + orientation + relevant stable anchor/sector references`.

Examples:
```text
space_settlement_01, (-22,3,40), heading 270°
space_region_01, (-92,-4,-145), heading 0°
```

A save does not need one giant global coordinate.

Transition reconstruction uses stable anchor mapping.

If later graybox tuning changes a prototype anchor before production stability, the current coordinate registry and any corresponding test fixtures must be updated together.

Do not silently change an anchor in scene data while leaving documentation/save fixtures stale.

---

# 18. Coordinate change discipline

Before production implementation, prototype coordinates may move when graybox evidence shows:
- excessive travel time;
- bad sightline/camera composition;
- Monster body-fit failure;
- sector streaming problems;
- impossible terrain slope/elevation;
- Settlement service-loop friction.

Any such change must record:
- old anchor/extent;
- new anchor/extent;
- reason/evidence;
- affected route/footprint/test fixtures;
- whether persistence fixtures require migration/update.

Once production saves rely on coordinates, stable anchor IDs matter more than preserving exact historical numeric values; migrations/reconstruction rules then belong to Persistence/Stage-14 hardening.

---

# 19. Required future graybox/spatial tests

Before this framework can be considered graybox-verified, test at least:
1. world/layout implementation uses meter convention with no hidden scale conversion;
2. world axes/cardinal labels agree with debug/map tools;
3. Hunter 1.75 m reference fits doors/interiors naturally;
4. Monster 01 6.6×3.0 m proxy fits every intended Region route;
5. Settlement 01 playable layout remains inside selected prototype planning extent or changes are recorded;
6. Hunter Gate clear width supports intended Hunter/material-cart flow;
7. Smith building footprint does not overlap impossible neighboring geometry;
8. Gate->Smith actual path time is measured and compared with <=25-second target;
9. main Hunter Service Loop path widths remain readable under aerial camera;
10. frontier corridor is continuously traversable;
11. frontier corridor can hide/load major-area transition without geometry pop/softlock;
12. Region entry maps to S00 coherently;
13. all seven sector centers/envelopes are represented in graybox;
14. every canonical topology link exists physically;
15. no noncanonical link appears only because planning envelopes overlap;
16. canonical route distances stay dense enough to avoid empty travel;
17. player can traverse the reference loop S00->S01->S03->S04->S05->S02->S00;
18. Monster proxy can traverse every route its behavior packet may select;
19. S04 elevation does not become precision platforming;
20. S06 remains reachable from both S04 and S05;
21. no normal aerial viewpoint reveals the entire Region graph;
22. R01_EF01 anchor is physically within River Ford context;
23. R01_EF02 anchor preserves open-meadow charge space;
24. R01_EF03 anchor preserves constrained Root/Boulder context and S02/S05 route relationship;
25. R01_EF04 anchor preserves S06 nest escape connections;
26. at least three encounter envelopes accept 6–12 meaningful future tactical nodes;
27. each encounter envelope has legal player/Monster escape mapping;
28. aerial->first-person camera path can be planned without major obstruction;
29. persistence round-trip preserves `space_id + local XYZ + heading` with no unit drift;
30. debug overlay can display space/sector/anchor IDs and meter coordinates;
31. repeated sector crossing does not rely on teleporting between center coordinates;
32. current/neighbor streaming bounds can be derived without loading whole Region at hero detail;
33. coordinate registry has no duplicate stable anchor ID;
34. all referenced space/sector/footprint IDs resolve;
35. coordinate changes are traceable rather than silently edited.

These are future graybox/runtime tests. This document itself is design-recorded only.

---

# 20. Explicitly open

Still open until graybox/engine/device evidence:
- exact Settlement collision boundary;
- exact street curves/slopes/stair geometry;
- exact building doors/interior pivots beyond selected service anchors;
- exact Frontier streaming trigger distances;
- exact sector polygon/streaming buffer shapes;
- exact path spline/route lengths;
- exact tactical-node coordinates;
- exact camera altitude/FOV/zoom limits;
- final navmesh/collider dimensions;
- final Monster width/turn radius;
- final settlement/region size if pacing/profile evidence requires changes;
- target-phone spatial/performance validation.

---

# 21. Acceptance

Design recording is complete when:
- [x] meter convention adopted;
- [x] world axis/cardinal convention selected;
- [x] local major-space policy selected;
- [x] coordinate naming/precision selected;
- [x] Settlement 01 planning extent selected;
- [x] Settlement anchors/dimensions selected;
- [x] Frontier dimensions/anchors selected;
- [x] Region 01 seven-sector coordinate layout selected without changing topology;
- [x] route anchors selected;
- [x] four encounter-footprint anchors/envelopes selected;
- [x] Hunter/Monster/built-world dimension table connected;
- [x] persistence interface linked;
- [x] prototype/final/verified boundaries explicit;
- [x] future graybox tests recorded.

`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_RECORDED = YES`
`WORLD_SPATIAL_GRAYBOX_IMPLEMENTED = NO`
`WORLD_SPATIAL_RUNTIME_VERIFIED = NO`
`SPATIAL_COORDINATES_PHONE_VERIFIED = NO`.