# Pixel RPG — Combat Bridge 001 Targeting Preview — Historical Checkpoint — 2026-09-21

Status: HISTORICAL / BUILD-VERIFIED FOR SOURCE `977d4004625631d077856b5a49246fbf08313b64` / NOT CURRENT PRESENTATION AUTHORITY
Branch: `pixel-rpg`

> AUTHORITY BARRIER: this file records what the 2026-09-21 Bridge 001 build actually implemented and verified. Its camera/presentation statements are historical evidence only. Current Pixel RPG is first-person; current authority is defined by `START_HERE_NEW_CHAT.md`, `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`, and current source/tests. Do not use this handoff to restore superseded presentation.

## Historical bounded piece

`PIXEL_RPG_COMBAT_BRIDGE_001_THIRD_PERSON_TARGETING_PREVIEW`

## Verified source

`977d4004625631d077856b5a49246fbf08313b64`

Workflow `35566594002`: SUCCESS.  
Job `106229556552`: SUCCESS.

## What Bridge 001 implemented at that source

The verified historical source used a third-person target-acquisition state around the live Mudcrest:
- `OBSERVE` remained available inside 15 m;
- `ENGAGE` appeared inside 8 m;
- ENGAGE opened a touch-safe target panel without switching cameras or moving actors;
- locomotion locked only after explicit ENGAGE;
- right-side camera look remained available outside the targeting panel;
- exiting targeting restored the exploration joystick.

Selectable groups followed the Measured Cut attack authority at that revision:
- `HEAD`;
- `HORN_CREST`;
- `FORELEG_L`;
- `FORELEG_R`;
- `HINDLEG_L`;
- `HINDLEG_R`;
- `DORSAL_PLATES`;
- `TAIL`.

`GENERAL_TORSO` remained the anatomy/body fallback and was not exposed as a selected-part Measured Cut target.

Each selector entry mapped to the Pack 002 Mudcrest visual node. Selection applied a presentation-only highlight; LOCK TARGET recorded the selected visual target only.

## Explicit non-goals at that source

Bridge 001 did NOT:
- invoke the older forced-first-person encounter trigger;
- use older Region-01 absolute encounter coordinates;
- instantiate `CombatTurnShellRuntime`;
- instantiate `MudcrestAnatomyRuntime`;
- spend AP or Stamina;
- apply damage;
- move/teleport the Mudcrest;
- claim full combat integration.

## Runtime files changed by that checkpoint

Modified:
- `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`;
- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`;
- `.github/workflows/pixel-rpg-prototype-android.yml`.

Added:
- `game/tests/pixel_rpg_combat_bridge_001_targeting_preview_test.gd`.

No file under `game/scripts/gameplay/` changed.

## Verification evidence

PASS at source `977d4004625631d077856b5a49246fbf08313b64`:
- Godot `4.7.2.stable` import/parse;
- AppShell smoke;
- prototype scene smoke;
- Pack 002 runtime gate: `24/24`;
- Pack 003 HUD gate: `19/19`;
- Pack 004 enterable-smith gate: `19/19`;
- Combat Bridge 001 targeting gate: `32/32`;
- preserved deterministic combat/anatomy/status domain suites;
- Android debug export;
- package-size ceiling;
- artifact uploads.

The historical bridge gate verified:
- current-world OBSERVE/ENGAGE thresholds for that revision;
- that revision's exploration camera remained unchanged through targeting;
- no legacy `FirstPersonCamera` node existed in that source;
- Hunter and Mudcrest transforms were unchanged by ENGAGE;
- target-group metadata/order;
- visual-node mapping;
- target highlight/clear behavior;
- target lock state;
- no combat/anatomy runtime start;
- targeting touch exclusion from camera look;
- right-side look outside controls;
- camera rotation during targeting;
- locomotion lock after ENGAGE;
- restoration of exploration controls on exit.

Measured exported APK: `58,018,736` bytes.  
Package ceiling: `2,000,000,000` bytes.

Artifacts:
- APK `10624343272` — `PixelRPG-prototype-001-debug`;
  - artifact archive bytes: `57,502,072`;
  - digest: `sha256:105eb8ccaa40e1e863d0697d80a59b505a1613f94d3677c824d4a2fa84f9512d`;
- evidence `10623919419` — `PixelRPG-prototype-001-build-evidence`;
  - artifact archive bytes: `28,344`;
  - digest: `sha256:cd464d72dcef1b7bc97ce8184900cbde65c9241efc6c9e056bdb815d1b488e1f`.

## Compatibility finding retained as technical history

The older Hunt-01 authored tactical graph was not a simple translation of the compact world used by Bridge 001:
- legacy N01 was `(-70, 4, -238)`;
- legacy Mudcrest body-force center was `(-18, 4, -252)`;
- N01 began roughly 54 m from that center;
- Bridge 001 ENGAGE began inside 8 m.

Therefore direct coordinate reuse was rejected. The deterministic turn-shell/anatomy domain could be adapted independently from obsolete tactical positioning. This compatibility finding remains useful technical history; it grants no current presentation authority.

## Historical next step

At the time, the next bounded package was:
`PIXEL_RPG_COMBAT_BRIDGE_002_DOMAIN_BOOTSTRAP_NO_ATTACK`.

Bridge 002 was subsequently implemented and remains represented by current source/tests where applicable. This section is not a current task instruction.

## Current authority reminder

Current Pixel RPG first-person source/tests and current authority documents supersede every camera/presentation instruction recorded in this historical checkpoint. Other archived or unrelated project material is excluded from Pixel RPG authority.
