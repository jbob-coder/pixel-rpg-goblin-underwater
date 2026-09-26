# Godot 4.7 Input, First-Person Camera and 3D Physics Reference

Official references:

Input examples:
https://docs.godotengine.org/en/4.7/tutorials/inputs/input_examples.html

Ray casting:
https://docs.godotengine.org/en/4.7/tutorials/physics/ray-casting.html

3D introduction:
https://docs.godotengine.org/en/4.7/tutorials/3d/introduction_to_3d.html

Class reference:
https://docs.godotengine.org/en/4.7/classes/

## 1. Input architecture

Godot supports two broad input approaches:

A. Named actions through InputMap.
B. Raw/device-specific InputEvent handling and direct Input queries.

For scalable controls, named actions are usually preferable for gameplay actions because keyboard, gamepad and other devices can map to the same action.

Raw events remain important for:
- touch IDs and positions;
- pointer motion;
- gestures;
- text input;
- specialized device behavior.

Pixel RPG currently uses raw touch events plus direct keyboard/mouse fallback in its prototype.

## 2. InputMap

Read a digital action:

    if Input.is_action_pressed("move_forward"):
        pass

One-frame edge:

    if Input.is_action_just_pressed("jump"):
        pass

Axis:

    var horizontal := Input.get_axis("move_left", "move_right")

2D vector:

    var input_vec := Input.get_vector(
        "move_left",
        "move_right",
        "move_forward",
        "move_back"
    )

InputMap makes rebinding and multi-device support easier than hard-coded KEY_W style checks.

Project migration warning:
Do not replace current hard-coded prototype input until compatibility with mobile touch state, tests and existing behavior is preserved.

## 3. _input versus _unhandled_input

_input receives input early.

_unhandled_input is useful for gameplay input that should only run if UI or another input consumer did not handle it.

A Control can consume events. Code can also mark input handled through the Viewport.

Pixel RPG uses:

    get_viewport().set_input_as_handled()

for owned touch events.

## 4. Touch input

Key event types:

- InputEventScreenTouch
- InputEventScreenDrag
- InputEventGesture and specialized gesture subclasses where supported

ScreenTouch provides:
- index: finger/touch identifier;
- position;
- pressed/canceled state depending on event.

ScreenDrag provides:
- index;
- position;
- relative/screen_relative fields depending on need and API version.

Multi-touch rule:
Track touch index ownership. Do not assume one global touch.

Pixel RPG already separates joystick touch ownership from look touch ownership.

## 5. Mouse input for first-person look

Typical desktop pattern:

    func _input(event: InputEvent) -> void:
        if event is InputEventMouseMotion:
            var motion := event as InputEventMouseMotion
            apply_look(motion.relative)

For dedicated desktop FPS control, mouse capture is available through Input.mouse_mode. Mobile does not use mouse capture for normal touch look.

## 6. First-person yaw/pitch split

Recommended node structure:

    Player
      CameraYaw
        CameraPitch
          Camera3D

Apply horizontal rotation to yaw and vertical rotation to pitch:

    yaw.rotation.y = yaw_radians
    pitch.rotation.x = clampf(pitch_radians, min_pitch, max_pitch)

Pixel RPG already uses this architecture.

Advantages:
- prevents unwanted roll;
- pitch clamp is simple;
- movement can use yaw basis;
- camera state can remain independent from the player visual.

## 7. Camera-relative movement

Pixel RPG already uses the following concept:

    var right := camera_basis.x
    right.y = 0.0
    right = right.normalized()

    var forward := -camera_basis.z
    forward.y = 0.0
    forward = forward.normalized()

    var move := (
        right * input_vector.x +
        forward * -input_vector.y
    ).normalized()

Use the horizontal camera/yaw basis rather than full pitched camera basis when movement should stay on ground.

## 8. CharacterBody3D

Key properties/methods:

- velocity;
- move_and_slide;
- is_on_floor;
- is_on_wall;
- is_on_ceiling;
- up_direction;
- floor_max_angle;
- floor_snap_length;
- motion_mode;
- get_last_motion;
- get_real_velocity;
- get_slide_collision_count;
- get_slide_collision.

Typical ground movement:

    func _physics_process(delta: float) -> void:
        var input_vec := Input.get_vector("left", "right", "forward", "back")
        var move_dir := camera_relative_direction(input_vec)

        velocity.x = move_dir.x * speed
        velocity.z = move_dir.z * speed

        if not is_on_floor():
            velocity.y -= gravity * delta

        move_and_slide()

Pixel RPG uses CharacterBody3D plus move_and_slide and explicit gravity.

## 9. Collision object types

StaticBody3D:
Static world collision. Best for terrain/building collision that does not move under gameplay physics.

CharacterBody3D:
Code-driven character motion with slide/floor helpers.

RigidBody3D:
Physics-simulated dynamic body.

AnimatableBody3D:
Moving body controlled by animation/code and intended to affect physics bodies predictably.

