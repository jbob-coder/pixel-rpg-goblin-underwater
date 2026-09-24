# Hunt-01 Hunter Reaction Window Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED / PHONE DEFERRED
Last reconciled: 2026-09-04

## Bounded purpose

Shared combat prerequisite required before real Mudcrest attacks can replace the Monster scheduler placeholder.

Production owner:
`game/scripts/gameplay/combat/hunt01_reaction_window_runtime.gd`.

Stable schema:
`uhr.hunt01.reaction_window.v1`.

## Verified contract

The runtime:
- opens only from the current hostile Monster normal activation;
- keys a window by encounter + round + source actor + source action + action sequence;
- permits at most one normal reaction decision in that window;
- rejects overlapping/recursive windows;
- supports deterministic open/closed readback;
- prevents repeated UI/readback from spending reaction resources twice;
- exposes an explicit free decline path;
- closes only after a hostile-source resolution status is supplied.

## Shell handshake

`hunt01_combat_turn_shell_runtime.gd` remains authoritative for resources and normal actor ownership.

The shell supports:
- one optional Monster activation driver registration;
- bounded external Monster activation hold/complete handshake;
- `try_commit_reaction_cost(...)` for out-of-turn RP/Stamina commitment while the hostile source actor remains current;
- per-window resource-commit idempotence.

The Hunter is never promoted to current normal actor merely because a reaction window exists.

Without a registered Monster driver, `WAIT_NO_ATTACK_RUNTIME` remains the explicit fallback.

## First supported paid reaction

`POLEBLADE_BLOCK`.

Cost:
- `1 RP`;
- `6 Stamina`.

Authority:
- baseline one-normal-reaction / 1 RP: `ACTION_ECONOMY_CONTRACT.md`;
- Field Poleblade Block commitment 6 Stamina: Monster-01 `COMBAT_ATTACK_PACKET.md`.

Attack-specific guard-impact drain remains separate from the 6-Stamina Block commitment.

## Resolution boundary

A committed Block returns:
`PENDING_ATTACK_DEFENSE_RESOLUTION`.

This layer does not resolve:
- Block strong/partial/broken outcome;
- Hunter health damage;
- forced movement;
- status consequences;
- Monster attack damage.

Those belong to the hostile-action resolver and subsequent Hunter-damage owner.

## Player-facing UI

`ReactionWindowPanel` appears only while a real hostile action offers a reaction.

Implemented choices:
- `BLOCK • 1 RP + 6 Stamina`;
- `DECLINE REACTION`.

Block disables when required resources are unavailable; decline remains free.

## Final automated evidence

Verified source head:
`be389c393f993c0cbab60c0e15688f827951f8f8`.

Production workflow:
`33884922855` — SUCCESS.

Passed:
- reaction source/static gate;
- Godot 4.7.2 import/parse;
- AppShell and Region-01 smoke;
- existing Hunt-01 production integration;
- combat turn shell + tactical movement;
- dedicated Hunter reaction window headless test;
- Mudcrest anatomy regression;
- first Hunter attack/anatomy regression;
- Android debug export;
- APK/evidence artifact upload.

## QA repair

Initial reaction run `33854902520` exposed a timing race in the existing production integration helper. EV07 evidence collection could become visible before the observation Area3D callback/state consumer settled. The final repair in `be389c393f993c0cbab60c0e15688f827951f8f8` allows additional physics/process frames after evidence collection before derived encounter-state assertions.

No production gameplay source, coordinates, zone radii or control behavior changed in that repair.

## Verification boundary

Phone/user acceptance remains `DEFERRED_BATCH`.
Performance remains unverified.

## Next consumer

`FIRST_SLICE_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME_IMPLEMENTATION`.

The first real hostile attack must consume this verified window using `M01_HEAD_SWEEP_GORE`, exact `2 AP / 14 Stamina` Monster commitment, authoritative telegraph, Block/decline decision, deterministic hostile contact/protection resolution and a stable `PENDING_HUNTER_DAMAGE_RUNTIME` handoff. Final Hunter HP arithmetic remains outside that next bounded attack slice.