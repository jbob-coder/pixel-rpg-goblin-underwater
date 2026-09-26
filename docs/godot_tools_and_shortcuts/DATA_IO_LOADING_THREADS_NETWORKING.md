# Godot 4.7 Data, Save/Load, Background Loading, Threads and Networking

Official references:

Saving games:
https://docs.godotengine.org/en/4.7/tutorials/io/saving_games.html

Background loading:
https://docs.godotengine.org/en/4.7/tutorials/io/background_loading.html

Thread-safe APIs:
https://docs.godotengine.org/en/4.7/tutorials/performance/thread_safe_apis.html

Using multiple threads:
https://docs.godotengine.org/en/4.7/tutorials/performance/using_multiple_threads.html

High-level multiplayer:
https://docs.godotengine.org/en/4.7/tutorials/networking/high_level_multiplayer.html

## 1. Godot path model

res://
Project resources packaged with the game.

user://
Writable user-specific data location.

Use res:// for shipped content.
Use user:// for:
- save games;
- settings;
- logs where appropriate;
- generated user data.

Do not depend on writing to res:// in exported Android builds.

## 2. FileAccess

Text write:

    var file := FileAccess.open("user://save.json", FileAccess.WRITE)
    if file == null:
        push_error("Could not open save file")
        return
    file.store_string(json_text)

Text read:

    if not FileAccess.file_exists("user://save.json"):
        return

    var file := FileAccess.open("user://save.json", FileAccess.READ)
    var text := file.get_as_text()

FileAccess can also read/write binary data.

Important:
For imported Godot resources inside exported projects, use ResourceLoader rather than trying to navigate imported files with FileAccess.

## 3. DirAccess

Use DirAccess for:
- creating save directories;
- listing files;
- deleting/renaming user files;
- directory checks.

Example:

    DirAccess.make_dir_recursive_absolute("user://saves")

Check exact return/error behavior in the 4.7 class reference.

## 4. JSON

Serialize:

    var text := JSON.stringify(data)

Parse:

    var parsed := JSON.parse_string(text)
    if parsed == null:
        push_error("Invalid JSON")
        return

JSON supports a limited data model. Complex Godot types may need explicit encoding.

For long-lived save files, define a schema/version and migration path.

## 5. ConfigFile

ConfigFile is useful for INI-like settings.

Example:

    var config := ConfigFile.new()
    config.set_value("audio", "master", 0.8)
    config.set_value("camera", "sensitivity", 0.105)
    var err := config.save("user://settings.cfg")

Load:

    var config := ConfigFile.new()
    var err := config.load("user://settings.cfg")
    if err == OK:
        var sensitivity := float(config.get_value("camera", "sensitivity", 0.105))

Strong fit:
user settings, not necessarily large world-state saves.

## 6. ResourceSaver / custom Resources

A custom Resource can be saved as .tres/.res.

Advantages:
- Godot-native types;
- editor inspectability for .tres;
- typed resource classes;
- ResourceLoader integration.

Tradeoffs:
- migration/versioning still required;
- do not expose untrusted external Resource data as a security boundary;
- shared Resource behavior must be understood.

## 7. Save architecture for Pixel RPG

Recommended durable state model:

SaveHeader
- schema version;
- game version;
- timestamp;
- active world/region;
- player stable ID.

PlayerState
- stats;
- inventory;
- progression;
- location.

WorldState
- persistent entity states keyed by stable IDs;
- opened/closed/destroyed state;
- quest/event state;
- time/calendar if applicable.

Do not serialize raw Node references as durable identity.
Use stable IDs and reconstruct runtime nodes from definitions/resources.

## 8. Save migration

Every durable format should have a version:

    {
        "schema": "pixel_rpg.save.v1",
        "player": { ... }
    }

On load:
- validate root type;
- validate schema;
- migrate older supported version;
- reject/backup unknown future version safely;
- never overwrite the only valid save until the new save has been written successfully.

For higher reliability:
write temp -> flush/close -> verify -> replace canonical save.

## 9. ResourceLoader synchronous load

    var resource := ResourceLoader.load("res://path/resource.tres")

Simple but potentially blocking.

Use for:
- small startup data;
- already-cached resources;
- non-time-sensitive operations.

Avoid large synchronous loads during active gameplay.

## 10. Background loading

Start:

    var err := ResourceLoader.load_threaded_request(path)

Poll:

    var progress: Array = []
    var status := ResourceLoader.load_threaded_get_status(path, progress)

Retrieve only when ready where non-blocking behavior matters:

    var loaded := ResourceLoader.load_threaded_get(path)

Godot documentation notes load_threaded_get can block if loading is incomplete.

Useful for:
- world chunks;
- large scenes;
- heavy meshes/textures;
- transitions.

## 11. Thread fundamentals

Godot supports Thread, Mutex, Semaphore and WorkerThreadPool-style facilities.

