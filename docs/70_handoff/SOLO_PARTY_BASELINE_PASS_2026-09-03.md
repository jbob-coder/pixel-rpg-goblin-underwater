# Solo / Party Baseline Pass — 2026-09-03

Status: BOUNDED GAMEPLAY-DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## Bounded piece

`SOLO_PARTY_BASELINE_CONTRACT`

This pass advances the game-design lane while the direct Galaxy A03s Stage-1 phone gate remains deferred. The game is the objective; documentation records ownership, design truth, verification boundaries and exact continuation.

## Authorities reread

Before recording this baseline, current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `docs/70_handoff/MONSTER_01_BERSERK_PROTOTYPE_PASS_2026-09-03.md`;
- `GAME_EXPERIENCE_BIBLE.md`;
- `NEW_GAME_MASTER_PLAN.md`;
- `BEHAVIOR_PATTERN_SYSTEM.md`;
- `docs/20_gameplay/combat/INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- current combat/action/Stamina/status/terrain owners;
- current combat/gameplay/readiness front doors.

The pass did not define defeat, death, revive, retreat resolution, reward sharing, companion relationships, multiplayer or production code.

## New authority

`docs/20_gameplay/combat/SOLO_PARTY_BASELINE_CONTRACT.md`.

This is a reusable gameplay/combat participation contract, not one content package.

It supersedes the older unresolved `solo/party` placeholder in `NEW_GAME_MASTER_PLAN.md` and the older unresolved party/companion-behavior placeholder in `BEHAVIOR_PATTERN_SYSTEM.md` within this scope.

## Selected first-slice participation model

`FIRST_SLICE_PARTY_MODE = SOLO_CAPABLE_WITH_OPTIONAL_COMPANIONS`.

The hunt loop must work with the player hunter alone. Companions are optional; no first-slice hunt is party-required.

Prototype active party cap:
`MAX_ACTIVE_HUNTERS_IN_PARTY = 3`.

Composition:
- one player hunter;
- zero, one or two companion hunters.

The cap is a first-slice implementation/readability target, not a permanent world maximum.

## Direct control

Selected:
`PLAYER_DIRECT_CONTROL = PLAYER_HUNTER_ONLY`.

No mid-combat body switching is selected.

The player directly chooses their own hunter actions. Companions own their own normal activations and act through deterministic authored behavior.

## Independent resources and scheduler ownership

Each hunter owns independent Health/body state/AP/RP/Stamina/status/position/equipment/InitiativeSnapshot/RoundRoster slot.

No shared party AP/RP/Stamina pool exists.

All combat actors use the same Initiative scheduler. Party affiliation does not group allied turns together.

Hard invariant remains:
`ONE_NORMAL_ACTIVATION_MAX_PER_ELIGIBLE_ACTOR_PER_ROUND`.

## Companion command model

Safe pre-encounter directive selection costs no combat AP.

Mid-combat player action:
`ISSUE_COMPANION_ORDER`.

Prototype:
- costs player hunter `1 AP`;
- max one successful order action per player normal activation;
- targets one companion;
- does not spend companion AP;
- does not change Initiative order.

Minimal persistent order set:
- `ORDER_STANDARD`;
- `ORDER_FOCUS_PART`;
- `ORDER_HOLD_POSITION`;
- `ORDER_CLOSE_DISTANCE`.

Orders are priorities/constraints, not permission to bypass attack, target-part, terrain, cover, AP/Stamina or knowledge legality.

## Companion behavior / no AI

Companions consume `BEHAVIOR_PATTERN_SYSTEM.md`:
- authored explicit rules;
- deterministic priorities/ties;
- normal domain action requests;
- inspectable traces;
- no runtime generative AI decision-making.

Companion reactions are chosen deterministically by the companion's defensive policy rather than interrupting the player with a manual reaction prompt for every ally attack.

They still spend their own RP/Stamina and obey one-reaction-per-window rules.

## Encounter continuity

Party members are persistent world actors, not combat summons.

An absent/out-of-context party member does not teleport beside the player when combat begins.

If a world/script rule accepts a companion after the current round roster is finalized, Initiative's late-entry rule applies: no current-round normal activation; first eligible next round.

Normal first-slice party recruitment/swapping does not happen mid-combat.

## Removal/incapacitation boundary

This pass records only scheduler behavior:
- terminal removal → `REMOVED`;
- temporary ineligibility at slot → `SKIPPED_INELIGIBLE`;
- no same-round reinsert;
- no replacement slot;
- no control transfer to companion if player hunter is incapacitated.

What defeat/retreat/revive/hunt failure actually means is deliberately deferred to the next packet.

## Camera/presentation

Player first-person camera remains owned by the player hunter during companion activations.

Presentation may show companion actions but never chooses them, moves the player tactically, or advances the scheduler.

## Future implementation verification

The contract records 36 minimum checks covering:
- solo/2-hunter/3-hunter roster construction;
- party-cap rejection;
- one activation per actor;
- independent resources;
- no body switching;
- deterministic companion decisions;
- command cost/rate/validation;
- order legality;
- companion reaction ownership;
- absent/late companion behavior;
- removal/skip scheduling;
- save/reload anti-duplication;
- presentation non-authority;
- solo completion path.

No runtime verification is claimed because production party/combat source does not yet exist.

## Documentation/navigation reconciliation

This pass maps/updates:
- `docs/20_gameplay/combat/SOLO_PARTY_BASELINE_CONTRACT.md`;
- `docs/20_gameplay/combat/README.md`;
- `docs/20_gameplay/README.md`;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`;
- root `README.md`;
- `DOCUMENTATION_INDEX.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `EVOLVE_ALIGNMENT.md`;
- this handoff.

Older master-plan/behavior open placeholders are explicitly superseded by the new specific contract; they do not override it.

## Verification boundary

`SOLO_PARTY_BASELINE_RECORDED = YES`
`PARTY_RUNTIME_IMPLEMENTED = NO`
`PARTY_RUNTIME_VERIFIED = NO`

Stage-1 phone truth remains unchanged:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next active non-phone action

`DEFEAT_RETREAT_BASELINE_CONTRACT`

That next pass must define only first-slice player/party defeat, monster defeat, voluntary retreat/escape, encounter termination, hunt continuation/failure and scheduler/persistence boundaries.

Do not combine it with production implementation, reward/economy expansion or broad companion relationship systems.
