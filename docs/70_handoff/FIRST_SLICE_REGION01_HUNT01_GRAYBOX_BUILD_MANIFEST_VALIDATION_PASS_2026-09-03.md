# Handoff — Hunt-01 Graybox Build Manifest + Validation Specification

Date: 2026-09-03
Status: BOUNDED PASS RECORDED / NO GRAYBOX SCENE / STATIC VALIDATOR NEXT

## Bounded piece

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_AND_VALIDATION_SPECIFICATION`.

## Objective

Translate the already-recorded Hunt-01 geometry into stable build entries and explicit validation rules so future graybox construction can be checked mechanically instead of relying on visual/manual memory.

## Source authority

Read from current branch before work:
- `EVOLVE_ALIGNMENT.md`;
- Hunt-01 integration contract/spatial registry;
- Hunt-01 graybox geometry specification/registry;
- `CONTENT_DATA_GUIDE.md`;
- `CODE_GUIDE.md`;
- Region 01/World/Quality front doors.

## New durable authorities

Region package:
- `docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.md`;
- `docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`;
- `docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.

This handoff records the pass; it does not own the rules above.

## Build-manifest decisions

Engine-neutral hierarchy:
- `gb_h01_root`;
- physical groups for S00, S00→S01, S01 Ford, S01→S03, EF02 and escape stub;
- dedicated DEBUG groups for evidence, tactical nodes, Monster clearance, camera clearance and streaming proxies.

Machine-readable manifest records:
- proof/Monster/encounter identities;
- meter/axis/space frame;
- physical terrain/corridor/cover entries;
- seven evidence entries;
- ten tactical nodes;
- fourteen tactical links;
- Monster pivot/body-force/Charge clearances;
- escape corridor;
- camera clearances;
- three stream proxies;
- allowed terrain tags;
- validation-rule IDs `H01VAL001..030`.

## New reversible build coordinates

The geometry owner already required a 6–7 m curved observation→N01 ramp because the direct chord is too steep.

This pass adds one explicit build-only midpoint:

`build_ctrl_h01_obs_ramp_mid = (-74.0, 4.62, -237.5)`.

Its classification is:
`PROTOTYPE_BUILD_CONTROL_NOT_GAMEPLAY_ANCHOR`.

It must not become persistence/evidence/tactical/Monster authority without a later bounded promotion.

The manifest also selects a nominal build placement for the west brush belt:
`(-74,4,-250)` with 12 m nominal depth inside the existing allowed 10–14 m range.

This is also build placement only.

## Validation layers

Recorded levels:
1. `MANIFEST_STATIC`;
2. `SCENE_STATIC_FUTURE`;
3. `RUNTIME_FUTURE`;
4. `PHONE_FUTURE`.

Lower layers cannot be reported as higher verification.

Thirty rule IDs are recorded.

The first executable validator must implement at least the MANIFEST_STATIC subset:
`H01VAL001,002,003,004,012,013,014,021,024,025,026,027,030`.

## Current verification truth

Recorded:
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_BUILD_MANIFEST_RECORDED = YES`
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION_RECORDED = YES`.

Not implemented/verified:
`HUNT01_GRAYBOX_MANIFEST_STATIC_VALIDATOR_IMPLEMENTED = NO`
`HUNT01_GRAYBOX_MANIFEST_STATIC_VERIFIED = NO`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`
`PERFORMANCE_VERIFIED = NO`.

## Regression/ownership inspection

Preserved:
- canonical Region 01 topology;
- stable evidence coordinates;
- N01–N10 coordinates and 14-link graph;
- Monster MA01/escape/reacquisition identities;
- terrain-rule ownership;
- physical-cover semantics;
- camera non-authority;
- streaming proxy non-gameplay status;
- Galaxy A03s phone gate.

No production gameplay source or engine scene was created.

## Exact next bounded action

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_STATIC_VALIDATOR_IMPLEMENTATION`.

Purpose:
implement an engine-independent validator over the JSON manifest and current source-coordinate constants so the MANIFEST_STATIC subset can produce real PASS/FAIL evidence before any engine graybox exists.

Expected future source location should follow the project test/quality ownership after rereading `CODE_GUIDE.md` and `docs/60_quality/README.md`.

Do not use that validator to claim scene/runtime/phone verification.
