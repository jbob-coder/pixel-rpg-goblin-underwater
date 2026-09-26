# Settlement 01 — F002 to Graybox Binding Register

Status: ENGINEERING BRIDGE / DOCUMENTATION ONLY  
Created: 2026-09-26

## Purpose

Map the current creator-review F002 visual references into safe graybox implementation inputs.

This document prevents a common error:

**visual-reference detail must not silently become gameplay geometry, collision, state, or coordinates.**

Authority order for graybox work:

1. master layered settlement blueprint;
2. final spatial lock;
3. coordinate/connector registers;
4. building/model-sheet contracts;
5. this F002 binding register;
6. F002 images for visual composition only.

## Binding classes

### GEOMETRY_AUTHORITY

May drive primitive graybox dimensions because the value is already defined in the blueprint/model contracts.

### ANCHOR_AUTHORITY

May drive creation/naming of stable anchors already defined by documentation.

### VISUAL_GUIDE

May influence composition/silhouette only.

### ART_ONLY

Do not create gameplay/collision ownership from this detail.

---

# Area 01 — South Arrival Gate

Current review target:
`AREA_01_SOUTH_ARRIVAL_GATE_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- 8 m South Gate opening;
- South Gatehouse parcel;
- South Watch parcel;
- Main Spine continuation;
- perimeter wall/gate connector locations.

## ANCHOR_AUTHORITY
- gate center;
- inner arrival;
- outer arrival;
- guard/visitor anchors;
- gate-control anchor.

## VISUAL_GUIDE
- readable paired gate structures;
- arrival/security composition;
- lantern/banner hierarchy;
- civilian/logistics identity.

## ART_ONLY
- generated sign text;
- exact crate/cart placement;
- exact NPC count;
- decorative roof trim.

---

# Area 02 — Gate Barracks & Security

Current review target:
`AREA_02_GATE_BARRACKS_SECURITY_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- Arrival Guard/Barracks parcel centered -20,+23;
- open security yard;
- clear east/north connectors.

## ANCHOR_AUTHORITY
- GuardDuty;
- PatrolStart;
- Briefing;
- EquipmentUse;
- GuardIdle;
- A01/A03 road connectors.

## VISUAL_GUIDE
- compact barracks;
- briefing/security-yard hierarchy;
- equipment-rack edge language.

## ART_ONLY
- exact weapon arrangement;
- training prop count;
- exact guard poses.

---

# Area 03 — Caravan Yard / Visitor Staging

Current review target:
`AREA_03_CARAVAN_VISITOR_STAGING_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- Arrival Storage/Logistics parcel centered +20,+23;
- open visitor/logistics yard;
- west and north connectors.

## ANCHOR_AUTHORITY
- cart anchors;
- loading;
- water;
- visitor idle;
- wayfinding.

## VISUAL_GUIDE
- cart-perimeter staging;
- awning/trough identity;
- temporary civilian logistics.

## ART_ONLY
- exact cart design;
- exact luggage stacks;
- generated signage.

---

# Area 04 — Main Central Spine Road

Current review target:
`AREA_04_MAIN_CENTRAL_SPINE_ROAD_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- X -4..+4;
- Z -35..+33;
- 8 m width;
- Central Plaza crossing at Z 0;
- South/North gate continuity.

## ANCHOR_AUTHORITY
- section-boundary corridor anchors;
- orientation/minimap reference points.

## VISUAL_GUIDE
- surface rhythm;
- lighting/lantern cadence;
- settlement sightline.

## ART_ONLY
- individual paving marks;
- exact roadside clutter;
- NPC placement.

---

# Area 05 — Central Market Plaza

Current review target:
`AREA_05_CENTRAL_MARKET_PLAZA_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- bounds X -14..+14 / Z -14..+14;
- Main Spine X -4..+4;
- Cross Street Z -2.5..+2.5;
- four 4×3 m stall sockets outside both roads.

## ANCHOR_AUTHORITY
- Stall SW/SE/NW/NE;
- Notice;
- CivicWater;
- Event;
- Social;
- north/south/east/west connectors.

## VISUAL_GUIDE
- four-quadrant market identity;
- open central crossing;
- peripheral civic props.

## ART_ONLY
- exact goods;
- awning colors;
- NPC grouping;
- decorative tree species.

---

# Area 06 — Community Hall / Civic Core

Current review target:
`AREA_06_COMMUNITY_HALL_CIVIC_CORE_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- Community Hall center -24.5,0;
- footprint 8×10 m;
- east-facing entrance;
- West Frontage Lane relation.

## ANCHOR_AUTHORITY
- HallEntrance;
- Keeper;
- Notice;
- EventGather;
- Social;
- A05/A07 connectors.

## VISUAL_GUIDE
- civic silhouette;
- frontage court;
- notice/bench/tree balance.

