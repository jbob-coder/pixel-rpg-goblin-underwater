# First-Slice Status Set Prototype Pass — 2026-09-03

Status: BOUNDED DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT`

This pass advanced the active non-phone game-design lane while the Stage-1 Galaxy A03s implementation gate remains deferred for direct device evidence.

The game remains the primary objective. Documentation changes in this pass exist to make the game rules discoverable, owned, testable and reconstructable from the repository.

## Authorities reread

Before selecting the status set this pass reread the current repository copies of:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- `docs/70_handoff/INITIATIVE_AND_TURN_ORDER_PASS_2026-09-03.md`;
- `docs/20_gameplay/combat/README.md`;
- `docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`;
- `docs/20_gameplay/combat/COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `docs/20_gameplay/combat/FIRST_WEAPON_FAMILY_CONTRACT.md`;
- `docs/20_gameplay/combat/STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`;
- `docs/20_gameplay/combat/INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`.

The pass intentionally did not combine terrain values, Monster 01 attack authoring, berserk, party design or defeat/retreat behavior.

## New authority

`docs/20_gameplay/combat/FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`.

## Selected first-slice set

Exactly five states are selected:
1. `status_bleeding`;
2. `status_staggered`;
3. `status_off_balance`;
4. `tactical_braced`;
5. `tactical_guarded`.

The set is deliberately small and tied directly to existing combat mechanics.

## Why these five

### Bleeding
Proves a persistent physical condition, bounded stacking, anatomy/source traceability and deterministic periodic effects.

### Staggered
Proves short disruption and defense-legality changes without introducing a full stun/turn-skip mechanic.

### Off-Balance
Proves a temporary stability condition and deliberate recovery through the existing Brace action.

### Braced
Already exists conceptually in Action Economy, Combat Resolution and Stamina. This pass records its actual tactical-state lifetime/stack/removal boundary.

### Guarded
Already exists conceptually in Field Poleblade/Block design. This pass records its directional authoritative state and prevents camera/UI orientation from becoming combat authority.

## Explicitly deferred

Not selected now:
- Exhausted — Stamina affordability/recovery pressure must be tested first;
- generic Wounded — anatomy/injury already owns physical damage state;
- Focused/Aimed — defer until a concrete first-slice consumer requires persistent preparation state;
- Concealed — terrain/behavior/visibility packet;
- environmental/toxin/psychological catalogs — later content/system packets.

## Deterministic application

No independent random status-proc roll is selected.

Flow:
`AUTHORITATIVE RESOLUTION → VALID STATUS APPLICATION EVENT → STATUS OWNER VALIDATES/STACKS → TRACE`.

UI/VFX/animation cannot apply, repeat or remove gameplay state independently.

## Timing model

Selected first-slice hooks include:
- `ON_APPLY`;
- `TURN_START_PRE_RECOVERY`;
- `BEFORE_ACTION_VALIDATION`;
- `BEFORE_ACTION_RESOLUTION`;
- `ON_HIT_OR_DAMAGE_CONSEQUENCE`;
- `AFTER_ACTION`;
- `TURN_END`;
- `ROUND_END`;
- `ENCOUNTER_END`;
- `ON_REMOVE`.

`ROUND_END` is explicitly added to the first-slice contract so Bleeding has a cadence independent of whether a combatant's own activation was skipped.

## Bleeding law

Selected:
- one authoritative actor-level Bleeding instance;
- `STACK_INTENSITY_CAPPED`;
- max intensity `3`;
- multiple body-part wounds may be retained as source metadata without multiplying independent round ticks;
- first eligible tick is `application_round + 1`;
- at most one periodic Bleeding event per affected actor per round;
- exact HP magnitude remains blocked on health/damage scale;
- no arbitrary turn-duration auto-expiry;
- encounter end does not silently equal treatment/healing.

This avoids duplicated periodic damage from presentation or multi-part bookkeeping.

## Staggered law

Selected:
- `REFRESH_DURATION`, no intensity stacking;
- Dodge and Parry are illegal while active;
- compatible Block/reactive Brace may remain legal through existing owners;
- no automatic next-turn skip;
- at next `TURN_START_PRE_RECOVERY`, Staggered removes once and transitions once to Off-Balance;
- the normal activation then continues and only afterward do the existing Stamina/AP/RP start hooks run.

This prevents stun-lock architecture and extra scheduling behavior.

## Off-Balance law

Selected:
- `REFRESH_DURATION`;
- Parry illegal while active;
- explicit shared-pipeline stability/control modifiers may be added later with tested numeric values;
- successful deliberate Brace clears Off-Balance and then applies Braced;
- otherwise Off-Balance clears after one completed normal activation at `TURN_END`;
- skipped/ineligible slot does not grant a free recovery turn.

## Braced law

