# Hunt-01 Graybox Manifest Static QA

Status: EXECUTABLE MANIFEST-STATIC QA PACKAGE / NO ENGINE SCENE VERIFICATION

## Purpose

Validate the machine-readable Region 01 Hunt-01 graybox build manifest before an engine graybox exists.

Owning Region contract:
`docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_VALIDATION_SPECIFICATION.md`.

Machine input:
`docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json`.

This package may establish only `MANIFEST_STATIC`. It may not establish scene, runtime, phone, graybox implementation, or performance verification.

## Files

- `hunt01_graybox_manifest_validator.py` — Python standard-library-only validator.
- `hunt01_stable_coordinate_fixture.json` — stable-coordinate source table derived from the current Hunt-01 spatial registry.

The fixture records the Git blob SHA of its owning spatial registry. If that authority changes, validation fails until the fixture is deliberately reconciled.

## Implemented rules

`H01VAL001, H01VAL002, H01VAL003, H01VAL004, H01VAL012, H01VAL013, H01VAL014, H01VAL021, H01VAL024, H01VAL025, H01VAL026, H01VAL027, H01VAL030`.

The validator also reports group/entry counts, tactical-link distances, observation-ramp path length and segment grades, route metadata, coordinate-source consistency, and all higher validation levels as `NOT_EXECUTED`.

## Run

```bash
python3 tests/quality/hunt01/hunt01_graybox_manifest_validator.py \
  --manifest docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json \
  --fixture tests/quality/hunt01/hunt01_stable_coordinate_fixture.json \
  --repo-root . \
  --json-out build-evidence/hunt01-graybox-manifest-static.json
```

Exit codes: `0` PASS, `1` authoritative validation ERROR, `2` manifest/fixture load failure.

## Negative self-test

```bash
python3 tests/quality/hunt01/hunt01_graybox_manifest_validator.py \
  --manifest docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json \
  --fixture tests/quality/hunt01/hunt01_stable_coordinate_fixture.json \
  --repo-root . \
  --self-test-invalid
```

The self-test moves N01 outside EF02 and injects an invalid terrain tag. It passes only when the validator rejects the corrupted manifest.

## CI

Workflow: `.github/workflows/hunt01-graybox-manifest-static.yml`.

It runs positive validation, the intentional negative self-test, and uploads validation JSON/log evidence.
