> **CURRENT PIXEL RPG STATUS NOTE — 2026-09-25**
>
> This document mixes still-current product constraints with historical Stage-1 probe state. The hard player-required storage ceiling remains current: `2 GB = 2,000,000,000 bytes`.
>
> Stage-1 probe references, aerial/first-person transition assumptions, and old “current calibration” language are historical unless corroborated by current source/device evidence. Sustained FPS/heat, installed footprint, and current phone behavior still require real-device validation.

# Unnamed Hunt RPG — Performance Budgets and Caps

Status: PLANNING CONTRACT / 2 GB GAME STORAGE CAP SELECTED / STAGE 1 TELEMETRY PREPARED / SUSTAINED TARGET-DEVICE CALIBRATION PENDING
Last reconciled: 2026-09-14

## Purpose

Prevent the project from becoming slow, unstable or impossible to debug as content grows. These are guardrails, not final measured device limits. Every performance cap must eventually be confirmed or replaced by target-device evidence. The total shipped-game storage cap below is a user-selected hard product constraint and is not waiting on device calibration.

Primary rule:
**performance is a feature and a design constraint, not cleanup at the end.**

## Hard game-storage cap

`TOTAL_PLAYER_REQUIRED_GAME_STORAGE_CAP = 2 GB`
`TOTAL_PLAYER_REQUIRED_GAME_STORAGE_CAP_BYTES = 2000000000`
`TOTAL_GAME_STORAGE_CAP_SELECTED = YES`

The complete player-required installed/runtime game footprint must not exceed `2,000,000,000` bytes. Treat `2 GB` as the hard ceiling; do not reinterpret it as `2 GiB` to gain extra headroom.

The cap includes all files/assets/data that a player must have installed for the base game to function, including packaged runtime assets and any required split/downloaded runtime content. Splitting required content across APK/AAB asset packs or later mandatory downloads does not bypass the cap.

The cap excludes development-only source masters, repository history, CI artifacts, debug symbols and other files that are never shipped or required on the player's device.

The packaged Android build itself must remain below the same ceiling, but APK/AAB artifact size alone is not proof that the installed footprint is below the cap because compression and platform installation can change on-device size. A future release/storage gate must measure the complete player-required installed footprint. Current debug-artifact size is evidence of package size only.

This storage ceiling does not replace RAM, frame-time, streaming or target-device performance budgets. Runtime memory and sustained-performance limits remain separately evidence-driven.

## 1. Budget hierarchy

Protect in this order:
1. input responsiveness;
2. deterministic gameplay correctness;
3. body-part/monster readability;
4. combat telegraphs;
5. camera stability;
6. stable frame pacing;
7. world navigation/readability;
8. audio cues;
9. decorative effects/detail.

When overloaded, reduce decorative cost before gameplay-critical presentation.

## 2. Frame targets

Initial target candidates:
- preferred: stable 60 FPS on capable target hardware;
- acceptable fallback: stable 30 FPS on older supported hardware;
- never prefer unstable 45–60 over a stable responsive 30.

Frame budgets:
- 60 FPS ≈ `16.7 ms`;
- 30 FPS ≈ `33.3 ms`.

Stage-1 Galaxy A03s representative minimum remains stable `30 FPS`.

Final production targets and platform quality tiers remain unselected until the engine/device gate is complete.

## 3. Runtime caps philosophy

Every scalable subsystem must eventually have a cap/budget, including:
- active high-detail monsters;
- visible distant creatures/NPCs;
- behavior-pattern evaluations;
- derived-stat recalculations;
- status/effect processing;
- particles;
- decals/wounds;
- dynamic lights/shadow casters;
- audio voices;
- loaded sectors;
- physics bodies;
- tactical cover nodes;
- UI overlays;
- event/debug-log size;
- save history/backups;
- telemetry buffers.

Caps prevent accidental unbounded growth.

## 4. Initial representative scene guidance

### Exploration
- one player high-detail presentation;
- approximately 1–3 nearby important monsters at relevant quality;
- distant population uses simplified update/presentation or culling;
- load current region sectors plus bounded adjacency/preload margin;
- real-time shadow casting limited to high-value nearby actors/lights;
- repeated vegetation/effects pooled where appropriate;
- avoid unnecessary unique materials per prop.

