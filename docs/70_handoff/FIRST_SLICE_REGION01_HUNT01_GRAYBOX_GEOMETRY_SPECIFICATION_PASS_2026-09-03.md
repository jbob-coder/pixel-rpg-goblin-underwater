# First-Slice Region 01 Hunt-01 Graybox Geometry Specification Pass — 2026-09-03

Status: BOUNDED GEOMETRY/DIMENSION PASS COMPLETE / NO ENGINE GRAYBOX IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION`

## Purpose

Continue the game as the main objective by converting the already-recorded Hunt-01 coordinates into measurable primitive blockout dimensions, while also saving the user-requested project status report and repairing stale navigation/governance statements discovered during the pass.

## Source baseline

Verified branch before publication:
`worldlife-reference-docs`

Baseline head:
`eebea9a1b4aa9601ce932c19f5513021d3bdc1ea`.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- root README;
- docs placement/governance guides;
- current Build Readiness Matrix;
- Region 01 README;
- Hunt-01 integration contract + spatial registry;
- Region topology/tracking/terrain/encounter/streaming/acceptance;
- Monster 01 anatomy/attack constraints;
- Persistence state ownership.

## New geometry authorities

Rules:
`docs/10_world/regions/REGION_01/FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION.md`.

Concrete geometry registry:
`docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md`.

Project status snapshot:
`docs/00_project/PROJECT_STATUS_REPORT_2026-09-03.md`.

The status report is explicitly non-operating snapshot evidence. EVOLVE remains the exact current-action authority.

## Route measurement

The required Hunt-01 centerline through the selected route-control anchors measures approximately `279 m` before smoothing the observation-to-N01 transition.

Selected actual graybox navigable target after path smoothing/curvature:
`285–315 m`.

This remains inside the previously recorded broad `260–340 m` target.

## Grade / step guardrails

Selected prototype geometry targets:
- normal required-route sustained grade <=15%;
- short transition <=18%;
- no required vertical step/ledge >0.25 m;
- normal cross-slope <=8%.

The direct observation->N01 chord is too steep. The geometry specification therefore requires a 6–7 m curved/ramped descent, >=3.5 m wide, arriving at the existing N01 coordinate without moving the anchor.

## S00 geometry

Selected:
- departure pad 18×14 m;
- route-choice clearing 24×20 m;
- S01 branch normal surface >=7 m;
- large-body corridor >=9 m;
- bend widening 10–12 m;
- S02 wrong-route mouth remains >=6 m clear for at least the first 20–30 m;
- Monster-route overhead >=4.5 m;
- prototype Monster-route bend radius >=10 m.

## S01 River Ford geometry

Selected first-proof tracking micro-zone:
- ford working envelope 58×54 m;
- shallow-water patch 34×18 m;
- required water depth 0.15–0.55 m;
- wallow mud 16×12 m with ~0.35–0.45 m depression;
- exit mud 20×12 m;
- required dry-bank usable shoulders >=8 m;
- required bank sustained slope <=12° / short <=15°;
- reeds/brush 3–6 m deep but non-solid by default.

No swimming or random slip mechanic is introduced.

## Evidence geometry

Seven evidence authoring volumes now have concrete footprint/volume targets.

They are debug/placement bounds only and do not become player detection radii or GPS.

## S01->S03 route

Selected:
- ~58 m straight route through water-exit/canonical/feeding controls;
- ~7 m total rise;
- hunter surface >=6 m;
- Raker permanent-solid corridor >=9 m;
- bend width 10–11 m;
- overhead >=4.5 m;
- sustained grade <=14%;
- short <=16%.

Two physical visibility breaks are specified so the River Ford cannot see directly to the feeding Monster.

## EF02 Meadow geometry

Selected:
- 70×54 m working meadow floor inside existing 76×60 m footprint;
- playable Y band ~3.5–5.5 m;
- open core ~48×34 m;
- west brush belt 10–14 m deep;
- feeding disturbance 14×12 m;
- observation shelf 16×12 m;
- 6–7 m observation->N01 ramp.

## Tactical-node authoring

N01–N10 retain current world coordinates.

Debug markers:
- 2 m diameter;
- 0.20–0.25 m thick;
- local standable pad target >=5 m diameter where geometry allows;
- legal link corridors >=3.5 m clear;
- immediate vertical solid clearance >=3 m.

These values are authoring aids, not Hunter collider dimensions.

## Physical cover

Boulder:
- 5×4×3 m;
- yaw ~15–25°;
- ground embedding ~0.5–0.8 m;
- placement tolerance ±0.75 m X/Z;
- must preserve intended MA01->N02 interception and remain outside the initial Charge lane.

Scarred tree:
- trunk 1.4 m diameter;
- >=8 m graybox height;
- root base 4×3 m;
- exposed root height <=1.2 m;
- preserve N03<->N06 route.

## Monster clearance

Selected environment test volumes:
- Charge lane ~48 m long / >=9 m solid-free width / >=4.5 m solid-free height;
- MA01 pivot cylinder radius 8 m / 4.5 m solid-free height;
- local body-force reference 24×24 m to prove ~12 m relevant directional travel;
- escape/S05 staging corridor >=9 m wide, <=15% sustained grade, >=4.5 m overhead.

These are environment clearances, not final attack ranges/colliders.

## Camera / streaming debug geometry

Camera:
- N01 descent-clear cylinder radius 4 m, approximately Y4..16;
- initial sight tube radius 1.5 m;
- no full-cover permanent object may block initial silhouette.

Streaming proxies:
- S00/S01 ~20×18×8 m;
- S01/S03 ~24×18×10 m;
- S03/S05 ~24×18×10 m.

Streaming proxies are debug-only and have no gameplay collision. Exact runtime grace/hysteresis meter values remain engine/device-open.

## Geometry validation recorded

Future build must check:
- coordinate integrity;
- 285–315 m route target;
- grade/step limits;
- Hunter/Monster route widths;
- water depth;
- evidence physical fit;
- tactical-node/link clearance;
- real cover lines;
- Charge/pivot/body-force clearance;
- camera clearance;
- physical escape continuity;
- no-softlock;
- no false runtime/phone PASS.

## Governance fixes in this pass

Two stale statements were identified for repair:
1. Region 01 Acceptance Checklist still ended with `IMPLEMENTATION = NOT AUTHORIZED`, conflicting with current EVOLVE Stage-1 authorization.
2. `docs/00_project/README.md` still described an older pre-build Stage-1 readiness state.

Correct current distinction:
- `IMPLEMENTATION_AUTHORIZED = YES` for the current Stage-1 probe/bounded work;
- `PRODUCTION_DOMAIN_IMPLEMENTATION = BLOCKED_BY_ENGINE_PHONE_GATE`;
- final engine/phone performance remains unverified.

## Verification boundary

Design/geometry review only.

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION_RECORDED = YES`
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_REGISTRY_RECORDED = YES`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`.

No Android/probe source is changed by this pass, so no Android workflow is expected solely from these documentation/geometry authorities.

## Exact next bounded action

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_AND_VALIDATION_SPECIFICATION`

Purpose:
translate the now-dimensioned geometry into an engine-neutral build/scene manifest and explicit validation-data/test ownership, without final art or false production/runtime claims while the engine-phone/domain gate remains unresolved.
