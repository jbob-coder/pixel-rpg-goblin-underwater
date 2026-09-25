# Pixel RPG — Handoff Classification Index

Status: CURRENT HANDOFF NAVIGATION / DOCUMENTATION BRANCH  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Purpose

`docs/70_handoff/` contains historical continuity records. This index classifies every handoff so older evidence can be found without accidentally promoting an old camera, branch, coordinate system, issue map, or implementation state into current authority.

No handoff is current design authority merely because it is listed here.

Current authority remains:

current creator instruction  
→ live production `main`  
→ exact source owner  
→ exact tests  
→ exact same-SHA build/device evidence  
→ current issue register  
→ current documentation map/authority files.

Historical SHA/workflow/APK/device evidence remains valid only for the exact revision/evidence it identifies.

## Classification rules

### A — Current-lineage Pixel RPG technical evidence

These records describe subsystems whose descendants remain present in current Pixel RPG source/tests.

Use them for provenance, earlier verification evidence, and design rationale.

Current source/tests override old branch names, old issue numbers, old workflow paths, or stale presentation wording.

### B — Superseded Pixel RPG presentation checkpoints

These records are factual history for older Pixel RPG presentation states, especially third-person or pre-first-person checkpoints.

Do not use them to restore old camera/presentation authority.

Technical findings may still be useful where current source/tests preserve the underlying subsystem.

### C — Live Hunt-01 deterministic domain provenance

These records describe deterministic combat/anatomy/status/tracking foundations that still have current source/test descendants.

Use them to understand domain behavior and regression lineage.

Do not assume their older coordinates, UI, boot path, or production workflow are current-world authority.

### D — Region-01 / legacy spatial and graybox provenance

These records describe Region-01 coordinates, graybox geometry, manifest validation, and tracking-to-encounter integration.

The Region-01 runtime remains real/tested code, but it is not the current app boot path.

Do not reuse its absolute tactical/world coordinates in the compact first-person world without an explicit adapter.

### E — Future/partial-system design provenance

These records define harvest, inventory, crafting, persistence, service, terrain, or Berserk-era contracts that are not broad current-world implemented systems.

Use as design/provenance inputs only after checking current source/issues.

### F — Stage-1 probe and target-device history

These records belong to the isolated Stage-1 probe/device-validation lineage.

They may contain useful Android/device/input/performance observations, but they do not define current production gameplay architecture.

### G — Bootstrap/asset-generation history

These records preserve old bootstrap and asset-generation process history.

They are not current implementation authority.

---

# A — Current-lineage Pixel RPG technical evidence

- `PIXEL_RPG_COMBAT_BRIDGE_002_BUILDIDENTITY_V1_2026-09-23.md`
- `PIXEL_RPG_FIRST_PERSON_REALIGNMENT_2026-09-23.md`
- `PIXEL_RPG_STARTING_AREA_ASSET_PACK_001_2026-09-23.md`
- `PIXEL_RPG_STARTING_AREA_ASSET_PACK_002_SMITH_2026-09-23.md`
- `PIXEL_RPG_STARTING_AREA_ASSET_PACK_003_ENVIRONMENT_2026-09-23.md`
- `PIXEL_RPG_STARTING_AREA_ASSET_PACK_004_HOST_ENVIRONMENT_2026-09-23.md`
- `PIXEL_RPG_STARTING_AREA_ASSET_PACK_005_GATE_WARDEN_2026-09-23.md`
- `PIXEL_RPG_STARTING_AREA_ASSET_PACK_006_BUILDINGS_2026-09-23.md`
- `PIXEL_RPG_STARTING_AREA_ASSET_PACK_007_PATH_SURFACES_2026-09-23.md`
- `PIXEL_RPG_STATE_OWNERSHIP_CONTRACT_001_2026-09-23.md`
- `PIXEL_RPG_VISUAL_PACK_008_MUDCREST_REFINEMENT_2026-09-23.md`
- `PIXEL_RPG_VISUAL_PACK_009_FIRST_PERSON_VIEWMODEL_2026-09-23.md`
- `PIXEL_RPG_WORLD_PACK_004_ENTERABLE_SMITH_VERTICAL_SLICE_2026-09-21.md`

## How to use Class A

These are the first handoffs to consult when a current task specifically concerns:

- first-person realignment;
- Combat Bridge 002;
- state ownership;
- canonical ViewModel lineage;
- starting-area reusable assets;
- current smith building lineage;
- Mudcrest visual refinement.

Caution: some Class-A records still contain historical branch labels or presentation wording from the exact revision they documented. Never let that wording override live source.

---

# B — Superseded Pixel RPG presentation checkpoints

