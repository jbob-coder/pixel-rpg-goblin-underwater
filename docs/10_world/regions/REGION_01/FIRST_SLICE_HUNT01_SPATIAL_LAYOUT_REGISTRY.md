# REGION_01 — Hunt 01 Spatial Layout Registry

Status: PROTOTYPE GRAYBOX COORDINATE REGISTRY / NO RUNTIME IMPLEMENTATION
Last reconciled: 2026-09-03

Rules owner:
`FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_CONTRACT.md`.

Shared coordinate owner:
`/docs/10_world/spatial/FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`.

All coordinates use:
`space_region_01`, meters, `+X East / +Y Up / -Z North`.

All values are `PROTOTYPE TARGETS` unless explicitly stated otherwise.

---

# 1. Stable identities

| Type | ID |
|---|---|
| Scenario | `R01_HUNT01_M01_TRACK_TO_MEADOW` |
| Hunt | `hunt_r01_m01_proof_01` |
| Monster instance | `monster_r01_m01_0001` |
| Species | `species_r01_mudcrest_raker` |
| Encounter | `enc_r01_ef02_m01_0001` |
| Footprint | `R01_EF02` |

---

# 2. Player route anchors

| Anchor | Coordinate `(x,y,z) m` | Role |
|---|---:|---|
| `anchor_r01_h01_depart_s00` | `(0, 0, -45)` | proof departure after Region entry/camp orientation |
| `anchor_r01_h01_choice_s00` | `(0, 0, -65)` | S01-vs-S02 route interpretation area |
| `anchor_r01_h01_choice_s01` | `(-72, -2, -153)` | fresh S03-vs-old S02 evidence comparison |
| `anchor_r01_h01_observe_meadow_w` | `(-72, 5, -236)` | pre-engagement observation |
| `anchor_r01_h01_engage_ef02` | `(-70, 4, -238)` | maps exactly to `R01_EF02_N01` |

---

# 3. Pre-engagement evidence anchors

| Evidence ID | Coordinate | Class | Confidence | First-proof meaning |
|---|---:|---|---|---|
| `R01_H01_EV01_OUTER_PRINTS` | `(-24, 0, -68)` | DIRECTION | RECENT / USEFUL | heavy prints on outer-camp western fork, favors S01/downhill |
| `R01_H01_EV02_BANK_REEDS` | `(-70, -2, -110)` | DIRECTION | RECENT / USEFUL | body passage/reed-bank deformation leading toward ford |
| `R01_H01_EV03_FRESH_WALLOW` | `(-100, -4, -140)` | ACTIVITY | FRESH / STRONG | active wallow/water disturbance confirms recent S01 use |
| `R01_H01_EV04_WATER_EXIT` | `(-78, -3, -168)` | DIRECTION | FRESH / STRONG | fresh exit prints trend toward canonical S01→S03 route |
| `R01_H01_EV05_OLD_ROOT_SCRAPE` | `(-35, -1, -145)` | DIRECTION / ACTIVITY | OLD / WEAK | older same-instance territory sign toward S02; deliberately weaker competing clue |
| `R01_H01_EV06_FEEDING_REMAINS` | `(-59, 4, -220)` | ACTIVITY | RECENT / USEFUL | confirms feeding use near S03 west edge |
| `R01_H01_EV07_FLATTENED_GRASS_AUDIO` | `(-67, 4, -232)` | DIRECTION / AUDIO | FRESH / STRONG | flattened grass + current feeding sound supports observation approach |

Coordinates are authoring/debug truth. Normal player UI does not display them as Monster GPS.

---

# 4. Intended clue-chain distance sanity

Straight-line anchor-to-anchor planning distances on the intended proof path:

| Segment | Approx distance |
|---|---:|
| departure → EV01 | 33 m |
| EV01 → EV02 | 62 m |
| EV02 → EV03 | 43 m |
| EV03 → EV04 | 36 m |
| EV04 → EV06 | 56 m |
| EV06 → EV07 | 14 m |
| EV07 → observation | 7 m |
| observation → engagement/N01 | 3 m |

Cumulative straight anchor-chain:
~253 m.

Future actual navigable graybox target:
~260–340 m before optional wrong-route detours.

---

# 5. Monster movement / activity anchors

