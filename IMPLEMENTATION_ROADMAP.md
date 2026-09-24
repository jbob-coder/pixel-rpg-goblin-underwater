# Unnamed Hunt RPG — Implementation Roadmap

Status: STAGE 1 ENGINE/ANDROID PROBE AUTHORIZED / LATER STAGES DEPENDENCY-GATED
Last reconciled: 2026-09-02

## Purpose

Build the game from foundational risk to detail, proving each dependency before expanding content. The roadmap starts with platform evidence, then domain foundations, combat, exploration, integration, tooling and expansion.

Readiness authority:
`docs/00_project/BUILD_READINESS_GATE_MATRIX.md`.

Current engine/device authority:
`docs/50_technical/ENGINE_ANDROID_PROBE_DECISION.md`.

## Mandatory loop

`READ STATE → VERIFY → DEFINE ONE SMALL PIECE → IDENTIFY OWNER → IMPLEMENT → TEST → PROFILE IF RELEVANT → INSPECT REGRESSION → FIX → UPDATE DOCS → SAVE/COMMIT → READ BACK → MARK GATE → NEXT`

No phase advances because it merely looks promising.

---

# Stage 0 — Design foundation

Status:
**SUFFICIENT FOR STAGE 1 / DESIGN CONTINUES BY LATER READINESS GATES**.

Recorded foundation includes:
- game experience philosophy;
- aerial/first-person visual behavior;
- core hunting loop;
- anatomy/harvest architecture;
- six-role attributes;
- shared modifier/effect architecture;
- equipment/status/terrain interaction rules;
- deterministic NPC/creature pattern architecture;
- crystal life-force architecture;
- Tier/Rank/Quality/Element separation;
- desperation/berserk reserve-drain model;
- mutation architecture/support limits;
- bounded ecology/population strategy;
- architecture/ownership;
- content schema direction;
- code guide;
- performance caps;
- Admin/Creator architecture;
- verification rules;
- first settlement blueprint;
- Region 01 package;
- Hunter Base 01 design;
- Monster 01 design;
- player progression/equipment model;
- 4 AP / 1 RP / persistent-Stamina action economy.

Important change:
not every remaining design question blocks Stage 1.

Unresolved questions are classified by:
- before engine probe;
- before domain implementation;
- before combat;
- before vertical slice;
- expansion-only.

Gate:
`ENGINE_PROBE_DESIGN_READY = YES`.

---

# Stage 1 — Engine and Android probe

Status:
**CURRENT / AUTHORIZED**.

Selected candidate:
- Godot 4.7;
- GDScript;
- GL Compatibility renderer;
- Samsung Galaxy A03s baseline device;
- stable 30 FPS representative-scene target.

Purpose:
fail cheaply if the rendering/input/lifecycle stack is wrong.

Create only:
- boot/title probe;
- landscape orientation;
- tiny forest/diorama region;
- aerial 40–50° camera;
- 1.75 m hunter placeholder;
- one large animated monster placeholder;
- billboard/impostor vegetation experiment;
- touch movement/input;
- limited shadow experiment;
- camera descent to first-person;
- combat HUD mock only;
- first-person monster framing;
- basic audio;
- suspend/resume;
- development performance instrumentation.

Measure:
- cold launch;
- FPS/frame pacing;
- memory and peak transition memory;
- input responsiveness;
- camera transition cost;
- thermal behavior;
- suspend/resume;
- crashes/ANRs.

No real combat, harvest or crafting source in this stage.

Gate:
`ENGINE_PHONE_PROBE_VERIFIED`.

If the gate fails, stop before Stage 2 and record why. Do not silently continue.

---

# Stage 2 — Project skeleton and domain core

Blocked until Stage 1 passes.

Implement:
- app/game shell;
- content repository interfaces;
- stable IDs/validation;
- domain result/error model;
- seeded RNG abstraction;
- GameState skeleton;
- PlayerState;
- WorldState;
- MonsterDefinition/MonsterInstance;
- BodyPartDefinition/BodyPartState;
- EncounterState;
- domain events;
- test runner/verification entry point.

Gate:
`DOMAIN_FOUNDATION_TESTED`.

---

# Stage 3 — Shared stats/effects foundation

Implement:
- six attributes;
- derived-stat evaluator;
- typed effects/modifiers;
- stack groups/policies;
- caps/floors;
- equipment effects;
- status lifecycle;
- terrain/weather context effects;
- calculation trace;
- caching/invalidation.

Tests must cover modifier ordering, stacking, caps and deterministic traces.

Gate:
`STATS_EFFECTS_CORE_TESTED`.

---

# Stage 4 — Crystal, mutation and bounded ecology foundation

Implement smallest authoritative core:
- Tier/Rank/Quality/Element definition;
- CrystalCoreState Energy/Condition/Strain;
- zero-Energy death invariant;
- energy transaction API;
- berserk state/drain skeleton;
- mutation definitions/prerequisites/incompatibilities/support-load;
- mutation effects/capabilities/anatomy hooks;
- minimal region/species aggregate;
- deterministic creature-variant generation;
- debug trace data.

