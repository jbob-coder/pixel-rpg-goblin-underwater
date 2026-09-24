# Unnamed Hunt RPG — World Scale, Streaming, Transition and Building Guide

Status: CORE DESIGN DECISION + PROTOTYPE SCALE TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how the player physically experiences settlements and hunting regions, how major-area transitions work, how wilderness battlefield zones remain continuous whenever possible, and what scale rules should govern characters, monsters, buildings, streets and sectors.

This guide refines `MAP_WORLD_SETTLEMENT_STRUCTURE.md`.

The main objective is to avoid two bad extremes:
- one gigantic map where the player can see or load too much at once;
- a fragmented game where every small wilderness zone triggers a loading screen.

# 1. User-decided requirements

Current explicit requirements:
- settlements must be physically walkable;
- entering the battlefield/hunting world should feel like entering a new major area;
- different battlefield/wilderness zones should remain continuous whenever technically possible;
- the player should not see the entire hunting map during normal exploration;
- world, character, monster and building scale must remain coherent;
- transitions and streaming must be designed for Android performance rather than added later.

# 2. Possible world-loading solutions considered

## Solution A — One completely seamless settlement + wilderness + all neighboring regions

Advantages:
- maximum physical continuity;
- no explicit major-area loading transition;
- distant geography can theoretically remain visible.

Problems:
- highest Android memory and streaming risk;
- settlement NPCs and wilderness ecology compete for resources;
- difficult asset lifetime management;
- harder debugging;
- more complicated navigation and save boundaries;
- encourages oversized empty geography;
- requires strong streaming technology before the game loop is proven.

Decision: NOT preferred.

## Solution B — Every settlement and every wilderness sector is a separate loaded scene

Advantages:
- easiest memory control;
- simple authoring boundaries;
- simple reset/testing.

Problems:
- wilderness feels fragmented;
- repeated loading interrupts tracking;
- fleeing monsters crossing zones becomes awkward;
- player loses sense of physical territory;
- combat continuity is weaker.

Decision: NOT preferred as the normal wilderness model.

## Solution C — Walkable settlement + major transition + one continuous streamed hunting region

Structure:

```text
WALKABLE SETTLEMENT
        ↓
DIEGETIC MAJOR-AREA TRANSITION
        ↓
CONTINUOUS HUNTING REGION
  sector A ↔ sector B ↔ sector C
      ↕          ↕          ↕
  sector D ↔ sector E ↔ sector F
        ↓
LOCAL FIRST-PERSON ENCOUNTER FOOTPRINTS
```

Advantages:
- settlement can be dense and socially detailed;
- settlement↔wilderness feels like a meaningful threshold;
- wilderness tracking remains continuous;
- monsters can physically move/flee between sectors;
- sectors can stream independently without visible loading screens;
- easier Android memory control than one seamless world;
- easier expansion by adding regions;
- region identity remains strong.

Decision: **SELECTED PREFERRED ARCHITECTURE.**

## Solution D — Same as Solution C, but large interiors/deep caves can use additional controlled transitions

This is an extension of C rather than a competing base architecture.

Use when a location is too expensive or structurally distinct to coexist with the surrounding region.

Examples:
- very large guild hall interior;
- underground crystal cavern;
- deep nest chamber;
- major dungeon-like special site;
- story location with unique lighting/assets.

Decision: ALLOWED selectively. Do not turn every door/cave into a loading screen.

# 3. Locked world hierarchy

Preferred hierarchy:

```text
WORLD ATLAS / LONG-DISTANCE TRAVEL
        ↓
WALKABLE SETTLEMENT
        ↓
SETTLEMENT OUTSKIRTS / HUNTER GATE
        ↓
TRANSITION CORRIDOR / FRONTIER BELT
        ↓
CONTINUOUS STREAMED HUNTING REGION
        ↓
LOCAL FIRST-PERSON COMBAT FOOTPRINT
```

Different hunting regions may later connect physically by major passes, caves, roads or river routes, but those are major-region transitions rather than tiny battlefield-zone transitions.

# 4. Settlement is real walkable gameplay space

Settlement is not a menu hub.

The player physically walks through:
- streets;
- plazas;
- workshops;
- hunter lodge;
- research/crystal facilities if adopted;
- merchants;
- material-processing area;
- storage/loadout area;
- inn/home/recovery area;
- training yard;
- residential/ambient spaces;
- walls/gates/outskirts.

