# AI Agent Operating Rules for Godot Work in Pixel RPG

Purpose:
Prevent another AI or developer from mixing engine versions, inventing repository state, changing the wrong owner or claiming unexecuted tests.

## 1. Start from live repository state

Before a repository-specific Godot change:

1. identify repository;
2. identify target branch;
3. fetch current HEAD;
4. read game/project.godot;
5. inspect relevant scene;
6. inspect attached/related scripts;
7. inspect tests;
8. inspect CI when tooling/export behavior matters.

Do not use an old chat summary as stronger authority than current files.

## 2. Version lock

Current reference baseline:
Godot 4.7.x
CI:
Godot 4.7.2

If project.godot or CI later changes, update this documentation.

Never use Godot 3.x APIs in this project.
Never assume latest/unstable Godot documentation applies.
Prefer URLs under:
https://docs.godotengine.org/en/4.7/

## 3. Separate four evidence states

When discussing a Godot feature, state one of:

CONFIRMED_PROJECT_USE
Found in current code/config.

CONFIRMED_PROJECT_TOOLING
Found in CI/export/dev configuration.

GODOT_4_7_AVAILABLE
Verified in official 4.7 docs/class reference, but not present in current project.

PROPOSED
Recommended design not yet implemented.

Do not blur these categories.

## 4. Architecture before patch

For a requested behavior, determine:

- durable state owner;
- runtime controller owner;
- presentation owner;
- input owner;
- collision/physics owner;
- save owner;
- tests that prove behavior.

Do not patch the first script containing a similar word.

## 5. Scene ownership

Before changing a NodePath:
- inspect the .tscn;
- confirm root type;
- confirm path;
- check whether tests use the same path;
- search scripts for references.

A scene rename is an API change when code/tests depend on the path.

## 6. State versus presentation

Presentation may:
- display state;
- interpolate;
- animate;
- render effects;
- collect input intent.

Presentation should not silently become authoritative durable state.

For Pixel RPG, preserve explicit state/domain ownership when it exists.

## 7. Pure math extraction

When behavior can be expressed as deterministic math:
- use a small RefCounted/static utility where consistent with local architecture;
- test it separately;
- keep Node mutation in a controller/owner.

Current camera and player-motion code demonstrates this pattern.

## 8. Stable IDs

Use stable machine IDs for persistent references.

Do not use display names as durable save identity.

When changing an existing stable ID:
- find all references;
- define migration;
- update tests;
- update save/content contracts.

## 9. Input

Do not break mobile input while fixing desktop input or vice versa.

For first-person control:
- preserve joystick/look touch ownership;
- preserve UI exclusion;
- preserve focus/pause reset;
- preserve camera-relative movement;
- preserve pitch clamp.

## 10. Physics

Physics-affecting movement belongs in _physics_process unless there is a documented reason otherwise.

Do not directly manipulate RigidBody3D every frame as though it were CharacterBody3D without understanding physics ownership.

Use primitive/convex collision for moving bodies where possible.

## 11. Thread safety

Never mutate the active SceneTree from a worker thread.

Read:
https://docs.godotengine.org/en/4.7/tutorials/performance/thread_safe_apis.html

If background work is needed:
worker computes/prepares
-> main thread applies tree mutation.

## 12. Loading

Do not introduce synchronous large resource loading into an active gameplay frame.

Use ResourceLoader background loading when measured content size warrants it.

Do not use FileAccess to locate imported resources after export.

## 13. Rendering

Project renderer is GL Compatibility.

Before using:
- shader feature;
- GPU-only effect;
- compute;
- advanced material option;

verify Godot 4.7 GL Compatibility support.

## 14. Performance

Do not optimize by folklore.

Measure:
- frame time;
- profiler;
- draw calls;
- node/object count;
- memory;
- device behavior.

Use:
- MultiMesh;
- HLOD/visibility ranges;
- streaming;
- simpler collision;
- reduced shadows;
only when they match the bottleneck and content.

## 15. Android

For Android changes:
- keep package identity in mind;
- preserve safe-area layout;
- test app pause/resume/focus;
- test touch cancellation;
- verify permissions;
- run APK integrity checks;
- record APK SHA-256;
- record exact source commit.

## 16. Editor plugins/tool scripts

Do not add @tool code casually.
Editor-time code can mutate assets/scenes.

If a plugin/tool is needed:
- isolate under addons;
- provide cleanup;
- integrate undo where applicable;
- document recovery mode;
- test editor startup.

## 17. GDExtension

Do not introduce native code for ordinary gameplay unless:
- required external native integration exists; or
- profiling proves GDScript/normal server APIs cannot meet requirements.

Native extensions materially increase maintenance cost and Android build complexity.

## 18. Test workflow

Minimum after a GDScript/scene change where available:

Parse/import:

    godot --headless --verbose --editor --path game --quit

Focused test:

    godot --headless --path game --script ABSOLUTE_RELEVANT_TEST.gd

Broader regression:
run all game/tests/*_test.gd when practical.

Android-impacting change:
build/debug APK and inspect export log/integrity.

Never state tests passed if they were not actually run.

## 19. Test creation

Behavior change should normally add/update a test.

Good test levels:

Pure logic:
RefCounted/static helpers.

Scene contract:
instantiate PackedScene and assert required nodes/properties.

Runtime:
add scene to SceneTree, await frame/physics frame, inspect outcome.

Device-only:
touch feel, frame pacing, rendering artifacts, Android lifecycle.

A headless test cannot prove tactile camera feel on a physical phone.

## 20. Failure triage

When a test fails:

1. capture exact failure/log;
2. identify first causal error, not cascading symptoms;
3. inspect relevant file/current HEAD;
4. reproduce focused;
5. make smallest safe patch;
6. rerun focused;
7. rerun regressions;
8. review diff.

## 21. Documentation lookup strategy

For an exact Godot API:

1. installed Godot 4.7 editor class help;
2. official Godot 4.7 class reference;
3. official Godot 4.7 tutorial;
4. Godot source only when internals matter;
5. community examples only as secondary evidence.

Avoid copying older tutorial syntax without checking 4.7.

## 22. Machine-readable API discovery

Godot 4.7 CLI can dump engine API/GDExtension interface and generate GDScript docs.

Useful commands are catalogued in:
EDITOR_DEBUG_CLI_SHORTCUTS_AUTOMATION.md

For a future automated agent, generated 4.7.2 API data can be a stronger exact source than a language model's remembered API.

## 23. Branch discipline

This branch is a reference branch.

Do not merge speculative runtime implementations into it unless the creator changes the branch purpose.

If implementation begins elsewhere:
reference this branch for Godot capability knowledge
but read the implementation branch itself for current code truth.

## 24. Completion report

For consequential repository work, report:

CURRENT_OBJECTIVE
VERIFIED_STATE
COMPLETED
NEXT_ACTION
BLOCKERS
ASSUMPTIONS
UNKNOWNS
FILES_CHANGED
TESTS_RUN
TEST_RESULTS
REPOSITORY_HEAD

Do not fabricate empty certainty.

## 25. Prime rule

The correct Godot feature is not necessarily the best project change.

Choose the smallest feature set that:
- solves the actual gameplay/tooling problem;
- fits current architecture;
- is valid for Godot 4.7;
- is maintainable;
- is testable;
- performs on target Android hardware;
- preserves future migration paths.
