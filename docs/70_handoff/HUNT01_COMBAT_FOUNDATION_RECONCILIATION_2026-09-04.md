# Hunt-01 Combat Foundation Reconciliation — 2026-09-04

Status: RECONSTRUCTED FROM LIVE SOURCE / AUTOMATED BASELINE GREEN

## Why this handoff exists

The project front-door documents were stale: they still described Layer 2 tracking as the current endpoint and observation/encounter as the next piece, while the live branch had already advanced through observation/ENGAGE, combat turn shell, tactical movement and first Hunter attack contact resolution.

Current source/build evidence supersedes those stale status sections.

## Verified source baseline

Repository: `jbob-coder/Chatgptjuegolpcal`
Branch: `worldlife-reference-docs`
Source head tested before documentation reconciliation:
`6c6715a2fb4a945b953e1dc1fbc69f79731c31ab`.

Production workflow:
`33851145446` — SUCCESS.

Passed steps:
- authoritative manifest and production projection;
- Godot 4.7.2 import/parse;
- AppShell runtime smoke;
- Region-01 runtime smoke;
- Hunt-01 production integration headless;
- combat turn shell + tactical movement headless;
- first Hunter attack headless;
- Android debug APK export;
- APK/evidence artifact upload.

Verification boundary:
- current combat foundation = IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED;
- observation/combat phone acceptance = DEFERRED / NOT PHONE VERIFIED;
- sustained phone performance = NOT VERIFIED.

## Current production gameplay stack

1. continuous themed Hunt-01 world/exploration foundation;
2. physical tracking/evidence through `OBSERVATION_READY`;
3. observation and explicit same-location ENGAGE;
4. first-person deterministic combat turn shell;
5. authored adjacent tactical-node movement;
6. Hunter `POLEBLADE_MEASURED_CUT` through target contact/hit quality/local protection;
7. attack output hands off as `PENDING_ANATOMY_DAMAGE_RUNTIME`.

No separate generic combat arena is introduced. The encounter remains based on the existing Meadow world location and Monster identity.

## QA repair record

Commit `31999ced0a961f8d56c7159bdb387d986f3c8375`:
- repaired a stale static preflight that still asserted the entire combat package must contain no attacks;
- retained the valid rule that turn-shell and movement owners themselves contain no damage resolution.

Commit `6c6715a2fb4a945b953e1dc1fbc69f79731c31ab`:
- repaired a stale Hunter-attack test expectation at `R01_EF02_N09`;
- the runtime correctly reports `INSUFFICIENT_AP` after a three-step Round-1 approach because only 1 AP remains;
- the test now verifies that N09 passes the working-melee range gate before the AP gate and retains the exact AP rejection assertion;
- no combat gameplay behavior was changed.

## Deferred phone list

- observation/explicit ENGAGE transition;
- first-person same-location combat staging;
- tactical-node movement UX/readability;
- Measured Cut targeting/contact feedback;
- future anatomy-integrity feedback;
- final smoothed-route/dimensional acceptance where applicable;
- sustained performance/thermal evidence.

Stage-1 shooter-style controls remain previously user accepted 100%, but that evidence does not phone-verify later gameplay layers.

## Next bounded piece

`FIRST_SLICE_MUDCREST_ANATOMY_INTEGRITY_RUNTIME_IMPLEMENTATION`.

Required ownership/invariants:
- Monster-01/species production package owns anatomy state;
- generic combat retains action/contact resolution ownership;
- consume a committed `damage_handoff` exactly once;
- preserve stable encounter/Monster/anatomy target identity;
- no reroll on readback/replay;
- deterministic consequence trace;
- duplicate application rejected/idempotent;
- final damage arithmetic, break/sever thresholds and status tuning remain open;
- any first-slice numeric fixture must be marked provisional and reversible;
- break/sever/status/Monster reaction layers remain outside this piece unless current design authority closes those gates;
- production change requires static, Godot headless and Android-build verification before continuation.
