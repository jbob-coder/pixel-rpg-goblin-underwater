# Pixel RPG — Starting Area Asset Pack 004 Host Environment Reuse — 2026-09-23

Status: BUILD-VERIFIED / DRIVE-ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Starting Area Asset Pack 004 Host Environment Reuse

- source SHA: `8d896285c04b3a55da5836b4e38d55684788ab1e`;
- workflow run: `35926481868` — SUCCESS;
- job: `107402676378` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.11-starting-area-assets-004-host-environment`;
- APK: `PixelRPG-starting-area-assets-004-host-environment-debug.apk`;
- APK size: `58,176,659` bytes;
- APK SHA-256: `55e67fbca0ebc1956b05074a956e8baaf707bcfe0350e37aab635aaae707f12f`;
- APK artifact ID: `10779695702`;
- APK artifact digest: `0eae02f2bb571cbc890c7a911ae9f5f46da27e439549037da90fcc5d01a237eb`;
- build-evidence artifact ID: `10778982480`;
- build-evidence digest: `17bdd7971311185157b14b24365d0a928c12ee327c3f400bba547c50338e2367`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35926481868_starting-area-assets-004-host-environment/`
- folder ID: `1AgOfPLPerQ-lWeMDQczJgAhdQQlOerr5`;
- APK ID: `1krztuQZnmioc2a_e8gFwWAT6JR-yn8cI`;
- BuildIdentity JSON ID: `1qsGypUWP_CFg7SwHWKbm1Kdjlm-WgyAK`;
- BuildIdentity Markdown ID: `1eWw8OL2bo4K63-qXN2UYZfJWvMapCt5D`;
- raw CI evidence ID: `11a_fWLfY3aLOfAOY9y5S-JclmQ5BY2fi`;
- canonical device checklist ID: `1dnZsFBehlj0FxAaw4mhQXXcXy-hHW3iB`.

Implemented and verified:
- the ten host-built trail trees now instantiate the reusable `trail_pine_01.tscn` visual while keeping their exact world positions;
- `TrailRockL` keeps its `StaticBody3D`, collision layer/mask and exact `2.4 × 1.5 × 2.0` `BoxShape3D`, while its visible mesh is replaced by `trail_rock_visual_01.tscn`;
- first-person camera, Pack 004 smith, Mudcrest anchor, targeting/combat bootstrap and State Ownership 001 remain preserved;
- all prior runtime gates, deterministic combat/anatomy/status regressions, Android export and package-size ceiling passed.

Physical-device install, visual acceptance, touch feel, sustained FPS/heat and installed footprint remain NOT VERIFIED.


## Preservation boundary

Pack 004 changed presentation only. Ten existing trail-tree world coordinates remain unchanged. `TrailRockL` remains the same gameplay collision body at `Vector3(-3.8, 0.75, -29.0)` with a `Vector3(2.4, 1.5, 2.0)` box collision. The new tree and rock resources do not own gameplay state.

## Next bounded task

`PIXEL_RPG_STARTING_AREA_ASSET_PACK_005_GATE_WARDEN_VISUAL`

Create and apply a reusable presentation-only Gate Warden visual while preserving the existing `GateWarden` world anchor, TALK interaction, first-person presentation, smith contracts, targeting/combat and State Ownership 001.