- `PIXEL_RPG_BRANCH_RECOVERY_2026-09-16.md`
- `PIXEL_RPG_COMBAT_BRIDGE_001_THIRD_PERSON_TARGETING_PREVIEW_2026-09-21.md`
- `PIXEL_RPG_PIXEL_CAMERA_HUD_POLISH_2026-09-16.md`
- `PIXEL_RPG_PROTOTYPE_001_2026-09-16.md`
- `PIXEL_RPG_VISUAL_PACK_002_HUNTER_MONSTER_READABILITY_2026-09-21.md`
- `PIXEL_RPG_VISUAL_PACK_003_HUD_LAYOUT_ALIGNMENT_2026-09-21.md`
- `PIXEL_RPG_WORLD_COMPOSITION_PACK_001_2026-09-20.md`

## How to use Class B

These records are useful for:

- provenance;
- exact old build evidence;
- understanding why later first-person changes were required;
- preserving technical lessons from earlier world/HUD/targeting work.

They are **not** current presentation authority.

In particular, Bridge 001's third-person acquisition state is historical. Current Pixel RPG is first-person.

---

# C — Live Hunt-01 deterministic domain provenance

- `COMBAT_ACTION_ECONOMY_PASS_2026-09-02.md`
- `COMBAT_RESOLUTION_PASS_2026-09-02.md`
- `DEFEAT_RETREAT_BASELINE_PASS_2026-09-03.md`
- `FIRST_SLICE_STATUS_SET_PASS_2026-09-03.md`
- `FIRST_WEAPON_FAMILY_PASS_2026-09-02.md`
- `HUNT01_BASIC_RUNTIME_AUTORUN_2026-09-13.md`
- `HUNT01_COMBAT_FOUNDATION_RECONCILIATION_2026-09-04.md`
- `HUNT01_GENERIC_STAGGERED_STATUS_RUNTIME_2026-09-13.md`
- `HUNT01_GENERIC_STATUS_APPLICATION_RUNTIME_2026-09-04.md`
- `HUNT01_GENERIC_STATUS_TIMING_RUNTIME_2026-09-05.md`
- `HUNT01_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_2026-09-04.md`
- `HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_2026-09-06.md`
- `HUNT01_HUNTER_HEALTH_INJURY_RUNTIME_2026-09-04.md`
- `HUNT01_HUNTER_REACTION_WINDOW_RUNTIME_2026-09-04.md`
- `HUNT01_MUDCREST_ANATOMY_INTEGRITY_RUNTIME_2026-09-04.md`
- `HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME_2026-09-04.md`
- `HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME_2026-09-13.md`
- `HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME_2026-09-04.md`
- `HUNT01_TAIL_SWEEP_CLEAN_STAGGERED_PRODUCER_2026-09-13.md`
- `HUNT01_TRACKING_EVIDENCE_RUNTIME_PASS_2026-09-04.md`
- `INITIATIVE_AND_TURN_ORDER_PASS_2026-09-03.md`
- `MONSTER_01_COMBAT_ATTACK_PACKET_PASS_2026-09-03.md`
- `SOLO_PARTY_BASELINE_PASS_2026-09-03.md`
- `STAMINA_PROTOTYPE_PASS_2026-09-02.md`

## How to use Class C

Current source still contains descendants of the deterministic Hunt-01 systems under:

- `game/scripts/gameplay/combat/`;
- `game/scripts/gameplay/monsters/monster_01/`;
- `game/scripts/gameplay/tracking/`;
- `game/scripts/gameplay/encounter/`.

Use these handoffs for exact historical semantics and verification lineage, but verify current behavior through current source/tests.

Current first-person presentation should adapt to these domain owners instead of duplicating them.

---

# D — Region-01 / legacy spatial and graybox provenance

- `FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_VALIDATION_PASS_2026-09-03.md`
- `FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION_PASS_2026-09-03.md`
- `FIRST_SLICE_REGION01_HUNT01_GRAYBOX_STATIC_VALIDATOR_PASS_2026-09-04.md`
- `FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_PASS_2026-09-03.md`
- `FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_PASS_2026-09-03.md`
- `HUNT01_PRODUCTION_GRAYBOX_IMPLEMENTATION_PASS_2026-09-04.md`

## How to use Class D

The Region-01 scene and tests still exist and remain useful regression/integration evidence.

However:

- Region-01 is not the current app boot scene;
- its absolute coordinates are not current compact-world authority;
- current-world tactical movement/combat requires an explicit spatial adapter;
- do not solve integration by translating/offsetting the legacy graph blindly.

---

# E — Future/partial-system design provenance

- `FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_PASS_2026-09-03.md`
- `FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_PASS_2026-09-03.md`
- `FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_PASS_2026-09-03.md`
- `FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_PASS_2026-09-03.md`
- `FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_PASS_2026-09-03.md`
- `FIRST_SLICE_TERRAIN_EFFECT_SET_PASS_2026-09-03.md`
- `MONSTER_01_BERSERK_PROTOTYPE_PASS_2026-09-03.md`

## How to use Class E

