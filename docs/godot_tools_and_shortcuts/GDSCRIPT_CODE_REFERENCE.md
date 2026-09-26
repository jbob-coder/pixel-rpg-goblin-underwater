# Godot 4.7 GDScript Code Reference

Status:
GODOT_4_7_AVAILABLE unless explicitly marked CONFIRMED_PROJECT_USE.

Official entry:
https://docs.godotengine.org/en/4.7/tutorials/scripting/index.html

Class reference:
https://docs.godotengine.org/en/4.7/classes/

## 1. Script inheritance

Every GDScript can extend a Godot class or another script.

    extends Node

    extends CharacterBody3D

    extends RefCounted

    extends Resource

Pixel RPG uses Node and RefCounted extensively, and CharacterBody3D in the first-person player implementation.

Use Node when lifecycle/tree behavior is required.
Use RefCounted for lightweight reference-counted logic/data that does not need the scene tree.
Use Resource for serializable/shareable engine resources.
Use CharacterBody3D for script-controlled character motion.

## 2. Global script types with class_name

    class_name DamageCalculator
    extends RefCounted

This registers the script as a named GDScript type. Pixel RPG already uses class_name for camera, motion, touch and settlement helpers.

Use it for stable reusable types. Avoid duplicate class names.

## 3. Static methods and variables

    class_name MathHelpers
    extends RefCounted

    static var calls := 0

    static func clamp_health(value: float) -> float:
        calls += 1
        return clampf(value, 0.0, 100.0)

Static utilities are useful when no instance state is required. Pixel RPG uses static functions for deterministic math and validation.

## 4. Typed variables

Prefer explicit types when the expected type is stable:

    var speed: float = 5.2
    var target: Node3D
    var names: Array[String] = []
    var state: Dictionary = {}

Typed code improves editor completion and catches mistakes earlier.

Inference with := is also useful:

    var direction := Vector3.ZERO

Do not force a narrow inferred type when a variable intentionally changes among incompatible Variant types.

## 5. Constants

    const MOVE_SPEED_MPS := 5.2
    const PLAYER_START := Vector3(0.0, 0.9, 13.0)

Pixel RPG uses constants heavily for tuning values and stable IDs. Prefer constants for invariants that should not change at runtime.

## 6. Enums

    enum MovementState {
        IDLE,
        WALK,
        RUN,
    }

    var movement_state: MovementState = MovementState.IDLE

Use enums when a small finite state set is stronger than arbitrary strings. Existing project code may use stable string IDs for data contracts; do not replace those without migration analysis.

## 7. Exported properties

Godot can expose script properties in the Inspector.

    @export var move_speed := 5.2
    @export_range(0.1, 20.0, 0.1) var acceleration := 8.0
    @export_file("*.json") var data_file := ""
    @export_node_path("Camera3D") var camera_path: NodePath

High-value annotations include:

- @export
- @export_range
- @export_enum
- @export_flags
- @export_file
- @export_dir
- @export_global_file
- @export_multiline
- @export_color_no_alpha
- @export_node_path

Check the 4.7 annotation/class reference for the exact form before adding a specialized annotation.

## 8. On-ready references

    @onready var camera: Camera3D = $CameraPivot/Camera3D

@onready delays initialization until the node has entered the scene tree and its children are available. Pixel RPG uses this heavily in its presentation host.

Failure mode:
A hard-coded NodePath breaks when the scene hierarchy is renamed. Tests should cover important paths.

Safer optional lookup:

    @onready var camera := get_node_or_null("CameraPivot/Camera3D") as Camera3D

Use strict $ paths when missing nodes are a hard configuration error. Use get_node_or_null when absence is legitimate and handled.

## 9. preload versus load

Preload occurs when the script is parsed:

    const PLAYER_SCENE: PackedScene = preload("res://player.tscn")

Load occurs at runtime:

    var scene := load("res://player.tscn") as PackedScene

Use preload for fixed dependencies needed by the script and where synchronous load at parse/setup is acceptable.

Use ResourceLoader for dynamic or background loading. Do not use FileAccess to read imported engine resources after export.

## 10. Functions

    func apply_damage(amount: float) -> bool:
        if amount <= 0.0:
            return false
        health -= amount
        return true

Prefer typed arguments and return types for stable APIs.

Private-by-convention methods start with underscore:

    func _rebuild_cache() -> void:
        pass

Godot does not enforce private visibility for normal GDScript methods.

## 11. Lifecycle callbacks

Common Node callbacks:

    func _enter_tree() -> void:
        pass

    func _ready() -> void:
        pass

    func _process(delta: float) -> void:
        pass

    func _physics_process(delta: float) -> void:
        pass

    func _input(event: InputEvent) -> void:
        pass

    func _unhandled_input(event: InputEvent) -> void:
        pass

    func _exit_tree() -> void:
        pass

Use _physics_process for physics movement and collision operations. Pixel RPG does this for CharacterBody3D movement.

Use _process for frame-driven presentation/UI that does not need the fixed physics tick.

## 12. Notifications

Nodes and Objects receive integer notifications.

    func _notification(what: int) -> void:
        if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
            reset_input()

Pixel RPG uses application pause/resume/focus notifications to clear transient touch input, preventing stuck controls.

## 13. Signals

Declare:

    signal health_changed(current: float, maximum: float)

Emit:

    health_changed.emit(health, max_health)

Connect:

    health_changed.connect(_on_health_changed)

Disconnect only when needed; connections are usually cleaned when an object is freed.

Signals reduce direct coupling and are first-class values in Godot 4.

Official:
https://docs.godotengine.org/en/4.7/getting_started/step_by_step/signals.html

