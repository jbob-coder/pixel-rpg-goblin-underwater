# Area 05 Asset Extraction Review — Central Market Plaza

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A05_CENTRAL_MARKET_PLAZA`  
Reference ID: `REF_SET01_A05_CENTRAL_MARKET_PLAZA_R001`

## Review result

Useful reference concepts:
- four compatible market stalls on plaza perimeter;
- large open central circulation zone;
- one civic water/fountain/well feature;
- one notice board;
- benches;
- sparse trees/green accents;
- lantern rhythm;
- moderate NPC activity.

Reject as literal authority:
- perfect four-corner symmetry;
- exact fountain position;
- exact tree count;
- exact NPC count/placement;
- fence-like perimeter treatment;
- uniform flat ground color.

## Blueprint authority

Central Plaza remains:
- approximately 28×24 m planning target;
- Main Spine stays clear;
- Cross Street stays clear;
- permanent stalls remain outside the central cross.

## Reuse current runtime assets

### REUSE_CURRENT

`market_stall_01.tscn`
- base structural reference for stall family.

`lantern_post_01.tscn`
- plaza perimeter landmarks.

`street_surface_details_01.tscn`
- surface variation.

`vegetation_cluster_01.tscn`
- controlled greenery where appropriate.

### REUSE PLANNED SHARED FAMILIES

`SET01_PROP_BENCH_A`
- shared plaza seating.

`SET01_PROP_CRATE_A`
- vendor logistics.

`SET01_PROP_WAYFINDING_NODE_A`
- route guidance on plaza approaches.

## New/adapted families required

### A05-MARKET-STALL-FAMILY

Use existing building blueprint:
`BLD_06_MARKET_STALL_VARIANTS.md`

Four roles:
- general goods/produce;
- food/basic supplies;
- civic/local rotating vendor;
- hunter/material/equipment display.

One structural frame, multiple dressing variants.

### A05-CIVIC-WATER-FEATURE

New compact civic landmark.

Preferred:
- low stone basin / well / trough-derived civic feature;
- does not dominate the plaza;
- readable first-person landmark.

Collision:
`SIMPLE`.

No water simulation required.

### A05-CIVIC-NOTICE-BOARD

Reuse structural family from Area 02 Duty Board where possible.

Difference:
- civic/community content layer;
- larger public-facing presentation.

Text/data:
authored separately.

### A05-PLAZA-TREE/PLANTER

Prefer existing vegetation/tree assets first.

If a dedicated civic tree planter is needed:
- simple trunk/planter;
- no dense canopy blocking first-person sightlines.

## NPC/market relationship

Reference shows multiple people distributed across plaza.

Runtime first pass:
- 3–6 visible NPCs around active plaza;
- vendors tied to stall anchors;
- visitors use social/idle anchors;
- avoid crowding the cross.

## Collision table

| Asset | Collision |
|---|---|
| Market stall support/counter | SIMPLE |
| Stall canopy | NONE |
| Display goods | NONE |
| Water feature | SIMPLE |
| Notice board | NONE/SIMPLE |
| Bench | SIMPLE |
| Tree trunk | SIMPLE only if substantial |
| Foliage | NONE |
| Lantern | NONE/SIMPLE |
| Crates | NONE/SIMPLE |

## Model-sheet queue

1. Market Stall Deployment/Variant Contract
2. Civic Water Feature
3. Civic Notice Board Variant
4. Plaza Furniture/Social Anchor Layout

## First-person readability

From plaza approach:
- central open space must read immediately;
- stalls should read as four service edges, not a wall;
- water/notice landmarks should aid orientation;
- signage should not depend on tiny baked text.

## Review state

Technical review:
`PASS`

Model extraction:
`READY`

Runtime:
`NOT STARTED`
