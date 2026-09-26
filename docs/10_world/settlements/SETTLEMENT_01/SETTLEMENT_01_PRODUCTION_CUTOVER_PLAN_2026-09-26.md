# Settlement 01 — Production Cutover Plan

Status: READY FOR BOUNDED IMPLEMENTATION / NO DEFAULT-FLIP AUTHORIZATION  
Created: 2026-09-26

Production baseline:

`main@abeeda02568a4e7b9a36d9dd9ee381d1539cdc67`

Settlement isolated foundation:

**G00–G17 verified**

Current player-facing world:

**existing compact first-person prototype**

## Purpose

Move Settlement 01 from isolated verified runtime components into the real first-person application without destroying the current working world or collapsing evidence layers.

Primary law:

**Parallel integration first. Default replacement last.**

## Cutover architecture

Recommended path:

`AppShell / current prototype boot`
→ bounded settlement-world selection seam
→ current compact world OR Settlement 01 candidate world
→ same first-person control/camera/HUD contracts
→ same gameplay/domain owners.

The seam must not duplicate:
- player state;
- camera-control state;
- combat state;
- targeting state;
- durable world state.

## C00 — Cutover feature flag / parallel builder seam

Goal:
create an explicit runtime selection seam for:
- LEGACY_COMPACT_WORLD;
- SETTLEMENT_01_CANDIDATE.

Requirements:
- default remains current compact world;
- no user-facing setting required yet;
- test may instantiate candidate path directly;
- no duplicated player authority;
- AppShell boot remains stable.

Acceptance:
- legacy boot unchanged;
- candidate boot can be exercised in isolation/headless;
- one authoritative player/camera path.

## C01 — Spawn, floor and first-person traversal parity

Integrate:
- Settlement 01 floor;
- Main Spine;
- safe player spawn;
- South Arrival starting context.

Preserve:
- CharacterBody3D player;
- camera-relative movement;
- first-person Camera3D;
- ViewModel/hands;
- touch input ownership.

Acceptance:
- player spawns above valid floor;
- no fall-through;
- Main Spine traversable;
- direct first-person camera unchanged.

## C02 — Static settlement world composition

Add candidate-world composition for:
- G02–G13 graybox structures;
- roads;
- buildings;
- gates;
- perimeter;
- streetscape.

Do not add final creator-unapproved art as final authority.

Acceptance:
- all five sections physically present;
- twelve authored areas identifiable;
- key doors/passages follow tested collision contracts;
- no duplicate legacy settlement geometry in candidate path.

## C03 — Interaction and service parity

Reconnect current first-person interaction behavior to candidate-world anchors:
- Gate Warden / hunter gate;
- Smith interaction;
- local hall anchors;
- contextual actions.

Preserve:
- interaction owner;
- targeting owner;
- combat bootstrap boundary.

Acceptance:
- current Smith behavior still reachable;
- current Gate Warden behavior still reachable;
- HUD does not become gameplay truth;
- no interaction action silently mutates presentation-only nodes.

## C04 — Settlement minimap cutover under candidate path

Use G15 contract for candidate world.

Legacy world:
- retains old minimap wrapper.

Settlement candidate:
- uses G00-derived 60×70 bounds and G15 section/area/building/gate/road data.

Acceptance:
- player marker maps correctly;
- legacy minimap unchanged;
- minimap remains presentation-only.

## C05 — NPC presentation hookup

Use G14 identities/anchors/schedules.

First candidate implementation:
- simple visible NPC presentations only;
- bounded active count;
- schedule resolution from G14;
- abstract/off-duty unloaded state.

Do not add:
- runtime generative AI;
- broad relationship persistence;
- expensive all-section CharacterBody simulation.

Acceptance:
- no duplicate NPC stable IDs;
- anchor resolution remains valid;
- unloaded/hidden presentation does not erase NPC identity.

## C06 — G16 real scene-lifecycle adapter

Only after the fully static candidate world works.

Translate G16 lifecycle intent into actual presentation-node residency.

Safety rules:
- delayed unload;
- protect interaction target/current service;
- never unload current section;
- Area 04 connector availability preserved;
- no durable state owned by residency.

Acceptance requires:
- no visible missing floor;
- no interaction target disappears mid-use;
- no duplicate section instances;
- no state loss;
- device memory/performance measurement.

This is the first phase that can create real streaming pop, so it needs physical-device evidence.

## C07 — G17 persistence service adapter

Only after current-world durable owner/service exists.

G17 remains the Settlement 01 world-state envelope.

A separate persistence service will eventually own:
- generation/slot write;
- temp/atomic promotion;
- load validation;
- fallback to last committed generation;
- migrations.

Do not write streaming residency, camera, touch, HUD, targeting, or other owners into the Settlement envelope.

Acceptance:
- bounded settlement flags survive save→load deterministically;
- invalid/corrupt generation fails safely;
- transient state not persisted.

## C08 — Combat/current-world spatial compatibility

Before candidate world becomes default, verify:
- Mudcrest/current encounter route still works;
- targeting works;
- Combat Bridge 002 remains no-attack bootstrap;
- no Region-01 tactical-coordinate teleport leaks into Settlement 01.

Future full current-world attack integration remains a separate adapter task.

## C09 — Android candidate acceptance

Build exact candidate SHA.

Physical device checks:
- install/launch;
- landscape;
- no black screen;
- first-person hands;
- movement/look;
- South Gate → Plaza → Smith → North Gate traversal;
- interactions;
- minimap;
- section-lifecycle transitions if C06 active;
- sustained FPS;
- heat;
- lifecycle;
- installed footprint.

No default flip before this evidence exists.

## C10 — Default flip

Only after C00–C09 required gates pass.

Change:
- Settlement 01 becomes default player-facing starting world;
- legacy compact world becomes fallback/regression fixture until intentionally retired.

Requirements:
- exact source SHA;
- canonical CI success;
- Android build success;
- physical-device acceptance;
- creator approval for any final visual assets used.

## Rollback law

Every cutover phase must be independently reversible.

The current compact world remains available until Settlement 01 default behavior is proven.

Do not delete:
- old world builders;
- legacy current-world collision;
- current interaction glue

in the same commit that first introduces the candidate Settlement 01 path.

## Visual approval law

Graybox candidate cutover may proceed with clearly provisional geometry.

Final visual promotion may not.

Creator final review remains:
**0 / 12**

Any final-art integration must point to the approved reference/version for that area.

## Evidence ladder

C00–C08:
- source + focused tests;
- full regressions;
- canonical CI;
- Android export as required.

C06/C09/C10:
- physical-device evidence required for visible streaming/performance/default-player-experience claims.

## Immediate next bounded implementation

**C00 — parallel world-selection seam**

This is the safest first production-cutover change because:
- default behavior remains unchanged;
- candidate path becomes testable;
- rollback is trivial;
- it creates the adapter surface needed by later phases.

Do not start C02 or default replacement before C00/C01 are proven.
