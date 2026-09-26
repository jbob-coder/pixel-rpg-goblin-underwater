# Pixel RPG — Visual / Play Presentation Direction

Status: CREATOR-AUTHORITATIVE / FIRST-PERSON / ACTIVE  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`

## Purpose

This file is the current visual and player-facing presentation authority for Pixel RPG.

Current explicit creator direction, current source/tests, and exact build/device evidence outrank historical presentation records.

Archived, migrated, or unrelated project material is not a design source merely because it exists.

## Core identity

Pixel RPG is an Android-first first-person monster-hunting RPG with:

- pixel-styled real 3D presentation;
- direct first-person exploration;
- mobile movement/look controls;
- compact connected physical spaces;
- body-part-focused Monster combat;
- persistent world/NPC consequences;
- deterministic/testable systems where practical.

The game should be deep, coherent, expandable, and bounded rather than massive or empty.

## Camera

Normal exploration uses an eye-height first-person `Camera3D` path.

Preserve:

- camera-relative movement;
- independent look;
- current FOV/near/far unless a bounded test-backed change requires otherwise;
- no third-person body obstructing normal first-person view;
- camera behavior independent from durable gameplay ownership.

The camera must not become an owner of durable state, targeting truth, combat resolution, or world collision.

## First-person ViewModel

Live scene:

`game/assets/characters/first_person_viewmodel_01.tscn`

Canonical hands:

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`

Current source already references the canonical PNG directly.

Requirements:

- camera-local presentation;
- preserve central forward visibility;
- nearest/pixel-consistent filtering;
- avoid clipping/obstruction that harms exploration or targeting;
- no physics/collision ownership;
- no input authority;
- no targeting/combat authority;
- no persistence/durable-state authority.

Physical-device composition/clipping acceptance remains separate from automated source/build verification.

## Controls

Mobile control law:

- left virtual stick = continuous direct movement;
- right side = independent look;
- movement and look may occur simultaneously;
- contextual actions remain on the right side;
- landscape-first Android layout;
- no forced joystick release/center/rebase that interrupts continuous movement.

Touch target size, sensitivity, pitch limits, and final ergonomics require physical-device validation.

## Pixel presentation

Target: deliberately pixel-styled real 3D, not flat menu presentation and not smooth 3D with only a cosmetic pixel filter.

Preferred technical direction:

- real 3D geometry/collision;
- pixel-authored/pixel-consistent textures and sprites;
- deliberate low-resolution internal rendering where useful;
- crisp nearest-neighbor/equivalent scaling;
- restrained lighting/material complexity;
- strong silhouette/value grouping;
- readable animation at phone scale;
- pixel-consistent UI without sacrificing legibility.

## Image-derived asset rule

Approved Pixel RPG image-derived assets may become visible presentation when source lineage is explicit and runtime use passes owning gates.

Gameplay/collision geometry may remain invisible technical support.

Presentation assets must not silently take ownership of:

- collision;
- interactions;
- targeting;
- combat;
- save state;
- durable world state.

Do not leave duplicated visible placeholders after a replacement has passed parity/integration verification.

Current runtime image-derived families include Pack 010 concept-derived material textures and Pack 011 direct concept-photo PNG presentation assets.

## World traversal

Normal exploration is physical.

Use compact connected routes and world compression.

Traversed spaces should contain meaningful terrain, NPC activity, resources, clues, hazards, interactions, decisions, or encounters.

Fast travel may exist later as earned convenience but must not replace initial discovery.

## Buildings

Settlements are playable spaces, not backdrop-only facades.

Prefer:

- readable main routes;
- functional buildings identifiable by silhouette;
- physically present NPCs;
- compact service/market activity;
- physical exits to hunt routes;
- strong target-device scale/readability.

The current enterable smith is the strongest building-pattern reference because it has a real doorway, segmented collision, anchors, interior handling, and split roof visibility.

A visual door on a monolithic collision box must not be treated as an enterable building.

## Combat presentation

Combat remains in the same physical world unless an explicit future creator decision authorizes otherwise.

Preserve current deterministic domain authorities rather than duplicating damage/anatomy logic in presentation.

Current first-person integration boundary:

Observe/Engage
→ targeting
→ anatomy target lock
→ Combat Bridge 002 bootstrap
→ no attack yet.

Future presentation should support:

- meaningful anatomy targeting;
- readable Monster scale;
- repositioning;
- dodge/evade;
- defend/block where equipment permits;
- terrain/cover where relevant;
- tools/items;
- behavior observation;
- legal withdrawal.

Future attack/tactical integration must use an explicit current-world spatial adapter.

## Monster readability and harvesting

Monsters must remain readable on Android phone displays.

Body-part damage/break/sever state should be visually legible and connected to authoritative domain state.

Harvest quantity/quality must derive from authoritative body state and extraction rules, not presentation nodes.

## NPC and world simulation

Important NPCs may preserve stable identity, relationships, role, schedule, injury/status, location/activity, memories/flags, faction/settlement membership, and long-term consequences.

Runtime generative AI is not required. Behavior should remain state-driven and testable.

## Time and progression

Time should advance through play/actions such as travel, interaction, harvesting, rest, hunts, crafting, and processing.

Progression may include:

- attributes;
- weapon mastery;
- equipment;
- Monster knowledge;
- relationships/access;
- crafting/harvesting skill;
- tactical options.

Presentation must not become progression authority.

## HUD direction

Preferred zoning:

- upper-left: health/stamina/status;
- upper-right: compact map/compass/time access;
- objective panel: collapsible;
- lower-left: quick items only when useful;
- lower-right: contextual touch actions;
- world markers only when relevant.

Requirements:

- safe-area aware;
- scalable across Android aspect ratios;
- sufficiently large touch targets;
- minimal obstruction of forward visibility/Monster anatomy;
- pixel-consistent but legible styling.

## Performance discipline

Visual upgrades must preserve Android-first performance discipline.

Prefer:

- bounded draw distance;
- visibility/occlusion control;
- low-cost materials;
- sensible texture sizes;
- reuse/instancing;
- no unnecessary always-active physics/presentation nodes.

Performance requires sustained device evidence; aesthetics or CI alone cannot verify it.

## Verification language

Keep separate:

- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

## Current automated baseline

Audited runtime source:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical workflow:

`36082533109` — SUCCESS

Verification:

`107907382620` — SUCCESS

Android export:

`107907562399` — SUCCESS

That baseline includes current first-person source, canonical hands integration, current world decomposition state, regression stack, and Android debug export.

It does not establish physical-device visual acceptance, touch ergonomics, sustained performance, or heat.
