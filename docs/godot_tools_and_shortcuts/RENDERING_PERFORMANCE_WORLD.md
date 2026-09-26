# Godot 4.7 Rendering, Performance and Large-World Tools

Official references:

Godot 4.7 feature list:
https://docs.godotengine.org/en/4.7/about/list_of_features.html

MultiMesh:
https://docs.godotengine.org/en/4.7/tutorials/performance/using_multimesh.html

Internal rendering architecture:
https://docs.godotengine.org/en/4.7/engine_details/architecture/internal_rendering_architecture.html

Jitter/stutter:
https://docs.godotengine.org/en/4.7/tutorials/rendering/jitter_stutter.html

Class reference:
https://docs.godotengine.org/en/4.7/classes/

## 1. Current renderer constraint

CONFIRMED_PROJECT_USE:

Pixel RPG project.godot selects GL Compatibility for desktop, mobile and web.

That choice should constrain implementation decisions.

Do not assume Forward+ Vulkan-only features are available.
Do not introduce compute-shader-dependent gameplay/rendering without first changing and validating the renderer strategy.
Always check the class/property documentation for renderer limitations.

## 2. Core 3D rendering nodes/resources

High-value types:

- MeshInstance3D
- MultiMeshInstance3D
- GeometryInstance3D
- Decal
- Sprite3D
- Label3D
- GPUParticles3D
- CPUParticles3D
- DirectionalLight3D
- OmniLight3D
- SpotLight3D
- WorldEnvironment
- Environment
- Camera3D
- SubViewport
- SubViewportContainer
- StandardMaterial3D
- ShaderMaterial
- Mesh resources
- Texture2D resources

Pixel RPG currently uses runtime-created MeshInstance3D/StandardMaterial3D patterns in its world builders and a SubViewport-based presentation scene.

## 3. StandardMaterial3D

Use StandardMaterial3D for most ordinary materials before reaching for a custom shader.

It exposes common physically based and stylized options such as:
- albedo;
- metallic;
- roughness;
- normal mapping;
- emission;
- transparency;
- culling;
- texture filtering;
- UV controls.

Renderer and mobile cost still matter. A feature existing does not mean it is free.

## 4. ShaderMaterial and Godot shader language

Godot supports text shaders for 2D and 3D rendering.

Typical spatial shader skeleton:

    shader_type spatial;

    uniform vec4 tint : source_color = vec4(1.0);

    void fragment() {
        ALBEDO = tint.rgb;
    }

Possible uses:
- stylized pixel/palette treatment;
- water;
- damage flash;
- dissolve;
- wind/vegetation motion;
- outlines;
- fog/atmospheric effects;
- UV animation.

Before adopting a shader:
- confirm GL Compatibility support;
- profile on the Galaxy A03 class of target hardware;
- avoid expensive screen reads or many texture samples unless justified.

## 5. Geometry generation from code

Godot offers:

ArrayMesh:
Create mesh surfaces from arrays.

SurfaceTool:
Higher-level mesh construction helper.

ImmediateMesh:
Immediate-style geometry for dynamic/simple drawing.

CSG nodes:
Useful for prototyping geometry, not automatically ideal for final large production worlds.

Pixel RPG settlement grayboxes are currently generated largely through script-driven primitives and scenes. If geometry becomes asset-heavy, evaluate whether authored Mesh/PackedScene content is easier to maintain.

## 6. MultiMesh

GODOT_4_7_AVAILABLE.

MultiMesh can draw very large numbers of repeated mesh instances efficiently in one rendering primitive.

Strong use cases:
- grass;
- repeated rocks;
- repeated debris;
- trees;
- fence posts;
- repeated street props.

Important limitation:
per-instance visibility culling is not automatic in the same way as independent MeshInstance3D nodes. Partition a large world into multiple MultiMeshes/chunks when culling matters.

MultiMesh allows per-instance transforms and optional custom/color data.

## 7. Visibility ranges / HLOD

GeometryInstance3D exposes visibility range concepts that support manual hierarchical level of detail.

Use cases:
- replace detailed building cluster with simpler proxy at distance;
- hide tiny props past useful visual range;
- switch vegetation representations;
- reduce far-settlement cost.

Large-world rule:
do not keep tiny high-detail geometry active at distances where it contributes less than a pixel.

Check exact Godot 4.7 properties before implementation because HLOD controls live on GeometryInstance3D-derived nodes.

## 8. Mesh LOD

Godot can generate/use mesh LOD for imported meshes.

For future externally authored 3D assets:
- preserve source asset;
- import with appropriate LOD settings;
- test silhouette;
- profile transition thresholds;
- avoid over-detailed collision matching visual LOD unless required.

## 9. Occlusion culling

Godot 4 uses CPU-side occlusion culling with OccluderInstance3D/Occluder3D infrastructure.

Best environments:
- settlements with buildings;
- interiors;
- walls/alleys;
- dense structures that block line of sight.

Less valuable:
- flat open terrain with few occluders.

Occluders should be simple and stable. Dynamic complex occluders are not a good default.

Before enabling/tuning:
- measure CPU and GPU frame cost;
- compare with/without culling;
- ensure occluder generation does not become excessive.

## 10. Distance culling

Even without a full HLOD system, GeometryInstance3D visibility ranges or custom chunk activation can suppress objects too distant to matter.

For this project, design streaming and distance culling together:
loaded does not have to mean rendered;
rendered does not have to mean simulated;
simulated does not have to mean durable.

## 11. World streaming architecture

Recommended high-level separation for future large areas:

WorldState
Durable logical state independent from loaded scenes.

