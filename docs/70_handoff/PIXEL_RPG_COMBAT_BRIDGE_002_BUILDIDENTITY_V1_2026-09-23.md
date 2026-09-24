# Pixel RPG — First-Person Combat Bridge 002 + BuildIdentity v1 — 2026-09-23

Status: IMPLEMENTED / FIRST-PERSON VERIFIED / BRIDGE 002 VERIFIED / BUILDIDENTITY V1 VERIFIED / ANDROID BUILD VERIFIED / DRIVE ARCHIVED / PHONE VERIFICATION OPEN
Branch: `pixel-rpg`

## Authority

Pixel RPG exploration and same-world combat presentation are creator-authoritative **FIRST-PERSON**.

All older handoff statements that make third-person camera/exploration authoritative are **STALE / SUPERSEDED**. Historical source/build/test evidence remains valid for what those checkpoints actually proved; it is not retroactively rewritten as first-person evidence.

Current presentation authority:
- `PIXEL_RPG_VISUAL_DIRECTION.md`;
- `docs/70_handoff/PIXEL_RPG_FIRST_PERSON_REALIGNMENT_2026-09-23.md`.

Historical handoffs with third-person phrasing whose camera authority is now stale/superseded:
- `docs/70_handoff/PIXEL_RPG_BRANCH_RECOVERY_2026-09-16.md`;
- `docs/70_handoff/PIXEL_RPG_COMBAT_BRIDGE_001_THIRD_PERSON_TARGETING_PREVIEW_2026-09-21.md`;
- `docs/70_handoff/PIXEL_RPG_PIXEL_CAMERA_HUD_POLISH_2026-09-16.md`;
- `docs/70_handoff/PIXEL_RPG_PROTOTYPE_001_2026-09-16.md`;
- `docs/70_handoff/PIXEL_RPG_VISUAL_PACK_002_HUNTER_MONSTER_READABILITY_2026-09-21.md`;
- `docs/70_handoff/PIXEL_RPG_VISUAL_PACK_003_HUD_LAYOUT_ALIGNMENT_2026-09-21.md`;
- `docs/70_handoff/PIXEL_RPG_WORLD_COMPOSITION_PACK_001_2026-09-20.md`;
- `docs/70_handoff/PIXEL_RPG_WORLD_PACK_004_ENTERABLE_SMITH_VERTICAL_SLICE_2026-09-21.md`.

Abandoned Monster Choice RPG, WorldLife RPG and standalone Shooter RPG are not current Pixel RPG authority.

## Combat Bridge 002 exact behavior

Gameplay implementation source:
`31446466f10840bc3820a03b8d11d17a5433a149`.

Bridge 002:
- preserves the direct first-person Camera3D path;
- preserves Bridge 001 OBSERVE/ENGAGE/target-selection semantics;
- adds collidable current-world domain monster authority `monster_r01_m01_0001` at the live Mudcrest position;
- exposes explicit START COMBAT DOMAIN only after target lock;
- initializes only current `CombatTurnShellRuntime` and `MudcrestAnatomyRuntime`;
- exposes initialized round/resources/anatomy state in the targeting UI;
- preserves Hunter and live Mudcrest transforms;
- keeps first-person look available.

Explicitly not implemented in this slice:
- legacy tactical movement integration;
- hunter attack/combat-resolution runtime integration;
- AP/Stamina spending;
- damage;
- actor teleport;
- legacy Region-01 coordinate migration.

## BuildIdentity v1 continuation

Latest Android-build-verified source:
`160d12cfabde025a383dd50f9bfcbb0e51ae87c6`.

The only source change after the Bridge 002 gameplay commit is additive CI provenance: future build evidence now contains `pixel_rpg.build_identity.v1`.

