# Godot 4.7 Animation, Navigation, UI and Audio Reference

Official references:

Animation:
https://docs.godotengine.org/en/4.7/tutorials/animation/

AnimationTree:
https://docs.godotengine.org/en/4.7/tutorials/animation/animation_tree.html

Navigation:
https://docs.godotengine.org/en/4.7/tutorials/navigation/

3D navigation overview:
https://docs.godotengine.org/en/4.7/tutorials/navigation/navigation_introduction_3d.html

GUI:
https://docs.godotengine.org/en/4.7/tutorials/ui/

Audio:
https://docs.godotengine.org/en/4.7/tutorials/audio/

## 1. AnimationPlayer

AnimationPlayer stores and plays animations.

It can animate:
- Node and Resource properties;
- transforms;
- method calls;
- audio playback;
- animation playback;
- bezier values.

Common API concepts:
- play;
- stop;
- pause;
- seek;
- speed_scale;
- animation_finished signal.

Example:

    @onready var animation_player: AnimationPlayer = $AnimationPlayer

    func play_attack() -> void:
        animation_player.play("attack")

Do not put authoritative combat results into animation events unless the architecture explicitly defines animation as the source of truth. Prefer gameplay state to drive animation, with carefully scoped animation callbacks for presentation timing.

## 2. AnimationTree

AnimationTree handles advanced blending/transitions while animations themselves remain in AnimationPlayer.

Useful tools:
- AnimationNodeStateMachine;
- AnimationNodeBlendTree;
- AnimationNodeBlendSpace1D;
- AnimationNodeBlendSpace2D;
- OneShot;
- TimeScale;
- transition nodes;
- filters.

State-machine playback:

    var playback := $AnimationTree.get("parameters/playback") as AnimationNodeStateMachinePlayback
    playback.travel("run")

Blend parameter:

    $AnimationTree.set("parameters/locomotion/blend_position", Vector2(input_x, input_y))

Use AnimationTree for:
- idle/walk/run blending;
- directional locomotion;
- crouch transitions;
- attack layers;
- hit reactions;
- state-machine transitions.

## 3. Root motion

AnimationTree can expose root-motion position/rotation/scale deltas.

Root motion can be fed into CharacterBody3D movement when animation-authored displacement is desired.

Tradeoff:
Root motion improves foot contact and authored motion fidelity but complicates deterministic movement, networking and player responsiveness.

For Pixel RPG, movement is currently code-driven. Do not switch to root-motion authority without an explicit movement architecture decision.

## 4. Skeleton3D and imported rigs

Godot 4 supports skeletal 3D characters and imported animations.

Typical structure:

CharacterBody3D
  VisualRoot
    imported_model
      Skeleton3D
      MeshInstance3D
      AnimationPlayer
  AnimationTree

Use imported glTF 2.0 where possible for interchange.

For first-person body parts:
- separate first-person viewmodel from world body when needed;
- avoid clipping into the camera;
- use animation retargeting/import tools when source rigs differ;
- test on the actual first-person FOV.

## 5. Bone attachments

BoneAttachment3D can attach runtime nodes to skeleton bones.

Uses:
- weapons;
- tools;
- held items;
- VFX attachment;
- armor pieces.

For gameplay-critical hit detection, do not assume visual bone attachment alone is authoritative. Explicit hitbox/hurtbox ownership may be needed.

## 6. Tween

Godot Tween is useful for lightweight procedural animation.

Example:

    var tween := create_tween()
    tween.tween_property(panel, "modulate:a", 1.0, 0.2)

Use for:
- UI fades;
- simple doors;
- camera/UI feedback;
- property interpolation.

Do not use a Tween as hidden durable state. A tween animates toward state; another system should own the state itself.

## 7. Navigation system overview

Core 3D tools:
- NavigationRegion3D;
- NavigationMesh;
- NavigationAgent3D;
- NavigationObstacle3D;
- NavigationLink3D;
- NavigationServer3D.

NavigationAgent3D assists path following and optional avoidance. The parent still needs movement code.

Typical pattern:

    @onready var agent: NavigationAgent3D = $NavigationAgent3D

    func set_target(world_position: Vector3) -> void:
        agent.target_position = world_position

    func _physics_process(delta: float) -> void:
        if agent.is_navigation_finished():
            velocity = Vector3.ZERO
            move_and_slide()
            return

        var next := agent.get_next_path_position()
        var direction := global_position.direction_to(next)
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
        move_and_slide()

Exact avoidance setup should be verified in the 4.7 class reference before use.

## 8. Navigation baking

NavigationMesh can be baked from geometry in the editor and can also participate in runtime workflows.

For streamed settlements/world:
- partition navigation data;
- do not assume one global giant navmesh is best;
- align navmesh load/activation with world streaming;
- keep dynamic obstacle use separate from pathfinding geometry changes.

