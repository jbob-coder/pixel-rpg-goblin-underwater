# Hunt-01 Mudcrest Anatomy Integrity Runtime

Status: IMPLEMENTED IN SOURCE / AUTOMATED VERIFICATION PENDING
Last reconciled: 2026-09-04

Bounded piece:
`FIRST_SLICE_MUDCREST_ANATOMY_INTEGRITY_RUNTIME_IMPLEMENTATION`.

## Purpose

Add the first species-owned anatomy consequence after the generic Hunter attack has already committed resources and resolved target contact/body fallback, hit quality and local protection.

Owner:
`game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd`.

Input:
existing Hunter-attack `damage_handoff`.

## Runtime law

The anatomy runtime does not reroll the attack. It consumes the committed trace using a stable resolution identity composed from the existing encounter/round/action/actor/technique context.

It tracks normalized per-target integrity for:
- `HEAD`;
- `HORN_CREST`;
- `FORELEG_L`;
- `FORELEG_R`;
- `HINDLEG_L`;
- `HINDLEG_R`;
- `DORSAL_PLATES`;
- `TAIL`;
- internal body-fallback target `GENERAL_TORSO`.

The runtime rejects mismatched encounter/actor/technique/channel/protection data and prevents the same resolution ID from applying integrity loss twice. Reuse of one resolution ID with a changed source fingerprint is rejected as a collision.

## Provisional numeric fixture

`PROVISIONAL_FIRST_SLICE_ANATOMY_INTEGRITY_FIXTURE`.

Each target begins with normalized integrity 100 solely so state transitions can be implemented and tested now. Hit-quality load and CUTTING protection reductions are deterministic provisional values. They are not final health, armor or weapon balance.

The current fixture encodes only the already-recorded qualitative direction that hard horn/mineralized plate resists CUTTING more strongly than hide.

Example first-slice deterministic outcomes:
- CLEAN + `MINERALIZED_DORSAL_PLATE`: provisional load 12 - reduction 7 = integrity loss 5;
- GRAZE + `HIDE_TORSO`: provisional load 4 - reduction 1 = integrity loss 3.

These examples may be retuned or replaced when final combat arithmetic is authored; the stable transaction/state ownership should remain.

## Explicit non-scope

This piece does not implement or claim:
- final Monster health/damage balance;
- crack/break thresholds;
- horn or dorsal structural state transitions;
- tail sever/detachment;
- bleeding or other status effects;
- Monster reactions/attacks/AI;
- defeat/escape outcome;
- harvest quantity;
- phone acceptance;
- performance verification.

All structural thresholds remain `NOT_EVALUATED_BREAK_SEVER_DEFERRED`.

## Required verification

Before this piece can be marked verified:
- source/static anatomy preflight;
- Godot 4.7.2 parse/import;
- existing production integration regressions;
- existing combat/attack regressions;
- dedicated anatomy headless test;
- Android debug APK export/integrity/artifact upload.

Phone validation remains deferred-batch.
