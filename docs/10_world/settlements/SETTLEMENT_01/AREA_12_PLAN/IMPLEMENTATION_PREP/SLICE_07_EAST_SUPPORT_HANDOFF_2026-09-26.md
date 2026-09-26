# Settlement 01 — Runtime Slice 07 Handoff

Status: READY AFTER SLICE 06 VERIFICATION / EAST SUPPORT GRAYBOX  
Created: 2026-09-26

## Objective

Complete the non-smith portions of S04 around the already-adapted Area 09 Smith:

- Area 08 East Work Frontage / Worker Passage
- Area 10 Storage / Workshop Yard

Parent:
`SET01_S04`

## Locked geometry

East Frontage Lane:
- center X `+16.25`
- width `4.5 m`
- Z `-13..+13`

Area 08:
- X `+14..+20.5`
- Z `-14..+14`
- no permanent residence buildings.

Work Canopy:
- center `(+24.5,-9.5)`
- footprint `7×6 m`

Smith:
- center `(+24.5,0)`
- already handled in Slice 04.

Work Storage:
- center `(+24.5,+9.5)`
- footprint `7×6 m`

East service alley:
- approximately X `+28.5`
- target width `2.5 m`

## Allowed

- frontage-lane scaffold;
- work-storage real doorway/collision;
- open canopy posts/roof primitive;
- loading/cart/material anchors;
- flush Area 08 work-support anchors/markers;
- service-alley scaffold;
- focused tests.

## Forbidden

- worker housing in Area 08;
- duplicate smith;
- final crafting/service logic;
- final material piles/clutter;
- streaming.

## Area 08 law

Area 08 remains connective frontage.

No new building parcel may be invented there.

Allowed only:
- worker idle anchors;
- flush tool/coat/storage edge;
- wayfinding;
- narrow rest socket if measured clearance allows.

## Required tests

1. East Frontage Lane width/center correct.
2. Area 08 contains no new building footprint.
3. Smith remains unique.
4. Work Canopy remains north of Smith.
5. Work Storage remains south of Smith.
6. all three S04 fixed parcels do not overlap.
7. canopy remains open-sided/traversable.
8. storage doorway opens toward frontage/service flow.
9. east service alley remains continuous.
10. Area 05 connector remains clear.
11. current smith regressions remain green.
12. first-person controls/camera unchanged.

## Visual bindings

- Area 08 F002
- Area 09 F002
- Area 10 F002

## Completion evidence

Slice 07 completes when:
- S04 traversal is continuous;
- frontage/service circulation passes;
- storage/canopy contracts pass;
- smith remains valid.

## Next slice

Slice 08 — North Hunter transition / Areas 11–12.
