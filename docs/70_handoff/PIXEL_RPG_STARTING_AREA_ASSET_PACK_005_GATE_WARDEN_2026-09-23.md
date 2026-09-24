# Pixel RPG — Starting Area Asset Pack 005 Gate Warden Visual — 2026-09-23

Status: BUILD-VERIFIED / DRIVE-ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Starting Area Asset Pack 005 Gate Warden Visual

- source SHA: `7c27495eec5ddc53d42d596bbe1c3a48dad799a8`;
- workflow run: `35926969130` — SUCCESS;
- job: `107404261711` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.12-starting-area-assets-005-gate-warden`;
- APK: `PixelRPG-starting-area-assets-005-gate-warden-debug.apk`;
- APK size: `58,189,449` bytes;
- APK SHA-256: `cb215fc88ddb76f15f0fae6edb34243d220b9b387e56063019d67fa0437e9699`;
- APK artifact ID: `10779836686`;
- APK artifact digest: `855c1657bb5f714d60d127474ae3963da8b6123a148c31548513799a5ee68d5f`;
- build-evidence artifact ID: `10779642325`;
- build-evidence digest: `ee47cd37f6e7ebf242024bb41a06aa8b3244b602673097aaeee5acfd8a7a6df4`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35926969130_starting-area-assets-005-gate-warden/`
- folder ID: `13M9eiLedJQ5es3NGJd6XdmckLmdrWooJ`;
- APK ID: `1GFItfyM2yala4xYQaifqLyX8aQxtgQOb`;
- BuildIdentity JSON ID: `1C5j-RovCh_c9RXqcEvuOk2Fvu05gXQzj`;
- BuildIdentity Markdown ID: `10ARaoO7Sb2C944U_BumGYDHIvoQDpw_S`;
- raw CI evidence ID: `18wSmXn6u3EDzQ9aj2NQEGkd_mbFP5dMy`;
- canonical device checklist ID: `1pdPQexPApcqv681dGR6AtiQfxlqO2nsQ`.
- Note: Drive contains a second same-named checklist from concurrent archival activity; it was not deleted.

Implemented and verified:
- reusable `gate_warden_visual_01.tscn`;
- visual is presentation-only and adds no NPC collision/AI authority;
- `GateWarden` anchor remains exactly `Vector3(-2.6, 0.0, -6.2)`;
- TALK button/prompt and existing tracks/north-gate field-note result remain unchanged;
- first-person camera, Pack 004 smith, Mudcrest anchor, targeting/combat bootstrap and State Ownership 001 remain preserved;
- all prior asset/runtime/domain gates, Android export and package-size ceiling passed.

Physical-device visual acceptance, touch feel, sustained performance/heat and installed footprint remain NOT VERIFIED.


## Preservation boundary

Pack 005 changes only Gate Warden presentation. The existing `GateWarden` Node3D remains interaction authority. The new visual owns no collision, AI, dialogue state or durable state.

## Next bounded task

`PIXEL_RPG_STARTING_AREA_ASSET_PACK_006_SETTLEMENT_BUILDING_DETAILS`

Improve the two generic settlement building shells using reusable presentation-only detail assets. Preserve their existing collision bodies, exact positions and dimensions; do not add building gameplay or move any runtime owner.
