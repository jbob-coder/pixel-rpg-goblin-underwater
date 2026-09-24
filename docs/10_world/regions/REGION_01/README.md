# REGION_01 — First Hunting Region

Status: PRODUCTION HUNT-01 GRAYBOX IMPLEMENTED / STATIC + HEADLESS + ANDROID BUILD VERIFIED / PHONE RETEST REQUIRED
Last reconciled: 2026-09-04

Technical package ID: `REGION_01`.

## Purpose

Own the first continuous hunting Region beyond Settlement 01 while applying shared world/combat/terrain/persistence authorities without redefining them.

Canonical sectors:
S00 Trailhead / S01 River Ford / S02 Rootwood / S03 Feeding Meadow / S04 Rocky Rise / S05 Deepwood Basin / S06 Nesting Shelf.

Topology remains owned by `REGION_TOPOLOGY.md`.

## Hunt-01 proof

Scenario `R01_HUNT01_M01_TRACK_TO_MEADOW`.
Persistent Monster `monster_r01_m01_0001`.
Encounter `enc_r01_ef02_m01_0001`.

Physical chain:
`S00 -> S01 -> S03 -> R01_EF02 -> escape via S03→S05 -> same-Monster reacquisition`.

## Design/build authorities

- `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`
- `FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_CONTRACT.md`
- `FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION.md`
- `FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md`
- `FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.md`
- `FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`
- `FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.

## Production implementation

Production project:
`../../../../game/`.

Production scene:
`../../../../game/scenes/regions/region_01_hunt01_graybox.tscn`.

Runtime manifest projection:
`../../../../game/content/regions/region_01/hunt01_graybox_build_manifest.json`.

Projection/source QA:
`../../../../tests/quality/hunt01/hunt01_production_projection_preflight.py`.

The runtime projection is derived from and must remain equal to this package's authoritative JSON manifest.

Implemented physical content:
- S00 departure/choice area;
- 13 required route slabs;
- reversible S02 wrong-route stub;
- River Ford/water/mud visuals;
- S01→S03 transition forms;
- EF02 Meadow/open core/observation shelf;
- boulder/tree cover;
- 7 evidence markers;
- 10 tactical nodes;
- solid Monster placeholder;
- Monster pivot/Charge debug clearances;
- 3-segment S03→S05 escape corridor;
- camera/stream debug volumes.

## Current dimensions

- final smoothed route target 285–315 m;
- raw current construction-anchor polyline 282.926 m;
- Ford basin 58×54 m;
- water 34×18 m at 0.15–0.55 m required depth;
- wallow 16×12 m;
- exit mud 20×12 m;
- S01→S03 Raker corridor >=9 m;
- EF02 floor 70×54 m;
- 10 tactical nodes / 14 links;
- boulder 5×4×3 m design target;
- scarred tree 1.4 m trunk / 4×3 m root base;
- Charge corridor ~48×>=9 m;
- Monster pivot radius 8 m;
- escape corridor >=9 m.

Build-only ramp midpoint `(-74.0,4.62,-237.5)` remains non-gameplay/non-persistence authority.

`H01VAL005_FINAL_SMOOTHED_ROUTE_LENGTH = NOT_EXECUTED`.

## Verification

Authoritative manifest workflow `33830978945`: SUCCESS / 13-of-13 MANIFEST_STATIC.

Production source head:
`ef0db3b4dcbea32608228f99a8fffead5ad6c858`.

Production workflow `33836865365`: SUCCESS.

`HUNT01_PRODUCTION_PROJECTION_STATIC_VERIFIED = YES / 29_OF_29`
`HUNT01_PRODUCTION_GRAYBOX_HEADLESS_VERIFIED = YES / 23_OF_23`
`HUNT01_PRODUCTION_ANDROID_BUILD_VERIFIED = YES`
`REGION01_HUNT01_PHONE_VERIFIED = NO / RETEST_REQUIRED`
`HUNT01_GRAYBOX_SCENE_STATIC_FULL_DIMENSION_GATE = NOT_EXECUTED`.

Production APK SHA-256:
`7094b3046a6a35144b3d6c80bab8b6900a1fc33d9c04cbeca9d9a80e2361e36a`.
Drive ID `150Wot1owtIGrFWUG_BmfWWlXmlMUT02F`.

## Exact next package work

External device gate:
`REGION01_HUNT01_PRODUCTION_GRAYBOX_GALAXY_A03S_RETEST`.

Independent Region implementation:
`FIRST_SLICE_REGION01_HUNT01_TRACKING_EVIDENCE_RUNTIME_IMPLEMENTATION`.

The seven evidence markers are physically placed but do not yet constitute implemented tracking semantics.
