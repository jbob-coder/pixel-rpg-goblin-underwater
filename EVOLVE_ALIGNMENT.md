# EVOLVE ALIGNMENT — Pixel RPG

Status: ACTIVE / FIRST-PERSON / MIGRATION-RECONCILED ON DOCUMENTATION BRANCH  
Last reconciled: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation cleanup branch: `documentation`

## Operating law

The game is the objective. Documentation exists to preserve authority, ownership, evidence, and continuation.

`READ LIVE STATE → IDENTIFY OWNER → ONE BOUNDED CHANGE → TEST → FIX SAME-LAYER FAILURES → RECORD EVIDENCE → COMMIT → READ BACK`

Current creator direction and current verified repository evidence outrank chat memory, migrated stale documents, superseded handoffs, and historical presentation decisions.

## Active authority

Use this order:

1. current explicit creator instruction;
2. live production `main`;
3. exact implementation owner;
4. exact tests;
5. exact same-SHA build/device evidence;
6. current GitHub issue register;
7. current migration/stale-document audit;
8. narrow owner documentation that still matches source;
9. historical handoffs for provenance only.

The old `Chatgptjuegolpcal@pixel-rpg` repository/branch is not current implementation authority.

## Current creator direction

Pixel RPG is first-person.

Preserve unless a bounded task explicitly changes them compatibly:

- direct active first-person `Camera3D`;
- camera-relative movement;
- independent right-side look;
- hidden third-person presentation body;
- current collision ownership;
- HUD/context interaction;
- first-person targeting;
- Combat Bridge 002 no-attack bootstrap;
- deterministic combat/anatomy/status owners;
- explicit state-ownership boundaries;
- Android landscape build/export pipeline.

Do not replace proven gameplay/domain systems merely to change presentation.

## Current first-person ownership

Current source has already extracted important responsibilities into dedicated owners:

- camera math;
- camera yaw/pitch state;
- player motion math;
- player motor execution;
- touch math;
- touch mutable state;
- HUD layout math;
- minimap mapping.

Continue decomposition mechanically and in small slices. Do not duplicate authoritative mutable state back into the host to satisfy stale assumptions.

## Visual direction

Target presentation remains:

- pixel-styled real 3D;
- compact physical spaces;
- readable Android silhouettes;
- image-derived presentation through explicit lineage;
- collision/gameplay authority independent from visible art;
- duplicated visible placeholders removed only after parity verification.

Canonical first-person hands are already live in:

`game/assets/characters/first_person_viewmodel_01.tscn`

using:

`game/assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`.

Older “hands integration pending” statements are stale.

## Current-world combat rule

The current compact first-person world exposes targeting plus Combat Bridge 002 domain bootstrap.

The proven Hunt-01 domain is richer than current player-facing integration.

Future attack/tactical integration must use an explicit current-world spatial adapter. Do not let old Region-01 tactical coordinates teleport or redefine current compact-world authority.

## State ownership law

One authoritative owner per mutable datum.

Current principles:

- world transforms → world/runtime owners;
- combat resources/scheduler → combat domain owner;
- monster anatomy → anatomy owner;
- touch/camera/targeting/context → transient control owners;
- HUD/minimap/highlights → presentation only;
- local preferences → separate from gameplay saves;
- future player/world/inventory/NPC/economy durable data → bounded durable owners, not one giant singleton.

## Persistence law

Broad current-world save/load is not yet implemented.

Future persistence must serialize stable authoritative snapshots, not presentation widgets or callback state.

## Storage and cost law

`TOTAL_PLAYER_REQUIRED_GAME_STORAGE_CAP = 2 GB`  
`TOTAL_PLAYER_REQUIRED_GAME_STORAGE_CAP_BYTES = 2000000000`

Required runtime downloads count toward the same ceiling.

Use free/no-billing-risk tooling for normal development. Do not invoke paid/credit-consuming services without explicit authorization.

## Verification boundaries

Keep separate:

- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

A build does not prove physical phone quality.

## Current documentation references

Repository location map:

`docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`

Master scan/reference:

`docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`

Migration audit:

`docs/00_authority/PENDING_CORROBORATION_AUDIT_2026-09-24.md`

## Continuation rule

Before implementation:

1. fetch current production `main`;
2. record exact HEAD;
3. read the current owner source and tests;
4. inspect the current issue;
5. make the smallest compatible change;
6. run focused and required regression gates;
7. record failures instead of weakening gates;
8. commit only claims proven by source/evidence;
9. read back resulting source;
10. update documentation only with facts actually proven.

For documentation-only reconciliation, use `documentation` and do not modify runtime/gameplay code there.
