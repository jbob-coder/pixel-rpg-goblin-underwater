# Area 04 Asset Extraction Review — Main Central Spine Road

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A04_MAIN_CENTRAL_SPINE_ROAD`  
Reference ID: `REF_SET01_A04_MAIN_CENTRAL_SPINE_ROAD_R001`

## Review result

The reference correctly emphasizes circulation over decoration.

Useful concepts:
- wide uninterrupted central road;
- sparse pedestrian activity;
- buildings remain outside the road corridor;
- repeated trees/lanterns/signage create rhythm;
- occasional benches/cart/boxes remain on edges;
- strong north/south visual axis.

Reject as literal authority:
- identical repeated houses;
- exact tree/lantern spacing;
- exact pedestrian positions;
- road width inferred only from the image;
- flat uniform road color;
- any implication that every edge building shares one visual family.

## Blueprint authority

Main Hunter Spine:
- 8 m design width;
- center X 0;
- South Gate → Central Plaza → North Hunter Exit.

The image does not change that geometry.

## Reuse current runtime assets

### REUSE_CURRENT

`street_surface_details_01.tscn`
- current primary road-detail family.

`lantern_post_01.tscn`
- repeated wayfinding/lighting landmark.

`signpost_01.tscn`
- major route nodes.

`vegetation_cluster_01.tscn`
- limited green edge accents.

`trail_pine_01.tscn`
- only where settlement edge transitions justify tree scale; avoid turning the civic spine into forest.

### ADAPT_CURRENT

`settlement_building_details_01.tscn`
- temporary frontage presentation only;
- not the reusable building authority;
- future frontage should use real building families from Areas 06–10.

## New infrastructure assets required

### A04-ROAD-EDGE-STONE-FAMILY

Purpose:
- visually define road shoulders;
- help first-person navigation;
- separate street from yards/frontages.

Variants:
- straight;
- broken/irregular;
- connector/opening.

Collision:
`NONE` unless a true curb/step is intentionally added.

### A04-SURFACE-DETAIL-DECAL/SPRITE FAMILY

Shared road wear:
- wheel tracks;
- packed-earth variation;
- stone patches;
- drain/worn edge marks.

Presentation-only.

Must not introduce physics.

### A04-WAYFINDING-NODE

May adapt current signpost base.

Needs stable destinations:
- South Gate
- Plaza
- Local Hall/Homes
- Smith/Work Yard
- Hunter Gate

Text authored separately.

## Shared existing/new props

Bench:
- use shared `SET01_PROP_BENCH_A`.

Cart:
- use Area 03 cargo cart family when a cart is needed.

Crates:
- use shared crate family.

Lantern:
- use current lantern asset.

## Street density rule

Within the 8 m spine:
- keep central 6 m visually clean of permanent props.

Edge zone:
- lanterns;
- signs;
- benches;
- occasional cart/loading activity.

Never use decoration to reduce the primary route into a narrow lane.

## Pedestrian rule

Reference shows multiple walkers.

Runtime first pass:
- 1–4 visible NPCs per nearby spine segment depending active sections;
- schedules/section ownership drive population;
- no decorative crowd owner.

## Collision table

| Asset | Collision |
|---|---|
| Road surface detail | NONE |
| Edge stones | NONE by default |
| Signpost | NONE/SIMPLE |
| Lantern | NONE/SIMPLE |
| Bench | SIMPLE |
| Cart | SIMPLE |
| Small clutter | NONE |
| Buildings | owned by their building contract |

## Model-sheet queue

1. Main Spine Surface System
2. Road Edge / Shoulder Module Family
3. Wayfinding Node / Signpost Content Interface

Other visible objects should reuse already planned families.

## Review state

Technical review:
`PASS`

Model extraction:
`READY`

Runtime:
`NOT STARTED`
