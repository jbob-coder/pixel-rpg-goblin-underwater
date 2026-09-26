# Settlement 01 — Runtime Slice 09 Handoff

Status: READY AFTER CORE TRAVERSAL VERIFICATION / PERIMETER + PROP SOCKETS  
Created: 2026-09-26

## Objective

Add modular perimeter-wall geometry and bounded streetscape prop sockets only after all core settlement traversal slices are verified.

## Dependency

Required:
- Slices 01–08 verified;
- South→North traversal passes;
- West↔East traversal passes;
- all important building doors pass.

Do not use perimeter construction to hide unresolved layout problems.

## Modular wall set

Required module families:
- 4 m straight wall;
- 2 m straight wall;
- inside corner;
- outside corner;
- left/right gate connectors;
- watch connector;
- optional utility opening.

## Perimeter reference

Settlement envelope:
- west centerline near X `-29`
- east centerline near X `+29`
- south centerline near Z `+33`
- north centerline near Z `-35`

Gate openings:
- South: 8 m
- North: 8 m

## Allowed

- modular wall primitives/scenes;
- explicit simple per-module collision;
- wall/gate connectors;
- streetscape prop sockets;
- non-blocking decorative placeholder props;
- focused tests.

## Forbidden

- one giant settlement-wall mesh/collider;
- generated-image collision;
- blocking primary lanes with decorative props;
- final high-cost clutter;
- dynamic ambient physics clutter;
- changing building parcels.

## Prop collision classes

NONE:
- banners
- small signs
- tiny decorative bundles
- minor foliage

SIMPLE:
- carts
- large benches
- large crates
- substantial racks
- big rocks

BUILDING:
- handled by building contracts, not this slice

## Required tests

1. wall modules connect without unintended player gaps.
2. South Gate opening remains >=8 m.
3. North Gate opening remains >=8 m.
4. gate-side walls block.
5. no wall overlaps important building doorway.
6. no wall blocks world South Arrival connector.
7. no wall blocks world North Trail connector.
8. main/secondary street clearance thresholds remain valid.
9. decorative NONE-collision props create no physics owners.
10. no giant perimeter collider exists.
11. first-person regressions remain green.

## Visual bindings

Use F002 area references only for:
- wall language;
- corner landmark composition;
- prop density.

Collision comes from explicit module contracts.

## Completion evidence

Slice 09 completes when:
- full perimeter is modular;
- both gates work;
- all primary circulation remains open;
- prop sockets exist without clutter regression.

## Next slice

Slice 10 — conservative section streaming.
