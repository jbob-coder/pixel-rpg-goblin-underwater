# Area 01 — South Arrival Gate

Status: TECHNICAL_REFERENCE_REVIEWED / MODEL_SHEET_READY / FINAL REFERENCE REGEN REQUIRED
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
