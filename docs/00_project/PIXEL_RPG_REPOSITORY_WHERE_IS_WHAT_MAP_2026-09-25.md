# Pixel RPG — Repository “Where Is What” Map

Status: CURRENT NAVIGATION MAP / READ-AND-DOCUMENT PASS  
Created: 2026-09-25  
Repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Branch: `main`  
Audited implementation baseline: `7e9f37071a3634dee98db1d1040ecc1c57e13d3a`  
Audited implementation commit: `refactor: centralize first-person camera pose state`

## Purpose

This file answers one question: **where is what in the current Pixel RPG repository?**

It is a navigation and ownership map, not a replacement for source code, tests, current creator instructions, or exact build evidence.

When this map disagrees with live source/tests at a newer commit, the newer source/tests win.

## 1. Current trust order

Use this order when reconstructing the project:

1. current explicit creator instruction;
2. live `jbob-coder/pixel-rpg-goblin-underwater/main`;
3. exact implementation source for the subsystem;
4. exact tests for that source;
5. exact GitHub Actions evidence tied to the same SHA;
6. current GitHub issue register, especially master issue #20;
7. `docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md` for known migration/document conflicts;
8. narrow owner/package documentation that still matches current source;
9. historical handoffs/work registers for provenance only.

Do not use the old repository `jbob-coder/Chatgptjuegolpcal` as current implementation authority. It is migration/provenance history.

## 2. Repository identity and migration

Current active repository:

`jbob-coder/pixel-rpg-goblin-underwater`

Current active branch:

`main`

The old Pixel RPG branch `jbob-coder/Chatgptjuegolpcal@pixel-rpg` was migrated into this repository. The migrated snapshot corresponds to the old source lineage, while current `main` contains post-migration implementation work.

Known migration problem: several copied “active” Markdown files still name the old repository, old branch, old issue numbers, or removed workflow paths. Treat those fields as stale unless corroborated against live `main`.

## 3. Top-level structure

### `.github/workflows/`

Current canonical automation.

Current workflow:

`.github/workflows/pixel-rpg-ci.yml`

It owns current verification + Android APK export.

### `game/`

The **production Godot project**.

This is the main runtime implementation tree.

### `tests/quality/`

Repository-level Python static/preflight validators.

Current major families:

- `tests/quality/hunt01/`
- `tests/quality/pixel_rpg/`

### `probes/android_stage1/`

Historical/isolated Android engine/device probe project.

It is useful evidence and tooling history, but it is **not the current production gameplay project**.

### `ci/stage1/`

Stage-1 Godot test/support scripts.

These files exist, but the current canonical workflow's GDScript discovery loop runs `game/tests/*_test.gd`; do not claim the `ci/stage1/*.gd` files are current canonical CI gates unless a current invocation is proven.

### `docs/`

Package-oriented design, authority, world, gameplay, content, art, technical, quality, and handoff documentation.

### Root Markdown files

High-level game/design/architecture documentation. Several still contain pre-migration fields and must be corroborated before being treated as current implementation authority.

## 4. Current production boot path

Current application configuration:

`game/project.godot`

Main scene:

`game/scenes/app_shell.tscn`

App shell script:

`game/scripts/app_shell.gd`

Current player-facing first slice:

`game/scenes/prototypes/pixel_rpg_prototype_001.tscn`

Main orchestration script:

`game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`

Boot chain:

`project.godot → app_shell.tscn → app_shell.gd → pixel_rpg_prototype_001.tscn`

This is the current first-person Pixel RPG player path.

## 5. First-person player/controller presentation

Primary scene:

`game/scenes/prototypes/pixel_rpg_prototype_001.tscn`

Important live player nodes:

- `Hunter` — `CharacterBody3D`;
- `CameraYaw`;
- `CameraPitch`;
- direct current `Camera3D`;
- legacy `SpringArm3D` retained but not camera-owning;
- first-person ViewModel under the active camera.

Current extracted first-person/controller owners:

- `first_person_camera_math_001.gd` — camera-relative movement/look math;
- `first_person_camera_state_001.gd` — yaw/pitch transient state;
- `player_motion_math_001.gd` — locomotion math;
- `player_motor_001.gd` — CharacterBody3D movement application, move-and-slide, facing, respawn application;
- `touch_input_math_001.gd` — joystick/look math;
- `touch_input_state_001.gd` — joystick/touch/look transient mutable state;
- `hud_layout_001.gd` — safe-area/layout calculations;
- `minimap_math_001.gd` — world-to-minimap mapping.

The host prototype still owns/runs important orchestration such as:

