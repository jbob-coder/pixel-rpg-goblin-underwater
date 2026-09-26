# Model Sheet — A12 Trail Transition

Status: MODEL_SHEET_READY

## Flow

Main Hunter Spine
→ North Gate
→ external hunt trail.

## Visual transition

Inside settlement:
- wider packed road
- civic/guard props

At gate:
- warning identity
- wall/fence termination

Beyond gate:
- road narrows
- trail surface dominates
- trees/vegetation/rocks increase
- settlement clutter drops rapidly

## Existing reuse

- `trail_surface_details_01.tscn`
- `trail_pine_01.tscn`
- `trail_rock_visual_01.tscn`
- `vegetation_cluster_01.tscn`

## Physics

Ground owns walkability.

Trail presentation:
`NONE` collision unless a substantial rock/tree explicitly blocks.

## Navigation

Trail center must remain visibly readable beyond the gate.

## Graybox readiness

`READY`
