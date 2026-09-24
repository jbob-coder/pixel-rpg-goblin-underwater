# REGION_01 — Hunt-01 Graybox Geometry Registry

Status: PROTOTYPE PRIMITIVE / VOLUME REGISTRY / NO ENGINE IMPLEMENTATION
Last reconciled: 2026-09-03

Rules owner:
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION.md`.

Spatial source:
`FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

Space:
`space_region_01`.

Units:
meters.

Axes:
`+X East / +Y Up / -Z North`.

All entries are `PROTOTYPE BUILD TARGETS` unless explicitly marked `DEBUG ONLY`.

---

# 1. Route centerline registry

Required proof polyline:

| Order | ID/reference | Coordinate `(x,y,z) m` | Approx segment from previous | Anchor-derived grade |
|---:|---|---:|---:|---:|
| 1 | `anchor_r01_h01_depart_s00` | `(0,0,-45)` | — | — |
| 2 | `anchor_r01_h01_choice_s00` | `(0,0,-65)` | 20.0 m | 0% |
| 3 | `R01_H01_EV01_OUTER_PRINTS` | `(-24,0,-68)` | 24.2 m | 0% |
| 4 | canonical `S00<->S01` | `(-45,-1,-82)` | 25.3 m | ~4.0% |
| 5 | `R01_H01_EV02_BANK_REEDS` | `(-70,-2,-110)` | 37.5 m | ~2.7% |
| 6 | `anchor_r01_h01_m01_wallow` | `(-100,-4,-142)` | 43.9 m | ~4.6% |
| 7 | `anchor_r01_h01_choice_s01` | `(-72,-2,-153)` | 30.1 m | ~6.6% |
| 8 | `R01_H01_EV04_WATER_EXIT` | `(-78,-3,-168)` | 16.2 m | ~6.2% |
| 9 | canonical `S01<->S03` | `(-62,0,-188)` | 25.8 m | ~11.7% |
| 10 | `R01_H01_EV06_FEEDING_REMAINS` | `(-59,4,-220)` | 32.4 m | ~12.4% |
| 11 | `R01_H01_EV07_FLATTENED_GRASS_AUDIO` | `(-67,4,-232)` | 14.4 m | 0% |
| 12 | `anchor_r01_h01_observe_meadow_w` | `(-72,5,-236)` | 6.5 m | ~15.6% chord grade |
| 13 | `R01_EF02_N01` | `(-70,4,-238)` | 3.0 m direct chord | direct chord too steep; build 6–7 m ramp |

Polyline before final observation-ramp smoothing:
~`279 m`.

Selected smoothed navigable target:
`285–315 m`.

---

# 2. S00 ground primitives

| Geometry ID | Anchor/center | Primitive/envelope | Dimensions | Notes |
|---|---:|---|---:|---|
| `H01_GB_S00_DEPART_PAD` | `(0,0,-45)` | ground pad | `18×14 m` | level/stable orientation space; relief <=0.35 m |
| `H01_GB_S00_CHOICE_CLEARING` | `(0,0,-65)` | clearing | `24×20 m` | readable S01/S02 fork |
| `H01_GB_S00_S01_BRANCH_MOUTH` | west of choice | corridor | `7 m` walk surface / `9 m` large-body clear | widen 10–12 m at Monster bends |
| `H01_GB_S00_S02_BRANCH_MOUTH` | east of choice | corridor stub | `>=6 m` hunter clear | first 20–30 m remains physically usable |

S00->S01 Monster-path overhead clear target:
`>=4.5 m`.

Prototype Monster-route bend radius:
`>=10 m`.

---

# 3. S01 River Ford geometry

| Geometry ID | Center | Type | Prototype dimension / range |
|---|---:|---|---|
| `H01_GB_S01_FORD_BASIN` | `(-90,-3.3,-145)` | terrain working envelope | `58×54 m`, Y about `-4.6..-1.5` |
| `H01_GB_S01_SHALLOW_WATER_MAIN` | `(-92,-4,-149)` | shallow-water patch | `34×18 m`, ~20–30° orientation |
| `H01_GB_S01_WALLOW_MUD` | `(-100,-4,-142)` | mud/wallow depression | `16×12 m`, depression `0.35–0.45 m` |
| `H01_GB_S01_EXIT_MUD` | `(-79,-3,-165)` | mud patch | `20×12 m` |
| `H01_GB_S01_REQUIRED_DRY_BANK` | route shoulders | stable/rough shelves | `>=8 m` usable width where required |
| `H01_GB_S01_REED_BELT` | water margins | brush/visual band | `3–6 m` depth, non-solid by default |

Required-route shallow-water depth:
`0.15–0.55 m`.

Off-route visible shallow maximum target:
~`0.65 m`.

Required bank slope:
- sustained <=12°;
- short <=15°;
- decorative non-route erosion may reach ~25–35°.

Required-route step/ledge:
`<=0.25 m`.

---

# 4. Evidence authoring volumes — DEBUG ONLY

These are placement/inspection authoring bounds, not player detection radii.

