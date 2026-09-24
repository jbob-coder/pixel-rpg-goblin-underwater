# Pixel RPG — World Composition Pack 001 Handoff — 2026-09-20

Status: IMPLEMENTED / GODOT PARSE VERIFIED / HEADLESS SMOKES VERIFIED / DOMAIN REGRESSIONS VERIFIED / ANDROID BUILD VERIFIED / PHONE VISUAL ACCEPTANCE OPEN
Branch: `pixel-rpg`

## Bounded piece

`PIXEL_RPG_PROTOTYPE_002_WORLD_COMPOSITION — PACK 001`

## Verified source

`1c513af4097303f4f9a8c5e07eae97c7b615b91d`

Workflow `35489990032`: SUCCESS.  
Job `106023171735`: SUCCESS.

## What Pack 001 changed

The runtime world-composition layer now adds reusable lightweight pixel-consistent 3D forms for:
- settlement gate framing;
- smith/service landmark;
- market stall;
- gate-side service clutter;
- lantern rhythm;
- neutral banner;
- physical signpost;
- path-edge fences;
- layered vegetation;
- trail rock cluster.

The integration deliberately preserves:
- third-person controller semantics;
- SpringArm camera;
- 800×360 low-resolution SubViewport + nearest upscale;
- safe-area HUD;
- Gate Warden interaction;
- distant monster observation interaction;
- deterministic combat/anatomy/status domain behavior.

The old visible gate primitives were replaced, but conservative invisible collision boxes remain around the gate posts. The old market/smith grayboxes were replaced instead of visually stacked on top of the new package. The old right trail rock was removed to avoid duplicate composition.

## Runtime files

- `game/scripts/presentation/pixel_rpg/world_pack_001.gd`;
- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`.

## Source package in Google Drive

Folder:
`Pixel RPG / Asset Packages / PIXEL_RPG_WORLD_COMPOSITION_PACK_001`

Folder ID:
`1kYy8c73QHwBqkfvJGsZzWk35nZQh8PZy`

ZIP:
`PIXEL_RPG_WORLD_COMPOSITION_PACK_001.zip`

ZIP Drive ID:
`19igUb95rRPJcbCFeEhP15uKHjLDmElWF`

The Drive source package also preserves GLB prototypes, 16×16 source textures, manifest, placement plan, QA record and preview material. The live repository uses the procedural equivalent for this first integration because the connected GitHub path used here does not provide direct binary-file upload; this keeps the verified runtime lightweight and auditable.

## Verification evidence

PASS:
- Godot 4.7.2 import/parse;
- Pixel RPG AppShell smoke;
- Pixel RPG prototype scene smoke;
- combat turn shell;
- tactical movement;
- first Hunter attack;
- Mudcrest anatomy integrity;
- generic status application;
- generic status timing;
- Android debug export;
- package-size gate.

Measured APK:
`57,968,220` bytes.

Package ceiling:
`2,000,000,000` bytes.

Artifacts:
- APK `10599110903` — `PixelRPG-prototype-001-debug`;
- evidence `10598976147` — `PixelRPG-prototype-001-build-evidence`.

## Verification boundary

Confirmed:
- PACK 001 runtime integration = YES;
- Godot parse = YES;
- headless AppShell smoke = YES;
- headless prototype smoke = YES;
- selected deterministic domain regressions = YES;
- Android build = YES;
- package ceiling = YES.

Still open:
- phone runtime acceptance;
- phone visual-quality acceptance;
- sustained performance;
- installed-footprint 2 GB verification.

## Recommended next bounded package

`PIXEL_RPG_VISUAL_PACK_002_HUNTER_MONSTER_READABILITY`

Focus on the two hero silhouettes that remain most obviously placeholder-level: the visible hunter and the distant monster. Preserve all gameplay authority and only improve visual presentation/readability.
