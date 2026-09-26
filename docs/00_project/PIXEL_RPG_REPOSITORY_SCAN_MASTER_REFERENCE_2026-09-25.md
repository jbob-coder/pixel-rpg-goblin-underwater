# Pixel RPG — Repository Scan Master Reference

Status: CURRENT DOCUMENTATION-BRANCH MASTER REFERENCE  
Created: 2026-09-25  
Documentation branch: `documentation`  
Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Audited runtime implementation baseline: `7e9f37071a3634dee98db1d1040ecc1c57e13d3a`  
Audited runtime CI: `36082533109` — SUCCESS

Companion location map:

`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

This document records what was learned during the five-round repository scan, how the major pieces relate to each other, and the operating model the project should follow. It does not replace live source/tests. When newer source disagrees with this document, newer verified source wins.

## 1. Executive summary

Pixel RPG is an Android-first, first-person, pixel-styled real-3D monster-hunting RPG built in Godot 4.7.2.

The active repository is:

`jbob-coder/pixel-rpg-goblin-underwater`

The production branch is:

`main`

The old `jbob-coder/Chatgptjuegolpcal@pixel-rpg` repository/branch is migration and provenance history only.

The project already contains substantial working foundations:

- real first-person boot path;
- mobile movement/look foundation;
- first-person hands/ViewModel;
- reusable compact-world presentation assets;
- an enterable smith with real doorway/interior collision;
- deterministic Hunt-01 combat/anatomy/status systems;
- tracking and encounter runtime;
- explicit state-ownership contracts;
- broad regression tests;
- canonical CI;
- Android APK export.

The current player-facing first-person world does not yet expose the full richer Hunt-01 combat system. It currently exposes targeting plus Combat Bridge 002, which initializes combat/anatomy domain state without performing attacks or teleporting actors.

The main architectural task is therefore not “invent combat from scratch.” It is to connect the current first-person world to the already-proven domain systems through explicit current-world adapters while preserving ownership and deterministic behavior.

## 2. Authority and evidence model

Use this trust order:

1. current explicit creator instruction;
2. live production `main`;
3. exact source owner;
4. exact tests for that owner;
5. exact same-SHA build evidence;
6. current GitHub issue register;
7. migration/stale-document audit;
8. narrow documentation that still matches source;
9. historical handoffs for provenance only.

Evidence states must remain distinct:

- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

A green CI run does not prove phone ergonomics, sustained performance, heat, installed footprint, or visual acceptance.

## 3. Production runtime flow

Current boot:

`game/project.godot`
→ `game/scenes/app_shell.tscn`
→ `game/scripts/app_shell.gd`
→ `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`
→ `pixel_rpg_prototype_001.gd`.

The current app does not boot into the older Region-01 graybox scene.

The current prototype creates the world in this order:

1. world base/ground;
2. direct concept-photo presentation overlay;
3. street/trail surfaces;
4. settlement core;
5. gate and settlement props;
6. trail environment;
7. Gate Warden and Mudcrest presentation anchors;
8. separate Mudcrest domain/collision alias.

The prototype remains an orchestrator with some responsibilities still concentrated inside it. Ongoing decomposition work should move one responsibility at a time, keep wrapper/API compatibility where useful, and preserve regression tests.

## 4. First-person architecture

The first-person layer is split into explicit owners.

### Camera

The live camera is a direct `Camera3D` under yaw/pitch pivots.

Current extracted responsibilities include:

- camera movement/look math;
- camera yaw/pitch transient state;
- player locomotion math;
- player motor execution;
- touch input math;
- touch mutable state;
- HUD layout math;
- minimap mapping.

The third-person Hunter presentation body stays hidden during normal first-person play.

### Input

Input should be captured/routed once.

Touch ownership must not be duplicated in mirror fields. Joystick vector, touch IDs, and look-last-position belong to the explicit exploration-input state owner.

### Player motor

`player_motor_001.gd` owns actual CharacterBody3D velocity application and `move_and_slide()`.

Input collection and camera-relative movement intent should remain separate from motor execution.

### HUD

HUD is presentation, not durable truth.

HUD may render health/status/objectives/context/targeting/minimap, but authoritative gameplay values belong to their domain/world owners.

### First-person ViewModel

Scene:

`game/assets/characters/first_person_viewmodel_01.tscn`

Canonical hands:

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`

The ViewModel is camera-local presentation only. It must never own:

- collision;
- input;
- targeting truth;
- combat resolution;
- persistence;
- durable player state.

## 5. World and collision model

The world currently uses several ownership patterns.

