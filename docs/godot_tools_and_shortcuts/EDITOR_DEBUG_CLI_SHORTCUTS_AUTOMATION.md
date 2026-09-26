# Godot 4.7 Editor, Debugger, CLI, Shortcuts and Automation

Official Godot 4.7 command line:
https://docs.godotengine.org/en/4.7/tutorials/editor/command_line_tutorial.html

Script editor:
https://docs.godotengine.org/en/4.7/tutorials/editor/script_editor.html

Feature list:
https://docs.godotengine.org/en/4.7/about/list_of_features.html

## 1. Critical shortcut-source note

On 2026-09-26, the expected version-pinned Godot 4.7 URL for the old Default editor shortcuts documentation page returned 404 during research.

Therefore:

THE LIVE GODOT 4.7 EDITOR IS THE AUTHORITATIVE SOURCE FOR EXACT KEY BINDINGS.

Open:
Editor -> Editor Settings -> Shortcuts

Do not tell a user an exact shortcut is guaranteed merely because an older Godot page lists it.

The 4.6 shortcut page can be useful as historical/reference context:
https://docs.godotengine.org/en/4.6/tutorials/editor/default_key_mapping.html

## 2. Script editor capabilities

Godot 4.7 built-in script editor supports:
- syntax highlighting;
- completion;
- code folding;
- multiple carets;
- find/replace;
- project-wide find/replace;
- symbol navigation;
- inline refactoring;
- debugger integration;
- script warnings/errors;
- built-in API help.

Verified documented examples:
- multiple caret: Alt + left click;
- inline rename/refactor: Ctrl + D on Windows/Linux per 4.7 script-editor documentation;
- zoom: Ctrl + mouse wheel on Windows/Linux;
- all shortcuts can be rebound in Editor Settings -> Shortcuts.

Always verify the live binding if it matters operationally.

## 3. Common editor run actions

Common Godot concepts include:
- run project;
- run current scene;
- stop;
- play custom scene.

F5/F6 are historically common defaults for run project/current scene, but exact current binding should be read from the live 4.7 editor settings before treating it as guaranteed.

## 4. Built-in editor help

Godot includes offline class-reference help in the editor.

Use it before guessing an API:
- search class name;
- inspect methods/properties/signals;
- inspect inheritance;
- inspect enum values;
- compare expected argument/return types.

This is especially useful when internet access is unavailable.

## 5. Remote scene tree / inspector

While the project is running, Godot can expose the remote scene tree and remote inspector.

Use it to verify:
- node actually exists;
- transform at runtime;
- camera current flag;
- visibility;
- material state;
- collision-related properties;
- runtime UI values.

Do not confuse editing Remote runtime values with editing the saved local scene.

## 6. Debugger

Built-in debugging includes:
- breakpoints;
- stack traces;
- variable inspection;
- errors;
- warnings;
- profiler;
- monitors.

Use debugger evidence before speculative code changes.

## 7. Profiler

Profile:
- script time;
- frame spikes;
- physics;
- rendering;
- memory/objects;
- custom Performance monitors.

Godot 4.7 command-line flags include:
--profiling
--gpu-profile
--print-fps

## 8. Visual debug tools

Godot 4.7 CLI includes:

    --debug-collisions
    --debug-paths
    --debug-navigation
    --debug-avoidance

These are especially useful for:
- invisible collision;
- navmesh mismatch;
- path-following failures;
- avoidance behavior.

## 9. Command-line foundation

General pattern:

    godot --path game [options]

Version:

    godot --version

Help:

    godot --help

Verbose:

    godot --verbose

Headless:

    godot --headless

Editor:

    godot --editor --path game

Specific scene:

    godot --path game res://scenes/example.tscn

## 10. Parse/import gate

Pixel RPG CI runs:

    godot --headless --verbose --editor --path game --quit

Purpose:
- initialize project;
- import resources;
- parse scripts/scenes;
- surface load/parse errors.

Project CI then scans logs for blocking patterns.

## 11. Run a GDScript as a tool/test

Godot 4.7 supports:

    godot --headless --path game --script /absolute/path/test.gd

Pixel RPG uses SceneTree-derived test scripts this way.

## 12. Parse-only script check

Godot 4.7 command line includes --check-only when used with --script.

Example:

    godot --headless --path game --script res://path/script.gd --check-only

Use this for focused script syntax checks, but still run project import/runtime tests for behavior.

## 13. Project smoke test

Pixel RPG CI launches the app shell headlessly with a timeout.

Concept:

    godot --headless --verbose --path game

Because a normal game does not quit automatically, CI wraps it with an external timeout.

## 14. Debug command line

Local stdout debugger:

    godot -d --path game

