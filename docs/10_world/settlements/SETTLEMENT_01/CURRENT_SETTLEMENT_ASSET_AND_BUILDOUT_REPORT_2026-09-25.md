# Pixel RPG — Settlement 01 Current Assets and Five-Section Buildout Report

Status: CURRENT RUNTIME INVENTORY + PROVISIONAL FIVE-SECTION BLUEPRINT  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

Audited runtime baseline:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

## Purpose

Record:

- what Settlement 01 already has in the live game;
- which assets already exist;
- what is still missing;
- how the approved five-section settlement should be organized;
- provisional settlement size;
- street widths;
- corner functions;
- building/service placement;
- where photo-reference reverse engineering can supply missing assets.

This document separates **current runtime fact** from **provisional planned blueprint**.

---

# 1. Current live world size

Current physical ground owner:

`game/scripts/presentation/pixel_rpg/world_base_001.gd`

Current ground:

- width X: **46 m**;
- depth Z: **78 m**;
- center: `(0, -0.35, -18)`;
- current X extent: approximately **-23..+23 m**;
- current Z extent: approximately **-57..+21 m**.

This 46×78 m ground includes both:

- the compact settlement slice;
- the north trail/Monster approach.

It is **not** the final five-section settlement footprint.

## Current main path

Street:

- width: **6.2 m**;
- length: **34 m**;
- center Z: **+2 m**.

Trail:

- width: **4.2 m**;
- length: **34 m**;
- center Z: **-31 m**.

Current street and trail are presentation surfaces. Ground remains floor-collision authority.

---

# 2. What is already in the live settlement

Current compact settlement/world already includes:

- first-person Hunter spawn/current movement space;
- main Street;
- north Trail;
- two generic settlement buildings;
- one market stall;
- enterable smith;
- settlement gate;
- Gate Warden;
- gate collision proxies;
- service clutter;
- two lantern posts;
- banner post;
- signpost;
- fence segments;
- street/trail surface details;
- trail pines;
- vegetation clusters;
- rock clusters;
- large collidable TrailRockL;
- Mudcrest presentation;
- separate Mudcrest gameplay/collision alias;
- canonical first-person hands/ViewModel.

## Current important placements

Current source places:

- generic building A: approximately `(-7, 8.5 Z)`;
- market: approximately `(+7, +6 Z)`;
- smith: approximately `(-7.4, -1.5 Z)`;
- generic building B: approximately `(+7.5, -3 Z)`;
- Gate Warden: approximately `(-2.6, -6.2 Z)`;
- current gate: `(0, -10 Z)`;
- signpost: approximately `(+2.9, -13 Z)`;
- fences: approximately `Z -16.5` and `-19`;
- north trail: around `Z -31`;
- Mudcrest: around `Z -49`.

The current gate at negative Z functions most naturally as the **north Hunter exit/trail transition** in the future five-section topology.

---

# 3. Current enterable smith

Current smith owner:

`game/scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd`

Current dimensions:

- footprint: **6.6 × 6.4 m**;
- wall height: **3.3 m**;
- doorway: **1.8 m wide × 2.4 m high**;
- interior usable region: approximately **6.0 × 5.8 m**.

Already implemented:

- real doorway;
- segmented collision;
- interior floor;
- forge;
- anvil;
- bench;
- tool rack;
- smith sign;
- EntranceAnchor;
- UseAnchor;
- split roof;
- first-person interior/roof handling.

Missing:

- smith NPC/service runtime;
- materials/inventory integration;
- recipe selection;
- crafting output;
- durable crafting/economy state.

The smith is the best existing blueprint for future important buildings.

---

# 4. Current runtime asset inventory

The current `game/assets/` tree contains runtime/reference-support assets across these major categories.

## First-person / characters

Current:

- canonical first-person hands PNG;
- first-person ViewModel;
- Gate Warden visual;
- Hunter visual.

## Monsters/creatures

Current:

- Mudcrest presentation scene;
- older Mudcrest Raker visual scene;
- Head Sweep telegraph;
- Tail Sweep telegraph.

## Environment / starting area

Current reusable scenes include:

- settlement gate;
- market stall;
- service clutter;
- signpost;
- lantern post;
- fence;
- banner post;
- vegetation cluster;
- rock cluster;
- trail pine;
- trail rock visual;
- settlement building façade details;
- street surface details;
- trail surface details;
- smith forge detail;
- smith anvil detail;
- smith bench detail;
- smith frontage detail.

## Direct concept-derived PNGs

Current Pack 011 includes seven direct PNG presentation assets:

- gate banner left;
- gate banner right;
- smith banner;
- forge panel;
- signpost;
- water trough;
- fence segment.

