# Pixel RPG — Root Document Classification Index

Status: CURRENT ROOT-DOCUMENT NAVIGATION / DOCUMENTATION BRANCH  
Created: 2026-09-25

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`  
Documentation branch: `documentation`

## Purpose

The repository root contains documents from several generations of the project: pre-engine Unnamed Hunt design, Stage-1 probe planning, the abandoned Shooter/third-person pivot, and current first-person Pixel RPG authority.

This index prevents an older root document from becoming current authority merely because it has a broad title such as “Bible,” “Master Plan,” “Architecture,” or “Roadmap.”

Current source/tests/evidence always outrank historical documents.

## Classification rules

### A — Current authority / navigation

These are current entry, authority, continuation, or presentation documents on the documentation branch.

They are expected to point to the current repository/branch/issue structure and current first-person Pixel RPG identity.

### B — Reusable architecture/governance law with historical status sections

These documents contain useful cross-system laws that remain compatible, but their original implementation status, engine-selection state, camera assumptions, or next-action sequencing are partly historical.

Use their principles, not stale status fields.

### C — Future-system design provenance

These documents define systems that remain useful as design inputs but are not broad current runtime implementation claims.

They become implementation authority only when a current issue/source/test explicitly adopts them.

### D — Asset/model pipeline provenance

These documents contain useful asset-production, reference, scale, lineage, and technical-validation rules.

Their old aerial/illustrated-realism or “no implementation” status does not override current pixel-styled first-person runtime art.

### E — Superseded presentation/game-identity history

These documents contain aerial, third-person, shooter-pivot, or pre-first-person presentation claims that are no longer current Pixel RPG presentation authority.

Preserve compatible mechanics/architecture ideas only after corroboration.

---

# A — Current authority / navigation

- `README.md`
- `START_HERE_NEW_CHAT.md`
- `NEW_CHAT_CONTINUATION_PROMPT.md`
- `DOCUMENTATION_INDEX.md`
- `PIXEL_RPG_AUTHORITY_LOCK.md`
- `PIXEL_RPG_VISUAL_DIRECTION.md`
- `EVOLVE_ALIGNMENT.md`
- `PROJECT_HANDOFF.md`

## Use

Start here for current continuation and authority.

If these files disagree with newer live production source/tests, the newer verified source/tests win.

---

# B — Reusable architecture/governance law with historical status sections

- `DESIGN_QUALITY_GATES_AND_DEPENDENCY_MATRIX.md`
- `DEVELOPMENT_REFERENCE.md`
- `FIRST_SETTLEMENT_BLUEPRINT.md`
- `IMPLEMENTATION_ROADMAP.md`
- `MAP_WORLD_SETTLEMENT_STRUCTURE.md`
- `PERFORMANCE_BUDGETS_AND_CAPS.md`
- `SYSTEM_ARCHITECTURE_BLUEPRINT.md`
- `TESTING_VERIFICATION_PLAN.md`
- `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`

## Reusable laws

Useful current-compatible principles include:

- one authoritative owner per mutable datum;
- presentation requests/renders rather than invents gameplay truth;
- explicit dependency-impact analysis;
- bounded changes and evidence-specific gates;
- compact connected spaces;
- Android-first performance discipline;
- stable IDs;
- deterministic/reproducible systems where practical;
- save/version migration discipline;
- avoid one giant always-loaded world;
- separate package/build evidence from physical-device evidence.

## Historical fields to ignore unless reconfirmed

Examples:

- Stage-1 engine-selection status;
- aerial/first-person transition assumptions;
- “no source implemented” claims;
- old next-stage sequencing;
- old Region-01 coordinates as current compact-world coordinates;
- old workflow names.

---

# C — Future-system design provenance

- `ADMIN_CREATOR_SYSTEM.md`
- `BEHAVIOR_PATTERN_SYSTEM.md`
- `CODE_GUIDE.md`
- `CONTENT_DATA_GUIDE.md`
- `CRYSTAL_MUTATION_ECOSYSTEM_SYSTEM.md`
- `MECHANICAL_SYSTEMS_GUIDE.md`
- `STATS_ATTRIBUTES_EFFECTS_SYSTEM.md`

## Use

These remain useful for future system design such as:

- debug/admin tools;
- deterministic authored NPC/Monster behavior;
- data-driven content/stable IDs;
- crystal/mutation/ecology;
- shared stat/modifier/effect architecture;
- future modular domain separation.

They are not proof that those systems are currently implemented.

Current source ownership takes precedence over their old planned package/class layouts.

---

# D — Asset/model pipeline provenance

- `MODEL_ART_DIRECTION_AND_ASSET_STANDARD.md`
- `MODEL_CREATION_AND_PNG_REFERENCE_PIPELINE.md`
- `MODEL_REFERENCE_IMAGE_AND_CREATION_PIPELINE.md`
- `VISUAL_REFERENCE_ASSETS.md`

## Use

Preserve useful production laws:

- separate visual intent from technical truth;
- concept/reference images are not automatic technical blueprints;
- exact scale/collision/UV/anatomy data require verified technical sources;
- source/master/derivative/runtime lineage should be explicit;
- generated images must not silently become production texture/collision truth;
- runtime assets require actual engine/device validation.

## Superseded presentation aspects

Do not use old aerial or third-person composition language, grounded illustrated-realism framing, or old selected concept perspective as current camera authority.

Current presentation authority is `PIXEL_RPG_VISUAL_DIRECTION.md` and live first-person source.

---

# E — Superseded presentation/game-identity history

- `GAME_EXPERIENCE_BIBLE.md`
- `NEW_GAME_ARCHITECTURE_VISUAL_BIBLE.md`
- `NEW_GAME_DISCUSSION_CHECKLIST.md`
- `NEW_GAME_MASTER_PLAN.md`
- `VISUAL_WORLD_BEHAVIOR_BIBLE.md`

## Use

These are valuable for historical design rationale and compatible mechanics such as:

- anatomy-focused hunting;
- compact physical spaces;
- deterministic systems;
- persistent consequences;
- world/NPC continuity;
- hunt → harvest → craft loop.

They are **not** current camera or presentation authority.

Superseded examples include:

- aerial exploration as the main camera;
- third-person behind-character exploration;
- shooter-rpg visual authority;
- first-person only as a local encounter mode;
- pre-engine “no implementation” claims.

---

# Current root-document lookup

| Need | Current starting file |
|---|---|
| New session | `START_HERE_NEW_CHAT.md` |
| Continuation prompt | `NEW_CHAT_CONTINUATION_PROMPT.md` |
| Authority barrier | `PIXEL_RPG_AUTHORITY_LOCK.md` |
| Documentation navigation | `DOCUMENTATION_INDEX.md` |
| Current visual/player presentation | `PIXEL_RPG_VISUAL_DIRECTION.md` |
| Current project state/handoff | `PROJECT_HANDOFF.md` |
| Operating law | `EVOLVE_ALIGNMENT.md` |
| Project identity | `README.md` |
| Full repository location map | `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md` |
| Full scan/reference | `docs/00_project/PIXEL_RPG_REPOSITORY_SCAN_MASTER_REFERENCE_2026-09-25.md` |
| Handoff history classification | `docs/70_handoff/HANDOFF_CLASSIFICATION_INDEX_2026-09-25.md` |

## Preservation law

Do not delete old root design documents merely because their presentation is superseded.

Instead:

1. classify the document;
2. add a status/supersession note when its header can mislead current work;
3. preserve useful design rationale;
4. make live source/tests the implementation authority;
5. keep current navigation documents small enough to read first.

## Verification boundary

A design document can define intended behavior.

It cannot prove:

- implementation;
- current source state;
- current build success;
- current phone runtime;
- current visual quality;
- current performance.

Those require the corresponding source/test/build/device evidence.
