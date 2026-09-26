# Settlement 01 — Graybox Implementation Readiness Matrix

Status: IMPLEMENTATION-PREPARED / RUNTIME NOT STARTED  
Created: 2026-09-26

## Purpose

Separate what is ready for graybox implementation from what still requires creator art approval.

A graybox may use authoritative coordinates/model contracts even while final art approval is pending.

Final art promotion must wait for creator review.

## Global readiness

| Input | State |
|---|---|
| 60×70 m envelope | READY |
| global orientation | LOCKED |
| five-section topology | READY |
| twelve-area subdivision | READY |
| main spine/cross/frontage geometry | READY |
| fixed building parcels | LOCKED FOR F001 |
| section connectors | READY |
| collision/navigation rules | READY |
| area technical reviews | 12/12 COMPLETE |
| model-sheet packages | 12/12 COMPLETE |
| F001 final references | 12/12 GENERATED |
| F001 spatial checks | 12/12 PASS |
| creator art approval | 0/12 PENDING |
| runtime SectionDefinition | NOT IMPLEMENTED |
| runtime five-section migration | NOT IMPLEMENTED |

## What may proceed before visual approval

Documentation/engineering preparation may proceed for:
- stable IDs;
- SectionDefinition schema;
- SectionInstance schema;
- connector records;
- coordinate constants/data records;
- collision ownership contracts;
- graybox primitive dimensions;
- anchor naming;
- focused test specifications;
- migration/rollback plan.

Graybox geometry may use simple primitives and authoritative dimensions.

## What must not be treated as final before creator approval

Do not lock:
- final facade art;
- final roof silhouettes;
- final prop styling;
- color/material variants;
- decorative signage;
- final clutter density;
- final NPC visual density.

## Area-by-area readiness

| Area | Geometry | Technical review | Model sheets | F001 spatial | Graybox-ready | Final-art-ready |
|---|---|---|---|---|---|---|
| 01 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 02 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 03 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 04 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 05 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 06 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 07 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 08 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 09 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 10 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 11 | READY | COMPLETE | COMPLETE | PASS | YES | NO |
| 12 | READY | COMPLETE | COMPLETE | PASS | YES | NO |

## Implementation-prep package

Runtime-preparation contracts:

`IMPLEMENTATION_PREP/`

Contains:
- SectionDefinition / SectionInstance contract;
- 12-area coordinate register;
- stable connector register;
- graybox test contract.

These are implementation inputs only. Runtime code is still not started.

## Recommended runtime implementation order

Do not implement all twelve at once.

### Slice 1 — data/ownership only
- SectionDefinition
- SectionInstance
- stable connector records
- no visible movement

### Slice 2 — Area 04 spine scaffold
- main north/south route
- coordinate origin proof
- connector test

### Slice 3 — Area 05 central plaza scaffold
- central crossing
- four-way navigation
- minimap transform proof

### Slice 4 — Area 09 Smith quarter
- migrate/adapt current smith
- preserve real doorway/interior
- validate East frontage

### Slice 5 — Area 06 + 07 west local district
- Community Hall graybox
- two residence grayboxes
- frontage lane

### Slice 6 — Areas 01–03 south arrival
- gate
- barracks
- logistics yard
- south connector

### Slice 7 — Areas 10 + 08 east support
- storage/canopy
- worker passage

### Slice 8 — Areas 11–12 north hunter transition
- staging
- watch/supply
- gate/trail connector

### Slice 9 — perimeter/wall modules
- only after all core traversal passes

### Slice 10 — conservative streaming
- only after static full layout passes

## Minimum test set

Before full settlement promotion:
- every area inside envelope;
- every fixed building inside parcel;
- every required connector open;
- main spine continuous South→North;
- cross street continuous West↔East;
- all important doors traversable;
- adjacent walls block;
- no section-boundary step/gap;
- player transform continuous across section ownership;
- minimap mapping continuous;
- no duplicate NPC/world owner;
- current first-person controls unchanged.

## Evidence boundary

This matrix does not mean the runtime implementation exists.

Current status remains:
`DOCUMENTATION + REFERENCE + MODEL CONTRACT READY`

not:
`SETTLEMENT RUNTIME IMPLEMENTED`.
