# Pixel RPG — Authority Lock

Status: ACTIVE / CREATOR-AUTHORITATIVE
Branch: `pixel-rpg`
Effective: 2026-09-24
Owner: Sol — issue #29
Parent: issue #28

## Authority rule

Pixel RPG is the only active project authority for this repository branch.

For current design, visual direction, camera, sprites, assets, controls, gameplay presentation, runtime architecture, and continuation decisions, use only:
1. current explicit creator instruction;
2. current `pixel-rpg` source, tests, and build/device evidence;
3. current Pixel RPG authority documents on this branch;
4. bounded current Pixel RPG package documentation that current source/tests still support.

Archived, quarantined, superseded, unrelated, or historical material is non-authoritative unless current Pixel RPG source/tests prove a specific technical dependency. A technical dependency never grants design, visual, camera, sprite, asset, or project-direction authority.

## No-reference barrier

Do not use non-current material to infer or propose Pixel RPG:
- camera perspective or FOV;
- player presentation;
- sprite or ViewModel art;
- weapons or combat identity;
- movement mechanics;
- package/runtime structure;
- world design;
- UI/HUD direction;
- asset-selection decisions.

Do not recursively open archived or quarantined material unless a current bounded task explicitly requires provenance or compatibility evidence.

## First-person lock

Pixel RPG exploration is first-person by creator directive. Superseded presentation implementations remain historical evidence only and cannot override current first-person authority.

## Preservation rule

Do not delete proven gameplay/domain systems merely because their history predates the current presentation direction. Preserve current working behavior unless a bounded task and current evidence justify replacement.

## Quarantine rule

Drive material marked archived/non-authoritative stays outside the active Pixel RPG authority chain. No active bootstrap instruction may treat quarantined Drive material as required reading, asset authority, or design input.

## Current split of responsibility

- Issue #29 — Sol: authority/documentation only.
- Issue #30 — Nexo: canonical first-person hands PNG integration, tests, and Android export only.
- Issue #28 — common pipeline/root checkpoint.

Sol must not modify issue #30 runtime/ViewModel implementation while this split is active. Nexo must not redefine project authority while executing issue #30 except for implementation/build evidence.

## Audit result — 2026-09-24

Active authority chain reconciled:
- `START_HERE_NEW_CHAT.md`;
- `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`;
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `DOCUMENTATION_INDEX.md`;
- `PIXEL_RPG_VISUAL_DIRECTION.md`;
- this authority lock.

The active documents now describe Pixel RPG directly instead of relying on unrelated project names as rejection/comparison context.

`docs/70_handoff/README.md` explicitly classifies the handoff directory as historical continuity evidence and prevents a handoff from becoming current authority merely because it exists there. Historical handoff filenames/content are retained for traceability and truthful evidence.

Drive quarantine was verified directly on 2026-09-24. Archived historical material is marked non-authoritative and is not required by the active bootstrap.

This task is documentation-only. It changes no gameplay, camera, input, collision, combat, state, sprite rendering, or ViewModel implementation.

— Sol