| Anchor | Coordinate | State/context |
|---|---:|---|
| `anchor_r01_h01_m01_outer_pass` | `(-32, 0, -73)` | recent outer S00/S01-side territory passage; outside protected camp core |
| `anchor_r01_h01_m01_wallow` | `(-100, -4, -142)` | S01 `DRINKING_WALLOWING` activity |
| `anchor_r01_h01_m01_water_exit` | `(-80, -3, -170)` | transition from water/ford toward S03 route |
| canonical `R01_S01<->R01_S03` route anchor | `(-62, 0, -188)` | shared topology route |
| `anchor_r01_h01_m01_feed` | `(-20, 4, -258)` | S03 feeding/activity position |
| `R01_EF02_MA01` | `(-18, 4, -252)` | initial combat Monster anchor |

Historical weak S02-side evidence may refer to an earlier territory movement cycle of the same instance; it does not represent a second Monster.

---

# 6. Observation / initial encounter geometry

Observation:
`anchor_r01_h01_observe_meadow_w = (-72,5,-236)`.

Monster:
`R01_EF02_MA01 = (-18,4,-252)`.

Approx observation distance:
`56.3 m`.

Entry tactical node:
`R01_EF02_N01 = (-70,4,-238)`.

Approx N01→Monster distance:
`53.9 m`.

Approx player heading toward Monster:
`75°`.

Approx Monster heading toward player:
`255°`.

These are spatial targets only. They do not define final detection or attack-range thresholds.

---

# 7. `R01_EF02` footprint planning envelope

Existing shared footprint authority:
- center `(-45, 4, -250)`;
- envelope `76 × 60 m` X×Z.

Approx footprint bounds:
- X `-83 .. -7 m`;
- Z `-280 .. -220 m`.

No invisible arena wall is created at those bounds.

---

# 8. Tactical-node coordinates

| Node | Coordinate | Primary surface | Context | Cover / route role |
|---|---:|---|---|---|
| `R01_EF02_N01` | `(-70,4,-238)` | STABLE_GROUND | BRUSH | initial engagement node; west/south return relation toward S01 |
| `R01_EF02_N02` | `(-66,5,-252)` | STABLE_GROUND | HIGH_GROUND | western boulder position; directional solid cover via COV01 |
| `R01_EF02_N03` | `(-66,4,-270)` | STABLE_GROUND | BRUSH | scarred-tree position; directional solid cover via COV02; north-route relation |
| `R01_EF02_N04` | `(-54,4,-238)` | STABLE_GROUND | none | open west-center reposition |
| `R01_EF02_N05` | `(-50,4,-252)` | STABLE_GROUND | none | open central control node |
| `R01_EF02_N06` | `(-52,4,-270)` | ROUGH_GROUND | BRUSH | rough northern edge; no automatic solid cover |
| `R01_EF02_N07` | `(-36,4,-242)` | STABLE_GROUND | none | open central/east charge-line position |
| `R01_EF02_N08` | `(-36,4,-264)` | ROUGH_GROUND | none | rough north-east flank position |
| `R01_EF02_N09` | `(-22,4,-238)` | STABLE_GROUND | none | east flank; outward relation toward S05 route |
| `R01_EF02_N10` | `(-22,5,-270)` | ROUGH_GROUND | HIGH_GROUND | north-east lip; outward relation toward northern/deep routes |

`BRUSH` remains visibility context only unless a listed physical object actually intercepts the line.

---

# 9. Tactical-node link graph

Selected undirected links and straight planning distances:

| Link | Distance |
|---|---:|
| N01 ↔ N02 | 14.6 m |
| N01 ↔ N04 | 16.0 m |
| N02 ↔ N03 | 18.0 m |
| N02 ↔ N04 | 18.5 m |
| N02 ↔ N05 | 16.0 m |
| N03 ↔ N06 | 14.0 m |
| N04 ↔ N05 | 14.6 m |
| N04 ↔ N07 | 18.4 m |
| N05 ↔ N06 | 18.1 m |
| N05 ↔ N07 | 17.2 m |
| N05 ↔ N08 | 18.4 m |
| N06 ↔ N08 | 17.1 m |
| N07 ↔ N09 | 14.6 m |
| N08 ↔ N10 | 15.3 m |

These links are graybox readability targets. They do not establish a universal combat-meter rule outside this footprint.

---

# 10. Physical cover registry

## `R01_EF02_COV01_BOULDER_W`

Center:
`(-61, 4.8, -253)`.

Prototype bounding size:
`~5 m X × 4 m Z × 3 m high`.

Role:
- real solid boulder;
- provides directional interception/cover when geometry actually blocks Monster/Hunter line;
- sits outside the initial Charge centerline but can protect a Hunter who repositions behind it.