First implementation remains deliberately narrow: one practical element/tier context, small rank/quality range, 2–4 mutations, one berserk rule, one population aggregate.

Gate:
`CRYSTAL_MUTATION_CORE_TESTED`.

---

# Stage 5 — Content validation foundation

Before mass content, validate:
- species/NPCs;
- attributes;
- anatomy;
- attacks/capabilities;
- effects/statuses;
- terrain/weather;
- deterministic behavior rules;
- crystals/mutations;
- ecology profile;
- harvest;
- materials/recipes;
- encounter layouts.

Create minimal first-slice content only.

Gate:
`CONTENT_SCHEMA_VALIDATED`.

---

# Stage 6 — Tactical combat core

Design prerequisite authority:
`docs/00_project/BUILD_READINESS_GATE_MATRIX.md`.

Before implementation, the required combat packets must be recorded, including the pending Combat Resolution / Hit Quality and Defense Contract and minimal first-weapon/status/terrain/Monster-attack decisions.

Implement domain-only:
- turn order;
- approved 4 AP / 1 RP / Stamina economy;
- tactical nodes;
- movement/reposition;
- terrain movement context;
- range/bearing;
- cover;
- body-part exposure;
- one weapon family;
- attack/context resolution;
- hit-quality bands;
- break/sever/destroy;
- capability loss;
- small status set;
- one deterministic monster combat profile;
- core-energy consequences;
- one berserk pattern;
- telegraph/pending action;
- victory/escape/failure.

Tests precede presentation.

Gate:
`COMBAT_CORE_TESTED`.

---

# Stage 7 — Combat presentation

Connect first-person presentation to domain events:
- EncounterScene;
- tactical camera movement;
- monster presentation/rig placeholder or verified asset;
- body targeting;
- telegraphs;
- impacts;
- break/sever presentation;
- terrain/cover visualization;
- status indicators;
- berserk presentation;
- combat HUD/audio;
- animation skip/fast-forward safety.

Gate:
`COMBAT_PRESENTATION_PHONE_VERIFIED`.

---

# Stage 8 — Harvest core

Implement:
- harvest capacities;
- condition/quality mapping;
- one extraction/tool path;
- unique-part invariants;
- severed-part/carcass depletion;
- material award;
- crystal extraction result if first-slice design uses it;
- harvest explanation trace.

Prove combat damage changes harvest outcome without creating impossible material.

Gate:
`HARVEST_CORE_TESTED`.

---

# Stage 9 — Inventory, equipment and crafting

Implement:
- materials/inventory;
- first loadout slots;
- equip/unequip invalidation;
- one crafted item/upgrade;
- recipe validation/material consumption;
- one meaningful equipment tradeoff.

Crystal crafting hooks remain blocked unless human crystal use is explicitly selected for the slice.

Gate:
`EQUIPMENT_CRAFT_LOOP_TESTED`.

---

# Stage 10 — Exploration domain

Implement:
- world position/traversal/collision;
- terrain tags/effects;
- Region 01 definition;
- persistent Monster 01 world instance;
- deterministic roaming/territory pattern;
- tracks/evidence;
- encounter initiation;
- camp/exit minimal flow;
- transfer of the same monster into EncounterState.

Gate:
`EXPLORATION_DOMAIN_TESTED`.

---

# Stage 11 — Bounded ecology integration

Implement only enough to prove architecture:
- one region/species aggregate;
- abundance/development distribution;
- allowed mutation distribution;
- elemental/terrain pressure inputs;
- deterministic spawn variant selection;
- required aggregate persistence.

No broad breeding/predator-prey simulation yet.

Gate:
`ECOLOGY_AGGREGATE_TESTED`.

---

# Stage 12 — Aerial exploration presentation

Implement:
- RegionScene;
- validated aerial camera;
- touch movement;
- terrain/structures;
- hunter presentation;
- roaming Monster 01 presentation;
- tracking clues;
- lightweight HUD;
- region ambience/music;
- encounter camera transition.

Gate:
`EXPLORATION_PHONE_VERIFIED`.

---

# Stage 13 — Full vertical-slice integration

Readiness authority:
`docs/00_project/BUILD_READINESS_GATE_MATRIX.md`.

Join:
`TITLE/PREP → MINIMAL WALKABLE HUB → GATE → REGION → TRACK → ENGAGE → COMBAT → BREAK/SEVER/BERSERK → DEFEAT/ESCAPE → HARVEST → RETURN → CRAFT/EQUIP ONE UPGRADE → SAVE/RELOAD`.

Prove:
- same monster identity across world/combat;
- anatomy/status/crystal/mutations persist;
- terrain/context transfers correctly;
- no duplicate harvest;
- equipment modifiers recalculate correctly;
- deterministic behavior remains legal after anatomy/status/core changes;
- zero-Energy death invariant;
- Android lifecycle/performance remains acceptable.

Gate:
`VERTICAL_SLICE_RUNTIME_VERIFIED`.