### Ground

`world_base_001.gd` creates the main Ground `StaticBody3D`.

Ground is physical floor authority.

### Street and trail

`world_paths_001.gd` owns visible Street/Trail surfaces and presentation detail layers.

Those surfaces do not own floor physics. Ground remains the floor collision owner.

### Generic settlement buildings

`world_settlement_core_001.gd` currently creates two generic buildings as solid box `StaticBody3D` collision bodies with separate presentation-only façade detail.

This is provisional. A visual door on a solid collision box must not be treated as a functional doorway.

### Enterable smith

`world_pack_004_enterable_smith.gd` is the strongest existing building blueprint.

It demonstrates the desired pattern:

- segmented collision around a real doorway;
- EntranceAnchor;
- UseAnchor;
- interior space;
- split roof visibility;
- interior props;
- first-person inside/outside handling.

Future enterable buildings should follow this architecture rather than the generic solid-box pattern.

### Gate

Gate visual and gate collision are separate.

The reusable gate asset is presentation-only. Left/right collision proxies are owned separately by `world_gate_props_001.gd`.

### Trail objects

Most trees/vegetation/rock-cluster scenes are presentation-only.

`TrailRockL` is a useful mixed example: gameplay/static collision root with a reusable visual child and explicit collision child.

### Rule going forward

Visible art and gameplay collision are separate concerns.

Replacing visible art must not silently change physics.

When a presentation asset replaces an older visible placeholder:

1. preserve collision/gameplay authority;
2. prove visual parity/integration;
3. remove duplicated visible placeholder art only after verification.

## 6. Actor and monster presentation

Actor presentation owner:

`world_actor_presentation_001.gd`

Current actor anchors:

- Gate Warden;
- Mudcrest.

The Mudcrest visual scene exposes readable visual regions such as torso, head, horn crest, dorsal plates, limbs, and tail.

Those visual nodes are not authoritative anatomy state.

Authoritative anatomy lives in:

`hunt01_mudcrest_anatomy_runtime.gd`

The current compact-world prototype also creates a separate stable physical/domain body alias for Mudcrest. This avoids making the visible monster scene the only gameplay/collision truth.

## 7. Asset/runtime-art model

Two current image-derived paths are implemented.

### Visual Pack 010

Concept-derived material mosaics under:

`game/assets/textures/concept_derived/`

These provide pixel-consistent wood/stone/dirt/foliage/roof/banner/metal presentation.

### Visual Pack 011

Direct runtime PNGs under:

`game/assets/environment/starting_area/concept_photo_sprites_011/`

Their source crop, path, dimensions, and SHA-256 identity are recorded in:

`concept_photo_sprite_data_011.gd`

Runtime loader:

`concept_photo_reconstruction_011.gd`

These are actual runtime presentation assets and are test-verified.

### Asset law

Preferred chain:

SOURCE
→ selected/clean master
→ task-specific derivative
→ runtime import
→ automated validation
→ device visual/performance validation
→ approved ship asset.

Never infer technical truth from generated imagery.

Generated visual text, apparent collision boundaries, UV-looking diagrams, normal-map-looking images, or scale labels do not become authority automatically.

Upscaling may improve reference readability but does not create reliable missing geometry or technical detail.

## 8. Gameplay/domain architecture

The proven deterministic gameplay stack lives mainly under:

`game/scripts/gameplay/`

### Generic combat owners

`game/scripts/gameplay/combat/`

Important responsibilities include:

- turn/round/activation scheduler;
- AP/RP/Stamina;
- tactical movement;
- reaction windows;
- Hunter attack;
- defense consequences;
- Hunter health/injury;
- status application;
- status timing;
- terminal encounter outcome.

### Monster-specific owners

`game/scripts/gameplay/monsters/monster_01/`

Mudcrest-specific owners include:

- anatomy integrity;
- hostile attack driver;
- wound/contact consequences.

Current implemented attacks include Head Sweep and Tail Sweep.

Current incomplete areas include structural crack/break/sever thresholds, actual detachment, broader attacks, Monster defeat/escape/reacquisition, and final balance.

### Tracking

`hunt01_tracking_runtime.gd`

Owns clue collection/history and route inference.

### Encounter

`hunt01_encounter_trigger_runtime.gd`

Owns observation/engagement transition and starts the fuller Hunt-01 combat stack after explicit engagement.

## 9. Current-world combat relationship

The current first-person compact world and the richer Hunt-01 domain are related but not identical runtime paths.

Current first-person flow:

