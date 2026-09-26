# Area 08 — East Work Frontage / Worker Passage

Status: FINAL_REFERENCE_GENERATED / F002 CURRENT REVIEW TARGET / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S04`  
Area ID: `SET01_A08_EAST_WORK_FRONTAGE`

## Correction

The earlier Area 08 concept described two worker houses.

That placement is superseded.

Reason:
the approved S04 geometry already contains:

- Smith at +24.5,0;
- Work Storage at +24.5,+9.5;
- Work Canopy at +24.5,-9.5;
- East Frontage Lane centered X +16.25;
- east service alley near X +28.5.

Adding two 6×5 m worker houses would overlap the approved work-district parcels or circulation.

## Final physical role

Area 08 is now the **East Work Frontage / Worker Passage**.

Locked frame:
- X +14..+20.5
- Z -14..+14

It is a connective, mostly open area between:
- Area 05 Central Plaza to the west;
- Area 09 Smithy to the east/center;
- Area 10 work/storage pockets north and south.

## Functions

- frontage circulation;
- short worker idle/rest pockets at building edges;
- shift-change passage;
- flush tool/coat/storage edge props;
- lanterns;
- wayfinding;
- no tree or freestanding bench unless a measured frontage pocket proves enough clearance;
- no new permanent residence buildings.

## Fixed circulation

East Frontage Lane:
- center X +16.25
- width 4.5 m

The lane remains physically clear.

## Planned anchors

- `A08_WorkerIdle_01..04`
- `A08_ShiftChangeAnchor`
- `A08_BenchAnchor`
- `A08_Connector_A05`
- `A08_Connector_A09`
- `A08_Connector_A10_N`
- `A08_Connector_A10_S`

## Props

Allowed:
- lantern;
- wall-edge tool/coat rack;
- small flush crate/storage edge;
- wayfinding sign;
- optional narrow wall bench only if measured clearance remains >=1.5 m.

Not allowed:
- residence buildings;
- large warehouse;
- market stalls;
- material piles blocking frontage;
- smith forge duplicated here.

## Existing R001 reference

Reference ID:
`REF_SET01_A08_EAST_WORKER_HOUSING_R001`

Archive remains preserved for:
- pixel-language ideas;
- small-yard/worker-life props;
- housing visual ideas that may be reused elsewhere later.

It is **not** a final placement reference for Area 08.

Disposition:
`CONCEPT_REFERENCE_SUPERSEDED_FOR_FINAL_POSITION`

Future final Area 08 reference must be regenerated from:
`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`.

## Collision

- frontage floor owned by ground;
- benches/racks simple collision only if substantial;
- small props presentation-only;
- no new building collision.

## Acceptance

Final Area 08 must:
- show the fixed frontage lane;
- keep Smith/Area 09 east of it;
- preserve connections north/south to Area 10;
- contain no new residence buildings;
- remain pixel style.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_08_EAST_WORK_FRONTAGE_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_08/`

Final-reference placement authority:
`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

Current state:
- R001 concept reference preserved;
- technical asset review complete;
- primary model-sheet contracts ready;
- final position-locked reference still requires regeneration;
- runtime implementation not started;
- device visual verification not started.


## Final position-locked reference F001

Reference ID:
`FINAL_REF_SET01_A08_F001`

Artifact:
- filename: `AREA_08_EAST_WORK_FRONTAGE_PASSAGE_F001_LOCKED.png`
- dimensions: 396×1428
- bytes: 6,167
- SHA-256: `23dd95d62a4b2fea7f533d9a2b9b8478f495860aa25ccac96ea6a8cfb89e8ae6`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_08_EAST_WORK_FRONTAGE_PASSAGE_F001_LOCKED.png`
- Library file ID: `libfile_938f7952b3b08191b42740721cf00b4d`
- backing file ID: `file_00000000438c81f6aff450d1f3e38cbf`

Spatial validation:
- north = image top;
- frame uses X +14..+20.5 / Z -14..+14;
- East Frontage Lane occupies X +14..+18.5;
- remaining east apron is only about 2 m inside this frame;
- no residence building is present;
- only flush tool/storage/shift props occupy the apron;
- west connector to Area 05 and east connectors to Areas 09/10 remain readable;
- north/south passage remains open.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`


## Creator-review revision F002

Reason:
- F001 passed spatial checks but was too sparse and diagram-like for the intended worker-frontage/pass-through identity.

Reference ID:
`FINAL_REF_SET01_A08_F002`

Artifact:
- filename: `AREA_08_EAST_WORK_FRONTAGE_PASSAGE_F002_LOCKED.png`
- dimensions: 540×1860
- bytes: 10,025
- SHA-256: `12facdfbf68800190dc1378b146c941e878783215570c135b160302f74468acd`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_08_EAST_WORK_FRONTAGE_PASSAGE_F002_LOCKED.png`
- Library file ID: `libfile_efa4f553935c8191be7fad6f89f02020`
- backing file ID: `file_00000000b2f881f6945c004df7954574`

F002 preserves:
- north-up orientation;
- frame X +14..+20.5 / Z -14..+14;
- East Frontage Lane remains the dominant open circulation strip;
- no new residence buildings are introduced;
- west connector to Area 05 remains readable;
- center/east connector to Area 09 remains readable;
- north/south connectors to Area 10 remain readable;
- work-support detail stays flush to the east apron.

F002 improves:
- worker-frontage identity;
- tool/coat/storage edge detail;
- shift/rest points;
- lantern/wayfinding readability;
- pixel-art depth;
- visual connection between Areas 09 and 10 without blocking circulation.

Spatial status:
`SPATIAL_CHECK_PASS_BY_CONSTRUCTION`

Technical art review:
`F002 PREFERRED OVER F001`

Creator final visual approval:
`PENDING`

F001 remains archived for provenance.
