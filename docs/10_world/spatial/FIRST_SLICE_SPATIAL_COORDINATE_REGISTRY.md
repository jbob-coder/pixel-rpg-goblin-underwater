# First-Slice Spatial Coordinate Registry

Status: PROTOTYPE GRAYBOX COORDINATE/DIMENSION REGISTRY / NO WORLD IMPLEMENTATION
Last reconciled: 2026-09-03

Authority:
`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT.md`.

All coordinates are in meters and are `PROTOTYPE TARGETS` unless explicitly labeled otherwise.

World frame:
- `+X East`;
- `+Y Up`;
- `-Z North / wilderness-outbound`;
- `+Z South / settlement-inbound`.

Notation:
`(x, y, z) m`.

---

# 1. Major coordinate spaces

| Space ID | Purpose | Local origin |
|---|---|---|
| `space_settlement_01` | walkable Settlement 01 | Hunter Gate inner threshold |
| `space_frontier_01` | diegetic gate/frontier transition | Hunter Gate outer/frontier start |
| `space_region_01` | continuous Region 01 wilderness | Region entry/trailhead handoff |

Transitions map stable anchors between spaces; numeric coordinates do not have to match globally.

---

# 2. Settlement 01 planning bounds

`space_settlement_01`

Prototype planning AABB:
- X: `-100 .. +100 m`;
- primary walkable Y: `0 .. +14 m`;
- Z: `-10 .. +250 m`.

Characteristic plan size:
`200 m × 260 m`.

This is a planning envelope, not a rectangular invisible wall.

Natural cliff/river/walls/buildings shape the actual playable boundary later.

## Settlement anchors

| Stable anchor / area | Prototype coordinate | Prototype dimension / note |
|---|---:|---|
| `anchor_set01_hunter_gate_inner` | `(0, 0, 0)` | Settlement origin / return threshold |
| `anchor_set01_hunter_gate_outer` | `(0, 0, -10)` | maps to Frontier gate origin |
| Hunter Gate opening | centered near `(0,0,-5)` | 7 m clear width; ~12 m passage length |
| Processing Yard center | `(-34, 1, 22)` | ~28 × 24 m open working yard |
| Smith/Workshop center | `(-22, 3, 42)` | ~16 × 22 m footprint |
| `anchor_set01_smith_entry` | `(-16, 3, 34)` | primary first-slice workshop approach |
| `anchor_set01_smith_workbench` | `(-22, 3, 40)` | maps to `interact_settlement01_smith_weapon_workbench` |
| Storage/Loadout center | `(24, 4, 38)` | ~16 × 20 m footprint |
| `anchor_set01_storage_entry` | `(15, 4, 32)` | service-loop entry target |
| Hunter Lodge center | `(34, 7, 105)` | ~28 × 32 m main mass |
| `anchor_set01_hunter_lodge_entry` | `(18, 7, 86)` | repeated-use approach anchor |
| Market/Civic plaza center | `(-34, 7, 105)` | ~28 × 24 m plaza |
| Recovery/Inn center | `(20, 12, 175)` | ~18 × 24 m main mass |
| Upper Residential zone center | `(-22, 12, 185)` | district planning anchor, not one building |
| `anchor_set01_arrival_gate` | `(0, 7, 242)` | civilian/long-distance arrival side |

## Settlement route dimensional targets

| Route class | Width |
|---|---:|
| Main Hunter Spine | ~8 m clear |
| Secondary street | ~5 m |
| Alley/service lane | ~3 m |

## Gate -> Smith planning sanity

Straight-line distance:
- Gate inner `(0,0,0)` to Smith entry `(-16,3,34)` ≈ `37.7 m`;
- Gate inner to Smith workbench `(-22,3,40)` ≈ `45.7 m`.

These values support a compact path candidate but do **not** verify the <=25-second walking target.

Future graybox must measure the actual navigable route.

---

# 3. Settlement built-scale reference

