# Hunt-01 Production Graybox Implementation Pass — 2026-09-04

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED / PHONE RETEST REQUIRED

## Bounded piece

`FIRST_SLICE_REGION01_HUNT01_MINIMAL_ENGINE_GRAYBOX_IMPLEMENTATION`

This pass created the first production Godot project under `game/`. It does not convert the disposable `probes/android_stage1/` tree into production architecture.

## User gate that authorized this pass

The Samsung Galaxy A03s shooter-style Stage-1 controls were reported by the user as **100% PASS** on 2026-09-04.

Accepted control law preserved in production:
- left fixed joystick = direct camera-relative movement;
- fixed stick direction does not accumulate view turn;
- right-side drag = independent look;
- simultaneous move/look;
- first-person FOV 115°;
- first-person pitch ±80°;
- Look Speed default 35%;
- no adaptive hold/alignment/latch/rebase steering state.

`STAGE1_SHOOTER_STYLE_CONTROLS_PHONE_ACCEPTED = YES`
`ENGINE_FUNCTIONAL_PHONE_PROBE_VERIFIED = YES`
`PERFORMANCE_VERIFIED = NO` — sustained target-device soak remains separate.

## Production source

Production project root:
`game/`

Primary scene:
`game/scenes/regions/region_01_hunt01_graybox.tscn`

Presentation/input adapter:
`game/scripts/presentation/exploration/region_01_hunt01_graybox.gd`

Runtime manifest projection:
`game/content/regions/region_01/hunt01_graybox_build_manifest.json`

Authority remains:
`docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`.

The runtime projection is CI-checked against the docs authority and must not be edited independently.

## What is physically present

The production graybox currently builds:
- S00 departure/choice area;
- 13 required Hunt-01 route slabs through S01/S03 to N01;
- reversible S02 wrong-route stub;
- River Ford basin plus water/mud visual zones;
- S01→S03 transition/visibility-break forms;
- EF02 Feeding Meadow/open core/observation shelf;
- physical boulder and scarred-tree cover;
- 7 gold evidence markers;
- 10 cyan tactical-node markers;
- solid Mudcrest Raker placeholder `monster_r01_m01_0001`;
- Monster pivot/Charge clearance debug geometry;
- 3 S03→S05 escape-route slabs;
- non-colliding camera/stream debug volumes;
- production HUD, coordinates, reset-to-S00, aerial/first-person view, Settings/Look Speed.

Combat, evidence investigation semantics, persistent Monster behavior, harvesting, inventory, crafting, Settlement services and persistence are NOT implied by this graybox implementation.

## Route evidence classification

Raw manifest construction-anchor polyline measured by implementation:
`282.926 m`.

This is construction/pre-smoothing evidence only. The authoritative `285–315 m` value is the future finished/smoothed navigable-path target.

`H01VAL005_FINAL_SMOOTHED_ROUTE_LENGTH = NOT_EXECUTED`.

The implementation intentionally did not move valid coordinates merely to force the raw polyline into the future smoothed-path range.

## Verification

Tested source head:
`ef0db3b4dcbea32608228f99a8fffead5ad6c858`.

Production workflow:
`33836865365` — SUCCESS.

Manifest/projection/source gate:
`29/29 PASS`.

Headless production integration:
`23/23 PASS`.

Verified in CI:
- authoritative manifest/static validation;
- runtime projection equality;
- Android ETC2/ASTC requirement;
- Godot 4.7.2 import/parse;
- production AppShell smoke;
- production Region-01 smoke;
- required build identities/counts;
- S00/Meadow/Monster collision proofs;
- non-colliding stream proxies;
- 115° first-person FOV;
- aerial↔first-person toggle;
- reset to S00;
- Android debug export;
- APK archive integrity;
- artifact upload.

These checks do not prove Galaxy A03s traversal/visual feel, every final dimensional tolerance, the future smoothed route length, or sustained performance.

## Build identity

Workflow artifact ID:
`9923580879`

Artifact ZIP:
`57,142,468 bytes`
SHA-256 `184d158058df55f1b02dd92801c4af87376bc8f867d2bd77d29e6223368420db`

Inner production APK:
`UnnamedHuntRPG-Hunt01-Graybox-Retest.apk`
`57,587,191 bytes`
SHA-256 `7094b3046a6a35144b3d6c80bab8b6900a1fc33d9c04cbeca9d9a80e2361e36a`

Google Drive folder:
`Unnamed Hunt RPG`

Drive file ID:
`150Wot1owtIGrFWUG_BmfWWlXmlMUT02F`

## Current status

`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = YES`
`HUNT01_PRODUCTION_PROJECTION_STATIC_VERIFIED = YES / 29_OF_29`
`HUNT01_PRODUCTION_GRAYBOX_HEADLESS_VERIFIED = YES / 23_OF_23`
`HUNT01_PRODUCTION_ANDROID_BUILD_VERIFIED = YES`
`REGION01_HUNT01_PHONE_VERIFIED = NO / RETEST_REQUIRED`
`HUNT01_GRAYBOX_SCENE_STATIC_FULL_DIMENSION_GATE = NOT_EXECUTED`
`H01VAL005_FINAL_SMOOTHED_ROUTE_LENGTH = NOT_EXECUTED`
`PERFORMANCE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

## Parallel next actions

External device gate:
`REGION01_HUNT01_PRODUCTION_GRAYBOX_GALAXY_A03S_RETEST`.

Next independent game-development piece while phone evidence is pending:
`FIRST_SLICE_REGION01_HUNT01_TRACKING_EVIDENCE_RUNTIME_IMPLEMENTATION`.

That next piece should make the seven existing physical evidence anchors investigable and establish deterministic evidence order/confidence/route interpretation without implementing combat, harvest or unrelated systems in the same pass.
