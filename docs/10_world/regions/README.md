# Hunting Region Packages

Each hunting region is a bounded physical ecosystem composed of continuous streamed sectors. A region folder applies world/mechanical/art/performance authorities to one specific place.

## Required package files

Recommended minimum:
- `README.md` — local front door/status/decisions/file map;
- `REGION_TOPOLOGY.md` — sector graph, routes, landmarks, traversal and danger progression;
- `TRACKING_AND_ESCAPE.md` — evidence chains, monster movement/retreat and persistent-hunt continuity;
- `TERRAIN_ECOLOGY_MUTATION.md` — terrain tags, habitat roles, population/elemental/mutation pressures;
- `ENCOUNTER_FOOTPRINTS.md` — local first-person battlefield anchors and tactical requirements;
- `STREAMING_AND_PERFORMANCE.md` — adjacency/preload/culling/update tiers/budgets;
- `VISUAL_REFERENCE_PLAN.md` — reference PNG/asset requirements for environment production;
- `ACCEPTANCE_CHECKLIST.md` — what must be proven before the region expands.

## Region-package invariants

A region package must preserve:
- continuous ordinary sector traversal whenever technically possible;
- persistent monster identity across sectors/encounters;
- no full-region gameplay camera;
- no impossible teleporting of tracks/monster injuries/state;
- deterministic behavior rules rather than AI;
- shared terrain/effect/crystal/mutation systems;
- local encounter footprints derived from real region geometry;
- bounded current/adjacent-sector runtime cost;
- Android profiling before final budgets are called verified.

## Stable identifiers

Use:
- folder: `REGION_01`;
- content ID later: `region_01` or a stable semantic ID once naming is locked;
- sector IDs: `R01_S00`, `R01_S01`, etc. during planning;
- encounter footprint IDs: `R01_EF01`, etc.

Do not encode mutable display names into persistent identity.

## Current package

`REGION_01/` is the active first hunting-region design package.