Remote debug:
--remote-debug URI

Debugger server:
--debug-server URI

GDScript DAP:
--dap-port PORT

GDScript LSP:
--lsp-port PORT

This makes external editor integration possible.

## 15. User command-line arguments

Godot separates engine args from user args with -- or ++.

User code can retrieve arguments through:
OS.get_cmdline_user_args()

Useful for:
- test modes;
- deterministic seeds;
- debug scenarios;
- automated screenshots;
- content validation commands.

Do not expose dangerous arbitrary file/system behavior based solely on untrusted command-line arguments.

## 16. Fixed-time/debug simulation tools

Godot 4.7 CLI includes:
- --max-fps;
- --fixed-fps;
- --time-scale;
- --frame-delay;
- --disable-vsync;
- --quit-after.

Use cases:
- reproduce timing bugs;
- test low frame rate;
- deterministic capture workflows;
- stress frame pacing.

Be careful:
fixed FPS changes runtime synchronization characteristics and should not be mistaken for normal gameplay conditions.

## 17. Movie capture

Godot CLI includes --write-movie.

Useful for deterministic capture/testing of scenes.

For automated visual evidence, document:
- exact commit;
- exact Godot version;
- scene;
- resolution;
- fixed FPS;
- relevant command arguments.

## 18. Export from CLI

Debug:

    godot --headless --path game --export-debug "Android Debug" output.apk

Release:

    godot --headless --path game --export-release "Preset Name" output.file

Pack only:

    godot --headless --path game --export-pack "Preset Name" output.pck

The preset must exist in export_presets.cfg.

## 19. Import-only command

Godot 4.7 supports:

    godot --path game --import

This starts the editor import process and exits.

Useful for CI cache/build preparation.

## 20. Recovery mode

Godot 4.7 CLI supports:

    godot --recovery-mode

It disables features that commonly cause editor-startup crashes such as tool scripts, editor plugins and GDExtensions.

Useful when a custom editor extension prevents normal startup.

## 21. API/documentation generation

Godot 4.7 command line includes advanced documentation/API dump tools:

--doctool
--no-docbase
--gdextension-docs
--gdscript-docs
--dump-gdextension-interface
--dump-gdextension-interface-json
--dump-extension-api
--dump-extension-api-with-docs
--validate-extension-api

These are highly valuable for a bot or developer that needs machine-readable API evidence.

Example concept for GDScript docs:

    godot --editor --path game --doctool OUTPUT_PATH --gdscript-docs res://scripts

Verify exact argument order with godot --help for the installed binary before scripting automation.

## 22. Benchmark tools

Godot 4.7 CLI includes:
--benchmark
--benchmark-file PATH

Use for repeatable engine-run timing evidence.

## 23. Engine internal unit tests

Godot CLI includes --test for engine builds compiled with tests=yes.

This is not the same as Pixel RPG's GDScript SceneTree test suite.

Do not claim Pixel RPG tests are Godot engine unit tests.

## 24. Editor live tools

Godot's feature set includes:
- live script reloading;
- live scene editing;
- remote inspector;
- optional game embedding;
- camera override/replication features;
- ruler tools;
- vertex snapping;
- multiple simultaneous project instances.

Use them as authoring/debug accelerators, not as substitutes for committed tests.

## 25. Git-friendly scene workflow

Godot .gd, .tscn, .tres and project.godot files are text-based and can be code-reviewed.

Before hand-editing a .tscn:
- understand ext_resource/sub_resource IDs;
- preserve syntax;
- avoid accidental NodePath breakage;
- run import/parse gate immediately afterward.

For complex scene changes, the editor can be safer.

## 26. Pixel RPG exact CI contract

Current workflow:
- triggers on main changes under game/tests/ci/probes/workflows;
- Godot 4.7.2;
- Python static preflights;
- Godot import/parse gate;
- app shell smoke;
- all game/tests/*_test.gd;
- Android APK export after verify passes;
- artifact evidence retained for seven days.

A documentation-only branch does not automatically prove gameplay tests pass unless the workflow actually runs against it.

## 27. High-value troubleshooting commands

Confirm version:

    godot --version

Parse/import:

    godot --headless --verbose --editor --path game --quit

Run one test:

    godot --headless --path game --script ABSOLUTE_TEST_PATH

Run scene with collision debug:

    godot --path game --debug-collisions res://scenes/example.tscn

Print FPS:

    godot --path game --print-fps

Check command availability:

    godot --help

## 28. Evidence rule

A command written in documentation is not evidence that it was executed.

When another bot reports:
TESTS_RUN
TEST_RESULTS

it must only list commands actually executed and outputs actually observed.
