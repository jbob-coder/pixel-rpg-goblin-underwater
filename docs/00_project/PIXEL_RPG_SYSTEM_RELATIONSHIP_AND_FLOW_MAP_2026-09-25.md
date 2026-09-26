# Pixel RPG — Current System Relationship and Operating Flow Map

Status: CURRENT DOCUMENTATION / RUNTIME-RELATIONSHIP NAVIGATION  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

Audited runtime baseline:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical audited workflow:

`36082533109` — SUCCESS

## Purpose

This document answers:

- what is related to what;
- which layer owns what;
- how data and player intent should flow;
- where adapters are required;
- which layers may read versus mutate state;
- which historical systems remain reusable;
- how future work should extend the current architecture without creating duplicate truth.

This is a relationship map, not executable authority. Current source/tests at newer production commits win.

---

# 1. Core operating model

The intended runtime relationship is:

`PLAYER INPUT`
→ transient control owner
→ movement/look/interaction intent
→ world/gameplay owner
→ authoritative state mutation
→ presentation reads result
→ HUD/visual/audio feedback.

Presentation must not skip the gameplay owner and invent durable truth.

A second major path is:

`CURRENT-WORLD TARGETING / PHYSICAL CONTEXT`
→ explicit adapter
→ deterministic combat/anatomy domain
→ authoritative domain result
→ current-world/presentation feedback.

This is the key architectural bridge for future combat work.

---

# 2. Current application boot relationship

`game/project.godot`
→ loads `game/scenes/app_shell.tscn`
→ controlled by `game/scripts/app_shell.gd`
→ loads/hosts `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`
→ controlled by `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`.

Meaning:

- AppShell is startup/container logic;
- Prototype 001 is the current player-facing first-person slice;
- Region 01 is not the current boot scene;
- Region 01 remains domain/integration provenance and regression coverage.

---

# 3. Input → camera → movement relationship

## Touch input

Input events enter through the current prototype host.

Mutable touch state is delegated to:

`touch_input_state_001.gd`

Math/interpretation helpers live in:

`touch_input_math_001.gd`

Current responsibilities include:

- joystick vector;
- joystick touch capture;
- look touch capture;
- last look position.

These are transient control facts.

They must not be persisted as gameplay state.

## Camera

Camera-relative math:

`first_person_camera_math_001.gd`

Mutable yaw/pitch owner:

`first_person_camera_state_001.gd`

Scene nodes:

`Hunter/CameraYaw/CameraPitch/Camera3D`

Relationship:

touch/look delta
→ camera-state owner updates yaw/pitch
→ camera pivot nodes reflect that state
→ movement math reads camera orientation
→ gameplay/player motor receives desired movement.

Camera orientation is control/presentation state.

It must not become:

- combat truth;
- world quest truth;
- persistence truth;
- targeting truth.

## Player motion

Motion intent/math:

`player_motion_math_001.gd`

Physical movement executor:

`player_motor_001.gd`

Relationship:

input vector
+ camera basis
→ desired movement vector
→ player motor
→ `CharacterBody3D.velocity`
→ `move_and_slide()`
→ authoritative live Hunter transform.

The Hunter `CharacterBody3D` is the live world-transform/physics authority.

Do not store a second authoritative player position in HUD, camera, documentation, or interaction code.

---

# 4. World composition relationship

Prototype world construction currently calls bounded world owners.

`WorldBase001`
→ creates physical ground.

`ConceptPhotoReconstruction011`
→ adds presentation-only direct-photo sprites.

`WorldPaths001`
→ creates Street/Trail visual surfaces and reusable detail layers.

`WorldSettlementCore001`
→ creates generic buildings, market, and enterable smith.

`WorldGateProps001`
→ creates gate presentation + separately owned gate collision proxies + props.

`WorldTrailEnvironment001`
→ creates trees, vegetation, rocks, and TrailRockL.

`WorldActorPresentation001`
→ creates Gate Warden and Mudcrest presentation anchors.

Prototype host then adds the stable Mudcrest domain/collision alias.

This means world construction is modular, but not every module owns collision in the same way.

---

# 5. Collision relationship

## Ground

`world_base_001.gd`
→ `Ground StaticBody3D`
→ main floor collision.