## Concept-derived material textures

Current Pack 010 provides material-family textures for:

- wood beam;
- stone block;
- packed dirt;
- foliage;
- roof shingle;
- banner cloth;
- dark metal.

## Current asset-tree count

At the documentation-branch audit:

- `game/assets/environment/`: 28 files;
- `game/assets/characters/`: 7 files including first-person source records;
- `game/assets/effects/`: 2;
- `game/assets/creatures/`: 1;
- `game/assets/monsters/`: 1;
- `game/assets/textures/`: 8 files including manifest.

These counts include manifests/source records where they live under the runtime asset tree; they are not a count of unique visible objects on screen.

---

# 5. Missing settlement assets/systems

The approved five-section settlement still needs substantial content.

## Buildings still needed

Priority building families from current issues:

- South Gate / arrival gatehouse;
- Community Hall / Local Lodge;
- 2–3 small residences;
- utility storage;
- watchpost;
- work canopy;
- additional market-stall variants;
- second building using the reusable building contract.

Important buildings should be:

exterior
→ real doorway
→ usable interior
→ explicit collision
→ anchors.

Do not create important fake-door buildings.

## Street/civic assets still needed

Recommended missing/reusable sets:

- street corner marker/curb or edge treatment;
- drainage ditch/stone gutter where visually appropriate;
- benches;
- public notice board;
- market awnings;
- cart/loadout staging;
- crate/barrel variants;
- supply racks;
- firewood/ore piles;
- storage racks;
- hunter preparation racks;
- exterior worktables;
- additional lantern variants;
- settlement wall segments;
- corner wall/tower pieces;
- south-gate guard booth/gatehouse modules.

## NPC/world-life content still needed

- local NPC building ownership;
- stable NPC anchors;
- simple schedules;
- 2–3 supporting residence slots;
- abstract state for unloaded sections;
- community/social interaction anchors.

No expensive runtime generative AI is required.

## Systems still missing

- SectionDefinition / SectionInstance;
- five-section migration;
- conservative section streaming;
- generalized reusable building standard;
- interaction event boundary;
- current-world persistence;
- full inventory UI/runtime;
- smith crafting/service;
- audio foundation;
- final lighting/readability pass;
- current-world combat positioning graph;
- physical-device performance/heat/install acceptance.

---

# 6. Approved five-section topology

Current issue #4 defines:

- **S01 South Gate / Arrival**
- **S02 Central Plaza / Market**
- **S03 West Residential / Local NPC building**
- **S04 East Work District / Smith + storage**
- **S05 North Hunter Exit / trail transition**

This topology is approved.

Exact final runtime bounds are not yet implemented.

---

# 7. Provisional final settlement footprint

## Recommended planning target

**60 m wide × 70 m north-south**

Approximate enclosed footprint:

**4,200 m²**

Coordinate convention for planning:

- X negative = west;
- X positive = east;
- Z positive = south/arrival;
- Z negative = north/hunter trail.

Provisional settlement envelope:

- X: **-30..+30 m**
- Z: **-36..+34 m**

This is a **planning target**, not a current runtime constant.

Why this size:

- stays compact enough for mobile walking;
- allows five identifiable districts;
- allows real interiors;
- supports a 7–8 m main spine;
- supports 4.5–5 m secondary streets;
- leaves room for wall/gate/corner identity;
- is large enough for Community Hall + residences + smith/storage without becoming an empty open world.

Current 46 m width proves that a compact settlement already reads in first person. The proposed 60 m width adds room for proper side districts while keeping the settlement small.

---

# 8. Street standard

## Main Hunter Spine

Target:

- width: **7–8 m**;
- direction: South Gate → Central Plaza → North Hunter Exit.

Functions:

- primary pedestrian route;
- carts/loadout;
- landmark sightline;
- easiest navigation route;
- market/plaza access;
- hunt-departure route.

## Secondary streets

Target:

- width: **4.5–5 m**.

Use:

- Central Plaza → West Residential;
- Central Plaza → East Work District;
- residence/local circulation;
- smith/storage access.

## Service alleys

Target:

- width: **2.5–3 m**.

Use:

- rear smith access;
- storage delivery;
- firewood/ore/material piles;
- utility access;
- NPC-only/lightweight shortcuts.

## Building frontage clearance

Target:

- generally **2–3 m** between doorway and primary traffic route;
- more where queuing/work interactions are expected.

This prevents first-person doors from opening directly into a congested movement lane.

---

# 9. Section blueprint

## S01 — South Gate / Arrival

Approximate planning zone:

- southern band around Z **+20..+34**.

Purpose:

- civilian/player arrival;
- settlement identity;
- initial orientation;
- guard/watch presence;
- notice/signage;
- first clear sightline to the central spine.

Recommended content:

- South Gate/gatehouse;
- guard/watchpost;
- arrival notice board;
- visitor/cart staging;
- water trough;
- lanterns;
- banners;
- small storage/crate area;
- clear spawn/arrival pocket.

### South-west corner

Recommended:

- guard booth/watch structure;
- notice board;
- stacked supply crates;
- wall access or watch stair visual.

### South-east corner

Recommended:

- water trough;
- cart/loadout parking;
- visitor/arrival supplies;
- lantern/signpost.

Do not overcrowd both corners; one should remain visually open for navigation.

---

## S02 — Central Plaza / Market

Approximate planning center:

- around the middle of the settlement;
- recommended plaza target roughly **28 × 24 m**.

Purpose:

- settlement navigation anchor;
- social center;
- market/service visibility;
- crossroads between every other section.

Recommended content:

- 3–5 market stall positions;
- public notice/bounty board;
- benches;
- water/well/trough feature;
- civic marker/statue/sign structure if lore supports it;
- food/general-goods stall;
- open circulation space;
- local NPC idle/conversation anchors.

### Plaza south-west corner

- produce/general-goods stall;
- bench;
- shade/awning.

### Plaza south-east corner

- food/service stall;
- crate/barrel staging;
- lantern.

### Plaza north-west corner

- route toward Community Hall/residences;
- local notice/event board.

### Plaza north-east corner

- route toward smith/work district;
- equipment/material display.

The plaza center should remain mostly open.

---

## S03 — West Residential / Local NPC Building

Approximate planning zone:

- western middle district.

Purpose:

- local life;
- Community Hall / Local Lodge;
- residents;
- social/event foundation.

Required from issue #7:

- real Community Hall/Local Lodge entrance/interior;
- resident/local conversation anchors;
- future event/social hooks;
- **2–3 residence slots**;
- stable NPC section ownership.

Recommended content:

- Community Hall;
- 2–3 compact houses;
- shared yard;
- benches;
- laundry/woodpile/garden-style low-cost life props where appropriate;
- small residential lane;
- local lanterns/signage.

### West-south corner

- small residence;
- shared yard/storage.

### West-central corner

- Community Hall frontage.

### West-north corner

- residence + small garden/woodpile;
- transition toward Hunter Exit.

Avoid excessive props that turn residential space into clutter.

---

## S04 — East Work District

Approximate planning zone:

- eastern middle district.

Purpose:

- smith/work/storage;
- visible production activity;
- equipment/material logistics.

Existing current smith moves here conceptually.

Required/desired content:

- enterable smith;
- utility storage;
- work canopy;
- ore/wood/material staging;
- equipment racks;
- service alley;
- cart/loading point.

### East-south corner

- storage shed;
- cart/loading pocket;
- material crates.

### East-central corner

- smith frontage;
- smith sign;
- exterior worktable;
- forge identity.

### East-north corner

- work canopy;
- material yard;
- hunter equipment staging.

Smith service logic remains separate from the building scene.

---

## S05 — North Hunter Exit / Trail Transition

Approximate planning zone:

- northern band around Z **-18..-36**.

This section should absorb/replace the role currently served by the existing gate at Z -10 and the trail extending north.

Purpose:

- explicit departure from safe settlement;
- hunt preparation;
- warning/transition;
- trail/world connector.

Recommended content:

- Hunter Gate;
- Gate Warden/watch NPC anchor;
- signpost;
- hunt/bounty board;
- warning banners;
- lantern pair;
- fence/wall transition;
- hunter supply rack;
- preparation bench;
- small watchpost;
- clear trail entrance.

### North-west corner

- hunter preparation rack;
- watchpost;
- bounty/route board.

### North-east corner

- emergency/supply cache;
- lantern/signage;
- fence/wall termination.

Beyond the gate:

- trees;
- vegetation;
- rocks;
- narrower trail;
- visual reduction in settlement props;
- Monster/tracking world.

---

# 10. Main circulation map

Recommended logical flow:

`SOUTH GATE`
→ Main Hunter Spine
→ `CENTRAL PLAZA`
→ west branch to `RESIDENTIAL / COMMUNITY HALL`
→ east branch to `SMITH / WORK DISTRICT`
→ Main Hunter Spine north
→ `HUNTER EXIT`
→ Trail.

Every major section should be reachable without menu teleportation.

The central plaza should visually reveal at least:

- route south;
- route north;
- west local-life identity;
- east smith/work identity.

---

# 11. Wall/corner strategy

