# Area 01 — South Arrival Gate

Status: FINAL_REFERENCE_GENERATED / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S01`  
Area ID: `SET01_A01_SOUTH_ARRIVAL_GATE`

## Role

Civilian/traveler entry threshold into Settlement 01.

Primary functions:
- first visual impression;
- settlement security;
- traveler orientation;
- registration/greeting;
- arrival supplies;
- clear transition into the Main Central Spine.

## Visual reference

Reference asset ID:
`REF_SET01_A01_SOUTH_ARRIVAL_GATE_R001`

Generated source filename:
`south_arrival_gate_outpost.png`

Persisted archive:
- Library path: `/Pixel RPG/Settlement 01/Area References/AREA_01_SOUTH_ARRIVAL_GATE_R001.png`
- Library file ID: `libfile_5608f2d202188191a3a5ae202479a2e6`
- backing file ID: `file_000000001a0081f6996164362a0ee23f`
- MIME: `image/png`

Archived derivative:
- dimensions: 1448×1086
- indexed palette: 128 colors
- bytes: 840,924
- SHA-256: `fb9ab61c5b03aa2ccc790cd8580be4770df1a33e847c4ff5d0c66650686ad792`

The archived derivative preserves the generated composition while reducing storage size.

## Reference interpretation

Useful observed/reference concepts:
- strong central gate corridor;
- paired guard/watch structures;
- registration/supply identity on both sides;
- carts/travelers reinforce arrival function;
- sign/wayfinding cluster;
- banners and lanterns produce readable gate identity;
- settlement road continues clearly beyond the gate.

Not authoritative:
- exact wall shape;
- exact tower scale;
- exact signage text;
- number of guards/travelers;
- water/rock perimeter;
- any exact building dimensions shown only visually.

## Blueprint relationship

Area 01 must preserve:
- 8 m South Gate opening;
- Main Central Spine continuity;
- South Gatehouse/Watch parcel clearances;
- no permanent clutter in the gate corridor.

Relevant building blueprints:
- `../BUILDING_BLUEPRINTS/BLD_03_SOUTH_GATEHOUSE.md`
- `../BUILDING_BLUEPRINTS/MODULAR_WALL_GATE_KIT.md`

## Review decisions

Keep:
- readable gate hierarchy;
- arrival administration;
- traveler/cargo staging;
- strong central sightline;
- pixel-art visual density.

Refine before runtime:
- reduce NPC count for mobile performance;
- keep actual building footprints aligned to documented parcel sizes;
- simplify perimeter to match Settlement 01 terrain;
- replace generated text with authored in-game UI/signage;
- keep collision independent.

## Next state

After creator/reference review:
`REFERENCE_REVIEWED`

Then extract:
- gatehouse facade/model sheet;
- watch module;
- arrival booth/registration props;
- wayfinding sign;
- cart/supply prop set;
- gate/wall visual modules.


## Asset extraction and model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_01_SOUTH_ARRIVAL_GATE_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_01/`

Current state:
- reference generated and archived;
- technical reference review passed;
- primary model-sheet contracts ready;
- runtime implementation not started;
- device visual verification not started.


## Final-reference placement authority

`FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`

The archived R001 image remains a concept/asset reference.

A later final reference must be regenerated against the locked coordinates, orientation, neighbor edges, streets and building parcels before runtime placement is approved.


## Final position-locked reference F001

Reference ID:
`FINAL_REF_SET01_A01_F001`

Artifact:
- filename: `AREA_01_SOUTH_ARRIVAL_GATE_F001_LOCKED.png`
- dimensions: 1260×462
- bytes: 6,826
- SHA-256: `986fccf0c58ee10695352f7fa5ac653f1fdb554deaf47d73a7673960c00d46cf`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_01_SOUTH_ARRIVAL_GATE_F001_LOCKED.png`
- Library file ID: `libfile_4cd0010b75b48191af53be76338799dd`
- backing file ID: `file_00000000594c81f68221331225fd3565`

Spatial validation:
- north = image top;
- south = image bottom;
- west = image left;
- east = image right;
- frame uses X -14..+14 / Z +25..+34;
- Gatehouse W uses X -12..-4 / Z +25.5..+32.5;
- Watch E uses X +5..+11 / Z +26..+32;
- South Gate remains centered on X 0 / Z +33;
- 8 m central gate corridor X -4..+4 remains open;
- Main Spine continues north through the center;
- permanent props remain outside the locked gate corridor.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`
