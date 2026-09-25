# Pixel RPG — Package Authority Matrix

Status: CURRENT DOCUMENTATION / OWNERSHIP NAVIGATION  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Purpose

This matrix defines what each major repository/documentation package is allowed to own and what it must not override.

The project has accumulated several generations of design, implementation, test, build, device, and historical records. Folder location alone does not grant authority.

## Authority rule

Current claim resolution order:

1. current creator instruction;
2. live production source;
3. exact implementation owner;
4. exact current tests;
5. exact same-SHA build/device evidence;
6. current issue register;
7. current authority/navigation documents;
8. narrow package documentation;
9. historical handoffs/provenance.

## Package matrix

| Package | Primary role | Current relationship to implementation | Must not override |
|---|---|---|---|
| Repository root current authority files | game identity, bootstrap, current presentation, handoff, operating law | current documentation/navigation | live source/tests/evidence |
| `docs/00_authority/` | authority barriers, migration/stale-doc audit | current governance | implementation owners |
| `docs/00_project/` | project governance, repository maps, classification, readiness/history | current navigation + historical snapshots | subsystem mechanics |
| `docs/10_world/` | world/region/settlement/spatial design packages | mixed: Region-01 legacy implementation lineage + future/current-world design | live world transforms/collision/source |
| `docs/20_gameplay/` | reusable gameplay contracts: combat, harvest, inventory, crafting, progression | mixed: combat has live runtime descendants; several other systems are future/partial | executable domain owners |
| `docs/30_content/` | concrete Hunter/Monster/content packages | mixed: Mudcrest content has live runtime descendants; other content may be design only | generic gameplay rules |
| `docs/40_art/` | current art/runtime-asset records + historical asset pipeline | mixed: current Pack 010/011 runtime lineage + older pipeline history | gameplay/collision/state authority |
| `docs/50_technical/` | engine, Android, decomposition, persistence/state ownership | mixed: some current technical owners, some older design contracts | gameplay-design ownership outside technical scope |
| `docs/60_quality/` | testing/performance/debug quality navigation | documentation/protocol layer | exact current test results |
| `docs/70_handoff/` | historical continuity and exact past evidence | historical/provenance only | current design/runtime authority |
| `game/` | production Godot runtime | primary implementation authority | creator direction / declared ownership contracts |
| `game/tests/` | current Godot regression/integration gates | current executable verification | physical-device claims |
| `tests/quality/` | static/preflight verification | current static QA | runtime/device claims |
| `ci/stage1/` | older Stage-1 support/test scripts | historical unless explicitly invoked | canonical CI definition |
| `probes/android_stage1/` | isolated engine/device probe | historical/probe evidence | production gameplay architecture |
| `.github/workflows/pixel-rpg-ci.yml` | canonical automated source/test/Android export path | current build automation | phone visual/performance acceptance |

## Root current-authority files

Current entry/authority set:

- `README.md`
- `START_HERE_NEW_CHAT.md`
- `NEW_CHAT_CONTINUATION_PROMPT.md`
- `DOCUMENTATION_INDEX.md`
- `PIXEL_RPG_AUTHORITY_LOCK.md`
- `PIXEL_RPG_VISUAL_DIRECTION.md`
- `EVOLVE_ALIGNMENT.md`
- `PROJECT_HANDOFF.md`

Use:

`docs/00_project/ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md`

for all other root design/history documents.

## docs/00_authority

Owns:

- explicit current authority barriers;
- repository migration/stale-doc audit;
- rules about what may or may not act as current authority.

Does not own:

- camera code;
- combat mechanics;
- world transforms;
- Android behavior.

Those are proven by source/tests/evidence.

## docs/00_project

Owns:

- project-level navigation;
- authority/read order;
- repository/folder maps;
- documentation classification;
- readiness/evidence status;
- dated snapshots;
- documentation branch status.

Current key files:

- `PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`
- `PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md`
- `PIXEL_RPG_SYSTEM_RELATIONSHIP_AND_FLOW_MAP_2026-09-25.md`
- `ROOT_DOCUMENT_CLASSIFICATION_INDEX_2026-09-25.md`
- `PACKAGE_AUTHORITY_MATRIX_2026-09-25.md`
- `DOCUMENTATION_BRANCH_STATUS_2026-09-25.md`

Historical snapshot files must stay labeled as such.

## docs/10_world

Owns design/package-level world information such as:

