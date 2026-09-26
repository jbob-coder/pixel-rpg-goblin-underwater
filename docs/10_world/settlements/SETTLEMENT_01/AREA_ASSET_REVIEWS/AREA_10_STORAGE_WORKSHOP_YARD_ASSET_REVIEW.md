# Area 10 Asset Extraction Review — Storage / Workshop Yard

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A10_STORAGE_WORKSHOP_YARD`  
Reference ID: `REF_SET01_A10_STORAGE_WORKSHOP_YARD_R001`

## Spatial lock

Area 10 is one logical area with two fixed pockets separated by Area 09 Smith.

South/storage pocket:
- X +20.5..+30
- Z +6..+14
- Work Storage center +24.5,+9.5

North/canopy pocket:
- X +20.5..+30
- Z -14..-6
- Work Canopy center +24.5,-9.5

The R001 image places storage and canopy together for concept readability. That is **not final positional authority**.

## Review result

Useful:
- compact storage building;
- open canopy;
- carts;
- racks;
- crates;
- ore/wood piles;
- loading activity;
- sparse workers.

Reject:
- storage/canopy adjacency from R001;
- exact cart positions;
- exact worker count;
- flat yard geometry.

## Existing/planned authority

Building blueprint:
`BLD_04_WORK_DISTRICT_SUPPORT.md`

Cargo carts:
`SET01_PROP_CARGO_CART_A`

Shared:
- crate/barrel family
- worktable family
- equipment/material rack family
- lanterns

## New model needs

No additional major building family beyond existing Storage/Canopy blueprint.

Area-specific contracts:
- storage loading frontage;
- canopy work deployment;
- material-yard prop cluster;
- cart/load anchors.

## Collision

Storage:
BUILDING.

Canopy:
posts/workbench SIMPLE, no invisible side walls.

Carts/racks:
SIMPLE.

Small loose materials:
NONE by default.

## Model-sheet queue

1. Storage Loading Frontage
2. Work Canopy Deployment
3. Material Yard Cluster
4. Loading/Cart Anchor Layout

## Review state

Technical review: `PASS`  
R001 placement: `CONCEPT_ONLY`  
Locked two-pocket placement: `AUTHORITATIVE FOR FINAL REFERENCES`  
Model extraction: `READY`
