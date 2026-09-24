# Pixel RPG — Pixel Render / Camera / HUD Polish Handoff — 2026-09-16

Status: IMPLEMENTED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED / PHONE VISUAL ACCEPTANCE OPEN
Branch: `pixel-rpg`

## Completed bounded piece

`PIXEL_RPG_PROTOTYPE_001_PIXEL_RENDER_CAMERA_UI_POLISH`

Verified source: `88d19d733a579e326d7bdf3ebd8e002ef413d86a`.

Workflow `35062722630`: SUCCESS.
Job `104686283219`: SUCCESS.

Artifacts:
- APK `10432264323` — `PixelRPG-prototype-001-debug`;
- evidence `10433305640` — `PixelRPG-prototype-001-build-evidence`.

## What changed

- world 3D now renders in an 800×360 SubViewport and is stretched through nearest filtering for an intentional pixel presentation;
- prototype primitive materials use per-vertex shading and nearest texture filtering;
- third-person camera now uses `SpringArm3D` for wall/gate obstruction handling;
- hunter collision is excluded from the SpringArm collision query;
- HUD layout now recalculates from the display safe area and viewport size;
- joystick, action button, Diamond Watch button, prompts, status/objective panels and watch overlay adapt to screen edges rather than depending only on one fixed coordinate layout;
- movement/right-look semantics, NPC interaction, monster observation and reusable combat-domain regressions were preserved.

## Verification

The successful run passed:
- Godot 4.7.2 import/parse;
- AppShell smoke;
- Pixel RPG prototype scene smoke;
- selected deterministic combat-domain regressions;
- Android debug export;
- exact 2,000,000,000-byte package ceiling;
- APK and build-evidence uploads.

## CI-use reduction

After this verified run, the Pixel RPG workflow trigger was narrowed so documentation-only changes do not start a full Android export. It now runs on `game/**` changes and changes to its own workflow file.

## Verification boundary

Confirmed:
- pixel render path implemented;
- SpringArm camera collision implemented;
- safe-area HUD logic implemented;
- headless smokes verified;
- selected domain regressions verified;
- Android build verified;
- package ceiling gate passed.

Still open:
- phone runtime acceptance;
- visual-quality acceptance against the saved concept reference;
- sustained target-device performance;
- installed-footprint 2 GB verification.

## Exact next bounded piece

`PIXEL_RPG_PROTOTYPE_002_WORLD_COMPOSITION`

Improve the compact settlement/trail scene toward the selected concept reference using inexpensive reusable forms: stronger building/service silhouettes, gate framing, market cues, fencing/signage, layered vegetation/terrain depth and better distant monster framing. Preserve the current controller, camera, pixel render, HUD, interactions and deterministic domain tests.
