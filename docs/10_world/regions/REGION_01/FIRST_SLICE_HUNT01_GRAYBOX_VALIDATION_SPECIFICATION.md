# REGION_01 — Hunt-01 Graybox Validation Specification

Status: SELECTED FIRST-SLICE STATIC/SCENE VALIDATION CONTRACT / VALIDATOR NOT YET IMPLEMENTED
Last reconciled: 2026-09-03

Technical owner: `docs/10_world/regions/REGION_01/`.

Inputs:
- `FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.md`;
- `FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`;
- `FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION.md`;
- `FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md`;
- `FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

Quality/tooling owner for future executable validator:
`docs/60_quality/` + future test/tool source.

## Purpose

Define exactly what must be checked before the Hunt-01 graybox can be called correctly built.

Primary law:

**A scene looking plausible is not evidence that its coordinates, widths, grades, cover, terrain tags, tactical links, Monster clearances, camera clearances or debug-only boundaries match the authoritative build manifest.**

The validation system is intentionally layered so checks that can run without an engine do not wait for phone/runtime work.

---

# 1. Validation levels

### `MANIFEST_STATIC`
Runs against the JSON/Markdown data only.

Can verify:
- schema/identity;
- duplicate IDs;
- group references;
- stable coordinate copies;
- allowed terrain tags;
- tactical-node coordinate/link math;
- debug/non-authority classifications;
- presence of required entry families;
- consistency of build-control status.

### `SCENE_STATIC_FUTURE`
Runs once a graybox scene/data export exists.

Can verify:
- scene positions/dimensions versus manifest;
- measured corridor widths;
- slopes/steps;
- water depth;
- route length;
- cover placement;
- Monster/camera clearance intersections;
- debug volumes non-colliding;
- tactical-link corridor openness.

### `RUNTIME_FUTURE`
Runs once real traversal/encounter runtime exists.

Can verify:
- actual Hunter traversal;
- actual Monster fit/movement;
- aerial→first-person continuity;
- persistent Monster crossing/escape;
- no softlock;
- streaming behavior.

### `PHONE_FUTURE`
Direct Galaxy A03s/selected target-device evidence only.

Can verify:
- frame pacing;
- thermal behavior;
- memory;
- input/camera usability;
- real target-device regressions.

No lower validation level may be reported as a higher one.

---

# 2. Severity

`ERROR`
- violates an authoritative invariant;
- invalidates build correctness;
- must block promotion.

`WARNING`
- prototype tolerance/open question that needs review but does not necessarily invalidate the current data projection.

`INFO`
- measured/reported value for audit.

The first executable static validator should exit non-zero when any `ERROR` exists.

---

# 3. Expected validator input

Primary machine input:
`FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`.

Future scene validator additionally consumes an engine-neutral exported scene measurement snapshot containing at least:
- build ID;
- space ID;
- actual world/local transform;
- measured bounds;
- collision category;
- navigation category;
- terrain tags;
- parent/group;
- relevant overlap/intersection facts.

Presentation names are never used as identity.

---

# 4. Expected validator output

Human-readable console/report header:

```text
HUNT01_GRAYBOX_VALIDATION
manifest_schema=uhr_hunt01_graybox_build_manifest@1
scenario=R01_HUNT01_M01_TRACK_TO_MEADOW
checks_total=<N>
errors=<N>
warnings=<N>
result=PASS|FAIL
```

Each finding should expose:

```text
RULE_ID | SEVERITY | BUILD_ID/REFERENCE | measured | expected | explanation
```

Future machine output should also be available as structured JSON for CI artifacts.

---

# 5. Rule registry

## `H01VAL001` — schema and proof identity
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Require:
- schema `uhr_hunt01_graybox_build_manifest`;
- schema version `1`;
- scenario `R01_HUNT01_M01_TRACK_TO_MEADOW`;
- Hunt `hunt_r01_m01_proof_01`;
- Monster `monster_r01_m01_0001`;
- encounter `enc_r01_ef02_m01_0001`;
- footprint `R01_EF02`.

## `H01VAL002` — unique build IDs
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Every `build_id` must be unique.

## `H01VAL003` — valid group references
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Every non-root group references an existing parent. Every entry references an existing build group.

No parent cycle is allowed.

## `H01VAL004` — coordinate frame consistency
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Require:
- `space_region_01`;
- meters;
- +X East;
- +Y Up;
- -Z North/outbound.

## `H01VAL005` — required-route length
Levels: `MANIFEST_STATIC`, `SCENE_STATIC_FUTURE`.
Severity: ERROR when measured scene is outside target without recorded approved correction.

Target:
`285–315 m` navigable S00-departure→N01 path after smoothing.

The pre-ramp route-control polyline reference remains approximately `279 m`.

The validator must distinguish planning polyline length from actual navigable scene path length.

## `H01VAL006` — route grade limits
Levels: manifest relationships + future scene measurement.
Severity: ERROR.

General Hunt-01 required route:
- normal sustained `<=15%`;
- short `<=18%`.

Narrower section-specific limits remain authoritative where specified:
- S00→S01 required corridor `<=10%`;
- S01→S03 sustained `<=14%`, short `<=16%`.

## `H01VAL007` — required step/ledge limit
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

No required route or tactical link may contain an unavoidable step above `0.25 m` unless a later controller-evidence pass explicitly changes the threshold.

## `H01VAL008` — Hunter corridor widths
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Check section-specific minimum clear widths:
- S00→S01 primary Hunter route `>=7 m`;
- S02 wrong-route mouth `>=6 m` for first 20–30 m;
- S01→S03 Hunter surface `>=6 m`;
- observation ramp `>=3.5 m`;
- tactical links `>=3.5 m`.

## `H01VAL009` — Raker corridor widths
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Every path that the same Raker is required to traverse must provide `>=9 m` permanent-solid-free width, with documented `10–12 m`/`10–11 m` bend widening where required.

## `H01VAL010` — Monster-route overhead
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Required Raker paths and clearance volumes must preserve at least `4.5 m` permanent-solid vertical clearance where specified.

## `H01VAL011` — River Ford water depth
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Required Hunt-01 crossing depth:
`0.15–0.55 m`.

Off-route visible shallow-water target must not require swimming; current maximum target approximately `0.65 m`.

## `H01VAL012` — evidence anchor containment
Levels: `MANIFEST_STATIC`, `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Each of the seven evidence coordinates must exist and lie inside its corresponding authoring patch/volume.

