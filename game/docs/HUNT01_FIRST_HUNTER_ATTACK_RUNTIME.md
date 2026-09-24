# Hunt-01 First Hunter Attack Runtime

Status: MEASURED CUT BASELINE VERIFIED / MUDCREST ANATOMY INTEGRATION IMPLEMENTED IN SOURCE / RE-VERIFICATION PENDING
Last reconciled: 2026-09-04

This runtime owns exactly one Hunter attack after the existing same-location encounter, deterministic turn shell and adjacent tactical movement:

`POLEBLADE_MEASURED_CUT`

Prototype contract:
- 2 AP;
- 12 Stamina;
- CUTTING damage channel;
- selected Mudcrest target group;
- `ALLOW_BODY_FALLBACK`;
- hit-quality ceiling `CLEAN`;
- no independent critical-hit roll;
- one deterministic FNV-1a-derived bounded variance sample per committed attack;
- hard range/line-of-effect/resource validation before commitment;
- local target protection is resolved before species anatomy consequence.

Working-melee prototype:
- uses existing `R01_EF02` tactical-node graph and authored Monster body-force envelope;
- Measured Cut requires the current tactical node within 3.5 m of that body-force envelope;
- `R01_EF02_N09` is the current practical Measured Cut contact node;
- reaching N09 through three Round-1 1-AP moves leaves only 1 AP, so a 2-AP attack waits for the next Hunter activation.

Player-facing target groups:
`HEAD`, `HORN_CREST`, `FORELEG_L`, `FORELEG_R`, `HINDLEG_L`, `HINDLEG_R`, `DORSAL_PLATES`, `TAIL`.

Contact fixture:
- provisional AttackControl base 70;
- provisional DefenseControl 55;
- explicit target-control penalties;
- one deterministic variance sample in [-6,+6];
- margin maps to `MISS / GRAZE / SOLID / CLEAN`;
- selected-part acquisition requires margin >= 6;
- legal body contact below selected-part acquisition falls back to `GENERAL_TORSO`.

These control values remain `PROVISIONAL_FIRST_SLICE_CONTROL_FIXTURE`, not final Hunter/Mudcrest balance.

## Mudcrest anatomy integrity runtime integration

A committed attack now builds one `PENDING_ANATOMY_DAMAGE_RUNTIME` handoff carrying stable transaction identity:
- `resolution_id`;
- encounter ID;
- round ID;
- action sequence;
- attacker/defender IDs;
- technique ID;
- resolved target group;
- hit quality;
- CUTTING channel;
- local protection profile.

The handoff is delegated exactly once to:
`game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd`.

The attack runtime does not calculate target integrity directly and does not reroll contact. It retains the returned `anatomy_result` inside the same committed attack result/trace and exposes the provisional integrity change in the existing attack HUD.

The anatomy consumer currently uses `PROVISIONAL_FIRST_SLICE_ANATOMY_INTEGRITY_FIXTURE`, not final damage balance. Duplicate replay/readback is idempotent and does not apply integrity loss twice.

## Deliberate non-scope

- final damage/health arithmetic;
- crack/break/sever thresholds;
- tail detachment;
- bleeding/status application;
- Monster reaction selection;
- Monster attack runtime;
- defeat/escape outcome.

Previous Measured Cut baseline was HEADLESS VERIFIED / ANDROID BUILD VERIFIED at source `6c6715a2fb4a945b953e1dc1fbc69f79731c31ab`, workflow `33851145446`.

The new anatomy integration must pass the updated static/headless/Android workflow before its verification status can be promoted. Phone/user acceptance remains deferred-batch and performance is not verified.
