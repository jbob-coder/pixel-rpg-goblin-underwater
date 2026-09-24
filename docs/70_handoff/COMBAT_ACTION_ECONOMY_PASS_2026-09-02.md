# Combat Action-Economy Pass — 2026-09-02

Status: BOUNDED DESIGN PASS COMPLETE / NO IMPLEMENTATION

## Completed authority

`docs/20_gameplay/combat/ACTION_ECONOMY_CONTRACT.md`

## Selected architecture

Resource separation:
- `AP` = current-turn tactical opportunity;
- `RP` = bounded out-of-turn response;
- `STAMINA` = persistent exertion across turns.

First-slice prototype targets:
- Hunter `MAX_AP = 4`;
- Hunter normal `MAX_RP = 1`;
- standard adjacent move commonly `1 AP`;
- standard attack commonly `2 AP`;
- precision attack commonly `3 AP`;
- heavy/full-turn action commonly `4 AP`;
- aim/brace/analyze/recovery commonly `1 AP`;
- larger reposition commonly `2 AP` plus stamina.

## Selected timing laws

- AP refreshes on the actor's normal turn and does not bank.
- RP refreshes to allowed cap on the actor's normal turn.
- Stamina persists across turns.
- One normal eligible actor activation per round unless an explicitly approved exceptional mechanic exists.
- Ordinary progression/attributes do not create extra normal turns.
- Reactions require explicit reaction windows.
- Baseline normal defender chooses at most one normal reaction in a reaction window.
- Reactions/counters do not recursively create unlimited response chains.
- UI/animation cannot advance turns or mutate AP/RP/Stamina.

## Selected tactical laws

- Movement changes authoritative node/range/bearing/cover/terrain context before the next action validates.
- Entering nearby cover normally uses movement cost rather than an automatic second hidden cover charge.
- Body-part selection inside an already-known legal attack does not automatically cost extra AP.
- Aim/Analyze/positioning are separate setup actions and may cost AP.
- Normal dodge is primarily an RP-based reaction with stamina/space/terrain requirements.
- Heavy actions deliberately consume the whole 4 AP opportunity budget in the prototype.
- Repeatable 1 AP damaging attacks are not part of the default first-slice economy.

## Anti-loop invariants

At minimum:
- no AP banking;
- no ordinary extra-turn progression;
- no stamina→unlimited AP conversion;
- no 0 AP tactical-state value loops;
- no recursive reaction loops;
- no UI-owned refunds;
- no duplicate status/turn hooks;
- no save/reload resource duplication;
- no monster action that requires a capability disabled by anatomy damage.

## Open

- exact stamina scale/recovery;
- exact initiative formula;
- weapon-specific costs;
- exact dodge/block/parry formulas;
- guard upkeep;
- ammo/reload structure;
- exact item/tool costs;
- party activation if party design is later approved.

## Next bounded task

`Combat Resolution / Hit Quality and Defense Contract`.

Do not implement combat yet.

Next packet should define:
- accuracy/evasion;
- cover interaction;
- dodge/block/parry/brace resolution;
- hit-quality tiers;
- body-part targeting difficulty/exposure;
- deterministic vs seeded-random boundaries;
- armor/anatomy protection ordering;
- miss/failure consequences;
- debug/calculation trace requirements.

## Current gates

`COMBAT_ACTION_ECONOMY = RECORDED`
`FIRST_SLICE_AP_TARGET = 4`
`FIRST_SLICE_RP_TARGET = 1`
`AP_BANKING = NO`
`REACTION_RECURSION = BLOCKED`
`COMBAT_IMPLEMENTATION = NOT AUTHORIZED`
`COMBAT_RUNTIME_VERIFICATION = NOT EXECUTED`
