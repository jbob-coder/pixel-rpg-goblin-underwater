# Pixel RPG — First-Person Realignment 001 — 2026-09-23

Status: IMPLEMENTED IN SOURCE / EXACT-SOURCE ENGINE+ANDROID VERIFICATION PENDING AT COMMIT TIME
Branch: `pixel-rpg`

## Creator decision

Normal Pixel RPG exploration is FIRST-PERSON.

This explicitly supersedes older Pixel RPG documents/handoffs that made third-person exploration authoritative. Those documents remain historical evidence; they are not deleted or rewritten as though they had always been first-person.

The abandoned standalone Shooter RPG remains non-authoritative. This change does not import its firearm/wall-jump identity, package/runtime root or old 115° HFOV contract.

## Bounded implementation

Preserved the existing Hunter controller/collision and moved presentation around it:
- CameraYaw and CameraPitch remain the look pivots;
- active Camera3D is now directly under CameraPitch at eye height;
- SpringArm3D remains present but inert/outside the active camera path;
- Hunter third-person visual is hidden during normal first-person exploration;
- movement, touch-look, HUD, minimap, interactions, smith, Mudcrest targeting and deterministic domain files are preserved;
- targeting remains in the same world and no combat damage/AP/Stamina behavior is added by this slice.

## Verification contract

A dedicated `game/tests/pixel_rpg_first_person_realignment_runtime_test.gd` must prove:
- existing Hunter authority preserved;
- presentation init does not move Hunter;
- direct camera current;
- hidden third-person visual;
- inert SpringArm;
- believable eye pivot;
- bounded FOV;
- camera independent of SpringArm length;
- yaw/pitch look remains functional;
- movement remains camera-relative.

The Android workflow must run this gate before existing visual/world/targeting/domain regressions and export.

## Truth boundary

At file creation time this document records implementation intent/source changes. Engine/build/device claims must come from actual workflow/device evidence and be added later.


## Exact-source verification result

Status: GODOT/HEADLESS/ANDROID-BUILD VERIFIED; PHYSICAL DEVICE NOT VERIFIED.

- source SHA: `0a6e54ecdbc1c81043b6db5dd0f35e429cbb4ee9`
- workflow run: `35910688037` — SUCCESS
- job: `107349457171` — SUCCESS
- Godot: `4.7.2.stable.official.ed1daf0bf`
- APK: `PixelRPG-first-person-001-debug.apk`
- APK size: `58,023,057` bytes
- APK SHA-256: `d0ea93980e2e617d056a696183c6eced2d0df34cf3a6240e244f3524ced8e012`
- Drive APK ID: `1NwWuvKS_cXuz5o22r5taeTadnlgUiIYB`
- immutable Drive build folder ID: `1REno22ZSIUQnKxOB6pcZRaYS6W0aXFa1`
- build evidence ID: `1mf8pyPyIyFlBHblJZ5mXE4yvtoIrccZx`
- raw CI evidence ZIP ID: `1frUxEVieyzQedwJSkWLP7u8fvmVebZOo`
- device checklist ID: `1zACUGQil9eU8Cwayk4gJs8SBiR8eSz3k`

The initial workflow run `35909468940` failed 10/12 first-person checks because the test compared global transforms across live physics frames. Gravity/floor settling changed Hunter Y by millimeters and therefore camera global Y, falsely suggesting presentation mutation/SpringArm dependence. The production behavior was not changed to satisfy this. The gate was repaired to:
- capture the Hunter transform immediately after presentation initialization but before physics settling;
- prove SpringArm independence through Camera3D parent/local transform rather than a world position that inherits legitimate Hunter movement.

The corrected exact-source run passed the full preserved regression chain and Android export.

## APK-size evidence

The APK is intentionally not padded. Its compressed package is dominated by the Godot Android native runtime libraries for both `arm64-v8a` and `armeabi-v7a`; the current production texture/audio/animation content remains limited. Package size is not a progress metric and is not installed-footprint evidence.

## Device truth boundary

NOT VERIFIED until physical evidence exists:
- install/upgrade behavior;
- black-screen absence on target phone;
- landscape composition;
- first-person touch movement/look feel;
- camera clipping;
- HUD safe areas;
- smith entry;
- OBSERVE/ENGAGE/body targeting;
- sustained FPS/heat;
- installed footprint.

## Continuation

Next bounded slice: `PIXEL_RPG_COMBAT_BRIDGE_002_DOMAIN_BOOTSTRAP_NO_ATTACK`.
Preserve the first-person camera, world transforms and Bridge 001 targeting semantics. Bootstrap only the approved combat/anatomy domain authorities; no attack, AP/Stamina spend, damage or legacy tactical-coordinate migration in this slice.
