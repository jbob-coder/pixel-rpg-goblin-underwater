# Settlement 01 — 12-Area Reference Register

Status: TECHNICAL EXTRACTION COMPLETE / F002 ART REVISION PASS COMPLETE / CREATOR REVIEW PENDING  
Created: 2026-09-25

This register is the single lookup table for the twelve separately generated Settlement 01 area references.

## Production rule

Each area was handled separately:

`PLAN → GENERATE ONE IMAGE → ARCHIVE → RECORD SHA/LIBRARY ID → NEXT AREA`

No area image replaces coordinate, collision, building, state or section authority.

## Reference register

| Area | Area name | Documentation | Reference state | Library file ID | SHA-256 |
|---|---|---|---|---|---|
| 01 | South Arrival Gate | `AREA_01_SOUTH_ARRIVAL_GATE.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_5608f2d202188191a3a5ae202479a2e6` | `fb9ab61c5b03aa2ccc790cd8580be4770df1a33e847c4ff5d0c66650686ad792` |
| 02 | Gate Barracks & Security | `AREA_02_GATE_BARRACKS_SECURITY.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_d23b6419e71481919403009dfe6d009b` | `b62d64add0f57be79696a2e0347fbc21dbe4aebd04bfe1115ca23e95700c9600` |
| 03 | Caravan Yard / Visitor Staging | `AREA_03_CARAVAN_VISITOR_STAGING.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_13295846ca3c819196a0f8dc020dd388` | `5ba054d60d69d3cbd6a4365850a6fd4617ae2d3bb824936a4faed72ff9bd65f3` |
| 04 | Main Central Spine Road | `AREA_04_MAIN_CENTRAL_SPINE_ROAD.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_19a66f2318a48191a67d3585c113a31d` | `0be02d5640aac5293738bcc4db2b8f09d795e31b699e8367fdb8942564967442` |
| 05 | Central Market Plaza | `AREA_05_CENTRAL_MARKET_PLAZA.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_0486cb5d89ac8191a345de15ba8d976e` | `f89b2113a7a90647fd53096c60649674ff4f832c89213a270d9db5b533409176` |
| 06 | Community Hall / Civic Core | `AREA_06_COMMUNITY_HALL_CIVIC_CORE.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_4930f61027088191b60af81747b41a76` | `9d7e800d7c71cfb3ead52a28d45b12d7589ba5e44146775fca9e2a80c017069a` |
| 07 | West Residential Cluster | `AREA_07_WEST_RESIDENTIAL_CLUSTER.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_9482f1206518819194a4b7f6f73d9c1f` | `7795764a2b82c184dfde27f5f4979fc267564b559ebbd278d89d03ec4e1971d6` |
| 08 | East Work Frontage / Worker Passage | `AREA_08_EAST_WORKER_HOUSING.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_d74938a003188191b4f08185c552531a` | `148b0763fb03afb04a7f2795a3bcf16b0a7ea9a14048e141fc28e7310ce4b723` |
| 09 | Smithy & Craft Quarter | `AREA_09_SMITHY_CRAFT_QUARTER.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_4005c918494481919beab673e222d8dc` | `f3e3e7f446c4f59550a9d677cc382a258ef0374bf177c8c5ad262756ac4b5d7f` |
| 10 | Storage / Workshop Yard | `AREA_10_STORAGE_WORKSHOP_YARD.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_ed59a2812eb08191ae8cd434677811e0` | `8e9bd95f377c8917bd44103c1c0a754b0fc79ae06dc198ddfd3243cc2f98a680` |
| 11 | North Hunter Staging Ground | `AREA_11_NORTH_HUNTER_STAGING_GROUND.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_0bb6bce88c988191818a153a1f206df2` | `63afae7b08b3069a0b74deec359061f1437188d12f6672b5b1965ff241aa8bc0` |
| 12 | North Watch Gate & Trail Exit | `AREA_12_NORTH_WATCH_GATE_TRAIL_EXIT.md` | FINAL_REF_GENERATED / SPATIAL_PASS / CREATOR_REVIEW_PENDING | `libfile_5ccb9754dd288191ab6e1084513dab9b` | `72d1d8f941886a21809e8e148f3212b38593d010a34fe0eba4768de9758291f0` |

## Library folder

`/Pixel RPG/Settlement 01/Area References/`

Area 02 canonical R001 archive:
`AREA_02_GATE_BARRACKS_SECURITY_R001.png`