These are not broad current-world implementation claims.

Examples:

- the current smith is enterable, but full crafting/service gameplay is not yet implemented;
- broad save/load is not implemented;
- harvest/inventory/crafting remain planned or partial;
- Berserk is not the current completed Monster behavior stack.

Read current issues/source before promoting any of these contracts into implementation work.

---

# F — Stage-1 probe and target-device history

- `STAGE1_AERIAL_FIRST_PERSON_STATE_CONTINUITY_2026-09-03.md`
- `STAGE1_ANDROID_LIFECYCLE_FOUNDATION_REVIEW_2026-09-03.md`
- `STAGE1_ANDROID_LIFECYCLE_TRANSIENT_INPUT_RESET_2026-09-03.md`
- `STAGE1_CONTROL_CAMERA_REFINEMENT_2026-09-03.md`
- `STAGE1_GALAXY_A03S_ADAPTIVE_JOYSTICK_REPAIR_2026-09-04.md`
- `STAGE1_GALAXY_A03S_CONTROL_CAMERA_REPAIR_2026-09-04.md`
- `STAGE1_GALAXY_A03S_RUNTIME_EVIDENCE_2026-09-03.md`
- `STAGE1_GALAXY_A03S_SHOOTER_STYLE_CONTROLS_REPAIR_2026-09-04.md`
- `STAGE1_JOYSTICK_HEADING_RESET_2026-09-03.md`
- `STAGE1_MONSTER_PLACEHOLDER_SOLID_COLLISION_2026-09-03.md`
- `STAGE1_PROBE_SKELETON_PASS_2026-09-02.md`
- `STAGE1_STATIC_PREFLIGHT_PASS_2026-09-02.md`
- `STAGE1_SUSTAINED_PERFORMANCE_EVIDENCE_PREPARATION_2026-09-03.md`
- `STAGE1_TARGET_DEVICE_FEEDBACK_CAMERA_COLLISION_2026-09-03.md`
- `STAGE1_WORLD_BOUNDARY_REGRESSION_2026-09-03.md`

## How to use Class F

These records belong to the isolated probe path under:

`probes/android_stage1/`

They may contain useful evidence about:

- Android launch;
- target-device rendering;
- touch controls;
- lifecycle;
- camera behavior;
- performance methodology.

They do not define current production game architecture, current camera ownership, or current world presentation.

Device evidence remains valid only for the exact APK/device/run it documented.

---

# G — Bootstrap/asset-generation history

- `ASSET_GENERATION_PASS_2026-09-02.md`
- `NEW_CHAT_BOOTSTRAP_PROMPT_RECONCILIATION_2026-09-13.md`

## How to use Class G

Use only for historical process/provenance.

Current bootstrap is:

`START_HERE_NEW_CHAT.md`

Current asset/runtime-art authority comes from live source/tests and current Pixel RPG art documents.

---

# Handoff lookup by current task

| Current task | First historical records to consult |
|---|---|
| First-person camera | `PIXEL_RPG_FIRST_PERSON_REALIGNMENT_2026-09-23.md` |
| Canonical ViewModel/hands | `PIXEL_RPG_VISUAL_PACK_009_FIRST_PERSON_VIEWMODEL_2026-09-23.md` |
| Combat Bridge | Bridge 002 first; Bridge 001 only for historical acquisition semantics |
| State ownership | `PIXEL_RPG_STATE_OWNERSHIP_CONTRACT_001_2026-09-23.md` |
| Enterable smith | World Pack 004 + Starting Area Pack 002 |
| Starting-area assets | Starting Area Packs 001–007 |
| Mudcrest anatomy | `HUNT01_MUDCREST_ANATOMY_INTEGRITY_RUNTIME_2026-09-04.md` |
| Mudcrest attacks/status | Head Sweep, Tail Sweep, wound/contact, generic status handoffs |
| Region-01 regression | Class D + `HUNT01_TRACKING_EVIDENCE_RUNTIME_PASS_2026-09-04.md` |
| Android probe/device history | Class F |
| Persistence design | `FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_PASS_2026-09-03.md`, then current state-ownership docs |
| Crafting/harvest/inventory design | Class E, then current issues/source |

## Preservation law

Do not rewrite old handoffs to make them look as if they described the current game.

An old handoff may contain:

- stale branch names;
- superseded issue numbers;
- old workflow names;
- old camera authority;
- old coordinates;
- old next-action statements.

Those are part of the historical record.

Use this index and current authority documents to decide whether a handoff is:

- live technical provenance;
- superseded presentation history;
- domain regression history;
- future design provenance;
- probe/device evidence.

## Verification boundary

A handoff's old PASS result proves only the exact source/build/device evidence recorded there.

It does not automatically prove:

- current HEAD;
- current Android build;
- current phone runtime;
- current visual acceptance;
- current performance.

Current claims require current evidence.
