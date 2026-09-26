# Godot 4.7 Scenes, Nodes, Resources, Signals and SceneTree

Official references:

https://docs.godotengine.org/en/4.7/getting_started/step_by_step/nodes_and_scenes.html
https://docs.godotengine.org/en/4.7/tutorials/scripting/scene_tree.html
https://docs.godotengine.org/en/4.7/tutorials/scripting/resources.html
https://docs.godotengine.org/en/4.7/getting_started/step_by_step/signals.html
https://docs.godotengine.org/en/4.7/tutorials/scripting/groups.html

## 1. Mental model

Godot runtime composition is primarily:

Resource data
-> PackedScene resource
-> instantiated Node tree
-> added to SceneTree
-> lifecycle callbacks and signals
-> rendering/physics/audio/navigation servers underneath

A Scene is a reusable tree of Nodes saved as a resource. A PackedScene is the resource form that can instantiate that scene.

## 2. Node tree operations

Create:

    var root := Node3D.new()
    root.name = "RuntimeRoot"

Add:

    add_child(root)

Find strict:

    var camera: Camera3D = $CameraPivot/Camera3D

Find optional:

    var camera := get_node_or_null("CameraPivot/Camera3D") as Camera3D

Parent/child:

    var parent := node.get_parent()
    var child := node.get_child(0)
    var count := node.get_child_count()

Tree state:

    node.is_inside_tree()
    node.get_tree()
    node.get_viewport()

Remove without freeing:

    node.get_parent().remove_child(node)

Queue deletion:

    node.queue_free()

## 3. Node ownership

Node.owner is about scene ownership/serialization, not normal parentage.

When constructing editor-time scenes through code and then packing/saving them, ownership must be assigned correctly or children may not be serialized into the PackedScene.

Runtime-only nodes do not need an owner merely to exist in the live tree.

## 4. PackedScene instancing

    const ENEMY_SCENE: PackedScene = preload("res://enemy.tscn")

    func spawn_enemy(parent: Node) -> Node:
        var enemy := ENEMY_SCENE.instantiate()
        parent.add_child(enemy)
        return enemy

Never assume instantiate returned a specific subclass unless the root type is known and verified.

Typed cast:

    var enemy := ENEMY_SCENE.instantiate() as CharacterBody3D
    if enemy == null:
        push_error("Enemy root is not CharacterBody3D")
        return

## 5. Scene switching

Simple blocking switch:

    var err := get_tree().change_scene_to_file("res://levels/level_02.tscn")

Preloaded packed scene:

    const LEVEL_02: PackedScene = preload("res://levels/level_02.tscn")
    get_tree().change_scene_to_packed(LEVEL_02)

Pixel RPG app_shell.gd uses change_scene_to_file.

Scene switching is synchronous with respect to loading unless the resource is already loaded. Large world transitions should consider ResourceLoader threaded loading and explicit transition orchestration.

## 6. SceneTree

SceneTree is the default MainLoop for normal Godot games.

High-value capabilities:

- current_scene;
- root Viewport;
- change_scene_to_file;
- change_scene_to_packed;
- process_frame signal;
- physics_frame signal;
- node groups;
- timers;
- pause state;
- multiplayer API;
- quit return code.

Create a one-shot timer:

    await get_tree().create_timer(0.25).timeout

Pause:

    get_tree().paused = true

Each node has process_mode controlling whether/how it processes while paused.

## 7. Node lifecycle order

Important callbacks:

- _init: object construction;
- _enter_tree: enters SceneTree;
- _ready: node and children are in tree and ready;
- _process: frame/idle processing;
- _physics_process: fixed physics step;
- _exit_tree: leaving SceneTree.

Do not access child nodes in _init unless they were manually created before that access. @onready and _ready are the standard places for scene child dependencies.

## 8. Signals

Declare:

    signal inventory_changed

Typed:

    signal health_changed(current: float, maximum: float)

Connect:

    health_changed.connect(_on_health_changed)

Emit:

    health_changed.emit(current_health, max_health)

Signals are preferred when a producer should not own knowledge of every listener.

Avoid:
UI directly mutating deep gameplay internals simply because it can get a NodePath.

Prefer:
domain/state emits a change; UI observes and renders it.

## 9. Groups

Runtime:

    add_to_group("interactable")

Query:

    var interactables := get_tree().get_nodes_in_group("interactable")

Broadcast:

    get_tree().call_group("interactable", "refresh_state")

Groups are useful for tags and batch operations. They are not a replacement for stable entity IDs or durable save-state identity.