### Combat
- one primary large monster in the first slice;
- first-person player equipment;
- limited tactical environment;
- only combat-relevant cover/hazards active;
- bounded wounds/decals/severed visuals;
- no exploration-only distant population at full update/render rate.

These are planning constraints, not final measured counts.

## 5. Simulation/behavior tiers

TIER 0 — current combat decision points
- full required deterministic gameplay resolution;
- behavior evaluates when a decision is required, not every visual frame.

TIER 1 — nearby relevant roaming actors
- event-driven behavior plus bounded periodic checks.

TIER 2 — distant loaded actors
- low-frequency schedule/pattern advancement.

TIER 3 — unloaded/off-region actors
- coarse persistent-state transitions only when required.

Rendering and simulation tiers remain independent.

## 6. Deterministic behavior performance rules

- no generative/ML runtime behavior;
- pathfinding is event-driven/throttled rather than recalculated every frame for every actor;
- combat rules evaluate at explicit decision points;
- distant actors use reduced update frequency;
- pack/group systems require explicit member caps before implementation;
- debug traces use bounded buffers;
- authored complexity comes from more meaningful rules, not uncontrolled evaluation frequency.

Useful triggers include schedule/time changes, weather changes, awareness entry, damage, anatomy/capability changes, quest/event flags and action/cooldown completion.

## 7. Stats/effects rules

