# Monster-01 Gameplay Runtime — Mudcrest Raker

Status: ANATOMY + HEAD SWEEP + TAIL SWEEP STATIC/HEADLESS/ANDROID BUILD VERIFIED / CLEAN→STAGGERED PRODUCER VERIFIED
Last reconciled: 2026-09-13

Purpose: own species-specific runtime state and hostile actions for `monster_r01_m01_0001` without moving those rules into the generic combat shell.

## Current owners

`hunt01_mudcrest_anatomy_runtime.gd` owns deterministic per-target integrity and rejects invalid/replayed handoffs. It does not own global Monster HP or defeat and does not yet own crack/break/sever structural states.

`hunt01_mudcrest_attack_runtime.gd` remains the single external Monster activation driver registered with the generic combat shell.

Implemented attacks:
- `M01_HEAD_SWEEP_GORE`: `CAP_M01_HEAD_ATTACK`, 2 AP / 14 Stamina, `GORE_SWEEP`, Piercing + Impact, successful Poleblade Block impact profile 10 Stamina;
- `M01_TAIL_SWEEP`: `CAP_M01_TAIL_SWEEP`, 3 AP / 18 Stamina, rear/flank defensive arc, `TAIL_SWEEP_IMPACT`, pure Impact, successful Poleblade Block impact profile 14 Stamina, current attached `TAIL_DISTAL` capability requirement.

Deterministic normal-action priority is legal rear/flank Tail Sweep, otherwise established Head Sweep, otherwise wait/no-attack when neither implemented attack is legal.

## Structural boundaries

Head and Tail capability reads do not invent structural crack/break/sever thresholds. Current runtime records `PROVISIONAL_BASELINE_HEAD_HORNS_USABLE_NO_BREAK_STATE_RUNTIME` and `PROVISIONAL_BASELINE_TAIL_DISTAL_ATTACHED_NO_SEVER_STATE_RUNTIME` until a future structural owner supplies authoritative transitions. Current constraints: numeric sever thresholds remain open; normalized anatomy integrity must not be interpreted as an implicit detach threshold.

## Tail Sweep geometry/status boundary

Tail Sweep consumes the body-force envelope, authored pivot/forward reference, reversible N10-derived 6.0 m reach, reversible `forward_dot <= 0.25`, four physics pivot-clearance probes and physics line-of-effect. These are first-slice fixtures.

Species wound/contact qualification keeps SOLID pure Impact → one Off-Balance request when selected conditions are met; CLEAN pure Impact → exactly one generic Staggered request; Strong Block → no Tail Sweep status; no Tail Sweep Bleeding path. CLEAN replay is idempotent and does not refresh Staggered twice.

## Verification

Tail Sweep CLEAN→Staggered verified source head `fbfd30fde0ad74bdb73d384533287b884341cd93`.
Workflow `34762775881`: SUCCESS; job `103738398857`: SUCCESS.
Artifact `10319377979`: `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`, SHA-256 `1760956f76d2d908d64f6efc7da3fc7e409d23a26cb4ccd65402c83739d82273`.

Phone/user acceptance remains deferred-batch; sustained performance is not verified.

## Explicitly not implemented here

Final damage/armor balance; structural thresholds/detachment; forced displacement/knockdown; Horn Charge; Shoulder Ram; Foreleg Stomp; Berserk; Monster defeat/escape/reacquisition; harvest/inventory/crafting/settlement/persistence.

Design authorities: `docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md`, `COMBAT_ATTACK_PACKET.md`, and `BEHAVIOR_AND_REGION.md`.
Tail Sweep runtime note: `game/docs/HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME.md`.
