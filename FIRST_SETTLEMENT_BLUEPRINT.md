# Unnamed Hunt RPG — First Settlement Blueprint

Status: SELECTED FIRST-SETTLEMENT STRUCTURE + PROTOTYPE TARGETS / NO IMPLEMENTATION
Last reconciled: 2026-09-02

## Purpose

Define the first settlement as a real walkable gameplay space rather than a collection of menus or decorative buildings.

This document is intentionally bounded to **Settlement 01**. It does not define every future settlement, the full wilderness region, final lore, final NPC cast, or production art.

It refines:
- `MAP_WORLD_SETTLEMENT_STRUCTURE.md`;
- `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`;
- `DESIGN_QUALITY_GATES_AND_DEPENDENCY_MATRIX.md`.

---

# 1. Primary quality fix — functional walkability

A walkable settlement can become worse than a menu hub if the player repeatedly spends too long walking between services.

Therefore Settlement 01 uses two overlapping layouts:

1. **Hunter Service Loop** — the compact repeated-use path for contracts, storage/loadout, crafting/processing, recovery and departure.
2. **Living Settlement Layer** — market, residences, social spaces, civic/story locations and visual depth surrounding the service loop.

The settlement must feel like a believable place without making repeated hunt preparation tedious.

### Core rule

**Frequently repeated gameplay services are close together; optional social/worldbuilding spaces provide breadth around them.**

Do not scatter mandatory services across opposite ends of town merely to make the settlement seem larger.

---

# 2. Settlement identity

Working technical ID:
`SETTLEMENT_01`

Final name: **OPEN**.

Selected physical identity:

**A compact frontier hunter settlement built on defensible elevated terrain beside a river/chasm crossing, with one major outbound hunting gate leading toward the wilderness.**

Reasons:
- naturally explains why civilization survives near large mutated creatures;
- creates strong visual layers for the aerial camera;
- provides cliffs/water/walls as natural boundaries instead of invisible barriers;
- gives the hunter gate a logical chokepoint;
- supports bridges, watchtowers and vertical landmarks;
- matches the successful first concept-map direction without copying the image literally;
- allows wilderness to be visible in fragments without exposing the full region.

Exact lore of the settlement's founding and defenses remains OPEN.

Crystal-powered defenses are not assumed until human crystal technology is decided.

---

# 3. Prototype physical scale

These are **PROTOTYPE TARGETS**, not measured final dimensions.

Preferred characteristic playable extent:
- approximately **220–280 m** along the long axis;
- approximately **160–230 m** along the shorter axis;
- irregular footprint shaped by cliff, river, walls and terrain rather than a rectangle.

The settlement should feel larger than what the player can see at once.

The player should normally see only one or two nearby functional landmarks plus distant roof/tower silhouettes.

Avoid a camera angle where the entire town is visible like a board-game map.

---

# 4. Spatial organization

Settlement 01 should use a readable five-zone structure.

```text
                [UPPER RESIDENTIAL / RECOVERY]
                         /          \
                        /            \
            [MARKET / CIVIC] ---- [HUNTER LODGE]
                   |                    |
                   |                    |
          [CRAFT / PROCESSING] ---- [LOADOUT / STORAGE]
                   |                    |
                   \______ [HUNTER GATE] ______/
                              |
                       [FRONTIER CORRIDOR]
                              |
                         WILDERNESS
```

The diagram represents relationships, not exact geometry.

Terrain, curved streets, walls, stairs and elevation should prevent all zones from being visible simultaneously.

---

# 5. The Hunter Service Loop

This is the settlement's repeated gameplay spine.

Preferred sequence:

`HUNTER LODGE / CONTRACTS → STORAGE / LOADOUT → SMITH / CRAFT / PROCESSING → HUNTER GATE`

Recovery/home should connect to this loop without requiring a long detour.

## 5.1 Target travel quality

Prototype target from one core service to the next:
- usually around **10–25 seconds of normal walking**;
- no mandatory repeated service should routinely require a minute-long cross-town trip.

Exact movement speed and travel time remain engine/prototype decisions.

The target exists to prevent settlement realism from becoming repetitive friction.

## 5.2 Shortcuts