Authority:
`STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

Performance rules:
- derived stats are cached;
- equipment/status changes invalidate affected values only where practical;
- terrain/context calculations occur on movement/action validation rather than every visual frame;
- status periodic hooks run at defined timing points;
- duplicate stack groups are bounded;
- detailed calculation traces are development-only/bounded;
- distant/unloaded actors do not run full combat-context modifier evaluation.

Development instrumentation should eventually count derived-stat recalculations, effect evaluations, active statuses, modifier sources and behavior-rule checks.

## 8. Anatomy/tactical complexity guidance

First-slice anatomy target:
- approximately 6–8 meaningful targetable parts;
- additional simple harvest-only structures only when useful;
- avoid dozens of independently simulated micro-parts.

First-slice tactical-node starting range:
- approximately 6–12 useful nodes;
- only nodes that create meaningful positioning/cover/bearing/terrain decisions;
- no huge invisible tactical grid by default.

These are design starting ranges pending implementation/usability/performance evidence.

## 9. VFX / wounds / audio

VFX priorities:
- telegraph clarity;
- impact feedback;
- break/sever readability.

Use pooled emitters, bounded lifetime, cleanup, distance reduction and mobile-conscious transparency.

Damage visuals must preserve authoritative broken/severed state while bounded low-value cosmetic marks can be merged/reused/removed.

Audio priorities:
- active monster telegraphs;
- immediate player feedback;
- combat impacts;
- lower-priority distant ambience/wildlife culled by distance/priority.

## 10. Memory / loading / asset policy

- do not load every biome/monster asset at startup;
- load current region/encounter assets deliberately;
- unload heavy encounter presentation after use when appropriate;
- use compression/atlases/LOD/impostors where engine and visual evidence support them;
- monitor transition peak memory, not only steady-state memory;
- reusable materials/atlases before unnecessary unique texture/material proliferation;
- hero/first-person-visible monster detail gets more budget than distant scenery;
- source masters remain separate from runtime-optimized exports when practical.

Track cold boot, save load, hub→region, sector crossing, aerial→combat, combat→world/harvest and region→hub transitions. No transition should accidentally leave duplicate heavy scenes active.

## 11. Performance instrumentation

Production/development architecture should eventually expose where platform/engine permits:
- FPS/frame time;
- CPU/GPU/render metrics;
- memory;
- active/visible entity counts;
- behavior evaluation counts/tiers;
- statuses/modifier counts;
- derived-stat recalculation counts;
- particles;
- loaded sectors;
- quality tier;
- transition/hitch timing.

That long-term instrumentation belongs in the future Admin/Developer system.

### Current Stage-1 probe instrumentation

Stage-1 implements only the smallest probe-local measurement subset required to evaluate the Android candidate:
- engine FPS;
- rolling approximately one-second actual `_process(delta)` average/max frame duration;
- cumulative process frames above `34 ms`;
- cumulative process frames at/above `50 ms`;
- cumulative worst process-frame delta;
- debug static memory;
- renderer and view mode.

Telemetry source:
`probes/android_stage1/scripts/probe_world.gd`.

Executable telemetry test:
`ci/stage1/performance_telemetry_test.gd`.

Telemetry source commit:
`89394067971120df43b184a8509934f5458185f2`.

Deterministic regression result:
`20 / 20 PASS`.

The test verifies telemetry calculation/display and confirms telemetry does not mutate Hunter transform, camera/view state, Settings state or Look Speed. It does **not** prove phone performance.

## 12. Degradation ladder

When measured device evidence shows the target is not held, isolate one cost family at a time. General long-term degradation order:
1. decorative particles;
2. distant ambient creatures;
3. decorative prop density;
4. expensive transparency;
5. shadow distance/count/resolution;
6. distant LOD/texture detail;
7. environmental animation frequency;
8. noncritical distant simulation frequency;
9. post effects;
10. noncritical lighting.

For the current minimal Stage-1 probe, the practical cost-isolation sequence recorded in the phone protocol is:
1. directional shadows;
2. decorative vegetation when it exists;
3. particles/VFX when they exist;
4. internal render scale;
5. Monster/distance detail.

Do not first remove monster anatomy/readability, tactical readability, critical telegraphs, input responsiveness, or authoritative gameplay correctness.

## 13. Bug-isolation architecture

Development toggles should eventually allow disabling/isolation of particles, shadows, ambient wildlife, roaming updates, monster renderer, audio, foliage, damage decals, tactical presentation and other major cost domains.

This distinguishes domain, behavior, stats/effects, renderer, audio and content problems instead of treating every slowdown as one system.

## 14. Watchdog/invariant rules

Development checks should catch:
- entity-count runaway;
- duplicate monster IDs;
- unbounded event/log growth;
- invalid tactical occupancy;
- orphaned severed-part objects;
- repeated resource loading;
- save/write spam;
- behavior evaluating beyond policy;
- derived stats recalculating without inputs changing;
- unbounded statuses/modifiers;
- scene transitions leaving old heavy scenes active.

## 15. Performance gate per feature

A feature is not performance-cleared until:
- scalable counts are bounded;
- cleanup/unload behavior is defined;
- target-device impact is measured when executable;
- major costs can be isolated in development where practical;
- a representative/worst useful case is tested rather than only an empty scene.

## 16. Current Stage-1 calibration state

Earlier documentation saying no engine/device probe had executed is superseded.

Direct prior Galaxy A03s evidence exists for earlier Stage-1 APKs, including install/runtime smoke, GL Compatibility/OpenGL3 presentation, basic movement/view operation and one instantaneous `60 FPS / ~16.7 ms` with `40.9 MiB` debug-static-memory sample.

That instantaneous sample does **not** establish sustained performance, thermal stability, current-APK phone behavior or final production caps.

Current prepared phone authority:
`probes/android_stage1/docs/SUSTAINED_PERFORMANCE_EVIDENCE_PROTOCOL.md`.

Current protocol/documentation revision built by CI:
`c02971996e35770bbaaaf9bf6c460af208db4f83`.

Workflow:
`33811355891` — `SUCCESS`.

The prepared target-phone gate is one fixed `24` minute Galaxy A03s run with checkpoints at `T+02`, `T+07`, `T+09`, `T+14`, `T+19`, `T+24`. It records frame pacing, diagnostic hitch counters, worst frame, memory, battery, qualitative thermal signal, input response and transition-hitch observations.

The controlled transition segment performs exactly `20` aerial↔first-person transitions, followed later by a ten-minute sustained soak.

`STAGE1_PERFORMANCE_TELEMETRY_PREPARED = YES`
`STAGE1_PERFORMANCE_TELEMETRY_HEADLESS_VERIFIED = YES / 20_OF_20`
`STAGE1_SUSTAINED_PHONE_RUN_EXECUTED = NO / DEFERRED`
`PERFORMANCE_VERIFIED = NO`
`FINAL_PRODUCTION_CAPS_MEASURED = NO`
`TOTAL_GAME_STORAGE_CAP_SELECTED = YES / 2_GB`

Do not preemptively reduce shadows, render scale, camera behavior, controls, Monster readability or gameplay. If the phone gate reveals a failure, isolate and measure one cost family at a time before approving a change.
