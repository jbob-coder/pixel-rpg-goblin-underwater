# PNG → Rigged / Severable / Animated / LOD-Tested 3D Monster Pipeline

Status: SELECTED AUTOMATION STRATEGY / NOT YET EXECUTED
Last reconciled: 2026-09-02

## Goal

Create the most automated practical pipeline from approved creature reference PNGs to a game-ready monster while preserving the project's anatomy, damage, mutation, animation and Android-performance requirements.

Important truth:

**A single PNG cannot reliably prove all hidden 3D geometry, topology, rigging, sever boundaries, animation deformation, LOD quality and Android runtime behavior.**

The pipeline may START from one PNG, but production reliability requires additional generated/verified views and technical data.

The target is therefore:

`ONE APPROVED CONCEPT → AUTOMATED MULTIVIEW/3D CANDIDATE → SCRIPTED TECHNICAL PIPELINE → EXPLICIT QA GATES`

not magical `PNG → finished production monster with no verification`.

---

# 1. Recommended external reconstruction candidates

Current researched candidate tools, to be evaluated by actual output quality/licensing/cost before adoption:

## Meshy
Current public workflow supports:
- image-to-3D;
- single-image and multiview generation;
- PBR texturing;
- humanoid/quadruped/Smart Rig auto-rigging;
- animation presets;
- FBX/GLB export.

Use case for this project:
- rapid reconstruction candidate;
- first-pass quadruped/custom-monster rig;
- animation preview;
- GLB/FBX handoff to Blender.

Risk:
- generated topology/weights still require project-specific anatomy/sever/LOD validation.

## Tripo
Current public workflow supports:
- image-to-3D;
- rigged animation-ready outputs for supported character types;
- FBX/GLB/OBJ workflow.

Use case:
- alternate reconstruction candidate;
- compare geometry/silhouette against Meshy result.

## Rodin / Hyper3D
Current public workflow advertises:
- text/image-to-3D;
- optional multiview input;
- PBR materials;
- rigging-ready topology emphasis.

Use case:
- third candidate for hero-asset comparison where topology quality matters.

## Blender
Selected technical cleanup/orchestration DCC candidate because it is free/open-source and supports:
- mesh cleanup/remesh/retopology tools;
- armatures;
- Rigify building-block rigging;
- custom weight painting;
- vertex groups;
- shape keys;
- modifiers;
- Decimate for LOD candidates;
- scripting with Python;
- batch export.

Engine choice remains open, so final import/export rules are deferred.

---

# 2. Input package

Minimum automated reconstruction input should eventually include:

`M01 HERO CONCEPT`
`M02 TURNAROUND / MULTIVIEW`
`M03 ANATOMY SEGMENTATION`
`M04 DAMAGE/BREAK/SEVER DESIGN`
`M05 MUTATION/CRYSTAL VARIANTS`
`M07 SCALE TARGET`

The hero image alone may be used for an early candidate, but the multiview is preferred for reconstruction.

For image-to-3D input:
- neutral pose;
- subject isolated;
- no environment occlusion;
- no dramatic perspective;
- no cropped tail/horns/limbs;
- no combat VFX;
- clean silhouette;
- consistent proportions across views.

---

# 3. Automation stages

## Stage A — Source normalization

Automatable:
- copy selected reference into conversion-input lane;
- remove background where technically safe;
- standardize canvas/orientation;
- check transparency;
- verify minimum resolution;
- create metadata manifest;
- checksum input.

Output:
`CONVERSION_INPUT_v###`

## Stage B — Reconstruction candidate generation

Preferred:
- use 2–4 consistent views where service supports multiview;
- request geometry without presentation background/effects;
- preserve full tail/horns/feet;
- export GLB/FBX/OBJ candidate.

Create at least two candidates when feasible before locking a hero asset.

Automated comparison can score:
- bounding-box proportions;
- silhouette projections;
- gross asymmetry;
- missing limbs/components;
- triangle count;
- non-manifold geometry count;
- material count.

Visual approval still required.

## Stage C — Blender import and normalization

Scriptable in Blender:
- import candidate;
- set project unit convention;
- rotate to canonical forward/up axes;
- scale to documented meter target;
- apply transforms;
- rename objects/materials;
- detect/clean obvious duplicate geometry;
- report non-manifold/degenerate geometry;
- create source backup collection;
- generate validation report.

No source mesh is destructively overwritten without versioning.

## Stage D — Retopology / remesh

Can be partly automated but is a quality gate.

Options:
- keep acceptable generated topology if deformation tests pass;
- remesh/retopologize where necessary;
- use Blender remesh/decimate tools for candidates;
- use external retopology tools later if justified.

Hero monster rule:
**topology around shoulders, hips, jaw, neck, tail base, breakable structures and sever boundaries must be inspected.**

A fully automatic decimation pass is not enough for deforming hero topology.

## Stage E — Anatomy binding

Project-specific and cannot be trusted to generic image-to-3D automation alone.

Create named regions/vertex groups/objects linked to stable anatomy IDs.

Monster 01 example families:
- head;
- left/right horn;
- torso;
- left/right forelimb;
- left/right hindlimb;
- tail base;
- tail distal/sever section;
- dorsal plate group;
- crystal/core presentation region only if/when exposed visually.

Automatable after boundaries exist:
- naming validation;
- missing-region checks;
- parent/bone reference checks;
- overlap reports;
- export metadata.

## Stage F — Severable/breakable setup

Requires explicit mesh design.

