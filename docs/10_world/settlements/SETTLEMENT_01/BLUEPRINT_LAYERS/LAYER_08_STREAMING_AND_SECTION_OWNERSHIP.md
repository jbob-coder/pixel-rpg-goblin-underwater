# Layer 08 — Streaming and Section Ownership

Status: PROVISIONAL SECTION-DEFINITION INPUT FOR ISSUES #3/#5

## Goal

Prepare bounded section loading without changing the player's perception of one connected settlement.

Do not implement aggressive streaming first.

## Section records

Each SectionDefinition should eventually contain:
- stable section ID
- bounds/polygon
- neighbors
- connector IDs
- building IDs
- NPC anchor IDs
- prop groups
- minimap geometry
- interior references
- preload hints
- unload hints
- save-state hooks

## Ownership

### SET01_S01
Owns:
- South Gate/arrival structures
- arrival props
- arrival NPC anchors
- south perimeter segments

### SET01_S02
Owns:
- central plaza
- market stall sockets
- central civic/social props
- main intersection

### SET01_S03
Owns:
- Community Hall
- residence W01/W02
- local-life anchors/props
- west perimeter middle segments

### SET01_S04
Owns:
- smith
- work storage
- work canopy
- material/service props
- east perimeter middle segments

### SET01_S05
Owns:
- North Hunter Gate
- hunter watch
- supply cache
- Gate Warden anchors
- hunter-prep props
- north perimeter
- trail connector

## Connector ownership

Connectors must have stable IDs independent from loaded section nodes.

A connector record should know:
- section A
- section B
- position/bounds
- clear width
- world transform
- preload trigger region
- compatibility version

## Initial loading policy

First implementation:
- current section loaded
- directly adjacent section(s) preloaded/loaded as needed
- avoid unloading nearby visible geometry aggressively
- preserve uninterrupted first-person traversal

S02 may become a high-connectivity section and should be treated carefully to prevent excessive load churn.

## Interiors

Initial safe strategy:
- important interior scene belongs to parent section
- interior can remain loaded with its section
- later optimization may separate interior lifecycle

Do not add interior portals/teleport loads for the first settlement unless proven necessary.

## NPC unloaded state

When section unloads:
- NPC durable/abstract state remains
- visual node can disappear
- schedule may advance abstractly
- no duplicate NPC authority on reload

## Persistence

Section save data should reference stable IDs, not transient node paths.

Examples:
- door state
- service availability
- NPC section/activity
- world flags
- spawned/removed persistent objects

## Streaming verification

Before enabling unload:
1. section graph test
2. connector compatibility test
3. no transform discontinuity
4. no duplicate NPC/player state
5. no lost persistent props
6. no visible pop inside required visibility range
7. device memory/performance evidence

## Current-runtime rule

Current world remains monolithic/compact until section adapters reproduce it without player-visible regression.
