# Settlement 01 — Modular Wall and Gate Kit

Status: PROVISIONAL STRUCTURAL-ASSET BLUEPRINT

## Goal

Create perimeter identity without one giant mesh/collider.

## Modules

### WALL_STRAIGHT_A
Target length:
- 4 m

### WALL_STRAIGHT_B
Target length:
- 2 m

### WALL_CORNER_IN
90° inside corner

### WALL_CORNER_OUT
90° outside corner

### WALL_GATE_CONNECTOR_L/R
Connect wall to gatehouse/watch/gate frame.

### WALL_WATCH_CONNECTOR
Optional connector to watch silhouette/platform.

### WALL_UTILITY_OPENING
Only if later service circulation requires it.

## Height

Visual target:
- 4.5–6 m depending material/style

Collision:
- simple box/prism matching blocking volume
- separate by module

## Pivots

All wall modules need predictable grid-compatible origins.

Recommended:
- origin at ground center or end connector
- 0.5 m grid compatibility

## Connector standard

Each end should define:
- connector transform
- compatible connector type
- wall thickness assumption

## Gates

South and North gates:
- 8 m clear opening

Gate frame/doors are separate from wall modules.

## Art variation

Use:
- material variants
- banners
- repair patches
- controlled silhouette variation

Do not randomize collision dimensions per visual variant.

## Tests

- module dimensions
- connector alignment
- no gaps large enough for unintended player passage
- gate opening remains 8 m clear
- collision belongs to modules, not decorative overlays