## 10. Scene unique nodes

Godot supports scene unique names, accessed with the percent syntax when configured in a scene.

    @onready var hud := %HUD

Useful when internal hierarchy may move but a named scene-level dependency should remain easy to resolve.

Do not assume a node is unique unless the scene marks it that way.

## 11. Resources

Resource is a serializable, reference-counted data object integrated with Godot loading/saving.

Examples:

- PackedScene
- Mesh
- Material
- Texture2D
- AudioStream
- Animation
- Shape3D
- NavigationMesh
- custom Resource scripts

Custom resource:

    class_name WeaponDefinition
    extends Resource

    @export var stable_id := ""
    @export var damage := 1.0

This is a strong option for authoring reusable data in the Inspector.

## 12. Shared Resource behavior

Loaded Resources are commonly cached/shared. Mutating a shared resource can affect every instance that references it.

If an object needs independent mutable material/data:

    var local_material := shared_material.duplicate(true)

Or configure resource_local_to_scene where appropriate.

Before duplicating everything, understand whether shared state is desirable.

## 13. ResourceLoader

Dynamic load:

    var resource := ResourceLoader.load(path)

Typed expectation:

    var scene := ResourceLoader.load(path) as PackedScene

Background load:

    var err := ResourceLoader.load_threaded_request(path)
    if err != OK:
        push_error(error_string(err))

Poll status:

    var progress: Array = []
    var status := ResourceLoader.load_threaded_get_status(path, progress)

Retrieve after ready:

    var scene := ResourceLoader.load_threaded_get(path) as PackedScene

Official background loading:
https://docs.godotengine.org/en/4.7/tutorials/io/background_loading.html

Important:
load_threaded_get can block if the request is not complete. Check status when non-blocking behavior is required.

## 14. ResourceSaver

For custom Resource-based save/config data:

    var err := ResourceSaver.save(resource, "user://save_01.tres")

Use user:// for writable user data. res:// is the packaged project resource space and should not be treated as a normal writable location in exported builds.

## 15. Runtime node construction

Godot allows scenes/world pieces to be built entirely from code.

Example:

    var body := StaticBody3D.new()
    body.name = "rock_001"

    var collision := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = Vector3(1.0, 1.0, 1.0)
    collision.shape = shape

    body.add_child(collision)
    world.add_child(body)

Pixel RPG already performs runtime construction of world and collision content.

Tradeoff:
Code-generated content can be deterministic and data-driven, but large hand-authored content is often easier to inspect in .tscn scenes or external source assets.

## 16. Autoload

Autoload can place a Node/script under the SceneTree root for project-wide lifetime.

Typical uses:

- save service;
- scene transition coordinator;
- audio service;
- global configuration;
- broad-scope quest/dialogue service.

Avoid turning Autoload into an unbounded god object.

Project rule:
Do not introduce a new Autoload without checking whether an existing authority owner already exists.

## 17. Scene change architecture for larger worlds

For a future streamed world, separate:

- durable world state;
- loaded scene chunks;
- visual representation;
- collision/navigation representation;
- loading scheduler;
- player location;
- transition state.

Godot tools that can participate:

- ResourceLoader threaded loading;
- PackedScene;
- Node reparenting;
- process modes;
- visibility ranges;
- MultiMesh;
- NavigationServer3D;
- RenderingServer;
- WorkerThreadPool/Thread for data preparation with thread-safety constraints.

Do not put durable game state only in loaded scene nodes if those nodes may unload.

## 18. Failure modes

Common scene/tree errors:

- Node not found after renaming a path;
- accessing @onready dependency before _ready;
- freeing a node while another system retains an invalid reference;
- modifying the tree from an unsafe thread;
- mutating shared resources accidentally;
- using FileAccess for imported resources after export;
- adding runtime children but expecting them to be serialized automatically;
- scene transition causing a load hitch;
- using global state where a local owner/signals would be cleaner.

## 19. Pixel RPG applicability

CONFIRMED_PROJECT_USE:

- PackedScene preload in tests;
- SceneTree scene changes;
- Node runtime construction;
- typed @onready node references;
- queue_free;
- call_deferred;
- process_frame and physics_frame awaiting;
- Node groups in gameplay/domain code should be verified per script before changes;
- RefCounted helper classes.

GODOT_4_7_AVAILABLE, not confirmed as project-wide architecture:

- custom Resource definitions as primary content model;
- Autoload-based transition manager;
- scene-unique node references;
- full background world streaming.

Inspect current code before choosing any of these.
