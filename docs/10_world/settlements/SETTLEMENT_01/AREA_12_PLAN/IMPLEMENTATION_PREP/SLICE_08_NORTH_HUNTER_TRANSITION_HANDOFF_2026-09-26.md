# Settlement 01 — Runtime Slice 08 Handoff

Status: READY AFTER SLICE 07 VERIFICATION / NORTH HUNTER TRANSITION  
Created: 2026-09-26

## Objective

Graybox the final settlement-to-wilderness transition:

- Area 11 North Hunter Staging Ground
- Area 12 North Watch Gate & Trail Exit

Parent:
`SET01_S05`

## Locked geometry

Area 11 frame:
- X `-30..+30`
- Z `-23..-14`

Main Spine:
- X `-4..+4`
- must remain clear.

Hunter Watch:
- center `(-19,-27)`
- footprint `7×7 m`

Supply Cache:
- center `(+19,-27)`
- footprint `7×6 m`

North Gate:
- center `(0,-35)`
- clear opening `8 m`

Trail:
- continues north beyond Z `-36`.

## Allowed

- Area 11 open staging-yard scaffold;
- bounty/prep/supply anchors;
- Hunter Watch graybox;
- Supply Cache graybox;
- North Gate/wall modules;
- continuous trail connector;
- warning/return anchors;
- focused tests.

## Forbidden

- monster/combat integration;
- hunt teleportation;
- full bounty system;
- final hunter equipment art;
- final gate-state logic;
- final wilderness streaming;
- moving Region-01 tactical coordinates here.

## Required anchors

Area 11:
- BountyBoard
- Prep 01/02
- Supply
- HunterIdle
- connector A12

Area 12:
- NorthGateCenter
- Warden
- Watch
- Warning
- TrailConnector
- Return
- connector A11

## Required tests

1. Main Spine remains clear through Area 11.
2. Hunter Watch parcel correct.
3. Supply Cache parcel correct.
4. North Gate center correct.
5. North Gate opening >=8 m.
6. gate-side collision blocks outside opening.
7. Area 11→Area 12 route continuous.
8. trail floor continues beyond gate.
9. no South-Gate/civilian props or logic imported.
10. no combat/tactical teleport owner introduced.
11. current first-person controls/camera unchanged.
12. existing combat-domain regressions remain green.

## Visual bindings

- Area 11 F002
- Area 12 F002

## Completion evidence

Slice 08 completes when:
- staging→gate→trail traversal is continuous;
- building/gate/anchor tests pass;
- no combat/persistence ownership regression exists.

## Next slice

Slice 09 — perimeter walls and streetscape props.