Verified run:
- workflow run `35915818722` — SUCCESS;
- job `107366883423` — SUCCESS;
- Godot `4.7.2.stable.official.ed1daf0bf`;
- APK artifact ID `10774987608`;
- APK artifact digest `sha256:1ababd79b27fbe9644a06a95ca3534fb4ae847547d0b26cc52179526e16234d2`;
- build-evidence artifact ID `10775077410`;
- build-evidence digest `sha256:52810c42f13f9c80534247a429fc6b567bbe9923c20098d15ff6193e13896151`.

APK:
- filename `PixelRPG-combat-bridge-002-debug.apk`;
- size `58,039,909` bytes;
- SHA-256 `515148bb8ed35076664ef612f6b678f086929e75ecb34709014f018e665e5a55`.

The APK hash was independently recomputed after downloading the workflow artifact and matched BuildIdentity exactly.

## Verification gates

PASS on source `160d12cfabde025a383dd50f9bfcbb0e51ae87c6`:
- Godot import/parse;
- AppShell smoke;
- prototype scene smoke;
- first-person realignment runtime gate;
- Visual Pack 002 runtime gate;
- Visual Pack 003 HUD gate;
- World Pack 004 enterable-smith gate;
- Combat Bridge 001 first-person targeting gate;
- Combat Bridge 002 domain-bootstrap no-attack gate;
- deterministic combat turn-shell regression;
- hunter-attack domain regression;
- Mudcrest anatomy regression;
- generic status application/timing regressions;
- Android debug export;
- package-size gate;
- immutable APK artifact upload;
- BuildIdentity finalization;
- build-evidence artifact upload.

## APK size finding

The APK is intentionally not padded.

Measured package size is `58,039,909` bytes. Package inspection shows most compressed bytes are Godot Android native libraries for both `arm64-v8a` and `armeabi-v7a`; current production textures/audio/animation remain comparatively small. APK size is not a progress metric and does not prove installed footprint.

## Google Drive immutable revision

Path:
`Pixel RPG/Builds/First Person/2026-09-23_run-35915818722_buildidentity-v1/`

IDs:
- folder: `1zdvN-E1dJt8tgVV4c8g_tofS1eKaj172`;
- canonical APK: `1AHIq0nhFfzOogk6movCyrPuw1HING4xX`;
- BuildIdentity JSON: `1_ws3B8lMLjAtvbkTxLrEbz2EPKe0pPRX`;
- BuildIdentity Markdown: `1hnWe046bDrwixu15ZAm_s1Ba5nhb-fux`;
- raw CI evidence: `1tWJx6JkOxVKB7tBUwbSQZMuzEwXAbQ5a`;
- device checklist: `16jfx3X8rxEEqd1hUhDHytEx92iXQ9Kyl`.

A connector retry created a second APK upload. It was preserved and renamed `PixelRPG-combat-bridge-002-debug_DUPLICATE_UPLOAD_NOT_CANONICAL.apk`; it is not the canonical build reference.

## Truth boundary

VERIFIED:
- source integration;
- first-person camera regression;
- Bridge 002 no-attack domain bootstrap;
- preserved domain regressions;
- Android export;
- package-size gate;
- source/run/job/artifact/APK provenance;
- Drive archival.

NOT VERIFIED:
- physical Android installation;
- no-black-screen result on target hardware;
- touch feel;
- camera clipping/comfort on phone;
- HUD safe-area acceptance on target hardware;
- sustained FPS/heat;
- installed footprint;
- final visual quality.

## Issue status

Closed with evidence:
- #5 BuildIdentity/source authority;
- #8 Combat Bridge 002 no-attack bootstrap.

Open P0:
- #6 prototype decomposition;
- #7 runtime/state ownership;
- #9 geometry/collision ownership.

## Next bounded piece

`PIXEL_RPG_STATE_OWNERSHIP_CONTRACT_001` — issue #7.

Define current-world state ownership and serialization eligibility without a giant singleton. Preserve existing deterministic combat owners and all first-person/Bridge 002 behavior. Do not add attack/damage or legacy tactical coordinates in this slice.
