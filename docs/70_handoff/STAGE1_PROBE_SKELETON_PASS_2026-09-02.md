# Stage 1 Godot / Android Probe Skeleton Pass — 2026-09-02

Status: SOURCE CREATED + STATIC READBACK COMPLETE / GODOT EXECUTION NOT YET PERFORMED

## Purpose

Record the first actual implementation piece after the user explicitly authorized implementation.

This pass does not claim that Godot parsed, ran, exported, installed or performed acceptably on the Galaxy A03s.

## Current implementation root

Probe-only root:
`probes/android_stage1/`

Quality rule:
**probe source is isolated from future production/domain source.**

If the engine/renderer path fails, Stage 1 can be replaced without contaminating the later domain architecture.

## Created source

- `probes/android_stage1/project.godot`
- `probes/android_stage1/scenes/boot.tscn`
- `probes/android_stage1/scenes/probe_world.tscn`
- `probes/android_stage1/scripts/boot.gd`
- `probes/android_stage1/scripts/probe_world.gd`
- `probes/android_stage1/README.md`
- `probes/android_stage1/.gitignore`
- `probes/android_stage1/docs/ANDROID_EXPORT_SETUP.md`
- `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md`

## Implemented probe behavior

Current source requests:
- Godot 4.7 project feature level;
- GL Compatibility renderer;
- GL Compatibility mobile override;
- landscape orientation;
- 1600 × 720 logical viewport target;
- Android frame pacing enabled.

Boot scene:
- project title/status;
- explicit transition to the 3D probe.

3D probe scene:
- simple ground/collision;
- one directional light with shadow enabled for cost testing;
- 1.75 m capsule Hunter placeholder;
- large Monster placeholder;
- aerial camera;
- first-person camera attached to Hunter placeholder;
- directional touch buttons;
- desktop WASD fallback for editor smoke test;
- camera-view toggle;
- simple procedural Monster movement;
- runtime renderer/driver display;
- FPS + approximate frame time display;
- debug static-memory display where available.

No gameplay-domain state, real combat, harvest, crafting, progression, final assets, final map, or save architecture was added.

## Static readback performed

Read back after writes:
- `project.godot`;
- `probe_world.gd`;
- `probe_world.tscn`.

Observed source paths/node references are internally aligned at text/readback level.

Current APIs/settings were cross-checked against current Godot documentation for:
- `gl_compatibility` renderer;
- runtime renderer/driver query;
- Android landscape orientation;
- Android frame pacing;
- Performance monitor access;
- Android export prerequisites.

This is not equivalent to engine parsing.

## Execution-environment limitation

The available execution environment used during this pass does not contain a Godot executable.

Therefore these gates remain unverified:
- GDScript parse;
- `.tscn` parse/import;
- actual project boot;
- actual runtime node paths/signals;
- desktop/editor behavior;
- Android export;
- APK install;
- phone runtime;
- performance.

Do not infer any of those from source creation.

## Android export direction

First probe should use the normal Godot Android export path rather than introducing custom Gradle work unless an actual requirement appears.

Probe-specific package identity is recommended so it cannot collide with the eventual production app.

Export credentials/keystores/local SDK paths must remain outside source control.

## Current verification state

`IMPLEMENTATION_AUTHORIZED = YES`
`STAGE_1_SOURCE_ROOT_CREATED = YES`
`PROJECT_GODOT_CREATED = YES`
`BOOT_SCENE_CREATED = YES`
`PROBE_3D_SCENE_CREATED = YES`
`TOUCH_INPUT_PLACEHOLDER_CREATED = YES`
`AERIAL_FIRST_PERSON_TOGGLE_CREATED = YES`
`PERFORMANCE_HUD_CREATED = YES`
`ANDROID_EXPORT_SETUP_DOCUMENTED = YES`
`PHONE_TEST_PROTOCOL_RECORDED = YES`
`SOURCE_READBACK_VERIFIED = YES`
`GODOT_PARSE_VERIFIED = NO`
`EDITOR_RUN_VERIFIED = NO`
`ANDROID_PRESET_CREATED = NO`
`APK_BUILD_VERIFIED = NO`
`GALAXY_A03S_INSTALL_VERIFIED = NO`
`PHONE_RUNTIME_VERIFIED = NO`
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`

## Exact next implementation piece

**Godot parse/editor smoke verification of the existing Stage 1 skeleton.**

Required next evidence:
1. open the project with Godot 4.7;
2. fix any project/scene/script parse errors;
3. run Boot;
4. enter ProbeWorld;
5. test WASD movement;
6. test aerial↔first-person toggle;
7. inspect runtime renderer string;
8. verify metrics HUD;
9. record all warnings/errors;
10. only after that create the Android export preset/build.

Do not add additional Stage 1 features until this existing skeleton parses/runs.

## Independent design lane

The next independent gameplay-design packet remains:
`Combat Resolution / Hit Quality and Defense Contract`.

That design work does not block the editor parse gate.
