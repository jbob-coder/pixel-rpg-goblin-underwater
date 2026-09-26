# Area 07 Asset Extraction Review — West Residential Cluster

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL-SHEET QUEUE READY  
Area ID: `SET01_A07_WEST_RESIDENTIAL_CLUSTER`  
Reference ID: `REF_SET01_A07_WEST_RESIDENTIAL_CLUSTER_R001`

## Spatial lock

Area 07 is one logical area split into two fixed residential pockets around Area 06 Community Hall.

South pocket:
- X -30..-18
- Z +6..+14
- Residence W01 center -24.5,+10

North pocket:
- X -30..-18
- Z -14..-6
- Residence W02 center -24.5,-10

Both connect through the West Frontage Lane.

The reference image may inform residential language, but it does not move these houses.

## Review result

Useful concepts:
- two related but not identical houses;
- quiet yards;
- low fence/yard divider;
- one shared tree/green pocket;
- benches;
- low-density crates/woodpile;
- lanterns;
- sparse residents.

Reject as literal authority:
- exact house spacing from image;
- exact fence line;
- path/barrier at image right;
- exact resident positions;
- exact tree/bench positions;
- any composition that removes Community Hall from the physical gap between W01 and W02.

## Existing building authority

Residence family:
`BUILDING_BLUEPRINTS/BLD_02_RESIDENCE_TYPE_A.md`

Initial instances:
- W01
- W02

Do not create separate one-off house geometry for each reference house.

## Reuse current/planned assets

### REUSE PLANNED
- `SET01_PROP_BENCH_A`
- `SET01_PROP_CRATE_A`
- `SET01_PROP_SUPPLY_BUNDLE_A`
- lantern_post_01
- vegetation_cluster_01
- fence_01 where a low yard divider is appropriate

### NEW/ADAPTED
- Residence Type A visual variant A
- Residence Type A visual variant B
- small residential yard-marker/fence variant
- woodpile family
- simple household storage cluster

## Collision

| Asset | Collision |
|---|---|
| Residences | BUILDING |
| Low yard fence | SIMPLE only if intentionally blocking |
| Bench | SIMPLE |
| Tree trunk | SIMPLE if substantial |
| Foliage | NONE |
| Small crates/woodpile | NONE by default |
| Lantern | NONE/SIMPLE |

## Density

Each pocket:
- 1 house
- 1–3 yard props
- 0–2 visible residents normally
- no dense decorative crowd

## Model-sheet queue

1. Residence Type A visual variant pair
2. Residential yard module
3. Woodpile / household storage family
4. Residential social/idle anchor layout

## Review state

Technical review:
`PASS`

Spatial placement:
`LOCKED`

Model extraction:
`READY`

Runtime:
`NOT STARTED`