Use believable shortcuts rather than teleporting the player between buildings:
- side alley;
- lodge rear stair;
- covered passage;
- bridge/terrace connection;
- processing-yard gate;
- upper/lower street stair.

Shortcuts can unlock as the player learns the town, but the first loop should already be practical.

---

# 6. Primary landmarks

Settlement navigation should rely first on physical landmarks rather than floating quest arrows.

## Hunter Lodge
Role:
- contract center;
- hunter administration;
- research/bestiary access where appropriate;
- major social/story anchor;
- orientation landmark.

Silhouette:
- broad recognizable roof mass;
- banners/signage;
- trophy/preparation architecture;
- elevated or visually central position.

## Hunter Gate
Role:
- wilderness departure/return;
- loadout checkpoint where relevant;
- technical settlement↔wilderness transition anchor.

Silhouette:
- fortified opening;
- watchtowers/guard structures;
- view toward wilderness but not full-region visibility.

## Smith / Workshop
Role:
- weapon/armor crafting and upgrades;
- visible material transformation;
- equipment identity.

Silhouette:
- chimney/furnace;
- open work area;
- racks/storage;
- strong warm-light/fire cue without excessive emissive cost.

## Material / Harvest Processing Yard
Role:
- receives monster materials;
- cleaning/sorting/tanning/cutting/processing;
- visually connects hunting success to civilization.

Placement:
- near hunter gate and smith;
- not deep in the residential core;
- accessible by cart/service route.

## Watchtower / Defensive Tower
Role:
- orientation landmark;
- communicates settlement defense;
- can visually mark hunter-gate side of town.

---

# 7. Functional zones

## 7.1 Hunter / Service Quarter
Contains:
- hunter lodge;
- storage/loadout;
- equipment maintenance;
- contract preparation;
- training access;
- direct route to hunter gate.

This is the player's most frequently used zone.

## 7.2 Craft / Processing Quarter
Contains:
- smith;
- material processing;
- tanning/drying/storage;
- crystal-handling facility only if later lore approves human crystal processing;
- carts and heavy service access.

Visual character:
- practical;
- noisy;
- smoke/steam in bounded amounts;
- work yards rather than narrow residential alleys.

## 7.3 Market / Civic Quarter
Contains:
- general merchants;
- food/supplies;
- public meeting/notice area;
- optional story/social services;
- caravan/visitor activity where appropriate.

This zone should create life without becoming mandatory before every hunt.

## 7.4 Residential / Recovery Quarter
Contains:
- homes;
- inn/recovery space;
- player's home/base if adopted;
- quieter NPC routines;
- small courtyards and communal areas.

It should visually contrast with the industrial quarter.

## 7.5 Defensive / Frontier Edge
Contains:
- hunter gate;
- walls/palisades/terrain choke;
- watch posts;
- guard/hunter staging;
- supply checkpoint;
- transition corridor toward wilderness.

The atmosphere gradually shifts here from safety to frontier tension.

---

# 8. Street hierarchy

Use three street classes.

## Main Hunter Spine
Prototype width target:
- roughly **7–10 m** including edge space where appropriate.

Connects:
- lodge;
- service quarter;
- gate.

Must remain readable and unobstructed enough for aerial navigation.

## Secondary Streets
Prototype width target:
- roughly **4–7 m**.

Connect districts and residences.

Can curve, climb or narrow to control sight lines.

## Alleys / Service Passages
Prototype width target:
- roughly **2–4 m** where collision/camera testing allows.

Used for:
- shortcuts;
- back entrances;
- visual depth;
- service access.

Do not make critical navigation depend on very narrow alleys if the aerial camera cannot read them reliably.

---

# 9. Elevation strategy

Use approximately **2–3 major walkable elevation bands**, not a flat town and not an excessive maze of stairs.

Candidate arrangement:

### Lower/frontier terrace
- hunter gate;
- processing yard;
- heavy carts/supplies;
- direct wilderness connection.

### Main terrace
- hunter lodge;
- smith;
- storage/loadout;
- market/civic core.

### Upper/quieter terrace
- residences;
- recovery/inn;
- selected story locations;
- viewpoint landmarks.

Benefits:
- settlement looks larger than its footprint;
- districts gain identity;
- roof lines naturally break sightlines;
- camera composition improves;
- defensive geography feels plausible.

