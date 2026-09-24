# Pixel RPG — World Pack 004 Enterable Smith Vertical Slice — 2026-09-21

Status: IMPLEMENTED / GODOT PARSE VERIFIED / HEADLESS SMOKES VERIFIED / PACKS 002–003 PRESERVED / ENTERABLE-SMITH PHYSICS GATE VERIFIED / DOMAIN REGRESSIONS VERIFIED / ANDROID BUILD VERIFIED / PHONE ACCEPTANCE OPEN
Branch: `pixel-rpg`

## Bounded piece

`PIXEL_RPG_WORLD_PACK_004_ENTERABLE_SMITH_VERTICAL_SLICE`

## Verified source

`47ade9413fe24f15453ee6fb0135b270b2d3ce8d`

Workflow `35566025131`: SUCCESS.  
Job `106227900327`: SUCCESS.

## What Pack 004 changed

The settlement smith is no longer a decorative blocked facade.

A new reusable module was added:
- `game/scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd`.

The historical Pack 001 smith implementation remains untouched for audit/rollback, but the live prototype now instantiates the Pack 004 smith instead.

Physical contract:
- footprint: `6.6 m × 6.4 m`;
- wall height: `3.3 m`;
- doorway clear width: `1.8 m`;
- doorway clear height: `2.4 m`;
- modular back/side/front wall segments;
- collision aligned to those wall segments;
- no monolithic `SmithCollision`;
- doorway center remains physically clear.

Interior:
- readable floor;
- forge hearth + ember surface;
- smith bench;
- anvil;
- tool rack;
- entrance anchor;
- bounded smith-use anchor.

Third-person camera readability:
- `RoofA`, `RoofB` and `RidgeBeam` hide while the hunter is inside the smith footprint;
- roof elements restore after exiting.

Interaction:
- approaching the smith-use anchor exposes `USE`;
- the current action only confirms the accessible station;
- full crafting/economy is explicitly not claimed or implemented by this slice.

## Runtime files

Added:
- `game/scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd`;
- `game/tests/pixel_rpg_world_pack_004_enterable_smith_runtime_test.gd`.

Modified:
- `game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`;
- `.github/workflows/pixel-rpg-prototype-android.yml`.

## Verification evidence

PASS:
- Godot `4.7.2.stable` import/parse;
- Pixel RPG AppShell smoke;
- Pixel RPG prototype scene smoke;
- Pack 002 runtime gate: `24/24`;
- Pack 003 HUD runtime gate: `19/19`;
- Pack 004 enterable-smith runtime/physics gate: `19/19`;
- preserved deterministic combat/anatomy/status domain suites;
- Android debug export;
- package-size ceiling;
- APK artifact upload;
- build-evidence upload.

The Pack 004 gate specifically verifies:
- old Pack 001 smith is not instantiated in the live prototype;
- old monolithic `SmithCollision` is absent;
- entrance/use anchors exist;
- interior station geometry exists;
- doorway is `1.8 m` clear and wider than the hunter body;
- lintel clears the `2.4 m` contract;
- a physics ray passes through the doorway;
- an adjacent front-wall ray is blocked;
- roof hides inside and restores outside;
- smith `USE` interaction is available;
- no full-crafting claim is made.

Measured exported APK:
`58,006,217` bytes.

Package ceiling:
`2,000,000,000` bytes.

Artifacts:
- APK `10623673945` — `PixelRPG-prototype-001-debug`;
  - artifact archive bytes: `57,489,727`;
  - digest: `sha256:723fdff70f19a442a365e97f260953507b348b563e8727ac56dbd6c7b10e2ca0`;
- evidence `10623923310` — `PixelRPG-prototype-001-build-evidence`;
  - digest: `sha256:7f51d216c21247ad4064e9826872bc8265c68a23eeef9599f822de38f2647076`.

## Verification boundary

Confirmed:
- source integration = YES;
- Pack 004 scene construction = YES;
- doorway geometry contract = YES;
- doorway physics clearance = YES;
- adjacent wall collision = YES;
- interior roof handling = YES;
- bounded smith interaction = YES;
- Packs 002–003 preserved = YES;
- deterministic domain regressions preserved = YES;
- Android build = YES.

Still open:
- phone visual acceptance;
- final camera feel inside buildings;
- sustained device performance;
- installed-footprint verification;
- full smith NPC/crafting/economy;
- broader settlement interior rollout.

## Combat-integration finding

The repository's older Hunt-01 combat domain is still valuable deterministic gameplay authority, but its old encounter presentation/runtime assumes:
- a different Region-01 world;
- legacy absolute coordinates near the old encounter footprint;
- legacy HUD nodes;
- a forced first-person camera on ENGAGE.

Those assumptions conflict with current Pixel RPG's third-person presentation and current compact world. They must not be wired directly into the Pixel RPG prototype.

## Next bounded package

`PIXEL_RPG_COMBAT_BRIDGE_001_THIRD_PERSON_TARGETING_PREVIEW`

Boundary:
- preserve current Pixel RPG third-person camera and physical actor positions;
- do not invoke the obsolete forced-first-person encounter trigger;
- add a current-world ENGAGE/target-acquisition state near the live Mudcrest;
- expose the existing Mudcrest visual target groups through a touch-safe body-part targeting panel;
- map every selectable target to the corresponding Pack 002 visual node;
- preserve movement/camera behavior until explicit ENGAGE;
- while targeting is open, prevent HUD touches from becoming camera-look input;
- do not apply damage/AP/Stamina or claim full combat integration yet;
- preserve deterministic combat/anatomy domain files unchanged;
- use this bridge to establish the correct third-person presentation contract before adapting the older combat runtime to current-world coordinates.

## Abandoned authority exclusions

- Monster Choice RPG: ABANDONED — DO NOT USE.
- WorldLife RPG: ABANDONED — DO NOT USE.
- Shooter RPG: ABANDONED — DO NOT USE.
