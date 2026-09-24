# REGION_01 — First-Slice Tracking → Encounter Graybox Integration Contract

Status: SELECTED FIRST-SLICE INTEGRATION DESIGN / NO GRAYBOX RUNTIME IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/10_world/regions/REGION_01/`
Concrete coordinate owner for this proof: `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`

## Purpose

Bind the existing Region 01 topology, tracking rules, Monster 01 behavior, world coordinates and first-person encounter-footprint design into one physical first-hunt proof.

Primary law:

**The player follows physical evidence through the same continuous Region that contains the same persistent Monster; engagement converts the current real location into tactical nodes without teleporting either actor to an unrelated arena.**

This contract owns:
- one representative first-slice pursuit chain;
- first-proof evidence order and route-choice semantics;
- same-Monster movement/activity anchors;
- observation and engagement handoff into `R01_EF02`;
- first `R01_EF02` tactical-node graph;
- first-proof cover and Monster-clearance targets;
- Monster escape/reacquisition handoff;
- save/reload checkpoint application;
- future graybox tests.

It does not own:
- generic tracking confidence formulas;
- Monster decision engine semantics;
- generic terrain/status/combat formulas;
- final attack range meters;
- final player/Monster collision dimensions;
- final camera FOV/altitude;
- production terrain art;
- runtime implementation;
- phone/performance verification.

Supporting authorities:
- `REGION_TOPOLOGY.md`;
- `TRACKING_AND_ESCAPE.md`;
- `ENCOUNTER_FOOTPRINTS.md`;
- `STREAMING_AND_PERFORMANCE.md`;
- `/docs/10_world/spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`;
- `/docs/10_world/spatial/FIRST_SLICE_SPATIAL_COORDINATE_REGISTRY.md`;
- `/docs/30_content/monsters/MONSTER_01/BEHAVIOR_AND_REGION.md`;
- `/docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md`;
- `/docs/30_content/monsters/MONSTER_01/COMBAT_ATTACK_PACKET.md`;
- `/docs/20_gameplay/combat/FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT.md`;
- `/docs/20_gameplay/combat/DEFEAT_RETREAT_BASELINE_CONTRACT.md`;
- `/docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`.

---

# 1. Stable proof identities

Scenario ID:
`R01_HUNT01_M01_TRACK_TO_MEADOW`

Hunt ID:
`hunt_r01_m01_proof_01`

Persistent Monster instance ID:
`monster_r01_m01_0001`

Species:
`species_r01_mudcrest_raker`

Encounter ID:
`enc_r01_ef02_m01_0001`

Encounter footprint:
`R01_EF02` — Meadow Edge.

These IDs are prototype content/state identities. Reload, sector streaming and encounter transitions must preserve them rather than spawn replacements.

---

# 2. Selected physical pursuit chain

First-proof intended chain:

```text
FRONTIER HANDOFF
-> R01_S00 TRAILHEAD / FIELD CAMP
-> OUTER CAMP TRACK CLUE
-> R01_S01 RIVER FORD
-> WALLow / WATER-EXIT EVIDENCE
-> ROUTE CHOICE: OLD S02 SIGN vs FRESH S03 SIGN
-> R01_S03 FEEDING MEADOW
-> FEEDING EVIDENCE
-> OBSERVATION EDGE
-> R01_EF02 ENGAGEMENT
-> FIRST-PERSON TACTICAL COMBAT
-> MONSTER ESCAPE EAST
-> R01_S03 -> R01_S05 CANONICAL ROUTE
-> REACQUISITION EVIDENCE
-> SAME MONSTER IN R01_S05
```

The proof deliberately does not require S04/S06 before the first encounter. Those sectors remain available for later/deeper pursuit and are not removed from topology.

---

# 3. Scenario Monster state before player contact

Selected authored proof facts:
- Monster is alive and nonterminal;
- no anatomy part is broken/severed at proof start;
- Berserk is inactive and unused;
- severe injury is false;
- Nest Defense is false;
- the current territory cycle has recently used the western S00-outskirts/S01 route without entering the protected camp core;
- wallowing/thirst activity occurs in S01;
- after wallowing, `feeding_condition = true` for this proof;
- legal S01→S03 route exists;
- deterministic behavior therefore moves the same instance toward S03 Feeding Meadow;
- an older S02-side scrape from the same territory cycle/history may remain as weak evidence.

No random weighted behavior selection is introduced.

---

# 4. Evidence model for this proof

The concrete evidence coordinates live in `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