Observe/Engage Mudcrest
→ targeting preview
→ choose anatomy target group
→ lock target
→ start Combat Bridge 002
→ initialize Mudcrest anatomy
→ initialize combat turn shell
→ stop before attacks.

Current Bridge 002 intentionally does not:

- attack;
- deal damage;
- spend combat resources for an attack;
- teleport the Hunter;
- blindly reuse the old Region-01 tactical-node geometry.

### How combat should progress

Do not duplicate deterministic combat rules inside presentation.

Instead:

current-world physical state
→ current-world spatial adapter
→ proven combat-domain intent/resolution
→ authoritative anatomy/status/resource update
→ presentation reads and displays result.

A future current-world positioning graph must be designed for the compact first-person world. Do not offset or teleport the old Region-01 graph into the new world without an explicit adapter.

## 10. Region 01 relationship

Region 01 remains a real, tested integrated runtime path:

`game/scenes/regions/region_01_hunt01_graybox.tscn`

It demonstrates:

tracking
→ observation
→ explicit engage
→ tactical/combat runtime.

It is not the current boot scene.

Use it as:

- proven domain/integration evidence;
- regression coverage;
- source of bounded reusable contracts.

Do not automatically reuse its camera architecture, coordinates, or spatial assumptions in the current compact first-person world.

## 11. State ownership

Executable contract:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Primary law:

**one authoritative owner per mutable datum.**

Current examples:

- Hunter transform/physics → world Hunter body;
- Mudcrest compact-world transform → world Mudcrest owner;
- combat resources/scheduler → combat turn shell;
- Mudcrest anatomy → anatomy owner;
- touch/joystick state → exploration-input owner;
- yaw/pitch → first-person camera-state owner;
- target selection/lock → targeting control owner;
- current interaction context → interaction owner;
- HUD/highlight/minimap → presentation only.

Do not reintroduce duplicated mirror fields merely to satisfy an old test. Update tests to inspect the declared owner.

## 12. Persistence

Broad current-world save/load is not implemented.

Planned durable namespaces include:

- player state;
- world state;
- inventory/equipment;
- NPC relationships;
- economy.

Transient control state must never enter gameplay saves.

Camera sensitivity is a local-preference candidate, not gameplay state.

Future persistence should:

1. serialize authoritative domain/world snapshots;
2. use versioned schemas;
3. save at stable transaction boundaries;
4. avoid persisting HUD widgets/callbacks;
5. preserve stable IDs and transaction/sequence continuity;
6. validate/migrate/correct corrupt or old data explicitly.

The older first-slice persistence contract is design material, not proof of current implementation.

## 13. Tests and CI

Canonical workflow:

`.github/workflows/pixel-rpg-ci.yml`

At the audited baseline it runs:

- Python static preflights;
- Godot import/parse;
- AppShell smoke;
- all discovered `game/tests/*_test.gd`;
- Android debug export;
- APK integrity;
- SHA-256;
- byte-size recording;
- artifact upload.

Audited runtime SHA:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Workflow:

`36082533109` — SUCCESS

Verification job:

`107907382620` — SUCCESS

Android export job:

`107907562399` — SUCCESS

The CI path is evidence for that exact SHA only.

## 14. Android build model

Current build is a debug APK export.

Important unresolved build-control topics:

- stable signing/update identity is not yet proven;
- application ID still contains older Unnamed Hunt lineage;
- version metadata still reflects an older visual-pack checkpoint;
- current workflow records APK size but does not enforce the 2,000,000,000-byte cap with an explicit comparison;
- CI artifacts expire after seven days;
- `main` currently lacks enforced branch protection/required checks.

Do not casually change package ID or signing identity. Android update compatibility depends on them.

## 15. Documentation status

Several files still look active but contain stale migration fields.

Confirmed examples include:

- `START_HERE_NEW_CHAT.md` — being reconciled on `documentation`;
- `DOCUMENTATION_INDEX.md`;
- `PROJECT_HANDOFF.md`;
- `EVOLVE_ALIGNMENT.md`;
- root `README.md`;
- `PIXEL_RPG_VISUAL_DIRECTION.md` branch header;
- old master work register;
- old asset-pipeline status banners;
- many handoffs under `docs/70_handoff/`.

The correct strategy is not mass deletion.

Use item-by-item corroboration:

current source/tests
→ confirm which statement is still true
→ update current navigation/status fields
→ retain historical evidence when useful
→ clearly label provenance versus current authority.

## 16. Current issue relationships

Current master issue:

#20 — first-person foundation, settlement, and current-world combat.

Important current tracks:

