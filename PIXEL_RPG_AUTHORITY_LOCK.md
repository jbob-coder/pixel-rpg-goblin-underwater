# Pixel RPG — Authority Lock

Status: ACTIVE / CREATOR-AUTHORITATIVE / MIGRATION-RECONCILED  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Authority rule

Pixel RPG is the active project authority.

Current implementation authority comes from:

1. current explicit creator instruction;
2. live production `main`;
3. exact implementation owner;
4. exact tests;
5. exact same-SHA build/device evidence;
6. current GitHub issue register;
7. current migration/stale-document audit;
8. narrow current documentation;
9. historical evidence only for provenance.

The old `jbob-coder/Chatgptjuegolpcal@pixel-rpg` repository/branch is not current implementation authority.

## No-reference barrier

Archived, quarantined, superseded, unrelated, or historical material must not define current:

- camera/FOV;
- player presentation;
- ViewModel art;
- controls;
- movement;
- combat identity;
- package/runtime structure;
- world design;
- implementation priorities;
- build state.

Historical material may be opened when a bounded task needs provenance or compatibility evidence.

A technical dependency does not grant design authority.

## First-person lock

Pixel RPG exploration/presentation is first-person unless an explicit current creator decision changes it.

Preserve:

- direct first-person `Camera3D`;
- camera-relative movement;
- independent look;
- hidden third-person presentation body;
- current targeting;
- current collision/state ownership;
- Combat Bridge 002 no-attack boundary;
- deterministic combat/anatomy/status systems.

Do not delete proven domain systems because their history predates the current presentation.

## Presentation/gameplay boundary

Visible art may be replaced through verified asset lineage.

Gameplay collision may remain invisible technical support.

Presentation must not own:

- authoritative collision;
- targeting truth;
- combat resolution;
- save state;
- durable world/player state.

## Documentation split

`documentation` is documentation-only.

Do not put gameplay/runtime implementation changes on it.

Production runtime work belongs against current `main`.

## Current issue authority

Master:
- #20.

Priority tracks include:
- #1 prototype decomposition;
- #2 geometry/collision ownership;
- #9 player/touch/camera separation;
- #21 documentation migration cleanup.

Old #28/#29/#30 task ownership is historical and must not control current work.

## Current navigation

Bootstrap:
`START_HERE_NEW_CHAT.md`

Index:
`DOCUMENTATION_INDEX.md`

Repository map:
`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

Master scan/reference:
`docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`

Migration audit:
`docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md`

This file is an authority barrier, not runtime/device evidence.
