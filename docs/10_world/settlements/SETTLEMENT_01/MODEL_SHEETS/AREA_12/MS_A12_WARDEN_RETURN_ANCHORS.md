# Model Sheet — A12 Warden / Return Anchor Layout

Status: MODEL_SHEET_READY

## Anchors

- `A12_NorthGateCenterAnchor`
- `A12_WardenAnchor`
- `A12_WatchAnchor`
- `A12_WarningAnchor`
- `A12_TrailConnectorAnchor`
- `A12_ReturnAnchor`
- `A12_Connector_A11`

## Placement rules

Warden:
- inside settlement side of gate;
- outside central path centerline;
- visible during northbound approach.

Warning anchor:
- before the gate, not after player has already crossed.

Return anchor:
- settlement side;
- safe from gate leaf/collision changes.

Trail connector:
- beyond gate;
- aligned to north/top continuation.

## State ownership

Current Gate Warden visual may inform presentation.

Durable NPC/world state must not live in the visual anchor node.

## Graybox readiness

`READY`
