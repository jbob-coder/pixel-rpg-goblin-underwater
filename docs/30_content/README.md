# 30_content — Reusable Content Packages

Status: ACTIVE CONTENT MAP / MONSTER 01 NORMAL ATTACK + BERSERK PACKETS RECORDED
Last reconciled: 2026-09-03

## Purpose

Own authored entity/content packages that configure shared gameplay rules without redefining generic laws.

Current child areas:
- `hunters/` — hunter/player body/content packages;
- `monsters/` — species anatomy, attacks, behavior, Crystal/mutation, Berserk and harvest relationships.

Future areas may include equipment, materials, recipes, reusable status/terrain definitions and other content packages.

## Hunter Base 01

`hunters/HUNTER_BASE_01/README.md`
- neutral reusable hunter base for scale/rig/modular gear;
- not yet the final story protagonist.

## Monster 01 — Mudcrest Raker

Front door:
`monsters/MONSTER_01/README.md`.

Current authorities:
- `ANATOMY_AND_DAMAGE.md` — target groups, horn/plate break, leg impairment, tail sever;
- `COMBAT_ATTACK_PACKET.md` — five normal first-slice attacks, anatomy gates, AP/Stamina, telegraphs/reactions, terrain/cover/status/guard-impact relationships;
- `BERSERK_PROTOTYPE_CONTRACT.md` — one-episode desperation state, Core Energy/strain costs, bounded AP discounts, critical exit/death;
- `BEHAVIOR_AND_REGION.md` — deterministic activity/combat/retreat/Region 01 selection;
- `CRYSTAL_AND_MUTATION.md` — Crystal/mutation context and species Energy expression.

Selected normal attacks:
- Horn Charge;
- Head Sweep/Gore;
- Shoulder Ram;
- Foreleg Stomp;
- Tail Sweep.

Selected Berserk laws:
- entry only at `>20%` and `<=60%` Core Energy plus a deterministic desperation pressure;
- entry consumes full activation + 10% Max Core Energy +20 strain;
- later Berserk activations consume 5% Max +10 strain;
- attack-specific Core surcharges apply;
- attack AP discounts never grant a second damaging attack;
- lost anatomy remains lost;
- critical Energy/strain can end Berserk only when legal retreat exists and Nest Defense is not active;
- zero Core Energy means death.

## Ownership law

- Monster-specific content configures generic combat/Crystal/status/terrain/behavior systems.
- `COMBAT_ATTACK_PACKET.md` decides attack legality/profile.
- `BERSERK_PROTOTYPE_CONTRACT.md` decides Berserk entry/drain/action modifiers/exit.
- `BEHAVIOR_AND_REGION.md` selects deterministically from legal candidates.
- No behavior/animation/UI may bypass destroyed anatomy, cover, terrain or resource legality.

## Content-package law

A content package separates:
- reusable definition;
- runtime instance state;
- presentation references;
- validation/test expectations.

Root authority: `/CONTENT_DATA_GUIDE.md`.

Stable IDs are authority; display names are not identity.

Entity packages may reference Region 01 but cannot redefine its physical sector graph.

`MONSTER_01_ATTACK_PACKET_RECORDED = YES`
`MONSTER_01_BERSERK_PROTOTYPE_RECORDED = YES`
`MONSTER_01_COMBAT_RUNTIME_IMPLEMENTED = NO`

## Exact next gameplay dependency

`SOLO_PARTY_BASELINE_CONTRACT`.