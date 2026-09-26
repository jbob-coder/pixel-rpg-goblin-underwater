# Layer 11 — Performance, LOD and Visibility

Status: PROVISIONAL MOBILE PERFORMANCE DESIGN

## Goal

Preserve a dense-looking settlement without simulating/rendering everything at full cost.

Physical-device evidence decides final budgets.

## Section visibility

Preferred:
- current section fully active
- directly visible adjacent geometry available
- distant sections simplified/culled only when transitions are not visible

Avoid aggressive pop near central plaza sightlines.

## Building cost classes

### Important enterable
Examples:
- Community Hall
- Smith
- Gatehouse
- Hunter Watch

Allow:
- interior
- anchors
- segmented collision

Keep material count and interior clutter bounded.

### Secondary residence/storage
Simpler geometry/materials.

### Open canopy/stall
Low geometry and minimal collision.

## Props

Prefer:
- reusable scenes
- instancing
- shared materials
- no collision for small decorative props

Avoid many unique high-resolution textures.

## Lighting

Prefer:
- restrained global/environment lighting
- limited expensive dynamic lights
- emissive/unshaded presentation where appropriate

Lantern visuals do not automatically require one dynamic light each.

## Physics

Activate physics only where gameplay needs it.

Most settlement props should be StaticBody3D/simple collision or presentation-only.

Avoid:
- dynamic rigid bodies as ambient clutter
- complex mesh collision
- always-active physics far from player

## NPCs

Use lightweight state-driven NPCs.

Visible active NPC density remains provisional and must be tested on target Android hardware.

Unloaded sections:
- abstract state
- no full CharacterBody simulation

## LOD/HLOD

Possible later:
- section-level visibility ranges
- simplified distant building shells
- MultiMesh for repeated small props/vegetation

Do not add a complex LOD system before measured need.

## Texture/image rule

Use pixel-consistent source sizes.
Do not upscale assets merely to increase file size/resolution without visible benefit.

## Performance evidence

Measure on target device:
- sustained FPS/frame time
- stutter entering sections
- memory
- heat
- battery where useful
- load/unload spikes
- first-person interior/exterior transitions

## Acceptance

No performance claim is complete from editor/headless CI alone.