Street/Trail presentation does not replace ground collision.

## Generic buildings

`world_settlement_core_001.gd`

Current pattern:

solid `StaticBody3D` box
+ separate façade presentation.

Therefore a visible door on a generic building is not automatically traversable.

## Enterable smith

`world_pack_004_enterable_smith.gd`

Current stronger pattern:

building root
→ segmented wall collision
→ real doorway gap
→ EntranceAnchor
→ UseAnchor
→ interior
→ split roof visibility.

This is the current best building-pattern reference.

## Gate

`settlement_gate_01.tscn`
→ visual only.

`world_gate_props_001.gd`
→ owns left/right physical gate proxies.

## TrailRockL

Current mixed pattern:

`StaticBody3D`
→ reusable visual child
→ explicit collision child.

## Rule

Visual replacement must not silently modify gameplay collision.

Preferred future relationship:

`BUILDING/PROP DEFINITION`
→ visible asset
→ explicit collision contract
→ interaction anchors
→ tests.

---

# 6. Interaction relationship

Current interaction context is transient control state.

Relationship:

player position/orientation
+ nearby interactable anchors
+ current context rules
→ current interaction candidate
→ contextual action UI
→ player action intent
→ owning service/gameplay handler.

HUD/action-button text is not interaction truth.

The interaction owner decides what is currently actionable.

Examples:

Gate Warden:
world actor anchor
→ nearby/context detection
→ NPC interaction intent
→ presentation response.

Smith:
UseAnchor
→ nearby/context detection
→ smith action
→ current limited smith inspection/service behavior.

Full crafting does not yet exist merely because the smith is enterable.

---

# 7. Targeting relationship

Current first-person Mudcrest targeting is a control/presentation bridge.

Relationship:

Mudcrest visual/world presence
→ Observe/Engage context
→ targeting preview opens
→ anatomy group selection
→ target lock
→ Combat Bridge 002 bootstrap.

Target UI may display/select targets.

It must not own anatomy integrity.

Authoritative anatomy is:

`hunt01_mudcrest_anatomy_runtime.gd`.

---

# 8. Combat relationship

## Current first-person boundary

Current first-person path:

Observe/Engage
→ target group selection
→ target lock
→ Combat Bridge 002
→ create/init Mudcrest anatomy runtime
→ create/init combat turn shell
→ stop before attack execution.

This is intentional.

## Proven Hunt-01 domain

The deterministic domain already contains:

- combat scheduler;
- AP/RP/Stamina;
- tactical movement;
- reactions;
- Hunter attack;
- defense consequences;
- health/injury;
- status application;
- status timing;
- encounter outcome;
- Mudcrest anatomy;
- Mudcrest attack runtime;
- wound/contact logic;
- tracking;
- encounter trigger.

## Required future relationship

Do not duplicate those systems in the first-person presentation layer.

Future flow should be:

current physical world
→ derive current-world combat/spatial intent
→ current-world spatial adapter
→ proven deterministic combat owner
→ anatomy/status/resource mutation
→ event/result
→ first-person visual/HUD feedback.

The adapter is the missing architectural bridge.

---

# 9. Region 01 relationship

Region 01 is a real tested integration path.

It demonstrates:

tracking
→ evidence completion
→ physical observation
→ explicit engagement
→ fuller tactical/combat stack.

Use Region 01 for:

- deterministic-domain provenance;
- regression behavior;
- older integration evidence;
- compatibility tests.

Do not use Region 01 for:

- current compact-world transforms;
- current first-person camera authority;
- current settlement coordinates;
- automatic tactical teleport positions.

Old Region-01 spatial assumptions require an adapter before current-world reuse.

---

# 10. Monster presentation ↔ anatomy relationship

Mudcrest visual:

`game/assets/monsters/mudcrest_visual.tscn`

contains readable named visual regions.

Examples:

- torso;
- head;
- horn crest;
- dorsal plates;
- forelegs;
- hindlegs;
- tail.

These support presentation and targeting readability.

Authoritative anatomy:

`hunt01_mudcrest_anatomy_runtime.gd`

Relationship:

domain anatomy state
→ presentation mapping
→ highlight/damage/break visual feedback.

Never:

visual node HP
→ independent gameplay truth.

