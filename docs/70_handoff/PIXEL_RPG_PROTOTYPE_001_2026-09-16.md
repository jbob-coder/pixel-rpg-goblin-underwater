# Pixel RPG — Prototype 001 Handoff — 2026-09-16

Status: IMPLEMENTED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED / PHONE + VISUAL + PERFORMANCE ACCEPTANCE OPEN
Branch: `pixel-rpg`

## Objective completed

`PIXEL_RPG_THIRD_PERSON_VISUAL_PROTOTYPE_001`

The first bounded third-person Pixel RPG slice now exists in the live `game/` project and has passed the dedicated Android verification workflow.

## Verified source

`8d0c21018c396ec1943d0930a867273e4753ba6c`

Workflow: `35062091768` — SUCCESS.
Job: `104684371733` — SUCCESS.

Artifacts:
- `PixelRPG-prototype-001-debug` — ID `10432014296`;
- `PixelRPG-prototype-001-build-evidence` — ID `10433105552`.

## Implemented files

- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`;
- `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`;
- `game/scripts/app_shell.gd`;
- `game/project.godot`;
- `game/export_presets.cfg`;
- `.github/workflows/pixel-rpg-prototype-android.yml`.

## Implemented slice

The prototype currently provides:
- a visible third-person hunter;
- camera-relative movement;
- mobile left-stick direct movement;
- independent right-side touch camera look;
- desktop WASD/right-mouse fallback for development;
- compact settlement street and north gate;
- short physical trail outside settlement;
- one Gate Warden NPC interaction;
- one distant monster proxy with observation interaction;
- Diamond Watch prototype panel;
- objective/journal feedback;
- Android Pixel RPG project/export naming.

The current world/building/monster geometry is deliberately prototype-level and is not final visual art.

## Verification evidence

Workflow `35062091768` passed:
- checkout of exact tested source;
- Python/JDK/Android SDK setup;
- Godot 4.7.2 + templates;
- Godot import/parse gate;
- Pixel RPG AppShell smoke;
- Pixel RPG prototype scene smoke;
- selected existing deterministic combat-domain regressions;
- Android debug APK export;
- package-size ceiling check against exactly `2,000,000,000` bytes;
- APK artifact upload;
- build-evidence upload.

The first workflow attempt failed before game testing because the Android setup action received an invalid default package string. The workflow was corrected to request `platform-tools` explicitly. The successful run above is authoritative.

## Domain regression preservation

The successful workflow retained checks for existing monster-hunting foundations including:
- combat turn shell;
- Hunter attack runtime;
- Mudcrest anatomy runtime;
- generic status application;
- generic status timing.

This is intended to stop the visual/presentation pivot from silently destroying reusable deterministic gameplay logic.

## Verification boundary

Confirmed:
- IMPLEMENTED = YES;
- GODOT_IMPORT_PARSE_VERIFIED = YES;
- APPSHELL_HEADLESS_SMOKE_VERIFIED = YES;
- PROTOTYPE_HEADLESS_SMOKE_VERIFIED = YES;
- SELECTED_DOMAIN_REGRESSIONS_VERIFIED = YES;
- ANDROID_BUILD_VERIFIED = YES;
- PACKAGE_2GB_CEILING_GATE_PASSED = YES.

Not yet confirmed:
- PHONE_RUNTIME_VERIFIED = NO;
- VISUAL_QUALITY_VERIFIED = NO;
- SUSTAINED_PERFORMANCE_VERIFIED = NO;
- INSTALLED_FOOTPRINT_2GB_CAP_VERIFIED = NO.

Do not infer the latter from CI/build success.

## Shooter branch separation

The standalone first-person Shooter RPG remains rejected and non-authoritative for Pixel RPG.

The connected GitHub tool cannot delete branch refs. Therefore `shooter-rpg` is not truthfully marked deleted. The following non-authoritative helper refs were also accidentally created during attempted cleanup and should be removed through GitHub UI/CLI:
- `pixel-rpg-temp-guard`;
- `pixel-rpg-authority`;
- `pixel-rpg-working`;
- `pixel-rpg-docs`;
- `pixel-rpg-notes`;
- `pixel-rpg-final`.

Only `pixel-rpg` is active.

## Exact next bounded piece

`PIXEL_RPG_PROTOTYPE_001_PIXEL_RENDER_CAMERA_UI_POLISH`

Required scope:
1. introduce an intentional pixel render/upscale treatment;
2. improve camera collision/occlusion near settlement structures;
3. convert brittle fixed-offset HUD placement toward anchored/safe-area responsive layout;
4. preserve current movement/look semantics;
5. preserve NPC and monster-proxy interactions;
6. preserve deterministic combat-domain regression tests;
7. rerun Godot parse, smokes, Android export and package ceiling;
8. keep phone/visual/performance acceptance open until actual device evidence.
