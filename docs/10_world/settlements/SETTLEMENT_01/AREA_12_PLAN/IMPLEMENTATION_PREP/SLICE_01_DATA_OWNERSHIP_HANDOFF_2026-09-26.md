# Settlement 01 — Runtime Slice 01 Handoff

Status: READY TO IMPLEMENT / DATA-OWNERSHIP ONLY  
Created: 2026-09-26

## Objective

Implement issue #3's SectionDefinition / SectionInstance foundation without moving visible world geometry.

## Runtime scope

Allowed:
- data/config classes or resources;
- stable section IDs;
- section bounds;
- neighbor graph;
- connector records;
- validation helpers;
- focused tests.

Forbidden in Slice 01:
- move current settlement objects;
- replace current world builders;
- enable section unloading;
- enable aggressive preloading;
- change first-person controls/camera;
- change combat;
- lock final building art.

## Required section IDs

- SET01_S01
- SET01_S02
- SET01_S03
- SET01_S04
- SET01_S05

## Required connectors

- SET01_CON_S01_S02_MAIN
- SET01_CON_S02_S05_MAIN
- SET01_CON_S02_S03_WEST
- SET01_CON_S02_S04_EAST
- SET01_CON_WORLD_SOUTH_ARRIVAL
- SET01_CON_WORLD_NORTH_TRAIL

## Required tests

1. exactly five section definitions;
2. IDs unique;
3. bounds match coordinate register;
4. neighbor relation symmetric;
5. connector relation symmetric;
6. no duplicate SectionInstance per ID;
7. shared A04 does not become section 6;
8. every non-shared area maps to one section;
9. no player/camera/combat owner introduced;
10. current AppShell/first-person runtime remains unchanged.

## Source inputs

- SECTION_RUNTIME_CONTRACT_2026-09-26.md
- AREA_12_COORDINATE_REGISTER_2026-09-26.md
- CONNECTOR_REGISTER_2026-09-26.md
- GRAYBOX_TEST_CONTRACT_2026-09-26.md
- FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md

## Completion evidence

Slice 01 is complete only when:
- runtime data structures exist;
- focused tests pass;
- existing Pixel RPG regression suite remains green;
- exact source SHA/build evidence recorded;
- no visible world movement occurred.

## Next slice after success

Slice 02:
Area 04 Main Central Spine scaffold + coordinate-origin proof.

Do not begin Slice 02 until Slice 01 source/tests are verified.
