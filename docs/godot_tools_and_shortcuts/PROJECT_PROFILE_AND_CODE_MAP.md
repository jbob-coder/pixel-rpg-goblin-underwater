# Pixel RPG — Godot Project Profile and Code Map

## Verified baseline

Repository:
jbob-coder/pixel-rpg-goblin-underwater

Reference branch:
godot-tools-and-shortcuts

Branch creation baseline:
3eb07c3905e803e7ea7ab0eef9486c6a59c9be7b

Baseline commit message:
feat: add Settlement 01 G06 isolated work support

## Engine configuration

game/project.godot confirms:

- config_version = 5
- application name = Pixel RPG
- main scene = res://scenes/app_shell.tscn
- feature tag = 4.7
- renderer = GL Compatibility
- mobile renderer = GL Compatibility
- web renderer = GL Compatibility
- viewport = 1600 x 720
- window override = 1600 x 720
- stretch mode = canvas_items
- Android frame pacing = enabled
- ETC2/ASTC texture import = enabled
- nearest mipmap default filter = disabled
- gravity magnitude = 9.8
- gravity direction = Vector3(0, -1, 0)

The CI workflow installs Godot 4.7.2. For this repository, 4.7.2 is the strongest verified runtime/tooling target until the repository changes.

## Android export configuration

game/export_presets.cfg currently contains one runnable preset named:

Android Debug

Verified options include:

- platform = Android
- Gradle build = disabled
- armeabi-v7a = enabled
- arm64-v8a = enabled
- x86 = disabled
- x86_64 = disabled
- package name = Pixel RPG
- package identifier = org.unnamedhuntrpg.game
- debug signing = enabled
- current preset version code = 19
- current preset version name = 0.19-visual-pack-011-direct-photo-assets

The CI workflow overrides the output path and produces:
game/build/android/PixelRPG-debug.apk

Do not infer release signing from this setup. It is explicitly a debug export path.

## Main scene flow

game/scenes/app_shell.tscn
-> game/scripts/app_shell.gd
-> deferred scene change
-> res://scenes/prototypes/pixel_rpg_prototype_001.tscn

app_shell.gd uses:

- Node
- _ready
- call_deferred
- SceneTree.change_scene_to_file
- Error / OK
- error_string
- push_error

This is a useful minimal example of Godot scene switching and deferred initialization.

## Current first-person presentation architecture

Key code:

- scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd
- scripts/presentation/pixel_rpg/first_person_camera_math_001.gd
- scripts/presentation/pixel_rpg/first_person_camera_state_001.gd
- scripts/presentation/pixel_rpg/player_motion_math_001.gd
- scripts/presentation/pixel_rpg/player_motor_001.gd
- scripts/presentation/pixel_rpg/touch_input_math_001.gd
- scripts/presentation/pixel_rpg/touch_input_state_001.gd
- scripts/presentation/pixel_rpg/hud_layout_001.gd
- scripts/presentation/pixel_rpg/minimap_math_001.gd

Confirmed patterns:

- presentation host extends Node;
- reusable math/state components use class_name and RefCounted;
- utility dependencies are preloaded;
- node references use typed @onready variables;
- CharacterBody3D is the movement body;
- movement uses velocity plus move_and_slide;
- gravity is applied in _physics_process;
- rendering/UI updates are split into _process where appropriate;
- camera yaw and pitch are separated on Node3D pivots;
- first-person camera is a direct child of the pitch pivot;
- touch input uses InputEventScreenTouch and InputEventScreenDrag;
- desktop fallback reads keyboard and right mouse motion;
- touch ownership is stateful so joystick and look touches do not steal each other;
- safe-area calculations use DisplayServer;
- transient touch state is reset on pause/resume/focus notifications;
- contextual interaction is distance-based in the current prototype;
- runtime-created world objects are added as nodes with explicit types.

## Example project-proven utility pattern

    class_name PixelRPGExampleMath
    extends RefCounted

    const SCHEMA := "pixel_rpg.example.v1"

    static func get_schema() -> String:
        return SCHEMA

    static func calculate(value: float) -> float:
        return maxf(value, 0.0)

Why this pattern is useful:

- no scene node is required;
- deterministic logic is easy to test;
- class_name exposes a global GDScript type;
- static functions prevent unnecessary instance state;
- a schema string gives the project a stable compatibility identifier.

## Example project-proven state-owner pattern

    class_name PixelRPGExampleState
    extends RefCounted

    var _value := 0.0

    func set_value(value: float) -> void:
        _value = value

    func get_value() -> float:
        return _value

The camera state code uses this separation so mutation and pure math are not trapped inside a large scene controller.

## World and settlement implementation files

Current settlement/world code includes:

- settlement_01_layout_contract.gd
- settlement_01_graybox_base.gd
- settlement_01_plaza_graybox.gd
- settlement_01_smith_graybox.gd
- settlement_01_community_hall_graybox.gd
- settlement_01_residential_graybox.gd
- settlement_01_work_support_graybox.gd
- settlement_area_definition.gd
- settlement_section_definition.gd
- settlement_section_instance.gd

The definition code uses Dictionaries, typed Arrays, duplicate/duplicate(true), validation methods and stable IDs. This is a useful current pattern for data-first settlement layout contracts.

## Gameplay domain scripts

The repository currently contains dedicated scripts for:

- combat turn shell;
- encounter outcomes;
- hunter attacks;
- defense consequences;
- health/injury;
- reaction windows;
- status application;
- status timing;
- tactical movement;
- encounter triggers;
- monster anatomy;
- monster attacks;
- wound/contact handling;
- tracking.

These must be inspected individually before changing combat behavior. The existence of the files does not prove every path is integrated into the active prototype.

## Scene and asset patterns

Current scenes include:

- app shell;
- Pixel RPG prototype;
- Region 01 Hunt 01 graybox;
- first-person viewmodel;
- hunter visual;
- gate warden visual;
- monster visuals;
- effects;
- modular environment props.

The repository uses text .tscn resources, which are version-control friendly and can be inspected without opening the editor.

## Current testing model

Many tests extend SceneTree directly and run through Godot with --script.

Typical structure:

    extends SceneTree

    var failures: Array[String] = []

    func _init() -> void:
        call_deferred("_run")

    func _run() -> void:
        # instantiate, inspect, await frames, validate
        quit(0 if failures.is_empty() else 1)

This is not Godot's engine-internal unit test framework. It is a project-defined runtime verification style using executable GDScript.

## Current CI verification commands

The repository CI currently runs:

Import/parse gate:

    godot --headless --verbose --editor --path game --quit

App-shell smoke:

    godot --headless --verbose --path game

Each project GDScript test:

    godot --headless --path game --script ABSOLUTE_PATH_TO_TEST.gd

Android debug export:

    godot --headless --verbose --path game --export-debug "Android Debug" ABSOLUTE_OUTPUT.apk

The workflow also checks APK integrity with unzip, records SHA-256 and records artifact byte size.

## CI engine/tool versions

Verified from the workflow:

- Godot 4.7.2
- Python 3.12 for static preflights
- JDK 17
- Android build-tools 35.0.1
- Android platform 35

Official Godot 4.7 Android documentation currently lists the same Android build-tools 35.0.1 and platform 35 family for setup, making the repository configuration consistent with the version-pinned documentation.

## Code-reading rule

Before changing any subsystem, search the actual repository for:

- the scene that owns the node;
- the script attached to it;
- helper classes preloaded by that script;
- tests covering the same behavior;
- stable IDs/schema strings;
- CI or export expectations.

Do not substitute this reference document for that inspection.
