# Layer 00 — Coordinate, Scale and Blueprint Rules

Status: PROVISIONAL SETTLEMENT DESIGN FRAME

## Coordinate convention

- X negative = west
- X positive = east
- Z positive = south / civilian arrival
- Z negative = north / hunter trail
- Y = vertical
- nominal settlement walking floor = Y 0

## Envelope

Provisional enclosed settlement:
- X -30..+30
- Z -36..+34
- width 60 m
- north-south depth 70 m
- area about 4,200 m²

## Perimeter reference lines

Provisional wall centerlines:
- west: X -29
- east: X +29
- south: Z +33
- north: Z -35

Wall modules must not be implemented as one giant collision body.

## Gate standards

South civilian gate:
- center: (0,0,+33)
- clear opening: 8 m

North Hunter gate:
- center: (0,0,-35)
- clear opening: 8 m
- north trail continues beyond Z -36

## Human/gameplay scale

Use current first-person scale and current smith as practical anchors.

Current smith reference:
- footprint 6.6 × 6.4 m
- wall height 3.3 m
- doorway 1.8 × 2.4 m

Important building doorway planning:
- preferred clear width 1.6–2.0 m
- preferred clear height 2.2–2.6 m

## Street standards

- Main Hunter Spine: 8 m design width
- Secondary street: 5 m design width
- residential/work frontage lane: 4.5 m
- service alley: 2.5–3 m
- doorway frontage clearance: target 2–3 m when possible

## Height bands

Provisional:
- residence eave: 3–4 m
- hall/smith eave: 3.5–4.5 m
- gate/watch structures: 5–7 m silhouette envelope
- wall/palisade visual height: 4.5–6 m

Exact art height is subject to first-person readability and performance.

## Blueprint evidence labels

Every value should be one of:
- CURRENT_RUNTIME
- APPROVED_TOPOLOGY
- PROVISIONAL_BLUEPRINT
- ASSET_DERIVED
- GAMEPLAY_ADJUSTED
- UNKNOWN

No provisional value becomes runtime truth until implemented and tested.

## Grid discipline

Use a 0.5 m planning grid for major placement.
Use 0.1 m detail increments only inside a building/asset blueprint.

## Stable IDs

Planned IDs use:
- section: `SET01_S01` etc.
- building: `SET01_BLD_...`
- connector: `SET01_CON_...`
- anchor: `SET01_ANCHOR_...`
- prop socket: `SET01_PROP_...`

Stable IDs must survive visual replacement.
