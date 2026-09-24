# EVOLVE ALIGNMENT — Pixel RPG

Status: ACTIVE / FIRST-PERSON / CURRENT AUTHORITY ONLY
Last reconciled: 2026-09-24
Branch: `pixel-rpg`

## Operating law

The game is the objective. Documentation exists to preserve authority, ownership, evidence, and continuation.

`READ LIVE STATE → VERIFY → ONE BOUNDED CHANGE → TEST → FIX SAME-LAYER FAILURES → RECORD EVIDENCE → COMMIT → READ BACK`

Current explicit creator direction and current repository evidence outrank chat memory, archived material, superseded handoffs, and historical presentation decisions.

## Active authority

Pixel RPG is the only active project authority on this branch.

Authority order:
1. current explicit creator instruction;
2. current `pixel-rpg` source/tests/build/device evidence;
3. `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`;
4. `START_HERE_NEW_CHAT.md`;
5. `PIXEL_RPG_VISUAL_DIRECTION.md`;
6. current `PROJECT_HANDOFF.md` and this alignment;
7. narrow owner/package documentation.

Archived or quarantined material may be consulted only for provenance or for a technical dependency that is demonstrably referenced by current Pixel RPG source/tests. It cannot define current camera, visual identity, sprite selection, world presentation, gameplay identity, build state, or implementation priorities.

## Current creator direction

Pixel RPG uses first-person exploration and presentation.

Preserve unless a bounded current task explicitly changes them compatibly:
- active direct `Camera3D` first-person path;
- camera-relative movement and independent right-side look;
- hidden non-first-person presentation body;
- current collision ownership;
- HUD and interaction anchors;
- targeting and Combat Bridge 002 no-attack bootstrap;
- State Ownership 001 boundaries;
- deterministic combat/anatomy/status domain behavior;
- Android landscape build/export pipeline.

Do not replace proven gameplay/domain systems merely to change presentation.

## Visual direction

Target presentation:
- pixel-styled real 3D;
- compact physical spaces rather than menu-only travel;
- readable world geometry and silhouettes on Android phone displays;
- image-derived presentation assets promoted only through explicit Pixel RPG asset lineage;
- gameplay/collision geometry may remain invisible technical support while approved presentation art becomes visible;
- duplicated procedural presentation is removed only after parity verification.

Primary visual authority: `PIXEL_RPG_VISUAL_DIRECTION.md`.

Current approved concept-image lineage is recorded in the Visual Pack 010/011 documentation and tests. Visible text or names inside concept imagery are not automatically game canon.

## Current canonical hands work

Master task: issue #28.

Authority/document track: issue #29.
Technical integration track: issue #30.

Canonical first-person presentation asset:
`pixel_rpg_hunter_fp_hands_neutral_r001.png`.

The canonical source is presentation-only. It must not own:
- physics;
- collision;
- input;
- targeting;
- combat resolution;
- persistence;
- durable state.

The repository currently records canonical-source identity under:
`game/assets/characters/first_person/`.

The live integration is not complete until the PNG is actually wired into `game/assets/characters/first_person_viewmodel_01.tscn` and all required gates pass.

## Latest build-verified visual baseline

Visual Pack 011 Direct Concept-Photo PNG Assets remains the latest fully recorded visual baseline prior to the current hands integration.

Verified source SHA: `93978e1947fe8cffaeb0876574d8d761dcad90b2`.
Workflow run: `35947488962` — SUCCESS.
Job: `107468585038` — SUCCESS.
Godot: `4.7.2.stable.official.ed1daf0bf`.
APK: `PixelRPG-visual-pack-011-direct-photo-assets-debug.apk`.
APK size: `58,290,596` bytes.
APK SHA-256: `bec6ba206a293edab5ab6b5220090e444b110a3521f7f8a48c6e9b6cade40c7b`.

That baseline verifies seven standalone RGBA concept-derived environment PNG assets under:
`game/assets/environment/starting_area/concept_photo_sprites_011/`.

Those assets are presentation-only; existing world/collision geometry remains gameplay authority.

## First-person verified foundation

The first-person realignment, Pack 009 viewmodel, Combat Bridge 002, State Ownership 001, targeting, smith interaction, deterministic combat/anatomy/status regressions, and Android build pipeline have build/headless evidence in their owning handoffs/tests.

Do not convert historical build evidence into a claim about the current source without a fresh gate.

## Storage and cost law

`TOTAL_PLAYER_REQUIRED_GAME_STORAGE_CAP = 2 GB`
`TOTAL_PLAYER_REQUIRED_GAME_STORAGE_CAP_BYTES = 2000000000`

Required runtime downloads count toward the same ceiling. Development-only source/repository/CI files do not.

Use free/no-billing-risk tooling for normal development. Do not invoke paid or credit-consuming services without explicit creator authorization.

## State ownership law

Durable mutable state must have one declared owner.

Current principles:
- combat resources/turn state remain with combat runtime/domain owners;
- creature anatomy integrity remains with anatomy runtime/domain owners;
- world transforms remain world-runtime state;
- camera/input/targeting/context latches remain transient control state;
- HUD and visual nodes present state but do not own durable gameplay truth;
- future durable player/world/inventory/NPC/economy data should use bounded owner namespaces rather than a giant singleton.

## Verification boundaries

Keep these states separate:
- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

Current physical Android acceptance for the latest visual/hands work remains unverified unless a current device record explicitly proves otherwise.

Required device evidence includes install, launch/no black screen, landscape framing, first-person hands visibility/clipping, touch movement/look, HUD safe area, targeting, sustained FPS, heat, and lifecycle behavior.

## Continuation rule

Before every new implementation slice:
1. fetch current `pixel-rpg` HEAD;
2. read the current owner files and tests;
3. make the smallest compatible change;
4. run the exact relevant gates;
5. record failures as evidence instead of weakening gates;
6. commit only verified source claims;
7. update authority/handoff docs only with facts proven by the resulting source/evidence.
