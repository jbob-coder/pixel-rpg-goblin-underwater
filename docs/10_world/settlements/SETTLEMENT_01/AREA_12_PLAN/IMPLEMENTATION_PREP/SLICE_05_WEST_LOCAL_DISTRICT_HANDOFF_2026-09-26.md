# Settlement 01 — Runtime Slice 05 Handoff

Status: READY AFTER SLICE 04 VERIFICATION / WEST LOCAL DISTRICT GRAYBOX  
Created: 2026-09-26

## Objective

Graybox the west local district using the locked Community Hall, two Residence Type A parcels, and the West Frontage Lane.

Areas:
- Area 06 — Community Hall / Civic Core
- Area 07 — West Residential Cluster

Parent section:
`SET01_S03`

## Dependencies

Required:
- Slice 01 section data verified;
- Slice 02 spine verified;
- Slice 03 plaza/cross verified;
- Slice 04 smith migration verified.

## Locked geometry

Community Hall:
- center `(-24.5, 0)`
- footprint `8×10 m`
- bounds X `-28.5..-20.5`
- Z `-5..+5`
- primary facade EAST.

Residence W01:
- center `(-24.5,+10)`
- footprint `7×5.5 m`

Residence W02:
- center `(-24.5,-10)`
- footprint `7×5.5 m`

West Frontage Lane:
- center X `-16.25`
- width `4.5 m`
- Z `-13..+13`

## Allowed runtime work

- Community Hall primitive graybox;
- W01/W02 primitive grayboxes;
- real doorway openings;
- segmented collision;
- interior floor primitives;
- stable entrance/interior/NPC anchor nodes or data;
- West Frontage Lane scaffold;
- connector records/tests.

## Forbidden

- final facade/roof art;
- NPC durable relationship implementation;
- full schedules;
- final furniture clutter;
- final residence variants;
- streaming;
- moving S02/S04 geometry.

## Required anchors

Community Hall:
- HallEntrance
- HallCenter
- KeeperWork
- Notice
- EventGather
- Social anchors

Residences:
- Entrance
- Exit
- ResidentIdle
- ResidentRest
- Yard
- InteriorCenter

## Required tests

1. all three buildings inside S03 bounds.
2. no footprint overlap.
3. Community Hall remains between W01/W02.
4. every important doorway is physically open.
5. adjacent wall pieces block.
6. no monolithic sealed collision.
7. West Frontage Lane remains clear.
8. door-to-lane frontage clearance preserved.
9. Area 05 west connector aligns.
10. no NPC durable-state owner introduced.
11. current first-person controls/camera unchanged.
12. existing regressions remain green.

## Visual bindings

Area 06:
`AREA_06_COMMUNITY_HALL_CIVIC_CORE_F002_LOCKED.png`

Area 07:
`AREA_07_WEST_RESIDENTIAL_CLUSTER_F002_LOCKED.png`

Use visuals for silhouette/composition only.

## Completion evidence

Slice 05 completes when:
- S03 graybox traverses correctly;
- three important buildings have real doorway/collision contracts;
- frontage lane/connectors pass;
- existing regressions pass;
- exact SHA/build evidence recorded.

## Next slice

Slice 06 — South Arrival / Areas 01–03.
