# Combat Resolution / Hit Quality / Defense Pass — 2026-09-02

Status: BOUNDED DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## EVOLVE compliance

This pass began by rereading:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`;
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`;
- `docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md`;
- `docs/20_gameplay/combat/README.md`.

The Stage-1 implementation lane remains blocked on Godot parse/editor smoke verification, so this pass used the independent design lane explicitly allowed by EVOLVE.

## Completed authority

`docs/20_gameplay/combat/COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`

## Primary quality fix

A committed attack no longer has permission to become a pile of unrelated hidden rolls.

Selected architecture:

```text
COMMITTED ACTION
→ freeze authoritative context
→ hard legality
→ target/exposure
→ reaction consequence
→ directional cover
→ attack vs defense control
→ one bounded seeded variance source
→ body/selected-part contact
→ hit quality
→ cover/guard/local armor/anatomy protection
→ damage/break/sever/status handoff
→ domain events + trace
```

## Selected resolution laws

- hard physical/capability illegality is not represented as fake low accuracy;
- attack control is separate from raw damage power;
- defense control is separate from armor/protection;
- large-monster body contact is distinct from selected-part contact;
- techniques explicitly declare whether failed part acquisition can fall back to general body contact;
- target parts use `EXPOSED / PARTIALLY_EXPOSED / OBSCURED / NOT_TARGETABLE` states;
- cover is directional physical context, not one universal defense percentage;
- full blocking cover can make a direct attack illegal;
- partial cover affects the actual blocked path/parts;
- Dodge primarily avoids/degrades contact through displacement;
- Block primarily interposes guard/protection rather than pretending the attack missed;
- Parry is restricted/high-control deflection and cannot apply to every attack;
- Brace primarily improves stability/consequence resistance rather than generic evasion;
- no free recursive counter-turn from Parry;
- one reproducible bounded seeded variance source is used per committed attack resolution;
- legality/anatomy/cover state remains deterministic;
- no separate hidden random critical-hit roll;
- identical authoritative state + seed/action sequence must reproduce the same resolution;
- presentation/UI cannot reroll or change resolution.

## Hit-quality model

Recorded generic classes:
1. `MISS / NO_CONTACT`;
2. `GRAZE`;
3. `SOLID`;
4. `CLEAN`;
5. `PRECISION`.

Hit quality is contextual contact quality, not a generic rarity/critical system.

`PRECISION` requires actual selected-part acquisition and a technique that allows that quality ceiling.

## Protection ordering

Selected generic order:

```text
COVER INTERCEPT
→ ACTIVE GUARD/BLOCK STRUCTURE
→ EXTERNAL EQUIPMENT / NATURAL ARMOR AT CONTACT LOCATION
→ TARGET BODY-PART PROTECTION / STRUCTURE
→ TISSUE / STRUCTURAL INTEGRITY
→ WOUND / BREAK / SEVER / STATUS
→ CAPABILITY CHANGE
→ HARVEST-CONDITION CHANGE
```

Global armor subtraction before contact location is known is not preferred.

## Monster 01 compatibility

The contract preserves Monster 01's recorded physical design:
- eight first-slice target groups remain authoritative;
- broken dorsal plates affect the relevant region rather than global defense;
- tail sever requires the legal distal boundary and suitable damage/sever rules;
- already broken/severed parts cannot duplicate rewards;
- the internal crystal remains deep/non-default-targetable in the first slice;
- hit quality alone cannot bypass physical break/sever requirements.

## Seed/randomness boundary

Selected:
`BOUNDED_SEEDED_VARIANCE`.

Rejected:
- unseeded hit rolls;
- reroll-on-animation/UI;
- separate random critical-hit roll;
- hidden random cover/anatomy truth.

Exact variance amplitude and score thresholds remain balance-open.

## Development trace requirement

Future domain resolution must be able to explain:
- attacker/defender/action;
- selected and actual target part;
- range/bearing/elevation;
- exposure;
- cover;
- attack-control contributors;
- defense-control contributors;
- modifier sources;
- reaction result;
- seeded variance label/value;
- contact class;
- hit quality;
- guard/armor/anatomy profile used;
- damage/break/sever/status handoff;
- final capability changes.

## Still open before real combat implementation

- First Weapon Family Contract;
- Stamina prototype scale/recovery;
- Initiative/tie rule;
- first-slice status set;
- concrete first terrain-effect set;
- Monster 01 attack packet;
- first berserk prototype;
- solo/party baseline;
- defeat/retreat baseline;
- prerequisite implementation stages/tests.

## Current gates

`COMBAT_ACTION_ECONOMY = RECORDED`
`COMBAT_RESOLUTION_CONTRACT = RECORDED`
`HIT_QUALITY_MODEL = RECORDED`
`RANDOM_CRITICAL_ROLL = REJECTED`
`SEEDED_VARIANCE_BOUNDARY = RECORDED`
`COMBAT_IMPLEMENTATION = BLOCKED_BY_READINESS_GATES`

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
**First Weapon Family Contract**, one family only.

Do not combine those two pieces into one pass.
