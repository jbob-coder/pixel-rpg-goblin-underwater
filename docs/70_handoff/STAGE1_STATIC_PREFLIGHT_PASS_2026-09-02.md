# Stage 1 Static Preflight QA Pass — 2026-09-02

Status: BOUNDED IMPLEMENTATION-QA PREPARATION PASS COMPLETE / GODOT EXECUTION STILL PENDING

## EVOLVE compliance

This pass began by rereading the current repository copy of `EVOLVE_ALIGNMENT.md`, followed by the current `PROJECT_HANDOFF.md` and the owning Stage 1 probe source/test protocol.

The current implementation gate forbids adding further Stage 1 gameplay/visual complexity before the existing probe is verified.

Therefore this pass did not add gameplay, combat, harvesting, crafting, production assets, Region 01 content or Stage 2 domain source.

The bounded quality piece was:
**add static repository-level preflight tooling around the existing Stage 1 probe so obvious source/reference regressions can be caught before later Godot/APK/phone testing.**

## Files created

- `probes/android_stage1/tests/static_preflight.py`;
- `probes/android_stage1/tests/README.md`.

## Files reconciled

- `probes/android_stage1/README.md`;
- `probes/android_stage1/docs/PROBE_TEST_PROTOCOL.md`.

## Primary quality fix

Previously, Test 0 existed only as a human checklist.

The probe now has an executable Python/standard-library static guard for invariants that do not require Godot itself.

It checks:
- required files;
- configured main-scene path;
- key Stage 1 renderer/viewport/orientation/frame-pacing text;
- `res://` source references;
- scene ExtResource/SubResource declaration/use consistency;
- duplicate external/sub-resource IDs;
- one-root-node integrity;
- duplicate node paths;
- child-parent node-path validity;
- root scene script resolution;
- signal source/target node paths;
- connected method existence;
- current `@onready $Node/Path` references;
- expected root type/script inheritance pairing;
- probe-only GDScript source boundary.

## Verification boundary

The static checker is intentionally not a Godot parser.

Its PASS state is:
`STATIC_PREFLIGHT_VERIFIED`.

It may not promote:
- `GODOT_PARSE_VERIFIED`;
- `EDITOR_RUN_VERIFIED`;
- `ANDROID_PRESET_VERIFIED`;
- `APK_BUILD_VERIFIED`;
- `PHONE_INSTALL_VERIFIED`;
- `PHONE_RUNTIME_VERIFIED`;
- `PERFORMANCE_VERIFIED`;
- `ENGINE_PHONE_PROBE_VERIFIED`.

Those still require their actual execution environments.

## Harness self-test performed

The harness logic was executed against a local reconstruction of the exact currently fetched probe source files because the available execution environment cannot clone GitHub.

Positive result after regression hardening:
- `123 / 123` checks PASS;
- process exit code `0`;
- reported gate `STATIC_PREFLIGHT_VERIFIED`.

Negative validation 1:
- Boot's `res://scenes/probe_world.tscn` reference was deliberately changed to a missing scene;
- harness returned exit code `1`;
- missing reference was reported as failure.

Negative validation 2:
- an unauthorized `scripts/rogue_gameplay.gd` was deliberately added;
- harness returned exit code `1`;
- source-boundary failure was reported.

Negative validation 3:
- a duplicate scene sub-resource ID was deliberately introduced;
- harness returned exit code `1`;
- duplicate-resource failure was reported.

This demonstrates that the checker does not merely print PASS for the happy path.

## Important limitation

The environment cannot resolve GitHub through normal `git clone`, and it does not contain a Godot executable.

Therefore:
- `REAL_CHECKOUT_PREFLIGHT_RUN = PENDING`;
- `GODOT_PARSE_VERIFIED = NO`;
- `EDITOR_RUN_VERIFIED = NO`.

The next real environment should run the script from the actual checkout before opening the project in Godot.

## Corrected stale state

The probe README previously still said:
`SOURCE_READBACK_VERIFIED = PENDING`.

Current durable project handoff already proved source readback occurred.

The probe README now correctly records:
`SOURCE_READBACK_VERIFIED = YES`.

This is state reconciliation, not a new runtime claim.

## Updated Test 0

`PROBE_TEST_PROTOCOL.md` now requires:

```bash
cd probes/android_stage1
python tests/static_preflight.py
```

from the actual source checkout.

A real-checkout PASS becomes the static prerequisite for the Godot import/parse gate.

## Evidence-record requirement

Later executed gates should record:
- date/time;
- branch/commit SHA;
- gate number/name;
- machine/device;
- Godot version where applicable;
- exact command/action;
- PASS/FAIL;
- warnings/errors;
- evidence references;
- repair files;
- rerun result.

This prevents test evidence from being detached from the tested source revision.

## Current implementation state

`STAGE_1_PROBE_SOURCE_CREATED = YES`
`SOURCE_READBACK_VERIFIED = YES`
`STATIC_PREFLIGHT_HARNESS = RECORDED`
`HARNESS_LOGIC_SELF_TESTED = YES`
`CURRENT_FETCHED_SOURCE_SNAPSHOT_PREFLIGHT = 123_OF_123_PASS`
`REAL_CHECKOUT_PREFLIGHT_RUN = PENDING`
`GODOT_PARSE_VERIFIED = NO`
`EDITOR_RUN_VERIFIED = NO`
`ANDROID_PRESET_VERIFIED = NO`
`APK_BUILD_VERIFIED = NO`
`PHONE_INSTALL_VERIFIED = NO`
`PHONE_RUNTIME_VERIFIED = NO`
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`

## Exact next implementation piece

In a real repository checkout:
1. run `python tests/static_preflight.py` from `probes/android_stage1/`;
2. record tested commit SHA and full result;
3. if PASS, open/import the existing probe with Godot 4.7-family tooling;
4. fix only actual project/scene/GDScript parse failures;
5. run Boot/ProbeWorld editor smoke;
6. record exact warnings/errors and rerun results.

Do not add more Stage 1 visual/gameplay complexity before those gates close.

Independent gameplay-design work remains separately controlled by EVOLVE and must not be combined into this implementation-QA piece.
