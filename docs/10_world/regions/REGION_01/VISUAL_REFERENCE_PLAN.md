# REGION_01 — Visual Reference and PNG Plan

Status: REFERENCE PLAN / IMAGES NOT YET GENERATED
Last reconciled: 2026-09-02

## Purpose

Define which environment reference images are worth creating now that Region 01 has a topology and terrain identity.

This applies `/MODEL_REFERENCE_IMAGE_AND_CREATION_PIPELINE.md`.

Generated PNGs are visual references unless explicitly labeled as deterministic diagrams produced from recorded data.

## Quality rule

Do not create one giant beautiful map image and expect it to solve:
- exact sector topology;
- terrain dimensions;
- streaming boundaries;
- encounter nodes;
- asset kit design;
- gameplay visibility;
- tracking readability.

Use separate references for separate questions.

## R01_V01 — Region mood / identity board

Purpose:
- establish coherent temperate river-root basin visual language;
- show outer frontier versus deeper old-growth/crystal pressure;
- define broad color/value/material families.

Recommended panels:
- river/mud;
- root forest;
- feeding meadow;
- rocky rise;
- deepwood;
- nest/fault.

Can ChatGPT generate? **YES.**

Authority: visual intent only.

## R01_V02 — Sector topology diagram

Purpose:
- show canonical sector adjacency and route relationships.

This should be created as a **clean deterministic diagram from `REGION_TOPOLOGY.md`**, not as freeform concept art.

Requirements:
- stable sector IDs;
- exact adjacency;
- camp/gate edge;
- deep-territory direction;
- no invented routes;
- clearly distinguish diagram from physical scale map.

Can ChatGPT create? **YES**, but the labels/lines must be checked against Markdown after generation or rendered programmatically later.

Authority: diagram can communicate topology only after readback verification; it is not exact terrain geometry.

## R01_V03 — Gameplay camera keyframes

Purpose:
Show what the region should look like from the actual local exploration camera without revealing the whole map.

Panels:
- S00 trailhead/camp;
- S01 river ford;
- S02 rootwood;
- S03 meadow;
- S04 rocky rise;
- S05 deepwood;
- S06 nest shelf.

Each panel should keep the player locally framed and show only partial geography.

Can ChatGPT generate? **YES.**

Authority: visual target, not engine FOV proof.

## R01_V04 — Environment modular kit sheet

Purpose:
Identify reusable asset families instead of unique modeling for every meter.

Include:
- large trees/root modules;
- trunk/branch silhouettes;
- boulder/rock families;
- cliff/shelf modules;
- riverbank modules;
- mud/wet edge;
- fallen trunks;
- reeds/brush;
- meadow grass masses;
- camp pieces;
- nest material;
- restrained crystal/fault geology.

Can ChatGPT generate? **YES as modeling reference.**

Exact modular seams/pivots/snap dimensions require DCC/engine validation.

## R01_V05 — Tracking evidence sheet

Purpose:
Make clues readable and physically plausible.

Panels can include:
- footprint in mud;
- water entry/exit disturbance;
- snapped branch;
- scratch/rub mark;
- flattened feeding grass;
- feeding remains;
- injured blood/limp trail;
- territory/nest marks;
- mutation/element residue candidate.

Can ChatGPT generate? **YES.**

Important: evidence must later be filtered to only clues the actual first monster can produce.

## R01_V06 — Encounter continuity sheet

Purpose:
Show one location in three connected views:
1. aerial approach;
2. camera descent/engagement context;
3. first-person tactical view.

Recommended first subject: River Ford or Meadow Edge.

Must preserve:
- same boulder/log/terrain;
- same monster;
- same relative approach direction;
- same visible landmark.

Can ChatGPT generate? **YES as a continuity target.**

Actual camera transition must be verified in engine.

## R01_V07 — Visibility/LOD sheet

Purpose:
Show what survives at:
- local gameplay detail;
- adjacent-sector distance;
- far landmark distance.

Focus:
- tree masses;
- ridge silhouette;
- nest/fault silhouette;
- monster silhouette where visible;
- removal of tiny detail before gameplay readability.

Can ChatGPT generate? **YES as art-direction reference.**

Actual LOD meshes/distances require device profiling.

## R01_V08 — Field camp / frontier handoff sheet

Purpose:
Visually connect Settlement 01's hunter-gate corridor to S00 without making the camp a second town.

Show:
- trail arrival;
- compact shelter/fire/storage/map surface;
- wilderness continuing immediately beyond;
- visible but distant region landmark;
- limited human infrastructure.

Can ChatGPT generate? **YES.**

## Generation order

Do not generate all at once.

Recommended bounded sequence:
1. `R01_V02` topology diagram — cheapest structural check;
2. `R01_V03` gameplay camera keyframes — validates not seeing whole map;
3. `R01_V01` mood board — locks coherent visual family;
4. `R01_V04` modular kit sheet — supports modeling plan;
5. `R01_V06` encounter continuity — supports camera/combat presentation;
6. tracking/LOD/camp sheets as needed.

## Storage/versioning

When generated, store references in Google Drive and record:
- reference ID;
- filename/version;
- Drive file ID/link;
- purpose;
- status `CONCEPT / SELECTED / SUPERSEDED / TECHNICALLY_VERIFIED`;
- linked Markdown file;
- known inaccuracies.

Recommended filenames:
- `REGION_01_V02_TOPOLOGY_v001.png`;
- `REGION_01_V03_CAMERA_KEYFRAMES_v001.png`;
- etc.

## Current decision

No new Region 01 PNG is generated in this documentation pass. The blueprint is recorded first so future images have a stable question to answer rather than becoming speculative art.
