# REGION_01 — Encounter Footprints

Status: SELECTED LOCAL-COMBAT STRUCTURE / PROTOTYPE TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how first-person tactical combat is anchored to Region 01's real terrain without turning each fight into a disconnected arena.

A footprint is a **local tactical interpretation of an actual region location**.

## Core invariant

Encounter creation preserves:
- source sector/location;
- player approach direction;
- monster identity/state;
- range/bearing;
- relevant cover;
- elevation;
- terrain tags;
- hazards;
- escape routes;
- time/weather where mechanically active.

Presentation may simplify decorative geometry, but tactical meaning cannot be replaced by a generic arena.

## Footprint authoring rule

Do not make every square meter combat-capable.

Author high-quality encounter-capable locations where:
- large-monster body can fit/move;
- camera can frame target anatomy;
- useful tactical positions exist;
- escape routes map back to region topology;
- terrain effects are legible;
- cover does not create impossible clipping;
- aerial-to-first-person transition has a viable path.

A monster can still be encountered outside a preferred footprint only if the system has a safe fallback or can map the local geometry correctly. First slice should favor authored/validated footprints over unrestricted procedural conversion.

## Prototype footprint set

### R01_EF01 — Riverbank Ford
Source: `R01_S01`

Purpose:
- demonstrate mud/water terrain consequences;
- cover from rocks/logs;
- exposed crossing/open bank contrast;
- retreat routes toward S00/S02/S03 depending local position.

Tactical features:
- 6–10 player tactical nodes candidate;
- dry-bank nodes;
- mud/shallow-water nodes;
- 1–2 substantial cover objects;
- slight elevation on bank;
- clear monster approach corridor;
- at least two player reposition directions.

Risks to test:
- water transparency/performance;
- monster feet intersecting bank/water;
- first-person camera at water edge;
- footprint/tracking decals overlapping combat VFX.

### R01_EF02 — Meadow Edge
Source: `R01_S03`

Purpose:
- demonstrate exposed/open fight;
- long visual telegraphs;
- edge cover versus center exposure;
- support charge/large-body movement patterns.

Tactical features:
- open center;
- tree/rock edge cover;
- multiple flanking bearings;
- enough distance for close/medium/long tactical states;
- escape direction toward S01/S02/S04/S05 as geographically valid.

Risks to test:
- arena becoming visually empty;
- camera seeing too much of surrounding region;
- long-range target readability on phone.

### R01_EF03 — Root/Boulder Hollow
Source: `R01_S02` or boundary toward `R01_S05` after graybox validation.

Purpose:
- demonstrate constrained sight lines and cover;
- make lateral movement meaningful;
- show how large roots/boulders affect legal attacks.

Tactical features:
- several substantial occluders;
- clear navigable lanes;
- no tiny maze nodes;
- one exposed central lane;
- side positions allowing part-angle changes.

Risks to test:
- first-person camera obstruction;
- monster body clipping roots;
- cover becoming too binary/strong;
- target part hidden unfairly.

### R01_EF04 — Deep Nest Shelf
Source: `R01_S06`

Purpose:
- deepest/most defensive region encounter;
- crystal/mutation environmental context;
- nest geometry affecting tactics;
- strong retreat/berserk presentation potential.

Tactical features:
- stone shelf/nest area;
- cover/elevation that still permits major monster movement;
- two geographic route connections back toward S04/S05;
- visible but bounded crystal/fault environmental elements;
- clear camera composition for severe injury/berserk state.

This footprint should not become a sealed boss room by default. If the creature can escape by rules, valid retreat paths remain represented.

## Node model

Preferred first-slice combat positioning uses meaningful tactical nodes/range/bearing relationships rather than free FPS locomotion.

A footprint should define:
- node ID;
- world anchor;
- neighbor links;
- terrain tag;
- cover relation;
- elevation band;
- approximate range/bearing to monster anchors;
- occupancy constraints;
- escape/region-link relation where relevant.

Exact node count remains a prototype decision. Prior planning target of roughly 6–12 meaningful positions remains appropriate for testing, not a final universal cap.

## Cover quality

Cover must be physically understandable.

Good cover examples:
- boulder;
- fallen trunk;
- thick root wall;
- bank elevation;
- stone shelf.

Avoid invisible percentage cover zones with no visible geometry.

Cover can modify legality/exposure through shared encounter/effect rules; this document only determines where cover exists.

## Terrain continuity

The local combat terrain tag must come from the same world surface/context.

Examples:
- if the aerial player is standing in mud at engagement, the first combat node cannot silently become dry stone;
- a nearby boulder visible before engagement should remain represented if tactically relevant;
- elevation relationships should remain recognizable.

## Monster footprint requirements

The future first monster packet must declare for each attack/movement:
- required space/range;
- body-part capability;
- whether terrain/cover can block/limit it;
- which footprints support it;
- fallback legal actions when a footprint prevents it.

Do not solve a footprint mismatch by letting the monster clip through cover or use destroyed anatomy.

## Transition camera gate

Every prototype footprint must be tested for:
1. aerial encounter commitment;
2. camera descent path;
3. no major wall/tree clipping;
4. correct first-person final orientation;
5. monster visible/readable enough for target selection;
6. HUD not obscuring critical anatomy;
7. return camera reconstructing the real region location.

## Persistence after encounter

If cover/environment changes persist by future rules, state must be mapped back to the region.

At minimum first slice must preserve:
- monster injury/state;
- player/monster exit locations;
- detached harvest-relevant body parts without duplication;
- evidence generated by escape/death.

Environment destruction persistence beyond critical cover remains OPEN.

## Admin/Creator requirements

Future tools should show:
- footprint bounds;
- tactical nodes/links;
- cover/exposure;
- elevation;
- terrain tags;
- monster anchors;
- camera transition preview;
- first-person preview from each node;
- escape mapping to region routes;
- collision/monster-fit warnings.

## Acceptance gate

Before final art, graybox must prove at least three distinct footprints:
- river/mud;
- open meadow;
- constrained root/rock or deep nest.

The same monster proxy must remain readable and physically plausible in each.
