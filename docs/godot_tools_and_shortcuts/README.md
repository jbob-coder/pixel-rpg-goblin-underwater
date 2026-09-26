# Godot Tools and Shortcuts — Pixel RPG Technical Reference

Status: ACTIVE REFERENCE BRANCH
Repository: jbob-coder/pixel-rpg-goblin-underwater
Branch: godot-tools-and-shortcuts
Reference baseline commit: 3eb07c3905e803e7ea7ab0eef9486c6a59c9be7b
Engine target: Godot 4.7.x
CI engine: Godot 4.7.2
Language currently used by the game: GDScript
Primary platform: Android
Primary rendering method: GL Compatibility

## Purpose

This directory is the durable Godot reference library for Pixel RPG. It exists so a developer or another AI agent can quickly determine:

- what Godot version this project actually uses;
- what Godot APIs and patterns are already used by the repository;
- what additional Godot systems are available from code;
- which editor, debugger, profiler, command-line, export and automation tools are available;
- how to find the authoritative Godot 4.7 documentation;
- which features are project-proven versus merely available in the engine;
- how to validate changes without guessing.

This branch is documentation-only unless the creator explicitly authorizes implementation. The presence of an API in this library does not mean the game currently uses it.

## Evidence labels

Every agent using this library should keep these meanings separate.

CONFIRMED_PROJECT_USE
The repository contains code/configuration that uses the feature.

CONFIRMED_PROJECT_TOOLING
The repository or CI configuration uses the tool or command.

GODOT_4_7_AVAILABLE
Godot 4.7 documentation exposes the feature, but it is not necessarily used by Pixel RPG.

PROPOSED_PATTERN
A recommended pattern for future work. It must not be represented as implemented.

UNKNOWN
Not yet verified from repository state or Godot 4.7 documentation.

## Read order for another bot

1. README.md
2. PROJECT_PROFILE_AND_CODE_MAP.md
3. AI_AGENT_GODOT_OPERATING_RULES.md
4. GDSCRIPT_CODE_REFERENCE.md
5. SCENES_NODES_RESOURCES_SIGNALS.md
6. INPUT_CAMERA_PHYSICS_3D.md
7. RENDERING_PERFORMANCE_WORLD.md
8. ANIMATION_NAVIGATION_UI_AUDIO.md
9. DATA_IO_LOADING_THREADS_NETWORKING.md
10. EDITOR_DEBUG_CLI_SHORTCUTS_AUTOMATION.md
11. ANDROID_EXPORT_MOBILE.md
12. EDITOR_EXTENSIONS_GDEXTENSION.md
13. OFFICIAL_GODOT_4_7_REFERENCE_INDEX.md
14. godot_capability_index.json

## Project-specific source of truth

For implementation questions, authority order is:

1. current branch files and current commit;
2. game/project.godot;
3. game/export_presets.cfg;
4. current scenes and scripts;
5. current tests;
6. current CI workflow;
7. this reference library;
8. official Godot 4.7 documentation;
9. older or newer Godot documentation only when explicitly labeled as non-authoritative background.

Never mix Godot 3.x syntax with this project. Do not use an API from latest/unstable documentation unless it is independently verified as present in Godot 4.7.

## Main official documentation

Godot 4.7 documentation:
https://docs.godotengine.org/en/4.7/

Godot 4.7 class reference:
https://docs.godotengine.org/en/4.7/classes/

Godot 4.7 scripting:
https://docs.godotengine.org/en/4.7/tutorials/scripting/index.html

Godot 4.7 command line:
https://docs.godotengine.org/en/4.7/tutorials/editor/command_line_tutorial.html

Godot 4.7 Android export:
https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html

## Important scope rule

Godot exposes thousands of classes, properties, methods and signals. Duplicating the entire class reference into this repository would become stale and would be inferior to the version-pinned official class reference. Therefore this library records:

- the major engine systems;
- the APIs most relevant to this game;
- code patterns and failure modes;
- debugging and automation tools;
- high-value class names to search;
- official version-pinned reference locations.

When an exact property, method signature or enum value matters, open the Godot 4.7 class reference before modifying code.

## Current project snapshot

The game is configured for Godot 4.7 and GL Compatibility. CI installs Godot 4.7.2. The current game contains GDScript gameplay systems, first-person camera and touch-control code, runtime world construction, settlement graybox code, Android export configuration and a large collection of executable SceneTree test scripts.

No claim in this library supersedes live repository code.
