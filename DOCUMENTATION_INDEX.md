# Pixel RPG — Documentation Index

Status: ACTIVE GLOBAL MAP / FIRST-PERSON / MIGRATION-RECONCILED ON DOCUMENTATION BRANCH  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation cleanup branch: `documentation`

## Start here

For a new session or contributor:

1. fetch live production `main` and record exact HEAD;
2. read `START_HERE_NEW_CHAT.md`;
3. read `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`;
4. read `docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`;
5. use `docs/00_project/ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md` before relying on older root design documents;
6. use `docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md` before relying on handoff history;
7. use `docs/00_project/PACKAGE_AUTHORITY_MATRIX_2026-09-25.md` when ownership crosses documentation/runtime packages;
8. read the exact owning source and tests for the bounded task;
9. inspect the current GitHub issue for that subsystem;
10. use `docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md` when an older document conflicts with current source.

Do not use `jbob-coder/Chatgptjuegolpcal@pixel-rpg` as current implementation authority. It is migration/provenance history.

## Authority order

current explicit creator instruction  
→ live production `main` source  
→ exact implementation owner  
→ exact tests  
→ exact same-SHA CI/build evidence  
→ current GitHub issue register  
→ migration/stale-document audit  
→ narrow documentation that still matches source  
→ historical handoffs/provenance.

A document marked ACTIVE may still contain stale migration fields. Current source/tests/evidence win.

## Current production boot

`game/project.godot`
→ `game/scenes/app_shell.tscn`
→ `game/scripts/app_shell.gd`
→ `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`.

Main host:

`game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`

The richer Region-01 Hunt-01 graybox remains real/tested code but is not the current application boot scene.

## Current presentation authority

Primary player-facing direction remains first-person:

- direct eye-height `Camera3D`;
- camera-relative movement;
- independent right-side look;
- Android landscape-first controls;
- pixel-styled real 3D;
- compact connected physical spaces;
- same-world monster encounter/combat direction;
- readable HUD and contextual actions;
- approved image-derived presentation with gameplay/collision authority kept separate.

Primary visual document:

`PIXEL_RPG_VISUAL_DIRECTION.md`


## Current first-person technical owners

Source package:

`game/scripts/presentation/pixel_rpg/`

Important current owners include:

- `first_person_camera_math_001.gd`;
- `first_person_camera_state_001.gd`;
- `player_motion_math_001.gd`;
- `player_motor_001.gd`;
- `touch_input_math_001.gd`;
- `touch_input_state_001.gd`;
- `hud_layout_001.gd`;
- `minimap_math_001.gd`.

The prototype still owns orchestration/event-routing responsibilities that are being decomposed safely.

## Canonical first-person hands

