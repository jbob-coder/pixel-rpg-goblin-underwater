# Hunt-01 Mudcrest Head Sweep Wound / Contact Classification Runtime

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED
Last reconciled: 2026-09-04

## Purpose

Turn the already-resolved `M01_HEAD_SWEEP_GORE` contact/defense/health consequence into a deterministic species/content classification that may emit a valid status application request without applying the status itself.

Owner:
`game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd`.

Schema:
`uhr.hunt01.mudcrest_wound_contact.v1`.

Fixture:
`PROVISIONAL_FIRST_SLICE_HEAD_SWEEP_WOUND_CONTACT_CLASSIFICATION_FIXTURE`.

## Authority boundary

`COMBAT_ATTACK_PACKET.md` requires SOLID/CLEAN horn penetration before Head Sweep may request `status_bleeding +1`, CLEAN impact-dominant contact before it may request `status_off_balance`, and no independent random proc. Mixed `PIERCING + IMPACT` channels alone establish neither condition.

## Reversible first-slice classifier

- no contact or zero applied injury → no status request;
- `BLOCK_STRONG` → no penetration/dominance claim;
- unguarded `GORE_SWEEP` + resolved injury + SOLID/CLEAN → provisional horn penetration → one Bleeding +1 request;
- CLEAN + `BLOCK_PARTIAL` or `BLOCK_BROKEN` + resolved injury → provisional impact-dominant residual force → one Off-Balance request;
- CLEAN unguarded GORE_SWEEP follows horn-penetration priority and does not simultaneously claim impact dominance.

This mapping is replaceable content tuning, not final physical simulation.

## Application request boundary

A qualifying classification emits `VALID_STATUS_APPLICATION_REQUEST` with schema `uhr.status_application_request.v1`, stable request identity, source/target/action/resolution IDs, trigger `ON_HIT_OR_DAMAGE_CONSEQUENCE`, Bleeding intensity delta or Off-Balance apply/refresh mode, and consumer marker `PENDING_GENERIC_STATUS_APPLICATION_RUNTIME`.

This layer does not apply, stack, tick, refresh, expire or remove a status. Generic status application remains downstream.

## Transaction safety

Classification is idempotent by original hostile `resolution_id`. It does not reroll contact, apply Health again, spend AP/RP/Stamina, change anatomy, move actors or modify status state.

## Integration

`CONTACT → DEFENSE/IMPACT → HEALTH/INJURY → SPECIES WOUND/CONTACT CLASSIFICATION → reaction close → Monster activation complete`.

The stable Head Sweep resolution records `wound_contact_classification` beside the original damage handoff and defense consequence.

## Verification evidence

Implementation commit:
`6012235a958c0d4a73ff7c36201e2eff20715b70`.

Production workflow `33935813877`: SUCCESS.
Job `101223419039`: SUCCESS.

Static gate:
`HUNT01_MUDCREST_WOUND_CONTACT_SOURCE_STATIC_VERIFIED`.

Headless gate:
`HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME_VERIFIED`.

Artifact `9960134957`:
- `UnnamedHuntRPG-Hunt01-WoundContact-debug`;
- 57,384,899 bytes;
- SHA-256 `54f942ec0d891a27c9ee702db58db8edf68cb905e2468b07f3097797976820b1`;
- APK output `UnnamedHuntRPG-Hunt01-WoundContact-debug.apk`.

The successful production run also passed Godot 4.7.2 parse/import, AppShell/Region smoke and all preceding combat/anatomy/Hunter-attack regressions.

Phone acceptance and sustained performance remain deferred/not verified.
