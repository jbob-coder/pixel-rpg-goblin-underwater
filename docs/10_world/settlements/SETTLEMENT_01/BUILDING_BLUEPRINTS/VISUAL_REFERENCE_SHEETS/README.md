# Settlement 01 — Visual Reference Sheet Package

Status: ACTIVE ART-REFERENCE SPECIFICATION / DOCUMENTATION ONLY  
Created: 2026-09-25

Purpose: define exactly what visual references should be generated or collected for the first Settlement 01 building families before modeling/runtime integration.

## Current sheets

1. `REF_01_COMMUNITY_HALL_VISUAL_SPEC.md`
2. `REF_02_RESIDENCE_TYPE_A_VISUAL_SPEC.md`
3. `REF_03_SOUTH_GATEHOUSE_VISUAL_SPEC.md`

## Required sheet views

Preferred per building:
- front orthographic-style concept
- side concept
- rear concept
- top/roof concept
- 3/4 perspective
- simple cutaway/interior concept where useful
- material/detail strip
- modular-parts strip

## Art-direction law

References must support:
- first-person readability
- pixel-styled real 3D
- compact believable proportions
- original IP
- modular construction
- restrained detail
- mobile performance

## Technical-truth firewall

Generated/reference images may define:
- silhouette
- visible part arrangement
- color/material direction
- module ideas
- facade hierarchy

They do not define automatically:
- exact collision
- hidden framing
- engineering
- exact dimensions
- gameplay anchors
- UVs
- final text/signage.

Dimensions come from building blueprints first.

## Promotion path

VISUAL_REFERENCE_SPEC
→ generated/collected reference
→ observed/inferred annotation
→ model sheet
→ graybox
→ runtime visual
→ automated validation
→ device visual acceptance.
