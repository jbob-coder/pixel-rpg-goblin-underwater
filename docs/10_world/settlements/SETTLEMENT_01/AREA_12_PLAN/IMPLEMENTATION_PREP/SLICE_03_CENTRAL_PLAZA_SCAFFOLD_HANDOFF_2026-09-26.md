# Settlement 01 — Runtime Slice 03 Handoff

Status: READY AFTER SLICE 02 VERIFICATION / CENTRAL PLAZA SCAFFOLD ONLY  
Created: 2026-09-26

## Objective

Implement the Central Market Plaza graybox scaffold around the already-proven Main Spine coordinate frame.

This slice proves the first real 4-way settlement intersection without migrating final market art or services.

## Dependency

Required predecessor:
- Slice 01 SectionDefinition / SectionInstance verified;
- Slice 02 Main Spine scaffold verified.

Do not begin Slice 03 runtime changes before Slice 02 completion evidence exists.

## Runtime scope

Allowed:
- primitive plaza floor/presentation;
- Central Cross Street scaffold;
- four market-stall socket markers;
- civic-water/notice placeholder anchors;
- minimap-shape/transform proof;
- focused tests.

Forbidden:
- final stall art;
- vendor inventory/economy;
- NPC schedules;
- final water/notice props;
- moving current production market until migration is explicitly part of the slice;
- section streaming;
- final material lock.

## Area identity

Area ID:
`SET01_A05_CENTRAL_MARKET_PLAZA`

Parent section:
`SET01_S02`

Bounds:
- X `-14..+14`
- Z `-14..+14`

## Locked circulation

Main Spine:
- X `-4..+4`

Cross Street:
- Z `-2.5..+2.5`
- planned X extent `-20..+20`

Within Area 05 the visible cross is clipped to the Area 05 bounds.

The plus-shaped central circulation must stay clear.

## Market sockets

Four stall sockets remain outside both clear road corridors.

Stable socket IDs:
- `A05_Stall_SW`
- `A05_Stall_SE`
- `A05_Stall_NW`
- `A05_Stall_NE`

Target footprint per stall:
- 4×3 m

No stall primitive may overlap:
- X -4..+4;
- Z -2.5..+2.5.

## Civic anchors

Required placeholder anchors:
- `A05_NoticeAnchor`
- `A05_CivicWaterAnchor`
- `A05_EventAnchor`
- `A05_SocialAnchor_01`
- `A05_SocialAnchor_02`
- `A05_SocialAnchor_03`
- `A05_SocialAnchor_04`

These anchors do not implement service/state behavior yet.

## Connectors

Required:
- `A05_Connector_South`
- `A05_Connector_North`
- `A05_Connector_West`
- `A05_Connector_East`

The four-way crossing must visually and physically align with:
- S01/Main Spine south;
- S05/Main Spine north;
- S03 west frontage;
- S04 east frontage.

## Graybox representation

Use:
- simple ground/road primitives;
- four stall bounding boxes or debug-only outline markers;
- simple anchor nodes/records.

Do not introduce:
- decorative market clutter;
- final stall collision;
- vendor AI/state.

## Required tests

1. Area 05 bounds equal X -14..+14 / Z -14..+14.
2. Main Spine remains X -4..+4.
3. Cross Street remains Z -2.5..+2.5.
4. four stall sockets exist and are unique.
5. every stall footprint is outside both road-clearance bands.
6. north/south/east/west connectors exist.
7. crossing is continuous with Slice 02 road.
8. minimap transform maps plaza center to world X 0 / Z 0.
9. no service/economy owner is introduced.
10. current first-person controls/camera remain unchanged.
11. existing combat ownership remains unchanged.
12. no final visual asset is required for the test to pass.

## Visual binding

Current creator-review target:
`AREA_05_CENTRAL_MARKET_PLAZA_F002_LOCKED.png`

Use only for:
- stall-perimeter composition;
- civic/social visual hierarchy;
- pixel-density reference.

Do not copy exact:
- goods;
- NPC positions;
- awning colors;
- generated sign text.

## Completion evidence

Slice 03 completes when:
- plaza/cross scaffold exists;
- four stall sockets exist;
- connector tests pass;
- minimap mapping proof passes;
- existing regressions remain green;
- exact source SHA/build evidence is recorded if runtime source changed.

## Next slice

Slice 04 — Smith Quarter migration/adaptation.

Do not begin Slice 04 until Slice 03 is verified.
