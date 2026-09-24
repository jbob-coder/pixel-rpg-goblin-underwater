# Pixel RPG — State Ownership Contract 001 — 2026-09-23

Status: IMPLEMENTED / EXECUTABLE OWNERSHIP CONTRACT VERIFIED / FIRST-PERSON + BRIDGE 002 PRESERVED / ANDROID BUILD VERIFIED / DEVICE VERIFICATION PENDING  
Branch: `pixel-rpg`  
Issue: #7

## Objective

Define authoritative runtime/state ownership without creating a giant singleton and without moving proven gameplay state merely to satisfy documentation.

## Implementation

Added:
- `game/scripts/state/pixel_rpg_state_ownership_contract.gd`;
- `game/tests/pixel_rpg_state_ownership_contract_test.gd`;
- `docs/50_technical/persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md`.

CI now runs `PIXEL_RPG_STATE_OWNERSHIP_CONTRACT_001_VERIFIED`.

## Ownership result

Current live ownership:
- Hunter world transform/physics: live Hunter world body;
- live Mudcrest transform: current-world Mudcrest proxy;
- combat round/current actor/AP/RP/Stamina/terminal scheduler: CombatTurnShellRuntime;
- Mudcrest anatomy integrity + resolution dedupe: MudcrestAnatomyRuntime;
- joystick/touch/camera yaw-pitch/targeting/context/bootstrap latches: transient controls/orchestration;
- HUD labels/highlights/derived visual state: presentation only.

Future durable domains are reserved as separate bounded owners:
- player;
- world/sections/decisions;
- inventory/equipment;
- NPC relationships;
- economy.

No global GameState singleton was introduced.

## Persistence boundary

Never gameplay-save:
- touch IDs;
- joystick vector;
- camera yaw/pitch;
- targeting panel state;
- selected/locked UI target;
- HUD/highlights;
- orchestration latches.

Preference-only candidate:
- camera sensitivity.

Future durable/checkpoint candidates:
- player/world transforms after a dedicated durable owner exists;
- deterministic combat/anatomy snapshot only at explicit stable combat save points;
- future player/world/inventory/NPC/economy state.

No save/load implementation is claimed.

## Exact verification

Source: `9b84000ca343dff0d4baa86accb024b9ebac4fb8`  
Workflow: `35917375696` — SUCCESS  
Job: `107372326343` — SUCCESS  
Godot: `4.7.2.stable.official.ed1daf0bf`

Focused ownership gate: `70/70` PASS.

Preserved gates:
- first-person realignment `12/12`;
- Visual Pack 002 `24/24`;
- Visual Pack 003 HUD `19/19`;
- World Pack 004 smith `19/19`;
- Bridge 001 targeting `34/34`;
- Bridge 002 domain bootstrap `28/28`;
- turn shell `76/76`;
- Hunter attack regression `64/64`;
- Mudcrest anatomy `20/20`;
- status application `57/57`;
- status timing `40/40`.

Android export/signature/package-size gates: PASS.

## APK / BuildIdentity

APK: `PixelRPG-state-ownership-001-debug.apk`  
Size: `58,052,621` bytes  
SHA-256: `531498c45c6d2293d5d38d646ca277ca7d0968b43caedb390ed3d3806578c532`  
APK artifact ID: `10775601339`  
APK artifact digest: `sha256:7e783165545febc3a7f430ba1c47a9e27dc369c400fa15077f81fa24251891af`  
Build-evidence artifact ID: `10775168943`

## Google Drive

Immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35917375696_state-ownership-001/`

Folder ID: `1PODIl1OXJ5Rpz5CqjmueEfau-HLXasci`  
APK ID: `1PGcW_okc1owdvuKxZuMNboICcRBoYKOd`  
BuildIdentity JSON ID: `18YieqdZBvYhzGshzBpFV2IJRQx_kZIu8`  
BuildIdentity Markdown ID: `1XLkjc9ZtIKMXpLvTrx6C7uzJaQ15YYJU`  
Raw CI evidence ZIP ID: `1xnZswS624jJ4DzsJh3KlfQFJn3Lb7sub`  
Device checklist ID: `1PjOBSiRyfhsqEn_a3eVkdw_jibWZ7bVF`

## Truth boundary

NOT VERIFIED on a physical Android device:
- installation/update;
- black-screen absence;
- touch feel;
- visual acceptance;
- sustained FPS/heat;
- installed footprint.

## Compatibility risk retained

Legacy Hunt01 tactical movement writes Hunter position to legacy authored Region-01 nodes. The verified Hunter attack legality also references the legacy tactical graph/body envelope.

Do not connect those owners directly to the compact current Pixel RPG world. A later combat slice requires an explicit current-world spatial adapter.

## Next bounded piece

`PIXEL_RPG_PROTOTYPE_DECOMPOSITION_001_WORLD_BASE` — issue #6.

Extract only world-base construction from the prototype God-script. Preserve coordinates, collisions and observable behavior. Keep input/camera/HUD/targeting/combat ownership unchanged in this first extraction.
