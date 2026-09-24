# Hunt-01 Mudcrest Anatomy Integrity Runtime — 2026-09-04

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED / PHONE VALIDATION DEFERRED

## Bounded piece

`FIRST_SLICE_MUDCREST_ANATOMY_INTEGRITY_RUNTIME_IMPLEMENTATION`

Species owner:
`game/scripts/gameplay/monsters/monster_01/`.

Generic combat remains owner of attack legality, action/resource commitment, contact, body fallback, hit quality and local protection routing.

## Implemented source

- `game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd`;
- `game/scripts/gameplay/monsters/monster_01/README.md`;
- `game/tests/hunt01_mudcrest_anatomy_runtime_test.gd`;
- `tests/quality/hunt01/hunt01_mudcrest_anatomy_preflight.py`;
- `game/docs/HUNT01_MUDCREST_ANATOMY_INTEGRITY_RUNTIME.md`;
- encounter/Hunter-attack integration and production workflow coverage.

Implementation commit:
`da664deaa88a04cd2d2c5ca3ddd11953f897c7f2`.

QA repair / verified head:
`a70b7680f3a7d552a08fc9080a04bc40617c916b`.

## Runtime behavior

The species runtime:
- validates stable encounter and Monster identity;
- preserves the eight player-facing Mudcrest target groups plus declared `GENERAL_TORSO` body fallback;
- accepts only the already-committed `PENDING_ANATOMY_DAMAGE_RUNTIME` consequence;
- does not reroll contact or hit quality;
- validates the expected local protection for the resolved anatomy target;
- maintains normalized per-target integrity;
- derives one stable `resolution_id` from the committed combat transaction;
- makes replay/readback of that same resolution idempotent;
- rejects resolution-ID collisions with different source fingerprints;
- returns the anatomy result into the committed Hunter attack resolution.

The current arithmetic is explicitly:
`PROVISIONAL_FIRST_SLICE_ANATOMY_INTEGRITY_FIXTURE`.

It exists to exercise deterministic integrity state and protection routing. It is not final balance authority.

Example test fixture:
- CLEAN Dorsal Plates CUTTING contact from normalized integrity 100 → 95;
- replay of the same resolution remains at 95 rather than applying twice.

## Explicit non-ownership / deferred work

This piece does not implement:
- final health/damage balance;
- crack/break thresholds;
- sever thresholds;
- detached-part containers;
- bleeding/status effects;
- Monster reactions/attacks/behavior;
- Monster defeat/escape outcome;
- harvest extraction/inventory/crafting.

`ANATOMY_AND_DAMAGE.md` remains design authority for future structural semantics; unresolved numeric thresholds were not fabricated.

## Failure and repair evidence

Initial production run on the implementation commit stopped at the anatomy source preflight because the preflight required the literal phrase `break/sever` in the package README.

That was QA drift, not a runtime failure: the package README already separately and explicitly deferred both `crack/break thresholds` and `sever thresholds`, and the runtime already returned `NOT_EVALUATED_BREAK_SEVER_DEFERRED`.

Commit `a70b7680...` changed only that one source-gate assertion to validate the actual authority wording. No gameplay behavior changed.

## Verification evidence

Static manifest workflow:
`33853607294` — SUCCESS.

Production workflow:
`33853607287` — SUCCESS.

Production gates passed:
- authoritative manifest / production projection;
- Mudcrest anatomy source preflight;
- Godot 4.7.2 import/parse;
- AppShell smoke;
- Region-01 smoke;
- Hunt-01 production integration headless;
- combat turn shell + tactical movement headless;
- Mudcrest anatomy integrity headless;
- first Hunter attack + anatomy integration headless;
- Android debug APK export;
- APK/evidence artifact upload.

Verification classification:
- DESIGN RECORDED: YES;
- IMPLEMENTED: YES;
- STATIC VERIFIED: YES;
- HEADLESS VERIFIED: YES;
- ANDROID BUILD VERIFIED: YES;
- PHONE VERIFIED: NO / DEFERRED_BATCH;
- PERFORMANCE VERIFIED: NO.

## Next bounded piece

`FIRST_SLICE_HUNTER_REACTION_WINDOW_RUNTIME_IMPLEMENTATION`.

Reason:
The current Monster activation still ends through `WAIT_NO_ATTACK_RUNTIME`. All selected Mudcrest normal attacks require shared telegraph/reaction handling. The combat shell currently has no legal out-of-turn Hunter RP/Stamina commitment path, so reaction infrastructure must land before a real Monster attack can be integrated without bypassing the combat contracts.

The next piece belongs to generic combat, not Monster-01 anatomy.