Services can still open UI when interacting with a person/workstation, but the player reaches them through the world.

## 4.1 Settlement navigation principle

Compact and memorable rather than gigantic.

A useful service should normally be reachable without several minutes of empty walking.

Recommended first-settlement organization:

```text
ARRIVAL / MAIN GATE
        ↓
CENTRAL MARKET / PLAZA
   ↙        ↓        ↘
SMITH   HUNTER LODGE  PROCESSOR/RESEARCH
   ↘        ↓        ↙
 STORAGE / INN / TRAINING
        ↓
OUTBOUND HUNTER GATE
```

Residential streets and visual life surround these anchors rather than separating every useful location by long distances.

# 5. Settlement building-entry solutions

## Small/medium important buildings — preferred seamless walk-in

For shops/workshops that are inexpensive enough:
- player opens door/threshold;
- interior is part of the local settlement presentation or streamed/cullable subscene;
- no explicit loading screen;
- exterior can be hidden/occluded while inside.

Good candidates:
- smith;
- small merchant;
- material processor;
- compact inn room;
- small research room.

## Large interiors — threshold streaming allowed

For large expensive interiors:
- entering doorway starts preloading;
- short doorway/hall/stair transition hides asset swap;
- player remains in control when possible;
- only use an explicit loading transition if target-device evidence requires it.

Good candidates:
- large hunter lodge;
- multi-floor guild headquarters;
- major crystal laboratory;
- underground complex.

## Rule

Do not make every door a scene change by default.

The building system should choose the least disruptive solution that still meets memory/performance limits.

# 6. Settlement → wilderness transition

This transition SHOULD feel different from moving between wilderness sectors.

It represents leaving protected civilization and entering the active ecosystem.

Preferred presentation:

```text
SETTLEMENT STREET
→ HUNTER GATE
→ WALL / GATE TUNNEL / BRIDGE / CANYON THROAT
→ FRONTIER CHECKPOINT
→ TRAILHEAD
→ WILDERNESS CONTROL RETURNS AT FULL HUNT MODE
```

## 6.1 Preferred transition implementation

Use a **diegetic transition corridor**.

Examples:
- fortified gate tunnel;
- bridge across defensive gorge/river;
- narrow canyon exit;
- palisade corridor;
- lift/ferry only if world design justifies it;
- winding forest approach with strong occlusion.

During this short traversal the game can:
- save/checkpoint;
- validate hunt loadout;
- unload/deactivate dense settlement NPC presentation;
- preload current + neighboring wilderness sectors;
- activate ecology/tracking systems;
- load required monster/terrain assets;
- crossfade music/ambience;
- change HUD mode.

Preferred experience: the player keeps walking and the world changes around them.

Fallback: if device evidence requires a hard break, use one short intentional major-area transition at this boundary rather than repeated loading screens inside the wilderness.

# 7. Wilderness battlefield zones must normally be continuous

A wilderness `sector` is primarily a streaming/simulation unit, NOT a visible boxed arena.

The player should normally be able to walk:

`River → Root Forest → Meadow → Ridge → Deep Territory`

without an area-select menu or loading screen.

## 7.1 Sector boundary design

Hide technical boundaries inside natural geography:
- path bends;
- ridgelines;
- dense trees;
- rock walls;
- elevation changes;
- river bends;
- ruins;
- narrow passes;
- heavy vegetation;
- fog/atmospheric depth where appropriate.

Do not use invisible walls just to match sector borders unless the geography justifies the boundary.

# 8. Streaming model — preferred

Use a rolling sector set.

Conceptually:

```text
RING 0 — current sector
- full collision
- full local gameplay
- full relevant rendering
- active tracks/gatherables
- relevant monsters at normal local simulation tier

RING 1 — directly neighboring sectors
- preloaded geometry/assets required for visual continuity
- collision/navigation ready near boundary
- simplified or partial gameplay simulation where safe
- persistent monsters can move into/out of these sectors

RING 2 — farther region sectors
- very low-cost aggregate/logical state only
- no high-detail rendering
- no expensive animation/physics unless specifically required
```

When the player approaches a boundary:
1. next sector is already present or finishes preloading;
2. current neighbor becomes Ring 0;
3. old distant sector is demoted/unloaded;
4. authoritative monster/ecology state persists through the change.

