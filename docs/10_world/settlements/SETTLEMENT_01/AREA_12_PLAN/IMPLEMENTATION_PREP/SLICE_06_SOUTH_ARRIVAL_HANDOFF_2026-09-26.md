# Settlement 01 — Runtime Slice 06 Handoff

Status: READY AFTER SLICE 05 VERIFICATION / SOUTH ARRIVAL GRAYBOX  
Created: 2026-09-26

## Objective

Graybox the complete South Arrival sequence without breaking the Main Spine:

- Area 01 South Arrival Gate
- Area 02 Gate Barracks & Security
- Area 03 Caravan Yard / Visitor Staging

Parent:
`SET01_S01`

## Locked geometry

South Gate:
- center `(0,+33)`
- clear opening `8 m`

South Gatehouse W:
- center `(-8,+29)`
- footprint `8×7 m`

South Watch E:
- center `(+8,+29)`
- footprint `6×6 m`

Arrival Guard/Barracks:
- center `(-20,+23)`
- footprint `7×6 m`

Arrival Storage/Logistics:
- center `(+20,+23)`
- footprint `7×6 m`

Main Spine:
- X `-4..+4`
- must remain clear.

## Allowed

- primitive gate/wall modules;
- gatehouse/watch/barracks/storage grayboxes;
- Area 02/03 yard primitives;
- stable anchors;
- arrival connectors;
- simple cart/rack/trough placeholder boxes;
- focused tests.

## Forbidden

- final gate art;
- dynamic gate-state gameplay;
- civilian economy/service implementation;
- final NPC schedules;
- final prop clutter;
- moving Central Plaza.

## Required connectors

- world South Arrival;
- Area 01→Area 04/Main Spine;
- Area 02 security connections;
- Area 03 logistics connections;
- S01↔S02 main connector.

## Required tests

1. South Gate opening >=8 m clear.
2. gatehouse/watch collision blocks outside opening.
3. Main Spine remains clear.
4. all four fixed S01 building parcels match blueprint.
5. Area 02 yard remains open.
6. Area 03 cart/logistics route remains open.
7. no building overlaps Main Spine.
8. no giant wall collider seals the gate.
9. South Gate path reaches Plaza scaffold.
10. current first-person controls/camera unchanged.
11. no arrival/service durable owner added.
12. regression stack remains green.

## Visual bindings

- Area 01 F002
- Area 02 F002
- Area 03 F002

Images guide visual hierarchy only.

## Completion evidence

Slice 06 completes when:
- South arrival traversal is physically continuous;
- gate/building/yard anchors exist;
- collision tests pass;
- no current gameplay owner regresses.

## Next slice

Slice 07 — East support/frontage + Area 10.
