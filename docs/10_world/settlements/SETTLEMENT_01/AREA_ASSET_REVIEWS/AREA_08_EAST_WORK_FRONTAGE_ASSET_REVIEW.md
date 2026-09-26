# Area 08 Asset Extraction Review — East Work Frontage / Worker Court

Status: TECHNICAL_REFERENCE_REVIEWED / OLD HOUSING COMPOSITION REJECTED  
Area ID: `SET01_A08_EAST_WORK_FRONTAGE`  
Historical reference ID: `REF_SET01_A08_EAST_WORKER_HOUSING_R001`

## Spatial correction

Final Area 08 frame:
- X +14..+20.5
- Z -14..+14

Area 08 is an **open frontage/worker court**, not a housing district.

The old R001 image contains two houses. Those houses are:
`REJECT_FROM_AREA_08_FINAL_PLACEMENT`.

Reason:
they conflict with fixed S04 parcels for Smith, Work Storage and Work Canopy.

## Useful concepts salvaged from R001

Keep as prop/mood reference:
- one bench;
- one modest tree/green pocket;
- restrained worker idle activity;
- hanging work clothes/cloth line;
- small tool/storage rack;
- small crate cluster;
- lanterns;
- compact social court.

Do not keep:
- two residence buildings;
- house door/window placement;
- residential parcel logic.

## Reuse current/planned assets

### REUSE
- `SET01_PROP_BENCH_A`
- `SET01_PROP_CRATE_A`
- lantern_post_01
- vegetation_cluster_01

### ADAPT
- Area 02 Equipment Rack Family for light worker-tool storage;
- Area 07 optional cloth line as a worker-life detail;
- wayfinding/signpost family for shift/work direction if needed.

## New Area-08-specific structure

None required.

Area 08 should remain mostly open.

Potential new small prop:
`SET01_PROP_SHIFT_BOARD_A`

This may reuse the duty/civic board structural family with work-shift content.

## Worker-court role

Functions:
- worker idle/rest;
- shift-change gathering;
- circulation between Plaza, Smith and Work Yard;
- light social interaction;
- visual breathing room in S04.

## Collision

| Asset | Collision |
|---|---|
| Frontage floor | owned by ground |
| Bench | SIMPLE |
| Tree trunk | SIMPLE if substantial |
| Tool rack | SIMPLE |
| Clothesline | NONE |
| Small crates | NONE |
| Lantern | NONE/SIMPLE |
| Shift board | NONE/SIMPLE |

## Density

First pass:
- 1 bench;
- 1 tree/green accent;
- 1 small tool/storage rack;
- 0–3 workers;
- 2–3 lanterns;
- optional shift board.

No building.

## Model-sheet queue

1. Worker Court Deployment
2. Shift Board / Worker Tool Rack Variant
3. Worker Social/Shift Anchors

## Final image requirement

A future final Area 08 image must be regenerated.

It must show:
- East Frontage Lane at its correct position;
- Smith/Area 09 to the east;
- Area 10 connections north/south;
- no residence buildings.

## Review state

Technical review:
`PASS WITH SPATIAL CORRECTION`

Old R001:
`CONCEPT_ONLY / NOT FINAL POSITION`

Model extraction:
`READY`

Runtime:
`NOT STARTED`
