# Settlement 01 — Runtime Graybox Implementation Plan

Status: READY FOR IMPLEMENTATION PLANNING / DOCUMENTATION ONLY  
Created: 2026-09-26

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Purpose

Translate the completed 12-area spatial/reference package into an implementation sequence that can be applied to the live Godot project without replacing proven systems or moving the entire settlement in one risky change.

This document does **not** change runtime files.

## Authoritative inputs

- `SETTLEMENT_01_MASTER_LAYERED_BLUEPRINT_2026-09-25.md`
- `AREA_12_PLAN/FINAL_AREA_REFERENCE_SPATIAL_LOCK_2026-09-26.md`
- `AREA_12_PLAN/AREA_REFERENCE_REGISTER_2026-09-25.md`
- `BUILDING_BLUEPRINTS/`
- `MODEL_SHEETS/`
- `AREA_ASSET_REVIEWS/`

## Final reference status

- 12 / 12 F001 references generated
- 12 / 12 archived
- 12 / 12 documentation spatial-check PASS
- creator-final-visual approval remains separate
- runtime implementation remains not started

Archive:
`/Pixel RPG/Settlement 01/Final Area References/`

## Runtime strategy

Do not replace the current world in one commit.

Use this progression:

1. create data/ownership layer;
2. reproduce current settlement through section/area records;
3. add reusable building graybox standard;
4. migrate one area at a time;
5. run focused collision/navigation tests after every area;
6. preserve first-person controller and combat-domain boundaries;
7. only enable streaming after the static 12-area settlement is stable.

## Area ownership model

The five durable settlement sections remain the primary streaming/save ownership layer.

The twelve areas are authored sub-areas inside those sections.

```
SET01_S01
  A01 South Arrival Gate
  A02 Gate Barracks & Security
  A03 Caravan / Visitor Staging

SHARED CONNECTOR
  A04 Main Central Spine Road

SET01_S02
  A05 Central Market Plaza

SET01_S03
  A06 Community Hall / Civic Core
  A07 West Residential Cluster

SET01_S04
  A08 East Work Frontage / Worker Passage
  A09 Smithy & Craft Quarter
  A10 Storage / Workshop Yard

SET01_S05
  A11 North Hunter Staging Ground
  A12 North Watch Gate & Trail Exit
```

Area 04 remains shared infrastructure; it must not become a separate durable save owner.

## Proposed runtime scene/data layers

### Settlement root

Proposed future stable owner:
`Settlement01Root`

Responsibilities:
- section registry
- shared connector registry
- area registry
- world-coordinate origin
- section lifecycle orchestration hooks

Must not own:
- player durable state
- combat state
- crafting state
- NPC relationship state

### Section instance

Proposed:
`SettlementSectionInstance`

Contains:
- stable section ID
- area IDs
- bounds
- neighbor IDs
- connector records
- building references
- NPC anchor groups
- presentation group
- collision group

### Area instance

Proposed:
`SettlementAreaInstance`

Contains authored sub-area composition only:
- stable area ID
- parent section
- local bounds
- prop/building references
- interaction-anchor references
- minimap label/source
- visibility hints

Area instance is not a durable gameplay silo.

## Shared infrastructure

### Ground

Walking physics remains independent from road visuals.

Target:
- continuous settlement floor
- no duplicate thin road colliders
- no section-boundary height seams

### Main Spine

Area 04 presentation:
- 8 m wide
- X -4..+4
- Z -35..+33

Physics:
- ground-owned

### Central Cross Street

- Z -2.5..+2.5
- X -20..+20

Presentation only unless a deliberate curb/step is later added.

## Building migration register

| Building | Area | Fixed center | Footprint | Initial runtime action |
|---|---|---:|---:|---|
| South Gatehouse W | A01 | -8,+29 | 8×7 | new graybox |
| South Watch E | A01 | +8,+29 | 6×6 | new graybox |
| Arrival Guard/Barracks | A02 | -20,+23 | 7×6 | new graybox |
| Arrival Storage | A03 | +20,+23 | 7×6 | new graybox |
| Community Hall | A06 | -24.5,0 | 8×10 | new graybox |
| Residence W02 | A07 | -24.5,-10 | 7×5.5 | new reusable residence |
| Residence W01 | A07 | -24.5,+10 | 7×5.5 | second instance/variant |
| Smith | A09 | +24.5,0 | 6.6×6.4 | migrate current smith |
| Work Canopy | A10 | +24.5,-9.5 | 7×6 | new open structure |
| Work Storage | A10 | +24.5,+9.5 | 7×6 | new graybox |
| Hunter Watch | A12 | -19,-27 | 7×7 | new graybox |
| Supply Cache | A12 | +19,-27 | 7×6 | new graybox |

## Reusable building implementation standard

Every important enterable building must expose:

- stable BuildingID
- SectionID
- AreaID
- EntranceAnchor
- ExitAnchor
- InteriorCenterAnchor
- service/NPC anchors as required
- segmented wall collision
- real doorway opening
- interior floor
- roof visibility group where required

No solid-box fake-door building is accepted as final.

## Proposed graybox build order

