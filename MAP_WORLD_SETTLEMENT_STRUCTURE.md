# Unnamed Hunt RPG — Map, Settlement and Hunting-World Structure

Status: CORE WORLD-STRUCTURE DESIGN / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define how the game world is divided spatially and technically so settlements feel alive, hunting regions feel dangerous, combat preserves physical continuity, and Android does not need to run one enormous seamless world at full detail.

This document distinguishes:
- **CURRENT DESIGN DECISION** — the structural direction to use unless changed;
- **BALANCE / PRESENTATION CANDIDATE** — useful details that can still be tuned;
- **FUTURE OPTION** — intentionally deferred expansion.

# 1. Core world structure decision

The game should NOT use one gigantic always-loaded open world.

Use four connected spatial layers:

```text
WORLD ATLAS / MACRO MAP
        ↓
SETTLEMENT / HUB SPACE
        ↓
FRONTIER GATE / TRANSITION BELT
        ↓
HUNTING REGION / WILDERNESS
        ↓
LOCAL FIRST-PERSON ENCOUNTER
```

The first-person encounter is not a separate world location. It is a tactical interpretation of the same local wilderness area and monster state.

# 2. Why this structure is preferred

This structure gives:
- believable world scale without rendering empty travel distance;
- dense settlements with more NPCs and services;
- dangerous wilderness with more ecology/tracking/terrain simulation;
- different performance budgets per space type;
- clean save/load boundaries;
- simpler Android streaming;
- easier content expansion;
- easier debugging and creator tooling;
- stronger music/lighting/pacing differences;
- clear separation between civilian life and hunt gameplay without making the world feel disconnected.

# 3. World Atlas / Macro Map

The world atlas represents geography larger than one physical playable scene.

It can show:
- settlements;
- hunting territories;
- mountain ranges;
- rivers/coastlines;
- roads/trails;
- dangerous zones;
- locked/unexplored regions;
- known monster activity;
- contracts/hunt destinations;
- caravan/travel routes;
- ecological pressure or elemental influence where knowledge allows it.

The atlas is NOT the normal exploration mode.

It exists for long-distance travel/selection between physically playable locations.

## 3.1 Atlas node types

Recommended stable node categories:
- `SETTLEMENT`;
- `OUTPOST`;
- `HUNTING_REGION`;
- `SPECIAL_SITE`;
- `PASS / ROUTE`;
- `LOCKED / UNKNOWN`.

Each node references a real playable scene/region definition when entered.

## 3.2 Long-distance travel

Do not force the player to physically walk across many kilometers of empty road just to preserve the illusion of seamlessness.

Preferred flow:
`LEAVE LOCATION → SELECT/CONFIRM ROUTE → TRAVEL COST/TIME/EVENT CHECK IF USED → LOAD DESTINATION EDGE/ARRIVAL POINT`

Possible travel consequences later:
- time passes;
- food/supplies consumed if survival depth is adopted;
- route closed by weather;
- caravan event;
- monster migration warning;
- contract timer changes;
- new tracks/news discovered.

These are future mechanics, not required for the first slice.

# 4. Settlement spaces

Settlements are dense social/service spaces rather than combat maps with shops pasted into them.

Primary purposes:
- preparation;
- recovery;
- crafting/upgrading;
- research/bestiary;
- contracts;
- storage/loadout;
- merchants/services;
- NPC relationships/story;
- crystal/material processing if society uses them;
- visual proof of civilization surviving beside dangerous ecosystems.

## 4.1 Settlement simulation budget

Settlement priority differs from wilderness.

More budget can go to:
- NPC schedules/patterns;
- shops/workstations;
- environmental storytelling;
- dialogue/interactions;
- visible crafting/processing;
- architecture;
- ambient civilians;
- music and social soundscape.

Less budget is needed for:
- large-monster tactical anatomy;
- heavy combat VFX;
- full hunting-track simulation;
- many active wilderness predators;
- first-person encounter assets.

## 4.2 Settlement safety rule

Default design:
- ordinary random monster combat does not begin inside the settlement core;
- weapons can be restricted/sheathed by presentation/rules where appropriate;
- normal NPC schedules assume the core is protected;
- danger can exist at gates/outskirts or in authored exceptional events.

This preserves settlements as a pacing/recovery contrast.

Future option:
- rare siege/emergency/monster-incursion events may temporarily override settlement safety if the campaign later needs them.

