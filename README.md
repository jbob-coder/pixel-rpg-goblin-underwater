# Pixel RPG

Status: ACTIVE ANDROID MONSTER-HUNTING RPG / FIRST-PERSON PIXEL DIRECTION  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`

Documentation reconciliation is staged on branch `documentation`.

Pixel RPG is the active game. WorldLife is abandoned, and the later standalone first-person Shooter RPG is not the implementation base.

## Player-facing identity

**First-person pixel-styled real-3D monster-hunting RPG with mobile move/look controls, physical exploration, anatomy-focused combat, harvesting, and persistent world/NPC consequences.**

Primary presentation authority:

`PIXEL_RPG_VISUAL_DIRECTION.md`

Repository navigation:

`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

Master scan/reference:

`docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`

## Current production boot

`game/project.godot`
→ `game/scenes/app_shell.tscn`
→ `game/scripts/app_shell.gd`
→ `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`.

The current app boots into the first-person Pixel RPG prototype slice, not the older Region-01 graybox.

## Main loop target

`SETTLEMENT → PREPARE → PHYSICALLY LEAVE SETTLEMENT → EXPLORE/TRACK → OBSERVE/APPROACH → FIRST-PERSON SPATIAL COMBAT → TARGET ANATOMY → BREAK/SEVER/DEFEAT/ESCAPE → HARVEST → RETURN → NPC/SETTLEMENT CONSEQUENCES → PROCESS/CRAFT/EQUIP/LEARN → NEXT HUNT`

Use compact connected physical spaces and world compression rather than a huge empty open world or normal menu teleportation.

## Controls

- Android landscape-first;
- left virtual stick = continuous movement;
- right side = independent camera/look;
- simultaneous movement + look;
- contextual action controls;
- safe-area-aware HUD.

“Shooter-style controls” describes the familiar mobile control layout only. Pixel RPG is not the abandoned standalone Shooter RPG.

## Art direction

Pixel-styled real 3D:

- real spatial world/collision/camera;
- pixel-authored or pixel-consistent textures/sprites/UI;
- controlled low-resolution rendering/upscale where useful;
- strong silhouettes;
- readable monster anatomy;
- restrained material/lighting complexity;
- no smooth generic 3D scene with only a cosmetic pixel filter.

Image-derived presentation assets may be used when lineage and runtime verification are explicit.

Visible art does not automatically own gameplay collision.

## Current first-person implementation

Current source includes:

- direct active first-person `Camera3D`;
- camera-relative movement;
- independent look;
- hidden third-person presentation body;
- extracted camera math/state;
- extracted player motion/motor;
- extracted touch math/state;
- HUD layout/minimap math;
- camera-local ViewModel;
- canonical first-person hands PNG;
- compact settlement/trail world;
- Gate Warden interaction;
- enterable smith;
- visible Mudcrest;
- first-person targeting;
- Combat Bridge 002 no-attack bootstrap.

## Current combat boundary

The deterministic Hunt-01 domain is richer than the current first-person player-facing integration.

Current first-person flow:

Observe/Engage
→ targeting preview
→ select/lock anatomy group
→ Combat Bridge 002
→ initialize anatomy + combat turn shell
→ no attack yet.

Future combat integration should adapt current-world physical/spatial state into the proven deterministic domain rather than duplicating combat rules or blindly teleporting old Region-01 tactical coordinates.

## Gameplay foundations to preserve

Where compatible, preserve:

- deterministic combat/action resolution;
- Monster anatomy/body-part ownership;
- wounds/statuses;
- break/sever/harvest consequences;
- tracking/encounter continuity;
- stable IDs and data-driven content;
- explicit state ownership;
- regression infrastructure.

## Buildings/world

The current enterable smith is the strongest building blueprint because it has:

- a real doorway;
- segmented collision;
- entrance/use anchors;
- interior handling;
- split roof visibility;
- first-person interior support.

Generic settlement buildings still use monolithic collision despite visual doors. They should not be treated as enterable until their collision/interaction contract is rebuilt.

## State and persistence

Current state ownership is explicit and executable through:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Broad current-world save/load is not yet implemented.

Future durable state should use bounded owners for player/world/inventory/NPC/economy rather than one giant global singleton.

## Android build

Canonical workflow:

`.github/workflows/pixel-rpg-ci.yml`

Audited runtime baseline:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical run:

`36082533109` — SUCCESS

Verification job:

`107907382620` — SUCCESS

Android export job:

`107907562399` — SUCCESS

This verifies that exact source revision at automated/headless/Android-build level. It does not prove phone acceptance.

## Storage ceiling

Player-required installed/runtime footprint cap:

`2 GB = 2,000,000,000 bytes`

Required runtime downloads count toward the same cap.

Development-only source/repository/CI files do not.

APK byte-size evidence alone does not prove installed-footprint compliance.

## Current work register

Current master issue:

- #20 — first-person foundation, settlement and current-world combat.

Important active tracks:

- #1 — safe prototype decomposition;
- #2 — geometry/collision ownership;
- #9 — player/touch/camera separation;
- #21 — stale documentation/authority cleanup after migration.

## Verification discipline

Keep separate:

DESIGNED  
→ IMPLEMENTED  
→ STATIC_VERIFIED  
→ HEADLESS_VERIFIED  
→ ANDROID_BUILD_VERIFIED  
→ PHONE_RUNTIME_VERIFIED  
→ VISUAL_QUALITY_VERIFIED  
→ PERFORMANCE_VERIFIED.

Do not claim physical-device acceptance from CI alone.

## Continuation

Begin with:

`START_HERE_NEW_CHAT.md`

Then use the repository map/master reference to locate the exact source and tests.

Always fetch live `main` before implementation work and re-check it before writes.
