# START HERE — Pixel RPG — Canonical Bootstrap

Status: ACTIVE / FIRST-PERSON / CURRENT AUTHORITY ONLY
Last reconciled: 2026-09-24

Repository: `jbob-coder/Chatgptjuegolpcal`
Active branch: `pixel-rpg`

## Canonical authority barrier

Pixel RPG is the only active game authority for this branch.

Do not use any archived, quarantined, superseded, unrelated, or historical project document, prompt, asset package, camera direction, gameplay identity, or handoff as design authority for Pixel RPG.

Historical material may be consulted only for provenance or for a technical dependency that is demonstrably referenced by the current Pixel RPG source/tests. Historical material never overrides current Pixel RPG design, presentation, camera, sprite, or gameplay direction.

## Mandatory bootstrap

1. Fetch live `pixel-rpg` HEAD and record the exact SHA before doing work.
2. Read this file first.
3. Then read `EVOLVE_ALIGNMENT.md`, `PROJECT_HANDOFF.md`, `DOCUMENTATION_INDEX.md`, `PIXEL_RPG_VISUAL_DIRECTION.md`, the newest relevant Pixel RPG handoff under `docs/70_handoff/`, and the exact owning source/tests/workflow for the bounded task.
4. Re-check HEAD after reconstruction; never mix revisions.
5. Authority order is: current explicit creator instruction → current source/tests/build/device evidence → current Pixel RPG presentation authority → current handoff/alignment docs → narrow owner/package docs.
6. Archived or quarantined material is outside that authority chain.
7. Never weaken a legitimate gate to force success.
8. Never treat CI/build success as physical-device verification.

## Active game identity

Pixel RPG is first-person.

Preserve the current working first-person camera/controller, movement/look, collision ownership, HUD, targeting, Combat Bridge 002, state ownership, deterministic combat/domain systems, and Android build pipeline unless a current bounded task explicitly requires a compatible change.

The active camera contract remains the direct `Camera3D` first-person path with camera-relative movement and the third-person presentation body hidden.

## Current visual direction

User-supplied and approved image-derived assets are presentation authority when they have been explicitly promoted into the current Pixel RPG asset chain.

Gameplay/collision geometry may remain as invisible technical support while approved image-derived art becomes the visible presentation layer. Do not expose duplicated procedural placeholder visuals after an equivalent approved asset has passed parity verification.

The current first-person hands integration task uses the canonical Pixel RPG asset `pixel_rpg_hunter_fp_hands_neutral_r001.png`. It is presentation-only and must not own physics, collision, input, targeting, combat, persistence, or durable state.

## Current work split

- Issue #28 is the master task for canonical first-person hands integration plus authority cleanup.
- Issue #29 is documentation/authority only.
- Issue #30 is sprite/viewmodel integration and technical verification only.

The two work tracks must remain independent and auditable.

## Verification law

`READ LIVE STATE → VERIFY → ONE BOUNDED CHANGE → STATIC/HEADLESS/BUILD QA → FIX SAME-LAYER FAILURES → RECORD EVIDENCE → COMMIT → READ BACK`

Required evidence for a build-affecting change includes exact source SHA, workflow run ID, job ID, Godot version, APK filename, APK size, APK SHA-256, test results, and explicit physical-device verification status.

Physical Android acceptance remains separate from CI: install, launch/no black screen, landscape, first-person framing, hands visibility/clipping, touch movement/look, HUD safe area, targeting, FPS, and heat.
