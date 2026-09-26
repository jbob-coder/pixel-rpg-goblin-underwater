# Area 09 — Smithy & Craft Quarter

Status: FINAL_REFERENCE_GENERATED / SPATIAL_CHECK_PASS / CREATOR REVIEW PENDING
Parent section: `SET01_S04`  
Area ID: `SET01_A09_SMITHY_CRAFT_QUARTER`

## Purpose

Area 09 is the settlement's primary craft/service identity centered on the existing enterable smith.

Functions:
- smith service;
- visible forge/work activity;
- equipment display;
- future crafting interaction;
- transition between worker housing and storage/work yard.

## Current implemented anchor

The existing enterable smith remains the runtime reference:
- footprint about 6.6×6.4 m;
- real doorway;
- interior forge/anvil/bench;
- EntranceAnchor;
- UseAnchor;
- split roof behavior.

## Visual composition

Standalone pixel-art craft-quarter scene only.

Show:
- smith building as dominant structure;
- exterior forge/fire identity;
- anvil/worktable;
- equipment rack;
- ore/wood piles;
- small customer/waiting pocket;
- lanterns;
- work lane clear at edge.

Do not show:
- giant factory;
- multiple unrelated workshops;
- full storage yard;
- dense market stalls.

## Exterior work zone

Target:
- compact 10×10 m visible work apron around smith frontage.

Keep:
- real doorway clear;
- 2–3 m customer/service frontage;
- no material piles in main lane.

## Props

Required:
- anvil
- forge/fire source
- tool rack
- weapon/equipment display
- ore pile
- firewood pile
- worktable
- crate/material bin

## NPC density

Reference:
- Smith
- 1 optional helper
- 1–3 customers/workers maximum

## Anchors

Planned:
- `A09_SmithEntrance`
- `A09_SmithServiceAnchor`
- `A09_SmithWorkAnchor`
- `A09_CustomerAnchor`
- `A09_ForgeAnchor`
- `A09_EquipmentDisplayAnchor`
- `A09_Connector_A08`
- `A09_Connector_A10`
- `A09_Connector_A05`

## Collision

- smith follows current segmented building collision;
- large racks/anvil simple collision;
- small tool visuals presentation-only;
- forge effect does not own damage/gameplay unless future system explicitly adds it.

## Image brief

Generate only Area 09.

Desired view:
- high 3/4 deliberate pixel art;
- smith/craft identity obvious;
- compact work apron;
- visible real entrance;
- lane edge clear;
- no full settlement or infographic.

## Acceptance checklist

Approve only if:
- smith visually dominant;
- craft function immediately readable;
- work props organized;
- entrance/frontage not blocked;
- not factory-scale;
- genuine pixel art.


## Accepted reference artifact

Reference ID:
`REF_SET01_A09_SMITHY_CRAFT_QUARTER_R001`

Accepted pixel-art artifact:
- source file: `AREA_09_SMITHY_CRAFT_QUARTER_R001.png`
- dimensions: 1152×768
- bytes: 7,095
- SHA-256: `f3e3e7f446c4f59550a9d677cc382a258ef0374bf177c8c5ad262756ac4b5d7f`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Area References/AREA_09_SMITHY_CRAFT_QUARTER_R001.png`
- Library file ID: `libfile_4005c918494481919beab673e222d8dc`
- backing file ID: `file_00000000a2a881f6ba6db0742dbf86be`

Disposition:
- accepted as current Area 09 pixel-art reference;
- current enterable smith remains runtime/collision authority.


## Technical asset review / model sheets

Technical asset review:
`../AREA_ASSET_REVIEWS/AREA_09_SMITHY_CRAFT_QUARTER_ASSET_REVIEW.md`

Model-sheet package:
`../MODEL_SHEETS/AREA_09/`

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
`FINAL_REF_SET01_A09_F001`

Artifact:
- filename: `AREA_09_SMITHY_CRAFT_QUARTER_F001_LOCKED.png`
- dimensions: 597×624
- bytes: 4,654
- SHA-256: `077c802d2aca2c61f654919f9cdb74cd38a68d3c277e4aca5ded32d4c5352ad3`

Persisted Library archive:
- path: `/Pixel RPG/Settlement 01/Final Area References/AREA_09_SMITHY_CRAFT_QUARTER_F001_LOCKED.png`
- Library file ID: `libfile_49f0b232fe948191b3fa618a6710e7ee`
- backing file ID: `file_0000000043a081f68f693571c0c7264a`

Spatial validation:
- north = image top;
- frame uses X +20.5..+30 / Z -5..+5;
- Smith remains fixed at center +24.5,0;
- Smith footprint remains 6.6×6.4 m;
- west-facing entrance remains on the Area 08/frontage side;
- no duplicate forge building is introduced;
- anvil, worktable, rack and material piles remain outside the building footprint and do not block the entrance.

Disposition:
`SPATIAL_CHECK_PASS`

Creator visual approval:
`PENDING`

Runtime implementation:
`NOT STARTED`