## 14. Callables

    var callback: Callable = Callable(self, "_finish")
    callback.call()

Useful methods include call, call_deferred, bind and unbind. Prefer direct method references where possible:

    button.pressed.connect(_on_button_pressed)

## 15. Deferred calls

    call_deferred("_initialize_after_ready")
    node.add_child.call_deferred(child)

Deferred execution is useful when a tree mutation would be unsafe during the current callback or when initialization must occur after the current frame step.

Do not use deferred calls as a generic fix for ordering bugs. Document why the deferral is necessary.

## 16. await

Await a signal:

    await get_tree().process_frame
    await get_tree().physics_frame
    await animation_player.animation_finished

Pixel RPG tests use process_frame and physics_frame to verify runtime state after tree/physics updates.

Be aware that the function becomes coroutine-like and resumes later. Revalidate object lifetime after long waits where nodes may have been freed.

## 17. Arrays

    var ids: Array[String] = ["a", "b"]

Important operations:

- append
- append_array
- erase
- has
- find
- duplicate
- sort
- sort_custom
- filter
- map
- reduce
- resize
- clear

Typed Arrays are preferable when all elements share a stable type.

## 18. Dictionaries

    var record := {
        "id": "monster_001",
        "hp": 100.0,
    }

Safe access:

    var hp := float(record.get("hp", 0.0))

Check presence:

    if record.has("id"):
        pass

Deep copy:

    var copy := record.duplicate(true)

Pixel RPG settlement definitions use dictionaries as data contracts. If dictionaries become complex or frequently mutated, consider a typed Resource or RefCounted class.

## 19. StringName and NodePath

StringName is optimized for names repeatedly compared by the engine.
NodePath represents a path into the scene tree.

Use StringName for frequently reused action, property, signal or method names when API signatures expect it.
Use NodePath for node/property paths that should remain path objects instead of plain strings.

## 20. Core value types

Frequently used types:

- Vector2 / Vector2i
- Vector3 / Vector3i
- Vector4 / Vector4i
- Basis
- Transform2D / Transform3D
- Quaternion
- Plane
- AABB
- Rect2 / Rect2i
- Color
- Projection

Pixel RPG first-person math uses Vector2, Vector3 and Basis.

## 21. Useful math helpers

Global math functions include:

- clamp / clampf / clampi
- lerp / lerpf
- inverse_lerp
- remap
- move_toward
- smoothstep
- snapped
- deg_to_rad
- rad_to_deg
- wrapf
- absf
- minf / maxf
- is_equal_approx
- is_zero_approx

Vectors provide normalized, length, length_squared, dot, cross, distance_to, direction_to, lerp and more.

## 22. Object lifetime

Node deletion:

    node.queue_free()

Immediate deletion exists via free(), but queue_free is usually safer during scene-tree processing.

Check an Object reference after asynchronous/deferred work:

    if is_instance_valid(node):
        node.queue_free()

RefCounted objects are freed automatically when no references remain.

## 23. Error handling

Godot APIs often return Error enum values.

    var err := get_tree().change_scene_to_file(path)
    if err != OK:
        push_error("Scene change failed: %s" % error_string(err))

Useful diagnostics:

- print
- print_rich
- printerr
- push_warning
- push_error
- assert

Do not rely on assert for production error recovery.

## 24. Dynamic calls and reflection

Available:

    object.call("method_name", argument)
    object.has_method("method_name")
    object.get("property")
    object.set("property", value)
    object.get_method_list()
    object.get_property_list()
    ClassDB.class_exists("CharacterBody3D")

These tools are powerful for generic systems and editor tooling but lose static safety. Prefer direct typed calls when the type is known.

## 25. Metadata

Objects can store metadata:

    node.set_meta("stable_id", "npc_gate_warden_001")
    var id := node.get_meta("stable_id", "")

Useful for editor/runtime tagging, but important durable game state should live in an explicit state model, not hidden metadata.

## 26. Groups

    add_to_group("damageable")
    var targets := get_tree().get_nodes_in_group("damageable")
    get_tree().call_group("damageable", "refresh")

Groups work as scene-tree tags and are useful for broad decoupled addressing.

Official:
https://docs.godotengine.org/en/4.7/tutorials/scripting/groups.html

## 27. Tool scripts

    @tool
    extends Node3D

Tool scripts execute in the editor. They can automate content generation and expose project-specific authoring tools.

Risk:
Editor execution can modify scenes/resources while you are authoring. Use defensive null checks, avoid destructive operations in property setters, and separate runtime-only behavior.

Editor tooling is covered separately in EDITOR_EXTENSIONS_GDEXTENSION.md.

## 28. RPC annotation

Godot high-level multiplayer uses @rpc on Node methods.

Do not add networking merely because the annotation exists. Multiplayer architecture requires authority, validation, serialization and security decisions.

Official:
https://docs.godotengine.org/en/4.7/tutorials/networking/high_level_multiplayer.html

## 29. Documentation comments

Use triple-hash documentation comments for public reusable project APIs where appropriate.

Then Godot can surface script documentation and can generate GDScript docs through command-line tooling.

Godot 4.7 command line includes:
--gdscript-docs with --doctool

## 30. Style for this repository

Preferred for new Pixel RPG code unless surrounding code requires otherwise:

- typed parameters and return types;
- stable IDs rather than display names;
- small deterministic helpers for math/validation;
- explicit state owner versus presentation owner;
- constants for invariant tuning values;
- schema/version identifiers for contracts likely to evolve;
- no unrelated refactors during feature patches;
- tests that run in headless Godot where practical.

Always match the actual local architecture before introducing a new abstraction.
