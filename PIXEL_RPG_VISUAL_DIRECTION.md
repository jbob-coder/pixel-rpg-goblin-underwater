# Pixel RPG — Visual / Play Presentation Direction

Status: CREATOR-AUTHORITATIVE / FIRST-PERSON / ACTIVE
Last reconciled: 2026-09-24
Branch: `pixel-rpg`

## Purpose

This file is the current visual and player-facing presentation authority for Pixel RPG.

Current explicit creator direction, current source/tests, and current build/device evidence outrank historical presentation records.

Archived or unrelated project material is not a design source for this file.

## Core identity

Pixel RPG is an Android-first first-person monster-hunting RPG with:
- pixel-styled real 3D presentation;
- direct first-person exploration;
- mobile movement/look controls;
- compact connected physical spaces;
- body-part-focused monster combat;
- persistent world/NPC consequences;
- deterministic/testable systems where practical.

The game should be deep, coherent, expandable, and bounded rather than massive or empty.

## Camera

Normal exploration uses an eye-height first-person `Camera3D` path.

Preserve:
- camera-relative movement;
- independent look;
- current FOV/near/far unless a bounded test-backed change is required;
- no visible body obstructing normal first-person view;
- camera behavior independent from gameplay ownership.

The camera must not become an owner of durable state, targeting truth, combat resolution, or world collision.

## First-person ViewModel

The first-person ViewModel is presentation-only.

Live scene:
`game/assets/characters/first_person_viewmodel_01.tscn`.

Canonical hands asset:
`pixel_rpg_hunter_fp_hands_neutral_r001.png`.

Requirements:
- render as camera-local presentation;
- preserve central forward visibility;
- use nearest/pixel-consistent filtering;
- avoid clipping that materially blocks exploration or targeting;
- own no physics, collision, input, targeting, combat, persistence, or durable state;
- keep procedural placeholder geometry only as a temporary fallback until the canonical asset passes parity gates;
- remove duplicated visible placeholder pieces only after verified replacement.

## Controls

Mobile control law:
- left virtual stick = direct continuous movement;
- right side = independent camera/look;
- movement and look may occur simultaneously;
- contextual actions remain on the right side;
- landscape-first Android layout;
- no forced joystick release/center/rebase that interrupts continuous movement.

Touch target size, sensitivity, pitch limits, and final ergonomics require physical-device validation.

## Pixel presentation

Target: deliberately pixel-styled real 3D, not flat menu presentation and not smooth 3D with only a cosmetic pixel filter.

Preferred technical direction:
- real 3D world geometry/collision/navigation;
- pixel-authored or pixel-consistent textures and sprites;
- deliberate low-resolution internal rendering where useful;
- crisp nearest-neighbor/equivalent scaling;
- restrained lighting/material complexity;
- strong silhouette/value grouping;
- readable animation at phone scale;
- pixel-consistent UI without sacrificing legibility.

## Image-derived asset rule

Approved Pixel RPG image-derived assets may become visible presentation when their source lineage is explicit and their runtime use passes the owning gates.

Gameplay/collision geometry may remain as invisible support. Presentation assets must not silently take ownership of collision, interactions, targeting, combat, save state, or durable world state.

Do not leave duplicated visible procedural placeholders after an approved replacement reaches parity.

## Canonical visual reference lineage

Current reference-image IDs and source hashes are recorded in the Visual Pack 010/011 art documentation and owning tests.

Reference imagery defines visual direction and source lineage. Text, labels, names, counts, or incidental details visible inside a concept image are not automatically canon.

## World traversal

Normal exploration is physical.

Use compact connected routes and world compression. Traversed spaces should contain meaningful terrain, NPC activity, resources, clues, hazards, interactions, decisions, or encounters.

Fast travel may exist later as earned convenience but must not replace initial discovery.

## Combat presentation

Combat remains in the same physical world unless a future explicit creator decision authorizes a different presentation.

Preserve current domain authorities rather than duplicating damage/anatomy logic in presentation.

Combat presentation should support:
- meaningful anatomy targeting;
- readable monster scale;
- repositioning;
- dodge/evade;
- defend/block where equipment permits;
- terrain/cover where relevant;
- tools/items;
- behavior observation;
- legal withdrawal.

Combat Bridge 002 remains no-attack bootstrap authority until a later verified combat slice explicitly extends it.

## Monster readability and harvesting

Monsters must remain readable on Android phone displays.

Body-part damage/break/sever state should be visually legible and remain connected to authoritative domain state.

Harvest quantity/quality must continue to derive from authoritative body state and extraction rules, not from presentation nodes.

## Settlement presentation

Settlements are playable spaces.

Prefer:
- readable main routes;
- functional buildings identifiable by silhouette;
- physically present NPCs;
- compact service/market activity;
- physical exits to hunt routes;
- layered depth without unnecessary clutter;
- strong scale/readability on the target device.

Prefer one small excellent settlement over a large empty city.

## NPC and world simulation

Important NPCs may preserve stable identity, relationships, role, schedule, injury/status, location/activity, memories/flags, faction/settlement membership, and long-term world consequences.

Runtime generative AI is not required. Behavior should be state-driven and testable.

## Time and progression

Time should advance through play/actions such as travel, interaction, harvesting, rest, hunts, crafting, and processing.

Progression may include attributes, weapon mastery, equipment, monster knowledge, relationships/access, crafting/harvesting skill, and tactical options.

Presentation must not become progression authority.

## HUD direction

Preferred zoning:
- upper-left: essential health/stamina/status;
- upper-right: compact map/compass/time access;
- objective panel: collapsible;
- lower-left: quick items only when useful;
- lower-right: contextual touch actions;
- world markers only when relevant.

Requirements:
- safe-area aware;
- scalable across Android aspect ratios;
- touch targets large enough for phone use;
- minimal obstruction of forward visibility and monster anatomy;
- pixel-consistent styling with high legibility.

## Performance discipline

Visual upgrades must preserve Android-first performance discipline.

Prefer:
- bounded draw distance;
- visibility/occlusion control;
- low-cost materials;
- sensible texture sizes;
- reuse/instancing where appropriate;
- no unnecessary always-active physics or presentation nodes.

Performance is not verified by aesthetics or CI alone; sustained device evidence is required.

## Verification language

Keep these states separate:
- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

## Current baseline

Latest fully recorded visual baseline before the current hands integration:
Visual Pack 011 Direct Concept-Photo PNG Assets.

Current hands integration is complete only when:
1. the canonical PNG is present in the source tree;
2. the live ViewModel references it;
3. existing first-person invariants remain intact;
4. required Godot/headless/regression/build gates pass;
5. build evidence is recorded;
6. physical visual acceptance remains separately labeled until actually tested on device.
