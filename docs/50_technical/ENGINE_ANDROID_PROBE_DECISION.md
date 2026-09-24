# Engine / Android Probe Decision

Status: STAGE 1 AUTHORIZED / ENGINE CANDIDATE SELECTED FOR PROBE / FINAL ENGINE NOT YET VERIFIED
Last reconciled: 2026-09-02

## Decision summary

The previous implementation hold is lifted.

Implementation is now authorized under the existing EVOLVE / bounded-piece development discipline.

This does **not** authorize skipping verification gates or immediately building the entire vertical slice. The first implementation stage is the engine + Android phone probe from `IMPLEMENTATION_ROADMAP.md`.

Selected probe candidate:
- Engine: **Godot 4.7**;
- Language: **GDScript**;
- Renderer: **GL Compatibility**;
- Primary target platform: **Android**;
- Baseline physical phone: **Samsung Galaxy A03s**.

Final production engine status remains `PROBE_PENDING`. Godot becomes the selected production engine only after the phone probe passes its required gates.

---

# 1. Why Godot 4.7 for the probe

The game needs:
- stylized 3D hunter/monster presentation;
- elevated aerial exploration camera;
- first-person camera transition;
- touch UI/input;
- animation/skeleton support;
- scene streaming/content loading;
- Android export;
- data-driven gameplay/domain code;
- rapid prototype iteration;
- low-cost/free development tooling.

Godot provides these directly and allows the first probe to test the actual risky combination rather than building a custom 3D stack first.

GDScript is selected for the probe because iteration speed and project readability matter more than premature low-level optimization. Performance-critical architecture must still avoid per-frame waste; a language choice does not excuse unbounded simulation.

---

# 2. Renderer decision

Selected probe renderer:
**GL Compatibility**.

Reason:
- the baseline device is intentionally low-end;
- the game targets Android scalability;
- Compatibility is the conservative renderer for older/lower-end mobile hardware;
- the project already prioritizes stylized readability over advanced desktop-only rendering features.

Do not assume Forward+ or Mobile renderer features in game design until separate evidence justifies them.

The probe must specifically test whether Compatibility can support the visual requirements that matter:
- one large animated monster;
- hunter placeholder;
- directional lighting;
- restrained shadows;
- billboard/impostor vegetation;
- transparency/foliage;
- simple VFX;
- aerial and first-person camera views;
- readable materials;
- UI overlay.

If a required visual feature cannot be delivered acceptably in Compatibility, record the exact failure before considering another renderer/engine.

---

# 3. Baseline phone

Selected baseline device:
**Samsung Galaxy A03s**.

Known hardware target characteristics from Samsung's published specification:
- 6.5-inch HD LCD;
- 720 × 1600 display;
- 60 Hz display;
- MediaTek Helio P35;
- 8 CPU cores: 4 × 2.3 GHz + 4 × 1.8 GHz;
- 3 GB RAM on the referenced baseline configuration;
- 32 GB storage on the referenced baseline configuration.

This is deliberately a hard baseline. If the first slice can remain stable and readable here, higher-capability Android devices have more headroom.

Do not infer final minimum supported Android version from this device alone; that is a later release-support decision.

---

# 4. Performance target for the probe

Selected baseline runtime target on Galaxy A03s:
**stable 30 FPS minimum target for the representative probe scene.**

Frame budget:
~33.3 ms.

60 FPS remains desirable on stronger devices and may be tested on the A03s, but the project should prefer a stable responsive 30 FPS over unstable frame pacing.

The probe must measure rather than assume:
- frame time / frame pacing;
- memory use and peak transition memory;
- input latency/feel;
- scene-transition hitching;
- cold launch;
- thermal degradation over a sustained test;
- suspend/resume;
- crash/ANR behavior.

---

# 5. Resolution test policy

The physical display is 720 × 1600, landscape equivalent 1600 × 720.

Do not lock internal 3D render scale before profiling.

Probe order:
1. test intended landscape presentation at device resolution/default scale;
2. record frame time/memory;
3. if GPU-bound, test controlled internal render-scale reductions while keeping UI crisp;
4. compare visual readability at each tested scale;
5. only then choose a baseline render scale/quality preset.

