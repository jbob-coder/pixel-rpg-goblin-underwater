# Settlement 01 — Final Area Reference Spatial Lock

Status: ACTIVE FINAL-REFERENCE PLACEMENT AUTHORITY / DOCUMENTATION ONLY  
Created: 2026-09-26

## Purpose

Prevent visual-reference drift.

The first 12 saved area images are **concept references**. They are useful for object language, density, mood, and module extraction, but they are not final positional renders.

Every future **FINAL AREA REFERENCE** must obey this document and the master 60×70 m settlement blueprint.

## Global orientation lock

Every final area reference uses the same map orientation:

- NORTH / hunt trail = image TOP = negative Z
- SOUTH / civilian arrival = image BOTTOM = positive Z
- WEST = image LEFT = negative X
- EAST = image RIGHT = positive X

No final reference may rotate or mirror an area for composition convenience.

## Settlement envelope

- X -30..+30 m
- Z -36..+34 m

Fixed shared infrastructure:

### Main Hunter Spine
- center X 0
- width 8 m
- X -4..+4
- south gate Z +33
- north gate Z -35

### Central Cross Street
- center Z 0
- width 5 m
- Z -2.5..+2.5
- X -20..+20

### West Frontage Lane
- center X -16.25
- width 4.5 m
- Z -13..+13

### East Frontage Lane
- center X +16.25
- width 4.5 m
- Z -13..+13

## Fixed building parcels

These do not move between area images:

| Building | Center X/Z | Footprint |
|---|---:|---:|
| South Gatehouse W | -8,+29 | 8×7 |
| South Watch E | +8,+29 | 6×6 |
| Arrival Guard / Barracks | -20,+23 | 7×6 |
| Arrival Storage / Logistics | +20,+23 | 7×6 |
| Community Hall | -24.5,0 | 8×10 |
| Residence W01 | -24.5,+10 | 7×5.5 |
| Residence W02 | -24.5,-10 | 7×5.5 |
| Smith | +24.5,0 | 6.6×6.4 |
| Work Storage | +24.5,+9.5 | 7×6 |
| Work Canopy | +24.5,-9.5 | 7×6 |
| Hunter Watch | -19,-27 | 7×7 |
| Supply Cache | +19,-27 | 7×6 |

## 12-area spatial placement lock

### Area 01 — South Arrival Gate
Parent: S01

Final-reference frame:
- X -14..+14
- Z +25..+34

Must contain:
- South Gate center at X 0 / Z +33
- Gatehouse W at -8,+29
- Watch E at +8,+29
- 8 m clear central opening

Neighbor edges:
- Area 02 lies west/north-west
- Area 03 lies east/north-east
- Area 04 begins northward through center

### Area 02 — Gate Barracks & Security
Parent: S01

Final-reference frame:
- X -30..-12
- Z +14..+29

Fixed primary building:
- Arrival Guard/Barracks center -20,+23

Must preserve:
- east-side connection toward Main Spine / Area 01
- north connection toward settlement interior
- open security yard around the fixed building

### Area 03 — Caravan Yard / Visitor Staging
Parent: S01

Final-reference frame:
- X +12..+30
- Z +14..+29

Fixed primary building:
- Arrival Storage/Logistics center +20,+23

Must preserve:
- west connection toward Main Spine / Area 01
- north connection toward Area 04/05
- open cart/logistics yard

### Area 04 — Main Central Spine Road
Owner: SHARED INFRASTRUCTURE

Physical corridor:
- X -4..+4
- Z -35..+33

Final reference may frame:
- X -10..+10
- Z -36..+34

Rule:
- neighboring buildings may appear only in their correct left/right positions;
- Area 04 does not own or relocate those buildings;
- Central Plaza crossing remains at Z 0.

### Area 05 — Central Market Plaza
Parent: S02

Bounds:
- X -14..+14
- Z -14..+14

Must preserve:
- Main Spine through X -4..+4
- Cross Street through Z -2.5..+2.5
- stall/bench/water/notice props stay outside those clear corridors.

