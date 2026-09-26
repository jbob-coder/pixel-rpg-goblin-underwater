# Area 07 — West Residential Cluster

Status: PLAN_READY / REFERENCE GENERATION NEXT  
Parent section: `SET01_S03`  
Area ID: `SET01_A07_WEST_RESIDENTIAL_CLUSTER`

## Purpose

Area 07 is the quieter local-living district west of the civic core.

It supports:
- two primary residence plots;
- small yards;
- resident daily-life anchors;
- low-density props;
- local path connection to Community Hall and the north/south settlement routes.

## Core buildings

Initial:
- Residence W01
- Residence W02

Both derive from Residence Type A:
- 7×5.5 m footprint
- east-facing real doorway
- simple one-room + private/rest zone interior

## Visual composition

Standalone pixel-art residential cluster only.

Show:
- two compact houses;
- separated yards;
- local lane;
- woodpile / small storage;
- one bench;
- 2–3 lanterns;
- low fence segments;
- one small shared green/tree pocket;
- sparse residents.

Do not show:
- market stalls;
- smith equipment;
- civic hall dominating frame;
- dense urban street.

## Yard language

House W01:
- woodpile
- bench/stool
- small fence/yard marker

House W02:
- storage chest/crates
- optional garden/laundry-style low-cost prop
- lantern

Keep both yards visually distinct while sharing the same residence family.

## Circulation

West frontage lane remains clear.

Target:
- 4.5 m frontage lane
- no yard prop intrudes into primary lane

Small footpath from each house to the frontage lane.

## NPC density

Reference:
- 3–6 resident figures maximum.

Runtime can be lower.

## Anchors

Planned:
- `A07_ResidenceW01Entrance`
- `A07_ResidenceW02Entrance`
- `A07_ResidentIdle_01..04`
- `A07_YardAnchor_W01`
- `A07_YardAnchor_W02`
- `A07_Connector_A06`
- `A07_Connector_North`
- `A07_Connector_South`

## Collision

- houses use segmented collision with real doorway;
- yard fences use modular simple collision only if player-blocking is intentional;
- small props mostly presentation-only.

## Image brief

Generate only Area 07.

Desired view:
- high 3/4 deliberate pixel art;
- two compact residences;
- readable lane and yards;
- quiet local-life character;
- no full settlement or infographic.

## Acceptance checklist

Approve only if:
- clearly residential;
- two houses share a family but are not identical;
- lane remains open;
- yard prop density controlled;
- no market/work-district visual language;
- genuine pixel art.
