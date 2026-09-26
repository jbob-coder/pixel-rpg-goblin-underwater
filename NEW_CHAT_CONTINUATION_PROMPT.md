# Pixel RPG — New Chat Continuation Prompt

Use this launcher in a new ChatGPT conversation when continuing active Pixel RPG development.

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation-only reconciliation branch: `documentation`

Active game: **Pixel RPG**

WorldLife and the standalone Shooter RPG are not current implementation authority.

## FIRST ACTION — MANDATORY

Before coding, changing assets, balance, architecture, or build configuration:

1. fetch live `main` and record exact HEAD;
2. read `START_HERE_NEW_CHAT.md`;
3. read `DOCUMENTATION_INDEX.md`;
4. read `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`;
5. read `docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`;
6. read the exact owning source/tests for the bounded task;
7. inspect the current GitHub issue for that subsystem;
8. use `docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md` if an older document conflicts;
9. re-check `main` HEAD before any implementation write;
10. never mix evidence from different revisions.

## AUTHORITY ORDER

1. current explicit creator instruction;
2. live production `main`;
3. exact implementation owner;
4. exact tests;
5. exact same-SHA CI/build/device evidence;
6. current GitHub issue register;
7. migration/stale-document audit;
8. narrow current documentation;
9. historical handoffs for provenance only.

Do not return to `jbob-coder/Chatgptjuegolpcal@pixel-rpg` for current implementation work. That repository/branch is migration history.

## CURRENT PLAYER-FACING IDENTITY

Pixel RPG is:

**an Android-first first-person pixel-styled real-3D monster-hunting RPG with physical exploration, mobile move/look controls, anatomy-focused combat, harvesting, and persistent world/NPC consequences.**

Preserve:

- direct first-person `Camera3D`;
- camera-relative movement;
- independent right-side look;
- hidden third-person presentation body;
- current collision ownership;
- first-person ViewModel;
- canonical hands PNG;
- HUD/context interaction;
- targeting;
- Combat Bridge 002 no-attack bootstrap;
- deterministic combat/anatomy/status domain owners;
- state ownership;
- Android landscape export pipeline.

Do not replace proven domain systems merely to change presentation.

## CURRENT BOOT PATH

`game/project.godot`
→ `game/scenes/app_shell.tscn`
→ `game/scripts/app_shell.gd`
→ `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`.

The richer Region-01 Hunt-01 path remains real/tested code but is not the current application boot scene.

## CURRENT COMBAT BOUNDARY

Current first-person flow:

Observe/Engage
→ targeting preview
→ anatomy group selection/lock
→ Combat Bridge 002
→ initialize anatomy + combat turn shell
→ no attack yet.

The next combat work must adapt current-world physical/spatial state into the proven deterministic domain. Do not blindly transplant old Region-01 tactical coordinates.

## CURRENT WORK REGISTER

Master:
- #20 — first-person foundation, settlement, and current-world combat.

Priority tracks:
- #1 — safe prototype decomposition;
- #2 — geometry/collision ownership;
- #9 — player/touch/camera separation;
- #21 — documentation/authority migration cleanup.

## VERIFIED RUNTIME BASELINE

Audited runtime source:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Canonical workflow:

`36082533109` — SUCCESS

Verification job:

`107907382620` — SUCCESS

Android export job:

`107907562399` — SUCCESS

This proves automated/headless/Android-build status for that exact SHA only.

## REQUIRED REPORT FORMAT WHEN RESUMING

Report:

- repository;
- branch;
- live HEAD;
- exact objective;
- verified current state;
- exact owner files;
- exact tests/gates;
- current issue;
- blockers;
- open questions;
- expected changes;
- protected behavior;
- contradictions/stale docs encountered.

If no genuine blocker exists, continue the bounded task after reconstruction without asking for repeated permission.
