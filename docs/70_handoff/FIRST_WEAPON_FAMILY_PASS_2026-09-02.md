# First Weapon Family Pass — 2026-09-02

Status: BOUNDED DESIGN PASS COMPLETE / NO COMBAT IMPLEMENTATION

## EVOLVE compliance

This pass began by rereading the current repository copy of:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `docs/20_gameplay/combat/README.md`;
- `docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`;
- `docs/20_gameplay/combat/COMBAT_RESOLUTION_HIT_QUALITY_DEFENSE_CONTRACT.md`;
- `docs/20_gameplay/progression/PLAYER_PROGRESSION_AND_EQUIPMENT_SYSTEM.md`;
- Monster 01 anatomy authority where needed.

Stage-1 implementation remains blocked on actual Godot parse/editor smoke verification, so this pass used the independent design lane explicitly allowed by EVOLVE.

## Completed authority

`docs/20_gameplay/combat/FIRST_WEAPON_FAMILY_CONTRACT.md`

## Primary quality fix

The first playable weapon family is now specific enough to exercise the combat architecture without being allowed to become universally optimal.

Selected technical family:
`WEAPON_FAMILY_FIELD_POLEBLADE`.

Working name:
**Field Poleblade**.

Identity:
- two-handed long-hafted hunting blade;
- primary cutting/sever role;
- secondary piercing/control role;
- limited impact capability;
- useful medium-melee reach;
- directional Guard;
- restricted Parry;
- deliberate weaknesses in hard-structure break, cramped fighting, shield-like defense and repeated high-exertion use.

## First technique packet

### Measured Cut
- 2 AP;
- controlled cutting;
- selected target allowed;
- body fallback allowed;
- maximum intended hit quality: CLEAN.

### Driving Thrust
- 2 AP;
- piercing/reach;
- selected target allowed;
- body fallback allowed;
- maximum intended hit quality: CLEAN.

### Placed Hew
- 3 AP;
- selected-part precision cut;
- selected part required;
- no automatic full-body fallback;
- PRECISION allowed;
- intended first-slice tail-sever control technique.

### Committed Cleave
- 4 AP;
- high-force full-turn cutting commitment;
- body fallback allowed;
- maximum intended hit quality: CLEAN;
- strong sever/structural contribution without becoming a dedicated impact weapon.

### Haft Check
- short-range emergency spacing/control;
- low-impact identity;
- explicitly not a substitute for a dedicated hammer/impact family.

### Guard / Parry
- directional;
- Stamina-dependent later;
- no shield-level omnidirectional protection;
- Parry is restricted to physically compatible attacks;
- no automatic free counter-turn.

## Monster 01 compatibility

The Field Poleblade gives the first slice a plausible interaction with all eight target groups without being equally good against each.

Especially important:
- tail distal sever is supported and should be achievable but not automatic;
- fore/hind legs are meaningful reach targets;
- intact dorsal plates remain poor cutting targets;
- horn crest can be damaged but dedicated future impact weapons should be more efficient at structural break;
- no arbitrary limb severing is introduced;
- local armor/anatomy still controls the result.

## Progression compatibility

The family follows the selected progression model:
- mastery improves handling/technique familiarity rather than multiplying damage each rank;
- refinement cannot erase core weaknesses;
- AP cap does not increase through normal weapon upgrading;
- future variants may trade handling, force, guard stability or sever efficiency, but should not dominate every axis simultaneously.

No actual variants were created in this pass.

## Data/QA requirements recorded

Future weapon and technique definitions must expose stable IDs, AP/Stamina costs, reach states, target/fallback policy, damage channels, hit-quality ceiling, break/sever behavior, defense compatibility and terrain restrictions.

Future tests must cover:
- 2/3/4 AP costs;
- hit-quality ceilings;
- body-fallback policy;
- too-close/out-of-range legality;
- incompatible Parry rejection;
- tail-sever legality;
- local plate/horn behavior;
- deterministic replay;
- no extra turns/AP;
- no universal-best weapon regression.

## Still open

- exact Stamina numbers;
- exact damage values;
- exact reach distances;
- exact weapon dimensions/mass;
- exact AttackControl coefficients;
- exact break/sever numerical efficiency;
- exact animation timing;
- final material/construction variant;
- final setting-facing name.

These remain open intentionally and should be answered by the first implementation stage that actually needs them.

## Current gates

`COMBAT_ACTION_ECONOMY = RECORDED`
`COMBAT_RESOLUTION_CONTRACT = RECORDED`
`FIRST_WEAPON_FAMILY_CONTRACT = RECORDED`
`FIRST_WEAPON_FAMILY = FIELD_POLEBLADE`
`COMBAT_DESIGN_READINESS = PARTIAL / THREE CORE CONTRACTS RECORDED`
`COMBAT_IMPLEMENTATION = BLOCKED_BY_READINESS_GATES`

Stage-1 implementation truth is unchanged:

`GODOT_PARSE_VERIFIED = NO`
`EDITOR_RUN_VERIFIED = NO`
`APK_BUILD_VERIFIED = NO`
`PHONE_RUNTIME_VERIFIED = NO`
`PERFORMANCE_VERIFIED = NO`

## Exact next actions

Implementation:
**Godot parse/editor smoke verification of the existing `probes/android_stage1/` source.**

Independent design:
**Stamina Prototype Scale and Recovery Contract**.

Do not combine those two pieces into one pass.