Candidate test scales may include 1.00, ~0.85 and ~0.75, but none is final until measured.

UI should remain rendered/readable independently where the engine permits appropriate scaling.

---

# 6. Stage 1 probe scope

Implement only enough to test platform risk:

1. boot/title screen;
2. landscape orientation;
3. tiny stylized forest/diorama test area;
4. elevated 40–50° aerial camera;
5. 1.75 m hunter placeholder/blockout;
6. one large animated monster placeholder approximating first-slice scale;
7. touch movement/input;
8. billboard/impostor foliage experiment;
9. limited directional shadow experiment;
10. aerial → first-person camera transition;
11. first-person monster framing;
12. combat HUD mock only — no real combat domain yet;
13. basic audio/music playback;
14. suspend/resume;
15. instrumentation/performance overlay;
16. install/update test on Galaxy A03s.

Explicitly out of scope for this first probe:
- full combat system;
- harvesting;
- crafting;
- full settlement;
- Region 01 production map;
- final Hunter model;
- final Mudcrest Raker model;
- progression implementation;
- final save system;
- creator suite.

---

# 7. Probe quality presets

The first probe should expose simple development toggles/presets rather than one hard-coded visual configuration.

At minimum compare:
- shadows ON/OFF;
- vegetation high/reduced;
- particles/VFX ON/reduced/OFF;
- render scale candidates;
- high-detail monster presentation vs reduced-distance detail.

This provides evidence about which subsystem causes frame-time or memory problems.

Do not optimize blindly.

---

# 8. Engine acceptance gate

Godot 4.7 + GL Compatibility passes Stage 1 only when the Galaxy A03s can demonstrate, in a representative bounded scene:
- reliable install and cold launch;
- stable landscape input/UI;
- aerial exploration camera behaves correctly;
- hunter movement is responsive;
- monster animation is readable;
- aerial → first-person transition works without state/camera corruption;
- first-person monster scale is viable;
- basic audio works;
- suspend/resume does not corrupt the session;
- no repeatable crash/ANR in the test loop;
- representative scene can hold the selected 30 FPS baseline target or an explicitly documented acceptable evidence-based adjustment;
- memory/thermal behavior is understood enough to proceed.

If this gate fails, do not quietly continue into Stage 2. Record the failure and decide whether to reduce presentation cost, change renderer settings, test Godot Mobile renderer where hardware support permits, or evaluate LibGDX/native alternatives.

---

# 9. Why LibGDX/native are not the first probe

They remain fallback options, not rejected technologies.

For this project, starting with LibGDX/native would require more custom work for scene/animation/rendering/tooling before answering the immediate question: can the intended hybrid aerial/first-person presentation run acceptably on the baseline phone?

Godot lets the project answer that risk sooner.

If Godot fails for demonstrated engine/render/runtime reasons that cannot be fixed without compromising the game, then evaluate the lower-level alternatives with evidence.

---

# 10. Implementation authorization

User authorization received: **2026-09-02**.

New project gate state:
- `IMPLEMENTATION_AUTHORIZED = YES`;
- `STAGE_1_ENGINE_ANDROID_PROBE_AUTHORIZED = YES`;
- `ENGINE_PROBE_CANDIDATE = GODOT_4_7_GDSCRIPT_GL_COMPATIBILITY`;
- `FINAL_ENGINE_SELECTED = NO / PROBE_PENDING`;
- `TARGET_BASELINE_DEVICE = SAMSUNG_GALAXY_A03S`;
- `BASELINE_DEVICE_FRAME_TARGET = STABLE_30_FPS_PROBE_TARGET`;
- `GAMEPLAY_VERTICAL_SLICE_IMPLEMENTATION = BLOCKED UNTIL STAGE_1_GATE`.

Implementation must continue one bounded piece at a time under EVOLVE.

---

# 11. Exact next implementation piece

Create the smallest Godot 4.7 Android probe project skeleton only:
- project boots;
- Compatibility renderer selected;
- landscape orientation;
- one simple title/probe scene;
- one simple 3D test scene;
- basic touch/input plumbing;
- development performance readout;
- Android export configuration documentation.

Then verify desktop/editor behavior and prepare the first Galaxy A03s install test.

Do not add real combat in the same piece.