Selected:
- one state only (`REPLACE`);
- deliberate Brace costs remain `1 AP + 6 Stamina` through existing owners;
- reactive Brace remains `1 RP + 10 Stamina` through existing owners;
- improves stability/stagger/displacement context, not Evasion/contact by default;
- deliberate Brace normally lasts through the between-turn defensive interval and expires at next activation start;
- movement, forced displacement, incompatible damaging attack or successful Staggered consequence can clear it earlier;
- reactive Brace lasts only through the current hostile-action resolution.

## Guarded law

Selected:
- one directional state only (`REPLACE`);
- stores weapon/source + authoritative guard bearing/coverage;
- current first-slice consumer is Field Poleblade;
- Guarded enables compatible Block attempts but never auto-Blocks;
- camera rotation alone cannot alter committed guard direction;
- no free RP;
- movement/displacement, incompatible attack, `BLOCK_BROKEN`, successful Staggered, capability loss or terminal removal can clear it;
- normally expires at next normal activation start;
- Guarded and Braced may coexist because one represents interposition and the other stability.

## Initiative / turn-order compatibility

None of the five selected states changes Initiative order or grants extra activations.

Selected:
- Bleeding does not skip turns;
- Staggered does not skip next normal activation;
- Off-Balance does not skip turns;
- Braced/Guarded do not alter Initiative;
- no `Stunned`/full-turn-skip state is selected.

Therefore `NORMAL_ACTIVATIONS_PER_ELIGIBLE_ACTOR_PER_ROUND = 1` remains intact.

## Save/reload requirements

The contract requires persistence of state identity, source, application sequence, intensity/timing, guard orientation and scope as applicable.

Reload may not:
- rerun ON_APPLY;
- duplicate Bleeding ticks;
- convert Staggered to Off-Balance twice;
- restore expired Braced/Guarded states;
- change Initiative order;
- trigger extra Stamina/AP/RP refresh.

## Future implementation-test packet

The new authority records 36 test requirements covering:
- generic status-engine determinism;
- Bleeding stack/tick rules;
- Staggered restrictions/transition;
- Off-Balance recovery;
- Braced deliberate/reactive scope;
- Guarded direction/Block boundaries;
- save/reload;
- presentation non-authority;
- no extra turns / no Initiative mutation.

No runtime tests were executed because combat runtime source does not exist and remains behind readiness gates.

## Cross-authority review

Reviewed against:
- Action Economy AP/RP/turn ownership;
- Stamina cost/recovery ownership;
- Combat Resolution Dodge/Block/Parry/Brace roles;
- Field Poleblade directional Guard;
- Initiative one-activation/no-reorder laws;
- root status stacking/event architecture.

No intentional conflict was introduced.

## Documentation/navigation reconciliation

This pass maps/updates:
- `docs/20_gameplay/combat/FIRST_SLICE_STATUS_SET_PROTOTYPE_CONTRACT.md`;
- `docs/20_gameplay/combat/README.md`;
- `docs/20_gameplay/README.md`;
- `docs/00_project/BUILD_READINESS_GATE_MATRIX.md`;
- `README.md`;
- `DOCUMENTATION_INDEX.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `EVOLVE_ALIGNMENT.md`;
- this specialized handoff.

The repository therefore continues to answer:
`WHAT EXISTS → WHERE IT IS → WHAT OWNS IT → WHAT IS VERIFIED → WHAT REMAINS UNVERIFIED → WHAT HAPPENS NEXT`.

## Write anomaly and repair audit

During publication, an incorrect connector write call created intermediate commit `0cf33ad28a24465272adc5d57f2a83379b33b16d` with root `README.md` temporarily empty.

The error was detected before the pass was closed.

Repair:
- no force push was used;
- commit `58985bfdbb31b6d6ccd2ccca03e03297f29c6ffb` fast-forwarded from that intermediate commit;
- the repair restored the intended root README and applied the complete intended ten-file status/design/navigation tree;
- final comparison from Initiative baseline `e457f1134063bdd17ac134a7ae228da200bd6378` to repaired status head showed only the intended ten final file differences;
- no Android workflow was triggered because the final changes were design/documentation only and no probe/build source changed.

The intermediate bad state is therefore present only in commit history; it is not the current branch tree.

## Verification boundary

`STATUS_SET_DESIGN_RECORDED = YES`.
`STATUS_SET_RUNTIME_IMPLEMENTED = NO`.
`STATUS_SET_RUNTIME_VERIFIED = NO`.

Stage-1 phone truth remains unchanged:
`PERFORMANCE_VERIFIED = NO`.
`ENGINE_PHONE_PROBE_VERIFIED = NO`.
`FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

Implementation action when phone evidence is available:
`DEFERRED_GALAXY_A03S_PERFORMANCE_AND_REGRESSION_EXECUTION_WHEN_DEVICE_AVAILABLE`.

## Exact next active non-phone action

`FIRST_SLICE_TERRAIN_EFFECT_SET_CONTRACT`

That next pass must define only the concrete first-slice terrain surfaces/effects needed by the first combat test, using existing terrain tags/modifier architecture.

Do not combine it with Monster 01 attacks, berserk, party design, defeat/retreat behavior or production implementation.