## `R01_EF02_COV02_SCARRED_TREE_NW`

Center:
`(-61, 4, -270)`.

Prototype physical form:
- trunk diameter ~1.4 m;
- root-base envelope ~4 × 3 m;
- exposed root height ~1.2 m locally.

Role:
- solid trunk/root interception;
- surrounding vegetation may also carry BRUSH visibility context;
- Brush without trunk/root intersection remains non-solid.

---

# 11. Monster clearance registry

Monster prototype:
~6.6 m long / ~3.0 m shoulder-body height.

## `R01_EF02_CHARGE_LANE_W`

Centerline:
`R01_EF02_MA01 (-18,4,-252)`
→ approximate west-lane end `(-65,4,-242)`.

Length:
~48 m.

Prototype minimum clear width:
~9 m.

This is environment clearance, not final Charge attack range.

## `R01_EF02_MA01_PIVOT_CLEARANCE`

Center:
`(-18,4,-252)`.

Prototype permanent-solid-free radius:
~8 m.

Purpose:
- large-body rotation;
- Tail Sweep/pivot testing;
- avoid initial spawn intersection.

Not final Tail Sweep reach.

## Local body-force clearance

Target:
~12 m of open forward/side local geometry around MA01 for Shoulder Ram/reposition testing.

Exact collider width/turn radius remains OPEN.

---

# 12. Monster escape / reacquisition registry

Selected test outcome branch:
`MONSTER_ESCAPED`.

| Anchor / evidence | Coordinate | Meaning |
|---|---:|---|
| `R01_EF02_MX01_TO_S05` | `(-8,4,-258)` | east-side footprint escape boundary |
| canonical `R01_S03<->R01_S05` route | `(23,0,-255)` | topology-owned deepwood route anchor |
| `R01_H01_RE01_PASSAGE_SCuff` | `(8,2,-257)` | guaranteed physical passage/trampled-grass evidence candidate |
| `R01_H01_RE02_DEEP_ROUTE_SIGN` | `(35,0,-260)` | deeper evidence; injury-specific form only if state supports it |
| `anchor_r01_h01_m01_reacquire_s05` | `(58,-3,-268)` | same Monster staging/reacquisition position inside S05 |

Approx spatial progression:
- MA01 → escape boundary: ~12 m from the initial anchor as a geometric reference only; actual combat movement may place the Monster elsewhere before escape;
- escape boundary → canonical route anchor: ~31 m;
- route anchor → RE02: ~13 m;
- RE02 → Monster staging: ~25 m.

The outcome owner and behavior owner decide whether/when escape is legal. This registry only gives the first-proof spatial application.

---

# 13. Save checkpoint registry

| Checkpoint | Kind | Spatial application |
|---|---|---|
| `H01_CP01_S00_ROUTE_CHOICE` | WORLD_DECISION_POINT | player near `(0,0,-65)`; inspected evidence IDs + Monster route/activity persist |
| `H01_CP02_S01_POST_WALLOW` | WORLD_DECISION_POINT | player near `(-72,-2,-153)`; fresh S03 + old S02 evidence persist |
| `H01_CP03_MEADOW_OBSERVATION` | WORLD_DECISION_POINT | player `(-72,5,-236)`; Monster feeding/alert position preserved |
| `H01_CP04_EF02_COMBAT_DECISION` | COMBAT_DECISION_POINT | encounter + exact tactical nodes/scheduler/resources persist |
| `H01_CP05_POST_MONSTER_ESCAPE` | POST_COMBAT_OUTCOME | `MONSTER_ESCAPED` committed; same Monster route intent saved |
| `H01_CP06_S05_REACQUIRE` | WORLD_DECISION_POINT | same Monster/evidence IDs restored around S03→S05 pursuit |

---

# 14. Authoring-status summary

`LOCKED/CURRENT`:
- world meter convention;
- Region sector IDs and topology;
- footprint ID `R01_EF02`;
- persistent same-Monster rule.

`PROTOTYPE TARGET`:
- Hunt-01 evidence coordinates;
- Monster activity/position anchors;
- tactical-node coordinates/links;
- cover primitive dimensions;
- Charge/pivot/body-force clearance targets;
- save-checkpoint positions.

`OPEN`:
- final terrain curves;
- final collision hulls;
- final Monster width/turn radius;
- final attack ranges;
- final camera geometry;
- final production coordinates after graybox evidence;
- target-phone performance.

`REGION01_HUNT01_TACTICAL_NODES_RECORDED = YES`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`.