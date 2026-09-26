# Area 06 Asset Extraction Review — Community Hall / Civic Core

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A06_COMMUNITY_HALL_CIVIC_CORE`  
Reference ID: `REF_SET01_A06_COMMUNITY_HALL_CIVIC_CORE_R001`

## Review result

The reference supports the existing Community Hall plan rather than requiring a different building.

Useful concepts:
- one dominant hall frontage;
- obvious usable door;
- simple civic flag/sign identity;
- notice board;
- benches;
- one strong tree/green landmark;
- low-density local gathering;
- lanterns framing the civic space.

Rejected as literal authority:
- exact facade/window count;
- exact flag shape/color;
- exact tree position;
- exact bench spacing;
- exact NPC count/poses;
- any dojo-like interpretation of the roof/building.

The building remains a Settlement 01 Community Hall / Local Lodge, not a dojo/temple.

## Existing building authority

Primary blueprint:
`BUILDING_BLUEPRINTS/BLD_01_COMMUNITY_HALL.md`

Visual spec:
`BUILDING_BLUEPRINTS/VISUAL_REFERENCE_SHEETS/REF_01_COMMUNITY_HALL_VISUAL_SPEC.md`

Do not create a second competing hall geometry from the area image.

## Reuse current/planned assets

### REUSE PLANNED

`SET01_PROP_BENCH_A`
- civic seating.

`SET01_PROP_NOTICE_BOARD_CIVIC`
- public notices/events.

`lantern_post_01.tscn`
- 2–4 frontage/court landmarks.

`vegetation_cluster_01.tscn`
- controlled greenery around civic court.

### ADAPT CURRENT

`banner_post_01.tscn`
- may become hall flag/banner support;
- final symbol must be original settlement identity.

## New support modules

### A06-HALL-FRONTAGE-SIGN

A compact civic sign/bracket that identifies the hall without relying on long baked text.

Collision:
NONE.

### A06-CIVIC-FLAG/BANNER VARIANT

Uses future original Settlement 01 crest/symbol.

Presentation only.

### A06-CIVIC-TREE-ANCHOR / PLANTER

Prefer existing vegetation/tree assets before creating a new model.

If a planter/base is required:
- simple stone/wood base;
- trunk collision only if substantial.

## Social-anchor layout

Recommended:
- 2–4 benches maximum;
- NoticeReadAnchor near board;
- HallSocialAnchor_01..04;
- EventGatherAnchor set;
- keep door landing and route to Area 04 clear.

## Collision table

| Asset | Collision |
|---|---|
| Community Hall | BUILDING |
| Bench | SIMPLE |
| Notice board | NONE/SIMPLE |
| Flag/banner | NONE |
| Hall sign | NONE |
| Tree trunk | SIMPLE if substantial |
| Foliage | NONE |
| Lantern | NONE/SIMPLE |

## Model-sheet queue

1. Civic Frontage Deployment
2. Hall Sign / Flag Variant
3. Social Anchor / Furniture Placement

Hall structure itself already has a complete blueprint and should not be duplicated.

## Review state

Technical review:
`PASS`

Existing hall model blueprint:
`READY`

Area-specific support model extraction:
`READY`

Runtime:
`NOT STARTED`
