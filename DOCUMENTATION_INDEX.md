# Pixel RPG — Documentation Index

Status: ACTIVE GLOBAL MAP / FIRST-PERSON / CURRENT AUTHORITY ONLY
Last reconciled: 2026-09-24
Branch: `pixel-rpg`

## Mandatory read order

1. `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`
2. `START_HERE_NEW_CHAT.md`
3. `EVOLVE_ALIGNMENT.md`
4. `PIXEL_RPG_VISUAL_DIRECTION.md`
5. `PROJECT_HANDOFF.md`
6. newest relevant Pixel RPG handoff under `docs/70_handoff/`
7. exact owning source/data/tests/workflow for the bounded task.

Fetch live `pixel-rpg` HEAD before reconstruction and re-check it before any write. Never mix evidence from different source revisions.

## Authority boundary

Only current Pixel RPG documentation, current source/tests, current build evidence, and explicit creator instructions participate in the active authority chain.

Archived, quarantined, superseded, or unrelated project material is excluded from bootstrap and design authority. Historical material may remain in repository/Drive history for provenance or for a technical dependency proven by current source/tests, but it cannot direct camera, presentation, sprites, gameplay identity, world design, or implementation priorities.

## Current presentation authority

`PIXEL_RPG_VISUAL_DIRECTION.md` owns current player-facing presentation direction:
- first-person eye-height exploration;
- pixel-styled real 3D;
- Android landscape-first controls;
- left-stick movement plus independent right-look;
- compact connected physical spaces;
- same-world monster combat;
- readable Android HUD and interaction presentation;
- approved image-derived assets replacing duplicated visible placeholders only after parity verification.

## Current bootstrap authority

`START_HERE_NEW_CHAT.md` is the canonical new-session bootstrap.

`docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md` is the explicit no-reference barrier.

`EVOLVE_ALIGNMENT.md` records current operating law, state ownership, verification boundaries, cost/storage constraints, and the current work split.

`PROJECT_HANDOFF.md` records the current verified baseline, active work, blockers, and next actions.

## Current work split

Issue #28: master pipeline.

Issue #29: authority/document cleanup only.

Issue #30: canonical first-person hands PNG → live ViewModel integration + technical verification.

Do not merge responsibilities between those tracks in documentation or implementation claims.

## Canonical first-person hands

Canonical asset name:
`pixel_rpg_hunter_fp_hands_neutral_r001.png`.

Repository source-identity records live under:
`game/assets/characters/first_person/`.

Live viewmodel scene:
`game/assets/characters/first_person_viewmodel_01.tscn`.

Owning verification:
- `game/tests/pixel_rpg_visual_pack_009_first_person_viewmodel_test.gd`;
- `game/tests/pixel_rpg_first_person_realignment_runtime_test.gd`;
- Combat Bridge 002 gate;
- State Ownership gate;
- deterministic combat/anatomy/status regressions;
- Android export/package-size gate.

The hands asset is presentation-only and must not own gameplay state, collision, input, targeting, or combat.

## Latest fully recorded visual baseline

Visual Pack 011 Direct Concept-Photo PNG Assets:
- source SHA `93978e1947fe8cffaeb0876574d8d761dcad90b2`;
- workflow `35947488962` — SUCCESS;
- job `107468585038` — SUCCESS;
- Godot `4.7.2.stable.official.ed1daf0bf`;
- APK `PixelRPG-visual-pack-011-direct-photo-assets-debug.apk`;
- size `58,290,596` bytes;
- SHA-256 `bec6ba206a293edab5ab6b5220090e444b110a3521f7f8a48c6e9b6cade40c7b`.

Owning art docs:
- `docs/40_art/PIXEL_RPG_VISUAL_PACK_011_DIRECT_PHOTO_ASSETS.md`;
- `docs/40_art/PIXEL_RPG_VISUAL_PACK_011_CONCEPT_PHOTO_SPRITES.md` for historical Pack 011 implementation detail;
- `docs/40_art/PIXEL_RPG_VISUAL_PACK_010_IMAGE_DERIVED_ASSETS.md` for prior image-derived material lineage.

Live concept-derived environment PNG directory:
`game/assets/environment/starting_area/concept_photo_sprites_011/`.

## Current technical authorities

State ownership:
- `docs/50_technical/persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`;
- `game/scripts/state/pixel_rpg_state_ownership_contract.gd`;
- `game/tests/pixel_rpg_state_ownership_contract_test.gd`.

First-person runtime:
- `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`;
- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`;
- `game/tests/pixel_rpg_first_person_realignment_runtime_test.gd`.

Combat compatibility:
- `game/scripts/presentation/pixel_rpg/pixel_rpg_world_combat_compat.gd`;
- `game/tests/pixel_rpg_combat_bridge_002_domain_bootstrap_test.gd`.

Android build:
- `.github/workflows/pixel-rpg-prototype-android.yml`;
- `game/export_presets.cfg`;
- `game/project.godot`.

## Handoff policy

`docs/70_handoff/` contains both current and historical evidence.

A handoff is not active authority merely because it exists in that directory. Use a handoff only when:
1. its title/scope is explicitly Pixel RPG;
2. it describes the exact current subsystem being worked on;
3. current source/tests still match its claims;
4. no newer current authority supersedes it.

Historical handoffs remain traceable but are not bootstrap authority.

## Manifest policy

Build manifests, package records, and evidence files prove only the source/build they identify. They do not define current presentation or design direction.

When a manifest is retained for legacy domain/provenance evidence, treat it as technical history unless current Pixel RPG source/tests directly depend on it.

## Verification language

Do not collapse these states:
- DESIGNED;
- IMPLEMENTED;
- STATIC_VERIFIED;
- HEADLESS_VERIFIED;
- ANDROID_BUILD_VERIFIED;
- PHONE_RUNTIME_VERIFIED;
- VISUAL_QUALITY_VERIFIED;
- PERFORMANCE_VERIFIED.

A successful CI build does not prove physical-device quality.

## Current unresolved physical evidence

Unless a fresh device record proves otherwise, the following remain unverified for the latest source:
- physical Android install/launch;
- first-person hands visual composition/clipping;
- touch ergonomics;
- safe-area behavior;
- sustained FPS/heat;
- lifecycle behavior;
- installed footprint under the 2 GB cap.