Evidence authoring bounds are not player detection radii.

## `H01VAL013` — EF02 tactical-node bounds
Levels: `MANIFEST_STATIC`, `SCENE_STATIC_FUTURE`.
Severity: ERROR.

All N01–N10 coordinates must remain inside the existing EF02 approximate envelope:
- X `-83..-7`;
- Z `-280..-220`.

No node may be silently relocated outside the footprint merely to simplify scene construction.

## `H01VAL014` — tactical-link distances
Level: `MANIFEST_STATIC` and later scene coordinates.
Severity: ERROR.

Recompute the 14 recorded link distances from node coordinates.

Each must remain within `±0.6 m` of its recorded planning distance unless an approved geometry correction updates both owner and manifest.

No extra adjacency is inferred merely because nodes appear close.

## `H01VAL015` — tactical-link corridor openness
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Every recorded legal link requires:
- `>=3.5 m` Hunter clearance;
- no mandatory jump/climb;
- no unrecorded invisible blocker.

## `H01VAL016` — physical-cover placement/tolerance
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Boulder must remain within:
- center X/Z ±0.75 m;
- Y ±0.25 m;
- horizontal size ±0.5 m;
- yaw target 15–25°.

Scarred tree X/Z tolerance:
`±0.5 m`.

Relationships are more important than cosmetic exactness.

## `H01VAL017` — Charge lane solid-free
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

`R01_EF02_CHARGE_LANE_W` must preserve:
- ~48 m reference centerline;
- `>=9 m` permanent-solid-free width;
- `>=4.5 m` permanent-solid vertical clearance.

The boulder/tree may not intrude into the required initial lane.

## `H01VAL018` — MA01 pivot clearance
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Within radius `8 m` around `(-18,4,-252)`, no permanent boulder/tree/root solid may intersect the required clearance volume at proof start.

Vertical clear target:
`>=4.5 m`.

## `H01VAL019` — N01 camera descent clearance
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Clear cylinder:
- center X/Z `(-70,-238)`;
- radius `4 m`;
- vertical band approximately Y `4..16 m`.

Permanent-solid intrusion is forbidden.

## `H01VAL020` — initial sight tube
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

A radius `1.5 m` sight tube from N01 toward the visible Monster upper-body reference cannot be blocked by FULL_COVER permanent geometry at encounter creation.

## `H01VAL021` — streaming proxies are non-colliding
Levels: `MANIFEST_STATIC`, `SCENE_STATIC_FUTURE`.
Severity: ERROR.

All three `stream` entries must have no gameplay collision and cannot act as visible/invisible barriers.

## `H01VAL022` — no invisible EF02 arena wall
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

The 76×60 m footprint envelope is a planning/encounter boundary, not a collider.

No generic perimeter wall may be generated from it.