| Evidence | Coordinate | Debug volume/patch |
|---|---:|---:|
| `R01_H01_EV01_OUTER_PRINTS` | `(-24,0,-68)` | ~`8×3 m` route strip |
| `R01_H01_EV02_BANK_REEDS` | `(-70,-2,-110)` | ~`10×4 m` disturbance strip |
| `R01_H01_EV03_FRESH_WALLOW` | `(-100,-4,-140)` | ~`14×10×2 m` placement volume |
| `R01_H01_EV04_WATER_EXIT` | `(-78,-3,-168)` | ~`10×4 m` track strip |
| `R01_H01_EV05_OLD_ROOT_SCRAPE` | `(-35,-1,-145)` | ~`4×2×2.5 m` inspection box |
| `R01_H01_EV06_FEEDING_REMAINS` | `(-59,4,-220)` | ~`8×6 m` patch |
| `R01_H01_EV07_FLATTENED_GRASS_AUDIO` | `(-67,4,-232)` | ~`10×8 m` patch |

---

# 5. S01 -> S03 route geometry

Route controls:
`(-78,-3,-168) -> (-62,0,-188) -> (-59,4,-220)`.

Straight 3D length:
~`58 m`.

Vertical rise:
~`7 m`.

Build targets:
- hunter walking surface `>=6 m`;
- Raker permanent-solid-free corridor `>=9 m`;
- bend width `10–11 m` at canonical route anchor;
- permanent-solid overhead clear `>=4.5 m`;
- sustained grade `<=14%`;
- short transition `<=16%`;
- step <=0.25 m.

---

# 6. Visibility-break geometry

| Geometry ID | Center | Envelope | Height/relief | Route opening |
|---|---:|---:|---:|---:|
| `H01_GB_VIS01_BANK_RISE` | `(-68,1,-190)` | `22×8 m` | ~`2.0–2.5 m` relief | >=9 m Monster route |
| `H01_GB_VIS02_MEADOW_EDGE_SCREEN` | `(-62,4,-222)` | `28×10 m` | ~`2.5–4 m` visual mass | >=9 m Monster route |

These are terrain/vegetation composition targets, not invisible walls.

---

# 7. EF02 meadow base geometry

Existing footprint:
center `(-45,4,-250)`, envelope `76×60 m`.

| Geometry ID | Center | Type | Dimensions / band |
|---|---:|---|---|
| `H01_GB_EF02_MEADOW_FLOOR` | `(-45,4,-250)` | terrain patch | `70×54 m`; Y `3.5..5.5` |
| `H01_GB_EF02_OPEN_CORE` | approx `(-37,4,-252)` | low-relief open floor | ~`48×34 m`; relief generally <=0.4 m |
| `H01_GB_EF02_WEST_BRUSH_BELT` | west edge | brush/soft visibility band | `10–14 m` depth |
| `H01_GB_EF02_FEED_SITE` | `(-20,4,-258)` | evidence/activity patch | `14×12 m` |
| `H01_GB_OBSERVATION_SHELF_W` | `(-72,5,-236)` | usable terrain shelf | `16×12 m`; relief <=0.4 m |
| `H01_GB_OBS_TO_N01_RAMP` | obs -> N01 | curved ramp | `6–7 m` path × >=`3.5 m` width; <=18% grade |

No invisible wall is placed at the EF02 envelope.

---

# 8. Tactical-node marker registry — DEBUG ONLY