Do not make random city attacks a normal background event unless deliberately designed.

## 4.3 Settlement layout

A settlement should be physically navigable and compact enough that useful services are easy to learn.

Recommended functional districts/anchors:
- arrival gate / caravan point;
- hunter lodge / contract board;
- smith / equipment workshop;
- material processing / harvest service;
- research / crystal / bestiary service depending on setting;
- merchant area;
- storage/loadout;
- inn/recovery/home base;
- training yard;
- residential/ambient areas;
- outbound hunting gate.

Do not make each shop a disconnected menu if the service can exist naturally in the world.

# 5. Frontier Gate / Transition Belt

The settlement should not cut directly from a busy town square to a giant monster standing five meters outside.

Use a frontier transition belt around or beyond the settlement gate.

Possible features:
- walls/palisades/natural defensive terrain;
- watch posts;
- hunters/guards;
- stables/caravans;
- supply depot;
- training targets;
- last safe camp;
- warning signs/trophies;
- trailheads into multiple hunting regions;
- monster-damage evidence farther from the gate.

This belt changes the player's mental state:
`SAFE / SOCIAL → PREPARATION → FRONTIER → DANGER`

## 5.1 Technical purpose

The transition belt is also useful for:
- unloading dense settlement NPCs;
- loading wilderness assets;
- changing music/ambience;
- activating ecology simulation;
- switching navigation/encounter systems;
- saving/checkpointing;
- preloading nearby monster assets;
- applying hunt loadout validation.

The transition can be visually continuous even if scenes/sectors change underneath.

# 6. Hunting Regions

A hunting region is a bounded but physically explorable wilderness territory.

It is not a tiny arena and not a massive empty open world.

Each region should feel like a meaningful ecosystem with multiple routes and landmarks.

Recommended contents:
- terrain sectors;
- paths/trails;
- elevation changes;
- water/mud/brush/rock/ice/etc.;
- caves/nests/ruins where relevant;
- monster territories;
- feeding/watering sites;
- migration paths;
- tracking evidence;
- gathering materials;
- tactical cover opportunities;
- hazards;
- camps/safe field points;
- region exits;
- encounter-compatible terrain anchors.

# 7. Region sector structure

Each hunting region should be internally divided into sectors/cells for streaming and simulation.

Conceptual example:

```text
REGION: Verdant Basin

Sector A — Trailhead / field camp
Sector B — River crossing
Sector C — Dense root forest
Sector D — Rocky ridge
Sector E — Feeding meadow
Sector F — Cave/nesting shelf
Sector G — Deep territory / high-danger zone
```

These are physically connected in the aerial exploration world.

Only current/adjacent sectors need full rendering/simulation.

## 7.1 Sector responsibilities

A sector can define:
- bounds;
- traversal/nav data;
- terrain tags;
- landmarks;
- encounter anchors/layout references;
- monster path anchors;
- track/evidence anchors;
- gathering nodes;
- cover/hazard references;
- audio/lighting subprofile;
- streaming dependencies;
- neighbor sectors.

# 8. Region scale philosophy

Prefer density and tactical meaning over kilometers.

A region should be large enough that:
- tracking direction matters;
- monster movement/escape matters;
- there are multiple approach routes;
- terrain identity changes;
- discovering a nest/feeding site feels meaningful.

But small enough that:
- the player does not spend long periods walking through empty scenery;
- Android can stream it reliably;
- landmarks remain memorable;
- content production is realistic.

Exact dimensions remain an engine/device/prototype decision.

# 9. Settlement-to-hunt flow

Recommended normal hunt flow:

```text
SETTLEMENT
↓
choose contract / prepare equipment
↓
visit services if needed
↓
exit through hunting gate
↓
FRONTIER BELT / OUTPOST
↓
select/enter target wilderness route
↓
HUNTING REGION
↓
track / gather / observe / avoid / approach
↓
encounter begins at current real location
↓
FIRST-PERSON TACTICAL COMBAT
↓
monster defeated / escapes / hunter retreats
↓
harvest or resume tracking
↓
return to field camp / settlement
↓
process / craft / research / recover
```

# 10. Encounter placement inside the wilderness

Combat must not teleport the player into an unrelated arena.

When a monster is engaged, build the encounter from current local facts:
- source sector;
- current monster instance;
- player position;
- monster position;
- relative bearing;
- current range;
- nearby cover;
- nearby hazards;
- elevation;
- terrain tags;
- escape routes;
- local weather;
- destructible/persistent objects if supported.