Outer settlement corners should be functional landmarks, not empty decorative dead zones.

Recommended corner language:

- south-west: arrival security;
- south-east: arrival logistics;
- west-middle: local/community life;
- east-middle: production/work;
- north-west: hunt preparation;
- north-east: supply/warning;
- plaza corners: market/social/service identity.

Wall segments should be modular and may use:

- straight segment;
- inward/outward corner;
- gate connector;
- watch platform connector;
- broken/utility opening where intentional.

Do not make the settlement wall a single huge collision box.

---

# 12. Asset reuse strategy

Already available assets should be reused before creating new ones.

Examples:

Existing gate:
→ prototype North Hunter Exit identity.

Existing market stall:
→ base for 3–5 variants through material/sign/prop changes.

Existing lantern:
→ street/plaza/gate variants.

Existing fence:
→ trail transition + yard boundaries.

Existing banner:
→ gate/plaza identity.

Existing signpost:
→ wayfinding.

Existing smith:
→ S04 anchor building.

Existing building façade:
→ temporary generic-house presentation only until real building blueprint replaces solid-box collision.

Existing pines/rocks/vegetation:
→ S05/trail transition.

---

# 13. Photo-reference reconstruction targets

The new photo-reference reverse-engineering guide should be used to create blueprint/model sheets for missing objects.

Highest-value targets:

1. Community Hall / Local Lodge;
2. compact residence;
3. South Gate gatehouse;
4. utility storage shed;
5. work canopy;
6. watchpost;
7. market-stall variants;
8. cart/loading props;
9. public notice board;
10. benches;
11. storage racks;
12. modular wall/corner pieces.

Preferred reference package for a building:

- front;
- side;
- rear;
- roof/high-angle;
- doorway;
- interior;
- scale anchor.

Single-photo assets remain approximate and must be labeled inferred where appropriate.

---

# 14. What should be generated first

Recommended visual/asset production order:

## Batch A — settlement structure

- Community Hall blueprint;
- residence blueprint;
- utility storage blueprint;
- gatehouse/watchpost blueprint;
- modular wall/corner kit.

## Batch B — street identity

- market stall variants;
- notice board;
- benches;
- cart/loadout staging;
- lantern/sign variants.

## Batch C — work district

- work canopy;
- material rack;
- ore/wood piles;
- storage crates;
- exterior smith work props.

## Batch D — residential life

- yard props;
- low-detail household storage;
- garden/woodpile variants;
- seating.

## Batch E — north hunt transition

- hunter prep rack;
- route/bounty board;
- warning sign/banner;
- supply cache;
- gate transition variants.

---

# 15. Implementation sequence

Do not build all five sections at once.

Recommended order follows current issue dependencies:

1. finish bounded geometry/collision ownership work (#2);
2. define SectionDefinition / SectionInstance (#3);
3. formalize reusable building blueprint (#6);
4. map current live objects into five-section ownership (#4);
5. build second real enterable building;
6. add Community Hall/residence anchors (#7);
7. update streets/plaza;
8. add section streaming conservatively (#5);
9. add interaction/persistence;
10. expand smith/inventory/crafting later.

---

# 16. Current versus planned summary

## Already implemented

- compact settlement slice;
- main Street;
- north Trail;
- current gate;
- Gate Warden;
- market stall;
- two generic buildings;
- fully enterable smith shell/interior;
- reusable starting-area props;
- image-derived runtime presentation;
- first-person ViewModel/hands;
- current Mudcrest/trail approach;
- relevant automated regression/build gates.

## Partially implemented

- settlement identity;
- important-building pattern;
- NPC physical presence;
- smith service context;
- world/path modularization;
- collision ownership.

## Not yet implemented

- five-section settlement;
- final 60×70 m target layout;
- South Gate/arrival district;
- Community Hall;
- 2–3 real residences;
- utility storage;
- generalized building blueprint;
- NPC schedule/section ownership;
- section streaming;
- current-world persistence;
- full market ecosystem;
- crafting/inventory;
- full current-world combat positioning/integration;
- complete physical-device acceptance.

---

# 17. Planning status

The **five-section topology** is approved by issue #4.

The **60 × 70 m footprint and detailed street/corner placement in this document are a provisional design decision for documentation/planning**, chosen from:

- current 46×78 m live world;
- existing 6.2 m Street;
- older 8 m main-spine / 5 m secondary / 3 m alley design targets;
- current enterable-building dimensions;
- approved five-section content requirements.

Before runtime placement moves, issue #3/#4 implementation must convert this plan into stable section IDs, exact bounds/connectors, and regression-tested coordinates.

No current runtime file is changed by this document.
