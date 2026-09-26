# Model Sheet — A01 Wall Connector Pair

Status: MODEL_SHEET_READY  
Asset IDs:
- `SET01_A01_WALL_CONNECTOR_L`
- `SET01_A01_WALL_CONNECTOR_R`

## Purpose

Join South Gate structures to the modular perimeter wall without gaps or giant custom wall meshes.

## Dimensions

Use modular wall assumptions:
- compatible with 0.5 m planning grid
- target wall visual height 4.5–6 m
- connector length selected from 2 m / 4 m module family where possible

## Interface

Each connector exposes:
- GateSideConnector
- WallSideConnector

Store:
- transform
- compatible module type
- nominal wall thickness

## Collision

Simple box/prism per structural connector.

No decorative banner/trim owns collision.

## Variants

Allowed:
- left/right mirrored
- repair/trim visual variation
- banner socket

Not allowed:
- arbitrary footprint changes that break connector math.

## Tests

- no player-sized gap at gatehouse/watch join
- no overlap sealing 8 m gate
- wall module snaps on 0.5 m grid
- left/right pair preserve symmetry only where geometry requires it

## Graybox readiness

`READY`
