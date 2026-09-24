# Pixel RPG

Status: ACTIVE ANDROID MONSTER-HUNTING RPG / FIRST-PERSON PIXEL DIRECTION
Last reconciled: 2026-09-23
Branch: `pixel-rpg`

Pixel RPG is the active game in this branch. WorldLife is abandoned, and the later standalone first-person Shooter RPG is not the implementation base.

## Selected player-facing identity

**First-person pixel-styled real-3D monster-hunting RPG with mobile move/look controls, physical exploration, body-part combat, harvesting and persistent world/NPC consequences.**

Primary presentation authority: `PIXEL_RPG_VISUAL_DIRECTION.md`.

Visual references in Google Drive:
- `Pixel RPG - Visual Reference ORIGINAL.png` — `1IcZDQAEPUVpSpvJsvaVZsLqAA0RJmaxp`;
- `Pixel RPG - Visual Reference.jpg` — `1NYHm1Y_CPQOb22ZQsF9e45T5uFV3Mh_b`.

Names/text shown in the generated concept image are placeholders unless separately approved.

## Main loop target

`SETTLEMENT → PREPARE → PHYSICALLY LEAVE SETTLEMENT → EXPLORE/TRACK → OBSERVE/APPROACH → FIRST-PERSON SPATIAL COMBAT → TARGET ANATOMY → BREAK/SEVER/DEFEAT/ESCAPE → HARVEST → RETURN → NPC/SETTLEMENT CONSEQUENCES → PROCESS/CRAFT/EQUIP/LEARN → NEXT HUNT`

Use compact connected spaces and world compression rather than a huge empty open world or normal menu teleportation.

## Controls target

- landscape Android-first;
- left virtual stick = direct continuous movement;
- right side = independent camera/look;
- simultaneous movement/look;
- contextual action controls;
- safe-area responsive HUD.

The phrase “shooter-style controls” describes the familiar mobile control layout only. Pixel RPG is not the standalone Shooter RPG.

## Art target

Pixel-styled real 3D:
- real spatial world/collision/camera;
- pixel-authored/pixel-consistent textures and UI;
- controlled low-resolution rendering/upscale where useful;
- strong silhouettes and readable monster anatomy;
- intentional lighting/material simplification;
- no generic smooth 3D scene with a cosmetic pixel filter.

## Gameplay foundations to preserve where compatible

- deterministic combat/action resolution;
- monster anatomy/body-part ownership;
- wounds/statuses;
- break/sever/harvest consequences;
- tracking/encounter continuity;
- stable IDs/data-driven content;
- test/regression infrastructure.

## Supporting systems

Gradual targets include Diamond Watch, hunter journal/bestiary, relationships/memories, NPC schedules/aging, settlements/factions, crystal/diamond mining and energy economy, meaningful long-term decisions, and multi-layer progression. These are not implementation claims unless source/tests prove them.

## Hard storage ceiling

Player-required installed/runtime footprint cap remains exactly `2 GB = 2,000,000,000 bytes`.

Required runtime downloads count. Development-only source/repository/CI files do not. Package-size evidence does not by itself prove installed-footprint compliance.

## Historical verification boundary

Previously recorded fully production-verified monster-hunting source:
`01a19b2811cfc5e3f9c0edb0e9264bc997161c7c`.

Workflow `34880096112`: SUCCESS.
Job `104096962757`: SUCCESS.
Artifact `10362706279`: 57,536,941 bytes; SHA-256 `ba02d634d1435ed294f42bf5db8e2c55470265da4026aa1488e4b2ce30792917`.

This verifies the older production state only. It does not prove the Pixel RPG presentation is implemented or accepted.

## Current bounded piece

`PIXEL_RPG_FIRST_PERSON_REALIGNMENT_001`.

First prove:
- one compact settlement gate/street;
- one controllable first-person presentation using the existing player controller;
- left-stick movement + right-side camera/look;
- one NPC interaction;
- one short physical route;
- one visible monster/proxy;
- coherent pixel rendering/art treatment;
- responsive safe-area HUD;
- static/headless/build verification available to the slice.

Do not rewrite the entire game before this slice is accepted.

For continuation, begin with `START_HERE_NEW_CHAT.md` and reconstruct live `pixel-rpg` state before implementation.
