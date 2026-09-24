# Hunt-01 Mudcrest Tail Sweep Attack Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED
Last reconciled: 2026-09-13

## Purpose

Add the first intact-tail rear/flank hostile action to the existing Monster-01 attack owner without introducing another scheduler, another Monster activation driver, structural sever thresholds or a new status system.

Runtime owner: `game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd`.
Attack: `M01_TAIL_SWEEP`.
Capability: `CAP_M01_TAIL_SWEEP`.

## Authored attack packet

Selected values remain 3 AP / 18 Stamina, pure Impact, 14-Stamina successful Poleblade Block impact drain after normal Block commitment, rear/flank role, hindquarter pivot/arc-clearance requirement and attached `TAIL_DISTAL` capability. SOLID contact may request Off-Balance; CLEAN contact requests Staggered through the existing generic status owner.

## Reversible geometry/control fixture

The executable slice uses the existing body-force envelope, authored pivot center/radius and forward reference; 6.0 m maximum distance outside the body-force envelope derived from authored N10; provisional `forward_dot <= 0.25`; four physics pivot-clearance probes across the authored 8 m pivot radius; physics line-of-effect; and one deterministic FNV-1a bounded variance sample.

Fixture: `PROVISIONAL_FIRST_SLICE_MUDCREST_TAIL_SWEEP_CONTROL_FIXTURE`.
These are replaceable tuning fixtures, not final animation/reach balance.

## Structural boundary

No crack/break/sever threshold owner exists. Tail Sweep records `PROVISIONAL_BASELINE_TAIL_DISTAL_ATTACHED_NO_SEVER_STATE_RUNTIME`; normalized Tail integrity is not interpreted as a sever threshold and this slice does not detach/break/mutate the tail.

## Reaction and consequence flow

`Monster activation → Tail Sweep legality → 3 AP / 18 Stamina commit → presentation-only telegraph → shared reaction window → Block/decline → one seeded contact resolution → generic defense → generic Hunter health → Mudcrest wound/contact qualification → generic status application → reaction close → encounter outcome boundary → Monster activation complete`.

The first paid reaction remains `POLEBLADE_BLOCK`; decline remains free. Tail Sweep routes its 14-Stamina successful Block impact drain through the existing generic Hunter defense consequence owner.

## Status boundary

- MISS/no injury → no status request;
- funded `BLOCK_STRONG` → no Tail Sweep status request;
- SOLID Impact with resolved injury and no Strong Block → one valid `status_off_balance` request;
- CLEAN Impact with resolved injury and no Strong Block → one valid `status_staggered` request consumed by the existing generic status owner.

CLEAN application uses `APPLY_OR_REFRESH` with no intensity delta, and replay of the same stable resolution does not dispatch or refresh twice. Tail Sweep has no Bleeding path.

## Presentation asset

`game/assets/effects/mudcrest_tail_sweep_telegraph.tscn` is non-colliding presentation only and owns no legality, hit detection, damage or status state.

## Verification evidence

Static gate: `HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_SOURCE_STATIC_VERIFIED`.
Dedicated headless gate: `HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME_VERIFIED`.

Verified source head: `fbfd30fde0ad74bdb73d384533287b884341cd93`.
Production workflow `34762775881`: SUCCESS.
Job `103738398857`: SUCCESS.
Artifact ID `10319377979`.
Artifact name `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`.
Artifact size `57,485,460` bytes.
Artifact SHA-256 `1760956f76d2d908d64f6efc7da3fc7e409d23a26cb4ccd65402c83739d82273`.

The successful workflow executed current static gates, Godot 4.7.2 import/parse, production smokes, dedicated/current headless regressions including Tail Sweep and Generic Status Application/Timing, Android export, artifact validation and upload.

## Explicit exclusions

No claim is made for final Tail Sweep reach/control balance, structural crack/break/sever thresholds, tail detachment, forced displacement/knockdown, Bleeding periodic HP magnitude, Monster escape/death, harvest/inventory/crafting, phone acceptance or sustained Android performance.