# 9. Monster continuity across wilderness sectors

A monster cannot disappear merely because it crossed a streaming boundary.

A persistent hunted monster owns logical state independent of its current render sector.

When it crosses sectors:
- instance ID remains unchanged;
- anatomy injuries persist;
- crystal Energy/Condition persist;
- mutation set persists;
- statuses persist according to rules;
- behavior phase/memory persists where required;
- tracks/blood can be emitted in destination/path sectors;
- presentation can downgrade while distant but identity remains.

If the player later catches it, it is the same creature.

# 10. When wilderness transitions ARE acceptable

Major controlled transitions are allowed for:
- one hunting region → a completely different hunting region;
- surface → deep cave system;
- exterior → major ancient ruin/interior;
- special isolated nest/dungeon where continuous streaming is too expensive;
- boat/ferry/lift travel;
- long-distance atlas travel.

Do not use them for ordinary neighboring forest/meadow/river/ridge sectors.

# 11. Normal exploration camera must never show the entire region

The whole map belongs in the map screen, not in the normal camera.

Normal exploration camera remains local and character-centered.

Current camera target remains roughly 40–50° downward, but scale is controlled so the player reads the nearby environment rather than viewing the region as a board game.

## 11.1 Prototype camera visibility targets

These are prototype candidates, not final engine measurements.

### Settlement
- closer framing;
- strong building/NPC readability;
- practical gameplay-detail radius roughly 20–40 m;
- farther architecture can remain visible as skyline/landmark LOD;
- maximum zoom-out is capped so the settlement never becomes a complete map view.

### Wilderness
- slightly broader framing than settlement;
- practical gameplay-detail radius roughly 35–70 m;
- important distant landmarks/large-monster silhouettes may be visible beyond this using LOD/impostors;
- terrain/elevation/vegetation should prevent the player from seeing the full region from most positions;
- high viewpoints can reveal more geography intentionally without becoming an omniscient top-down map.

The exact radius must be measured against phone screen readability.

# 12. World measurement standard

Preferred implementation standard:

**1 world unit = 1 meter** whenever the selected engine supports that convention cleanly.

Reasons:
- simpler collision/physics expectations;
- intuitive building/monster authoring;
- easier encounter range design;
- easier camera/LOD distances;
- easier creator tools and debugging.

Visual stylization can exaggerate silhouettes without corrupting world measurement.

# 13. Human/player scale

Prototype physical reference:
- typical adult hunter height around 1.65–1.90 m depending character;
- baseline reference mannequin around 1.75–1.80 m;
- collision dimensions derived from actual body requirement rather than exaggerated art silhouette.

For aerial readability, visual features such as shoulder width, weapon silhouette, cloak/equipment shapes or head/hand readability may be mildly exaggerated.

Do NOT make the authoritative player physically two times larger just because the aerial camera is elevated.

Keep collision/gameplay scale coherent and solve readability through art/camera/contrast.

# 14. Monster scale classes

Use coherent physical classes rather than arbitrary giant sizing.

Prototype planning bands:

### Ambient/small fauna
- roughly 0.3–1.5 m characteristic body size.

### Small huntable creature
- roughly 1.5–3 m characteristic body length/height depending body plan.

### Standard large hunt monster
- roughly 4–10 m body length;
- roughly 2–5 m major body/shoulder height depending anatomy.

### Huge/elite creature
- roughly 8–16+ m body length where the region/encounter can support it.

### Exceptional colossal creature
- possible later, but requires special arena/streaming/camera rules and should not define normal content scale.

Recommended first major monster:
- large enough to be clearly visible from aerial exploration;
- approximately 5–8 m long as a useful prototype range;
- approximately 2.5–4 m body/shoulder height depending posture;
- imposing in first person without requiring a stadium-sized combat footprint.

Exact species anatomy determines final dimensions.

# 15. Building scale rules

Buildings should feel made for human inhabitants while remaining readable from the aerial camera.

Prototype dimensional guides:

### Doors
- common exterior door height: ~2.1–2.5 m;
- common door clear width: ~1.0–1.4 m;
- important workshop/guild doors can be wider/taller for equipment/material movement.

### Small house/shop
- footprint roughly 6–12 m × 8–16 m.

### Workshop/smith/material processor
- roughly 10–20 m × 12–28 m depending service/equipment.