Exactly seven pre-engagement evidence anchors are selected:
1. outer-camp heavy prints;
2. river-approach bank/reed deformation;
3. fresh wallow/water disturbance;
4. fresh water-exit prints toward S03;
5. old/weak root scrape toward S02;
6. feeding remains in S03;
7. flattened grass + audible feeding near observation edge.

Evidence obeys existing classes/confidence language.

## No-GPS law

Authoring coordinates are developer truth only.

Normal player presentation does not display exact Monster coordinates because an evidence record exists.

Player-facing interpretation may communicate:
- rough direction;
- confidence/age class;
- activity meaning;
- injury meaning when valid;
- known route/landmark association.

It may not reveal the current Monster position unless a separate visibility/knowledge mechanic has actually earned that information.

---

# 5. Route-choice proof

## Choice 1 — S00 outer fork

The player can physically choose:
- western/downhill route toward S01;
- eastern/rootward route toward S02.

Current evidence favors S01 through the heavy-print cluster.

The S02 route remains physically legal. The game does not disable it because it is not the intended proof path.

## Choice 2 — S01 post-wallow interpretation

The River Ford contains conflicting valid history:
- fresh/strong water-exit prints support S03;
- old/weak root-side scrape supports S02 as an older movement direction.

A player who follows the old clue is making an inference error, not hitting an invisible wall. S02 still links to S03 through canonical topology, so the hunt can recover without teleporting.

This is the first proof that evidence **confidence and context** matter more than simply following the nearest glowing marker.

---

# 6. Monster movement continuity

The Monster uses the same persistent instance throughout:

`monster_r01_m01_0001`.

Selected movement sequence:

```text
OUTER S00/S01 TRAIL HISTORY
-> S01 WALLOW
-> S01 WATER EXIT
-> canonical R01_S01<->R01_S03 route
-> S03 FEEDING SITE
-> S03 ALERT/ENGAGEMENT POSITION
```

The behavior owner remains responsible for state selection. This integration contract only records the first-proof scenario facts and spatial application.

No sector boundary:
- heals the Monster;
- resets Core Energy/strain;
- changes stable instance ID;
- deletes evidence merely because presentation unloaded;
- creates a second Monster copy.

---

# 7. Observation / engagement handoff

Selected observation anchor:
`anchor_r01_h01_observe_meadow_w`.

Selected tactical-entry node:
`R01_EF02_N01`.

Selected initial Monster combat anchor:
`R01_EF02_MA01`.

Prototype geometry:
- observation-to-Monster distance: about 56 m;
- initial tactical-node-to-Monster distance: about 54 m;
- player initial heading toward Monster: about 75°;
- Monster initial facing toward player: about 255°.

These are geometry targets, not final detection/range formulas.

The graybox must support observation at this distance without exposing the entire Region.

Monster detection remains determined by authoritative sensing/behavior rules. This contract does not declare the player invisible merely because they occupy the observation anchor.

---

# 8. Aerial → first-person continuity

Encounter creation must consume the same world facts:
- player at `R01_EF02_N01` world coordinate;
- Monster at `R01_EF02_MA01` world coordinate;
- source sector `R01_S03`;
- footprint `R01_EF02`;
- current terrain tags;
- cover objects;
- current player/Monster heading;
- current Monster identity/state.

First-person entry does not move the Hunter or Monster to a hidden secondary arena coordinate system.

