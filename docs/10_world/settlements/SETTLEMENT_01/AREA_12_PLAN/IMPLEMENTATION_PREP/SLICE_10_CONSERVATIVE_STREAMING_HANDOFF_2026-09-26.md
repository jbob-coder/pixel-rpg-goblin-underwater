# Settlement 01 — Runtime Slice 10 Handoff

Status: READY ONLY AFTER STATIC FULL-LAYOUT VERIFICATION / STREAMING LAST  
Created: 2026-09-26

## Objective

Enable conservative section lifecycle/streaming only after the complete static five-section settlement passes traversal, collision, ownership and device-baseline checks.

This slice must not be used to fix performance before static correctness exists.

## Dependencies

Required:
- Slices 01–09 verified;
- full static Settlement 01 traversal works;
- no duplicate state owner;
- important interiors work;
- baseline Android build/device performance measured.

## Sections

- SET01_S01
- SET01_S02
- SET01_S03
- SET01_S04
- SET01_S05

Shared Area 04 remains infrastructure, not Section 6.

## Lifecycle states

Use the SectionInstance contract:
- UNLOADED
- PRELOADING
- LOADED_INACTIVE
- ACTIVE
- UNLOAD_PENDING

## Conservative initial policy

First implementation:
- current player section ACTIVE;
- directly adjacent section(s) loaded/preloaded;
- avoid unloading geometry visible from current sightlines;
- avoid rapid churn around S02, which has four neighbors;
- important interiors may remain loaded with parent section initially.

## State law

Unloading visual/runtime section nodes must not unload authoritative durable state.

NPC:
- durable/abstract state persists;
- visual node may unload;
- schedule can advance abstractly;
- no duplicate NPC on reload.

World:
- stable IDs persist;
- persistent object/door/service states restore from authoritative owner.

Player:
- transform never owned by section lifecycle.

Combat:
- section unload must not silently destroy active combat state.

## Connector triggers

Connectors may provide preload hints.

They do not teleport the player.

Required:
- stable connector ID;
- source section;
- target section;
- trigger/preload bounds;
- compatibility version.

## Visibility

Do not unload:
- geometry currently visible through a connector;
- current important interior while player occupies it;
- combat-critical world pieces if an active encounter depends on them.

## Required tests

1. exactly one SectionInstance per section ID.
2. current section cannot become UNLOADED.
3. adjacent preload does not duplicate geometry/state.
4. player transform remains continuous across connector.
5. shared Area 04 is not duplicated per section.
6. NPC durable state survives unload/reload.
7. persistent world flags survive unload/reload.
8. minimap mapping remains stable.
9. no visible connector gap/step.
10. active combat ownership is not destroyed by lifecycle change.
11. no section churn loop around S02.
12. static full-layout mode remains available for regression/debug.

## Device evidence

Measure:
- memory before/after;
- load/unload spike;
- frame-time stutter;
- sustained FPS;
- heat;
- lifecycle/background recovery.

Streaming is accepted only if it provides measurable benefit without visible traversal/state regression.

## Completion evidence

Slice 10 completes when:
- lifecycle tests pass;
- static-regression mode remains green;
- device evidence demonstrates acceptable transitions;
- no ownership/persistence duplication occurs.

## After Slice 10

Then, and only then, deepen:
- NPC schedules;
- persistence;
- inventory/crafting;
- current-world combat adapter;
- broader settlement content.

Streaming is infrastructure, not a content shortcut.
