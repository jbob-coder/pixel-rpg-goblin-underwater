# Pixel RPG — Visual Pack 008 Mudcrest Refinement — 2026-09-23

Status: BUILD-VERIFIED / DRIVE-ARCHIVED / DEVICE VERIFICATION PENDING

## Latest verified checkpoint — Visual Pack 008 Mudcrest Refinement

- implementation source: `7da40b2b0e8d1d1c68a2a6144221c8a36628c4b8`;
- first failed run: `35928797541` — failed only because the new Pack 008 test referenced loop-local variables outside their scope; Mudcrest resource import, prototype smoke, first-person and Visual Pack 002 had already passed;
- corrected exact build source: `d280c2da7f434450930cf5950feb598a0f4f7462`;
- corrected workflow run: `35928948805` — SUCCESS;
- corrected job: `107410680490` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- version: `0.15-visual-pack-008-mudcrest-refinement`;
- APK: `PixelRPG-visual-pack-008-mudcrest-refinement-debug.apk`;
- APK size: `58,227,894` bytes;
- APK SHA-256: `7e980ed1a3e3d2de8c2f429c31b9ba1874c74273b0de839f4eaee1ffb28626d6`;
- APK artifact ID: `10779319853`;
- APK artifact digest: `085b812c198597cca68e57029c8c226e1b2d6eed3fa7bb1dbb974513d5276c4a`;
- build-evidence artifact ID: `10780361021`;
- build-evidence digest: `428cca2e20129acf995897a2121418e49f8332eff0039a63d3da91c6e9b5bba0`.

Google Drive immutable folder:
`Pixel RPG/Builds/First Person/2026-09-23_run-35928948805_visual-pack-008-mudcrest-refinement/`
- folder ID: `1dRhP6bwobMMIRhyCMSsUkORJwW-bbW_Z`;
- APK ID: `1UGYE1JuYN3EGD4wzdZQYvAOKH8_5YpXj`;
- BuildIdentity JSON ID: `10Eg_TJU0pAl0BXGthhOB5qGXKfznFvRG`;
- BuildIdentity Markdown ID: `1ukZ9pfcih7jRTzOqqoM63KyKDXaDRF-X`;
- canonical raw CI evidence ID: `1SGAhV_U4thFqI8-N3FN17UzSPEtAEUhj`;
- device checklist ID: `1YnINOvGYd0mfkoDT5zqrfI_emxs_g_Sq`;
- a duplicate same-byte raw evidence ZIP exists from concurrent archival activity and is intentionally left intact.

Implemented and verified:
- visible Mudcrest eyes/jaw/tusks, reinforced horn bases, shoulder/torso breakup, extra dorsal plates, claws and tail detail;
- all existing target roots remain unchanged: `HEAD`, `HORN_CREST`, four leg roots, `DORSAL_PLATES`, `TAIL`, and `GENERAL_TORSO`;
- Mudcrest visual remains presentation-only with no physics;
- recursive target highlighting reaches new detail and clears correctly;
- MonsterProxy remains exactly at `Vector3(0, 0, -49)` and domain-body alias remains co-located;
- first-person camera, targeting/combat bootstrap, deterministic combat/anatomy/status systems, State Ownership 001 and all prior asset gates remain preserved;
- Android export and package-size ceiling passed.

Physical-device visual acceptance, touch feel, sustained performance/heat and installed footprint remain NOT VERIFIED.


## Preservation boundary

Visual Pack 008 changes only Mudcrest presentation geometry/material detail within the existing anatomy target roots. It does not move MonsterProxy or domain collision, create monster physics, modify anatomy integrity, or change target IDs/target ordering/combat state.

The initial Pack 008 run failed only because its new test referenced loop-local variables outside the loop. The corrected test-only source `d280c2da...` passed the full regression/export pipeline without changing runtime behavior.

## Next bounded task

`PIXEL_RPG_VISUAL_PACK_009_FIRST_PERSON_VIEWMODEL`

Add a cosmetic first-person hands/poleblade scene under the existing active Camera3D. No collision, attack, damage, AP/Stamina, targeting or state ownership may move into the viewmodel.