### Hunter lodge / major civic building
- roughly 18–40 m characteristic footprint depending settlement importance;
- can use multiple connected volumes rather than one giant block.

### Building floors
- typical floor-to-floor visual scale roughly 3–4 m;
- important halls/workshops can be taller.

These are authoring guides, not mandatory identical templates.

# 16. Street and settlement-space scale

Prototype planning ranges:
- narrow alley/service lane: ~2.5–4 m;
- ordinary walkable street: ~4–7 m;
- main market/hunter route: ~7–12 m;
- small plaza: ~15–30 m across;
- major central plaza/training yard: ~25–50 m across where justified.

Avoid overscaled streets built only because the camera is high; empty oversized streets make settlements feel artificial.

# 17. Defensive wall/gate scale

The first settlement should visually justify surviving nearby mutated creatures.

Prototype ranges:
- walls/palisades roughly 5–10 m high depending material/setting;
- hunter/vehicle gate roughly 5–9 m clear width where monster-material carts/equipment need passage;
- gatehouse/towers can exceed wall height for visual/navigation landmarks.

Natural defenses—cliffs, rivers, ravines, narrow passes—should carry part of the defensive burden so every settlement does not require absurd fortress walls.

# 18. Settlement overall scale

Do not choose settlement scale by visual spectacle alone.

First-settlement prototype target:
- approximately 180–320 m characteristic playable diameter/extent;
- dense functional core rather than uniformly filled square acreage;
- curved streets/elevation/buildings create longer perceived traversal than straight-line diameter;
- important services usually within roughly 20–60 seconds of purposeful movement from the central route once learned.

Larger future towns can stream internal districts if needed.

The first settlement should be big enough to feel inhabited but small enough that returning from hunts does not become commuting gameplay.

# 19. First hunting-region scale

The first region should feel much larger than what is simultaneously visible.

Prototype target:
- approximately 4–7 meaningful sectors;
- sector characteristic span roughly 100–220 m depending terrain density;
- total traversable region can roughly occupy a several-hundred-meter footprint rather than several empty kilometers;
- direct end-to-end dimensions might land around ~400–900 m depending topology, but paths/elevation/obstacles should matter more than rectangular size.

These numbers are prototype candidates and must be changed if target-device profiling or traversal pacing proves them wrong.

# 20. Sector design is not square-grid level design

Author sectors by ecological/geographic identity:
- river crossing;
- root forest;
- ridge;
- meadow;
- wetland;
- cave mouth;
- nest shelf;
- ruins;
- crystal-saturated pocket.

Technical bounds can be rectangular/polygonal internally, but players should perceive terrain, not cells.

# 21. Building/model modular base system

To create settlements efficiently, use a modular construction kit after art direction is proven.

Potential reusable pieces:
- wall sections;
- corners;
- doors/windows;
- roof modules;
- wooden beams;
- stone foundations;
- balconies;
- stairs/ramps;
- awnings;
- fences;
- workshop chimneys;
- market stalls;
- bridge sections;
- defensive wall/gate pieces.

Rules:
- use a small number of coherent material families;
- vary combinations, proportions, signage, props and rooflines;
- avoid obvious copy-paste repetition;
- hero buildings receive unique silhouette pieces;
- collision should use simplified meshes rather than full visual geometry;
- interiors use separate visibility/culling groups where practical.

# 22. Model LOD strategy

### Player
- high enough detail for closer settlement framing;
- simplified aerial LOD only if needed;
- first-person hands/equipment may use separate presentation assets if required.

### NPCs
- nearby NPC: full interaction model/animation;
- medium NPC: simplified animation/LOD;
- distant crowd: much cheaper representation or culled.

### Monsters
- distant wilderness silhouette: low-cost LOD/impostor;
- local aerial monster: medium/high model;
- combat monster: highest required anatomy/animation detail;
- do not keep combat-quality rigs active for distant sectors.

### Buildings
- nearby exterior/interior detail;
- medium simplified materials/mesh;
- distant skyline/landmark LOD;
- interiors completely hidden/unloaded when not relevant where possible.

# 23. Perceived scale techniques

