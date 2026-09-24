# Pixel RPG — Pending Corroboration Audit

Status: NON-AUTHORITATIVE AUDIT NOTES / UPDATE ONLY AFTER CORROBORATION  
Date: 2026-09-24  
Repository inspected: `jbob-coder/pixel-rpg-goblin-underwater`  
Branch inspected: `main`  
Live HEAD at audit: `6c42a39d4f58969d1d165bbb12e34f387e57a13b`  
HEAD CI run: `36073988516` — SUCCESS

## Purpose

Record things that look wrong, stale, contradictory, or insufficiently verified without silently rewriting authority.

These notes are not design authority. A finding may be:
- **CONFIRMED STALE** — live repository evidence contradicts the document;
- **LIKELY STALE** — strong evidence suggests it should change, but owner intent should be confirmed;
- **COVERAGE GAP** — implementation exists and broad gates pass, but the exact claim lacks a dedicated regression;
- **RECONCILIATION NEEDED** — older structural material contains useful rules mixed with superseded presentation direction.

Do not convert a note into a current requirement until the owning source/doc is checked and the change is corroborated.

---

## A-001 — Active bootstrap documents still point to the old repository/branch

Status: **CONFIRMED STALE**  
Priority: P0 documentation/authority

Observed:
- `START_HERE_NEW_CHAT.md` says repository `jbob-coder/Chatgptjuegolpcal`, branch `pixel-rpg`.
- `EVOLVE_ALIGNMENT.md` says branch `pixel-rpg`.
- `DOCUMENTATION_INDEX.md` says branch `pixel-rpg` and tells the reader to fetch live `pixel-rpg` HEAD.
- `PROJECT_HANDOFF.md` says branch `pixel-rpg`.
- `PIXEL_RPG_AUTHORITY_LOCK.md` says branch `pixel-rpg`.
- `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md` says branch `pixel-rpg`.
- root `README.md` also says branch `pixel-rpg`.

Live evidence:
- active repository is `jbob-coder/pixel-rpg-goblin-underwater`;
- active branch is `main`;
- audited HEAD is `6c42a39d4f58969d1d165bbb12e34f387e57a13b`.

Risk:
A new chat or contributor following the bootstrap literally can resume work in the superseded repository.

Recommended update after corroboration:
Reconcile all active bootstrap/authority docs to the new repository and `main`, while retaining the old repository only as migration provenance.

---

## A-002 — Old issue split (#28/#29/#30) is still presented as current authority

Status: **CONFIRMED STALE**  
Priority: P0 documentation/coordination

Observed in current root docs:
- issue #28 = master pipeline;
- issue #29 = authority/document cleanup;
- issue #30 = hands integration.

