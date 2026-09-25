# 30_content — Reusable Content Packages

Status: ACTIVE CONTENT MAP / MUDCREST HAS LIVE RUNTIME DESCENDANTS / OTHER CONTENT MIXED DESIGN + PROTOTYPE  
Last reconciled: 2026-09-25

## Purpose

Own authored entity/content packages that configure shared gameplay systems without redefining generic laws.

Current areas:

- `hunters/`;
- `monsters/`.

## Hunter Base 01

`hunters/HUNTER_BASE_01/`

This remains a reusable historical/prototype hunter body/reference package.

Its old aerial-readability assumptions are not current first-person camera authority.

Current first-person visible hands/ViewModel live under:

`game/assets/characters/first_person/`

and:

`game/assets/characters/first_person_viewmodel_01.tscn`.

## Monster 01 — Mudcrest Raker

Front door:

`monsters/MONSTER_01/README.md`

Current live descendants include:

- Mudcrest visual/anatomy target groups;
- deterministic anatomy integrity;
- Head Sweep runtime;
- Tail Sweep runtime;
- wound/contact classification;
- generic status integration;
- tracking/encounter continuity;
- current-world targeting/Combat Bridge bootstrap.

Current source:

`game/scripts/gameplay/monsters/monster_01/`

Current presentation:

`game/assets/monsters/mudcrest_visual.tscn`

## Still incomplete / design-only areas

Do not treat the content package as proof that all planned behavior is implemented.

Still incomplete or future includes:

- structural crack/break/sever thresholds;
- detached-part behavior;
- broader Monster move set;
- full current-world combat integration;
- Berserk implementation;
- complete defeat/escape/reacquisition behavior;
- harvest/inventory/crafting integration;
- final balance.

## Ownership law

Content packages may configure:

- anatomy;
- attacks;
- behavior parameters;
- Crystal/mutation design;
- harvest capacities;
- visual references.

They may not redefine:

- generic combat scheduler/resource laws;
- state ownership;
- persistence architecture;
- world collision;
- UI authority.

Stable IDs remain preferable to display-name identity.

## Evidence law

Use content docs for design intent and local configuration.

Use live source/tests for implementation status.