Canonical source:

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`

Live ViewModel:

`game/assets/characters/first_person_viewmodel_01.tscn`

Current source already references the canonical PNG directly. Older documents claiming this integration is still pending are stale.

Owning verification includes:

- `game/tests/pixel_rpg_visual_pack_009_first_person_viewmodel_test.gd`;
- `game/tests/pixel_rpg_first_person_realignment_runtime_test.gd`.

ViewModel remains presentation-only.

## World and building owners

Current compact-world presentation owners:

- world base: `world_base_001.gd`;
- paths: `world_paths_001.gd`;
- settlement core: `world_settlement_core_001.gd`;
- gate/props: `world_gate_props_001.gd`;
- trail environment: `world_trail_environment_001.gd`;
- actor presentation: `world_actor_presentation_001.gd`;
- reusable starting-area visual factory: `world_pack_001.gd`;
- enterable smith: `world_pack_004_enterable_smith.gd`.

The enterable smith is the best current building blueprint. Generic settlement buildings still use monolithic collision and are not equivalent to the smith's real doorway/interior pattern.

## Runtime art / asset lineage

Current direct/runtime image-derived assets include:

- Pack 010 material derivation under `game/assets/textures/concept_derived/`;
- Pack 011 direct PNG assets under `game/assets/environment/starting_area/concept_photo_sprites_011/`.

Important runtime manifests/loaders:

- `game/assets/textures/concept_derived/image_derived_asset_manifest.gd`;
- `game/assets/environment/starting_area/concept_photo_sprite_data_011.gd`;
- `game/scripts/presentation/pixel_rpg/concept_photo_reconstruction_011.gd`.

Older asset-pipeline files saying “NO ENGINE IMPORT” or “APPROVED_RUNTIME_2D = NONE” are historical status statements and must not override current runtime source/tests.

## Gameplay/domain owners

Generic combat:

`game/scripts/gameplay/combat/`

Mudcrest species runtime:

`game/scripts/gameplay/monsters/monster_01/`

Tracking:

`game/scripts/gameplay/tracking/`

Encounter:

`game/scripts/gameplay/encounter/`

The deterministic Hunt-01 domain is richer than what the current first-person boot scene exposes.

## Current-world combat boundary

Current first-person player flow:

Observe/Engage  
→ targeting preview  
→ anatomy target selection/lock  
→ Combat Bridge 002  
→ initialize Mudcrest anatomy + combat turn shell  
→ no attack yet.

Owning tests:

- `game/tests/pixel_rpg_combat_bridge_001_targeting_preview_test.gd`;
- `game/tests/pixel_rpg_combat_bridge_002_domain_bootstrap_test.gd`.

Do not claim the full Hunt-01 attack/reaction/tactical loop is already exposed by the current first-person boot scene.

## State ownership and persistence

Current executable ownership authority:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Focused test:

`game/tests/pixel_rpg_state_ownership_contract_test.gd`

Current technical document:

`docs/50_technical/persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`

Broad save/load is not implemented.

Older design contract:

`docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`

is design/provenance material, not proof of current save/load implementation.

## Tests

Godot runtime/regression tests:

`game/tests/`

Python static/preflight tests:

- `tests/quality/hunt01/`;
- `tests/quality/pixel_rpg/`;
- `probes/android_stage1/tests/`.

The current canonical GDScript discovery loop runs `game/tests/*_test.gd`.

Do not automatically classify `ci/stage1/*.gd` as current canonical CI gates without a current invocation.

## Canonical CI / Android build

Current workflow:

`.github/workflows/pixel-rpg-ci.yml`

Audited runtime baseline:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical run:

`36082533109` — SUCCESS

Verification job:

`107907382620` — SUCCESS

Android export job:

`107907562399` — SUCCESS

Current workflow runs static preflights, Godot import/parse, AppShell smoke, discovered Godot tests, Android debug export, APK integrity, SHA-256, size recording, and artifact upload.

CI/build evidence applies to the exact SHA it tested.

## Current GitHub work register

Master:

- #20 — Pixel RPG first-person foundation, settlement and current-world combat.

Current important tracks:

- #1 — safe prototype decomposition;
- #2 — geometry/collision ownership;
- #9 — player/touch/first-person camera separation;
- #21 — stale authority/document reconciliation after repository migration.

Important planned work also includes sections/streaming, reusable buildings, NPC foundations, persistence, regression expansion, physical-device/performance evidence, and current-world combat positioning.

## Package authority map

Cross-package ownership/navigation:

`docs/00_project/PACKAGE_AUTHORITY_MATRIX_2026-09-25.md`

Use it to distinguish:

- documentation intent from runtime implementation;
- current technical packages from historical snapshots;
- Region-01 legacy spatial authority from current compact-world authority;
- current runtime-art records from historical asset-pipeline status;
- static/headless/build evidence from device evidence.

`docs/README.md` is the current documentation-folder front door.

## Handoff policy

`docs/70_handoff/` is evidence/history, not automatic current authority.

Classification index:

`docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md`

Use a handoff only when:

1. it concerns the exact current subsystem;
2. current source/tests still match it;
3. no newer source/authority supersedes it.

## Root design-document policy

Older root documents are classified in:

`docs/00_project/ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md`

Use current authority/navigation files directly. Use older Unnamed Hunt, Stage-1, aerial, third-person, Shooter-RPG, model, mechanics, and pre-engine documents only according to their classification and any supersession banner. Preserve reusable architecture/design laws without promoting stale implementation status or camera assumptions.

## Verification language

Keep separate:

- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

A successful CI build does not prove physical-device quality.

## Current unresolved physical evidence

Unless a fresh device record proves otherwise:

- physical Android install/launch;
- no-black-screen acceptance;
- first-person hands composition/clipping;
- touch ergonomics;
- safe-area behavior;
- sustained FPS/heat;
- lifecycle behavior;
- installed footprint;
- durable APK update/signing continuity

remain separate/unverified.

## Documentation branch policy

`documentation` is a documentation-only reconciliation branch.

Do not place gameplay/runtime implementation changes on it.

Documentation-only commits do not create a new runtime/build verification state.

When this branch is eventually reviewed/merged, merge only corroborated documentation changes.