NavigationObstacle3D affects avoidance; it does not automatically rewrite pathfinding geometry.

## 9. NavigationServer3D

NavigationServer3D is the low-level navigation API.

Potential advanced uses:
- direct map/region/path queries;
- runtime map control;
- multi-map setups;
- large-world custom navigation orchestration.

The 4.7 thread-safe API documentation states navigation server queries are thread-safe/thread-friendly.

Use NavigationAgent3D first unless profiling/architecture requires lower-level control.

## 10. AStar3D

AStar3D provides graph pathfinding independent of navigation meshes.

Good for:
- authored waypoint graphs;
- strategic travel;
- abstract roads;
- tactical graph systems;
- non-geometric routes.

It is not the same as NavigationServer3D.

Thread note:
Godot 4.7 thread-safety guidance warns that using the same AStar object from multiple threads can corrupt state. Isolate per-thread objects or keep access serialized.

## 11. UI foundation

Godot UI uses Control-derived nodes.

High-value nodes:
- Control;
- Container;
- MarginContainer;
- PanelContainer;
- VBoxContainer;
- HBoxContainer;
- GridContainer;
- Label;
- RichTextLabel;
- Button;
- TextureButton;
- OptionButton;
- Slider/HSlider/VSlider;
- ProgressBar;
- ScrollContainer;
- TabContainer.

Pixel RPG currently uses Button, Label, PanelContainer, HSlider, OptionButton and other Control nodes in its touch HUD.

## 12. Anchors and offsets

Control layout combines anchors and offsets.

Use anchors for relationship to parent size.
Use offsets for pixel/local spacing from anchored positions.

For mobile:
- design for aspect ratio changes;
- use safe area;
- avoid hard-coded screen coordinates where layout can be derived.

Pixel RPG already computes safe-area-aware HUD placement.

## 13. Containers

Containers automatically arrange child Controls.

Prefer Containers for:
- menus;
- settings;
- dynamic lists;
- inventories;
- dialog choices.

Manual offsets are still useful for game HUD elements such as a joystick, minimap and action button where placement is spatially intentional.

## 14. Theme

Theme resources centralize:
- fonts;
- font sizes;
- colors;
- style boxes;
- icons;
- spacing constants.

Use Themes to avoid manually setting every Control style in code.

For a stylized RPG UI, prefer reusable Theme resources and scoped theme overrides rather than per-node duplication.

## 15. Input focus and UI

Control nodes can consume mouse/touch events according to mouse_filter and focus rules.

When gameplay look is touch-driven:
- exclude UI rectangles from camera-look claiming;
- let UI consume relevant touches;
- keep touch ID ownership explicit;
- reset interaction state when panels open/close if needed.

Pixel RPG already excludes action/watch/settings/minimap/panels from look capture.

## 16. CanvasLayer

CanvasLayer can keep HUD independent of 3D camera transform.

Use separate layers for:
- HUD;
- menus;
- debug overlays;
- fade/transition overlays.

## 17. Audio players

Core nodes:
- AudioStreamPlayer;
- AudioStreamPlayer2D;
- AudioStreamPlayer3D.

Use:
AudioStreamPlayer for non-positional UI/music.
AudioStreamPlayer3D for world positional sound.
AudioStreamPlayer2D for 2D spatial sound.

## 18. Audio buses

AudioServer and bus layout support:
- master/music/SFX/voice buses;
- volume;
- mute/solo;
- effects;
- runtime control.

Example:

    var bus := AudioServer.get_bus_index("SFX")
    AudioServer.set_bus_volume_db(bus, linear_to_db(volume_linear))

Persist user volume settings separately, for example with ConfigFile.

## 19. 3D audio considerations

For a first-person game:
- use positional audio for world emitters;
- avoid excessive simultaneous sources;
- choose attenuation distances intentionally;
- use reverb/environment zones only when they materially improve experience and performance remains acceptable.

## 20. Video

Godot supports VideoStreamPlayer for supported video formats.

Use cautiously on Android:
- codec/platform support;
- package size;
- memory;
- startup cost.

## 21. Particles and animation coupling

Particles can be triggered by animation events/signals for:
- footsteps;
- hit effects;
- forge sparks;
- dust;
- water splash.

Gameplay authority should not depend solely on whether the particle system happened to emit.

## 22. Pixel RPG current status

CONFIRMED_PROJECT_USE:
- Control-based HUD;
- runtime UI state changes;
- first-person Camera3D;
- scene-based visual assets.

NOT VERIFIED AS CURRENT ACTIVE SYSTEM:
- AnimationTree locomotion;
- NavigationAgent3D-based NPC movement;
- large-scale navmesh streaming;
- audio-bus architecture;
- skeletal animation authority.

Before implementing any of these, inspect the current branch for newer code and define the owner/test boundary first.