The world can feel much larger than the actual loaded region through:
- mountains/cliffs outside playable bounds;
- distant settlement silhouettes;
- river continuation;
- forests extending beyond playable paths;
- inaccessible valleys;
- horizon terrain meshes;
- atmospheric perspective;
- distant creature calls;
- roads disappearing into geography;
- atlas geography showing how the local region fits into a larger world.

This is preferred over building kilometers of empty traversable terrain.

# 24. First-person combat footprint scale

Combat remains local to the current wilderness location.

Prototype footprint target depends on creature/body plan, but normal first-slice encounters should generally use tens of meters rather than hundreds.

A practical starting design range could be roughly 30–90 m across for a standard large-monster encounter footprint.

The footprint may reference geometry outside its strict tactical nodes for visual continuity.

Large/colossal creatures can require special footprints later.

# 25. Transition-state ownership

Area transition is a domain/world operation, not a camera trick.

Conceptual state:

`AreaTransitionRequest`
- source location/sector;
- destination location/sector;
- transition type;
- entry/exit anchor;
- player state;
- active hunt/monster references;
- required destination content IDs;
- save/checkpoint policy.

`AreaTransitionResult`
- destination active;
- authoritative player location updated;
- correct simulation tier activated;
- persistent monster references preserved;
- presentation transition event emitted.

Presentation can fade/crossfade/animate, but it cannot invent the destination state.

# 26. Streaming failure behavior

If the next sector/area is not ready:
- never let the player fall into unloaded geometry;
- keep a natural boundary/transition state active;
- show a minimal loading indicator only if necessary;
- do not silently teleport to an arbitrary fallback;
- log preload time/failure in development;
- allow Admin tools to force slow-loading simulation for testing.

# 27. Admin/Creator tools required for this architecture

Future development tools should expose:
- settlement walkability/collision overlay;
- building module/anchor inspector;
- interior loaded/cull state;
- current sector;
- neighbor preload state;
- sector memory/render cost;
- transition trigger/anchor visualization;
- persistent monster location across sectors;
- LOD level per actor/building;
- active NPC count;
- active ecology/monster simulation tier;
- camera practical-detail radius;
- line showing region sector boundaries in debug only;
- artificial slow-I/O/slow-stream test mode.

# 28. First implementation proof after authorization

Do NOT start with the final settlement.

Prototype this exact architecture with simple geometry:
1. one walkable settlement block with 2–3 enterable buildings;
2. one hunter gate;
3. one diegetic transition corridor;
4. one wilderness region with 3 connected prototype sectors;
5. seamless movement between those wilderness sectors;
6. one persistent monster crossing a sector boundary;
7. one local first-person encounter;
8. monster escapes back to another sector;
9. player returns through the gate to settlement;
10. verify no duplicated monster/player/save state;
11. profile memory/frame pacing/transition time on target Android hardware.

Then increase toward the first-slice target of 4–7 sectors and the real settlement layout.

# 29. Current locked decisions

- settlements are physically walkable;
- services exist in the world rather than only as disconnected menus;
- the settlement↔hunting-region boundary uses a meaningful major-area transition;
- preferred transition is diegetic and keeps player control whenever practical;
- wilderness battlefield sectors are continuous and streamed in the background whenever possible;
- ordinary sector boundaries do not show loading screens;
- only major region/interior boundaries may use explicit controlled transitions when necessary;
- normal exploration camera does not reveal the full settlement/region;
- full geography is shown through map UI, not normal camera zoom-out;
- preferred world measurement is 1 unit = 1 meter;
- collision/gameplay scale stays physically coherent even when art silhouettes are mildly exaggerated;
- first settlement is compact/dense rather than sprawling;
- first wilderness region is several meaningful sectors, not one visible board-sized map;
- modular building kits + simplified collision + LOD/culling are the preferred production approach;
- persistent monsters keep identity/state across sector streaming;
- first-person combat uses the same local geography/state rather than unrelated arenas.

# 30. Open prototype questions

Still require engine/device evidence:
- exact settlement dimensions;
- exact region/sector dimensions;
- exact camera altitude/FOV/projection and practical-detail radius;
- how many adjacent sectors can remain graphically loaded on minimum target hardware;
- whether important shop interiors can all remain seamless on target phone;
- exact transition corridor length/time;
- exact LOD distances;
- whether background skyline/horizon terrain is mesh, impostor or hybrid;
- how large a monster can use normal encounter footprints before requiring special encounter architecture.

No gameplay implementation is authorized yet.