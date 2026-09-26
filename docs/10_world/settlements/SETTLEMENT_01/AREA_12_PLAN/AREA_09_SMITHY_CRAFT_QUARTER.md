# Area 09 — Smithy & Craft Quarter

Status: PLAN_READY / REFERENCE GENERATION NEXT  
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
