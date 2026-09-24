# Pixel RPG — Visual Pack 009 First-Person Viewmodel — 2026-09-23

Status: BUILD-VERIFIED / DRIVE-ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Visual Pack 009 First-Person Viewmodel

- exact source SHA: `6e68a33df91b9d429d5c2fb1c913c3feb398c029`;
- workflow run: `35929499121` — SUCCESS;
- job: `107412442606` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.16-visual-pack-009-first-person-viewmodel`;
- APK: `PixelRPG-visual-pack-009-first-person-viewmodel-debug.apk`;
- APK size: `58,240,674` bytes;
- APK SHA-256: `67bc2e044ae85bc30036aba3c2cc50dd65d8e8d169f4aa4b28fd38f2d46141b3`;
- APK artifact ID: `10780781356`;
- APK artifact digest: `544acafcd06a081c2383d02e6b2bdcbe0ddf9a053df73d7f1076debb232d1982`;
- build-evidence artifact ID: `10780218824`;
- build-evidence digest: `b06945809304fa1c1f74d59d343e49e90ae4d4cb188d003d3d4666e7bdce6891`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35929499121_visual-pack-009-first-person-viewmodel/`
- folder ID: `1Vgq-4_4Qj4WEpZg3NL89mP0fItT3PhN2`;
- APK ID: `1kgYjaxiRJLUqL7iFH58fHR1L0OXdcHM2`;
- BuildIdentity JSON ID: `1KBV8O_KpQoPmYB0BntdVByBgDwH9paen`;
- BuildIdentity Markdown ID: `1IP1Vi4vG9XhteHOoGuF18tsOF1zzVxTe`;
- raw CI evidence ID: `10jycXz76JRKgi76-dCitTv4JOg9VTY1o`;
- device checklist ID: `1LG4B8xRlPp4GDlf7Le5a20SnHS_Rni1b`.

Implemented and verified:
- reusable `first_person_viewmodel_01.tscn` is a direct child of the active `Camera3D`;
- visible lower-frame left/right forearms and hands plus a bounded poleblade shaft/head/hook;
- viewmodel owns no scripts, Control nodes, physics, collision, input, targeting, damage, AP/Stamina or durable state;
- active camera path remains unchanged, camera local transform remains identity, FOV `70`, near `0.04`, far `180`;
- legacy SpringArm remains camera-free and third-person Hunter body remains hidden;
- camera-relative movement, target-count contract and no-attack combat-domain state remain unchanged;
- all prior asset/world/Mudcrest/combat/state/deterministic gates passed;
- Android export and package-size ceiling passed.

Physical-device viewmodel obstruction/readability, clipping, touch feel, sustained performance/heat and installed footprint remain NOT VERIFIED.


## Preservation boundary

The viewmodel is cosmetic camera-child geometry only. It is scriptless, non-colliding and owns no input or gameplay state. The active camera/controller and all world/combat/state owners remain unchanged.

## Next bounded task

`PIXEL_RPG_VISUAL_PACK_010_LIGHTING_ATMOSPHERE`

Improve only ambient/environment lighting presentation. No time-of-day simulation, gameplay visibility/detection mechanics, collision, camera/input, targeting/combat or state-owner changes are authorized in this slice.
