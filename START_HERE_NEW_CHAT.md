# START HERE — Pixel RPG — Canonical Bootstrap

Status: ACTIVE / FIRST-PERSON / CURRENT REPOSITORY AUTHORITY
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`
Production branch: `main`

Documentation-cleanup branch: `documentation`
Purpose of `documentation`: reconcile and stage documentation only. It is not a replacement runtime branch and does not redefine gameplay source authority.

Current repository navigation map:
`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

Known migration/stale-document audit:
`docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md`

## Canonical authority barrier

Pixel RPG is the active game authority.

The old repository `jbob-coder/Chatgptjuegolpcal` and its `pixel-rpg` branch are migration/provenance history, not current implementation authority.

Do not use archived, quarantined, superseded, unrelated, or historical project material as current design or implementation authority merely because it exists in repository history or `docs/70_handoff/`.

Historical material may be consulted only for provenance or for a technical dependency that current source/tests demonstrably still use.

## Mandatory bootstrap

1. Fetch live `jbob-coder/pixel-rpg-goblin-underwater@main` and record exact HEAD before implementation work.
2. Read the repository map named above to locate the current owner.
3. Read the exact owning source file(s).
4. Read the exact owning test(s).
5. Read the current GitHub issue for that subsystem.
6. Use exact current CI/build evidence only when it is tied to the same source SHA.
7. Re-check `main` HEAD before any implementation write.
8. Never mix evidence from different revisions.
9. Never weaken a legitimate gate to force success.
10. Never convert CI/build success into a physical-device claim.

Authority order:

current explicit creator instruction  
→ live `main` source  
→ exact implementation owner  
→ exact tests  
→ exact same-SHA build evidence  
→ current GitHub issue register  
→ migration/stale-doc audit  
→ narrow documentation that still matches source  
→ historical handoffs for provenance only.

## Active game identity

Pixel RPG is an Android-first first-person pixel-styled real-3D monster-hunting RPG.

Preserve unless an explicit bounded task changes them compatibly:

- direct first-person `Camera3D` path;
- camera-relative movement;
- independent right-side look;
- hidden third-person presentation body;
- current collision ownership;
- HUD and contextual interaction;
- first-person targeting;
- Combat Bridge 002 no-attack domain bootstrap;
- deterministic combat/anatomy/status domain owners;
- state-ownership boundaries;
- Android landscape export pipeline.

Do not replace proven gameplay/domain systems merely to change presentation.

## Current implementation boundary

The current player-facing boot path is:

`game/project.godot`
→ `game/scenes/app_shell.tscn`
→ `game/scripts/app_shell.gd`
→ `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`.

The richer Region-01 Hunt-01 runtime remains implemented/tested code but is not the current application boot scene.

The current first-person world exposes targeting plus Combat Bridge 002 bootstrap into the combat/anatomy domain. It does not yet expose the complete Hunt-01 attack/reaction/tactical-combat stack to the player.

## Current first-person hands status

Canonical asset:

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`

Live ViewModel:

`game/assets/characters/first_person_viewmodel_01.tscn`

Current source already references the canonical PNG directly and current automated gates cover the ViewModel/first-person invariants. Older documentation claiming that canonical-hands integration is still pending is stale.

The ViewModel is presentation-only and must not own physics, collision, input, targeting, combat, persistence, or durable state.

## Current work register

Current master issue:
- #20 — Pixel RPG first-person foundation, settlement and current-world combat.

Current high-priority architecture/documentation tracks include:
- #1 — safe decomposition of `PixelRPGPrototype001`;
- #2 — geometry/collision ownership;
- #9 — player/touch/first-person camera controller separation;
- #21 — stale authority/document corroboration after repository migration.

Issue comments are progress evidence, not guaranteed latest-source authority. Live source/tests at current `main` win.

## Verification law

`READ LIVE STATE → VERIFY OWNER → ONE BOUNDED CHANGE → RUN EXACT GATES → FIX SAME-LAYER FAILURES → RECORD EVIDENCE → COMMIT → READ BACK`

Keep these evidence states separate:

- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

Physical Android acceptance requires real device evidence for install/launch, no black screen, landscape framing, first-person composition, touch controls, safe areas, targeting, sustained FPS/heat, lifecycle behavior, and installed footprint.

## Documentation branch rule

Use `documentation` for documentation reconciliation only.

Do not place gameplay/runtime implementation changes on this branch.

A documentation-only commit does not create a new runtime verification state. Runtime/build claims must continue to point to the exact implementation SHA and exact workflow evidence that proved them.
