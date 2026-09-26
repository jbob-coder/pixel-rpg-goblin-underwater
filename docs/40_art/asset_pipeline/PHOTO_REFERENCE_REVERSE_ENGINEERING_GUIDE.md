# Pixel RPG — Photo Reference Reverse-Engineering and Blueprint Guide

Status: ACTIVE ASSET-REFERENCE METHOD / DOCUMENTATION ONLY  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Purpose

Define how photographs or generated reference images may be used to reconstruct visible objects, buildings, props, streetscape pieces, interiors, and environmental assets for Pixel RPG.

The goal is to convert a visual reference into a controlled **game-asset blueprint**, not to pretend a single image contains exact engineering truth.

## Allowed workflow

A supplied or generated reference image may be used to:

- identify the visible object and major components;
- break the object into reusable pieces;
- infer approximate proportions;
- produce front/side/top concept views;
- produce a labeled blueprint-style reference;
- produce an exploded-parts concept sheet;
- identify likely materials and surface groups;
- define modeling modules;
- define likely interaction points;
- propose a game-scale footprint;
- propose separate collision primitives;
- produce a game-asset construction checklist.

## Evidence classes

Every inferred value must be classified.

### OBSERVED

Directly visible in the source image.

Examples:

- visible door;
- visible roof pitch;
- number of windows;
- visible support posts;
- color/material appearance;
- visible tool or prop.

### SCALE-ANCHORED

Estimated using a known reference in the image.

Examples:

- ruler;
- known doorway;
- known brick size;
- human figure with stated height;
- known vehicle/model.

### INFERRED

Reasonable reconstruction that is not directly proven.

Examples:

- hidden rear wall;
- unseen roof structure;
- wall thickness;
- back-side window layout;
- internal framing.

### GAME-DESIGN CHOICE

Deliberately changed for gameplay/readability.

Examples:

- widening a doorway for first-person movement;
- simplifying roof collision;
- exaggerating a sign;
- increasing interior clearance;
- reducing decorative clutter;
- splitting an object into reusable modules.

Never label INFERRED or GAME-DESIGN CHOICE values as observed fact.

## Single-photo limits

One photograph cannot reliably prove:

- exact dimensions without scale;
- hidden/internal geometry;
- structural thickness;
- rear-side geometry;
- exact material composition;
- manufacturing tolerances;
- UV layout;
- gameplay collision;
- interaction sockets;
- engineering safety.

A single-photo reconstruction is therefore a **concept/game blueprint**, not certified CAD or manufacturing documentation.

## Multi-view upgrade

Preferred reference set:

1. front;
2. left/right side;
3. rear;
4. top/high-angle;
5. doorway/interior close-up where relevant;
6. scale reference;
7. material/detail close-ups.

Multiple views reduce inference and improve:

- orthographic accuracy;
- proportions;
- modular breakdown;
- texture/material reference;
- collision planning;
- interior/exterior alignment.

## Pixel RPG asset pipeline

Use:

`SOURCE PHOTO / GENERATED REFERENCE`
→ source identity record
→ visible-feature breakdown
→ observed/inferred classification
→ blueprint/model sheet
→ modular asset plan
→ runtime visual derivative
→ independent collision/interaction contract
→ automated validation
→ Android build
→ physical-device visual/performance acceptance.

## Required source record

For every reference used to drive an asset, record where possible:

- source ID;
- filename;
- original dimensions;
- source type: PHOTO / GENERATED_REFERENCE / CONCEPT_ART;
- creator/source provenance;
- date acquired/generated;
- checksum if stored;
- allowed usage/ownership status;
- known scale anchor;
- known camera/perspective limitations.

## Blueprint deliverable

A game blueprint should contain:

- asset ID;
- purpose;
- visible-part list;
- front/side/top concept views when useful;
- estimated overall width/depth/height;
- confidence for each dimension;
- modular pieces;
- material groups;
- first-person readability notes;
- proposed interaction anchors;
- proposed collision strategy;
- LOD/visibility notes if needed;
- what remains unknown.

## Building-specific blueprint

For buildings, include:

- footprint;
- wall height;
- roof volume;
- doorway width/height;
- window sockets;
- interior usable area;
- first-person roof behavior;
- interaction anchors;
- NPC anchors;
- prop sockets;
- section-placement connector;
- collision profile.

The current enterable smith remains the strongest implemented reference for this contract.

## Prop-specific blueprint

For props, include:

- footprint and visual height;
- silhouette;
- pivot/origin;
- orientation;
- collision need: NONE / SIMPLE / GAMEPLAY-SPECIFIC;
- interaction need;
- reusable variants;
- texture/material source.

## Collision firewall

Reference imagery does **not** define collision automatically.

Visual reconstruction:

`PHOTO → VISIBLE MODEL`

Gameplay collision:

`GAMEPLAY REQUIREMENT → EXPLICIT COLLISION CONTRACT`

These may share approximate shape, but they have different owners and verification.

## First-person readability rule

Objects are evaluated from eye-height first-person play on Android.

Prioritize:

- silhouette;
- doorway readability;
- useful landmark shapes;
- navigable clearance;
- simple material groups;
- limited clutter;
- visible interaction surfaces.

Do not add detail simply because it exists in a photograph if it creates mobile noise or collision complexity.

## Scale rule

If exact scale is unknown:

1. mark dimensions ESTIMATED;
2. use current Pixel RPG human/building scale as a gameplay anchor;
3. validate against first-person movement;
4. preserve proportions where useful;
5. change dimensions deliberately when gameplay requires it.

Do not invent “exact” millimeter values from perspective images.

## Generated-reference rule

AI-generated or artist-generated references are valid for:

- visual exploration;
- silhouette;
- module ideas;
- material direction;
- decorative motifs.

They are **not technical truth** for:

- exact geometry;
- hidden construction;
- collision;
- engineering;
- written labels;
- dimensions.

## Approval states

Use:

REFERENCE_ONLY  
→ BLUEPRINT_DRAFT  
→ MODEL_READY_REFERENCE  
→ RUNTIME_DERIVATIVE_IMPLEMENTED  
→ AUTOMATED_VERIFIED  
→ DEVICE_VISUAL_VERIFIED  
→ SHIP_APPROVED.

Do not skip directly from reference image to SHIP_APPROVED.

## Recommended usage for Settlement 01

Photo-reference reconstruction is especially suitable for:

- gatehouse;
- community hall/local lodge;
- residences;
- smith exterior/interior details;
- storage shed;
- work canopy;
- watchpost;
- market stall variants;
- carts;
- crates;
- benches;
- signs;
- lanterns;
- water trough;
- fences;
- awnings;
- street-edge clutter.

Each reconstructed asset should remain modular so the settlement can reuse pieces without looking copy-pasted.

## Relationship to current asset rules

This guide extends, not replaces:

- `ASSET_LINEAGE_AND_APPROVAL_MANIFEST.md`;
- `ASSET_QA_GATES.md`;
- `RUNTIME_2D_ASSET_GUIDE.md`;
- `RASTER_RESOLUTION_AND_ZOOM_QUALITY.md`;
- current Pixel RPG visual direction.

If those older documents contain stale runtime-status banners, their reusable lineage/QA laws still apply unless a newer current owner explicitly supersedes them.
