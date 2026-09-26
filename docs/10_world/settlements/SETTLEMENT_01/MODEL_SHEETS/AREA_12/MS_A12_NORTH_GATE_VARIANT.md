# Model Sheet — A12 North Gate Variant

Status: MODEL_SHEET_READY

## Locked geometry

Gate center:
- X 0
- Z -35

Clear opening:
- 8 m

## Engineering reuse

Use the same modular gate/wall connector logic as the South Gate where compatible.

Do not reuse South Gate presentation unchanged.

## Visual identity

North Gate:
- rugged
- weathered
- warning-oriented
- hunt/departure identity
- direct wilderness sightline

South Gate:
- civilian
- welcome/security
- carts/logistics
- civic identity

## Modules

- GatePost_L
- GatePost_R
- GateLeaf_L
- GateLeaf_R
- warning-banner sockets
- lantern sockets
- wall connectors

## Collision

Open state:
- posts/side modules block;
- central 8 m opening remains clear;
- leaves must not intrude into the passage.

Closed state:
future only; requires explicit state/collision owner.

## Final-reference rule

North/trail must remain image TOP.
Settlement/Area 11 must remain image BOTTOM.

## Graybox readiness

`READY`