### Pass G00 — schema and identity

Implement only:
- section definitions
- area definitions
- connector IDs
- fixed coordinate constants/data

Do not move current visible world yet.

Tests:
- all IDs unique
- all areas have valid parent section
- required section graph valid
- area bounds valid

### Pass G01 — shared floor and Main Spine

Graybox:
- continuous 60×70 m settlement floor
- Main Spine
- Cross Street
- section boundary markers in debug only

No buildings moved yet.

Tests:
- continuous floor
- no seams
- 8 m spine preserved
- 5 m cross street preserved

### Pass G02 — A05 Central Plaza

Reason:
central reference point for all district placement.

Add:
- plaza bounds
- four stall sockets
- civic-water placeholder
- notice-board socket
- social anchors

Tests:
- cross remains open
- stalls outside clear routes

### Pass G03 — A09 Smith

Migrate current enterable smith to locked center +24.5,0.

Preserve:
- real doorway
- segmented collision
- forge/anvil/bench
- current interaction anchors
- roof behavior

Tests:
- doorway still passes
- frontage clear
- no service-state regression

### Pass G04 — A06 Community Hall

Build second major enterable building from reusable standard.

Tests:
- real east-facing entrance
- Hall anchors
- no sealed collision

This is the proof that the building standard works beyond the Smith.

### Pass G05 — A07 Residences

Instantiate reusable Residence Type A twice.

Tests:
- W02 north
- W01 south
- Hall remains between them
- West Frontage Lane clear

### Pass G06 — A10 Work Support

Add:
- north canopy
- south storage
- service-alley/load anchors

Tests:
- Smith remains between work pockets
- canopy open sides traversable
- storage doorway clear

### Pass G07 — A08 Worker Passage

Add only:
- frontage-lane presentation
- shift/tool edge props
- worker anchors

No building.

Tests:
- 4.5 m frontage lane preserved
- minimum usable passage not reduced by props

### Pass G08 — A01 South Gate

Add:
- Gatehouse W
- Watch E
- modular gate/frame
- 8 m opening
- wall connectors

Tests:
- center gate path clear
- side structures block correctly
- open gate leaves do not intrude

### Pass G09 — A02 Security

Add:
- Barracks
- briefing canopy
- equipment racks
- duty-board anchors

Tests:
- east connector clear
- Barracks remains 7×6
- canopy stays open-sided

### Pass G10 — A03 Logistics

Add:
- Arrival Storage
- cart sockets
- logistics awning
- trough/hitching/wayfinding anchors

Tests:
- west connector clear
- carts do not block route

### Pass G11 — A11 Hunter Staging

Add:
- bounty board
- prep racks
- supply/bench anchors
- warning presentation

Tests:
- Main Spine remains fully clear

### Pass G12 — A12 North Gate

Add:
- Hunter Watch
- Supply Cache
- North Gate
- trail transition
- Warden/return anchors

Tests:
- 8 m opening clear
- trail continuous
- Area11→Area12 route continuous

### Pass G13 — perimeter and streetscape

Only after all area geometry passes:
- modular walls
- lanterns
- benches
- signs
- carts
- controlled vegetation
- surface detail

Tests:
- no connector obstruction
- no new sealed doorway
- no unexpected collision

### Pass G14 — NPC anchors and simple schedules

Bind authored NPCs to stable area/building anchors.

No runtime generative AI required.

### Pass G15 — minimap

Derive:
- section boundaries
- area landmarks
- buildings
- gates
- road graph

Minimap remains presentation-only.

### Pass G16 — conservative streaming

Only after static settlement passes all navigation tests.

Start with:
- current + directly adjacent section availability
- no aggressive visible unloads

### Pass G17 — persistence hooks

Persist by stable IDs.

Do not serialize transient node ownership.

## Collision verification matrix

Required route tests:

1. South Gate → Plaza
2. Plaza → Community Hall
3. Plaza → Residence W01
4. Plaza → Residence W02
5. Plaza → Smith
6. Smith → Work Storage
7. Smith → Work Canopy
8. Plaza → North Staging
9. North Staging → North Gate
10. North Gate → Trail
11. every important building doorway
12. every section connector

## Final-reference usage rule

F001 images are:
- visual placement guides
- prop-density guides
- pixel-language references

They are not:
- collision data
- save data
- authoritative dimensions beyond what the blueprint separately records
- justification to move a fixed parcel

When image and blueprint disagree:
`BLUEPRINT / SPATIAL LOCK WINS`.

## Implementation branch rule

Do not implement this settlement directly on `documentation`.

Before runtime work:
1. re-fetch live `main`;
2. verify current HEAD and open PR state;
3. choose/create the authorized implementation branch;
4. apply one bounded graybox pass;
5. test before continuing.

## Completion criteria

The settlement graybox is complete only when:

- all five sections exist;
- all twelve areas occupy locked positions;
- all important buildings have real doors/interiors;
- all required connectors are traversable;
- Main Spine and Cross Street remain clear;
- collision ownership is explicit;
- current first-person controls still pass regressions;
- Android export passes;
- physical-device acceptance is performed separately.
