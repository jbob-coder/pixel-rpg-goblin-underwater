# Settlement 01 — SectionDefinition / SectionInstance Runtime Contract

Status: IMPLEMENTATION-PREPARED / INPUT TO ISSUE #3  
Created: 2026-09-26

## Goal

Represent Settlement 01 as stable logical sections while preserving one continuous first-person world.

## SectionDefinition

Immutable/config-authored record.

Required fields:

- `section_id: StringName`
- `display_name: String`
- `bounds_min_x: float`
- `bounds_max_x: float`
- `bounds_min_z: float`
- `bounds_max_z: float`
- `neighbor_section_ids: Array[StringName]`
- `connector_ids: Array[StringName]`
- `building_ids: Array[StringName]`
- `area_ids: Array[StringName]`
- `npc_anchor_ids: Array[StringName]`
- `interior_ids: Array[StringName]`
- `minimap_shape_id: StringName`
- `preload_hint_ids: Array[StringName]`
- `unload_hint_ids: Array[StringName]`
- `save_namespace: StringName`
- `schema_version: int`

Optional:
- `stream_priority: int`
- `visibility_group_ids`
- `ambient_profile_id`

## SectionInstance

Runtime state for one loaded/known section.

Required runtime fields:

- `definition_id: StringName`
- `lifecycle_state`
- `is_loaded: bool`
- `is_visible: bool`
- `is_current_player_section: bool`
- `active_connector_ids`
- `loaded_building_ids`
- `visible_npc_ids`
- `persistent_snapshot_version`
- `last_activation_sequence`

Allowed lifecycle states:

- `UNLOADED`
- `PRELOADING`
- `LOADED_INACTIVE`
- `ACTIVE`
- `UNLOAD_PENDING`

## Ownership law

SectionDefinition owns:
- static spatial/config relationships.

SectionInstance owns:
- runtime lifecycle only.

Neither owns:
- player transform;
- NPC durable relationship state;
- combat state;
- inventory;
- camera;
- HUD.

## Stable section IDs

- `SET01_S01` — South Gate / Arrival
- `SET01_S02` — Central Plaza / Market
- `SET01_S03` — West Residential / Local
- `SET01_S04` — East Work District
- `SET01_S05` — North Hunter Exit

## Section bounds

### SET01_S01
- X -30..+30
- Z +14..+34

Areas:
- A01
- A02
- A03
- shared A04 corridor segment

Neighbors:
- S02

### SET01_S02
- X -14..+14
- Z -14..+14

Areas:
- A05
- shared A04 corridor segment

Neighbors:
- S01
- S03
- S04
- S05

### SET01_S03
- X -30..-14
- Z -14..+14

Areas:
- A06
- A07

Neighbors:
- S02

### SET01_S04
- X +14..+30
- Z -14..+14

Areas:
- A08
- A09
- A10

Neighbors:
- S02

### SET01_S05
- X -30..+30
- Z -36..-14

Areas:
- A11
- A12
- shared A04 corridor segment

Neighbors:
- S02

## Shared Area 04 rule

`SET01_A04_MAIN_CENTRAL_SPINE` is shared infrastructure.

It must not become a sixth section.

Its geometry crosses S01, S02 and S05.

At runtime:
- physical road geometry may belong to a world/shared infrastructure owner;
- section records reference the relevant corridor segment;
- no section may duplicate the same road as separate colliding geometry.

## Current migration rule

First implementation of SectionDefinition/SectionInstance must be data-only.

Acceptance:
- definitions can represent the current settlement plan;
- no visible world movement;
- first-person controls unchanged;
- graph connectivity test passes;
- duplicate section instances impossible.