Selected first-person facing target:
- player view begins aligned approximately toward the current Monster bearing (~75°) unless an authoritative engagement/awareness state requires a different current heading;
- no new Monster position is generated by the camera transition.

Exact camera altitude, FOV and interpolation path remain open.

Graybox must preserve a clear camera-transition route with no major tree/boulder intersection between the aerial approach and first-person head position.

---

# 9. `R01_EF02` tactical-node proof

The first integrated footprint uses exactly ten player tactical nodes:

`R01_EF02_N01` through `R01_EF02_N10`.

Concrete coordinates/terrain/cover/link values live in the Hunt-01 registry.

Design structure:
- western entry/brush edge;
- west-bank boulder position;
- north-west tree/brush position;
- open west-center positions;
- central open positions;
- rough/brush edge position;
- east/flank positions;
- route-linked exit positions.

Node graph is deliberately sparse enough to make movement choices readable on mobile.

Legal-link straight distances are approximately 14.0–18.5 m in this prototype layout.

This spacing is a graybox target for positional readability; it does **not** define final universal combat movement meters.

---

# 10. Terrain application inside EF02

Primary surfaces used here:
- `STABLE_GROUND`;
- `ROUGH_GROUND`.

Context tags used here:
- `BRUSH`;
- limited `HIGH_GROUND` where the actual meadow-bank/stone lip warrants it.

This first Meadow proof intentionally does not force Mud/Shallow Water into EF02. Those remain demonstrated by `R01_EF01` Riverbank Ford.

Brush remains visibility context, not armor.

High Ground remains physical elevation/exposure context, not a universal damage/Initiative bonus.

No random terrain slip is added.

---

# 11. Physical cover proof

Exactly two substantial first-proof cover objects are selected:

`R01_EF02_COV01_BOULDER_W`
- large western boulder;
- solid physical cover;
- positioned so moving from entry toward the boulder can remove/intercept some charge/contact lines;
- does not block the entire central footprint.

`R01_EF02_COV02_SCARRED_TREE_NW`
- thick scarred tree/root mass at the meadow edge;
- solid trunk/root cover where geometry intercepts;
- surrounding brush remains visibility-only.

No invisible percentage-cover zone is introduced.

---

# 12. Monster clearance targets

Monster 01 current prototype body target:
- ~6.6 m nose-to-tail;
- ~3.0 m shoulder/body height.

Exact collision width and turning radius remain open until blockout/model evidence exists.

For this graybox integration, use conservative **clearance test targets**, not attack-range laws:

### Charge lane
`R01_EF02_CHARGE_LANE_W`
- approximate centerline length: ~48 m;
- prototype clear width: ~9 m;
- runs from the initial Monster anchor toward the western/entry side;
- contains no permanent solid obstacle inside the required lane at proof start.

The western boulder sits outside the initial lane but can become relevant if the Hunter repositions behind it.

### Monster pivot zone
Around `R01_EF02_MA01`:
- prototype solid-obstacle-free radius: ~8 m.

Purpose:
- allow body rotation;
- allow Tail Sweep clearance testing;
- prevent the initial Monster placement from intersecting a tree/boulder.

This radius is not final Tail Sweep attack range.

### Short body-force clearance
At least ~12 m of local forward/side open space must remain available around the initial Monster position to test Shoulder Ram / reposition geometry.

Again, this is an environment clearance target, not final attack reach.

---

# 13. Tactical node / attack relationship

The node layout must allow later tests of:
- long frontal Charge threat from western positions;
- lateral Dodge/reposition choices;
- physical interception by the boulder/tree when geometry supports it;
- close front/front-flank pressure near east/center nodes;
- rear/flank positioning that can expose Tail Sweep threat;
- anatomy targeting from materially different bearings.

This contract does not declare exact node-to-attack legality solely from distance because final Monster attack range meters remain open.

