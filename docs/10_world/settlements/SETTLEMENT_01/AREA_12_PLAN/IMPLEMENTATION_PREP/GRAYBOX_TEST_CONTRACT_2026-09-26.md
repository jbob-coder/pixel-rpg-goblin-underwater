# Settlement 01 — Graybox Test Contract

Status: IMPLEMENTATION-PREPARED / TEST SPEC ONLY  
Created: 2026-09-26

## Goal

Define the minimum automated and physical checks required as the 12-area settlement enters runtime graybox implementation.

## Stage 1 — data-only tests

Before visible geometry moves:

### Section schema
Verify:
- exactly five stable section definitions;
- IDs S01..S05 unique;
- bounds valid;
- all required neighbors symmetric;
- every connector referenced by both owning sections;
- no duplicate SectionInstance for one section ID.

### Area ownership
Verify:
- all 12 logical areas represented;
- A04 marked shared infrastructure;
- A07/A10 pocket records map to one logical area each;
- every non-shared area has one parent section.

### Coordinate register
Verify:
- settlement envelope 60×70 m;
- every area frame inside envelope;
- every fixed building inside parent section/locked area;
- no fixed building overlaps the 8 m main spine.

## Stage 2 — shared-infrastructure graybox

Implement only:
- ground;
- A04 Main Hunter Spine;
- S01/S02/S05 primary connectors.

Verify:
- continuous walk South Gate→North Gate;
- no step/gap at Z +14 or Z -14;
- player transform continuous;
- current first-person camera/input unchanged.

## Stage 3 — central hub graybox

Add:
- A05 Central Plaza;
- West/East connectors.

Verify:
- four-way traversal;
- cross street clear;
- minimap transform continuous;
- section ownership changes do not move player.

## Stage 4 — important building grayboxes

Required doorway tests:

Smith:
- doorway open;
- adjacent walls block.

Community Hall:
- east entrance open;
- adjacent wall blocks.

Residences W01/W02:
- entrance open;
- frontage lane remains clear.

South Gatehouse:
- 8 m gate corridor clear.

Hunter Watch/Supply Cache:
- north trail corridor clear.

## Stage 5 — all-area traversal

Verify path set:

1. South outside → A01
2. A01 → A02
3. A01 → A03
4. A01 → A04
5. A04 → A05
6. A05 → A06
7. A06 → A07 pockets
8. A05 → A08
9. A08 → A09
10. A08 → A10 pockets
11. A05/A04 → A11
12. A11 → A12
13. A12 → north trail

## Collision tests

Verify:
- no visual-important doorway sealed by collision;
- settlement wall blocks except gate/intentional openings;
- prop collisions do not obstruct connector clearances;
- no duplicate floor collision causing camera/player bumps.

## Ownership tests

Verify:
- SectionInstance lifecycle does not own player transform;
- area presentation does not own persistent world state;
- minimap does not own section state;
- streaming manager cannot create duplicate section instance;
- unloading never removes current player or active interaction target.

## Streaming tests

Only after static full layout passes:

- current section remains loaded;
- direct neighbors load;
- probable next may preload;
- distant section unload delay deterministic;
- unloaded state restores without duplication;
- player never sees hard pop in required transition corridors.

## Regression gates

Must preserve:
- first-person camera tests;
- touch input tests;
- player motor tests;
- current smith doorway/interior tests;
- current Combat Bridge tests;
- AppShell boot smoke.

## Device checks

Required before calling the graybox mobile-ready:
- install/launch;
- first-person traversal through all required connectors;
- no black screen;
- no stuck collision;
- touch movement/look unchanged;
- sustained traversal FPS;
- section-transition stutter/heat observation.

## Evidence vocabulary

Use:
- DATA_CONTRACT_VERIFIED
- GRAYBOX_GEOMETRY_VERIFIED
- HEADLESS_TRAVERSAL_VERIFIED
- ANDROID_BUILD_VERIFIED
- PHONE_TRAVERSAL_VERIFIED
- PERFORMANCE_VERIFIED

Do not collapse these into one PASS label.
