# Pixel RPG — Visual Pack 003 HUD Layout Alignment — 2026-09-21

Status: IMPLEMENTED / GODOT PARSE VERIFIED / HEADLESS SMOKES VERIFIED / PACK 002 PRESERVED / HUD RUNTIME GATE VERIFIED / DOMAIN REGRESSIONS VERIFIED / ANDROID BUILD VERIFIED / PHONE VISUAL ACCEPTANCE OPEN
Branch: `pixel-rpg`

## Bounded piece

`PIXEL_RPG_VISUAL_PACK_003_HUD_LAYOUT_ALIGNMENT`

## Verified source

`449a409cdf812c7b36cfbb42e2298acdf5a5b082`

Workflow `35565414747`: SUCCESS.  
Job `106226140792`: SUCCESS.

## What Pack 003 changed

HUD zoning now matches the current Pixel RPG direction:
- objective/status remain upper-left;
- Settings is centered toward the top;
- a compact minimap/navigation panel occupies the upper-right;
- movement joystick remains lower-left;
- contextual action remains on the right;
- Diamond Watch remains available below the minimap;
- Bag/inventory remains intentionally absent.

Settings:
- opens a real session settings panel;
- currently owns camera-look sensitivity only;
- sensitivity is clamped to the tested `0.06–0.18` range;
- no persistence is claimed yet.

Minimap:
- is grounded in the current prototype world bounds rather than being decorative;
- maps hunter X/Z position from the current `[-23, 23]` X and `[-57, 20]` Z world envelope;
- shows the current settlement/street/trail/gate composition;
- updates the player marker from the actual hunter world position.

Input safety:
- Settings, minimap, Watch, visible settings panel and action controls are excluded from right-side camera-look capture;
- existing move/look semantics are otherwise unchanged.

## Runtime files

Modified:
- `game/scenes/prototypes/pixel_rpg_prototype_001.tscn`;
- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`;
- `.github/workflows/pixel-rpg-prototype-android.yml`.

Added:
- `game/tests/pixel_rpg_visual_pack_003_hud_runtime_test.gd`.

## Verification evidence

PASS:
- Godot `4.7.2.stable` import/parse;
- Pixel RPG AppShell smoke;
- Pixel RPG prototype scene smoke;
- Visual Pack 002 runtime gate: `24/24`;
- Visual Pack 003 HUD runtime gate: `19/19`;
- preserved deterministic combat/anatomy/status domain tests;
- Android debug export;
- package-size ceiling;
- APK artifact upload;
- evidence artifact upload.

Measured exported APK:
`57,993,451` bytes.

Package ceiling:
`2,000,000,000` bytes.

Artifacts:
- APK `10624410805` — `PixelRPG-prototype-001-debug`;
  - artifact archive bytes: `57,477,219`;
  - digest: `sha256:3ded02d8d6abd02011adc70f1890e4ba056b5d25cb4bf58f23bfd3c3646b433f`;
- evidence `10624027197` — `PixelRPG-prototype-001-build-evidence`;
  - digest: `sha256:ce767c151c32f5027c9617ca0ae4cd22b1222b3a1fa522662c5d932831f0e277`.

## Verification boundary

Confirmed:
- source integration = YES;
- scene/resource parse = YES;
- Pack 002 hero/anatomy visual gate = YES;
- Pack 003 HUD zoning/settings/minimap gate = YES;
- Bag deferral = YES;
- headless prototype runtime = YES;
- selected deterministic domain regressions = YES;
- Android build = YES;
- package ceiling = YES.

Still open:
- physical phone visual acceptance;
- final camera feel;
- sustained device performance;
- installed-footprint 2 GB proof;
- persistent settings storage;
- final production UI art;
- actual third-person body-part targeting presentation.

## Next bounded package

`PIXEL_RPG_WORLD_PACK_004_ENTERABLE_SMITH_VERTICAL_SLICE`

Why this is next:
- the current smith/service landmark is still a visually solid shell;
- its prototype collision is one full blocking box;
- this violates the current Pixel RPG building rule for important buildings.

Boundary:
- preserve Packs 001–003;
- keep the smith footprint near its current `6.6 m × 6.4 m` scale;
- replace the fake front/solid shell with real wall segments and a navigable doorway;
- replace the monolithic smith collision with wall-aligned collision that leaves the doorway clear;
- create a readable interior floor and first smith-use station;
- make roof handling camera-readable while the hunter is inside;
- preserve world scale, street alignment and Android-safe performance;
- do not add full crafting/economy systems yet;
- add an explicit runtime verification gate before Android export.

## Abandoned authority exclusions

- Monster Choice RPG: ABANDONED — DO NOT USE.
- WorldLife RPG: ABANDONED — DO NOT USE.
- Shooter RPG: ABANDONED — DO NOT USE.