| Element | Status | Reference |
|---|---|---:|
| Hunter Base 01 height | `LOCKED/CURRENT` | `1.75 m` |
| Common exterior door | `PROTOTYPE RANGE` | 2.1–2.5 m high × 1.0–1.4 m clear width |
| Smith service/material door | `PROTOTYPE TARGET` | ~3.0 m high × 2.4 m clear width |
| Smith main working clear height | `PROTOTYPE TARGET` | ~5.5 m |
| Smith footprint | `PROTOTYPE TARGET` | 16 × 22 m |
| Processing yard | `PROTOTYPE TARGET` | 28 × 24 m |
| Storage/Loadout | `PROTOTYPE TARGET` | 16 × 20 m |
| Hunter Lodge | `PROTOTYPE TARGET` | 28 × 32 m |
| Market/Civic plaza | `PROTOTYPE TARGET` | 28 × 24 m |
| Recovery/Inn | `PROTOTYPE TARGET` | 18 × 24 m |
| Defensive wall baseline | `PROTOTYPE TARGET` | ~7 m high |
| Hunter Gate clear width | `PROTOTYPE TARGET` | ~7 m |

Final collision/interior dimensions remain open until graybox/DCC/device evidence.

---

# 4. Frontier transition registry

`space_frontier_01`

Prototype transition size:
- centerline length ~80 m;
- normal clear width ~12 m;
- minimum choke ~8 m;
- watch/supply widening up to ~18 m;
- total elevation change ~-4 m toward Region 01.

## Frontier anchors

| Anchor | Coordinate | Purpose |
|---|---:|---|
| `anchor_frontier_gate_outer` | `(0, 0, 0)` | maps from Settlement Hunter Gate outer |
| `anchor_frontier_gate_pass_exit` | `(0, -1, -14)` | gate tunnel/bridge/pass exit |
| `anchor_frontier_watch_supply` | `(6, -2, -42)` | watch/supply post / loading-cover candidate |
| `anchor_frontier_region_handoff` | `(0, -4, -80)` | maps to Region 01 entry |

Transition mapping:
```text
space_settlement_01 / anchor_set01_hunter_gate_outer
-> space_frontier_01 / anchor_frontier_gate_outer

space_frontier_01 / anchor_frontier_region_handoff
-> space_region_01 / anchor_r01_entry
```

No teleport is implied. The player traverses physical frontier geometry while technical area state changes underneath.

---

# 5. Region 01 sector registry

`space_region_01`

Origin:
`anchor_r01_entry = (0, 0, 0) m`.

All sector planning spans are characteristic X×Z envelopes, not visible/hard boxes.

| Sector | Center `(x,y,z)` m | X×Z span | Approx planning X range | Approx planning Z range |
|---|---:|---:|---:|---:|
| `R01_S00` Trailhead/Camp | `(0, 0, -35)` | 90 × 80 m | -45..45 | -75..5 |
| `R01_S01` River Ford | `(-90, -3, -130)` | 120 × 110 m | -150..-30 | -185..-75 |
| `R01_S02` Rootwood | `(75, 2, -135)` | 125 × 115 m | 12.5..137.5 | -192.5..-77.5 |
| `R01_S03` Feeding Meadow | `(-35, 4, -245)` | 135 × 120 m | -102.5..32.5 | -305..-185 |
| `R01_S04` Rocky Rise | `(-45, 22, -365)` | 120 × 110 m | -105..15 | -420..-310 |
| `R01_S05` Deepwood Basin | `(80, -4, -265)` | 135 × 125 m | 12.5..147.5 | -327.5..-202.5 |
| `R01_S06` Nesting Shelf | `(70, 18, -395)` | 115 × 105 m | 12.5..127.5 | -447.5..-342.5 |

Region entry to deepest sector-center straight-line distance:
`anchor_r01_entry -> R01_S06 center ≈ 401.6 m`.

The deepest envelope extends the overall planning footprint to roughly the mid-400-meter range North of entry.

---

# 6. Canonical Region route anchors

Each anchor below is a planning waypoint along one **existing canonical physical connection**. It is not a teleport/sector-select node.

| Canonical link | Planning route anchor `(x,y,z)` m |
|---|---:|
| `R01_S00 <-> R01_S01` | `(-45, -1, -82)` |
| `R01_S00 <-> R01_S02` | `(38, 1, -85)` |
| `R01_S01 <-> R01_S02` | `(-8, -1, -132)` |
| `R01_S01 <-> R01_S03` | `(-62, 0, -188)` |
| `R01_S02 <-> R01_S03` | `(22, 3, -190)` |
| `R01_S02 <-> R01_S05` | `(78, -1, -200)` |
| `R01_S03 <-> R01_S04` | `(-40, 12, -305)` |
| `R01_S03 <-> R01_S05` | `(23, 0, -255)` |
| `R01_S04 <-> R01_S05` | `(18, 8, -315)` |
| `R01_S04 <-> R01_S06` | `(13, 20, -380)` |
| `R01_S05 <-> R01_S06` | `(75, 7, -330)` |