Use threading for CPU work that can be safely separated from scene-tree mutation:
- procedural data generation;
- path/query workloads where API is thread-safe;
- serialization/compression;
- expensive pure calculations.

Do not add threads before profiling proves a need.

## 12. Scene tree is not thread-safe

Godot 4.7 documentation explicitly states interacting with the active SceneTree is not thread-safe.

Unsafe from worker:

    world.add_child(node)

Safe pattern:
prepare data/off-tree object, then schedule main-thread mutation:

    world.add_child.call_deferred(node)

Also available:
set_deferred.

Even if off-tree scene chunks can be prepared away from the active tree, shared resources across multiple threads can still cause races.

## 13. Rendering and physics thread constraints

Godot thread-safety depends on server/project settings.

Do not assume:
- Mesh/texture GPU operations are safe from arbitrary threads;
- PhysicsServer3D operations are automatically configured for threaded use;
- scene nodes are safe because their underlying server is thread-safe.

Read the Godot 4.7 thread-safe API page before a new threaded subsystem.

## 14. Navigation threading

Godot 4.7 documentation states NavigationServer2D/3D are thread-safe/thread-friendly for relevant queries.

AStar helper objects are not safe for concurrent mutation/query on the same object.

## 15. WorkerThreadPool

WorkerThreadPool can schedule tasks without manually creating a Thread per short operation.

Good use:
large independent CPU work sets.

Rules:
- task data ownership must be clear;
- avoid shared mutable containers without synchronization;
- scene-tree mutations return to main thread;
- capture only references that remain valid until completion.

Verify the exact Godot 4.7 WorkerThreadPool API before implementation.

## 16. HTTPRequest / HTTPClient

Godot includes:
- HTTPRequest node for convenient HTTP;
- HTTPClient for lower-level control.

Potential uses:
- optional web services;
- update metadata;
- remote content manifest.

Project constraint:
Do not introduce paid/cloud dependencies without explicit creator approval.

On Android, networking requires appropriate export permissions such as INTERNET.

## 17. TCP/UDP/WebSocket/WebRTC

Godot exposes lower-level networking tools:
- StreamPeerTCP / TCPServer;
- PacketPeerUDP / UDPServer;
- WebSocket APIs;
- WebRTC APIs.

Use only when architecture requires direct protocol control.

## 18. High-level multiplayer

Godot high-level multiplayer integrates with SceneTree/Node.

Core concepts:
- MultiplayerAPI;
- MultiplayerPeer;
- ENetMultiplayerPeer;
- server/client peer creation;
- peer connection signals;
- @rpc;
- authority;
- reliable/unreliable transfer modes;
- channels.

Example server shape:

    var peer := ENetMultiplayerPeer.new()
    var err := peer.create_server(PORT, MAX_CLIENTS)
    if err == OK:
        multiplayer.multiplayer_peer = peer

Example RPC:

    @rpc("any_peer", "call_local", "reliable")
    func request_action(action_id: String) -> void:
        if not multiplayer.is_server():
            return
        var sender := multiplayer.get_remote_sender_id()
        validate_and_apply(sender, action_id)

Security rule:
Treat remote client data as untrusted. The server/authority should validate gameplay-critical actions.

## 19. Multiplayer authority

Node.set_multiplayer_authority can assign authority for nodes.

Do not confuse network authority with durable domain ownership. A clean architecture defines:
- which peer may propose actions;
- which peer validates;
- which runtime object represents replicated state;
- which durable state owner persists results.

## 20. Android network permission

Godot 4.7 multiplayer documentation warns that Android networking requires INTERNET permission in the Android export preset.

The current Pixel RPG export preset should be inspected before any network feature is added. Do not assume the permission is already enabled.

## 21. Security and untrusted data

Never:
- execute downloaded scripts;
- trust client-reported inventory/combat results;
- deserialize untrusted data into privileged behavior without validation;
- use network data as file paths without sanitization;
- expose arbitrary filesystem paths.

Validate:
- IDs;
- ranges;
- enum/state transitions;
- rate limits;
- ownership;
- schema versions.

## 22. Offline-first fit

Pixel RPG can remain fully functional offline with:
- local Resources;
- local user:// save data;
- local deterministic/domain systems;
- headless tests;
- APK export.

Networking should be optional architecture unless the game design explicitly requires it.

## 23. Verification for data/save patches

- new game save works;
- load restores exact intended state;
- corrupt/partial save fails safely;
- old supported schema migrates;
- unknown schema does not overwrite data;
- path uses user://;
- no raw Node reference is required after reload;
- stable IDs resolve correctly;
- save during scene transition does not capture inconsistent state;
- Android permissions/storage behavior tested on device.

## 24. Verification for threaded/background patches

- no active SceneTree mutation from worker;
- resource ownership documented;
- no race on shared Dictionary/Array resizing;
- completion callback handles owner destruction;
- cancellation/lifecycle considered;
- loading failure path tested;
- frame hitch measured before/after;
- Android behavior tested for large loads.
