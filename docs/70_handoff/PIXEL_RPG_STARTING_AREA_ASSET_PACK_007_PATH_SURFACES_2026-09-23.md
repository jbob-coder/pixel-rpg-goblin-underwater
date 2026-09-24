# Pixel RPG — Starting Area Asset Pack 007 Path Surface Details — 2026-09-23

Status: BUILD-VERIFIED / DRIVE-ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Starting Area Asset Pack 007 Path Surface Details

- source SHA: `8a2b061acd71f02ffecc2a7b738cd821ac4e6371`;
- first failed test run: `35928162750` — failed only because the new gate incorrectly cast the historical Street/Trail holder nodes as MeshInstance3D; no APK exported;
- corrected workflow run: `35928283662` — SUCCESS;
- corrected job: `107408524350` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.14-starting-area-assets-007-path-surfaces`;
- APK: `PixelRPG-starting-area-assets-007-path-surfaces-debug.apk`;
- APK size: `58,219,471` bytes;
- APK SHA-256: `42cb74a4500650db9167cd133c2aa3e8588c956c2052387b28a0e7b7ba472e44`;
- APK artifact ID: `10779618297`;
- APK artifact digest: `a226513cbd52ac0412d95c85320c2d34de1299a1200930d8d9be14d3c2eb0f7a`;
- build-evidence artifact ID: `10779413781`;
- build-evidence digest: `fec2740f4cb5f4ce7d9e3496acbd189c6a14d9ef4300b09ff7b1bf816f7bbaad`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35928283662_starting-area-assets-007-path-surfaces/`
- folder ID: `1yz7_68oPoOMQnMHXnQzGqiSNDtsR7Nwo`;
- APK ID: `1Vuae8OIZNpjhR8ihv2hXfX6_uA6J4-Dv`;
- BuildIdentity JSON ID: `1VUSLYSb2hWX_EKpuiBxf6cB1e_NSdm2Z`;
- BuildIdentity Markdown ID: `1SqJOqCS1sF1DPEvT6oDwlz5niFyv991o`;
- raw CI evidence ID: `1AVNLQnGlode8AvGJt1f5EL4WXKaXSNQ4`;
- device checklist ID: `1-qxdzstoLVoZ68UxVFqLZfMDTgjN0B_S`.

Implemented and verified:
- reusable `street_surface_details_01.tscn` and `trail_surface_details_01.tscn`;
- existing Street holder remains at `Vector3(0, 0.03, 2)` with BoxMesh size `Vector3(6.2, 0.10, 34)`;
- existing Trail holder remains at `Vector3(0, 0.04, -31)` with BoxMesh size `Vector3(4.2, 0.11, 34)`;
- new rut/dirt/stone/moss detail is presentation-only and adds no physics;
- Ground remains physical floor authority;
- all prior asset/runtime/domain gates, Android export and package-size ceiling passed on the corrected exact source.

Physical-device visual acceptance, touch feel, sustained performance/heat and installed footprint remain NOT VERIFIED.


## Failure/repair note

Run `35928162750` failed before export because the newly added Pack 007 test incorrectly assumed Street and Trail were MeshInstance3D root nodes. Historical source uses Node3D holders with a direct child BoxMesh. The repair in source `8a2b061...` corrected the test to read the existing holder/child contract; runtime code/assets were not weakened to make the gate pass.

## Preservation boundary

Street/Trail base holders and meshes remain unchanged. Surface details are presentation-only. Ground remains physical collision authority.

## Next bounded task

`PIXEL_RPG_VISUAL_PACK_008_MUDCREST_REFINEMENT`

Improve only Mudcrest presentation inside the existing anatomy target groups. Preserve every target root and all targeting/combat/world/state authority.
