# Settlement 01 — Stable Connector Register

Status: IMPLEMENTATION-PREPARED  
Created: 2026-09-26

## Purpose

Provide stable connector IDs for SectionDefinition, graybox traversal, minimap continuity and future streaming.

## Required section connectors

### SET01_CON_S01_S02_MAIN

Connects:
- S01 ↔ S02

Type:
- PRIMARY_SPINE

Boundary:
- Z +14

Center:
- X 0

Clear width:
- 8 m

Required:
- player traversal
- line-of-sight continuity
- preload handoff

### SET01_CON_S02_S05_MAIN

Connects:
- S02 ↔ S05

Type:
- PRIMARY_SPINE

Boundary:
- Z -14

Center:
- X 0

Clear width:
- 8 m

### SET01_CON_S02_S03_WEST

Connects:
- S02 ↔ S03

Type:
- SECONDARY_STREET

Boundary:
- X -14

Center:
- Z 0

Clear width:
- 5 m

### SET01_CON_S02_S04_EAST

Connects:
- S02 ↔ S04

Type:
- SECONDARY_STREET

Boundary:
- X +14

Center:
- Z 0

Clear width:
- 5 m

## World-boundary connectors

### SET01_CON_WORLD_SOUTH_ARRIVAL

Connects:
- outside/civilian arrival ↔ S01

Center:
- (0,+33)

Clear width:
- 8 m

Type:
- WORLD_GATE

### SET01_CON_WORLD_NORTH_TRAIL

Connects:
- S05 ↔ external hunt trail

Center:
- (0,-35)

Clear width:
- 8 m

Type:
- WORLD_GATE

## 12-area logical connectors

These do not create new section boundaries by themselves.

Required area adjacency:

- A01 ↔ A02
- A01 ↔ A03
- A01 ↔ A04
- A02 ↔ A04/S01 interior
- A03 ↔ A04/S01 interior
- A04 ↔ A05
- A05 ↔ A06
- A05 ↔ A08
- A05 ↔ A11 via A04
- A06 ↔ A07
- A08 ↔ A09
- A08 ↔ A10
- A09 ↔ A10 through S04 circulation
- A11 ↔ A12
- A12 ↔ external north trail

## Connector data fields

Each runtime connector record should contain:

- `connector_id`
- `kind`
- `owner_section_a`
- `owner_section_b`
- `center_x`
- `center_z`
- `clear_width`
- `min_y`
- `max_y`
- `preload_section_ids`
- `minimap_link_id`
- `schema_version`

Optional later:
- transition concealment hints
- load priority
- one-way restrictions
- gate-state reference

## Compatibility law

A connector is compatible only when:
- both sections name the same connector ID;
- center position matches;
- clear width matches;
- traversal direction is continuous;
- no blocking collision crosses the connector volume.

## Streaming law

A connector may request preload.

A connector must never:
- teleport the player;
- own player transform;
- own NPC durable state;
- unload the current player section;
- unload the current interaction target's section during use.