The first-person combat presentation can simplify geometry but must preserve the tactical meaning of the location.

# 11. Battlefield / Encounter footprint

A battlefield is a local tactical footprint within a wilderness sector, not the entire region.

Conceptually:

```text
WILDERNESS SECTOR
└── Encounter Footprint
    ├── player tactical nodes
    ├── monster anchor/movement relationships
    ├── cover
    ├── elevation
    ├── hazards
    ├── escape nodes
    └── visual anchors from real world geometry
```

This lets us author many encounter-capable locations without building a separate combat map for every fight.

# 12. Camps and field safety

Use a hierarchy of safety rather than binary town/wilderness only.

### Settlement Core
High safety / full services.

### Frontier Outpost
Moderate safety / limited services / hunt launch point.

### Field Camp
Temporary/local safety; limited recovery, loadout, storage or travel functions depending on final design.

### Wilderness
Normal monster/ecology danger.

### Deep Territory / Nest
High danger; strongest ecological pressure; limited retreat options.

This gives the world a readable danger gradient.

# 13. Map UI hierarchy

Use different map scales rather than one overloaded map.

## World Atlas
Shows macro geography and travel destinations.

## Region Map
Shows the currently known hunting region:
- major landmarks;
- camps;
- discovered paths;
- known hazard zones;
- known monster evidence/territory only when knowledge supports it.

## Tactical Context
During combat, do not open a giant atlas.
Show only relevant local position/cover/range/bearing information.

The player should not receive perfect omniscient monster positions unless a mechanic has earned that information.

# 14. Discovery / fog of knowledge

Recommended:
- physical terrain can be revealed through exploration;
- landmarks become permanent map knowledge once discovered;
- monster territory/evidence is more temporary/contextual;
- mutation/crystal/ecology data appears only after research/tracking reveals it;
- dangerous deep zones can begin partially unknown.

This makes map progression part of hunting knowledge.

# 15. Settlement/world state separation

Do not use one giant object with every NPC and monster active at once.

Conceptual persistent structure:

`WorldState`
- unlocked atlas nodes/routes;
- settlement states;
- region ecological aggregates;
- persistent important monster instances;
- contracts/world flags;
- travel state.

`SettlementState`
- local NPC schedule/relationship/service flags;
- shop/service state;
- story/contract flags;
- local visual damage/emergency state if persistent.

`RegionState`
- discovered landmarks/camps;
- ecology/population aggregates;
- persistent hunt monsters;
- regional mutation/crystal pressure;
- local world changes;
- active contract state;
- resource refresh policy.

Only the entered location expands into full runtime scene state.

# 16. Ecosystem integration

Hunting regions own ecological pressure; settlements normally do not run full wild ecology simulation.

Region-level ecology can track aggregate:
- species abundance;
- mutation-family pressure;
- elemental pressure;
- crystal tier/rank distribution;
- predator/prey balance;
- weather/terrain selection pressures;
- hunting pressure.

When a monster becomes physically relevant, those aggregates help generate/select its actual persistent instance traits.

This maintains a living mutation-driven ecosystem without simulating every creature in detail.

# 17. Settlement/ecosystem boundary

The frontier exists because civilization and mutated ecology exert pressure on one another.

Possible worldbuilding explanations remain open:
- walls/palisades;
- terrain chokepoints;
- patrols/hunters;
- deterrent substances/noise/fire;
- crystal-based defenses if human crystal technology is later approved;
- monsters avoiding dense human activity unless starving/enraged/displaced.

Do not lock crystal-powered settlement wards until human use of crystals is decided.

# 18. Region escalation

A single region can contain an internal danger gradient rather than every monster being equally dangerous everywhere.

Example:
- trailhead: low mutation pressure / small creatures;
- middle territory: normal predators;
- elemental pocket: specialized mutations;
- deep territory: higher-rank crystal creatures;
- nest/core zone: dominant creature / boss / rare resources.

This lets one region support progression without arbitrary invisible level walls.

# 19. Monster escape behavior and map continuity

If a monster flees combat:
- encounter ends;
- same monster instance returns to the region;
- surviving wounds/anatomy/crystal reserve persist according to rules;
- it moves toward a valid retreat/nest/territory location;
- new blood/tracks may be created;
- behavior can become more defensive/aggressive/desperate;
- it may enter berserk later if conditions are met.

