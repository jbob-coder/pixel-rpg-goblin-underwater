# Godot 4.7 Editor Extensions, Tool Scripts, Plugins and GDExtension

Official editor plugin index:
https://docs.godotengine.org/en/4.7/tutorials/plugins/editor/

Making plugins:
https://docs.godotengine.org/en/4.7/tutorials/plugins/editor/making_plugins.html

Class reference:
https://docs.godotengine.org/en/4.7/classes/

## 1. Tool scripts

Basic:

    @tool
    extends Node3D

@tool executes the script in the editor.

Uses:
- procedural authoring;
- validation;
- previews;
- editor-time generation;
- custom Inspector behavior through exported properties.

Risks:
- code executes while editing;
- setters may run more often than expected;
- destructive filesystem/scene edits can damage authoring state;
- editor state and game runtime state are different contexts.

Rule:
Tool scripts must be small, deterministic and reversible where possible.

## 2. EditorScript

EditorScript can run editor automation.

Potential uses:
- one-off migration;
- content batch conversion;
- scene validation/fixing;
- asset metadata generation.

For repeatable team workflows, a proper EditorPlugin or command-line validation script is generally easier to version and discover than an undocumented one-off script.

## 3. EditorPlugin

EditorPlugin can extend the editor.

Plugin script requirements include:
- @tool;
- extends EditorPlugin.

Lifecycle:
- _enter_tree for registration/setup;
- _exit_tree for cleanup/unregistration.

Possible capabilities:
- docks;
- menu items;
- bottom panels;
- custom main screens;
- inspector plugins;
- import plugins;
- 3D gizmos;
- autoload registration;
- custom types.

## 4. plugin.cfg

Editor plugins use plugin.cfg metadata.

Typical structure concept:

    [plugin]
    name="Pixel RPG Tools"
    description="Project-specific authoring utilities"
    author="Project"
    version="1.0"
    script="plugin.gd"

Keep plugins under addons/<plugin_name>/.

## 5. Inspector plugins

EditorInspectorPlugin can customize how properties/classes appear in Inspector.

Use cases:
- stable-ID picker;
- custom validation UI;
- world section editor;
- domain resource visualization.

Avoid hiding important serialized data behind a custom editor without a readable source format.

## 6. 3D gizmo plugins

EditorNode3DGizmoPlugin can add project-specific 3D handles/visualization.

Strong Pixel RPG future uses:
- settlement section bounds;
- spawn anchors;
- interaction radius;
- streaming radius;
- combat reach/hit volumes;
- navigation connectors.

This can make data-first world design far easier to inspect than raw coordinates.

## 7. Import plugins

EditorImportPlugin can add custom import formats.

Use only if the project has a real custom source format that should become a first-class Godot Resource.

Do not build a custom importer when normal JSON/CSV/resource loading already solves the problem cleanly.

## 8. Custom Resource types

Many authoring needs do not require EditorPlugin.

A custom Resource with @export fields may already provide a usable Inspector:

    class_name SettlementDefinition
    extends Resource

    @export var stable_id := ""
    @export var display_name := ""
    @export var scene: PackedScene

This is simpler and should be considered before custom plugin UI.

## 9. EditorInterface

EditorInterface gives plugins access to editor facilities such as selection, inspector and edited scenes.

Exact methods change over engine versions. Always use Godot 4.7 class reference before implementing plugin code.

## 10. UndoRedo

Editor changes should integrate with undo/redo when possible.

Plugins that mutate scenes/resources without undo support create poor authoring safety.

Use the editor's undo/redo APIs for user-facing operations.

## 11. Custom import/validation pipeline

Potential Pixel RPG content pipeline:

source data/reference
-> importer/validator
-> normalized Resource or .tscn
-> stable IDs
-> automated headless validation
-> runtime load

Do not make the editor plugin the only source of truth. Generated artifacts should remain inspectable/versioned where appropriate.

## 12. GDExtension

GDExtension loads native extensions without recompiling the engine.

Use when:
- a hot subsystem cannot meet performance needs in GDScript;
- a native library must be integrated;
- custom low-level functionality is required.

Costs:
- C/C++ toolchain;
- platform-specific builds;
- Android ABI builds;
- crash/memory safety risk;
- more CI complexity;
- more difficult debugging.

Default project rule:
Do not introduce GDExtension until profiling proves a concrete need or required native integration has no simpler alternative.

## 13. godot-cpp

C++ GDExtension development commonly uses godot-cpp bindings.

Version compatibility matters. Bindings and extension API must match the targeted Godot series.

Never copy a Godot 4.3/4.4 extension setup into 4.7 without validating compatibility.

## 14. GDExtension API dump tools

Godot 4.7 command line includes:

    --dump-gdextension-interface
    --dump-gdextension-interface-json
    --dump-extension-api
    --dump-extension-api-with-docs
    --validate-extension-api

These are excellent machine-readable sources for another bot.

If exact engine binding data matters, generate it from the installed Godot 4.7.2 binary rather than relying on memory.

## 15. GDScript documentation generation

Godot 4.7 also exposes:
--gdscript-docs with --doctool.

This can turn project inline documentation into generated API reference material.

Potential future task:
add triple-hash documentation to stable project APIs, then generate a local API bundle in CI.

## 16. Recovery mode

If a plugin/tool/GDExtension prevents editor startup:

    godot --recovery-mode

Godot 4.7 documents recovery mode as disabling common editor-startup extension features.

## 17. External editor integration

Godot exposes GDScript language-server and debug-adapter ports:

    --lsp-port
    --dap-port

This allows supported external editors to obtain completion/diagnostics/debugging.

The built-in editor remains sufficient for GDScript, but external tooling is available.

## 18. Project-specific future editor tools

High-value candidates, only after current architecture stabilizes:

Settlement Inspector
Visualize section bounds, area IDs, connectors and load policies.

Stable ID Validator
Scan duplicate/missing entity IDs.

World Chunk Validator
Check bounds overlap, neighbor symmetry, resource existence.

Interaction Debugger
Draw use radius, camera ray, resolved target and authority owner.

Performance Overlay
Expose loaded chunks, active physics bodies, NPC count, draw-related custom metrics.

Save Inspector
Load a copy of a save and show schema/stable-ID resolution without mutating production data.

## 19. Plugin safety checklist

Before enabling a custom plugin:
- branch clean/committed;
- plugin scope documented;
- destructive operations require explicit action;
- undo support for scene edits;
- no hidden network calls;
- no paid service dependency;
- no secret/token storage in source;
- plugin disables cleanly;
- recovery-mode fallback documented;
- generated files deterministic where possible.

## 20. Status for Pixel RPG

No editor plugin or GDExtension is established here as part of the active runtime architecture based on the files inspected for this reference.

These capabilities are GODOT_4_7_AVAILABLE, not CURRENT_PROJECT_USE, unless newer repository state proves otherwise.
