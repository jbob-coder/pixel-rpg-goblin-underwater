# Pixel RPG — Starting Area Asset Pack 003 Environment Dressing — 2026-09-23

Status: BUILD-VERIFIED / DRIVE-ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Starting Area Asset Pack 003 Environment Dressing

- source SHA: `3b36ec42556d5603dc02ee1b07080c10670c2648`;
- workflow run: `35925800678` — SUCCESS;
- job: `107400485383` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.10-starting-area-assets-003-environment`;
- APK: `PixelRPG-starting-area-assets-003-environment-debug.apk`;
- APK size: `58,159,506` bytes;
- APK SHA-256: `cfbeb649b1f7cc62279aef647c15cba924501f1a0edf4398242a66c19b0897b7`;
- APK artifact ID: `10778896861`;
- APK artifact digest: `c0ad67e554be95efa43cb8d2be1b8296d05be9b1e9cf130e7a631fc6b0ad904e`;
- build-evidence artifact ID: `10779325700`;
- build-evidence digest: `fd9a27fa2a2c1313495885a49d1e3e0fde4705ed1b7cb5f3b4392b12a40c8274`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35925800678_starting-area-assets-003-environment/`
- folder ID: `1MroMvgM8a0j0bK1VvRH-6yehMqkYblnh`;
- APK ID: `17Bq6x2mzuFlLssUIdvSRWCChINe-DUpq`;
- BuildIdentity JSON ID: `1JnFgmM0VA9B9Cp7DQskNGVYjRlMrkqNE`;
- BuildIdentity Markdown ID: `1gArFsYoKXecWHGrzSUM_rSvmz02aoGQ8`;
- raw CI evidence ID: `1m6gKgn11Y28ji5f6LeBLJMy8QjbheYXu`;
- device checklist ID: `1E-TJJCBb5kqd-OhFk49PR4tB-X_lU5g8`.

Implemented:
- reusable fence asset scene;
- reusable banner-post asset scene;
- reusable vegetation-cluster asset scene;
- reusable rock-cluster asset scene;
- existing WorldPack001 builder names/caller transforms preserved;
- assets remain presentation-only with no new gameplay collision.

Verified:
- import/parse and app/prototype smoke;
- first-person and HUD gates;
- Pack 004 smith physics/interaction and Smith Visual Pack 002;
- Combat Bridge 001/002;
- State Ownership 001;
- world-base decomposition parity;
- Starting Area Asset Packs 001/002/003;
- deterministic combat/anatomy/status regressions;
- Android export and package-size ceiling.

Physical-device visual acceptance, touch feel, sustained performance/heat and installed footprint remain NOT VERIFIED.


## Preservation boundary

The four new environment assets are presentation-only. Existing WorldPack001 caller transforms remain authoritative for placement. No new collision was introduced. First-person camera/input, Pack 004 smith contracts, targeting/combat state and State Ownership 001 were not moved.

## Next bounded task

`PIXEL_RPG_STARTING_AREA_ASSET_PACK_004_HOST_ENVIRONMENT_REUSE`

Replace only the remaining host-built standalone trail-tree visuals and the decorative mesh portion of `TrailRockL` with reusable presentation assets. Preserve every current tree/rock coordinate and preserve the existing `TrailRockL` collision body unchanged.