Node coordinates remain owned by `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

At every N01–N10:
- marker disc/cylinder diameter `2.0 m`;
- marker thickness `0.20–0.25 m`;
- target local standable pad `>=5 m` diameter where local cover does not intentionally constrain it;
- vertical permanent-solid clearance `>=3 m` above local Hunter ground.

Every recorded legal node link:
- target clear hunter corridor `>=3.5 m`;
- no required jump/climb;
- no unrecorded invisible blocker.

---

# 9. Physical cover primitives

## `R01_EF02_COV01_BOULDER_W`
Anchor/center:
`(-61,4.8,-253)`.

Primitive:
approx convex/box blockout.

Nominal size:
`5.0 X × 4.0 Z × 3.0 H m`.

Yaw target:
`15–25°`.

Ground embedding:
`~0.5–0.8 m` allowed.

Placement tolerance:
- X/Z ±0.75 m;
- Y ±0.25 m;
- horizontal size ±0.5 m.

Required relationships:
- intercept MA01->N02 cover line;
- remain outside Charge lane;
- preserve >~4 m lateral safety from lane edge after tolerance;
- not seal central movement.

## `R01_EF02_COV02_SCARRED_TREE_NW`
Base anchor:
`(-61,4,-270)`.

Primitive:
- trunk cylinder diameter `1.4 m`;
- graybox trunk height `>=8 m`;
- root base `4×3 m`;
- exposed root height up to `1.2 m`.

Placement tolerance:
X/Z ±0.5 m.

Required relationships:
- provide real NW solid interception;
- preserve N03<->N06 link;
- Brush around it remains non-solid unless an actual root/trunk collider is present.

---

# 10. Monster clearance volumes — DEBUG ONLY

Monster current body reference:
~`6.6 m` long / ~`3.0 m` shoulder-body height.

## `R01_EF02_MA01_PIVOT_CLEARANCE`
Center:
`(-18,4,-252)`.

Clear cylinder:
- radius `8 m`;
- permanent-solid vertical clear `4.5 m`.

## `R01_EF02_MA01_BODY_FORCE_REFERENCE`
Center:
`(-18,4,-252)`.

Debug reference:
`24×24 m` local square/area.

Purpose:
show that at least ~12 m forward/side open travel exists in relevant directions.

Not a hitbox.

## `R01_EF02_CHARGE_LANE_W`
Centerline:
`(-18,4,-252)` -> approx `(-65,4,-242)`.

Length:
~`48 m`.

Permanent-solid-free width:
`>=9 m`.

Vertical permanent-solid clear:
`>=4.5 m`.

Not final attack range.

---

# 11. Escape / S05 staging corridor

| Control | Coordinate | Notes |
|---|---:|---|
| `R01_EF02_MX01_TO_S05` | `(-8,4,-258)` | EF02 escape boundary |
| canonical S03<->S05 | `(23,0,-255)` | route anchor |
| `R01_H01_RE02_DEEP_ROUTE_SIGN` | `(35,0,-260)` | deeper evidence/control |
| `anchor_r01_h01_m01_reacquire_s05` | `(58,-3,-268)` | same-Monster staging |

Corridor build targets:
- permanent-solid-free width >=9 m;
- bend width 10–12 m where required;
- vertical permanent-solid clear >=4.5 m;
- sustained grade <=15%;
- step <=0.25 m.

Anchor-derived grade checks:
- escape -> canonical route ~12.8%;
- canonical -> RE02 0%;
- RE02 -> staging ~12.3%.

Only the Hunt-01 staging stub is in scope; full S05 remains unbuilt.

---

# 12. Camera clearance volumes — DEBUG ONLY

## `H01_GB_CAM_N01_DESCENT_CLEAR`
XZ center:
`(-70,-238)`.

Cylinder:
- radius `4 m`;
- vertical range roughly Y `4..16 m`.

No permanent solid intrusion.

## `H01_GB_CAM_N01_SIGHT_TUBE`
From Hunter eye reference at N01 toward visible Monster upper-body silhouette.

Tube radius:
`1.5 m`.

No full-cover permanent object may block the initial sight tube.

Not target lock / aim assist.

---

# 13. Streaming/grace debug proxies — DEBUG ONLY

These are instrumentation placement references, not final runtime streaming boundaries.

| Proxy ID | Center | Debug dimensions |
|---|---:|---:|
| `H01_GB_STREAM_S00_S01_PROXY` | `(-45,-1,-82)` | ~`20×18×8 m` |
| `H01_GB_STREAM_S01_S03_PROXY` | `(-62,0,-188)` | ~`24×18×10 m` |
| `H01_GB_STREAM_S03_S05_PROXY` | `(23,0,-255)` | ~`24×18×10 m` |

No gameplay collision.

Final preload/unload/hysteresis meter values remain OPEN until engine/device evidence.

---

# 14. Terrain tag geometry mapping

| Geometry | First-slice primary/context |
|---|---|
| S00 departure/fork | `STABLE_GROUND` |
| S00->S01 trail | primarily `STABLE_GROUND`; optional `BRUSH` outside clear corridor |
| S01 shallow channel | `SHALLOW_WATER` |
| S01 wallow / exit mud | `MUD` |
| S01 dry banks | `STABLE_GROUND` or `ROUGH_GROUND` based on primitive surface |
| S01->S03 route | `STABLE_GROUND` / `ROUGH_GROUND` + Brush around visual screens |
| EF02 open core | `STABLE_GROUND` |
| EF02 rough north/east positions | `ROUGH_GROUND` where node registry says so |
| EF02 brush edge | `BRUSH` context only |
| EF02 elevated lips | `HIGH_GROUND` only where node registry says so |

No new terrain formula lives in this registry.

---

# 15. Geometry validation targets

A later build manifest/test layer must be able to verify:
- route target 285–315 m after smoothing;
- sustained grade <=15%, short <=18%;
- step <=0.25 m;
- required hunter widths;
- required Raker widths >=9 m;
- Monster-route overhead >=4.5 m;
- shallow water 0.15–0.55 m on required crossing;
- evidence anchors physically fit their patches;
- N01–N10 remain within EF02 and linked corridors remain open;
- boulder/tree cover relationships are physically real;
- boulder/tree do not intersect initial Charge lane;
- pivot cylinder remains solid-free;
- escape corridor remains physically connected;
- camera descent/sight volumes remain clear;
- streaming proxies have no gameplay collision;
- no S00/S02 route-mouth softlock;
- no phone/runtime PASS is inferred from geometry validation alone.

---

# 16. Status

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_REGISTRY_RECORDED = YES`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`.
