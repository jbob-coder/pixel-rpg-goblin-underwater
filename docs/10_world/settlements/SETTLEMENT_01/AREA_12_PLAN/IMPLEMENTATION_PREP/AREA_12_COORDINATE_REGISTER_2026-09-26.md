# Settlement 01 — 12-Area Coordinate Register

Status: LOCKED IMPLEMENTATION INPUT / F001 SPATIAL AUTHORITY  
Created: 2026-09-26

Coordinates are derived from:
`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

## Global envelope

- X -30..+30
- Z -36..+34
- nominal Y 0

## Shared infrastructure

Main Hunter Spine:
- X -4..+4
- Z -35..+33

Central Cross Street:
- X -20..+20
- Z -2.5..+2.5

West Frontage Lane:
- center X -16.25
- width 4.5
- Z -13..+13

East Frontage Lane:
- center X +16.25
- width 4.5
- Z -13..+13

## Area register

| ID | Name | Parent | X min | X max | Z min | Z max | Notes |
|---|---|---|---:|---:|---:|---:|---|
| SET01_A01 | South Arrival Gate | S01 | -14 | +14 | +25 | +34 | South Gate + gatehouse/watch |
| SET01_A02 | Gate Barracks & Security | S01 | -30 | -12 | +14 | +29 | Arrival Guard/Barracks |
| SET01_A03 | Caravan Yard / Visitor Staging | S01 | +12 | +30 | +14 | +29 | Arrival Storage/Logistics |
| SET01_A04 | Main Central Spine Road | SHARED | -10* | +10* | -36* | +34* | reference frame; physical road X -4..+4 |
| SET01_A05 | Central Market Plaza | S02 | -14 | +14 | -14 | +14 | central four-way hub |
| SET01_A06 | Community Hall / Civic Core | S03 | -30 | -14 | -6 | +6 | Community Hall |
| SET01_A07S | West Residential South Pocket | S03 | -30 | -18 | +6 | +14 | Residence W01 |
| SET01_A07N | West Residential North Pocket | S03 | -30 | -18 | -14 | -6 | Residence W02 |
| SET01_A08 | East Work Frontage / Worker Passage | S04 | +14 | +20.5 | -14 | +14 | no residence building parcels |
| SET01_A09 | Smithy & Craft Quarter | S04 | +20.5 | +30 | -5 | +5 | Smith |
| SET01_A10S | Storage / Workshop South Pocket | S04 | +20.5 | +30 | +6 | +14 | Work Storage |
| SET01_A10N | Storage / Workshop North Pocket | S04 | +20.5 | +30 | -14 | -6 | Work Canopy |
| SET01_A11 | North Hunter Staging Ground | S05 | -30 | +30 | -23 | -14 | preparation yard |
| SET01_A12 | North Watch Gate & Trail Exit | S05 | -30 | +30 | -36 | -23 | watch/cache/gate |

*A04 frame is documentation/reference framing, not its physical collision footprint.

## Fixed building register

| Building ID | Center X | Center Z | Width | Depth |
|---|---:|---:|---:|---:|
| SET01_BLD_SOUTH_GATEHOUSE_W | -8 | +29 | 8 | 7 |
| SET01_BLD_SOUTH_WATCH_E | +8 | +29 | 6 | 6 |
| SET01_BLD_ARRIVAL_GUARD | -20 | +23 | 7 | 6 |
| SET01_BLD_ARRIVAL_STORAGE | +20 | +23 | 7 | 6 |
| SET01_BLD_COMMUNITY_HALL | -24.5 | 0 | 8 | 10 |
| SET01_BLD_RES_W01 | -24.5 | +10 | 7 | 5.5 |
| SET01_BLD_RES_W02 | -24.5 | -10 | 7 | 5.5 |
| SET01_BLD_SMITH | +24.5 | 0 | 6.6 | 6.4 |
| SET01_BLD_WORK_STORAGE | +24.5 | +9.5 | 7 | 6 |
| SET01_BLD_WORK_CANOPY | +24.5 | -9.5 | 7 | 6 |
| SET01_BLD_HUNTER_WATCH | -19 | -27 | 7 | 7 |
| SET01_BLD_SUPPLY_CACHE | +19 | -27 | 7 | 6 |

## Gate register

South Gate:
- center (0,+33)
- clear width 8 m

North Gate:
- center (0,-35)
- clear width 8 m

## Coordinate-law

Runtime implementation must not derive coordinates from generated images.

Use this register/master spatial lock.

If coordinates change:
1. change master blueprint;
2. rerun geometric checks;
3. update this register;
4. update connectors;
5. update minimap;
6. update tests;
7. regenerate affected final references only after geometry is accepted.