Live evidence:
The new repository uses its own issue register. Current master is `pixel-rpg-goblin-underwater#20`; current work items are in this repository (#1 onward). Old issues were moved/closed in the superseded repository.

Risk:
Future work can be assigned to closed historical tasks or the wrong repository.

Recommended update after corroboration:
Replace the old issue split with the current issue map, preserving #28/#29/#30 only as historical provenance where useful.

---

## A-003 — Current handoff/index still say the canonical hands integration is incomplete

Status: **CONFIRMED STALE**  
Priority: P0 evidence/documentation

Observed:
`PROJECT_HANDOFF.md` says issue #30 remains open until the PNG is live in the ViewModel and required gates pass.

Live source evidence:
- `game/assets/characters/first_person_viewmodel_01.tscn` directly references:
  `res://assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png`;
- `game/tests/pixel_rpg_visual_pack_009_first_person_viewmodel_test.gd` requires that exact PNG path;
- `game/assets/characters/first_person/CANONICAL_HANDS_SOURCE.sha256` records:
  `7c310f85978f300a0be4f2fe4ab6a9e0439bbf2daf1c0883e014f6179ff509a4`;
- `CANONICAL_HANDS_RUNTIME_RULE.md` locks the exact 640x360 RGBA PNG.

Live gate evidence at audited HEAD:
- run `36073988516`: SUCCESS;
- verification job `107881190165`: SUCCESS;
- Android export job `107881331325`: SUCCESS.

Boundary:
This proves repository/headless/build integration, not physical-phone visual acceptance.

Recommended update after corroboration:
Change current hands status from “integration in progress/not complete” to implemented + CI/headless/Android-build verified, with phone visual/touch/performance still explicitly unverified.

---

## A-004 — Documentation Index points to a workflow that no longer exists

Status: **CONFIRMED STALE**  
Priority: P0 build documentation

Observed:
`DOCUMENTATION_INDEX.md` lists:
`.github/workflows/pixel-rpg-prototype-android.yml`

Live evidence:
The current `.github/workflows/` directory contains only:
`.github/workflows/pixel-rpg-ci.yml`

Current CI is the workflow that passed run `36073988516`.

Risk:
A maintainer can inspect or edit a nonexistent build authority.

Recommended update after corroboration:
Make `pixel-rpg-ci.yml` the single documented current CI/build authority.

---

## A-005 — Claimed repository-authority file is not present in the current tree

Status: **NEEDS CORROBORATION**  
Priority: P1 authority hygiene

Observed:
A prior migration step reported creation of root `REPOSITORY_AUTHORITY.md`.

Live evidence:
Fetching `REPOSITORY_AUTHORITY.md` from current `main` returns Not Found.

Possible explanations:
1. it was created before a later snapshot/force migration and disappeared;
2. it was never present in the final migrated tree;
3. its role was superseded by `docs/00_authority/PIXEL_RPG_ACTIVE_AUTHORITY.md`.

Recommended action:
Do not blindly recreate it. First decide whether one authority file is enough. If the existing active-authority file is canonical, update that instead of creating duplicate authority owners.

---

## A-006 — Some “guide book” documents still carry superseded camera/project direction

Status: **RECONCILIATION NEEDED**  
Priority: P0 design safety

Examples:
- `NEW_GAME_ARCHITECTURE_VISUAL_BIBLE.md` identifies a `shooter-rpg` branch and third-person direction.
- `SYSTEM_ARCHITECTURE_BLUEPRINT.md` includes an older “aerial exploration or first-person combat” presentation model.
- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md` repeatedly discusses aerial readability.
- `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md` contains aerial-camera assumptions.

Current authority evidence:
`PIXEL_RPG_VISUAL_DIRECTION.md` is explicit that normal exploration is first-person and that current explicit creator direction/source/evidence outrank historical presentation records.

Important distinction:
The older guides contain many still-useful structural rules:
- one authoritative state model;
- presentation does not own gameplay truth;
- stable IDs;
- deterministic/testable systems;
- modular buildings;
- simplified collision proxies;
- bounded streaming;
- Android performance discipline.

The presentation-specific aerial/third-person statements should not be used as current Pixel RPG direction.

Recommended update after corroboration:
Classify each older guide by section:
- reusable structural rule;
- superseded presentation rule;
- historical/prototype-only assumption.
Do not delete useful architecture merely because its old camera framing is wrong.

---

## A-007 — Several architecture guides still say “NO IMPLEMENTATION”

Status: **CONFIRMED STALE STATUS, CONTENT PARTIALLY REUSABLE**  
Priority: P1 documentation

Examples:
- `SYSTEM_ARCHITECTURE_BLUEPRINT.md`: “NO ENGINE SOURCE IMPLEMENTED”;
- `CODE_GUIDE.md`: “ENGINE-SPECIFIC SOURCE NOT CREATED”;
- `CONTENT_DATA_GUIDE.md`: “NO CONTENT PIPELINE IMPLEMENTED”;
- `MECHANICAL_SYSTEMS_GUIDE.md`: “NO IMPLEMENTATION”;
- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`: “NO IMPLEMENTATION”.

Live evidence:
The repository now contains Godot scenes/scripts/tests, a deterministic combat stack, world composition, first-person runtime, image-derived assets, Android export, and a passing canonical CI.

Recommended update after corroboration:
Do not rewrite the whole guides as if every planned system is complete. Change their status to something like “LEGACY DESIGN CONTRACT / PARTIALLY IMPLEMENTED — VERIFY AGAINST LIVE OWNER” and add explicit section-level ownership links.

---

## A-008 — Path extraction passed broad CI but lacks a dedicated parity regression

Status: **COVERAGE GAP**  
Priority: P0 implementation quality  
Related issue: #1

Live change:
- `game/scripts/presentation/pixel_rpg/world_paths_001.gd` now owns Street/Trail visual surface creation and detail scenes;
- `pixel_rpg_prototype_001.gd` routes path construction through that owner;
- exact legacy constants were retained:
  - Street position `(0, 0.03, 2)`, size `(6.2, 0.10, 34)`;
  - Trail position `(0, 0.04, -31)`, size `(4.2, 0.11, 34)`.

Evidence:
Current HEAD `6c42a39d4f58969d1d165bbb12e34f387e57a13b` passed canonical run `36073988516`, including import/parse, AppShell smoke, all discovered GDScript tests, and Android export.

Gap:
A dedicated “decomposition 002 / path parity” test was prepared conceptually but is not present in the current tree. Broad regression success is useful but does not explicitly prove every path anchor/material/detail contract.

Recommended action:
Before extracting the next world-composition slice, add a narrow path parity test that asserts exact Street/Trail transforms, sizes, detail roots, lack of new physics ownership, and first-person camera survival.

---

## A-009 — Prototype controller remains a large multi-responsibility owner

Status: **KNOWN STRUCTURAL RISK / ALREADY TRACKED**  
Priority: P0 architecture  
Related issue: #1

Observed in:
`game/scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd`

It still owns substantial portions of:
- mobile touch input;
- first-person yaw/pitch;
- player movement;
- HUD safe-area layout;
- minimap;
- settings/watch panels;
- targeting presentation;
- Combat Bridge bootstrap glue;
- contextual interactions;
- smith roof visibility;
- remaining world composition;
- NPC/monster presentation anchors.

This is not proof that the current runtime is broken. The current HEAD CI passes.

Why it is risky:
It conflicts with the guide’s anti-monolith rule and increases regression coupling.

Recommended action:
Continue #1 only in mechanical, individually gated extractions. Do not perform a large rewrite.

---

## A-010 — Current CI/build success must not be promoted to phone acceptance

Status: **BOUNDARY TO PRESERVE**  
Priority: P0 evidence

Current evidence:
- run `36073988516` passed source verification and Android export.

Still not proven by that run:
- physical Android install/launch;
- touch/multi-touch ergonomics;
- exact first-person hands composition/clipping on phone;
- safe areas on OEM devices;
- sustained FPS/frame pacing;
- heat/battery;
- installed footprint on the target device.

Related current tracker: #18.

---

## Corroboration workflow

For each item:
1. fetch current `main` HEAD again;
2. read the exact owning source/test/doc;
3. confirm whether the mismatch still exists;
4. update the smallest owning document or test;
5. run relevant CI/gate;
6. record commit + run evidence;
7. mark this audit item RESOLVED, REJECTED, or STILL OPEN.

Do not “fix” historical evidence by rewriting history. Update current authority and add supersession markers where needed.