- input event routing;
- interaction context;
- targeting UI/glue;
- settings/watch UI;
- smith interior roof visibility;
- scene/world orchestration;
- combat-domain bootstrap glue.

Current decomposition work is tracked primarily by issues #1 and #9.

## 6. First-person ViewModel and hands

ViewModel scene:

`game/assets/characters/first_person_viewmodel_01.tscn`

Canonical hands source:

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`

Canonical source records:

- `game/assets/characters/first_person/README.md`
- `game/assets/characters/first_person/CANONICAL_HANDS_RUNTIME_RULE.md`
- `game/assets/characters/first_person/CANONICAL_HANDS_SOURCE.sha256`

Current ViewModel structure:

- `CanonicalHandsSprite`;
- `PolebladeShaft`;
- `PolebladeHead`;
- `PolebladeHook`.

Boundary: presentation only. No physics, input, targeting, combat, persistence, or durable-state ownership.

Primary tests:

- `game/tests/pixel_rpg_visual_pack_009_first_person_viewmodel_test.gd`
- `game/tests/pixel_rpg_first_person_realignment_runtime_test.gd`

## 7. Current world composition

World assembly occurs in:

`pixel_rpg_prototype_001.gd::_build_prototype_world()`

Current assembly order:

1. `WorldBase001`;
2. concept-photo overlay;
3. `WorldPaths001`;
4. `WorldSettlementCore001`;
5. `WorldGateProps001`;
6. `WorldTrailEnvironment001`;
7. `WorldActorPresentation001`;
8. separate domain monster collision alias.

### Ground

Owner:

`game/scripts/presentation/pixel_rpg/world_base_001.gd`

Current physical floor:

`Ground` `StaticBody3D`

The ground owns the main floor collision.

### Street and trail

Owner:

`game/scripts/presentation/pixel_rpg/world_paths_001.gd`

Reusable details:

- `street_surface_details_01.tscn`
- `trail_surface_details_01.tscn`

These path surfaces/details are presentation. Ground remains physical floor authority.

### Settlement core

Owner:

`game/scripts/presentation/pixel_rpg/world_settlement_core_001.gd`

Currently creates:

- generic building A;
- market;
- enterable smith;
- generic building B;
- reusable building façade details.

Generic building detail scene:

`game/assets/environment/starting_area/settlement_building_details_01.tscn`

Current generic-building collision is still monolithic box collision even though the visual façade contains doors/windows. This is an active architecture limitation.

### Gate and settlement props

Owner:

`game/scripts/presentation/pixel_rpg/world_gate_props_001.gd`

Reusable visual assets are instantiated through:

`game/scripts/presentation/pixel_rpg/world_pack_001.gd`

Important reusable scenes include:

- `settlement_gate_01.tscn`
- `market_stall_01.tscn`
- `service_clutter_01.tscn`
- `signpost_01.tscn`
- `lantern_post_01.tscn`
- `fence_01.tscn`
- `banner_post_01.tscn`
- `vegetation_cluster_01.tscn`
- `rock_cluster_01.tscn`.

The gate visual scene does not own collision. Current left/right gate collision proxies are owned by `world_gate_props_001.gd`.

### Enterable smith

Owner:

`game/scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd`

This is the strongest current reusable exterior→doorway→interior building example.

It owns:

- segmented building collision;
- real doorway gap;
- `EntranceAnchor`;
- `UseAnchor`;
- split roof pieces;
- interior detection.

Visual detail scenes:

- `smith_forge_detail_01.tscn`
- `smith_anvil_detail_01.tscn`
- `smith_bench_detail_01.tscn`
- `smith_frontage_detail_01.tscn`.

Primary test:

`game/tests/pixel_rpg_world_pack_004_enterable_smith_runtime_test.gd`

Full crafting is not implemented in the current first-person smith interaction.

### Trail environment

Owner:

`game/scripts/presentation/pixel_rpg/world_trail_environment_001.gd`

Uses:

- `trail_pine_01.tscn`;
- `trail_rock_visual_01.tscn`;
- vegetation and rock-cluster scenes from World Pack 001.

Most trail assets are presentation-only.

`TrailRockL` is a notable exception: it is a `StaticBody3D` with separate reusable visual and collision children.

### Actors

Owner:

`game/scripts/presentation/pixel_rpg/world_actor_presentation_001.gd`

Current presentation anchors:

- Gate Warden;
- Mudcrest.

Reusable scenes:

- `game/assets/characters/gate_warden_visual_01.tscn`
- `game/assets/monsters/mudcrest_visual.tscn`

The Mudcrest visual is not the deterministic anatomy authority.

## 8. Current image-derived/runtime art

### Pack 010 material derivation

Manifest:

`game/assets/textures/concept_derived/image_derived_asset_manifest.gd`

Derived textures live under:

`game/assets/textures/concept_derived/`

Used for presentation materials such as wood, stone, dirt, foliage, roof, banner, and metal.

### Pack 011 direct PNG assets

Runtime data:

`game/assets/environment/starting_area/concept_photo_sprite_data_011.gd`

Runtime loader:

`game/scripts/presentation/pixel_rpg/concept_photo_reconstruction_011.gd`

Runtime PNG directory:

`game/assets/environment/starting_area/concept_photo_sprites_011/`

Current direct PNG roles include:

- gate banners;
- smith banner;
- smith forge;
- signpost;
- water trough;
- fence.

These assets are presentation-only.

Primary verification:

- `game/tests/pixel_rpg_visual_pack_010_image_derived_assets_test.gd`
- `game/tests/pixel_rpg_visual_pack_011_concept_photo_sprites_test.gd`

Older asset-pipeline docs saying “NO ENGINE IMPORT” or “APPROVED_RUNTIME_2D = NONE” are stale status statements relative to current Pixel RPG runtime integration.

## 9. Gameplay/domain code

Main deterministic gameplay runtime:

`game/scripts/gameplay/`

### Combat

`game/scripts/gameplay/combat/`

Important owners:

- `hunt01_combat_turn_shell_runtime.gd` — initiative/round/activation/AP/RP/Stamina/scheduler;
- `hunt01_tactical_movement_runtime.gd` — tactical movement;
- `hunt01_reaction_window_runtime.gd` — reaction lifecycle;
- `hunt01_hunter_attack_runtime.gd` — Hunter Measured Cut;
- `hunt01_hunter_defense_consequence_runtime.gd`;
- `hunt01_hunter_health_injury_runtime.gd`;
- `hunt01_status_application_runtime.gd`;
- `hunt01_status_timing_runtime.gd`;
- `hunt01_encounter_outcome_runtime.gd`.

### Mudcrest Monster 01

`game/scripts/gameplay/monsters/monster_01/`

Important owners:

- `hunt01_mudcrest_anatomy_runtime.gd` — per-target anatomy integrity;
- `hunt01_mudcrest_attack_runtime.gd` — current hostile attack driver;
- `hunt01_mudcrest_wound_contact_runtime.gd`.

Current implemented monster attacks include Head Sweep and Tail Sweep. Structural crack/break/sever and broader attack set remain incomplete.

### Tracking

`game/scripts/gameplay/tracking/hunt01_tracking_runtime.gd`

Owns deterministic clue collection/inference.

### Encounter

`game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd`

Bridges completed tracking + physical observation/engagement into the fuller Hunt-01 combat runtime.

## 10. Current first-person combat integration boundary

Current first-person Pixel RPG does **not** expose the full Hunt-01 combat runtime.

Current player-facing flow is:

`Observe/Engage → targeting preview → anatomy target selection → target lock → Combat Bridge 002 bootstrap`

Combat Bridge 002 currently initializes:

- `MudcrestAnatomyRuntime`;
- `CombatTurnShellRuntime`.

It intentionally does not perform attack, damage, AP/Stamina spending, or actor teleport.

Primary tests:

- `game/tests/pixel_rpg_combat_bridge_001_targeting_preview_test.gd`
- `game/tests/pixel_rpg_combat_bridge_002_domain_bootstrap_test.gd`

Do not equate “implemented Hunt-01 domain code exists” with “all combat is player-accessible in the current first-person boot scene.”

## 11. Region 01 / older integrated Hunt-01 path

Scene:

`game/scenes/regions/region_01_hunt01_graybox.tscn`

Presentation/runtime host:

`game/scripts/presentation/exploration/region_01_hunt01_graybox.gd`

This path contains the richer tracking→encounter→combat integration history.

It is still real and tested code, but it is not the current app boot scene.

Runtime content projection:

`game/content/regions/region_01/`

Important rule: `hunt01_graybox_build_manifest.json` is a runtime projection of the owning docs manifest. Do not hand-edit it independently.

Primary integration test:

`game/tests/region01_hunt01_graybox_runtime_test.gd`

## 12. State ownership and persistence

Executable ownership contract:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Focused test:

`game/tests/pixel_rpg_state_ownership_contract_test.gd`

Current owner categories include:

- world runtime;
- deterministic combat domain;
- transient touch/input;
- first-person camera state;
- targeting;
- interaction context;
- orchestration latches;
- presentation/HUD;
- local settings candidate;
- planned durable player/world/inventory/NPC/economy owners.

Important current rules:

- camera/input/targeting are not gameplay-save authority;
- combat/anatomy remain with domain owners;
- HUD/presentation are disposable derived state;
- durable player/world/inventory/NPC/economy namespaces are planned, not broad implemented persistence.

Current technical document:

`docs/50_technical/persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`

Older first-slice save contract:

`docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`

The older save contract is design material, not proof of implemented Pixel RPG save/load.

## 13. Tests and verification

### Godot tests

Directory:

`game/tests/`

At the audited baseline there are 33 discovered `*_test.gd` files.

Current canonical workflow runs all discovered tests in that directory.

### Python preflights

- `tests/quality/hunt01/`
- `tests/quality/pixel_rpg/`
- `probes/android_stage1/tests/`

At the audited baseline the workflow discovers 18 Python preflight files total.

### Important current Pixel RPG gates

Examples:

- first-person realignment;
- ViewModel/canonical hands;
- state ownership;
- Combat Bridge 001;
- Combat Bridge 002;
- world-base decomposition;
- starting-area asset packs;
- enterable smith;
- visual packs 010/011.

### Important Hunt-01 deterministic gates

Examples:

- combat turn shell;
- tactical movement;
- Hunter attack;
- reaction;
- Hunter defense/health/downed;
- Mudcrest anatomy/head/tail/wound;
- status application/timing;
- basic runtime autorun;
- Region 01 integration.

## 14. Canonical CI / Android build

Workflow:

`.github/workflows/pixel-rpg-ci.yml`

Audited baseline workflow run:

`36082533109` — SUCCESS

Audited baseline verification job:

`107907382620` — SUCCESS

Audited baseline Android export job:

`107907562399` — SUCCESS

The workflow performs:

1. Python static preflights;
2. Godot import/parse;
3. AppShell smoke;
4. all discovered `game/tests/*_test.gd`;
5. Android debug export;
6. APK ZIP integrity;
7. APK SHA-256;
8. APK byte-size recording;
9. evidence/artifact upload.

Current artifact retention is seven days.

Current workflow records package size but does not currently enforce the stated 2,000,000,000-byte cap with an explicit failure comparison.

## 15. Android export metadata

Export preset:

`game/export_presets.cfg`

Current package name:

`Pixel RPG`

Current application ID still records:

`org.unnamedhuntrpg.game`

Current version metadata still reflects the older Visual Pack 011 checkpoint.

Do not casually change application ID/signing/version identity; that affects Android update compatibility and needs a deliberate migration/build contract.

Current CI generates a debug keystore when absent. Therefore Android export is verified, but durable production signing/update identity is not yet proven by this workflow.

## 16. Current issue/work register

Current master:

**Issue #20 — Pixel RPG first-person foundation, settlement and current-world combat**

Current high-priority architecture work includes:

- #1 — safe prototype decomposition;
- #2 — geometry/collision ownership;
- #9 — player/touch/camera separation;
- #21 — stale authority/docs migration audit.

Important planned work includes:

- #3 — section definition/instance contract;
- #4 — five-section settlement;
- #5 — conservative section streaming;
- #6 — reusable building blueprint standard;
- #7 — NPC building/anchor/schedule foundation;
- #8 — interaction event boundary;
- #10 — current-world persistence;
- #16 — regression expansion;
- #18 — physical-device/runtime/performance/install evidence;
- #19 — current-world first-person combat positioning graph.

Issue comments are progress evidence, not guaranteed latest-source authority.

## 17. Known stale/currently conflicting documentation

The following files contain useful material but include confirmed stale migration/status fields:

- `START_HERE_NEW_CHAT.md` — old repository/branch and old #28/#29/#30 structure;
- `DOCUMENTATION_INDEX.md` — old branch/workflow/issue references;
- `PROJECT_HANDOFF.md` — old branch and hands-integration-incomplete state;
- `EVOLVE_ALIGNMENT.md` — old branch/issue split and stale hands status;
- `README.md` — old branch header;
- `PIXEL_RPG_VISUAL_DIRECTION.md` — old branch header, though first-person direction remains aligned;
- `docs/00_project/PIXEL_RPG_MASTER_WORK_REGISTER_2026-09-21.md` — pre-migration issue map and older state;
- parts of `docs/40_art/asset_pipeline/` — old “no engine import” status;
- older handoffs under `docs/70_handoff/` — historical evidence only unless source/tests still match.

Known migration audit:

`docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md`

Do not mass-rewrite these files without item-by-item corroboration.

## 18. Historical/provenance material

`docs/70_handoff/`

contains many bounded-pass records. Use for:

- exact old source/build evidence;
- reasoning about why a subsystem exists;
- provenance;
- regression history.

Do not treat a handoff as current authority simply because it is present.

The old repository `Chatgptjuegolpcal` is likewise provenance, not active implementation authority.

## 19. Current architectural risks

Evidence-backed risks at the audited baseline:

1. generic building visual doors do not match monolithic collision;
2. collision ownership varies between asset families;
3. the main prototype still owns significant orchestration;
4. older procedural helper code remains beside newer reusable implementations;
5. current first-person combat bridge exposes only part of the richer Hunt-01 domain;
6. broad save/load is not implemented;
7. several active-looking docs contain stale migration fields;
8. `main` is currently unprotected;
9. CI evidence artifacts expire after seven days;
10. current CI debug signing does not prove durable update signing identity;
11. physical-device visual/touch/performance acceptance remains separate from CI/build success.

## 20. Physical-device evidence boundary

Do not convert a green CI/APK export into claims about:

- install/update success on target device;
- no black screen;
- first-person hands clipping/obstruction;
- touch ergonomics;
- Android safe areas;
- sustained FPS;
- heat;
- lifecycle behavior;
- installed footprint.

Those require current physical-device evidence.

## 21. Safe continuation protocol

Before modifying the project:

1. fetch live `main`;
2. record exact HEAD;
3. read this map for location only;
4. read the exact owning source;
5. read the exact owning tests;
6. inspect the current issue for that subsystem;
7. make one bounded change;
8. run the smallest exact gate plus required broad regressions;
9. use canonical CI for source/build claims;
10. keep build/headless/device claims separate;
11. update this map only if ownership/location materially changes.

## 22. Quick lookup

| Need | Go here |
|---|---|
| Production Godot project | `game/` |
| App boot | `game/project.godot`, `game/scenes/app_shell.tscn`, `game/scripts/app_shell.gd` |
| Current first-person prototype | `game/scenes/prototypes/pixel_rpg_prototype_001.tscn` |
| Main prototype orchestrator | `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd` |
| Camera state/math | `game/scripts/presentation/pixel_rpg/first_person_camera_*_001.gd` |
| Player motor | `game/scripts/presentation/pixel_rpg/player_motor_001.gd` |
| Touch state/math | `game/scripts/presentation/pixel_rpg/touch_input_*_001.gd` |
| HUD layout/minimap math | `hud_layout_001.gd`, `minimap_math_001.gd` |
| World base | `world_base_001.gd` |
| Paths | `world_paths_001.gd` |
| Settlement | `world_settlement_core_001.gd` |
| Gate/props | `world_gate_props_001.gd` |
| Trail environment | `world_trail_environment_001.gd` |
| Actor presentation | `world_actor_presentation_001.gd` |
| Enterable smith | `world_pack_004_enterable_smith.gd` |
| First-person hands/ViewModel | `game/assets/characters/first_person/`, `first_person_viewmodel_01.tscn` |
| Mudcrest visual | `game/assets/monsters/mudcrest_visual.tscn` |
| Combat domain | `game/scripts/gameplay/combat/` |
| Mudcrest domain | `game/scripts/gameplay/monsters/monster_01/` |
| Tracking | `game/scripts/gameplay/tracking/` |
| Encounter trigger | `game/scripts/gameplay/encounter/` |
| Region 01 runtime data | `game/content/regions/region_01/` |
| State ownership | `game/scripts/state/pixel_rpg_state_ownership_contract.gd` |
| Godot regression tests | `game/tests/` |
| Static preflights | `tests/quality/` |
| Canonical CI/APK | `.github/workflows/pixel-rpg-ci.yml` |
| Android export preset | `game/export_presets.cfg` |
| Current master issue | GitHub issue #20 |
| Migration/stale-doc audit | `docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md` |
| Historical handoffs | `docs/70_handoff/` |

## 23. Verification note for this documentation pass

This map was produced by reading live repository source, tests, workflow, issue state, migration audit, and relevant package documentation across a bounded five-round familiarization pass.

No gameplay/runtime implementation was modified by that reading pass.

The audited implementation baseline `7e9f37071a3634dee98db1d1040ecc1c57e13d3a` had canonical workflow run `36082533109` complete successfully before this documentation-only map was added.

Because this map is a documentation-only change under `docs/`, do not infer a new runtime/build verification state from the documentation commit itself.
