# Pixel RPG — Starting Area Asset Pack 006 Settlement Building Details — 2026-09-23

Status: BUILD-VERIFIED / DRIVE-ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Starting Area Asset Pack 006 Settlement Building Details

- source SHA: `d050799380bdad814673d2752c3768f12bef0718`;
- workflow run: `35927524386` — SUCCESS;
- job: `107406042641` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.13-starting-area-assets-006-buildings`;
- APK: `PixelRPG-starting-area-assets-006-buildings-debug.apk`;
- APK size: `58,202,290` bytes;
- APK SHA-256: `073e2e0122e61028587291bd60791ca181083ab99c7fe5b6ed979798cac6f9bb`;
- APK artifact ID: `10779503582`;
- APK artifact digest: `f51fe0b945a9af18b3d7ccc2e8083deaaebe825e98de2a5f742a0b7d24e7fa3e`;
- build-evidence artifact ID: `10780001656`;
- build-evidence digest: `09671608f298e95deda0a20fcb65cc99735cb17d898ad0cd1e7b6382f1ba853f`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35927524386_starting-area-assets-006-buildings/`
- folder ID: `1UzFo9xaWmKaGjcw0iFOgHVFwmJeXVS6Y`;
- APK ID: `1mgS1RkhKnlv-c2hfcdCxogwga21ZSOa2`;
- BuildIdentity JSON ID: `1Po6sAmm2RCM3kDiZVZaM3u9rOKSLytDO`;
- BuildIdentity Markdown ID: `1mAJmbJMiiUL_xQDZFUU0U6EmuTnfIFj6`;
- raw CI evidence ID: `1NyMNUDUa6KcCoA-7LfNMI0dQoplPAhIL`;
- device checklist ID: `1rCZrglRxJgGuiBY1utaCUuM9e3ZAeIqx`.

Implemented and verified:
- reusable `settlement_building_details_01.tscn`;
- exactly two presentation-only detail layers are attached to the two existing generic settlement buildings;
- original colliding `Building` StaticBody3D nodes remain at `(-7.0, 1.7, 8.5)` / size `(7.0, 3.4, 7.0)` and `(7.5, 1.6, -3.0)` / size `(6.8, 3.2, 6.4)`;
- facade details add door/frame, windows, structural beams, eaves and chimney without adding gameplay collision;
- Gate Warden, first-person camera, smith, Mudcrest anchor, targeting/combat and State Ownership 001 remain preserved;
- all prior asset/runtime/domain gates, Android export and package-size ceiling passed.

Physical-device visual acceptance, touch feel, sustained performance/heat and installed footprint remain NOT VERIFIED.


## Preservation boundary

Pack 006 adds presentation-only facade/detail layers. Existing generic building StaticBody3D collision remains authoritative and unchanged. No new building interaction, interior, durable state or gameplay collision was introduced.

## Next bounded task

`PIXEL_RPG_STARTING_AREA_ASSET_PACK_007_PATH_SURFACE_DETAILS`

Improve only Street and Trail surface presentation. Preserve the exact existing Street/Trail positions and sizes and keep Ground as physical floor/collision authority. Do not add road/trail gameplay logic in this visual slice.
