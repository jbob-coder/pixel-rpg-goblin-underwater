# Pixel RPG — State Ownership Contract 001

Status: IMPLEMENTED CONTRACT / EXECUTABLE OWNERSHIP GATE / NO BROAD PERSISTENCE IMPLEMENTATION  
Last reconciled: 2026-09-25

Current related implementation: issue #9 — Separate player movement, touch input and first-person camera controllers.  
Historical source issue reference is superseded by the current repository issue map.

## Purpose

Define one owner for every current mutable gameplay/control datum and reserve bounded owners for upcoming durable systems without creating a giant global singleton.

Primary law:

**Only the declared owner may be authoritative for a datum. Presentation may render state and send intent; it may not silently become durable gameplay truth.**

Executable contract:
`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Focused gate:
`game/tests/pixel_rpg_state_ownership_contract_test.gd`

## Owner classes

### World runtime owners

- `world.hunter_body` owns the live Hunter transform and physics velocity.
- `world.mudcrest_proxy` owns the current compact-world Mudcrest transform/presentation placement.

The collidable domain body alias introduced by Combat Bridge 002 exists for stable domain identity/collision integration. It does not become a second transform authority.

### Combat-domain owners

- `domain.combat_turn_shell` owns round scheduling, current actor, AP/RP/Stamina and terminal combat scheduler state.
- `domain.mudcrest_anatomy` owns per-part integrity and resolution deduplication.

Presentation variables such as `_combat_domain_started` are orchestration latches only. Runtime-node existence plus domain state are the combat truth.

### Transient-control owners

Current ownership is deliberately split rather than concentrated in one prototype controller:

- `control.exploration_input` is implemented by `touch_input_state_001.gd`, held by the prototype as one transient `_touch_input_state` reference. It owns joystick vector, joystick touch capture, look touch capture and last look position.
- first-person yaw/pitch remains transient camera-control state while the camera-controller extraction continues;
- targeting open/selected/locked state remains transient targeting control;
- contextual interaction selection remains transient interaction control;
- scene/bootstrap latches remain orchestration state.

The prototype may route events to these owners, but it must not duplicate their authoritative mutable properties.

These are not gameplay-save data.

Camera sensitivity is currently a runtime control value. A future local-preferences owner may persist it, but it must remain outside gameplay save-state authority.

### Presentation owners

HUD labels, visibility, target highlight materials, minimap rendering and other derived visual state are disposable.

They are rebuilt from gameplay/control truth and are never persisted as authoritative gameplay state.

### Planned durable owners

Future durable state is deliberately split:
- `durable.player_state` — progression/player durable facts;
- `durable.world_state` — section/world/quest decision facts;
- `durable.inventory_equipment` — item/material/equipment ownership;
- `durable.npc_relationships` — NPC relationship/memory facts;
- `durable.economy_state` — wallet/economy facts.

These owner namespaces are reserved by contract but are not claimed as implemented runtime systems.

## Persistence boundary

Current persistence classifications:

- `NEVER_GAMEPLAY_SAVE` — touch/input/camera/targeting/presentation/runtime physics.
- `LOCAL_PREFERENCE_NOT_GAMEPLAY_SAVE` — user preference candidates such as camera sensitivity.
- `DURABLE_ELIGIBLE_NOT_IMPLEMENTED` — current world transforms that a future save owner may snapshot after ownership migration.
- `CHECKPOINTABLE_ACTIVE_DOMAIN_NOT_IMPLEMENTED` — deterministic combat/anatomy state that may be checkpointed only through an explicit stable combat save contract.
- `DURABLE_GAMEPLAY_PLANNED` — future player/world/inventory/NPC/economy state.

No serializer is introduced by this slice.

## Active-combat rule

Combat state remains in the verified deterministic owners. Future persistence must serialize a stable domain snapshot; it must not save UI widgets, replay callbacks, or infer combat truth from whether a targeting panel is open.

## First-person rule

Camera yaw/pitch, touch ownership, look state and SpringArm compatibility state are transient presentation/control state. None may mutate durable player/world/combat state merely because first-person presentation initializes.

## Legacy-coordinate firewall

The legacy Hunt-01 tactical movement graph remains separate from current compact-world spatial authority. This ownership contract does not promote legacy Region-01 nodes into current world state.

Later attack integration must use an explicit current-world spatial adapter rather than allowing an old tactical movement owner to teleport the live Hunter.

## Migration order

NOW:
1. keep owner identities and persistence eligibility explicit as the prototype is decomposed;
2. audit runtime properties at the declared owner rather than assuming every property still lives on the prototype;
3. preserve first-person + current combat-domain behavior.

NEXT:
1. continue mechanical controller decomposition without duplicating state authority;
2. introduce durable player/world owners only when persistence work begins;
3. route presentation intent through explicit boundaries.

LATER:
1. versioned save schema;
2. stable safe-point snapshots;
3. migration/corruption handling;
4. optional active-combat checkpoint serialization.

## Non-goals

This slice does not:
- add a global GameState singleton;
- implement save/load;
- persist camera/input/HUD;
- migrate combat state;
- add attack/damage;
- alter first-person camera behavior;
- alter world geometry or actor transforms.
