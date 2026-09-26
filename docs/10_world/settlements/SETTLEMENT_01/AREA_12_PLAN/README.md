# Settlement 01 — 12-Area Master Plan

Status: PROVISIONAL SUB-AREA PLAN / DOCUMENTATION AUTHORITY  
Created: 2026-09-25

This layer subdivides the existing five-section Settlement 01 topology into twelve smaller authored areas for visual design, asset production, navigation, streaming ownership, and incremental implementation.

The 12-area plan **refines** the five-section plan; it does not silently replace section IDs.

## Five-section → twelve-area relationship

### S01 South Gate / Arrival
- Area 01 — South Arrival Gate
- Area 02 — Gate Barracks & Security
- Area 03 — Caravan Yard / Visitor Staging

### Cross-settlement connector
- Area 04 — Main Central Spine Road

Area 04 crosses multiple section boundaries and is treated as shared connector infrastructure rather than an independent durable section owner.

### S02 Central Plaza / Market
- Area 05 — Central Market Plaza

### S03 West Residential / Local
- Area 06 — Community Hall / Civic Core
- Area 07 — West Residential Cluster

### S04 East Work District
- Area 08 — East Work Frontage / Worker Passage
- Area 09 — Smithy & Craft Quarter
- Area 10 — Storage / Workshop Yard

Area 08 is worker/local housing inside the broader East Work District; it does not redefine S04 as a purely residential district.

### S05 North Hunter Exit
- Area 11 — North Hunter Staging Ground
- Area 12 — North Watch Gate & Trail Exit

## Area list

| Area | Name | Parent | Primary purpose |
|---|---|---|---|
| 01 | South Arrival Gate | S01 | civilian entrance, welcome, gate identity |
| 02 | Gate Barracks & Security | S01 | guards, duty, weapons/equipment, patrol staging |
| 03 | Caravan Yard / Visitor Staging | S01 | carts, travelers, temporary staging, orientation |
| 04 | Main Central Spine Road | shared | strongest N/S circulation and landmark axis |
| 05 | Central Market Plaza | S02 | commerce, gathering, central orientation |
| 06 | Community Hall / Civic Core | S03 | local administration, notices, events, social hub |
| 07 | West Residential Cluster | S03 | resident homes, yards, quiet local life |
| 08 | East Work Frontage / Worker Passage | S04 | frontage circulation, worker rest/shift frontage, work-district connector |
| 09 | Smithy & Craft Quarter | S04 | smith service, work frontage, equipment/craft identity |
| 10 | Storage / Workshop Yard | S04 | materials, storage, work canopy, loading |
| 11 | North Hunter Staging Ground | S05 | hunt preparation, supplies, bounty/route information |
| 12 | North Watch Gate & Trail Exit | S05 | dangerous-world threshold, trail connector, watch |

## Final-image spatial lock

Authoritative placement contract for future final references:

`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

The existing R001 images are concept/asset references. They do not have authority to move buildings, roads, section boundaries or connectors.

Area 08 was corrected during this lock: the earlier worker-housing concept conflicts with fixed S04 building parcels and is superseded by **East Work Frontage / Worker Passage**.

## Production rule

One area at a time:

PLAN
→ document geometry/content
→ create visual reference specification
→ generate one area image
→ record provenance/review state
→ extract asset/building blueprints
→ only then move to the next area.

Do not generate all twelve areas on one sheet.

## Image style law

Every area reference must be:
- deliberate pixel art / pixel-styled game reference;
- readable at game-like scale;
- coherent with first-person real-3D conversion;
- original IP;
- free of copied logos/names/UI;
- free of misleading exact technical dimensions unless documented separately.

The image is visual reference, not collision or coordinate authority.


## Reference-production status — complete

All twelve areas now have separate saved references.

Register:
`AREA_REFERENCE_REGISTER_2026-09-25.md`

Current state:
- Area 01 — REFERENCE_GENERATED
- Area 02 — REFERENCE_GENERATED
- Area 03 — REFERENCE_GENERATED
- Area 04 — REFERENCE_GENERATED
- Area 05 — REFERENCE_GENERATED
- Area 06 — REFERENCE_GENERATED
- Area 07 — REFERENCE_GENERATED
- Area 08 — REFERENCE_GENERATED
- Area 09 — REFERENCE_GENERATED
- Area 10 — REFERENCE_GENERATED
- Area 11 — REFERENCE_GENERATED
- Area 12 — REFERENCE_GENERATED

All reference images are stored under the Library folder:

`/Pixel RPG/Settlement 01/Area References/`

The next production layer is **REFERENCE_REVIEWED → MODEL_SHEET_READY**:
1. review visual consistency;
2. extract reusable buildings/props;
3. assign collision class;
4. identify which objects already exist in runtime;
5. identify which require new blueprint/model sheets;
6. reject any image detail that conflicts with the documented 60×70 m settlement geometry.


## Final spatial-reference pass — complete

The original R001 set remains concept/asset-extraction material.

A second F001 set has now been created under the spatial lock:
- 12 / 12 final area references generated;
- north-up orientation fixed;
- fixed roads/buildings/connectors preserved;
- all 12 passed documentation spatial checks;
- files archived under `/Pixel RPG/Settlement 01/Final Area References/`.

Area 08 was materially corrected during this pass:
- final role: **East Work Frontage / Worker Passage**;
- no residence buildings;
- narrow frontage geometry preserved.

Creator visual review remains separate from spatial validation.
Runtime implementation remains separate from both.