Accessibility rule:
Important repeated-service paths should not require excessive stair climbing.

---

# 10. Camera and visibility design

The settlement must be designed around the aerial camera from the beginning.

## 10.1 Local visibility

Normal play should show:
- player;
- current street/courtyard;
- nearby entrances;
- one or two useful landmarks;
- partial distant skyline.

Normal play should not show:
- the complete settlement layout;
- every service at once;
- every NPC simultaneously.

## 10.2 Occlusion as composition

Use:
- curved streets;
- terraced elevation;
- walls;
- large roof masses;
- trees/awnings sparingly;
- towers/chimneys;
- cliff geometry.

These are not only visual decoration. They control what the player sees and what the renderer needs to display.

## 10.3 Roof behavior

When the player enters an important building:
- roof may fade/hide/cut away;
- selected upper wall sections may lower/fade;
- camera framing may tighten slightly;
- neighboring inaccessible interiors stay hidden.

Do not make all roofs globally transparent.

Visibility changes should be local to the active building/room group.

---

# 11. Building interior policy

## Seamless priority interiors
Prefer seamless physical entry for:
- smith/workshop;
- storage/loadout;
- selected merchant;
- recovery/home space;
- material processing service where enclosed.

## Hunter Lodge
May be:
- fully seamless if device budget supports it;
- or use a short threshold hall/stair for interior streaming if larger.

The threshold must feel architectural, not like an arbitrary loading portal.

## Residential buildings
Not every residence must be enterable.

Use three categories:
- enterable/functionally relevant;
- visible-interior/window/door dressing;
- exterior-only background structure.

This controls production cost.

---

# 12. Building-kit requirements

Settlement 01 should be constructible largely from the modular standards in `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`.

Minimum useful prototype kit:
- 2–3 foundation modules;
- straight/corner wall modules;
- timber/stone variants;
- 2–3 roof slopes;
- roof ridge/end pieces;
- doors/windows;
- posts/beams;
- stairs;
- balcony/walkway;
- awning;
- chimney;
- fence/rail;
- defensive wall;
- gate segment;
- watchtower segment;
- bridge/boardwalk pieces;
- market/service stall pieces.

Important buildings add signature pieces instead of becoming entirely unique construction systems.

---

# 13. NPC population and pattern quality

NPC behavior remains deterministic authored patterns, not AI.

A settlement should feel populated without running every resident at full fidelity.

## Runtime tiers

### Tier A — Nearby active NPCs
- visible;
- full local movement/navigation;
- interaction available;
- animation/audio as appropriate;
- behavior evaluated when events/schedule conditions require.

### Tier B — Nearby/background NPCs
- simplified routine;
- reduced interaction/presentation;
- may move between local anchors at lower update frequency.

### Tier C — Off-screen settlement population
- schedule/location state only;
- no continuous pathfinding/rendering;
- promoted into a physical actor when relevant/nearby.

This preserves deterministic schedules without wasting CPU on people the player cannot see.

Exact NPC counts remain OPEN until target-device testing.

---

# 14. Service availability and NPC schedules

A walkable settlement should not punish the player because a critical service NPC wandered somewhere inaccessible.

Quality rule:
- important repeated gameplay services must remain predictably usable;
- schedules can change presentation/location, but required progression services need fallback access rules.

Examples:
- smith works at forge during normal hours but can still provide essential interaction through a nearby workshop state;
- contract board can preserve contract access even if a guild NPC is temporarily elsewhere;
- storage/loadout should not depend on a specific NPC being awake.

This allows believable schedules without creating unnecessary friction.

---

# 15. Settlement state ownership

`SettlementState` should eventually own only settlement-specific truth such as:
- discovered/available services;
- local NPC schedule/location states;
- relationship/story/service flags;
- local emergency/damage state if persistent;
- settlement shortcuts/unlocks;
- local shop/service state where required.

It must not own:
- combat damage math;
- wilderness ecology simulation;
- monster anatomy;
- inventory rules;
- crystal life-force rules.

---

# 16. Settlement performance partitions

Settlement 01 should be divided into logical presentation/culling cells roughly aligned with districts/terrain, not one giant render group.

