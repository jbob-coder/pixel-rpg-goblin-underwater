# Unnamed Hunt RPG — Code Guide

Status: STRUCTURAL PLAN / ENGINE-SPECIFIC SOURCE NOT CREATED
Last reconciled: 2026-09-02

## Purpose

Explain how future code should be divided, what each layer does, how to improve it safely, and how to isolate slow or bug-prone systems.

This guide is engine-neutral until engine selection is verified.

## 1. Code philosophy

Code should optimize for:
- correctness;
- clear ownership;
- testability;
- deterministic debugging;
- bounded performance cost;
- easy content expansion;
- replaceable presentation;
- readable source;
- safe save evolution.

Avoid clever architecture that obscures state flow.

## 2. Dependency direction

Preferred:

`Presentation / Platform → Domain API ← Persistence / Tools / Tests`

Content definitions are consumed by Domain.

Domain must not depend on rendering/UI classes.

## 3. Planned modules/packages

### `domain/world`
World/region truth:
- region ID/state;
- world position;
- roaming monster/NPC instances;
- camps/interactables;
- exploration-to-encounter context.

### `domain/exploration`
- movement requests;
- traversal validation;
- terrain effects;
- tracking interactions;
- gathering;
- encounter initiation.

### `domain/encounter`
- turn order;
- AP/stamina/reactions;
- tactical nodes;
- cover;
- legal action queries;
- encounter outcomes.

### `domain/creature`
- species/runtime monster model;
- actor attributes/capabilities;
- state transitions shared across world/combat.

### `domain/anatomy`
- body-part graph;
- part integrity;
- break/sever/destroy;
- exposure;
- capability changes.

### `domain/stats_effects`
- primary attributes;
- derived stat calculation;
- typed modifiers;
- equipment/status/terrain/weather/posture effects;
- stack rules;
- caps/clamps;
- calculation traces;
- cached derived-state invalidation.

### `domain/damage`
- hit quality;
- armor/protection/damage resolution;
- wounds/status integration;
- damage profiles.

### `domain/behavior`
- deterministic NPC/creature behavior patterns;
- state/phase controller;
- reusable condition evaluation;
- priority/cooldown/tie policy;
- normal domain action request building;
- behavior trace/debug output.

There is no AI decision module.

### `domain/harvest`
- recoverable anatomical capacity;
- method/tool/condition calculation;
- extraction/depletion.

### `domain/inventory`
- item/material stacks;
- equipment/loadout.

### `domain/crafting`
- recipes;
- crafting/upgrading;
- material consumption.

### `domain/knowledge`
- bestiary/research/mastery visibility rules.

### `persistence`
- save schema;
- serialization;
- validation;
- migration;
- backup/repair.

### `presentation/exploration`
- aerial camera;
- region visual scene;
- actor visuals;
- exploration HUD;
- input adapter.

### `presentation/combat`
- first-person camera;
- monster visual adapter;
- tactical movement animation;
- body-part targeting overlay;
- combat HUD;
- event presentation.

### `presentation/shared`
- UI components;
- audio;
- VFX;
- loading/transitions;
- accessibility presentation.

### `admin`
- state/stat/modifier inspectors;
- behavior-rule inspector;
- typed admin commands;
- creator tools;
- performance dashboard.

### `content`
Data definitions, not runtime mutation logic.

### `tests`
Unit/domain/content/integration/save/replay tests.

## 4. File/class responsibility rule

A file/class should have one primary reason to change.

Warning signs:
- one `GameManager` owns saving, UI, combat, audio and autonomous behavior;
- one monster script contains all species-specific patterns/math;
- UI button callbacks directly edit state;
- combat renderer calculates damage;
- terrain scene directly changes stats outside domain rules;
- save serializer performs gameplay decisions.

Split by responsibility, not arbitrarily by line count.

## 5. Public domain API

Presentation and behavior systems should interact through narrow operations such as:
- `queryLegalActions()`;
- `dispatchAction(request)`;
- `getSnapshot()`;
- `readDomainEvents()`;
- `evaluateContext()`;
- `loadContent(id)`.

Exact names depend on engine/language.

Do not expose mutable internals to UI for convenience.

## 6. State mutation rule

Authoritative state changes happen through validated domain commands/functions.

Prefer pure or near-pure resolution where practical:

`oldState + request + definitions + context + rng → result(newState, events, trace)`

This improves testing and replay.

## 7. Stats/effect code rule