The map therefore supports a multi-stage hunt rather than requiring every battle to end in death.

# 20. Fast travel philosophy

Fast travel is allowed between discovered safe anchors if it improves pacing.

Recommended hierarchy:
- settlement ↔ settlement via atlas travel;
- settlement ↔ discovered outpost/camp where rules allow;
- camp ↔ camp only if it does not erase tracking/tactical decisions;
- no instant teleport directly onto an undiscovered monster.

Fast travel should reduce repeated empty traversal, not remove the hunt.

# 21. Loading/performance architecture

Different scene types have different budgets.

### Settlement
More NPCs/interactions/architecture; no full wilderness creature ecology around every corner.

### Frontier/Outpost
Moderate NPCs + limited wilderness systems.

### Hunting Region
Fewer civilians; more terrain/monster/tracking/ecology systems.

### First-Person Encounter
Only local combat-critical monster/terrain/VFX/audio systems at highest detail.

When transitioning:
1. persist authoritative outgoing state;
2. unload/deactivate expensive outgoing presentation;
3. preload destination essentials;
4. activate destination simulation tier;
5. reconstruct presentation from authoritative state.

# 22. Save/checkpoint boundaries

Useful safe save points:
- settlement arrival/departure;
- entering/leaving a hunting region;
- field camp;
- encounter start/end depending final save policy;
- important progression/crafting operations.

The exact save-anywhere policy remains open.

# 23. Music/audio separation

Settlement:
- warmer structured theme;
- voices/workshops/market ambience.

Frontier gate:
- music thins;
- wind/wildlife/distant calls become stronger;
- preparation tension increases.

Wilderness:
- sparse exploration layers;
- ecological ambience;
- tracking/threat tension.

Combat:
- tactical combat state music and telegraph-priority audio.

Returning to settlement should create an audible sense of safety/release.

# 24. Creator/Admin map tooling

Future tools should support:
- world-atlas node/route editor;
- settlement anchor/service overlay;
- frontier transition boundary viewer;
- region sector viewer;
- streaming state overlay;
- ecology-pressure overlay;
- monster territory/path overlay;
- track/gathering anchor overlay;
- encounter-capable footprint viewer;
- tactical-node/cover/elevation preview;
- first-person preview from encounter nodes;
- performance cost by sector;
- spawn/persistent-instance inspector.

# 25. First vertical-slice map scope

Keep first slice intentionally small:
- 1 compact settlement or frontier lodge;
- 1 outbound gate/transition belt;
- 1 hunting region;
- approximately 4–6 meaningful wilderness sectors;
- 1 field camp;
- 1 main monster territory;
- 2–3 encounter-capable footprints;
- 1 deeper nest/retreat location;
- enough alternate paths/terrain that tracking/approach choices are real.

Do not build the world atlas as a huge content system before the first settlement-region loop works.

# 26. Current decisions versus open questions

## Current structural decisions
- layered world rather than one enormous always-loaded open world;
- settlements and hunting regions are separate runtime spaces with different simulation/performance budgets;
- a frontier/outpost transition separates safety from wilderness danger;
- wilderness remains physically explorable in aerial view;
- long-distance geography uses a macro atlas/travel layer rather than requiring empty continuous walking;
- first-person combat is local to the real wilderness encounter location;
- hunting regions are sectorized/streamed;
- settlements default to safe social/service gameplay;
- rare settlement emergency combat remains a future authored option;
- region ecology is aggregate off-screen and detailed only for relevant/persistent creatures.

## Still open
- exact atlas art/style;
- exact settlement size/density;
- seamless visible gate transition versus short controlled loading transition;
- number of settlements long term;
- camp fast-travel rules;
- save-anywhere versus anchor/checkpoint policy;
- settlement defense lore/technology;
- whether human crystal technology powers defenses;
- exact first region sector count/dimensions;
- day/night/weather influence on travel and settlement gates;
- whether some hunting regions connect physically to each other without returning to atlas.

# 27. Implementation rule

Do not implement any map scene yet.

When implementation is authorized, first prove:
1. one tiny settlement/frontier space;
2. transition into one sectorized hunting region;
3. stable streaming/unloading;
4. one persistent monster moving between sectors;
5. local aerial-to-first-person encounter transition;
6. monster escape back into the region;
7. return to settlement without duplicated state;
8. Android performance/memory stability.

Only then expand world scale.