### Area 06 — Community Hall / Civic Core
Parent: S03

Final-reference frame:
- X -30..-14
- Z -6..+6

Fixed building:
- Community Hall center -24.5,0
- footprint X -28.5..-20.5 / Z -5..+5

Must preserve:
- east-facing entrance toward West Frontage Lane;
- Area 05 lies east;
- residential Area 07 occupies north/south pockets.

### Area 07 — West Residential Cluster
Parent: S03

Area 07 is one logical area with two linked residential pockets.

South pocket:
- X -30..-18
- Z +6..+14
- Residence W01 center -24.5,+10

North pocket:
- X -30..-18
- Z -14..-6
- Residence W02 center -24.5,-10

Connection:
- both use West Frontage Lane at X -16.25.

Final image may show both pockets in one north-up composition, but Community Hall must remain between them rather than being moved out of the district.

### Area 08 — East Work Frontage / Worker Court
Parent: S04

**This supersedes the earlier “East Worker Housing” placement concept.**

Reason:
the fixed S04 parcels already contain Smith, Work Storage, Work Canopy, frontage lane and service alley. Two additional 6×5 m houses would overlap the approved work-district geometry.

Final-reference frame:
- X +14..+20.5
- Z -14..+14

Function:
- east frontage circulation;
- worker idle/rest court;
- small shared storage/tool/bench props;
- connective social space between Areas 09 and 10;
- NO new residence buildings in this locked footprint.

### Area 09 — Smithy & Craft Quarter
Parent: S04

Final-reference frame:
- X +20.5..+30
- Z -5..+5

Fixed building:
- Smith center +24.5,0
- footprint X +21.2..+27.8 / Z -3.2..+3.2

Must preserve:
- west-facing frontage toward East Frontage Lane;
- clear smith doorway/service approach.

### Area 10 — Storage / Workshop Yard
Parent: S04

Area 10 is one logical support area with two fixed work pockets.

South/storage pocket:
- X +20.5..+30
- Z +6..+14
- Work Storage center +24.5,+9.5

North/canopy pocket:
- X +20.5..+30
- Z -14..-6
- Work Canopy center +24.5,-9.5

Connection:
- east service alley / frontage circulation;
- Smith/Area 09 remains between the two pockets.

### Area 11 — North Hunter Staging Ground
Parent: S05

Final-reference frame:
- X -30..+30
- Z -23..-14

Function:
- open preparation yard;
- bounty/route board;
- prep racks;
- supplies;
- regrouping.

Must preserve:
- 8 m Main Spine corridor centered X 0;
- clear northward view into Area 12.

### Area 12 — North Watch Gate & Trail Exit
Parent: S05

Final-reference frame:
- X -30..+30
- Z -36..-23

Fixed:
- Hunter Watch center -19,-27
- Supply Cache center +19,-27
- North Gate center 0,-35
- 8 m gate opening

Must preserve:
- trail continues north/top of image;
- settlement staging/Area 11 remains south/bottom;
- no South-Gate/civilian-arrival props.

## Final-image acceptance law

A future image can be labeled `FINAL_AREA_REFERENCE` only if:

1. north is up;
2. west/east are not mirrored;
3. all fixed buildings are inside their locked parcels;
4. streets/connectors enter and leave through the correct edges;
5. no neighboring building is moved into the area for composition;
6. no new building is invented where the blueprint has no parcel;
7. prop density does not block locked routes;
8. image remains pixel style;
9. generated text/logos are not accepted as final authored content;
10. area ID, image revision and blueprint revision are recorded.

## Current 12-image set

The current R001 images remain useful as:
- mood/reference;
- asset extraction;
- density studies;
- pixel-language studies.

They are **not final placement renders**.

A later R002/F001 pass will regenerate/refine each area against this spatial lock after model-sheet extraction is complete.

## Change control

If a final area needs more physical space:
- do not simply move objects in the image;
- change the master blueprint first;
- re-run geometric checks;
- update section/road/building ownership;
- then regenerate the affected final references.
