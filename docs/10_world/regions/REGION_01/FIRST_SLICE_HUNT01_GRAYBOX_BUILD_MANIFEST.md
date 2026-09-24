# REGION_01 — Hunt-01 Graybox Build Manifest

Status: SELECTED ENGINE-NEUTRAL BUILD MANIFEST / NO ENGINE SCENE IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/10_world/regions/REGION_01/`

Machine-readable companion:
`FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`.

Validation owner for this manifest:
`FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.

Upstream geometry authority:
- `FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION.md`;
- `FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md`;
- `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

## Purpose

Convert the already-recorded Hunt-01 dimensions and coordinates into one stable, engine-neutral construction list for only:

`R01_S00 -> R01_S01 -> R01_S03 -> R01_EF02 -> escape stub toward R01_S05`.

Primary law:

**Every graybox object or authoring/debug volume in the first proof must have one stable build ID, one owning group, one coordinate/dimension source, one collision/navigation intent, and one validation path.**

This manifest does not select final Godot scene classes, final collision hull dimensions, final navigation-agent values, production terrain art, or final streaming meters.

---

# 1. Identity and coordinate frame

Scenario:
`R01_HUNT01_M01_TRACK_TO_MEADOW`.

Hunt:
`hunt_r01_m01_proof_01`.

Persistent Monster:
`monster_r01_m01_0001`.

Encounter:
`enc_r01_ef02_m01_0001`.

Footprint:
`R01_EF02`.

Space:
`space_region_01`.

Units:
meters.

Axes:
- +X East;
- +Y Up;
- -Z North/outbound.

Stable gameplay/evidence/node coordinates remain owned by the spatial registry. Build-manifest-only controls are explicitly marked and may never silently become gameplay anchors.

---

# 2. Engine-neutral build hierarchy

The future graybox scene/data implementation should preserve these logical groups even if the selected engine uses different node/resource names.

```text
gb_h01_root
├── gb_h01_s00
├── gb_h01_s00_s01
├── gb_h01_s01
├── gb_h01_s01_s03
├── gb_h01_ef02
├── gb_h01_escape
├── gb_h01_debug_evidence
├── gb_h01_debug_nodes
├── gb_h01_debug_monster
├── gb_h01_debug_camera
└── gb_h01_debug_stream
```

Group meanings:

| Group | Owns |
|---|---|
| `gb_h01_s00` | departure pad, route-choice clearing, S01/S02 branch mouths |
| `gb_h01_s00_s01` | required outer trail corridor to River Ford |
| `gb_h01_s01` | ford basin, water, mud, dry banks, reed context |
| `gb_h01_s01_s03` | ascent corridor + visibility breaks |
| `gb_h01_ef02` | Meadow floor, open core, observation geometry, physical cover |
| `gb_h01_escape` | same-Monster escape/S05 staging corridor stub |
| `gb_h01_debug_evidence` | seven non-authoritative evidence authoring volumes |
| `gb_h01_debug_nodes` | ten tactical-node markers + link metadata |
| `gb_h01_debug_monster` | pivot/body-force/Charge clearance volumes |
| `gb_h01_debug_camera` | first-person transition/sightline clearance volumes |
| `gb_h01_debug_stream` | three non-colliding streaming instrumentation proxies |

---

# 3. Build-entry field contract

Every machine-readable entry must expose where applicable:

- `build_id` — stable lowercase manifest identity;
- `source_geometry_id` — existing human/design geometry ID;
- `group_id`;
- `entry_kind`;
- `status`;
- `center`, `center_nominal`, `polyline_positions`, `polyline_refs`, or placement rule;
- shape/envelope type;
- dimensions/width/depth/height/radius;
- terrain tags;
- `collision_intent`;
- `navigation_intent`;
- tolerance where placement is intentionally approximate;
- relationship constraints;
- source references.

IDs are not display names.

Do not recycle a build ID for a different piece of geometry after it is consumed by tests or authored scenes.

---

# 4. Entry-kind vocabulary

Selected manifest entry kinds:

- `terrain` — physical ground/water/mud/terrain form;
- `route_corridor` — traversability/clearance relationship rather than one collider;
- `solid_cover` — real line-intercepting physical cover;
- `non_solid_context` — brush/activity/visual context without blanket collision;
- `evidence` — DEBUG/authoring placement volume;
- `node` — DEBUG tactical-node marker;
- `monster_clearance` — DEBUG volume that must remain free of forbidden permanent solids;
- `camera` — DEBUG camera/sightline clearance volume;
- `stream` — DEBUG streaming/instrumentation proxy.

No entry kind is allowed to invent gameplay math owned by another system.

---

# 5. Collision-intent vocabulary

Selected values:

- `WALKABLE_SURFACE`;
- `WALKABLE_SHALLOW_WATER`;
- `SOLID`;
- `SOLID_TERRAIN_FORM`;
- `ROUTE_BOUNDARY_ONLY`;
- `MIXED_EXPLICIT_SOLIDS_ONLY`;
- `FORBID_PERMANENT_SOLID`;
- `FORBID_FULL_COVER_SOLID`;
- `NONE`.

Important rules:
- `ROUTE_BOUNDARY_ONLY` does not mean an invisible gameplay wall;
- `FORBID_PERMANENT_SOLID` is a validation relationship, not a runtime collision object;
- DEBUG entries normally use `NONE` and cannot block gameplay;
- Brush/reeds remain non-solid unless a separate explicit trunk/root/rock primitive exists.

---

# 6. Navigation-intent vocabulary

Selected values:

- `REQUIRED_ROUTE`;
- `OPTIONAL_WRONG_ROUTE`;
- `ENCOUNTER_FLOOR`;
- `TACTICAL_NODE`;
- `MONSTER_ESCAPE_ROUTE`;
- `ROUTE_OPENING_REQUIRED`;
- `CLEARANCE_ONLY`;
- `NOT_NAVIGATION`.

These labels are authoring/validation intent. They do not lock final controller/navmesh parameters.

---

# 7. S00 physical build entries

### `gb_h01_s00_depart_pad`
Source: `H01_GB_S00_DEPART_PAD`.

- center `(0,0,-45)`;
- terrain patch `18 × 14 m`;
- local height variation `<=0.35 m`;
- `STABLE_GROUND`;
- required route.

### `gb_h01_s00_choice_clearing`
Source: `H01_GB_S00_CHOICE_CLEARING`.

- center `(0,0,-65)`;
- terrain patch `24 × 20 m`;
- `STABLE_GROUND`;
- holds readable S01/S02 route interpretation.

### `gb_h01_s00_s01_branch_mouth`

- normal Hunter width `>=7 m`;
- Raker passage width `>=9 m`;
- meaningful Monster bends `10–12 m`;
- Monster-path bend radius target `>=10 m`;
- overhead permanent-solid clearance `>=4.5 m`.

### `gb_h01_s00_s02_branch_mouth`

- optional wrong-route Hunter width `>=6 m`;
- first `20–30 m` remains physically usable;
- may not be closed because current evidence favors S01.

### `gb_h01_s00_s01_required_corridor`
Polyline references:

`choice_s00 -> EV01 -> canonical S00/S01 -> EV02 -> wallow`.

Constraints:
- Hunter clear width `>=7 m`;
- Raker clear width `>=9 m`;
- bends `10–12 m`;
- bend radius `>=10 m`;
- overhead `>=4.5 m`;
- sustained grade target `<=10%`;
- required step `<=0.25 m`.

---

# 8. S01 River Ford build entries

### `gb_h01_s01_ford_basin`

- center `(-90,-3.3,-145)`;
- working envelope `58 × 54 m`;
- vertical band about `Y -4.6 .. -1.5 m`.

### `gb_h01_s01_shallow_water`

- center `(-92,-4,-149)`;
- `34 × 18 m`;
- nominal orientation remains within `20–30°`;
- required crossing depth `0.15–0.55 m`;
- off-route visible shallow-water max target `0.65 m`;
- terrain `SHALLOW_WATER`.

### `gb_h01_s01_wallow_mud`

- center `(-100,-4,-142)`;
- `16 × 12 m`;
- depression `0.35–0.45 m`;
- terrain `MUD`.

### `gb_h01_s01_exit_mud`

- center `(-79,-3,-165)`;
- `20 × 12 m`;
- terrain `MUD`.

### `gb_h01_s01_dry_bank`

Placement is relationship-based rather than one rectangular gameplay object:
- main required-route shoulders `>=8 m` usable width;
- sustained route slope `<=12°`;
- short route slope `<=15°`;
- decorative non-route erosion may reach `25–35°`;
- no required step above `0.25 m`.

### `gb_h01_s01_reed_belt`

- water-margin bands `3–6 m` deep;
- `BRUSH` context;
- non-solid by default.

---

# 9. S01 -> S03 build entries

### `gb_h01_s01_s03_corridor`

Polyline:
`EV04 -> canonical S01/S03 -> EV06`.

Reference geometry:
- ~`58 m` 3D length;
- ~`7 m` rise;
- Hunter width `>=6 m`;
- Raker width `>=9 m`;
- bend width `10–11 m`;
- overhead `>=4.5 m`;
- sustained grade `<=14%`;
- short grade `<=16%`;
- required step `<=0.25 m`.

### `gb_h01_vis01_bank_rise`

- center `(-68,1,-190)`;
- `22 × 8 m` terrain-rise envelope;
- `2.0–2.5 m` relief;
- preserve `>=9 m` Raker opening.

### `gb_h01_vis02_meadow_edge_screen`

- center `(-62,4,-222)`;
- `28 × 10 m` visual-mass envelope;
- `2.5–4.0 m` visual height;
- preserve `>=9 m` Raker opening;
- entire envelope may not become a solid wall.

---

# 10. EF02 build entries

### `gb_h01_ef02_meadow_floor`

- center `(-45,4,-250)`;
- `70 × 54 m` working terrain inside the existing `76 × 60 m` footprint;
- primary Y band `3.5–5.5 m`;
- no invisible arena wall.

### `gb_h01_ef02_open_core`

- nominal center `(-37,4,-252)`;
- ~`48 × 34 m`;
- local relief generally `<=0.4 m`;
- `STABLE_GROUND`.

### `gb_h01_ef02_west_brush_belt`

The geometry owner gave a `10–14 m` depth but no exact center. This manifest chooses a reversible build nominal:

- nominal center `(-74,4,-250)`;
- nominal depth `12 m`;
- allowed depth `10–14 m`;
- north/south span target ~`54 m`;
- status `PROTOTYPE_NOMINAL_PLACEMENT`;
- non-solid by default.

This coordinate is a build placement, not a new gameplay/stable spatial anchor.

### `gb_h01_ef02_feed_site`

- center `(-20,4,-258)`;
- `14 × 12 m` activity/evidence patch;
- no private gameplay buff.

### `gb_h01_observation_shelf`

- center `(-72,5,-236)`;
- `16 × 12 m`;
- local relief `<=0.4 m`.

### `gb_h01_obs_to_n01_ramp`

Endpoints remain stable:
- observation `(-72,5,-236)`;
- N01 `(-70,4,-238)`.

A straight chord is too steep. This build manifest therefore records one reversible ramp-control coordinate:

`build_ctrl_h01_obs_ramp_mid = (-74.0,4.62,-237.5)`.

Using observation -> build-control -> N01 produces approximately `6.6 m` of 3D path and keeps segment grades around `15–16%`, inside the `<=18%` short-transition target.

Status of the midpoint:
`PROTOTYPE_BUILD_CONTROL_NOT_GAMEPLAY_ANCHOR`.

It must never be treated as a persistence, evidence, tactical, or Monster-authority coordinate.

Ramp:
- target length `6–7 m`;
- clear width `>=3.5 m`;
- grade `<=18%`;
- no required step >`0.25 m`.

---

# 11. Physical cover build entries

### `gb_h01_cov01_boulder`
Source: `R01_EF02_COV01_BOULDER_W`.

- center `(-61,4.8,-253)`;
- solid blockout `5 × 4 × 3 m` X×Z×H;
- yaw target `15–25°`;
- ground embed `0.5–0.8 m`;
- center tolerance X/Z `±0.75 m`, Y `±0.25 m`;
- horizontal-size tolerance `±0.5 m`.

Must:
- intercept the MA01->N02 cover line;
- remain outside the initial Charge lane;
- preserve more than ~4 m lateral safety from the lane after tolerance;
- not seal central movement.

### `gb_h01_cov02_scarred_tree`
Source: `R01_EF02_COV02_SCARRED_TREE_NW`.

- center `(-61,4,-270)`;
- trunk diameter `1.4 m`;
- trunk graybox height `>=8 m`;
- root base `4 × 3 m`;
- exposed root height up to `1.2 m`;
- X/Z tolerance `±0.5 m`.

Must preserve N03<->N06 and provide real NW physical interception.

---

# 12. Evidence build/debug entries

Exactly seven DEBUG authoring entries exist and map one-to-one to the current evidence IDs:

| Build ID | Evidence source | Position | Authoring bound |
|---|---|---:|---:|
| `gb_h01_dbg_ev01_outer_prints` | `R01_H01_EV01_OUTER_PRINTS` | `(-24,0,-68)` | ~8×3 m strip |
| `gb_h01_dbg_ev02_bank_reeds` | `R01_H01_EV02_BANK_REEDS` | `(-70,-2,-110)` | ~10×4 m strip |
| `gb_h01_dbg_ev03_fresh_wallow` | `R01_H01_EV03_FRESH_WALLOW` | `(-100,-4,-140)` | ~14×10×2 m |
| `gb_h01_dbg_ev04_water_exit` | `R01_H01_EV04_WATER_EXIT` | `(-78,-3,-168)` | ~10×4 m strip |
| `gb_h01_dbg_ev05_old_root_scrape` | `R01_H01_EV05_OLD_ROOT_SCRAPE` | `(-35,-1,-145)` | ~4×2×2.5 m |
| `gb_h01_dbg_ev06_feeding_remains` | `R01_H01_EV06_FEEDING_REMAINS` | `(-59,4,-220)` | ~8×6 m |
| `gb_h01_dbg_ev07_flattened_grass_audio` | `R01_H01_EV07_FLATTENED_GRASS_AUDIO` | `(-67,4,-232)` | ~10×8 m |

These bounds are not player detection radii and have no gameplay collision.

---

# 13. Tactical-node build/debug entries

Exactly ten DEBUG node entries map one-to-one to `R01_EF02_N01..N10`.

Each marker:
- diameter `2.0 m`;
- thickness `0.20–0.25 m`;
- local standable-pad target `>=5 m` diameter;
- permanent solid head clearance `>=3 m`.

Every recorded legal link carries:
- expected source distance;
- tolerance `±0.6 m` for machine comparison;
- Hunter corridor target `>=3.5 m`;
- `jump_or_climb_required = false`.

The 14 legal links remain exactly the current spatial-registry graph; this manifest does not create extra adjacency from visual proximity.

---

# 14. Monster-clearance build/debug entries

### `gb_h01_dbg_ma01_pivot`

- center `(-18,4,-252)`;
- radius `8 m`;
- permanent-solid vertical clear `>=4.5 m`.

### `gb_h01_dbg_ma01_body_force`

- center `(-18,4,-252)`;
- reference area `24 × 24 m`;
- prove `>=12 m` relevant directional open travel.

### `gb_h01_dbg_charge_lane_w`

- start `(-18,4,-252)`;
- end approximately `(-65,4,-242)`;
- length reference ~`48 m`;
- permanent-solid-free width `>=9 m`;
- permanent-solid vertical clear `>=4.5 m`.

None of these volumes is a hitbox or final attack range.

---

# 15. Escape-stub build entry

`gb_h01_escape_s05_corridor` follows:

`(-8,4,-258) -> (23,0,-255) -> (35,0,-260) -> (58,-3,-268)`.

Constraints:
- Raker clear width `>=9 m`;
- bends `10–12 m` where needed;
- overhead `>=4.5 m`;
- sustained grade `<=15%`;
- required step `<=0.25 m`.

Only this staging stub is in scope; full S05 remains unbuilt.

---

# 16. Camera debug entries

### `gb_h01_dbg_cam_n01_descent`

- X/Z center `(-70,-238)`;
- clear cylinder radius `4 m`;
- Y range about `4..16 m`;
- permanent solid intrusion forbidden.

### `gb_h01_dbg_cam_n01_sight_tube`

- N01 -> visible Monster upper-body reference;
- tube radius `1.5 m`;
- FULL_COVER permanent obstruction forbidden;
- not target-lock or aim assist.

---

# 17. Streaming debug entries

Exactly three non-colliding proxy volumes exist:

- S00/S01 around `(-45,-1,-82)` — ~20 m along route × 18 m lateral × 8 m vertical;
- S01/S03 around `(-62,0,-188)` — ~24 × 18 × 10 m;
- S03/S05 around `(23,0,-255)` — ~24 × 18 × 10 m.

They provide shared instrumentation/crossing references only.

They do not select production streaming/hysteresis meter values.

---

# 18. Terrain-tag binding

Allowed first-slice tags in this manifest:

`STABLE_GROUND`, `ROUGH_GROUND`, `SHALLOW_WATER`, `MUD`, `BRUSH`, `HIGH_GROUND`.

The manifest stores application only. Modifier math remains owned by the shared terrain/effect contract.

---

# 19. Build order

When a real graybox scene is authorized, construct in this order:

1. create `gb_h01_root` and group hierarchy;
2. place stable route/evidence/node/Monster anchors from current registries;
3. create S00 pads/fork;
4. create S00->S01 route corridor;
5. create S01 basin, banks, water and mud;
6. create S01->S03 ascent + visibility breaks;
7. create EF02 base floor/open core/observation shelf/ramp;
8. place boulder/tree solid cover;
9. place tactical-node DEBUG markers and verify graph;
10. place Monster-clearance DEBUG volumes;
11. place camera-clearance DEBUG volumes;
12. place escape-stub corridor;
13. place streaming DEBUG proxies;
14. bind terrain tags;
15. run static/scene validation before adding visual decoration.

Do not start with foliage/art and retrofit gameplay geometry afterward.

---

# 20. Machine-readable manifest

`FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json` is the machine-readable projection of this document.

The JSON is build/validation data, not runtime save authority.

If Markdown and JSON disagree:
1. stop;
2. reread the geometry/spatial owners;
3. correct both representations in one bounded reconciliation;
4. do not choose whichever value is more convenient for the current scene.

---

# 21. Verification boundary

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_RECORDED = YES`

Not claimed:
- engine scene created;
- graybox implemented;
- static validator implemented;
- runtime route traversal;
- Monster-fit runtime verification;
- phone verification;
- performance verification.

Exact validation rules are owned by `FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.
