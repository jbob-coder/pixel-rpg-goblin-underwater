# 10_world/settlements — Settlement Packages

Status: ACTIVE WORLD PACKAGE MAP / DESIGN ONLY
Last reconciled: 2026-09-03

## Purpose

Own settlement-specific spatial/service application of the reusable world and gameplay systems.

The game is the objective. Settlement packages define where services physically exist, how the player reaches them, and how settlement-local availability/interaction state connects to generic gameplay owners without redefining those owners.

## Package map

- `SETTLEMENT_01/` — first frontier hunter settlement.

## Ownership law

Settlement packages may own:
- physical service anchors;
- settlement-local interaction points;
- service availability state;
- return/departure route application;
- district/landmark placement;
- local presentation/streaming requirements;
- local NPC/service schedule application.

They do not own:
- generic inventory quantity;
- generic crafting transaction math;
- equipment modifier formulas;
- combat rules;
- save-system architecture;
- UI-side authority.

Primary root authorities:
- `/FIRST_SETTLEMENT_BLUEPRINT.md`;
- `/MAP_WORLD_SETTLEMENT_STRUCTURE.md`;
- `/WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `/SYSTEM_ARCHITECTURE_BLUEPRINT.md`.

## Current child package

`SETTLEMENT_01/`

Current first-slice service proof:
`SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.