- #1 prototype decomposition;
- #2 geometry/collision ownership;
- #9 input/player/camera controller separation;
- #21 documentation/authority migration cleanup.

Planned related work includes section definitions, settlement restructuring, streaming, reusable building standards, NPC foundations, persistence, regression expansion, device/performance validation, and current-world combat positioning.

## 17. How the project should work

### Presentation

Presentation reads state and sends player intent.

It must not become authoritative gameplay truth.

### Input

Input is captured once and written to the declared transient-control owner.

### Player movement

Input intent
→ camera-relative movement math
→ player motor
→ CharacterBody3D physics.

### Interaction

World proximity/context
→ interaction intent
→ owning gameplay/service system
→ result
→ HUD feedback.

Do not let UI button labels become interaction truth.

### Combat

Physical first-person world intent
→ explicit spatial adapter
→ deterministic combat-domain resolution
→ anatomy/status/resource owners
→ presentation feedback.

### Buildings

Building definition
→ reusable visual scene
→ explicit collision contract
→ interaction anchors
→ interior/roof rules
→ tests.

Avoid fake doors on solid collision for buildings intended to be enterable.

### Assets

Source identity
→ lineage record
→ derived asset
→ runtime import
→ tests
→ phone visual/performance acceptance.

### Persistence

Authoritative owner snapshots only.

Never persist presentation/control noise as gameplay state.

### Testing

Each change should have:

smallest relevant focused test
+ required regression stack
+ exact CI/build evidence when build-affecting
+ device test only when physical behavior is being claimed.

## 18. Known risks

Current evidence-backed risks:

1. generic buildings still mismatch visual doors and solid collision;
2. collision ownership is not yet uniform across asset families;
3. prototype orchestrator still carries significant glue/responsibility;
4. legacy procedural helpers coexist with newer reusable assets;
5. first-person combat integration is intentionally incomplete;
6. broad persistence is not implemented;
7. stale documentation can redirect work to old repository/issue state;
8. branch protection is not enforcing green CI on `main`;
9. CI artifacts are temporary;
10. debug signing does not prove durable production update identity;
11. physical device acceptance is still separate from automation.

## 19. Priority order

Recommended architecture order based on current dependencies:

NOW
1. finish documentation authority reconciliation on `documentation`;
2. continue safe prototype/controller decomposition;
3. formalize geometry/collision ownership;
4. keep current first-person regressions green.

NEXT
1. reusable building blueprint contract;
2. current settlement section definition;
3. conservative streaming ownership;
4. NPC/building anchors and interaction boundary;
5. current-world persistence foundation.

THEN
1. explicit current-world combat-position adapter;
2. integrate proven combat attack/reaction layers;
3. crafting/inventory service integration;
4. structural Monster break/sever;
5. expanded world content.

ALWAYS
- preserve stable IDs;
- preserve original IP;
- keep tools/costs within creator constraints;
- distinguish source/build/device evidence;
- avoid giant rewrites when a bounded extraction works.

## 20. Safe continuation procedure

Before implementation:

1. fetch current production `main`;
2. record exact HEAD;
3. identify exact subsystem owner;
4. read its source and tests;
5. read the current issue;
6. classify the intended change;
7. make one bounded reversible change;
8. run focused verification;
9. run required regressions;
10. use canonical CI when build/runtime claims require it;
11. record exact evidence;
12. read back resulting source;
13. update documentation only with facts now proven.

For documentation-only reconciliation, work on `documentation` and do not claim a new runtime-verified state from docs commits.

## 21. Quick relationship map

`Prototype scene`
→ owns current player-facing orchestration.

`Camera/touch/motor components`
→ own transient control/math/execution slices.

`World owners`
→ build current compact settlement/trail/actors.

`Presentation assets`
→ render world identity but normally do not own gameplay collision.

`State ownership contract`
→ defines who is authoritative for mutable data.

`Combat/anatomy domain`
→ owns deterministic combat truth.

`Combat Bridge`
→ adapts current-world targeting/bootstrap into domain state.

`Region 01`
→ older/richer integrated runtime and regression source, not current boot.

`game/tests`
→ runtime regression authority.

`tests/quality`
→ static/preflight authority.

`pixel-rpg-ci.yml`
→ canonical source/build verification path.

`documentation`
→ current documentation-reconciliation staging branch only.

## 22. Completion note

This master reference was created from a five-round scan of live repository structure, source, tests, issues, CI/build evidence, asset lineage, state ownership, migration history, and package documentation.

The audited runtime baseline was not modified by the scan.

For exact file-by-file lookup, use:

`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`.
