# Hunt-01 Hunter Health / Injury Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED
Last reconciled: 2026-09-04

## Purpose

Consume one stable `PENDING_HUNTER_HEALTH_INJURY_RUNTIME` transaction exactly once and make incoming Monster contact materially affect Hunter state without pretending prototype balance is final.

Generic owner:
`game/scripts/gameplay/combat/hunt01_hunter_health_injury_runtime.gd`.

Schema:
`uhr.hunt01.hunter_health_injury.v1`.

## Reversible first-slice fixture

`PROVISIONAL_FIRST_SLICE_HUNTER_HEALTH_INJURY_FIXTURE`.

Normalized prototype Max Health: `100`.

Hit-quality base loads:
- GRAZE `4`;
- SOLID `8`;
- CLEAN `12`.

Residual-force percentages:
- `BLOCK_STRONG` `25%`;
- `BLOCK_PARTIAL` `60%`;
- `BLOCK_BROKEN` `90%`;
- `NO_ACTIVE_GUARD` `100%`.

Applied load is ceiling-rounded, capped by remaining Health and clamps at zero. These are first-slice tuning values only, not final Max Health/damage balance.

## Protection boundary

No authored Hunter gameplay armor profile currently exists. The Hunter visual packet is presentation intent; gameplay protection must come from equipment definitions.

This slice records:
`PROVISIONAL_NO_AUTHORED_HUNTER_GAMEPLAY_ARMOR_PROFILE_RESIDUAL_FORCE_BASELINE`.

It does not invent protection values from the model.

## Status boundary

The Monster attack packet allows Bleeding only after horn-penetration wound conditions and Off-Balance only for CLEAN impact-dominant contact. The current hostile handoff preserves `PIERCING + IMPACT` channels but does not prove dominant channel or confirmed penetration.

Therefore `status_requests` remains empty. Candidate-only metadata records missing prerequisites. A species/content-owned wound/contact classifier is the next owner.

## Zero-health boundary

Reaching zero emits `PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME`. This runtime does not end the encounter, respawn, retreat, drop loot or implement defeat.

## Integration

The generic defense-consequence owner instantiates this health owner and resolves the health handoff before the defense transaction returns to the Mudcrest attack driver:

`CONTACT → DEFENSE/IMPACT → HEALTH/INJURY → reaction close → Monster activation complete`.

Replay/readback cannot apply injury twice.

## Verification evidence

Implementation commit:
`057928b30ddef3eac83a316a62c48b5e3fa22632`.

Same-layer QA/documentation compatibility repairs:
- `da2ee5698a7b7c640b8d848fc0cde3d9f877921e`;
- `06bd3e6ee039bc0f975918d6cf5fef232bf36cdc`.

Static gate:
`HUNT01_HUNTER_HEALTH_INJURY_SOURCE_STATIC_VERIFIED`.

Headless gate:
`HUNT01_HUNTER_HEALTH_INJURY_RUNTIME_VERIFIED`.

Production workflow `33934988066`: SUCCESS.
Job `101221044355`: SUCCESS.

Artifact:
- ID `9959871663`;
- name `UnnamedHuntRPG-Hunt01-HunterHealth-debug`;
- size `57,365,013` bytes;
- SHA-256 `ebb15c4b124e9b046e4194951414bc01cdcd5c28a8136d7ebb2f8b694fcf1f66`;
- APK output `UnnamedHuntRPG-Hunt01-HunterHealth-debug.apk`.

Phone/user acceptance remains deferred-batch. Performance remains unverified.

## Next owner

`FIRST_SLICE_MUDCREST_HEAD_SWEEP_WOUND_CONTACT_CLASSIFICATION_RUNTIME_IMPLEMENTATION` belongs to Monster-01 species/content. It consumes this already-resolved consequence without changing Health and establishes whether the packet's horn-penetration or impact-dominance prerequisites actually qualify for a status request.