Candidate cells:
1. Hunter Lodge / central service cell;
2. Craft / processing / gate cell;
3. Market / civic cell;
4. Residential / recovery cell;
5. Transition corridor/frontier cell.

Exact geometry decides final partitions.

## Active presentation strategy
- current cell: highest detail;
- directly visible/adjacent cells: required LOD/presentation;
- occluded/far cells: aggressive culling/LOD or logical-only state;
- interiors not in use: hidden/deactivated where practical.

The player should not pay full rendering/animation cost for the entire town because the town is walkable.

---

# 17. Settlement performance budgets — prototype principles

Do not lock exact polygon/NPC/draw-call numbers before engine/device evidence.

However, every settlement subsystem must have a measurable budget category:
- visible NPC count;
- active animated NPC count;
- skinned-mesh count;
- unique materials/shaders;
- active lights/shadows;
- visible interior groups;
- particle emitters/smoke/fire;
- audio emitters;
- active interactables;
- navigation/path requests;
- memory by district/cell.

Development tools should expose these counts in real time.

---

# 18. Hunter Gate transition corridor

The hunter gate is both a narrative threshold and a technical streaming tool.

Preferred physical sequence:

`SERVICE QUARTER → OUTER COURTYARD → FORTIFIED GATE → SHORT BRIDGE/TUNNEL/PASS → WATCH/SUPPLY POST → TRAILHEAD → HUNTING REGION`

The corridor should be long/occluded enough to permit wilderness preloading but short enough not to feel like a disguised loading hallway.

During transition the game may:
- save/checkpoint according to final policy;
- demote settlement NPC simulation;
- unload/hide distant settlement interiors;
- preload the first wilderness sector and required neighbors;
- activate wilderness ecology/tracking systems;
- change music/ambience;
- validate hunt loadout where required.

Player control should remain available whenever practical.

Fallback:
If target-device evidence proves hidden streaming insufficient, a brief controlled transition may occur at the major gate boundary.

---

# 19. Return-from-hunt quality

Returning should be faster and emotionally clearer than initial departure.

On return:
- wilderness threat audio decreases;
- gate/guard/civilian ambience becomes audible;
- settlement presentation promotes as needed;
- persistent settlement state resumes;
- hunt-result/material-processing routes are close to the entrance;
- the player should not need to cross the full town simply to process a successful hunt.

This reinforces the loop:

`DANGER → RETURN → PROCESS → UPGRADE → PREPARE AGAIN`.

---

# 20. Material flow as environmental storytelling

Monster materials should enter the settlement logically.

Preferred physical flow:

`HUNTER GATE → PROCESSING YARD → STORAGE / RESEARCH / SMITH → MARKET / EQUIPMENT`

This allows the settlement to visibly communicate why different services are located where they are.

Large carcass/material processing should not occur in a quiet residential courtyard.

---

# 21. Interaction-density rule

Do not make every crate, chair and cup interactive.

Use interaction hierarchy:

### Primary
- doors;
- service stations;
- contract board;
- storage/loadout;
- important NPCs;
- training equipment;
- settlement exits.

### Secondary
- selected lore/trophy/workshop objects;
- optional conversations;
- useful environmental objects.

### Decorative
- visual only.

This protects UI clarity, content authoring time and performance.

---

# 22. Signage and navigation

Important services should be learnable visually.

Use:
- building silhouette;
- signs/banners;
- material language;
- smoke/chimney/fire for smith;
- racks/trophies for lodge;
- carts/hooks/drying frames for processing;
- market awnings/stalls;
- gate towers/flags.

Map/UI icons can assist but should not compensate for an unreadable settlement.

---

# 23. Day/night and closure handling

Day/night settlement behavior is a future system detail, but the blueprint must not create service-lock frustration.

If time affects schedules:
- ambient/residential behavior may change strongly;
- shops may visually close or reduce staff;
- essential hunt-loop functions need deliberate availability rules;
- the player must understand when/why a service is unavailable;
- waiting/resting should be convenient if time gates are used.

Exact schedule rules remain OPEN.

---

# 24. Emergency-state compatibility

Normal settlement core is safe.

Future authored emergency/siege states are allowed, so the blueprint should not make combat technically impossible.

