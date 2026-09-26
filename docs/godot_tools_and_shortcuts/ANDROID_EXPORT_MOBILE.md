# Godot 4.7 Android Export and Mobile Runtime Reference

Official Godot 4.7 Android export:
https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html

Gradle builds:
https://docs.godotengine.org/en/4.7/tutorials/export/android_gradle_build.html

## 1. Pixel RPG verified Android baseline

Current CI installs:
- Godot 4.7.2 with export templates;
- JDK 17;
- Android platform-tools;
- Android build-tools 35.0.1;
- Android platform 35.

Current export preset:
Android Debug

Current enabled CPU architectures:
- armeabi-v7a;
- arm64-v8a.

Current disabled:
- x86;
- x86_64.

Current package ID:
org.unnamedhuntrpg.game

Current export is debug-signed.

## 2. Official Godot 4.7 Android setup

The Godot 4.7 documentation currently specifies Android SDK tooling including:
- platform-tools;
- build-tools 35.0.1;
- platform android-35;
and additional command-line/NDK/CMake components for the documented setup.

The repository's CI Android platform/build-tools versions align with that documentation.

## 3. Export command

Pixel RPG CI shape:

    godot --headless --verbose --path game --export-debug "Android Debug" ABSOLUTE_OUTPUT.apk

The workflow checks:
- file exists and is non-empty;
- ZIP/APK integrity;
- SHA-256;
- byte size.

This is stronger provenance than merely uploading an APK without build evidence.

## 4. Debug versus release

Debug export:
- development/testing;
- debug signing;
- debugger-friendly;
- not the final store/release artifact.

Release export:
requires explicit release signing/key handling and release configuration.

Never commit private release keystore passwords or signing secrets to the repository.

## 5. Gradle build mode

Godot can use a generated Android Gradle project when customization is needed.

Potential reasons:
- AAB export;
- Android-specific Java/Kotlin integration;
- external SDK/plugin integration;
- manifest/build customization.

Current Pixel RPG preset has Gradle build disabled.

Do not enable Gradle merely because it is available. It increases build complexity and maintenance surface.

## 6. Android permissions

Permissions must match actual game features.

Examples:
- INTERNET for networking;
- vibration where used;
- microphone/camera only if features truly require them.

Do not request broad permissions without a concrete feature and privacy justification.

Godot high-level networking documentation specifically warns Android networking will be blocked without INTERNET permission.

## 7. Touch design

Pixel RPG current touch scheme:
- left-side virtual joystick;
- right-side camera look region;
- action UI;
- watch/settings panels;
- multi-touch finger ownership.

Maintain:
- per-finger index tracking;
- UI exclusion from look;
- lifecycle reset;
- configurable sensitivity;
- normalized movement;
- camera pitch clamp.

## 8. Safe area

Android devices may have:
- display cutouts;
- rounded corners;
- varying aspect ratios;
- navigation/status system UI behavior.

Pixel RPG already uses DisplayServer.get_display_safe_area plus current viewport/window sizes.

Any new HUD must test:
- 16:9;
- taller/wider ratios;
- cutout-safe regions;
- small screens.

## 9. Landscape

project.godot currently uses a landscape-oriented 1600x720 design baseline.

Do not assume physical device resolution equals the viewport design resolution.

Control layout should derive from viewport and safe-area geometry.

## 10. Frame pacing

Pixel RPG enables Android frame pacing in project.godot.

Do not disable this casually. If frame pacing problems are reported:
- profile device;
- record FPS/frame-time behavior;
- compare with explicit controlled tests;
- avoid changing multiple rendering/timing settings at once.

## 11. GL Compatibility

The project intentionally uses GL Compatibility.

Benefits:
- broad device compatibility;
- better fit for lower-end/older hardware.

Constraint:
Some advanced Forward+/Mobile rendering features may differ or be unavailable.

Any new shader/rendering effect must be validated under GL Compatibility specifically.

## 12. Texture compression

project.godot enables ETC2/ASTC import support.

For mobile assets:
- use dimensions appropriate for actual screen use;
- avoid giant source textures when unnecessary;
- choose lossless/lossy/import compression deliberately;
- inspect VRAM use;
- preserve nearest filtering where pixel-art assets require it rather than globally assuming one filter.

The project currently disables nearest mipmap filtering as the default. Individual assets may still need import settings suited to pixel-art intent.

## 13. Low-end hardware strategy

For Galaxy A03-class testing:
- reduce draw calls;
- cap dynamic lights/shadows;
- partition repeated objects with MultiMesh where useful;
- use visibility ranges;
- stream/deactivate distant systems;
- avoid huge transparent layers;
- simplify collision;
- avoid heavy per-frame GDScript loops;
- use lower-frequency updates for non-critical UI/context logic;
- measure memory;
- test thermal/performance behavior over time, not only first launch.

## 14. APK install/update reality

An APK can update an installed app when:
- package ID matches;
- signing key is compatible;
- version rules permit the update.

A changed APK still has to be delivered/installed unless an in-app patch/content update system exists.

Godot PCK/resource patch workflows exist, but designing self-updating code/content has platform/security/distribution implications and should be a separate architecture project.

## 15. Export preset versioning

Keep:
- version/code monotonically appropriate for distribution;
- version/name human-readable;
- package ID stable once external installs/saves depend on it.

Changing package ID creates a different Android application identity.

## 16. Save compatibility across APK updates

Use user:// durable saves.

Before shipping an update that changes save schema:
- back up;
- migrate;
- verify rollback behavior;
- never silently discard unknown old state.

Package reinstall/uninstall behavior depends on Android/user choices and export settings; do not promise saves survive uninstall unless specifically tested/configured.

## 17. Device logging

Use adb/logcat when debugging physical-device-only failures.

Useful categories:
- crash/ANR;
- OpenGL/driver;
- input lifecycle;
- permission errors;
- file/storage errors;
- Godot errors.

Preserve exact device model, Android version, APK SHA-256 and commit when recording a bug.

## 18. One-click deploy

Godot editor supports deploying to connected Android devices once SDK/device authorization is configured.

For authoritative QA evidence:
- record commit;
- record Godot version;
- record APK build identity;
- record device;
- record observed behavior.

## 19. Android editor

Godot also provides an Android editor, but Pixel RPG CI/build authority currently runs on desktop/Linux GitHub Actions.

Do not assume an Android-editor workflow has identical plugin/export constraints without verifying the relevant Godot 4.7 documentation.

## 20. Release checklist

Before a real release:
- release signing secured;
- package/version verified;
- required permissions minimal;
- save migration tested;
- cold launch tested;
- background/resume tested;
- rotation/orientation behavior tested;
- touch cancellation/focus tested;
- memory tested;
- performance tested on low-end target;
- APK/AAB integrity recorded;
- SHA-256 recorded;
- exact source commit recorded;
- privacy/network behavior reviewed if networking exists.

## 21. Current limitation

This reference branch documents Android tooling. It does not itself build or sign a new APK. Build/test claims require an actual CI or local run.
