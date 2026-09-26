# Settlement 01 — Runtime Status G00–G15

Status: CURRENT PRODUCTION EVIDENCE / ISOLATED SETTLEMENT RUNTIME IMPLEMENTED  
Reconciled: 2026-09-26

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`

Current production HEAD:

`9d600407e29e8f3c5be0ce48ec5afdf02c766f42`

Latest completed settlement pass:

**G15 — minimap derivation**

Canonical G15 CI:

`36267898515` — SUCCESS

Verification job:

`108475980140` — SUCCESS

Android export job:

`108476104561` — SUCCESS

## Current implemented settlement runtime

The Settlement 01 rebuild is no longer documentation-only.

Implemented and regression-tested runtime/data passes:

- G00 — section/area/layout identity and locked coordinates;
- G01 — isolated continuous settlement floor + Main Spine;
- G02 — isolated Central Plaza;
- G03 — isolated locked Smith;
- G04 — isolated Community Hall;
- G05 — isolated residences;
- G06 — isolated work-support structures;
- G07 — isolated worker/frontage passage;
- G08 — isolated South Arrival Gate;
- G09 — isolated Gate Barracks & Security;
- G10 — isolated Caravan/Logistics area;
- G11 — isolated North Hunter Staging;
- G12 — isolated North Watch Gate / trail exit;
- G13 — isolated perimeter and streetscape;
- G14 — stable NPC anchors + deterministic simple schedules;
- G15 — minimap data derived from the locked G00 layout.

The current isolated runtime includes the five durable sections, twelve authored areas, fixed building parcels, roads/connectors, graybox structures, perimeter/streetscape composition, stable NPC/anchor identities, simple schedule state, and settlement-aware minimap derivation.

## What is not yet true

The current player-facing prototype has **not** been cut over to Settlement 01.

Still not implemented:

- G16 conservative section streaming;
- G17 persistence hooks;
- production-world replacement/cutover;
- final creator-approved building/prop art;
- creator final visual approval of the 12 area references;
- current player-facing settlement minimap cutover;
- physical-device acceptance of the new settlement;
- sustained device performance/heat evidence for the new settlement.

## Visual-art gate

Current creator final approvals:

**0 / 12**

Spatial/technical references and model contracts may guide graybox/runtime work, but final facade/roof/material/prop art remains blocked on creator approval.

## Minimap boundary

G15 adds a Settlement 01 minimap contract derived from G00 layout authority.

It does not replace the live prototype's old compact-world minimap yet.

The existing `PixelRPGMinimapMath001.marker_position()` wrapper remains compatible with current compact-world bounds.

Settlement 01 uses the new bounds-aware mapping path through the G15 contract.

## NPC boundary

G14 currently defines:

- 7 authored NPC identities;
- 27 stable authored anchor IDs;
- deterministic schedule segments;
- abstract unloaded/off-duty schedule states;
- runtime anchor validation against the isolated settlement.

G14 does not add full NPC CharacterBody simulation, pathfinding, relationship persistence, or production-world NPC cutover.

## Next bounded runtime pass

**G16 — conservative streaming**

Safe initial scope:

- data/lifecycle contract only;
- loaded set = current section + directly adjacent sections;
- Area 04 shared Main Spine remains available;
- S02 may naturally keep all five sections loaded because it neighbors all four;
- no aggressive visible unload;
- no production-world cutover;
- no durable player/world state mutation;
- deterministic isolated tests before any actual unload behavior.

G17 persistence remains after G16.

## Evidence law

“Settlement runtime implemented” means the isolated G00–G15 settlement stack exists and passes current automated/build gates.

It does **not** mean:

- the current app boots into that settlement;
- the settlement is final art;
- streaming/persistence are complete;
- the phone experience is accepted.

Those evidence layers remain separate.