There should be one authoritative anatomy model.

---

# 11. Status/health relationship

Hunter and Monster status/health effects belong to deterministic gameplay/domain owners.

Presentation relationship:

domain status
→ HUD/status icon/text
→ animation/effect cue.

HUD must not decrement health itself.

Visual effects must not apply duplicate status truth.

Status timing must remain in status-domain owners, not timers attached only to UI.

---

# 12. State-ownership relationship

Executable ownership contract:

`game/scripts/state/pixel_rpg_state_ownership_contract.gd`

Current broad ownership classes:

## World runtime

Owns physical live transforms/physics.

## Combat domain

Owns turn resources, scheduler, anatomy, combat results.

## Transient controls

Own touch, camera pose, targeting selection, interaction context.

## Presentation

Owns disposable visual representation only.

## Planned durable systems

Will eventually own persistent:

- player progression;
- world decisions;
- inventory/equipment;
- NPC relationships;
- economy.

Relationship rule:

one mutable datum
→ one authoritative owner
→ many readers/adapters allowed.

Do not add mirror owners.

---

# 13. Persistence relationship

Broad save/load is not yet implemented.

Future relationship should be:

authoritative gameplay owners
→ stable snapshot builder
→ versioned save schema
→ atomic storage
→ validation/migration
→ restore authoritative owners
→ rebuild transient/presentation state.

Do not save:

- current joystick touch;
- current camera touch ID;
- open HUD panel as gameplay truth;
- callbacks;
- presentation-only highlight state.

Combat persistence, if supported later, requires explicit stable domain snapshots.

---

# 14. Asset relationship

Current recommended lineage:

source/reference
→ approved master
→ derivative
→ runtime asset
→ runtime manifest/hash
→ scene integration
→ automated tests
→ Android build
→ device visual/performance acceptance.

Current examples:

Pack 010:
concept source
→ derived material textures
→ environment scene materials
→ tests.

Pack 011:
concept source crop
→ direct PNG
→ data manifest/path/hash
→ Sprite3D loader
→ live world integration
→ tests.

Canonical hands:
source PNG
→ source identity/hash
→ ViewModel Sprite3D
→ first-person tests
→ Android build.

Asset presentation must not silently become collision/state authority.

---

# 15. Documentation relationship

Current documentation hierarchy is intentionally separated.

Root current-authority/navigation:
→ bootstrap, authority, presentation, handoff, operating law.

`docs/00_authority/`
→ authority barriers and migration audit.

`docs/00_project/`
→ maps, classification, governance, status.

`docs/10_world/`
→ world design contracts/provenance.

`docs/20_gameplay/`
→ gameplay design contracts.

`docs/30_content/`
→ concrete content packages.

`docs/40_art/`
→ runtime-art records + pipeline provenance.

`docs/50_technical/`
→ technical/state/persistence/build architecture.

`docs/60_quality/`
→ quality/test/performance protocols.

`docs/70_handoff/`
→ historical continuity/evidence only.

Documentation never replaces live implementation truth.

---

# 16. Test relationship

For a bounded implementation owner:

source owner
→ focused test
→ broader regression tests if dependency surface requires
→ canonical CI
→ Android export if build-affecting
→ physical device evidence only when physical behavior is claimed.

Current canonical CI discovers:

- Python preflights;
- `game/tests/*_test.gd`;
- Godot import/parse;
- AppShell smoke;
- Android export/integrity/hash/size.

The four `ci/stage1/*.gd` scripts are not automatically equivalent to current canonical GDScript gates unless explicitly invoked.

---

# 17. Build relationship

Current canonical automation:

`.github/workflows/pixel-rpg-ci.yml`

Relationship:

commit SHA
→ verification job
→ logs/evidence
→ Android build job
→ APK
→ hash/size/integrity
→ artifact.

An APK alone does not prove source provenance.

The chain must retain:

repository
+ branch/ref
+ commit
+ workflow/run
+ job
+ artifact hash.

Physical-device evidence is another layer after export.

---

# 18. Issue relationship

Current master issue:

#20.

Important current architecture tracks:

#1
→ prototype decomposition.

#2
→ geometry/collision ownership.

#9
→ player/touch/camera separation.

