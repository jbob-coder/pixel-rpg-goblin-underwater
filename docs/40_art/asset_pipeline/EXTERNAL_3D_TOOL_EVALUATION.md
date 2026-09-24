# External 3D Tool Evaluation

Status: RESEARCH SNAPSHOT / VENDOR CAPABILITIES NOT YET PROJECT-VERIFIED
Research date: 2026-09-02

## Purpose

Record current external tools that may reduce manual work between approved PNG references and a production monster. This is not an endorsement and does not replace project QA.

Vendor feature claims are time-sensitive and must be rechecked before committing money or building automation against an API/workflow.

## Meshy

Current researched capabilities from Meshy public/help documentation:
- Image to 3D from PNG/JPG/WebP;
- single-image and multiview workflows;
- textured model export in common formats including FBX/GLB;
- auto-rigging for humanoid/quadruped plus custom/fantasy Smart Rig beta path;
- animation preset library;
- game/DCC export workflows.

Potential use here:
- Monster 01 reconstruction candidates from turnaround/multiview;
- rapid quadruped/custom rig prototype;
- first-pass locomotion/animation preview;
- export to Blender for project-specific cleanup/anatomy/sever/LOD.

Project risk:
- vendor calling output “game-ready” does not prove our topology, sever boundary, anatomy hit regions, persistent damage states or Android performance.

Public references checked:
- https://www.meshy.ai/features/image-to-3d
- https://help.meshy.ai/en/articles/9996860-how-to-use-meshy-image-to-3d
- https://help.meshy.ai/en/articles/16231707-how-to-create-3d-animation-with-auto-rigging
- https://docs.meshy.ai/en/webapp/guides/animate

## Tripo

Current researched public/help claims:
- image-to-3D generation;
- animation-ready/rigged model generation for supported humans/animals/stylized characters;
- automatic skeleton/skin workflow;
- FBX/GLB/OBJ export.

Potential use:
- alternative Monster 01 reconstruction candidate;
- compare hidden-side geometry/proportions against Meshy candidate;
- fast rig candidate before Blender validation.

Public references checked:
- https://www.tripo3d.ai/help/features/how-to-use-the-image-to-3d-feature
- https://www.tripo3d.ai/help/features/can-tripo-create-animation-ready-3d-models

## Rodin / Hyper3D

Current public claims:
- image/text-to-3D;
- optional multiview input;
- PBR materials;
- emphasis on clean/rigging-ready topology.

Potential use:
- hero-asset geometry candidate where topology/material quality compares favorably;
- third reconstruction candidate before selecting a base mesh.

Public reference checked:
- https://hyper3d.ai/use-cases/animation

## Blender

Selected likely technical orchestration DCC candidate because it is free/open-source and supports Python automation.

Current Blender documentation confirms relevant capabilities such as:
- modeling/remeshing/retopology workflows;
- Decimate modifier for controlled face-count reduction candidates;
- armature/rigging;
- bundled Rigify building-block rig generation;
- modifiers/Geometry Nodes;
- Python scripting/batch processing.

Important limitation:
Rigify automates rig-control/bone construction; it does not magically solve every mesh skinning/topology issue for a custom hero creature. Project deformation QA remains required.

Public references checked:
- https://docs.blender.org/manual/en/4.5/
- https://docs.blender.org/manual/en/4.5/modeling/meshes/retopology.html
- https://docs.blender.org/manual/en/4.5/modeling/modifiers/generate/decimate.html
- https://docs.blender.org/manual/en/latest/addons/rigify/index.html

## Upscaling/restoration tools

### Upscayl
Current public site describes a free/open-source desktop AI upscaler with local processing and multiple models.

Potential use:
- visual-reference enlargement when native regeneration is unavailable;
- batch reference cleanup.

Not valid for reconstructing technical maps/measurements.

Reference:
- https://upscayl.org/download

### Real-ESRGAN
Open-source restoration/upscaling project with general x2/x4 models and portable/Python workflows.

Potential use:
- reproducible local reference-only upscale pipeline;
- batch processing with recorded model/scale.

Risk:
- generative restoration can invent texture/detail and tiled inference can introduce inconsistencies. Never treat output as exact technical geometry/PBR/hit information.

Reference:
- https://github.com/xinntao/Real-ESRGAN

## Selection method

Do not select one service from marketing copy.

For Monster 01, use the same approved conversion input and compare candidates on:
1. silhouette match;
2. front/side/back proportion match;
3. tail/horn/foot completeness;
4. hidden-side plausibility;
5. topology/non-manifold state;
6. material organization;
7. rig suitability;
8. export reliability;
9. licensing/privacy/cost;
10. repeatability/API availability if automation is needed.

## Automation preference

Best current architecture:
- external model service generates candidate;
- Blender owns normalization, anatomy/sever setup, QA renders, LOD candidate creation and final export preparation;
- engine/device owns final runtime verification.

This avoids locking the game to one vendor's topology/rig conventions.

## Current status

`TOOLS_RESEARCHED = YES`
`TOOLS_PROJECT_BENCHMARKED = NO`
`PAID_SERVICE_SELECTED = NO`
`AUTOMATION_API_SELECTED = NO`
`BLENDER_TECHNICAL_PIPELINE = PREFERRED CANDIDATE`
