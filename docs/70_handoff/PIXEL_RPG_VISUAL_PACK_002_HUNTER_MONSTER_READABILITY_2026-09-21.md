# Pixel RPG — Visual Pack 002 Hunter / Monster Readability — 2026-09-21

Status: IMPLEMENTED / GODOT PARSE VERIFIED / HEADLESS SMOKES VERIFIED / VISUAL MAPPING GATE VERIFIED / DOMAIN REGRESSIONS VERIFIED / ANDROID BUILD VERIFIED / PHONE VISUAL ACCEPTANCE OPEN
Branch: `pixel-rpg`

## Bounded piece

`PIXEL_RPG_VISUAL_PACK_002_HUNTER_MONSTER_READABILITY`

## Verified source

`43258bcad09040ece4b520fdbfa7dcd9a718c942`

Workflow `35564826300`: SUCCESS.  
Job `106224465180`: SUCCESS.

## What Pack 002 changed

Hunter presentation:
- retained the existing Pixel RPG hunter instead of inventing a replacement identity;
- lowered primitive segment counts for a harder low-poly/pixel-styled silhouette;
- added visible arms, bracers, boots, belt, bounded pouch/tool-roll cues and a clearer poleblade head/hook;
- preserved the existing 1.75 m player/collision scale and controller ownership.

Mudcrest presentation:
- added reusable `game/assets/monsters/mudcrest_visual.tscn`;
- replaced the generic capsule/cylinder distant monster proxy with that reusable scene;
- kept the existing observation interaction unchanged;
- exposed visual nodes matching all current authoritative anatomy target groups:
  - `HEAD`;
  - `HORN_CREST`;
  - `FORELEG_L`;
  - `FORELEG_R`;
  - `HINDLEG_L`;
  - `HINDLEG_R`;
  - `DORSAL_PLATES`;
  - `TAIL`;
  - `GENERAL_TORSO`.

The visual scene does not own damage, integrity, break, sever or combat rules. Those remain in the deterministic gameplay/domain runtime.

## Runtime files

Modified:
- `game/assets/characters/hunter_visual.tscn`;
- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`;
- `.github/workflows/pixel-rpg-prototype-android.yml`.

Added:
- `game/assets/monsters/mudcrest_visual.tscn`;
- `game/tests/pixel_rpg_visual_pack_002_runtime_test.gd`.

## Verification evidence

PASS:
- Godot `4.7.2.stable` import/parse;
- Pixel RPG AppShell smoke;
- Pixel RPG prototype scene smoke;
- Pack 002 runtime gate: `24/24`;
- preserved deterministic combat/anatomy/status domain tests;
- Android debug export;
- package-size ceiling;
- APK artifact upload;
- evidence artifact upload.

Measured exported APK:
`57,980,948` bytes.

Package ceiling:
`2,000,000,000` bytes.

Artifacts:
- APK `10623901334` — `PixelRPG-prototype-001-debug`;
  - artifact archive bytes: `57,469,012`;
  - digest: `sha256:8b7dd72dc43e54b96c12f45dadc125363851bf8caa293ab8625e5b815c20558a`;
- evidence `10623886474` — `PixelRPG-prototype-001-build-evidence`;
  - digest: `sha256:cc38b5f11322546e71320d996a6a60927f1be60d61ff1810b22a83f128711358`.

## Verification boundary

Confirmed:
- source integration = YES;
- scene/resource parse = YES;
- Pack 002 anatomy-node mapping = YES;
- headless prototype runtime = YES;
- selected deterministic domain regressions = YES;
- Android build = YES;
- package ceiling = YES.

Still open:
- physical phone visual acceptance;
- final camera feel;
- sustained device performance;
- installed-footprint 2 GB proof;
- final production art/animation;
- actual third-person body-part targeting presentation.

## Current UI gap recorded during reconstruction

Runtime still does not match the newest approved UI zoning in all respects:
- objective/status upper-left: present;
- joystick lower-left: present;
- contextual action right: present;
- Settings top-center: not yet implemented;
- minimap upper-right: not yet implemented;
- Bag/inventory control: intentionally deferred and must remain absent.

## Next bounded package

`PIXEL_RPG_VISUAL_PACK_003_HUD_LAYOUT_ALIGNMENT`

Boundary:
- preserve movement, camera, Pack 001 world composition and Pack 002 hero visuals;
- preserve Bag deferral;
- add a top-center Settings control;
- add a compact upper-right minimap/navigation presentation grounded in the current physical world;
- keep objective/status upper-left, joystick lower-left and contextual actions right;
- do not expand unrelated gameplay systems;
- retain safe-area handling;
- add explicit UI/runtime verification before Android export.

## Abandoned authority exclusions

- Monster Choice RPG: ABANDONED — DO NOT USE.
- WorldLife RPG: ABANDONED — DO NOT USE.
- Shooter RPG: ABANDONED — DO NOT USE.