WorldChunkDefinition
Data that describes bounds, dependencies, spawn anchors and resource paths.

WorldChunkRuntime
Loaded scene/node representation.

StreamingCoordinator
Determines desired load/active/unload set around player.

Presentation
Meshes/materials/VFX.

Physics
Collision representation, potentially activated at a smaller radius.

Navigation
Navigation maps/regions loaded or activated according to AI need.

This aligns with Pixel RPG's existing data-contract direction without assuming streaming is already implemented.

## 12. ResourceLoader background loading

Use ResourceLoader.load_threaded_request for scene/assets that would hitch when loaded synchronously.

Pipeline:

request
-> poll status/progress
-> retrieve loaded resource
-> instantiate
-> add to scene tree on safe thread
-> activate systems
-> later deactivate and free according to policy

Official:
https://docs.godotengine.org/en/4.7/tutorials/io/background_loading.html

## 13. RenderingServer

RenderingServer is the low-level rendering API under the scene-node layer.

It can be useful for extremely high instance counts or systems where Node overhead is too high.

Costs:
- more complex lifecycle;
- RID ownership;
- less editor friendliness;
- more manual state management.

Default rule:
prefer normal Nodes and MultiMesh until profiling proves they are insufficient.

## 14. Servers optimization

Godot exposes server APIs such as:
- RenderingServer;
- PhysicsServer3D;
- NavigationServer3D;
- AudioServer.

These APIs can bypass scene-tree overhead. They are advanced tools, not an automatic optimization.

Profile first.

## 15. SubViewport

SubViewport can render a separate 2D/3D scene to a texture or embedded region.

Uses:
- minimap;
- mirrors/cameras;
- inventory character preview;
- portals;
- render-to-texture effects;
- isolated world presentation.

Pixel RPG currently has a WorldViewport in its prototype scene.

Be careful:
Every additional 3D viewport may add meaningful rendering cost.

## 16. Lighting

Key tools:
- DirectionalLight3D;
- OmniLight3D;
- SpotLight3D;
- Environment/WorldEnvironment;
- baked/static techniques depending renderer and asset pipeline.

For mobile:
- minimize expensive dynamic lights/shadows;
- reduce shadow distance/resolution where possible;
- use lighting hierarchy based on player relevance;
- profile actual device.

## 17. Particles

GPUParticles3D:
high-throughput GPU particle simulation where renderer supports the desired features.

CPUParticles3D:
CPU alternative, useful for compatibility or cases where CPU behavior is needed.

For low-end Android:
budget particle count, overdraw and transparent fill rate carefully.

## 18. Transparency and overdraw

Transparent materials can be expensive, especially on mobile, because pixels may be shaded multiple times and ordering prevents some optimizations.

High-risk:
- full-screen transparent layers;
- dense overlapping foliage cards;
- large particle clouds;
- many alpha-blended surfaces.

Prefer opaque/cutout strategies where art direction allows.

## 19. Performance monitors

Godot exposes built-in performance metrics through the editor and Performance singleton.

Potential custom monitor:

    Performance.add_custom_monitor(
        "pixel_rpg/streaming/loaded_chunks",
        func(): return loaded_chunk_count
    )

Use custom monitors for systems whose cost/state matters but is invisible to generic CPU/GPU metrics.

Remove monitors when their owner is destroyed if required by the API/lifecycle.

## 20. Profiler and visual profiler

Godot includes:
- script profiler;
- frame timing;
- CPU/GPU visual profiler;
- rendering statistics;
- debugger monitors.

The command line also supports profiling/debug flags including:
--profiling
--gpu-profile
--print-fps

Do not optimize based only on intuition.

## 21. Performance budgeting for Pixel RPG

Target-device testing matters more than editor desktop FPS.

For the Galaxy A03 class target:
- test physical device regularly;
- cap world detail by distance;
- minimize draw calls/material variants;
- partition repeated geometry;
- simplify collisions;
- reduce transparent overdraw;
- avoid per-frame allocations in hot loops;
- avoid searching the entire scene tree every frame;
- update slow UI/context systems at lower frequency where acceptable;
- keep touch/camera feedback immediate.

The current prototype already updates some context/UI on a roughly 0.12 second cadence instead of every frame.

## 22. Common expensive patterns

Avoid unless measured:

- creating/freeing large numbers of nodes every frame;
- loading resources synchronously during gameplay;
- duplicating materials for every trivial object;
- many unique materials preventing batching;
- thousands of independent MeshInstance3D nodes when MultiMesh fits;
- expensive collision shapes on many static props;
- many shadow-casting lights;
- full-world active AI/physics;
- repeated get_nodes_in_group calls in tight loops if the result is stable;
- per-frame recursive tree searches;
- large amounts of transparent overdraw.

## 23. Streaming and origin precision

For extremely large coordinate ranges, floating-point precision can become relevant. Do not implement origin shifting prematurely.

First establish:
- actual world extents;
- gameplay coordinate needs;
- physics behavior;
- navigation architecture;
- save coordinate representation.

If precision becomes measurable, design an origin/rebasing strategy as a whole-system feature, not an isolated transform hack.

## 24. Verification checklist for rendering/world patches

- scene parses;
- no missing resources;
- no invalid material/texture paths;
- visual result checked in editor/runtime;
- frame time compared before/after;
- draw calls/objects/triangles observed when relevant;
- memory measured for streaming/content changes;
- collision still aligns with visible world;
- navigation still aligns where applicable;
- Android physical-device test performed for major visual changes;
- GL Compatibility behavior confirmed.
