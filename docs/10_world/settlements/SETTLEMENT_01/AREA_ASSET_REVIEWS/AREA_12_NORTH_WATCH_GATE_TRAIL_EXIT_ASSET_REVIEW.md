# Area 12 Asset Extraction Review — North Watch Gate & Trail Exit

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT`  
Reference ID: `REF_SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT_R001`

## Spatial lock

Frame:
- X -30..+30
- Z -36..-23

Fixed:
- Hunter Watch center -19,-27
- Supply Cache center +19,-27
- North Gate center 0,-35
- 8 m clear gate opening
- trail continues north/top

Area 11 lies south/bottom.

## Review result

Useful:
- rugged open gate;
- paired support masses;
- trail visible beyond;
- wall/fence transition;
- warning banner/sign;
- lanterns;
- trees/rocks increasing beyond settlement;
- sparse guards/hunters.

Reject:
- exact symmetrical tower placement;
- exact wall/fence line;
- exact tree/rock positions;
- gate-leaf angles from image;
- any fortress-scale interpretation.

## Existing/planned authority

Building blueprint:
`BLD_05_HUNTER_EXIT_SUPPORT.md`

Wall/gate kit:
`MODULAR_WALL_GATE_KIT.md`

Current gate/Warden assets:
reference/adaptation inputs only.

Trail assets already exist:
- trail_pine_01
- trail_rock_visual_01
- vegetation_cluster_01
- trail_surface_details_01

## New/adapted assets

### North Gate Variant
Shares modular gate engineering with South Gate but uses:
- rugged/weathered presentation;
- warning identity;
- different banners/signs;
- wilderness transition.

### Hunter Watch
Existing blueprint already covers building.

### Supply Cache
Existing blueprint already covers building.

### Trail Transition Module
Presentation system:
- packed settlement road → narrower trail;
- increasing vegetation/rock density;
- reduced civic props.

## Collision

Gate side modules:
GAMEPLAY_SPECIFIC/SIMPLE.

8 m opening:
must remain clear.

Watch/cache:
BUILDING.

Trail visual details:
NONE; ground owns walkability.

Trees/rocks:
simple collision only where substantial and intentional.

## Model-sheet queue

1. North Gate Visual Variant
2. Trail Transition Deployment
3. Hunter Watch / Supply Cache frontage deployment
4. Warden / Return / Warning anchor layout

## Review state

Technical review: `PASS`  
Spatial placement: `LOCKED`  
Model extraction: `READY`