#21
→ documentation/authority migration cleanup.

Other planned issues depend on foundations:

sections/buildings/streaming
→ need clear world/collision ownership.

NPC schedules/interactions
→ need stable building/interaction anchors.

persistence
→ needs stable state ownership.

full current-world combat
→ needs explicit current-world spatial adapter.

---

# 19. Dependency order for future work

A safe dependency order is:

## Foundation

authority/documentation clarity
→ owner clarity
→ controller decomposition
→ collision/building contract.

## World

section definitions
→ building blueprint
→ settlement sections
→ streaming
→ NPC anchors/schedules.

## Durable systems

state owners
→ persistence schema
→ inventory/equipment
→ NPC relationships
→ economy.

## Combat integration

current-world spatial graph
→ Combat Bridge extension
→ attack/reaction integration
→ break/sever
→ harvest consequences.

## Content expansion

more Monsters
→ more hunts
→ more settlements
→ progression/economy depth.

Do not expand content faster than ownership/test infrastructure can support.

---

# 20. Anti-patterns to reject

Do not:

- create a second player position owner;
- store camera pose as gameplay save truth;
- let HUD own HP;
- let a Monster visual node own anatomy independently;
- let a concept PNG define exact collision;
- treat visual doors as physical openings without collision work;
- duplicate Hunt-01 combat logic inside first-person UI code;
- transplant legacy Region-01 tactical coordinates directly;
- use a historical handoff as current authority;
- call a CI pass a phone-performance pass;
- call an APK a source-proven build without its SHA/workflow chain;
- add one giant GameState singleton to avoid owner design;
- rewrite many systems just to change presentation.

---

# 21. Desired architecture pattern

For each major feature, aim for:

`CONTENT/CONFIG`
→ immutable definitions/data

`DOMAIN OWNER`
→ authoritative mutable rules/state

`WORLD/ADAPTER`
→ translates physical-world context to domain intent

`PRESENTATION`
→ renders domain/world state

`INPUT`
→ creates player intent

`TESTS`
→ verify owner and adapter boundaries

`BUILD/DEVICE EVIDENCE`
→ prove execution at increasing evidence levels.

This pattern should be repeated rather than creating feature-specific ownership exceptions.

---

# 22. Quick flow diagrams

## Exploration

touch
→ touch state
→ camera/movement math
→ player motor
→ Hunter CharacterBody3D
→ world transform
→ interaction/targeting queries
→ HUD.

## Interaction

world proximity/context
→ interaction owner
→ action intent
→ service/NPC/world result
→ presentation feedback.

## Combat

physical encounter
→ targeting
→ selected anatomy target
→ current-world combat adapter
→ deterministic combat domain
→ anatomy/status/resource result
→ visual/HUD feedback.

## Persistence

authoritative owners
→ stable snapshot
→ save
→ load/validate/migrate
→ restore owners
→ rebuild transient/presentation state.

## Asset promotion

source
→ derivative
→ runtime import
→ manifest/hash
→ live scene integration
→ automated verification
→ Android build
→ device visual/performance acceptance.

---

# 23. Current gap map

Current important gaps:

- generic building collision does not match visible doors;
- full reusable building contract not generalized from smith yet;
- current prototype still owns orchestration glue;
- full first-person current-world combat adapter is missing;
- structural Monster break/sever remains incomplete;
- broad save/load is not implemented;
- current-world inventory/crafting/harvest loop is incomplete;
- physical-device acceptance remains separate;
- stable Android signing/update continuity is not yet proven;
- main branch required-check enforcement remains open.

These are gaps in integration/architecture—not evidence that proven underlying systems should be discarded.

---

# 24. Continuation rule

When adding or changing a feature:

1. identify the feature's authoritative owner;
2. identify its readers/adapters;
3. confirm no duplicate mutable truth exists;
4. identify focused tests;
5. make one bounded change;
6. verify source/runtime behavior;
7. run dependency regressions;
8. record exact build evidence when relevant;
9. use physical-device evidence for physical claims;
10. update documentation only after behavior/ownership is proven.

For exact file locations, use:

`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`.

For document/folder authority, use:

`docs/00_project/PACKAGE_AUTHORITY_MATRIX_2026-09-25.md`.
