# Hunt-01 Tracking/Evidence Runtime Pass — 2026-09-04

Status: IMPLEMENTED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED / PHONE ACCEPTANCE DEFERRED

## Scope completed

Second production gameplay layer over the existing flat-themed Region-01 Hunt-01 world.

Implemented:
- seven physical clue profiles;
- runtime clue collection history;
- freshness / confidence / activity interpretation;
- deterministic route inference;
- old weak S02 Rootwood clue retained as valid historical evidence;
- fresh S03 water-exit clue correctly outranks it;
- no exact Monster GPS;
- audio not required;
- final clue progresses to `OBSERVATION_READY`;
- collected clue geometry disappears and cannot duplicate;
- future tactical-node debug discs stay hidden during ordinary exploration.

## Production files

- `game/content/regions/region_01/hunt01_tracking_evidence.json`
- `game/scripts/gameplay/tracking/hunt01_tracking_runtime.gd`
- `game/scripts/gameplay/tracking/README.md`
- `game/scenes/regions/region_01_hunt01_graybox.tscn`
- `game/tests/region01_hunt01_graybox_runtime_test.gd`

## Verification

Tested source head:
`0df278eba2d9265ed84483265957d9f8c2d7f415`.

Workflow:
`33845109063` — SUCCESS.

Results:
- source/projection: 49/49 PASS;
- Godot import/parse: PASS;
- AppShell smoke: PASS;
- Region-01 smoke: PASS;
- production tracking/headless integration: 66/66 PASS;
- Android debug export: PASS;
- APK integrity: PASS;
- artifact upload: PASS.

A first headless attempt exposed a test-harness timing assumption after direct Hunter teleportation into `Area3D` clues. The same layer was repaired by waiting for the authoritative collection count with a bounded physics-frame budget. Gameplay coordinates and tracking rules were not changed.

## APK evidence

`UnnamedHuntRPG-Hunt01-Layer2-Tracking.apk`

Size: 57,633,529 bytes
SHA-256: `8cecb327cba3e8a21ac7bb54b281d2e3e9b76616963985acf4512819b31204fe`

GitHub artifact ID: `9926241504`
Artifact ZIP digest: `sha256:6d0283c5a51daf656d7fd5095c682ab131502a6f53445a2a474976d48f769305`

Google Drive ID:
`13c3SGmTxlj8BldnRvIErWvQGizj7VYbt`.

## User validation policy

The user explicitly instructed development not to stop waiting for phone validation after each layer.

`USER_PHONE_VALIDATION_POLICY = DEFERRED_BATCH`

Therefore:
- this layer is not claimed phone-accepted;
- missing phone acceptance does not block independent production layers;
- phone/performance evidence remains separate and can be batched later.

## Exact next bounded piece

`FIRST_SLICE_REGION01_HUNT01_OBSERVATION_AND_ENCOUNTER_TRIGGER_RUNTIME_IMPLEMENTATION`.

That piece must consume `OBSERVATION_READY`, establish explicit engagement at the existing Meadow physical location, transition to first-person without teleporting to a disconnected arena, reveal tactical-node presentation only after encounter entry, and create encounter state without implementing attack resolution yet.