For severable parts:
- define separation loop/boundary;
- create attached and detached representations;
- create sever-cap geometry/material;
- preserve compatible skinning before sever;
- define authoritative anatomy ID;
- define collision/harvest representation;
- test no gap/exploding vertices before event;
- test clean detach after event.

For breakable horns/plates:
- separate attachment or swap region;
- intact/broken visual state;
- broken stump/cap;
- optional detached material object;
- LOD equivalents.

This setup can be scripted once the topology/naming standard exists, but the original boundary cannot be inferred safely from one hero PNG.

## Stage G — Rigging

Candidate automated paths:
1. external auto-rig for quadruped/custom creature;
2. Blender custom metarig/Rigify-style building blocks where body plan permits;
3. custom armature for final hero asset if automatic result fails.

Required bones for Monster 01 will be defined by its packet.

Validation:
- root motion/origin;
- spine/neck/head;
- jaw if used;
- four limbs;
- tail chain;
- horn/plate attachment bones only if needed;
- secondary crystal/plate controls only when justified.

## Stage H — Skinning/deformation tests

Automatable test poses:
- neutral;
- full foreleg extension/compression;
- hindleg stride;
- sharp body turn;
- tail sweep extremes;
- head/neck charge pose;
- crouch/brace;
- stagger;
- death/fall candidate.

Generate diagnostic renders and flag:
- extreme volume loss;
- self-intersection;
- detached-looking joints;
- sever-boundary deformation;
- stretched textures.

## Stage I — Animation

Use two layers:

### Generic/prototype motion
External preset/retarget sources may provide:
- idle;
- walk;
- run;
- turn;
- basic attack test.

### Game-specific motion
Must be authored/adjusted for:
- telegraphed charge;
- horn attack;
- tail attack;
- wounded gait;
- broken-horn behavior presentation;
- leg-injury locomotion;
- berserk transition;
- exhausted/low-core state;
- specific stagger/death states.

Animation never decides damage or berserk state; it presents authoritative state.

## Stage J — LOD generation

Create LOD candidates from the verified hero mesh.

Possible automated method:
- duplicate hero mesh;
- use controlled reduction/decimation;
- preserve material/anatomy boundaries where possible;
- transfer/validate rig weights;
- retain silhouette-critical horn/tail/plates;
- generate separate distant representation only if needed.

Required checks:
- same species silhouette;
- break/sever state remains readable at required LOD;
- no critical targetable anatomy vanishes too early;
- no severe animation collapse;
- no UV/material corruption.

Exact triangle ratios remain open until device profiling.

## Stage K — Collision and hit proxies

Generate simplified body collision separately from render mesh.

Anatomy targeting uses dedicated hit regions/proxies linked to stable IDs.

Do not use raw high-poly triangles as authoritative body-part selection.

## Stage L — Automated validation report

Produce machine-readable report including:
- dimensions/world scale;
- object count;
- mesh/triangle/vertex count by LOD;
- material count;
- bone count;
- missing anatomy regions;
- non-manifold/degenerate checks;
- named sever/break objects;
- animation list;
- bounding boxes;
- collision objects;
- export files/checksums.

## Stage M — Engine/device verification

Cannot be replaced by DCC validation.

Must eventually verify:
- import correctness;
- material/shader correctness;
- aerial readability;
- first-person close quality;
- animation playback;
- break/sever runtime state;
- LOD switching;
- memory;
- frame pacing;
- thermal behavior;
- Android suspend/resume where relevant.

Only after this can it be called `LOD_TESTED` or `GAME_READY`.

---

# 4. One-button orchestration target

A future local pipeline script could orchestrate:

`reference manifest`
→ `submit reconstruction`
→ `download candidate`
→ `Blender headless normalize/inspect`
→ `generate QA renders`
→ `apply known anatomy setup template`
→ `rig/animation candidate`
→ `LOD candidates`
→ `export`
→ `generate validation report`
→ `copy to test-import area`

However, failure gates deliberately stop automation when:
- silhouette differs materially from approved design;
- limbs/tail/horns are malformed;
- topology cannot support deformation/severing;
- anatomy boundaries are ambiguous;
- rig weights fail deformation tests;
- LOD removes gameplay-critical forms.

A pipeline that continues through bad input is not high quality.

---

# 5. Current recommended first practical route

For Monster 01:
1. generate approved hero concept;
2. generate/check consistent turnaround;
3. use multiview reconstruction in Meshy/Tripo/Rodin candidates;
4. select best mesh;
5. Blender normalization/cleanup;
6. explicitly bind anatomy IDs;
7. create horn break + tail sever topology;
8. auto-rig quadruped candidate;
9. deformation test;
10. prototype locomotion/attack animations;
11. create LOD candidates;
12. engine/device test later.

This is far more reliable than asking one service to infer every gameplay requirement from one illustration.

---

# 6. Status vocabulary

Use:
- `IMAGE_REFERENCE_APPROVED`
- `RECONSTRUCTION_CANDIDATE`
- `MESH_SELECTED`
- `TOPOLOGY_VERIFIED`
- `ANATOMY_BOUND`
- `SEVER_SETUP_VERIFIED`
- `RIG_VERIFIED`
- `ANIMATION_PROTOTYPE_VERIFIED`
- `LOD_DCC_VERIFIED`
- `ENGINE_IMPORTED`
- `PHONE_RUNTIME_VERIFIED`
- `GAME_READY`

Never call a generated GLB `GAME_READY` immediately after download.
