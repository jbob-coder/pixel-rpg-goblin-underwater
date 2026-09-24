# HUNT-01 Mudcrest Head Sweep Attack Runtime — Verified Handoff

Date: 2026-09-04
Project: Unnamed Hunt RPG
Branch: `worldlife-reference-docs`
Production root: `game/`

## Completed bounded layer

`FIRST_SLICE_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME_IMPLEMENTATION`

Verification status:
- IMPLEMENTED: YES
- STATIC VERIFIED: YES
- GODOT 4.7.2 PARSE/IMPORT: PASS
- HEADLESS VERIFIED: YES
- ANDROID BUILD VERIFIED: YES
- APK/EVIDENCE ARTIFACT UPLOAD: PASS
- PHONE VERIFIED: NO / DEFERRED_BATCH
- PERFORMANCE VERIFIED: NO

Final verified source head before this documentation promotion:
`f7fe9d347921289ca104824e61fd82a2efc73fed`.

Production workflow `33932945947`: SUCCESS.
Workflow job `101215138444`: SUCCESS.

## Implemented ownership

Species owner:
`game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd`.

Schema:
`uhr.hunt01.mudcrest_attack.v1`.

Implemented attack:
`M01_HEAD_SWEEP_GORE`.

Selected commitment:
`2 AP / 14 Stamina`.

The runtime:
- owns the real Monster activation-driver transaction;
- validates head capability, body-envelope working melee, authored front/front-flank bearing and full-cover line of effect;
- commits resources exactly once;
- emits an authoritative Head Sweep telegraph plus a non-colliding world threat-band asset;
- opens/consumes the shared Hunter reaction window;
- supports the currently executable `POLEBLADE_BLOCK` and free decline paths;
- resolves one deterministic FNV-1a contact/hit-quality sample;
- routes contact through Field Poleblade guard or pending Hunter body protection;
- records the selected 10-Stamina standard Block impact-drain profile;
- emits a stable `PENDING_HUNTER_DAMAGE_RUNTIME` handoff;
- completes the Monster activation without fabricating Hunter HP damage.

## Implementation / QA revisions

Primary implementation:
`238f6bba98cb6dd7deb420bfe5196e08a3542279`.

QA repairs:
- `6cc493f3a9ce00b84279ac00e1985fc08276c4e0` — current reaction documentation boundary accepted by static gate;
- `0d843079bf6343cbb0b35d12264ce695ae5b5c5c` — current anatomy structural-boundary wording accepted by static gate;
- `bd732960051c9850dbec7beeaf856e73b478f9ad` — dedicated Head Sweep test waits one physics/process boundary after synthetic tactical movement so the cover ray reads the same N09 transform as real frame-separated movement;
- `f7fe9d347921289ca104824e61fd82a2efc73fed` — reaction regression frees the production deferred hostile driver before installing its controlled mock, preserving the production shell's one-driver invariant.

The last two are test-only. No production attack cost, coordinates, range, bearing, contact math, reaction cost or runtime source changed.

## Final automated evidence

Workflow `33932945947` passed:
- authoritative manifest / production projection;
- static/source combat gates;
- Godot 4.7.2 import/parse;
- AppShell smoke;
- Region-01 smoke;
- Hunt-01 production integration;
- combat turn shell + tactical movement;
- Hunter reaction regression;
- dedicated Mudcrest Head Sweep headless;
- Mudcrest anatomy headless;
- Hunter attack/anatomy headless;
- Android debug export;
- artifact upload.

Artifact:
- ID `9959201882`;
- name `UnnamedHuntRPG-Hunt01-MudcrestHeadSweep-debug`;
- size `57,322,699` bytes;
- digest `sha256:b56070a42a9abd5ef534443750c441385b1f5f8327a48f7ea1080e490abe0ca8`;
- APK output `UnnamedHuntRPG-Hunt01-MudcrestHeadSweep-debug.apk`.

The connector's generic REST fetch does not support the job-log download endpoint, so this handoff does not claim an unseen generic `ERROR:` scan. The known duplicate-driver path was instead removed structurally in the controlled reaction regression and the entire workflow passed afterward.

## Retained boundaries

Final Hunter Max Health/damage arithmetic is not selected.
Final Block balance is not selected.
Structural crack/break/sever/detachment is not implemented.
Status application, remaining Mudcrest attacks, behavior/Berserk, defeat/escape/reacquisition and the harvest-to-settlement runtime loop remain incomplete.

Phone validation remains `DEFERRED_BATCH` and performance remains unverified.

## Exact next bounded piece

`FIRST_SLICE_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_IMPLEMENTATION`.

Generic owner:
`game/scripts/gameplay/combat/`.

Required next-slice boundary:
1. consume one stable `PENDING_HUNTER_DAMAGE_RUNTIME` handoff idempotently;
2. no-contact resolves with no Hunter resource/health consequence;
3. Field Poleblade guard contact resolves through the existing Combat Resolution and Stamina contracts;
4. Head Sweep's 10-Stamina impact drain is separate from the already committed 1 RP / 6 Stamina reaction cost and must mutate resources only through shell authority;
5. Stamina cannot become negative and repeated readback cannot drain twice;
6. where final Block thresholds are still open, use an explicitly named reversible first-slice fixture rather than pretending the balance is final;
7. expose stable `BLOCK_STRONG / BLOCK_PARTIAL / BLOCK_BROKEN`-compatible consequence data as far as the selected fixture legitimately supports;
8. do not apply invented Hunter Max Health/damage/wound numbers;
9. emit a stable downstream pending health/injury handoff when force remains after defense;
10. integrate before the Monster activation finishes;
11. add static/headless/regression/Android-build gates;
12. phone remains deferred.

Do not implement Dodge/Parry/Brace, other Mudcrest attacks, break/sever, statuses, defeat/escape or harvest inside this bounded piece.