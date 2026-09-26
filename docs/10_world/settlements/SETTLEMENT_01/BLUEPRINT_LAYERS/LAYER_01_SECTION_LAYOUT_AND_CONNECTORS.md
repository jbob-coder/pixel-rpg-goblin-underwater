# Layer 01 — Section Layout and Connectors

Status: PROVISIONAL FIVE-SECTION GEOMETRY

## Macro layout

```
               NORTH / HUNT TRAIL
                      |
              +-------------------+
              | S05 HUNTER EXIT   |
              |  watch / supply   |
              +---------+---------+
                        |
        +-------+-------+-------+-------+
        | S03   |      S02      | S04   |
        | WEST  | CENTRAL PLAZA | EAST  |
        | LOCAL | / MARKET      | WORK  |
        +-------+-------+-------+-------+
                        |
              +---------+---------+
              | S01 SOUTH GATE    |
              | ARRIVAL           |
              +-------------------+
                      |
               CIVILIAN ARRIVAL
```

## Section geometry

### SET01_S01 — South Gate / Arrival

Primary band:
- X -30..+30
- Z +14..+34

Function:
- civilian/player arrival
- security
- initial orientation
- cart/logistics staging

### SET01_S02 — Central Plaza / Market

Bounds:
- X -14..+14
- Z -14..+14

Core plaza:
- X -14..+14
- Z -12..+12

Function:
- navigation hub
- social/market center
- cross-settlement sightlines

### SET01_S03 — West Residential / Local

Bounds:
- X -30..-14
- Z -14..+14

Function:
- Community Hall / Local Lodge
- residences
- local-life anchors

### SET01_S04 — East Work District

Bounds:
- X +14..+30
- Z -14..+14

Function:
- smith
- storage
- work canopy
- material logistics

### SET01_S05 — North Hunter Exit

Bounds:
- X -30..+30
- Z -36..-14

Function:
- hunt preparation
- Hunter Gate
- warning/route information
- transition to trail

## Primary connectors

### SET01_CON_S01_S02_MAIN

- center X 0
- boundary Z +14
- clear width 8 m
- carries Main Hunter Spine

### SET01_CON_S02_S05_MAIN

- center X 0
- boundary Z -14
- clear width 8 m
- carries Main Hunter Spine

### SET01_CON_S02_S03

- boundary X -14
- center Z 0
- clear width 5 m
- west residential connector

### SET01_CON_S02_S04

- boundary X +14
- center Z 0
- clear width 5 m
- east work connector

## Optional side connectors

These are PROVISIONAL and may remain closed until streaming tests justify them.

- S01↔S03 service/pedestrian connector near X -23, Z +14
- S01↔S04 service connector near X +23, Z +14
- S03↔S05 local/hunter shortcut near X -23, Z -14
- S04↔S05 work/supply shortcut near X +23, Z -14

Target width:
- 3–5 m depending route role

## Graph

Required graph:

S01 ↔ S02 ↔ S05  
S02 ↔ S03  
S02 ↔ S04

Optional future:
S01 ↔ S03
S01 ↔ S04
S03 ↔ S05
S04 ↔ S05

The required graph alone must keep the entire settlement traversable.