Hard attack requirements in `COMBAT_ATTACK_PACKET.md` remain authoritative.

---

# 14. Monster escape from the first encounter

Selected proof outcome branch:
`MONSTER_ESCAPED`.

This is a test branch, not a guarantee that every first encounter ends in escape.

When behavior/outcome rules legally choose escape:
1. same Monster reaches the east-side footprint escape boundary;
2. outcome owner commits `MONSTER_ESCAPED`;
3. encounter closes;
4. same instance transitions back to Region world state;
5. route intent uses canonical `R01_S03 <-> R01_S05` connection;
6. evidence is emitted along the real eastward/deepwood route;
7. player returns to aerial exploration at their final authoritative tactical/world position;
8. hunt becomes `HUNT_ACTIVE_REACQUIRE`.

No fresh Monster is spawned in S05.

---

# 15. Reacquisition proof

Selected route:

```text
R01_EF02 east escape boundary
-> canonical S03<->S05 route anchor
-> first route-disturbance evidence
-> second deeper evidence
-> same Monster staging position inside S05
```

At least one reacquisition information path must exist.

Guaranteed first-proof evidence may include:
- trampled grass;
- heavy passage scuff;
- broken vegetation appropriate to the body path.

Conditional evidence may include:
- blood only if an authoritative wound/status supports it;
- altered gait prints only if anatomy injury supports them;
- broken horn/plate fragments only if actual anatomy events created them.

The system may not invent blood because the design wants an easier trail.

---

# 16. Persistence checkpoints

The first proof records these save-safe applications:

### `H01_CP01_S00_ROUTE_CHOICE`
`WORLD_DECISION_POINT`
- player at S00 fork;
- inspected evidence IDs preserved;
- Monster remains same instance in its current route/activity state.

### `H01_CP02_S01_POST_WALLOW`
`WORLD_DECISION_POINT`
- fresh S03 evidence + old S02 evidence preserved;
- Monster has not been duplicated or teleported by reload.

### `H01_CP03_MEADOW_OBSERVATION`
`WORLD_DECISION_POINT`
- player observation position/heading saved;
- Monster feeding/alert state and exact Region position saved.

### `H01_CP04_EF02_COMBAT_DECISION`
`COMBAT_DECISION_POINT`
- encounter ID;
- footprint ID;
- player/Monster tactical positions;
- exact Initiative/RoundRoster/AP/RP/Stamina/status state as Persistence requires.

### `H01_CP05_POST_MONSTER_ESCAPE`
`POST_COMBAT_OUTCOME`
- `MONSTER_ESCAPED` committed once;
- Monster instance/route intent saved;
- no combat slot reopened on reload.

### `H01_CP06_S05_REACQUIRE`
`WORLD_DECISION_POINT`
- persistent Monster/evidence IDs restored;
- same Monster remains in S05 with all injury/anatomy/Core/Berserk state.

Presentation state is never the checkpoint authority.

---

# 17. Path / visibility / geometry acceptance targets

These are future graybox tests, not PASS claims.

### Pursuit pacing
- intended S00-departure → Meadow observation anchor-to-anchor chain is about 250 m straight-line cumulative planning distance;
- future navigable graybox route target: approximately 260–340 m before optional detours;
- intended clue gap should generally remain under ~70 m on this proof path;
- no required clue gap should exceed ~90 m without a strong macro/route landmark carrying orientation.

### Route choice
- both S00→S01 and S00→S02 remain physically usable;
- both S01→S03 and S01→S02 interpretation paths remain physically possible;
- following old S02 evidence cannot produce a topology softlock.

### Visibility
- observation anchor sees enough of Monster silhouette to support deliberate approach at roughly 55–60 m;
- observation does not expose the whole Region graph;
- brush may obscure details but must not make the Monster disappear unfairly.

### Monster fit
- ~6.6 m body proxy can reach feeding/combat/escape anchors without clipping permanent geometry;
- charge lane remains physically clear at initial proof state;
- boulder/tree geometry can genuinely intercept lines when repositioning warrants it;
- escape path to S05 remains large-body traversable.