## ART_ONLY
- roof trim;
- exact banner/sign graphics;
- exact social NPC count.

---

# Area 07 — West Residential Cluster

Current review target:
`AREA_07_WEST_RESIDENTIAL_CLUSTER_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- W02 center -24.5,-10;
- Community Hall center -24.5,0;
- W01 center -24.5,+10;
- house footprints 7×5.5 m;
- West Frontage Lane.

## ANCHOR_AUTHORITY
- W01/W02 entrances;
- resident idle;
- yard anchors;
- north/south/A06 connectors.

## VISUAL_GUIDE
- two compatible residence variants;
- quiet yard identity;
- low-density residential props.

## ART_ONLY
- laundry/garden detail;
- exact woodpile shapes;
- house-color differences.

---

# Area 08 — East Work Frontage / Worker Passage

Current review target:
`AREA_08_EAST_WORK_FRONTAGE_PASSAGE_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- frame X +14..+20.5 / Z -14..+14;
- East Frontage Lane;
- no new building parcels;
- north/south/center connector positions.

## ANCHOR_AUTHORITY
- WorkerIdle;
- ShiftChange;
- optional Bench;
- A05/A09/A10 connectors.

## VISUAL_GUIDE
- flush work-support edge detail;
- lantern/wayfinding cadence;
- worker pause pockets.

## ART_ONLY
- exact tools/coats;
- exact crate count;
- decorative wall-edge props.

---

# Area 09 — Smithy & Craft Quarter

Current review target:
`AREA_09_SMITHY_CRAFT_QUARTER_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- Smith center +24.5,0;
- footprint 6.6×6.4 m;
- west-facing entrance;
- clear service approach.

## ANCHOR_AUTHORITY
- SmithEntrance;
- Service;
- SmithWork;
- Customer;
- Forge;
- EquipmentDisplay;
- A05/A08/A10 connectors.

## VISUAL_GUIDE
- strong smith silhouette;
- forge glow;
- anvil/tool/equipment staging.

## ART_ONLY
- exact weapon models;
- exact ore/wood pile shapes;
- fire VFX.

---

# Area 10 — Storage / Workshop Yard

Current review target:
`AREA_10_STORAGE_WORKSHOP_YARD_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- Work Canopy center +24.5,-9.5;
- Smith center +24.5,0;
- Work Storage center +24.5,+9.5;
- east service-alley relation;
- two-pocket separation.

## ANCHOR_AUTHORITY
- StorageEntrance;
- Loading;
- WorkAnchor 01/02;
- Cart;
- MaterialRack;
- A08/A09 connectors.

## VISUAL_GUIDE
- open canopy;
- cart/loading identity;
- distinct north/south support pockets.

## ART_ONLY
- exact pallet/crate arrangement;
- exact material stacks;
- worker poses.

---

# Area 11 — North Hunter Staging Ground

Current review target:
`AREA_11_NORTH_HUNTER_STAGING_GROUND_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- frame X -30..+30 / Z -23..-14;
- Main Spine X -4..+4 remains clear;
- north connection to Area 12.

## ANCHOR_AUTHORITY
- BountyBoard;
- Prep 01/02;
- Supply;
- HunterIdle;
- A10/A12 connectors.

## VISUAL_GUIDE
- bounty/prep identity;
- warning banners;
- equipment-readiness hierarchy.

## ART_ONLY
- exact rack contents;
- target graphic;
- hunter equipment variants.

---

# Area 12 — North Watch Gate & Trail Exit

Current review target:
`AREA_12_NORTH_WATCH_GATE_TRAIL_EXIT_F002_LOCKED.png`

## GEOMETRY_AUTHORITY
- Hunter Watch center -19,-27;
- Supply Cache center +19,-27;
- North Gate center 0,-35;
- 8 m gate opening;
- trail continues north/top;
- Area 11 connection remains south/bottom.

## ANCHOR_AUTHORITY
- NorthGateCenter;
- Warden;
- Watch;
- Warning;
- TrailConnector;
- Return;
- A11 connector.

## VISUAL_GUIDE
- rugged hunt threshold;
- settlement→wilderness transition;
- weathered warning identity;
- vegetation/rock increase north of gate.

## ART_ONLY
- exact tree/rock placement;
- banner graphics;
- exact guard poses;
- decorative wall wear.

---

# Graybox implementation law

For Slice 01 and early graybox work:

Use only:
- primitive boxes/capsules/planes;
- exact documented parcel/bounds dimensions;
- stable IDs;
- stable connectors;
- stable anchors.

Do not implement from F002:
- final texture/material palette;
- decorative prop meshes;
- authored NPC density;
- final roof silhouettes;
- generated sign text.

## Promotion rule

A visual detail can become gameplay-relevant only after:
1. it receives a stable ID/owner;
2. geometry/collision is documented;
3. focused test exists;
4. implementation is verified.

Until then it remains presentation guidance only.