No additional connection is canonical.

If later terrain curves a route substantially, its stable sector link remains the same and this planning coordinate may move through a recorded spatial revision.

---

# 7. Canonical sector-center distance sanity table

These values are planning evidence only; they are not player path lengths.

| Link | Center distance |
|---|---:|
| S00–S01 | ~130.9 m |
| S00–S02 | ~125.0 m |
| S01–S02 | ~165.2 m |
| S01–S03 | ~127.7 m |
| S02–S03 | ~155.6 m |
| S02–S05 | ~130.2 m |
| S03–S04 | ~121.8 m |
| S03–S05 | ~117.0 m |
| S04–S05 | ~162.2 m |
| S04–S06 | ~118.9 m |
| S05–S06 | ~132.2 m |

This keeps the prototype graph dense enough for meaningful traversal without kilometer-scale emptiness while respecting Region 01's 100–180 m characteristic sector direction.

---

# 8. Region encounter-footprint registry

The existing footprint IDs remain authoritative.

Envelopes are X×Z planning extents around the listed center. They are not sealed arena walls.

| Footprint | Source context | Center `(x,y,z)` m | Envelope | Tactical-node target |
|---|---|---:|---:|---:|
| `R01_EF01` Riverbank Ford | `R01_S01` | `(-92, -4, -145)` | 52 × 46 m | ~8 |
| `R01_EF02` Meadow Edge | `R01_S03` | `(-45, 4, -250)` | 76 × 60 m | ~10 |
| `R01_EF03` Root/Boulder Hollow | S02 / S02→S05 route context | `(43, 0, -205)` | 58 × 52 m | ~8 |
| `R01_EF04` Deep Nest Shelf | `R01_S06` | `(70, 19, -405)` | 68 × 56 m | ~10 |

All four fit the existing broad 30–90 m normal first-slice encounter-footprint guidance.

Exact tactical node coordinates, cover shapes and Monster anchor positions are deferred to the Region 01 tracking-to-encounter graybox integration pass.

---

# 9. Creature and combat clearance reference

| Reference | Status | Dimension |
|---|---|---:|
| Hunter Base 01 | `LOCKED/CURRENT` | 1.75 m tall |
| Mudcrest Raker length | `PROTOTYPE TARGET` | ~6.6 m |
| Mudcrest Raker shoulder/body height | `PROTOTYPE TARGET` | ~3.0 m |
| Normal large-monster encounter envelope | `PROTOTYPE RANGE` | ~30–90 m across |
| First-slice encounter-node count | `PROTOTYPE RANGE` | usually ~6–12 meaningful positions |

Monster exact width, turning radius and collision decomposition remain open and must be measured from the future Monster blockout rather than guessed here.

---

# 10. Persistence coordinate examples

The Persistence owner stores space + local position instead of one giant global position.

Examples only:

```text
spatial_context_id = space_settlement_01
position_m = (-22, 3, 40)
near_anchor = anchor_set01_smith_workbench

spatial_context_id = space_region_01
sector_or_local_area_id = R01_S01
position_m = (-92, -4, -145)
near_footprint = R01_EF01
```

The same numeric coordinate in two different spaces is not the same physical place.

---

# 11. Verification labels

`LOCKED/CURRENT`:
- one world unit = one meter;
- Hunter Base 01 height 1.75 m;
- existing Region 01 sector IDs/topology;
- existing encounter-footprint IDs;
- existing Monster 01 prototype identity/body plan relationship.

`PROTOTYPE TARGET`:
- world-cardinal axis vocabulary until mapped/validated in real engine scene tooling;
- major local-space origins;
- Settlement extent/anchors/building dimensions;
- Frontier dimensions/anchors;
- Region sector centers/spans/route-anchor coordinates;
- encounter centers/envelopes;
- Monster 01 numeric length/height as current prototype body target.

`OPEN`:
- final player/Monster colliders;
- final path curves/slopes;
- exact sector polygons and streaming grace width;
- exact tactical-node coordinates;
- final camera geometry;
- production-final coordinates after graybox evidence;
- target-phone performance.

No coordinate in this registry is runtime/phone verified.