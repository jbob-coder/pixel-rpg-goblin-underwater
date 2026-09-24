# HUNT-01 Hunter Reaction Window Runtime — Verified Handoff

Date: 2026-09-04
Project: Unnamed Hunt RPG
Branch: `worldlife-reference-docs`
Production root: `game/`

## Completed bounded layer

`FIRST_SLICE_HUNTER_REACTION_WINDOW_RUNTIME_IMPLEMENTATION`

Verification status:
- IMPLEMENTED: YES
- STATIC VERIFIED: YES
- GODOT 4.7.2 PARSE/IMPORT: PASS
- HEADLESS VERIFIED: YES
- ANDROID BUILD VERIFIED: YES
- APK/EVIDENCE ARTIFACT UPLOAD: PASS
- PHONE VERIFIED: NO / DEFERRED_BATCH
- PERFORMANCE VERIFIED: NO

Verified source head:
`be389c393f993c0cbab60c0e15688f827951f8f8`

Production workflow:
`33884922855` — SUCCESS.

## Implemented ownership

Generic combat owner:
`game/scripts/gameplay/combat/hunt01_reaction_window_runtime.gd`.

The turn shell now supports one bounded external Monster activation driver and an out-of-turn reaction resource commitment path while preserving the Monster as current normal actor.

Stable reaction schema:
`uhr.hunt01.reaction_window.v1`.

First implemented paid reaction:
`POLEBLADE_BLOCK` = `1 RP + 6 Stamina`.

The runtime enforces:
- stable encounter/round/source/action/sequence window identity;
- at most one normal reaction decision per window;
- overlapping/recursive-window rejection;
- deterministic open/closed readback;
- idempotent resource commitment;
- explicit free decline;
- close only after a source-resolution status is provided.

The layer intentionally does not decide Block strength, Hunter health damage, forced movement or statuses.

## QA repair inside the same layer

Initial production run `33854902520` exposed one existing integration-test timing race. EV07 evidence collection could return before the observation Area3D state consumer had settled, so the test briefly read `SEARCHING` although the Hunter was physically inside the authored observation zone.

Repair commit:
`be389c393f993c0cbab60c0e15688f827951f8f8`.

The repair changes only `game/tests/region01_hunt01_graybox_runtime_test.gd`: after evidence collection is observed, the helper permits additional physics/process frames before derived encounter-state assertions. No gameplay coordinates, radii, controls or encounter rules changed.

## Green gates on final run

Production workflow `33884922855` passed:
- authoritative manifest / production projection;
- combat source preflight;
- reaction source preflight;
- Hunter attack source preflight;
- Mudcrest anatomy source preflight;
- Godot 4.7.2 import/parse;
- AppShell smoke;
- Region-01 smoke;
- Hunt-01 production integration headless;
- combat turn shell + tactical movement headless;
- Hunter reaction window headless;
- Mudcrest anatomy integrity headless;
- first Hunter attack + anatomy integration headless;
- Android debug APK export;
- APK/evidence artifact upload.

## Verification boundaries retained

`USER_PHONE_VALIDATION_POLICY = DEFERRED_BATCH`.

`H01VAL005_FINAL_SMOOTHED_ROUTE_LENGTH = NOT_EXECUTED`.

Stage-1 shooter-style controls remain protected and unchanged:
- left joystick direct continuous analog movement;
- right side independent camera/look;
- no forced release/center/rebase logic;
- first-person FOV approximately 115 degrees;
- exploration speed approximately 6.25 m/s.

## Next exact bounded piece

`FIRST_SLICE_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME_IMPLEMENTATION`.

Rationale:
- the selected Monster packet already defines `M01_HEAD_SWEEP_GORE` completely enough for first execution;
- it costs `2 AP / 14 Stamina`;
- normal Poleblade Block is a legal reaction for this attack, so it directly consumes the newly verified reaction runtime;
- it is the smallest real hostile attack that can be exercised at close range without inventing unresolved Dodge/Parry/Brace tuning;
- final Hunter health/damage arithmetic remains open, so this next slice must emit a stable committed hostile-contact / pending Hunter-damage handoff rather than fabricate final HP balance.

Required next-slice boundary:
1. species-owned Monster attack driver registers with the turn shell;
2. use real Monster activation ownership;
3. validate `M01_HEAD_SWEEP_GORE` capability/range/bearing/cover before commitment;
4. commit exactly `2 AP / 14 Stamina` once;
5. emit authoritative telegraph and open the shared reaction window;
6. consume Block or explicit decline without reroll/double spend;
7. resolve one deterministic hostile contact/hit-quality/protection trace using the generic combat contract;
8. emit a stable `PENDING_HUNTER_DAMAGE_RUNTIME` handoff;
9. complete the Monster activation without applying invented final Hunter HP damage;
10. add static/headless/Android verification; phone remains deferred.

Do not implement Horn Charge, Tail Sweep, Shoulder Ram, Stomp, Berserk, structural break/sever, defeat/escape or harvest inside this bounded piece.