Detailed authority: `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

Do not implement separate bonus math inside:
- equipment UI;
- status scripts;
- terrain scenes;
- attack animations;
- monster scripts.

Use one typed effect system with:
- source ID;
- target key;
- operation;
- magnitude;
- stack group/policy;
- conditions;
- timing;
- caps.

Derived stats should be cached until an input changes. Action-specific context is evaluated when validating/resolving the action.

## 8. Deterministic behavior code rule

Detailed authority: `BEHAVIOR_PATTERN_SYSTEM.md`.

Behavior does:
- read authoritative facts;
- evaluate explicit conditions;
- select a pattern by priority/tie policy;
- request a normal domain action;
- record bounded pattern memory/trace.

Behavior does not:
- mutate health directly;
- teleport through collision;
- bypass AP/stamina;
- use attacks disabled by broken anatomy;
- calculate damage;
- generate dialogue or plans through AI.

Simple actors should not pay the cost of boss-level pattern evaluation.

## 9. Error/result model

Avoid silent failure and generic booleans.

Return structured results:
- accepted/rejected;
- rejection code;
- explanation key;
- state delta/events;
- diagnostic metadata/trace in development.

## 10. Logging

Use structured, bounded logs.

Useful categories:
- lifecycle;
- save;
- region transition;
- encounter;
- combat action;
- behavior decision;
- modifier/effect calculation;
- status transition;
- anatomy transition;
- harvest;
- content validation;
- performance;
- fatal/nonfatal error.

Do not continuously print every frame.

## 11. Feature isolation

Every expensive/unstable subsystem should be separable from domain correctness.

Examples:
- domain combat runs headless;
- monster renders as debug proxy;
- foliage/VFX/music disabled;
- roaming behavior evaluation frozen;
- deterministic test behavior profile used;
- status/effect processing can expose trace without presentation;
- tactical geometry displays as debug nodes.

This supports binary-search debugging.

## 12. Performance-sensitive code rules

Avoid in per-frame paths unless measured/needed:
- repeated allocations;
- repeated content parsing;
- full behavior-rule scans for every entity every frame;
- recalculating all derived stats every frame;
- pathfinding for every actor every frame;
- rebuilding unchanged UI;
- expensive debug string generation;
- repeated disk/save writes;
- synchronous large loads during combat;
- scanning all world entities for local queries.

Prefer event-driven invalidation/indexing when ownership is clear.

## 13. Save writes

Do not write the entire save every visual frame.

Potential triggers:
- explicit save/checkpoint;
- region transition;
- encounter boundaries where needed;
- important progression change;
- app background/suspend.

Debounce/batch noncritical writes where safe.

## 14. Testing-friendly design

Inject/abstract:
- RNG;
- clock/time if mechanics use it;
- content repository;
- save repository;
- behavior profile/rule repository;
- contextual effect evaluator where useful.

Avoid hidden global singletons controlling domain rules.

## 15. Content-specific behavior

Prefer data/capability/pattern composition before monster-specific subclasses.

Code implements reusable mechanics; content combines them.

Custom source is reserved for mechanics that genuinely cannot be represented clearly through existing schemas.

## 16. Improving code safely

Before refactor:
1. identify preserved behavior;
2. ensure tests cover it;
3. identify measurable maintainability/performance problem;
4. make bounded change;
5. run regression tests;
6. compare behavior/performance;
7. update docs if ownership changed.

## 17. Bug-fix protocol

1. record exact observed behavior;
2. classify severity;
3. separate symptom from hypothesis;
4. reproduce with smallest fixture;
5. identify authoritative owner;
6. inspect calculation/behavior traces where relevant;
7. add regression test if possible;
8. fix root cause;
9. verify adjacent invariants;
10. test on device if runtime-related;
11. record result.

Do not make several speculative fixes at once.

## 18. Performance regression protocol

1. reproduce fixed scene/state;
2. record baseline metrics;
3. disable subsystems using admin toggles;
4. identify CPU/GPU/memory/loading category;
5. inspect behavior evaluation and derived-stat recalculation counts;
6. find owner;
7. optimize bottleneck;
8. compare before/after;
9. retain quality-critical features.

## 19. Code comments/documentation

Comments explain:
- invariants;
- non-obvious reasoning;
- compatibility constraints;
- algorithmic tradeoffs;
- external/platform limitations.

Do not comment obvious syntax.

Every important subsystem should eventually have a source-adjacent README describing responsibility, key types, state flow, invariants, tests, performance concerns and extension points.

## 20. Definition of done for code

A mechanic is not done until appropriate gates pass:
- source exists;
- static/content validation passes;
- unit/domain tests pass;
- integration tests pass where relevant;
- build compiles;
- runtime verified when visual/input/platform-dependent;
- performance checked when meaningful;
- documentation updated;
- saved state/readback verified.

## 21. Anti-monolith rule

Never allow one scene/controller/view-model/script to own world simulation, combat, saves, UI, audio, behavior, effects, admin and content loading.

Split at domain boundaries before responsibilities accumulate.

## 22. Engine adaptation

Once engine is selected, translate this guide into concrete folders/classes/scenes/API conventions. Ownership laws remain unless evidence proves a better structure.