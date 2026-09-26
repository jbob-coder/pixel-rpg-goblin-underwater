# Layer 03 — Building Parcels and Footprints

Status: PROVISIONAL BUILDING PLACEMENT BLUEPRINT

Coordinates are building-center X/Z unless otherwise stated.

## S01 South Gate / Arrival

### SET01_BLD_SOUTH_GATEHOUSE_W
- role: primary arrival/security building
- center: (-8, +29)
- target footprint: 8 × 7 m
- faces: north/east toward arrival pocket
- real interior required: YES

### SET01_BLD_SOUTH_WATCH_E
- role: gate/watch structure
- center: (+8, +29)
- target footprint: 6 × 6 m
- interior: limited/optional
- vertical landmark: YES

### SET01_BLD_ARRIVAL_GUARD
- role: guard/administrative booth
- center: (-20, +23)
- footprint: 7 × 6 m
- real entrance: YES

### SET01_BLD_ARRIVAL_STORAGE
- role: visitor/logistics storage
- center: (+20, +23)
- footprint: 7 × 6 m
- real entrance: YES

Keep central X -6..+6 mostly open for arrival/spine circulation.

## S02 Central Plaza / Market

No large permanent building in the central 28×24 m plaza.

Fixed sockets:
- market stall SW: (-11,+8.5)
- market stall SE: (+11,+8.5)
- market stall NW: (-11,-8.5)
- market stall NE: (+11,-8.5)

Typical stall footprint:
- 4 × 3 m

Reserve central clear space for:
- navigation
- NPC gathering
- temporary events

## S03 West Residential

### SET01_BLD_COMMUNITY_HALL
- center: (-24.5, 0)
- target footprint: 8 × 10 m
- faces east
- real interior required: YES
- primary local-life building

### SET01_BLD_RES_W01
- center: (-24.5,+10)
- target footprint: 7 × 5.5 m
- faces east
- real interior target: YES

### SET01_BLD_RES_W02
- center: (-24.5,-10)
- target footprint: 7 × 5.5 m
- faces east
- real interior target: YES

This satisfies the issue requirement for 2 supporting residence slots.

Optional third residence is expansion-only and should not be forced into the first 60×70 m implementation if it harms circulation.

## S04 East Work District

### SET01_BLD_SMITH
- center: (+24.5, 0)
- runtime-reference footprint: 6.6 × 6.4 m
- faces west
- real interior: IMPLEMENTED PATTERN
- migrate/adapt current enterable smith

### SET01_BLD_WORK_STORAGE
- center: (+24.5,+9.5)
- target footprint: 7 × 6 m
- faces west/south
- real interior required: YES

### SET01_BLD_WORK_CANOPY
- center: (+24.5,-9.5)
- target footprint: 7 × 6 m
- mostly open-sided
- collision must preserve walk-through work edges

Material yard:
- center approximately (+21,-5)
- no monolithic collision

## S05 North Hunter Exit

### SET01_BLD_HUNTER_WATCH
- center: (-19,-27)
- target footprint: 7 × 7 m
- role: watch/hunter preparation
- real entrance: YES

### SET01_BLD_SUPPLY_CACHE
- center: (+19,-27)
- target footprint: 7 × 6 m
- role: hunt supplies/emergency store
- real entrance: YES

### North Hunter Gate
- center: (0,-35)
- clear opening: 8 m
- modular gate/wall ownership
- current runtime gate is a visual/collision reference, not final placement

## Parcel rules

Every important building must define:
- building ID
- footprint
- frontage
- doorway
- collision profile
- interior type
- interaction anchors
- NPC anchors
- section ownership

No new important building may use a fake visual door on a solid collision box.
