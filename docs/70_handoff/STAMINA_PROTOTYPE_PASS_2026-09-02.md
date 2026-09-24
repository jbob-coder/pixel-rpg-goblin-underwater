# Stamina Prototype Scale and Recovery Pass — 2026-09-02

Status: BOUNDED DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## EVOLVE compliance

This pass began by rereading the current repository copy of:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`;
- `docs/20_gameplay/combat/FIRST_WEAPON_FAMILY_CONTRACT.md`;
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`.

The Stage-1 implementation lane remains blocked on actual Godot parse/editor smoke verification, so this pass used the independent design lane explicitly allowed by EVOLVE.

The pass did not combine Initiative, statuses, terrain numbers, Monster 01 attacks, berserk, party design or defeat/retreat behavior.

## Completed authority

`docs/20_gameplay/combat/STAMINA_PROTOTYPE_SCALE_AND_RECOVERY_CONTRACT.md`

## Primary quality fix

Stamina now constrains sustained exertion without becoming either:
1. irrelevant because AP already exists; or
2. a low-resource death spiral driven by hidden blanket penalties.

Selected philosophy:

**Stamina pressure comes primarily from affordability, defensive reserve and recovery opportunity cost. LOW/CRITICAL reserve does not automatically reduce generic accuracy/evasion/damage.**

## Selected neutral prototype scale

`BASELINE_MAX_STAMINA = 100`

This is a first-slice neutral test profile, not a final universal hunter value.

Hard laws:
- current Stamina stays within `0..MaxStamina`;
- no normal negative-Stamina debt;
- no ordinary recovery above Max;
- actions/reactions with positive Stamina cost require enough resource to commit;
- insufficient Stamina rejects before AP/RP/Stamina spend;
- no ordinary Stamina→AP/RP/extra-turn conversion.

## Reserve bands

- `READY = 50–100`;
- `LOW = 25–49`;
- `CRITICAL = 1–24`;
- `EMPTY = 0`.

These are readability/authoring states.
They do not automatically add generic AttackControl/DefenseControl/damage penalties.

A later explicit `EXHAUSTED` status remains possible only if testing proves it useful.

## Passive recovery

Selected:
`+10 Stamina` once at the start of each normal hunter activation.

It cannot duplicate through:
- UI;
- ending turn;
- round end;
- reaction windows;
- save/load;
- camera transitions.

## Catch Breath

Selected first-slice recovery action:

`CATCH_BREATH`
- `1 AP`;
- `0 Stamina` cost;
- `+20 Stamina` delayed to turn-end when valid;
- once per activation;
- cannot be used after a damaging attack in that activation;
- committing a later damaging/sprint/high-exertion incompatible action cancels pending recovery;
- canceled recovery does not refund the AP.

### Root exploit prevented

The design specifically prevents:

```text
3 AP precision attack
→ 1 AP immediate Stamina refill
→ attack + refill every turn
→ Stamina ceases to matter
```

Delayed recovery means Catch Breath cannot finance the same activation's attack.

## Zero-Stamina soft-lock prevention

Selected safeguards:
- normal stable-ground adjacent reposition = `0 Stamina` baseline;
- Catch Breath costs no Stamina;
- passive recovery occurs next normal activation;
- no negative debt.

EMPTY remains dangerous because most offensive/defensive exertion is unavailable, but it is not intended to become a permanent lock.

## Generic first-slice exertion targets

- stable adjacent reposition `0`;
- Sprint `8`;
- deliberate Brace `6`;
- reactive Brace `10`;
- Dodge `14`;
- compatible generic weapon Parry `10`;
- Guard preparation `4`;
- Block/guard commitment `6 + incoming-force impact drain`.

Guard-impact numeric drains remain blocked on Monster 01 attack authoring.

## Field Poleblade Stamina binding

Concrete prototype costs now supersede older `exact Stamina open` placeholders for first-slice testing:

- `POLEBLADE_MEASURED_CUT = 12`;
- `POLEBLADE_DRIVING_THRUST = 10`;
- `POLEBLADE_PLACED_HEW = 18`;
- `POLEBLADE_COMMITTED_CLEAVE = 30`;
- `POLEBLADE_HAFT_CHECK = 8`;
- Guard preparation `4`;
- Block commitment `6 + impact drain`;
- Parry `10`.

The Stamina contract is the more specific authority for these values.
The older Action Economy and First Weapon contracts remain authoritative for their non-Stamina rules.

## Cost-reduction safety floor

For actions with positive base Stamina cost:

`ordinary final cost >= max(1, ceil(base × 0.50))`

unless an explicitly authored exceptional capability overrides that floor.

This prevents normal mastery/equipment stacking from eventually making heavy attacks, Dodge or Parry effectively free.

## Offense vs defense tradeoff

The system does not protect a hidden reserve for reactions.

Example:
- Stamina `34`;
- Committed Cleave costs `30`;
- Stamina after commitment `4`;
- normal Dodge costs `14`;
- Dodge is therefore unavailable until recovery.

This is intentional tactical risk and should be previewed clearly by the UI later.

## Endurance integration

Existing stats authority keeps Endurance responsible for Max Stamina/recovery/exhaustion resistance.

This pass intentionally does not select the final Endurance formula.

Later combat-domain tests should begin with a neutral derived profile of 100 Max Stamina and compare bounded lower/higher profiles.

## Mode-transition continuity

Stamina is authoritative actor state.

Therefore camera/mode transitions do not automatically refill it.
Entering or leaving first-person presentation, menu use, monster escape/reacquisition, and save/load may not silently reset Stamina.

Exploration-wide exertion remains a later design dependency.

## Required later tests recorded

The contract now requires tests for:
- one passive recovery per activation;
- clamps;
- insufficient-resource rejection;
- exact Field Poleblade base costs;
- reaction spend once;
- guard-impact spend once;
- Catch Breath delayed grant;
- once-per-activation rule;
- attack incompatibility;
- cancellation behavior;
- no negative Stamina;
- no above-max Stamina;
- no encounter-camera refill;
- cost-reduction floor;
- UI preview/domain cost agreement;
- deterministic Stamina traces.

## Current combat gates

`COMBAT_ACTION_ECONOMY = RECORDED`
`COMBAT_RESOLUTION_CONTRACT = RECORDED`
`FIRST_WEAPON_FAMILY_CONTRACT = RECORDED`
`FIRST_WEAPON_FAMILY = FIELD_POLEBLADE`
`STAMINA_PROTOTYPE_CONTRACT = RECORDED`
`BASELINE_MAX_STAMINA = 100`
`BASE_PASSIVE_RECOVERY = 10`
`CATCH_BREATH = RECORDED`
`COMBAT_IMPLEMENTATION = BLOCKED_BY_REMAINING_READINESS_GATES`

Stage-1 implementation truth remains unchanged:

`GODOT_PARSE_VERIFIED = NO`
`EDITOR_RUN_VERIFIED = NO`
`APK_BUILD_VERIFIED = NO`
`PHONE_RUNTIME_VERIFIED = NO`
`PERFORMANCE_VERIFIED = NO`

## Exact next actions

Implementation:
**Godot parse/editor smoke verification of the existing `probes/android_stage1/` source.**

Independent design:
**Initiative and Turn-Order Prototype Contract**.

Do not combine those two pieces into one EVOLVE pass.