Area3D:
Detection/overlap region; not a solid physics body by itself.

## 10. CollisionShape3D

CollisionObject3D bodies and areas generally require CollisionShape3D children with Shape3D resources.

Common shapes:
- BoxShape3D
- SphereShape3D
- CapsuleShape3D
- CylinderShape3D
- ConvexPolygonShape3D
- ConcavePolygonShape3D
- WorldBoundaryShape3D

For moving bodies, prefer primitive/convex collision where possible. Concave collision is normally for static environment geometry.

## 11. Collision layers and masks

Layer:
What the object is.

Mask:
What it checks/collides against.

Use a documented layer table before a project becomes large. Avoid arbitrary bit assignments spread across scripts.

Suggested future documentation categories might include:
- world static;
- player;
- NPC;
- monster;
- interaction query;
- projectile;
- trigger;
- hitbox/hurtbox.

This is a proposal only; inspect existing project masks before assigning values.

## 12. RayCast3D

RayCast3D node is useful for a persistent per-frame query:
- interaction focus;
- weapon aiming;
- ground probe;
- line of sight.

Typical:

    if ray_cast.is_colliding():
        var collider := ray_cast.get_collider()
        var point := ray_cast.get_collision_point()

## 13. Direct physics-space ray query

For one-shot/dynamic queries, use PhysicsDirectSpaceState3D through World3D.

Concept:

    var space := get_world_3d().direct_space_state
    var query := PhysicsRayQueryParameters3D.create(origin, destination)
    query.collision_mask = interaction_mask
    var hit := space.intersect_ray(query)

Physics-space queries should normally be performed from the physics step or another safe physics context.

## 14. ShapeCast3D

ShapeCast3D sweeps a shape rather than an infinitesimal ray.

Useful for:
- melee volumes;
- ledge/clearance checks;
- broader targeting;
- movement prediction;
- camera obstruction volumes.

Check exact 4.7 class methods before implementation.

## 15. Area3D

Use Area3D for trigger/overlap detection.

Signals include body_entered/body_exited and area_entered/area_exited depending on monitoring configuration.

Good uses:
- interactable zones;
- hazard volume;
- water volume;
- encounter trigger;
- audio/reverb zones;
- transition zones.

## 16. Physics timing

Use _physics_process for:
- CharacterBody movement;
- physics queries tightly tied to movement;
- deterministic fixed-step timers where appropriate.

Use _process for:
- UI interpolation;
- non-physics visuals;
- frame-rate visual effects.

Mixing motion updates across physics and frame processing can produce jitter.

## 17. Physics interpolation

Godot supports physics interpolation. It can improve visual smoothness when physics tick rate and render refresh differ.

Before enabling globally, test:
- player responsiveness;
- camera behavior;
- teleports/respawns;
- moving platforms;
- first-person viewmodel;
- Android device feel.

Physics interpolation can add perceived input latency to physics-driven behavior. Treat it as a measured decision, not a default toggle.

## 18. First-person interaction query

Recommended future pattern:

Camera center ray
-> collision hit
-> resolve stable interactable ID/component
-> validate distance and state
-> present prompt
-> send interaction intent to authoritative gameplay owner

Do not let the UI button itself become the authority for gameplay state.

## 19. Camera obstruction

Third-person cameras often use SpringArm3D. Pixel RPG is first-person, and its current first-person test explicitly verifies the active camera no longer depends on the legacy SpringArm length.

Do not reintroduce chase-camera architecture into the authoritative first-person path.

## 20. Safe area and mobile layout

Pixel RPG currently uses:

- DisplayServer.window_get_size
- DisplayServer.get_display_safe_area
- Viewport visible rect
- Control global rects

This is appropriate for notches/cutouts and changing device geometry.

## 21. Input reset on lifecycle transitions

On mobile, touches can become stale when the application loses focus or pauses.

Current project pattern:
reset transient input on:
- application paused;
- application resumed;
- focus out;
- focus in.

Preserve this behavior unless tests prove a better replacement.

## 22. Debugging physics

Godot 4.7 command line includes:

    --debug-collisions
    --debug-paths
    --debug-navigation
    --debug-avoidance

The editor also exposes visible collision/navigation debugging while running.

Use these to prove geometry/query problems instead of guessing from visuals.

## 23. Verification targets for player/camera work

Any meaningful movement/camera patch should verify:

- project parses;
- prototype instantiates;
- first-person Camera3D is current;
- no third-person body blocks the camera;
- yaw sign;
- pitch sign and clamp;
- movement remains camera-relative;
- movement normalization;
- gravity/floor behavior;
- respawn/teleport resets velocity as intended;
- joystick finger does not become look finger;
- UI touches do not rotate camera;
- losing focus resets transient input;
- safe-area layout still works;
- Android physical-device feel is separately tested.

The current repository already has pixel_rpg_first_person_realignment_runtime_test.gd as evidence for several of these.
