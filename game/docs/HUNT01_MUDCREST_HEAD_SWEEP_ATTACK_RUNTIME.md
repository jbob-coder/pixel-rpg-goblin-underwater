# Hunt-01 Mudcrest Head Sweep Attack Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED
Last reconciled: 2026-09-04

## Bounded purpose

First real Mudcrest Raker hostile attack without fabricating final Hunter HP arithmetic or broad Monster AI.

Species owner: `game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd`.
Schema: `uhr.hunt01.mudcrest_attack.v1`.
Attack: `M01_HEAD_SWEEP_GORE`.
Commitment: `2 AP / 14 Stamina`.

## Runtime sequence

1. species runtime registers one Monster activation driver through the combat shell;
2. validates baseline head capability, working-melee relation, front/front-flank bearing, sweep line/cover and Monster resources;
3. commits 2 AP / 14 Stamina once;
4. emits authoritative text + non-colliding `mudcrest_head_sweep_telegraph.tscn` threat band;
5. opens the generic Hunter reaction window;
6. executable paid reaction is Field Poleblade Block at 1 RP / 6 Stamina; explicit decline is free;
7. one deterministic FNV-1a bounded sample resolves provisional AttackControl/DefenseControl into MISS/GRAZE/SOLID/CLEAN;
8. contact routes through `FIELD_POLEBLADE_DIRECTIONAL_GUARD` or `HUNTER_BODY_PROTECTION_PENDING_RUNTIME`;
9. emits stable `PENDING_HUNTER_DAMAGE_RUNTIME` handoff;
10. closes reaction window, removes telegraph and completes Monster activation.

## Provisional boundaries

Working-melee body-envelope maximum is 3.5 m for this first executable slice. Front/front-flank uses the authored Mudcrest charge-forward half-plane. Structural break state does not yet exist, so the runtime does not infer broken horns from normalized integrity.

`PROVISIONAL_FIRST_SLICE_MUDCREST_HEAD_SWEEP_CONTROL_FIXTURE` supplies executable deterministic contact values only; it does not select final balance.

Head Sweep records the selected standard Poleblade Block impact drain of 10 Stamina, separate from the 6-Stamina Block commitment, but this attack owner does not apply the drain or invent the final Block outcome.

`guard_impact_drain_status = PENDING_FINAL_BLOCK_OUTCOME_RUNTIME`.

## Automated verification

Primary implementation commit:
`238f6bba98cb6dd7deb420bfe5196e08a3542279`.

QA chain:
- `6cc493f3a9ce00b84279ac00e1985fc08276c4e0` — reaction documentation-gate repair;
- `0d843079bf6343cbb0b35d12264ce695ae5b5c5c` — anatomy documentation-gate repair;
- `bd732960051c9850dbec7beeaf856e73b478f9ad` — dedicated Head Sweep test physics synchronization;
- `f7fe9d347921289ca104824e61fd82a2efc73fed` — reaction regression test isolates its mock from the production deferred hostile driver.

Final production workflow `33932945947`: SUCCESS.
Job `101215138444`: SUCCESS.

The final run passed static/source gates, Godot 4.7.2 parse/import, AppShell/Region smoke, production integration, combat/tactical movement, reaction regression, dedicated Head Sweep, anatomy, Hunter attack, Android debug export and artifact upload.

Artifact `9959201882`:
- name `UnnamedHuntRPG-Hunt01-MudcrestHeadSweep-debug`;
- size 57,322,699 bytes;
- SHA-256 `b56070a42a9abd5ef534443750c441385b1f5f8327a48f7ea1080e490abe0ca8`;
- APK output `UnnamedHuntRPG-Hunt01-MudcrestHeadSweep-debug.apk`.

Phone/user acceptance remains `DEFERRED_BATCH`; performance is not verified.

## Explicitly not implemented here

- final Hunter HP/damage arithmetic;
- final Block balance/consequence;
- forced movement/stagger/status consequences;
- structural break/sever;
- other Mudcrest attacks/Berserk/behavior selection;
- defeat/escape/reacquisition;
- harvest/inventory/crafting/settlement/persistence runtime.

## Next downstream owner

`FIRST_SLICE_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_IMPLEMENTATION` under generic combat.

It must consume `PENDING_HUNTER_DAMAGE_RUNTIME` idempotently, resolve no-contact/guard consequence, apply the selected Head Sweep 10-Stamina guard-impact drain through shell resource authority, and preserve final HP/injury arithmetic as a separate pending downstream boundary.