# Pixel RPG — Starting Area Asset Pack 002 Smith Visual — 2026-09-23

Status: EXACT-SOURCE ANDROID BUILD VERIFIED / DRIVE ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Starting Area Asset Pack 002 Smith Visual

- source SHA: `efd16b123ac41c2bcb1faf081e11dcb9f808f510`;
- workflow run: `35925218965` — SUCCESS;
- job: `107398569689` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.9-starting-area-assets-002-smith`;
- APK: `PixelRPG-starting-area-assets-002-smith-debug.apk`;
- APK size: `58,129,579` bytes;
- APK SHA-256: `f037aa4a0f945d500b8dbfd91a1ce4437884ddbc604f7c83a5aef8271088d498`;
- APK artifact ID: `10779151178`;
- APK artifact digest: `b31c3bc97e13d2b0e79506394fdb5c4ab4afcf107db4f8c2236db573e26e929f`;
- build-evidence artifact ID: `10778454296`;
- build-evidence digest: `7cde1fa37fb76def892f746de2d8d572e78f6c915d8f7310c50324e5ba66fe2e`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35925218965_starting-area-assets-002-smith/`
- folder ID: `1Ql4bDhi1_mAbF714IhwKo4NNGs-Y4uIf`;
- APK ID: `1iVq0udFb7e3mNCO5o5GqZhITdVwtObES`;
- BuildIdentity JSON ID: `1HfaM_mCTK5iFf4LODQ99BsYZ_fZdkk8h`;
- BuildIdentity Markdown ID: `1jVQLtb6NLppR2Eprh39kxlKSv8cONFGC`;
- raw CI evidence ID: `16ddWis1BIHdxZ9bB_JCceECkpaDReUyk`;
- device checklist ID: `1pE_7nwDa8i6gds-Tjc-IluX9_TKGKOCn`.

Implemented:
- reusable forge detail scene;
- reusable anvil/workstation detail scene;
- reusable bench/tool detail scene;
- reusable smith frontage detail scene;
- Pack 004 keeps its proven structural, collision, doorway, anchor and roof nodes;
- new details are presentation-only under `SmithVisualDetails`.

Verified:
- import/parse and app/prototype smoke;
- original Pack 004 doorway/physics/interaction gate;
- new Asset Pack 002 smith visual gate;
- first-person, Packs 001/002/003, Combat Bridge 001/002, State Ownership 001 and world-base decomposition parity;
- deterministic combat/anatomy/status regressions;
- Android export and package-size ceiling.

Physical-device install, visual acceptance, touch feel, sustained performance/heat and installed footprint remain NOT VERIFIED.

## Scope

This slice adds presentation-only reusable smith details while preserving the already-tested enterable-building gameplay contract.

New source assets:
- `game/assets/environment/starting_area/smith_forge_detail_01.tscn`
- `game/assets/environment/starting_area/smith_anvil_detail_01.tscn`
- `game/assets/environment/starting_area/smith_bench_detail_01.tscn`
- `game/assets/environment/starting_area/smith_frontage_detail_01.tscn`

Integration:
- `game/scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd`
- details are instanced below `SmithVisualDetails`;
- no CollisionObject3D/CollisionShape3D is owned by the new visual-detail scenes;
- existing direct nodes such as `RoofA`, `RoofB`, `RidgeBeam`, `EntranceAnchor`, `UseAnchor`, `ForgeHearth`, `AnvilTop`, `SmithBench` and `Collision` remain intact.

## Verification boundary

CI proves scene parsing, runtime integration, original Pack 004 doorway/collision/interaction behavior, first-person preservation and Android export. It does not prove final visual quality or physical-device performance.

## Next bounded task

`PIXEL_RPG_STARTING_AREA_ASSET_PACK_003_ENVIRONMENT_DRESSING`: reusable trail/settlement environmental dressing with current coordinates/collisions preserved.
