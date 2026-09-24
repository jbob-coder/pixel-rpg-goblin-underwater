# Stage 1 Android Export Setup

Status: DOCUMENTED / NOT YET CONFIGURED OR BUILT
Last reconciled: 2026-09-02

## Purpose

Prepare a repeatable first debug install of the isolated Godot 4.7 Stage 1 probe on the Samsung Galaxy A03s without pretending an APK has already been produced.

## Current project target

- project root: `probes/android_stage1/`;
- Godot target: 4.7;
- language: GDScript;
- renderer: GL Compatibility;
- orientation: landscape;
- baseline phone: Samsung Galaxy A03s;
- first representative target: stable 30 FPS minimum goal.

## Desktop editor prerequisites

For desktop export setup, current Godot Android documentation recommends:
- OpenJDK 17;
- Android SDK;
- Android SDK Platform-Tools 35.0.0 or later;
- Android SDK Build-Tools 35.0.1;
- Android SDK Platform 35;
- latest Android SDK command-line tools;
- Godot 4.7 export templates.

Do not commit local SDK/JDK paths or keystore credentials to this repository.

## Godot editor setup

1. Install Godot 4.7 export templates.
2. Open Editor Settings.
3. Set the Java SDK path to the OpenJDK installation.
4. Set Android SDK Path to the SDK directory containing `platform-tools/adb`.
5. Reopen/check Project > Export.
6. Add an Android preset for the probe.
7. Keep the first install as a debug/development build.
8. Prefer the normal prebuilt Android export template for the first probe; do not introduce Gradle customization unless a measured requirement appears.

Reason:
the probe is testing engine/device viability, not Android plugin/custom-Java integration.

## Package-name policy

Use a probe-specific package/application ID, separate from any future production game package ID.

Recommended development identity:
`org.unnamedhuntrpg.stage1probe`

This prevents a probe build from colliding with a later production app/signing identity.

## Architecture policy

For the first physical Galaxy A03s install, include the architecture supported by the physical device and keep configuration minimal.

Do not remove architectures or customize native templates based on assumptions before the first successful export/install.

## Orientation

The project records:
`display/window/handheld/orientation = 0`

In Godot's screen-orientation enum this is landscape.

Do not enable portrait/sensor rotation for the first probe; camera/UI measurements require a stable landscape baseline.

## Rendering verification

The project requests:
- `rendering/renderer/rendering_method = gl_compatibility`;
- mobile override = `gl_compatibility`.

At runtime, the probe HUD also reads the current rendering method/driver from `RenderingServer`.

Reason:
the actual runtime renderer can differ from a configuration value due to command-line/fallback behavior, so runtime evidence wins.

## Android frame pacing

`display/window/frame_pacing/android/enable_frame_pacing = true` is enabled in the project settings.

This should remain enabled for the first device probe unless a measured troubleshooting experiment deliberately toggles it.

## First export gate

Before exporting:
- Godot editor opens project without parse errors;
- Boot scene runs;
- 3D probe scene runs;
- Compatibility renderer is confirmed;
- no missing-resource errors;
- desktop placeholder movement/camera toggle works.

Only then create/install the Android debug package.

## Device preparation

On the Galaxy A03s:
- enable Android developer options;
- enable USB debugging;
- connect by USB to the development computer;
- authorize the computer when Android displays the debugging prompt;
- verify the device appears through ADB/Godot one-click deploy before claiming install readiness.

Do not assume connection from cable presence alone.

## First device test

Record:
- APK/install success or exact failure;
- cold-launch behavior;
- landscape correctness;
- touch-button responsiveness;
- aerial camera behavior;
- first-person toggle behavior;
- renderer/driver reported by runtime HUD;
- FPS/frame-time behavior;
- debug memory reading where available;
- visual readability;
- obvious shadow/overdraw problems;
- suspend/resume;
- crash/ANR/relaunch behavior.

The first run is evidence collection, not a visual-quality approval.

## Credentials and repository hygiene

Safe to commit later when generated/reviewed:
- `export_presets.cfg`, provided it contains no secrets.

Do not commit:
- `.godot/export_credentials.cfg`;
- release keystores;
- signing passwords;
- local SDK/JDK paths containing user-specific machine information.

## Current gate

`ANDROID_EXPORT_DOCUMENTED = YES`
`ANDROID_EXPORT_EDITOR_CONFIGURED = NO`
`ANDROID_PRESET_CREATED = NO`
`APK_BUILD_VERIFIED = NO`
`GALAXY_A03S_INSTALL_VERIFIED = NO`
`PHONE_RUNTIME_VERIFIED = NO`

Advance one state at a time from actual evidence.