### Tactical node readability
- every selected link is visually understandable;
- no link crosses an impossible solid obstacle;
- cover does not require invisible percentages;
- no tactical node sits inside the Monster proxy or cover geometry.

### Camera
- aerial encounter position maps to N01 without teleport;
- first-person entry retains Monster bearing/context;
- descent path avoids major solid obstruction;
- return to aerial uses current world position after outcome.

---

# 18. Future implementation / graybox tests

Before this integration can be called graybox/runtime verified, test at least:
1. S00 departure starts at the recorded Region-space context;
2. EV01 exists outside the protected camp core;
3. EV01 interpretation points generally toward S01 without exposing exact Monster coordinates;
4. S00→S02 remains legal even when S01 evidence is stronger;
5. S01 wallow evidence is physically represented at the recorded location;
6. old S02 scrape remains distinguishable from fresh S03 exit evidence;
7. player can choose S02 and later recover to S03 through canonical topology;
8. same Monster instance reaches S03 without identity reset;
9. evidence unload/reload does not duplicate logical evidence records;
10. observation anchor supports readable Monster silhouette at target distance;
11. engagement creates `enc_r01_ef02_m01_0001` from the same world actors;
12. player begins at N01 coordinate with correct terrain context;
13. Monster begins at MA01 coordinate with current anatomy/state;
14. node graph contains each node exactly once;
15. every selected link is traversable and maps correct destination terrain;
16. node-link distances remain within the recorded prototype band unless deliberately revised;
17. COV01 physically blocks relevant lines when Hunter is actually behind it;
18. brush alone never becomes solid cover;
19. initial Charge lane fits Monster proxy and has no permanent obstruction;
20. Tail Sweep/pivot clearance can be tested without environment intersection;
21. aerial→first-person transition does not relocate actor state;
22. camera descent does not clip the major boulder/tree in the intended entry path;
23. Monster escape uses the east boundary and canonical S03→S05 route;
24. escape does not spawn a fresh Monster in S05;
25. reacquisition evidence is emitted from authoritative escape/injury facts;
26. blood evidence is absent when no valid Bleeding/wound source exists;
27. CP01 reload preserves evidence/Monster route state;
28. CP03 reload preserves observation/Monster state;
29. CP04 reload preserves consumed scheduler slots/resources exactly;
30. CP05 reload does not replay Monster escape/outcome;
31. CP06 reload preserves same Monster ID/injuries/evidence;
32. no second Monster exists at the old EF02 position after escape;
33. no full Region becomes visible from normal aerial camera during the proof;
34. path-length/streaming boundaries can be measured without changing canonical topology;
35. target-phone performance remains unclaimed until direct device evidence.

---

# 19. Explicitly deferred

Not selected in this integration pass:
- final terrain mesh contours;
- production trees/rocks/water/foliage;
- exact collision hulls;
- exact Monster width/turning radius;
- final attack range meters;
- final player movement speed;
- final camera FOV/height;
- exact stealth/detection thresholds;
- complete Region 01 evidence catalog;
- full graybox for all seven sectors;
- S04/S06 encounter node maps;
- production source implementation;
- second Monster;
- phone PASS claims.

---

# 20. Verification boundary

`FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_INTEGRATION_RECORDED = YES`
`REGION01_HUNT01_TACTICAL_NODES_RECORDED = YES`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`.

The contract is design/graybox-authoring authority only.

## Exact next bounded dependency

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION`

That next pass should turn this coordinate/logic map into a build-ready primitive geometry specification for only the S00→S01→S03 pursuit corridor + EF02: route widths, grade/elevation segments, terrain patch dimensions, evidence marker volumes, cover primitive dimensions, Monster-clearance volumes, camera-clearance markers and streaming-boundary proxies. It must not expand to final art or all seven sectors.