---

# Stage 14 — Save-system hardening

Expand the minimal vertical-slice persistence into:
- schema/versioning;
- atomic save where supported;
- validation;
- backup/recovery;
- migration fixtures;
- corruption handling;
- explicit active-hunt/encounter policy.

Gate:
`SAVE_SYSTEM_VERIFIED`.

---

# Stage 15 — Read-only Admin/Debug foundation

After real state exists, add:
- state/stat/effect inspectors;
- calculation traces;
- deterministic behavior trace;
- status/terrain inspector;
- crystal/mutation inspector;
- anatomy/encounter inspector;
- event log;
- validation panel;
- performance overlay;
- subsystem isolation toggles.

Gate:
`ADMIN_INSPECTOR_VERIFIED`.

---

# Stage 16 — Admin mutation/test tools

Add typed test commands that preserve structural invariants:
- resources/attributes;
- items/materials;
- statuses;
- terrain/weather context;
- crystal/mutation test state;
- deterministic variant generation;
- validated spawn/encounter;
- part states;
- deterministic behavior-rule diagnostics;
- test teleport/save duplication.

Gate:
`ADMIN_TEST_COMMANDS_VERIFIED`.

---

# Stage 17 — Creator tools

Only after schemas stabilize:
- creature/anatomy/attack editors;
- stats/equipment/effect/status editors;
- terrain/weather tools;
- deterministic behavior-pattern editor;
- crystal/mutation/ecology tools;
- harvest/material/recipe tools;
- encounter/region helpers;
- validation/export/import;
- deterministic replay viewer.

Gate:
`CREATOR_WORKFLOW_VERIFIED`.

---

# Stage 18 — First real art/audio production pass

Replace placeholders systematically only after gameplay structures are proven:
- hunter;
- first monster;
- region kit;
- settlement kit;
- textures/materials;
- animation/effects;
- music/audio.

Every production asset requires provenance and performance budget.

Gate:
`FIRST_SLICE_VISUAL_AUDIO_QUALITY_VERIFIED`.

---

# Stage 19 — Second-content extensibility proof

Add one genuinely different second monster and/or weapon/content path to prove the architecture is reusable rather than hard-coded to Monster 01.

Gate:
`EXTENSIBILITY_PROVEN`.

---

# Stage 20 — World/campaign expansion

Only after the verified slice:
- more regions/hubs;
- story/contracts;
- broader NPC schedules;
- expanded crafting/economy;
- broader ecology/mutation distributions;
- additional weather/day-night mechanics where justified.

Most requirements classified `CAN_WAIT_UNTIL_EXPANSION` belong here or later.

---

# Stage 21 — Optimization and release discipline

Performance work occurs continuously, with release preparation including:
- target-device matrix;
- quality presets;
- worst-case benchmarks;
- save migration tests;
- crash/ANR review;
- accessibility/localization pass as required;
- all content validators green;
- signing/version/integrity checks;
- runtime regression suite.

---

# Anti-shortcut rules

Do not:
- create many monsters before one hunt is fun;
- create many elements/mutations before the first crystal loop is understandable;
- simulate thousands of full off-screen creatures;
- let berserk become a free generic stat multiplier;
- let crystal health replace anatomy gameplay;
- create a giant world before streaming/performance is proven;
- create final UI before domain requirements stabilize;
- build the full Creator suite before schemas exist;
- hard-code per-item/status/terrain/mutation math in presentation scripts;
- build opaque AI when authored deterministic condition patterns are the design;
- optimize speculative bottlenecks while ignoring measured ones;
- claim phone behavior from desktop/build success;
- allow Admin tools to bypass invariants invisibly;
- treat expansion-only design questions as blockers for earlier implementation gates.

---

# Current position

As of 2026-09-02:

`IMPLEMENTATION_AUTHORIZED = YES`
`CURRENT_STAGE = STAGE_1_ENGINE_ANDROID_PROBE`
`ENGINE_PROBE_CANDIDATE = GODOT_4_7_GDSCRIPT_GL_COMPATIBILITY`
`FINAL_ENGINE_SELECTED = NO / PROBE_PENDING`
`TARGET_BASELINE_DEVICE = SAMSUNG_GALAXY_A03S`
`BASELINE_DEVICE_FRAME_TARGET = STABLE_30_FPS_PROBE_TARGET`
`ENGINE_PROBE_READINESS = READY`
`DOMAIN_IMPLEMENTATION = BLOCKED_UNTIL_ENGINE_PHONE_PROBE_VERIFIED`
`COMBAT_IMPLEMENTATION = BLOCKED_BY_PRIOR_GATES_AND_COMBAT_DESIGN_REQUIREMENTS`
`VERTICAL_SLICE_IMPLEMENTATION = BLOCKED_BY_PRIOR_GATES`

Exact next implementation piece:
**smallest Godot 4.7 Compatibility Android probe skeleton.**

Independent design work may continue only when it belongs to a later readiness gate and does not conflict with the active implementation piece.