- Region 01 contracts;
- settlement packages;
- spatial frameworks;
- streaming/performance design;
- tracking/escape design;
- geometry/manifests.

Important distinction:

Region-01 spatial/graybox documentation remains useful legacy integration provenance.

It must not define current compact-world transforms unless current source explicitly adopts them.

Current compact-world runtime ownership lives in:

`game/scripts/presentation/pixel_rpg/world_*_001.gd`

and associated tests.

## docs/20_gameplay

Owns reusable gameplay design contracts.

Subpackages include:

- combat;
- crafting;
- harvest;
- inventory;
- progression.

Current relationship:

- combat has extensive live deterministic runtime descendants;
- crafting/harvest/inventory are not broad current-world completed runtime systems;
- progression is design/partial depending on exact file.

Before implementation, always check live `game/scripts/gameplay/` and tests.

## docs/30_content

Owns concrete content packages, not generic system laws.

Examples:

- Hunter Base 01;
- Monster 01 / Mudcrest.

Monster 01 content is related to live Mudcrest runtime and presentation.

A content package may specify local values/behavior, but it may not redefine generic combat/state/persistence rules.

## docs/40_art

Current art package has two kinds of records.

### Current runtime-art lineage

Examples:

- Visual Pack 010 image-derived material assets;
- Visual Pack 011 direct concept-photo PNG assets;
- current runtime asset manifests/tests.

### Historical pipeline/reference material

Older asset-pipeline records may contain:

- Drive/reference lanes;
- no-engine-import status;
- pre-runtime approval states;
- historical model pipelines.

Preserve their QA/lineage laws, but do not let old status banners deny current runtime assets.

Art never owns gameplay collision or durable state.

## docs/50_technical

Current important technical authority includes:

- state ownership contract;
- engine/Android build decisions where current;
- prototype decomposition records;
- persistence architecture.

Key distinction:

`docs/50_technical/persistence/PIXEL_RPG_STATE_OWNERSHIP_CONTRACT.md` has an executable current counterpart.

`docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md` is older design/provenance and is not proof of implemented broad save/load.

## docs/60_quality

Owns quality/testing/performance documentation.

It may define:

- protocols;
- test expectations;
- evidence vocabulary;
- acceptance boundaries.

It does not prove a test passed. Actual logs/workflow/device evidence do.

## docs/70_handoff

Historical continuity only.

Use:

`docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md`

before reading individual records.

No handoff is current design authority merely because it was build-verified once.

## game/

This is the production runtime.

Current boot:

`game/project.godot`
→ AppShell
→ first-person Pixel RPG prototype.

Implementation questions should normally be answered here before planning from old documentation.

## game/tests/

These are the current executable Godot regression/integration gates discovered by canonical CI.

Passing headless tests do not prove:

- phone touch ergonomics;
- visual quality;
- heat;
- sustained FPS;
- installed footprint.

## tests/quality/

Static/preflight ownership.

These tests can validate source/data structure and invariants.

They do not replace runtime or device evidence.

## probes/android_stage1

Historical isolated probe.

Useful for:

- early Android/Godot/device evidence;
- input/camera/lifecycle/performance methodology.

Not production gameplay architecture.

## Canonical CI

Current workflow:

`.github/workflows/pixel-rpg-ci.yml`

Audited current runtime baseline:

`7e9f37071a3634dee98db1d1040ecc1c57e13d3a`

Run:

`36082533109` — SUCCESS.

The workflow proves only its exact tested SHA and automated/build gates.

## How to choose an owner

When a change arrives:

1. decide whether it is presentation, gameplay, content, world, technical, quality, or documentation;
2. locate the narrowest current implementation owner;
3. locate its exact tests;
4. use documentation only to understand constraints/rationale;
5. do not move ownership merely because another folder contains a broad design file;
6. if ownership is unclear, record the ambiguity instead of creating duplicate truth.

## Anti-duplication law

Do not create:

- a second combat health truth in HUD;
- a second camera yaw/pitch truth in the host;
- a second Monster anatomy truth in visual nodes;
- a second world transform truth in documentation;
- a second current authority chain in a handoff;
- a second save-state owner for convenience.

One owner, multiple readers/adapters.

## Evidence law

For every claim, state the evidence layer:

- design only;
- source implemented;
- static verified;
- headless/runtime verified;
- Android build verified;
- phone runtime verified;
- visual quality verified;
- performance verified.

Never collapse these layers.