## `H01VAL023` — escape corridor same-Monster fit
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Escape path:
`(-8,4,-258) -> (23,0,-255) -> (35,0,-260) -> (58,-3,-268)`.

Must preserve:
- `>=9 m` Raker width;
- `>=4.5 m` overhead;
- sustained grade `<=15%`;
- step `<=0.25 m`.

## `H01VAL024` — terrain tag references
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Allowed in this first manifest:
- `STABLE_GROUND`;
- `ROUGH_GROUND`;
- `SHALLOW_WATER`;
- `MUD`;
- `BRUSH`;
- `HIGH_GROUND`.

Unknown private terrain formulas/tags fail validation unless added through the owning terrain system first.

## `H01VAL025` — DEBUG entries cannot own gameplay collision/state
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Entries with `status = DEBUG_ONLY`:
- cannot mutate gameplay state;
- cannot define player detection radii;
- cannot add blocking collision unless a future explicit debug-testing mode separately requests it;
- cannot become save authority.

## `H01VAL026` — stable coordinate copies match source registry
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Coordinates copied for evidence, N01–N10, MA01, escape route and canonical route anchors must exactly match the current owning spatial registry values.

## `H01VAL027` — nominal build controls remain non-authoritative
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Current build-only controls include:
- observation-ramp midpoint `(-74.0,4.62,-237.5)`;
- nominal west-brush-belt placement `(-74,4,-250)`.

They must remain marked as build/placement controls and may not appear in persistence/evidence/Monster/tactical stable-ID registries unless a later bounded pass intentionally promotes them.

## `H01VAL028` — wrong S02 route remains physically open
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

The first `20–30 m` of the S02 branch remains at least `6 m` Hunter-clear and is not disabled because it represents a weaker inference.

## `H01VAL029` — visibility breaks preserve Monster opening
Level: `SCENE_STATIC_FUTURE`.
Severity: ERROR.

Both visibility-break constructions preserve `>=9 m` required Raker passage.

The Meadow screen may not become one giant solid collider.

## `H01VAL030` — required manifest families present
Level: `MANIFEST_STATIC`.
Severity: ERROR.

Require at least:
- S00 physical entries;
- S00→S01 corridor;
- S01 Ford entries;
- S01→S03 corridor/visibility entries;
- EF02 terrain/cover;
- 7 evidence debug entries;
- 10 tactical-node debug entries;
- 14 tactical links;
- Monster pivot/body-force/Charge entries;
- escape corridor;
- 2 camera entries;
- 3 stream proxies.

---

# 6. Static validator minimum implementation target

The next executable validator should, at minimum, implement all `MANIFEST_STATIC` rules:

`H01VAL001, 002, 003, 004, 012, 013, 014, 021, 024, 025, 026, 027, 030`.

It should additionally report informational calculations for:
- tactical-link distances;
- observation-ramp build-control path length and segment grades;
- entry counts by group/kind;
- route target metadata.

It must not report scene/runtime checks as PASS when no scene exists.

---

# 7. Future scene-measurement interface

When the engine graybox exists, export/collect scene facts by stable `build_id` rather than scene display name.

Required future measurement categories:
- actual center/transform;
- actual bounds;
- terrain elevation samples;
- route/path sample length;
- width samples;
- slope/step samples;
- collision overlap classes;
- camera-clearance overlap;
- Monster-clearance overlap;
- terrain tags;
- tactical-link traversability;
- proxy collision state.

This keeps scene verification engine-adaptable while preserving one project-level contract.

---

# 8. Promotion gates

The Hunt-01 package may use:

`BUILD_MANIFEST_RECORDED`
when manifest Markdown + JSON + this validation contract exist and are reconciled.

It may use:

`MANIFEST_STATIC_VERIFIED`
only after an executable validator runs and passes the static rule subset.

It may use:

`GRAYBOX_IMPLEMENTED`
only after a real engine graybox exists.

It may use:

`GRAYBOX_SCENE_STATIC_VERIFIED`
only after actual scene measurement passes applicable scene rules.

It may use:

`RUNTIME_VERIFIED`
only after real gameplay traversal/encounter execution.

It may use:

`PHONE_RUNTIME_VERIFIED` / `PERFORMANCE_VERIFIED`
only with direct target-device evidence.

---

# 9. Current status

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION_RECORDED = YES`
`HUNT01_GRAYBOX_MANIFEST_STATIC_VALIDATOR_IMPLEMENTED = NO`
`HUNT01_GRAYBOX_MANIFEST_STATIC_VERIFIED = NO`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`.

Exact next implementation-safe quality piece after this pass:
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_STATIC_VALIDATOR_IMPLEMENTATION`.
