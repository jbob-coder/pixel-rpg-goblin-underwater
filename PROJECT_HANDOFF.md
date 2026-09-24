# PROJECT HANDOFF — Pixel RPG

Status: ACTIVE / FIRST-PERSON / AUTHORITY CLEANUP + CANONICAL HANDS INTEGRATION IN PROGRESS
Last reconciled: 2026-09-24
Branch: `pixel-rpg`

## CURRENT_OBJECTIVE

Finish the current first-person presentation pipeline without changing proven gameplay/domain ownership:
1. close authority/document cleanup under issue #29;
2. integrate the canonical first-person hands PNG into the live ViewModel under issue #30;
3. pass the required Godot/regression/Android build gates;
4. preserve physical-device validation as a separate evidence stage.

Parent pipeline: issue #28.

## CURRENT_STATE

Pixel RPG is first-person.

Current source keeps:
- direct active `Camera3D` first-person path;
- camera-relative movement and independent look;
- hidden non-first-person presentation body;
- existing world/collision authority;
- targeting and Combat Bridge 002 no-attack bootstrap;
- State Ownership 001;
- deterministic combat/anatomy/status domain regressions;
- Android build/export pipeline.

The canonical first-person hands source is recorded as:
`pixel_rpg_hunter_fp_hands_neutral_r001.png`.

Repository source-identity records exist under:
`game/assets/characters/first_person/`.

Live ViewModel scene:
`game/assets/characters/first_person_viewmodel_01.tscn`.

Issue #30 remains open until the PNG is actually live in that ViewModel and all required gates pass.

## AUTHORITY

Active authority chain:
1. explicit current creator instruction;
2. current source/tests/build/device evidence;
3. `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`;
4. `START_HERE_NEW_CHAT.md`;
5. `PIXEL_RPG_VISUAL_DIRECTION.md`;
6. `EVOLVE_ALIGNMENT.md` and this handoff;
7. narrow owner/package docs.

Archived, quarantined, superseded, or unrelated project material is outside this chain. It may remain for provenance or a proven technical dependency but cannot direct current camera, sprites, visual identity, gameplay identity, or priorities.

## LAST VERIFIED VISUAL BASELINE

Visual Pack 011 Direct Concept-Photo PNG Assets:
- source SHA: `93978e1947fe8cffaeb0876574d8d761dcad90b2`;
- workflow run: `35947488962` — SUCCESS;
- job: `107468585038` — SUCCESS;
- Godot: `4.7.2.stable.official.ed1daf0bf`;
- APK: `PixelRPG-visual-pack-011-direct-photo-assets-debug.apk`;
- APK size: `58,290,596` bytes;
- APK SHA-256: `bec6ba206a293edab5ab6b5220090e444b110a3521f7f8a48c6e9b6cade40c7b`.

That baseline includes seven standalone RGBA concept-derived environment assets under:
`game/assets/environment/starting_area/concept_photo_sprites_011/`.

Their presentation layer owns no collision, input, targeting, combat, persistence, or durable world state.

## COMPLETED_WORK

Current first-person foundation already has recorded engine/build evidence for:
- first-person realignment;
- Pack 009 camera-local ViewModel foundation;
- image-derived environment presentation through Pack 011;
- Gate Warden and smith interaction preservation;
- Mudcrest targeting/anatomy preservation;
- Combat Bridge 002 no-attack bootstrap;
- State Ownership 001;
- deterministic combat/anatomy/status regressions;
- Android debug export/package-size gate.

Authority cleanup completed so far:
- canonical bootstrap barrier added;
- active authority barrier added;
- Drive legacy handoff/folder quarantine verified;
- active alignment/index/visual-direction documents reconciled to current Pixel RPG authority;
- historical evidence retained outside active bootstrap authority.

## IN_PROGRESS

Issue #29 — authority/document cleanup:
- verify active bootstrap contains no path into quarantined Drive material;
- keep handoff/manifests as provenance only unless current source proves dependency;
- record exact intentionally retained history and justification;
- report final evidence to issue #28.

Issue #30 — technical hands integration:
- canonical PNG must be present in source;
- wire it into the live ViewModel as presentation-only art;
- preserve existing placeholder geometry as fallback until parity gates pass;
- update owning tests without weakening first-person invariants;
- run required build/regression gates;
- record exact source/build evidence.

## REQUIRED GATES FOR ISSUE #30

- Godot import/parse;
- AppShell smoke;
- prototype scene smoke;
- first-person realignment runtime gate;
- first-person ViewModel gate;
- Combat Bridge 002 no-attack bootstrap;
- State Ownership gate;
- deterministic combat/anatomy/status regressions;
- Android debug export;
- package-size ceiling.

## IMPORTANT_DECISIONS

- Do not restart the game or replace proven domain systems for presentation work.
- Approved image-derived art may replace duplicated visible procedural placeholders only after parity verification.
- Gameplay/collision geometry may remain invisible technical support.
- Presentation assets do not own gameplay state.
- Documentation-only changes must not be presented as runtime verification.
- Build success must not be presented as physical-device verification.
- Use free/no-billing-risk tooling for normal project work.

## KNOWN_RISKS

- Active source can move while documentation is being reconciled; always re-fetch HEAD before writes.
- A PNG source record is not equivalent to live ViewModel integration.
- Camera-local sprite placement can obstruct targeting or clip at phone aspect ratios even when headless gates pass.
- Removing procedural geometry before parity proof can create regressions.
- Historical evidence can contaminate current direction if treated as bootstrap authority.

## TEST_RESULTS

Latest fully recorded visual baseline: PASS at source/Godot/headless/Android-build level as listed above.

Current canonical-hands integration: NOT YET COMPLETE until issue #30 records a live source commit and passing gates.

Physical-device visual/touch/performance acceptance for the current hands work: NOT VERIFIED.

## NEXT_ACTION

Finish #29 with readback evidence, then keep documentation stable while #30 completes the technical integration and build gates. After #30 passes, prepare a bounded physical Android validation checklist for first-person hands composition, clipping, touch controls, targeting, safe areas, sustained FPS/heat, and lifecycle behavior.