The accidental duplicate-safe `(1)` and `(2)` copies were removed on 2026-09-26. Library IDs remain the stable lookup identity.

## Current review state

Technical extraction status:
- **12 / 12 areas technically reviewed**;
- **12 / 12 have non-empty model-sheet packages**;
- **12 / 12 R001 images remain concept/reference-only**;
- **12 / 12 F001 final position-locked references generated**;
- **12 / 12 F001 spatial checks PASS**;
- **0 / 12 creator-final-visual approvals recorded**;
- **0 / 12 runtime implementations started from this reference pass**.

Area 08 note:
- old worker-housing R001 preserved for concept/prop ideas;
- final Area 08 is East Work Frontage / Worker Passage;
- old house placement is superseded.

Final placement authority:
`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

## Next pass

The technical review/model-sheet extraction gate is already complete.

Next gate is **creator/art visual review of the F001 set**.

Review each final reference for:
- pixel-style consistency;
- first-person readability;
- area identity;
- density/clutter;
- neighbor/connector readability;
- landmark silhouette;
- mismatch with intended mood or original-IP direction.

Creator-approved areas may then advance to runtime graybox planning. A creator rejection produces an F002 revision while preserving F001 provenance.


## Asset-extraction progress

Verified 2026-09-26:

- **12 / 12 area asset-review documents exist**;
- **12 / 12 model-sheet directories are non-empty**;
- Area 01: 4 model contracts + README;
- Area 02: 4 model contracts + README;
- Area 03: 4 model contracts + README;
- Area 04: 3 model contracts + README;
- Area 05: 4 model contracts + README;
- Area 06: 3 model contracts + README;
- Area 07: 4 model contracts + README;
- Area 08: 3 model contracts + README;
- Area 09: 4 model contracts + README;
- Area 10: 4 model contracts + README;
- Area 11: 4 model contracts + README;
- Area 12: 4 model contracts + README.

Technical extraction/model-sheet phase is complete.


## Final-reference production order

Generate one final reference at a time, north-up and coordinate-locked:

1. Area 01 South Arrival Gate
2. Area 02 Gate Barracks & Security
3. Area 03 Caravan Yard / Visitor Staging
4. Area 04 Main Central Spine Road
5. Area 05 Central Market Plaza
6. Area 06 Community Hall / Civic Core
7. Area 07 West Residential Cluster
8. Area 08 East Work Frontage / Worker Passage
9. Area 09 Smithy & Craft Quarter
10. Area 10 Storage / Workshop Yard
11. Area 11 North Hunter Staging Ground
12. Area 12 North Watch Gate / Trail Exit

Each final image must be checked against the spatial lock before the next area advances.


## Final spatial-reference progress

Final references generated: **12 / 12**

- Area 01 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 02 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 03 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 04 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 05 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 06 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 07 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 08 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 09 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 10 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 11 — F001 generated, archived, spatial check PASS, creator review pending.
- Area 12 — F001 generated, archived, spatial check PASS, creator review pending.


## Final-reference generation pass complete

Final position-locked references:
- **12 / 12 generated**
- **12 / 12 archived**
- **12 / 12 spatial-check PASS**
- **0 / 12 creator-final-visual approvals recorded**
- **0 / 12 runtime implementations started from this reference pass**

Archive folder:
`/Pixel RPG/Settlement 01/Final Area References/`

The F001 set is now the spatially controlled visual-reference layer.

Next gate:
creator/art review may accept or request revisions per area. Runtime graybox/build work must still use the master coordinates, model-sheet contracts, collision rules and section ownership; an image alone never becomes runtime authority.


## F002 technical-art revision status

Technical art review found the original F001 set spatially valid but visually too flat/diagram-like in several areas.

A dedicated F002 pass was completed while preserving every area's spatial lock.

Current creator-review state:
- **12 / 12 areas have F002 current review targets**;
- **12 / 12 F001 references remain archived for provenance**;
- **12 / 12 F002 references preserve the locked orientation/parcel/connector rules**;
- **0 / 12 creator-final approvals recorded**;
- runtime implementation remains not started from the visual-reference layer.

The authoritative current creator-review filenames and Library IDs live in:
`CREATOR_VISUAL_REVIEW_QUEUE_2026-09-26.md`.

F002 changes are visual/art-quality revisions only. Coordinate, building, collision and connector authority remain owned by the master blueprint and spatial-lock documents.
