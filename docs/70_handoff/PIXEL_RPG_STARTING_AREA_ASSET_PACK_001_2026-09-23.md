# Pixel RPG — Starting Area Asset Pack 001 — 2026-09-23

Status: EXACT-SOURCE ANDROID BUILD VERIFIED / DRIVE ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Starting Area Asset Pack 001

- source SHA: `51b7262264f3460842021f0a9edf874413d301ae`;
- workflow run: `35924324641` — SUCCESS;
- job: `107395641354` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.8-starting-area-assets-001`;
- APK: `PixelRPG-starting-area-assets-001-debug.apk`;
- APK size: `58,099,610` bytes;
- APK SHA-256: `f1320e91d1a0163e74f8ca0924be9dd741a33c1f2bde3110d1b187a598baf6fa`;
- APK artifact ID: `10777838822`;
- APK artifact digest: `40d17d92ef8eec4baf287b6dca5bb3bb5d2194ac7738cb7925cb03242fdae6eb`;
- build-evidence artifact ID: `10777694345`;
- build-evidence artifact digest: `c785004b82d847bbca5a8145fa56d459fe831cf7c6124e929de2e15ee21f56dd`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35924324641_starting-area-assets-001/`
- folder ID: `10uXMDW0Jy13ExHyI86oxbuoNaYHGdzGI`;
- APK ID: `1wTTuw7NAfyB92eFv0COIj8btLg-_iwz8`;
- BuildIdentity JSON ID: `1gz_bTBWwz_T2hBcCvY73CGtexCbbX8zc`;
- BuildIdentity Markdown ID: `1g6BLUFATiYb9xSG0LcdGKyMqRv8unPLz`;
- raw CI evidence ID: `1wzSVCxClGP1Z1ie851X4uUe1RcrQ4cPC`;
- device checklist ID: `1fgNcnQqr0bjae9jEMOiJcfLRcNbh_jXV`.

Implemented in this checkpoint:
- reusable `settlement_gate_01.tscn`;
- reusable `market_stall_01.tscn`;
- reusable `service_clutter_01.tscn`;
- reusable `signpost_01.tscn`;
- reusable `lantern_post_01.tscn`;
- `WorldPack001` now instantiates those assets behind the existing builder API;
- existing world placement/collision ownership remains in the host;
- first-person camera, smith, targeting, combat bootstrap and state ownership were not moved.

Verification:
- import/parse PASS;
- AppShell/prototype smoke PASS;
- first-person gate PASS;
- Visual Pack 002/003 PASS;
- enterable smith gate PASS;
- Combat Bridge 001/002 PASS;
- State Ownership 001 PASS;
- world-base decomposition parity PASS;
- Starting Area Asset Pack 001 gate PASS;
- deterministic combat/anatomy/status regression set PASS;
- Android debug export and package-size ceiling PASS.

Physical phone install, touch feel, visual acceptance, sustained FPS/heat and installed footprint remain NOT VERIFIED.

## Scope

This slice replaces five inline/procedural World Pack 001 presentation groups with reusable PackedScene assets while keeping the existing builder API and caller transforms:
- settlement gate;
- market stall;
- service clutter;
- signpost;
- lantern post.

The gate's separate host-owned collision boxes were not moved. The smith remained on World Pack 004 and was not modified. No player/controller, camera, HUD, targeting, combat-domain or state-ownership code was changed.

## Files changed in source checkpoint

- `game/assets/environment/starting_area/settlement_gate_01.tscn`
- `game/assets/environment/starting_area/market_stall_01.tscn`
- `game/assets/environment/starting_area/service_clutter_01.tscn`
- `game/assets/environment/starting_area/signpost_01.tscn`
- `game/assets/environment/starting_area/lantern_post_01.tscn`
- `game/scripts/presentation/pixel_rpg/world_pack_001.gd`
- `game/tests/pixel_rpg_starting_area_asset_pack_001_runtime_test.gd`
- `.github/workflows/pixel-rpg-prototype-android.yml`
- `game/export_presets.cfg`

## Verification boundary

Engine/headless/Android build is verified. Physical Android install/runtime, visual acceptance, touch feel, sustained FPS/heat, camera clipping on-device and installed footprint are not verified.

## Next bounded task

`PIXEL_RPG_STARTING_AREA_ASSET_PACK_002_SMITH_VISUAL`.

Preserve:
- `WorldPack004EnterableSmith` root identity;
- doorway width/height and collision segmentation;
- `EntranceAnchor` and `UseAnchor`;
- `RoofA`, `RoofB`, `RidgeBeam` visibility behavior;
- first-person camera and mobile input;
- targeting/combat bootstrap;
- State Ownership 001.

Do not add full crafting in the smith visual slice.
