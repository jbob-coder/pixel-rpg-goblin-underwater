# PROJECT HANDOFF — Pixel RPG

Status: ACTIVE / FIRST-PERSON / POST-MIGRATION DOCUMENTATION RECONCILIATION  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## CURRENT_OBJECTIVE

Maintain a reliable current authority chain while production development continues on `main`.

Current documentation task:
- reconcile stale migrated bootstrap/status documents on `documentation`;
- keep historical evidence intact where useful;
- prevent new sessions from returning to the old repository/branch or obsolete issue map.

Current implementation work remains governed by live `main` and the current GitHub issue register.

## CURRENT_STATE

Pixel RPG is first-person.

Current production boot:

`game/project.godot`
→ `game/scenes/app_shell.tscn`
→ `game/scripts/app_shell.gd`
→ `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`.

Current source preserves:

- direct first-person `Camera3D`;
- camera-relative movement;
- independent look;
- hidden third-person presentation body;
- explicit camera/touch/player-motor decomposition;
- compact current-world settlement/trail;
- enterable smith;
- first-person targeting;
- Combat Bridge 002 no-attack bootstrap;
- deterministic combat/anatomy/status domain systems;
- state ownership;
- Android CI/export.

## LAST VERIFIED RUNTIME BASELINE

Audited runtime source:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Commit:

`refactor: centralize first-person camera pose state`

Canonical workflow:

`36082533109` — SUCCESS

Verification job:

`107907382620` — SUCCESS

Android export job:

`107907562399` — SUCCESS

This evidence applies to that exact runtime SHA.

Documentation-only commits after that SHA do not create a new runtime verification state.

## COMPLETED / CONFIRMED

Confirmed current foundations include:

- first-person camera realignment;
- canonical hands PNG live in the ViewModel;
- first-person ViewModel presentation-only boundary;
- mobile touch/movement/look ownership decomposition;
- world-base/path/settlement/gate/trail/actor decomposition slices;
- enterable smith with real doorway/interior collision;
- image-derived runtime presentation assets;
- Mudcrest targeting/anatomy integration;
- Combat Bridge 002 bootstrap;
- deterministic Hunt-01 combat/anatomy/status regressions;
- state ownership contract;
- canonical Android CI/export.

## CURRENT COMBAT BOUNDARY

The current first-person boot scene does not expose the complete Hunt-01 combat loop.

Current flow:

Observe/Engage
→ targeting preview
→ anatomy group select/lock
→ Combat Bridge 002
→ initialize anatomy + turn shell
→ no attack yet.

The richer Hunt-01 tracking/encounter/combat implementation remains real and tested but is not the current app boot path.

Future attack integration requires an explicit current-world spatial adapter rather than blindly reusing Region-01 tactical coordinates.

## CURRENT WORK REGISTER

Master:
- #20 — Pixel RPG first-person foundation, settlement and current-world combat.

Important current tracks:
- #1 — safe prototype decomposition;
- #2 — geometry/collision ownership;
- #9 — player/touch/camera separation;
- #21 — stale authority/document migration cleanup.

## DOCUMENTATION WORK COMPLETED ON `documentation`

- created/reconciled repository “Where Is What” map;
- added repository scan master reference;
- corrected `START_HERE_NEW_CHAT.md`;
- corrected `DOCUMENTATION_INDEX.md`;
- reconciled this handoff;
- reconciled active authority barrier.

Remaining stale documents should be corrected one at a time with live-source corroboration.

## IMPORTANT DECISIONS

- Do not restart the game.
- Do not replace proven domain systems merely to change presentation.
- Presentation does not own gameplay truth.
- Collision and visible art are separate concerns.
- Generic visual doors do not imply traversable buildings.
- Use the enterable smith as the strongest current building-pattern reference.
- Current-world combat needs an adapter to proven domain systems, not a duplicate combat engine.
- Documentation-only changes do not prove runtime behavior.
- Build success does not prove physical-device acceptance.
- Use free/no-billing-risk tooling unless explicitly authorized otherwise.

## KNOWN RISKS

- generic buildings still have monolithic collision;
- collision ownership varies by asset family;
- the main prototype still owns significant orchestration;
- some legacy procedural helpers remain;
- full current-world combat integration is incomplete;
- broad save/load is not implemented;
- stale migrated docs can misdirect future work;
- `main` is not currently protected by required status checks;
- GitHub CI artifacts expire after seven days;
- debug signing does not yet prove durable production update identity;
- physical Android visual/touch/performance acceptance remains separate.

## NEXT_ACTION

Continue documentation reconciliation on `documentation`, next prioritizing:
1. `EVOLVE_ALIGNMENT.md`;
2. root `README.md`;
3. `PIXEL_RPG_VISUAL_DIRECTION.md` stale branch/status fields;
4. old work-register/status documents where current-source claims conflict.

Do not modify gameplay/runtime code on the documentation branch.
