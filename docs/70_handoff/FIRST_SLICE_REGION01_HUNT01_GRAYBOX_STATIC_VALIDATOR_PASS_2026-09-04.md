# Handoff — Hunt-01 Graybox Manifest Static Validator

Date: 2026-09-04
Status: IMPLEMENTED / MANIFEST_STATIC VERIFIED / NO ENGINE SCENE CLAIM

## Bounded piece

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_STATIC_VALIDATOR_IMPLEMENTATION`.

## Durable source

- `tests/quality/hunt01/hunt01_graybox_manifest_validator.py`
- `tests/quality/hunt01/hunt01_stable_coordinate_fixture.json`
- `tests/quality/hunt01/README.md`
- `.github/workflows/hunt01-graybox-manifest-static.yml`

Owning validation contract remains:
`docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.

## Implemented rules

`H01VAL001,002,003,004,012,013,014,021,024,025,026,027,030`.

The validator uses only the Python standard library and returns non-zero on authoritative ERROR.

## Verification

Workflow: `33830978945`
Job: `100893737844`
Result: SUCCESS
Tested commit: `ed60f25454a77af7196a5ad01c3f7cd440360784`

Positive result:
- 13/13 MANIFEST_STATIC rules PASS;
- 0 errors;
- 0 warnings;
- 12 build groups;
- 22 physical/build entries;
- 7 evidence anchors;
- 10 tactical nodes;
- 14 tactical links;
- 3 stream proxies.

Measured observation ramp:
- total path `6.607 m`;
- segment 1 grade `15.2%`;
- segment 2 grade `15.38%`;
- both under the current `18%` short-transition target.

Negative self-test deliberately moved N01 outside EF02 and injected an invalid terrain tag. The validator produced 5 errors and `NEGATIVE_SELF_TEST=PASS`, proving failure detection.

Evidence artifact:
- ID `9921659636`;
- size `4,904 bytes`;
- artifact ZIP SHA-256 `0c3eb67588a74bcb6d3ce615c85c57208c1fb876a6485fe1987915dce194de92`.

## Verification boundary

`HUNT01_GRAYBOX_MANIFEST_STATIC_VALIDATOR_IMPLEMENTED = YES`
`HUNT01_GRAYBOX_MANIFEST_STATIC_VERIFIED = YES / 13_OF_13`
`HUNT01_GRAYBOX_SCENE_STATIC_VERIFIED = NO`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`.

No scene/runtime/phone rule was promoted by this PASS.