Prepare architecture for possible future overrides:
- gates can close;
- civilians can use shelter anchors;
- guards/hunters can occupy defensive anchors;
- selected courtyards/streets can support combat navigation;
- damaged structures can have state variants.

This is compatibility planning only, not first-slice scope.

---

# 25. Admin/Creator settlement tools

Future tools should include:
- settlement district/cell overlay;
- service-anchor overlay;
- player travel-time measurement between services;
- NPC active/background/logical tier display;
- NPC schedule/location trace;
- roof/interior visibility groups;
- culling/LOD state;
- visible/animated NPC count;
- draw/material/light/audio counters;
- navigation path visualization;
- hunter-gate transition preload state;
- artificial slow-storage/slow-stream simulation;
- shortcut/door-state inspector.

A particularly useful tool should measure:

`CONTRACT BOARD → STORAGE → SMITH → GATE`

and report actual travel time/path length so settlement revisions can be judged objectively.

---

# 26. First graybox proof after implementation authorization

Do not begin with final art.

Graybox Settlement 01 should contain only:
- terrain/cliff/river boundary shapes;
- main wall/gate silhouette;
- hunter lodge blockout;
- smith blockout;
- processing yard;
- storage/loadout building;
- recovery/inn or home blockout;
- small market/civic area;
- approximately 6–10 simple residential/background structures;
- main street/secondary paths/shortcuts;
- 2–3 elevation bands;
- 2–3 seamless test interiors;
- one larger interior threshold test if needed;
- prototype NPC schedule anchors;
- frontier transition corridor.

Acceptance questions:
- Is navigation immediately understandable?
- Can the player reach repeated services quickly?
- Does the town feel larger than the camera view?
- Do roofs/walls behave correctly?
- Are key landmarks readable?
- Can NPCs move without clogging the path?
- Can unused cells/interiors be culled?
- Does the gate transition hide streaming adequately?
- Does the graybox remain stable on target Android hardware?

Only after those pass should the final settlement asset kit be produced broadly.

---

# 27. First-settlement design status

## SELECTED / CURRENT
- Settlement 01 is fully walkable.
- Compact frontier hunter settlement on defensible elevated river/chasm geography.
- Repeated hunt services form a short Hunter Service Loop.
- Processing/smith/storage are logically close to the hunter gate/lodge.
- Optional residential/market/social content expands around the functional core.
- Terrain/elevation/curved streets prevent full-map visibility during normal play.
- 2–3 major elevation bands preferred.
- Important small/medium interiors should be seamless where budgets permit.
- Settlement uses logical rendering/simulation cells.
- NPCs use active/background/logical fidelity tiers while preserving deterministic schedules.
- Gate corridor is the settlement↔wilderness streaming threshold.
- Return-from-hunt material-processing route is intentionally short.
- Modular building kit is required before broad art expansion.

## PROTOTYPE TARGETS
- overall playable extent roughly 220–280 m × 160–230 m irregular footprint;
- core-service walking legs usually roughly 10–25 seconds;
- main hunter spine roughly 7–10 m width;
- secondary streets roughly 4–7 m;
- alleys/service passages roughly 2–4 m where camera/collision testing approves;
- graybox includes approximately 6–10 background/residential structures plus core service buildings.

## OPEN
- final settlement name;
- exact lore/history;
- exact defense technology;
- whether humans use crystals in settlement infrastructure;
- final building architectural culture;
- exact player home/recovery model;
- exact NPC counts;
- exact day/night service rules;
- exact settlement damage/emergency mechanics;
- final dimensions after graybox/device testing.

## REJECTED / NOT PREFERRED
- menu-only hub;
- enormous sprawling town with mandatory services far apart;
- completely flat settlement with full-map visibility;
- every building uniquely modeled as a monolithic asset;
- every residence fully enterable at hero quality;
- every NPC simulated/pathfinding at full fidelity while off-screen;
- every decorative prop interactable.

---

# 28. Stop boundary

This document completes the **first settlement blueprint** planning piece.

Do not automatically proceed into:
- final settlement art production;
- complete NPC cast;
- first wilderness-region blueprint;
- first monster design packet;
- engine scene implementation.

The next bounded documentation piece, when requested/continued, should be the **first hunting-region blueprint** so the settlement gate and frontier have a concrete place to lead.