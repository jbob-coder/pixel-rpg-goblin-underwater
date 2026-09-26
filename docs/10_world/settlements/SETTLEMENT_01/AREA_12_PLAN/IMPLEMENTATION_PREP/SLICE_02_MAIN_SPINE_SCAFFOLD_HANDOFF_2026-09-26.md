# Settlement 01 — Runtime Slice 02 Handoff

Status: READY AFTER SLICE 01 VERIFICATION / MAIN-SPINE SCAFFOLD ONLY  
Created: 2026-09-26

## Objective

Implement the Area 04 Main Central Spine scaffold and prove the settlement coordinate frame without migrating buildings or services.

This handoff is documentation only until Slice 01 is actually implemented and verified.

## Dependency

Required predecessor:

`SLICE_01_DATA_OWNERSHIP_HANDOFF_2026-09-26.md`

Do not begin Slice 02 runtime changes until Slice 01 has:
- SectionDefinition / SectionInstance source;
- connector records;
- focused tests;
- existing regressions green;
- exact source SHA/evidence.

## Runtime scope

Allowed:
- shared Main Spine data/config;
- primitive road/floor scaffold;
- coordinate-origin/reference marker;
- connector trigger/reference records;
- minimap transform proof;
- non-authoritative graybox visual markers;
- focused tests.

Forbidden:
- moving current smith;
- moving current gate;
- moving current market;
- moving current generic buildings;
- migrating NPCs;
- changing combat;
- changing first-person input/camera;
- enabling section unloading;
- final art/material lock.

## Shared infrastructure ID

`SET01_A04_MAIN_CENTRAL_SPINE`

This is shared infrastructure, not a sixth section.

## Geometry authority

Main Spine:
- center X: `0`
- width: `8 m`
- X bounds: `-4..+4`
- south extent: `Z +33`
- north extent: `Z -35`

Total planned corridor length:
- about `68 m`

Central crossing:
- Z `0`

South Gate opening:
- centered X `0`, Z `+33`

North Gate opening:
- centered X `0`, Z `-35`

## Section ownership relationship

The spine physically crosses:
- S01;
- S02;
- S05.

No section duplicates the physical road/collision.

Recommended owner concept:
- shared settlement infrastructure owner;
- section records reference corridor segments.

## Initial graybox representation

Safe first primitive:
- one long plane/box or equivalent non-duplicated shared road presentation;
- floor physics remains owned by the chosen settlement ground/floor owner;
- road presentation must not create a competing floor collider unless explicitly required.

If a temporary collision proxy is necessary:
- exactly one authoritative floor/corridor collider;
- no overlap with duplicated section road collision.

## Coordinate-origin proof

Add a test/debug-only reference to prove:
- X 0 maps to road center;
- Z 0 maps to Central Plaza crossing;
- positive Z is south;
- negative Z is north;
- no mirror/rotation error exists.

Do not ship debug labels as gameplay UI.

## Required connectors touched

- `SET01_CON_S01_S02_MAIN`
- `SET01_CON_S02_S05_MAIN`
- `SET01_CON_WORLD_SOUTH_ARRIVAL`
- `SET01_CON_WORLD_NORTH_TRAIL`

Slice 02 does not activate streaming behavior.

## Required tests

1. Area 04 is not represented as Section 6.
2. road center X is 0.
3. road width is 8 m.
4. south endpoint is Z +33.
5. north endpoint is Z -35.
6. road crosses S01/S02/S05 definitions without duplicated geometry ownership.
7. S01↔S02 connector intersects the road.
8. S02↔S05 connector intersects the road.
9. Central Plaza crossing reference resolves to Z 0.
10. current player/camera/combat owners remain unchanged.
11. current AppShell boot remains unchanged.
12. no current world object transform is modified by Slice 02.

## Visual binding

Current art-reference target:
`AREA_04_MAIN_CENTRAL_SPINE_ROAD_F002_LOCKED.png`

Use it only for:
- visual road rhythm;
- lantern cadence;
- roadside readability.

Do not derive:
- collision;
- object positions;
- final material dimensions

from the image.

Binding authority:
`F002_TO_GRAYBOX_BINDING_REGISTER_2026-09-26.md`

## Completion evidence

Slice 02 completes only when:
- shared spine scaffold/data exists;
- all focused tests pass;
- no current-world object moved;
- existing first-person regressions pass;
- canonical CI/build evidence is recorded if runtime source changed.

## Next slice

After Slice 02 success:

Slice 03 — Central Market Plaza scaffold.

It should prove:
- 8 m Main Spine;
- 5 m Cross Street;
- four perimeter stall sockets;
- minimap transform continuity.

Do not begin Slice 03 before Slice 02 is verified.
