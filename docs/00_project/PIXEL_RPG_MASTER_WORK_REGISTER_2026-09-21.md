> **CURRENT STATUS NOTE — 2026-09-25**
>
> This file is retained as a historical work-register snapshot from the pre-migration / early current-world phase. Its branch name, issue numbering, “current” handoff references, and some presentation-state claims are superseded by live `jbob-coder/pixel-rpg-goblin-underwater@main`, current GitHub issue #20, and the current repository scan/navigation documents.
>
> Do not use this file as the present master work register. Preserve it for provenance, dependency history, and earlier design/verification rationale. For current location/ownership use `docs/00_project/PIXEL_RPG_REPOSITORY_WHERE_IS_WHAT_MAP_2026-09-25.md`; for current operating context use `START_HERE_NEW_CHAT.md`, `DOCUMENTATION_INDEX.md`, and live source/tests/issues.

# Pixel RPG — Master Work Register

Status: ACTIVE WORK AUTHORITY / FOUNDATION + FIVE-SECTION SETTLEMENT + CURRENT-WORLD COMBAT
Date: 2026-09-21
Branch: `pixel-rpg`

## 1. Evidence boundary

This register distinguishes live repository state from build-verified state.

- Active branch confirmed: `pixel-rpg`.
- Live branch HEAD observed before this documentation-only register pass:
  `06f9c7b68f3bf98fe9266636d2b34c0f145b36df`.
- Observed HEAD message:
  `Update Pixel RPG documentation index after combat bridge 001`.
- Last Android-build-verified source recorded by current `PROJECT_HANDOFF.md`:
  `977d4004625631d077856b5a49246fbf08313b64`.
- Verified workflow: `35566594002`.
- Verified job: `106229556552`.
- Godot used by verified build: `4.7.2.stable`.
- `game/project.godot` declares project name `Pixel RPG`, main scene
  `res://scenes/app_shell.tscn`, feature compatibility `4.7`, and GL Compatibility renderer.

APK evidence must never be treated as proof of a source SHA by itself. Source → workflow → job → artifact digest must remain traceable.

## 2. Verified baseline already completed

Current handoff records the following as integrated and Android-build verified:

- Pack 001 world composition.
- Pack 002 hunter/Mudcrest readability and anatomy-node mapping.
- Pack 003 Settings/minimap HUD alignment.
- Pack 004 enterable smith with real doorway/interior/collision/roof handling.
- Combat Bridge 001 Observe → Engage → current-world third-person target acquisition.
- Eight selected body-part target groups mapped to live Mudcrest visual nodes.
- Target highlight/lock and post-Engage locomotion lock.
- Android debug export and package-size gate.

Do not reopen these as unfinished without new contradictory runtime evidence.

## 3. Current immediate continuation

Current handoff NEXT_ACTION:
`PIXEL_RPG_COMBAT_BRIDGE_002_DOMAIN_BOOTSTRAP_NO_ATTACK`.

Boundary:
- preserve third-person camera and Bridge 001 targeting;
- keep gameplay-domain source unchanged where possible;
- expose explicit START COMBAT DOMAIN after target lock;
- initialize current CombatTurnShellRuntime + MudcrestAnatomyRuntime only;
- keep transforms unchanged;
- expose initialized turn/resources/anatomy;
- no legacy tactical movement;
- no hunter attack runtime;
- no AP/Stamina spend;
- no damage;
- dedicated runtime gate before Android export.

## 4. Priority system

- **P0** — authority/foundation blockers. Broad expansion waits on these.
- **P1** — required architecture/world/runtime work.
- **P2** — later systems/content or explicitly deferred work.

## 5. Canonical GitHub issue register

### P0 — foundation

- #5 — Freeze Pixel RPG source/build authority and BuildIdentity.
- #6 — Decompose `PixelRPGPrototype001` God-script responsibilities safely.
- #7 — Define authoritative runtime/state ownership contract.
- #8 — Combat Bridge 002: current-world domain bootstrap without attack.
- #9 — Establish geometry/collision ownership rules.

### P1 — required architecture/world/runtime

- #10 — Create SectionDefinition / SectionInstance contract for streamed world.
- #11 — Rebuild settlement as five logical sections.
- #12 — Implement conservative section streaming manager.
- #13 — Formalize reusable building blueprint standard.
- #14 — Add local NPC building and NPC anchor/schedule foundation.
- #15 — Decouple interactions from direct HUD writes.
- #16 — Separate player movement, touch input and camera controllers.
- #17 — Current-world persistence/save-load foundation.
- #23 — Expand tests around ownership, sections, interactions and regressions.
- #24 — Target-device runtime, sustained performance and installed-footprint evidence.

### P2 — later/deferred

- #18 — Persist Settings safely.
- #19 — Inventory/material UI and ownership integration — **DEFERRED BAG**.
- #20 — Smith service/crafting gameplay integration.
- #21 — Audio foundation for current Pixel RPG.
- #22 — Lighting/environment readability standard.
- #26 — Design current-world tactical movement graph instead of offsetting legacy Region-01.

#25 is an accidental duplicate of #24 and is closed as duplicate.

Master tracking issue: #27.

## 6. Execution order

Recommended dependency order:

1. #5 — source/build authority.
2. #7 — state ownership.
3. #6 — mechanical decomposition with behavior parity.
4. #9 — collision/geometry ownership.
5. #8 — Combat Bridge 002 within no-attack boundary.
6. #10 — section data/instance contract.
7. #11 — settlement 5-section relayout.
8. #12 — conservative streaming.
9. #13 + #14 — reusable buildings and local NPC building/anchors.
10. #15 + #16 — interaction and controller boundaries.
11. #17 — current-world save/load.
12. #23 + #24 — regression and target-device proof.
13. P2 work only after prerequisites are green.

This ordering is not a prohibition on small isolated fixes; it prevents architecture/content work from outrunning its ownership and verification contracts.

## 7. Five-section settlement authority

World should feel open while actually loading logical sections.

Settlement topology:

- **S01 — South Gate / Arrival**
  - settlement entrance;
  - gate warden;
  - entry signage/banners;
  - clean seam to exterior approach.

- **S02 — Central Plaza / Market**
  - orientation landmark;
  - market/services;
  - social traffic hub;
  - connection point to every district.

- **S03 — West Residential / Local NPC**
  - local community hall/lodge;
  - residences;
  - resident/social anchors;
  - future abstract schedules for unloaded sections.

- **S04 — East Work District**
  - verified enterable smith;
  - storage/service buildings;
  - work props;
  - future crafting/service integration.

- **S05 — North Hunter Exit**
  - transition toward monster trail;
  - hunter/scout/watchpost use;
  - natural streaming seam to wilderness.

Exact transforms/bounds are not frozen until derived against the live scene. Conceptual topology is approved; arbitrary relocation without live-coordinate audit is not.

## 8. Section-loading standard

Target model:

- current section loaded;
- directly adjacent sections loaded;
- probable next section may preload;
- distant non-neighbors unload after safe delay;
- no unsafe unload of current interaction/combat target;
- hide transitions using paths, turns, trees, walls, gate structures, elevation and view management;
- unloaded NPCs use abstract state, not full expensive simulation.

Streaming begins only after #10 establishes stable section IDs, bounds, connectors and lifecycle contracts.

## 9. Reusable building standard

Important building contract must include:

- stable building ID/type;
- footprint and height;
- entrance connector(s);
- real doorway opening;
- usable interior floor;
- modular collision profile;
- interior camera/roof behavior;
- interaction anchors;
- NPC anchors;
- prop sockets;
- section placement connector;
- save/state hooks if gameplay-relevant.

Initial reusable families:
- gatehouse;
- market stall;
- residence;
- local community hall;
- smith;
- utility/storage;
- watchpost;
- work canopy.

Critical rule:
**Important buildings may not be fake facades or one solid collision block.**

## 10. Pixel-world visual standard

The game is pixel-styled real 3D.

Required:
- strong silhouettes;
- controlled palette;
- hard readable geometry;
- nearest/crisp treatment where appropriate;
- mobile-readable forms;
- modular low-cost assets;
- visual hierarchy through landmarks.

Avoid:
- Minecraft-like all-cube identity;
- Pixel Gun toy/shooter-arena identity;
- realistic glossy PBR drift;
- noisy high-frequency detail that breaks mobile readability.

## 11. Ownership standards

### Durable state
Must live in dedicated gameplay/world state owners, not UI nodes.

### Combat
Deterministic turn/anatomy domain is authoritative for combat data.

### Input/camera
Transient runtime state; never saved as durable gameplay state.

### Presentation
HUD/visuals display state and send intents; they must not silently become game-state authority.

### Geometry/collision
Reusable important buildings should own bounded building collision. World composition owns terrain/roads/section infrastructure, not duplicate interior collision.

### Interactions
Use an interaction boundary/event contract instead of gameplay writing directly into HUD controls.

## 12. Persistence standard

Current-world persistence is not considered complete until #17 is implemented against #7 ownership.

Required characteristics:
- versioned schema;
- stable IDs;
- migration strategy;
- bounded corruption fallback;
- player/world/section state;
- no persistence of transient touch/camera/HUD state;
- no implicit import of abandoned-project saves.

## 13. Known risks / bugs to prevent

1. **God-script growth**
   - risk: prototype owns too many domains;
   - mitigation: #6 and #16.

2. **Presentation becomes state authority**
   - risk: HUD/runtime variables silently become canonical;
   - mitigation: #7 and #15.

3. **Collision duplication**
   - risk: building-owned and compositor-owned collision overlap;
   - mitigation: #9.

4. **Section seam popping**
   - risk: open-world illusion breaks;
   - mitigation: #10/#12 plus view-aware seams.

5. **NPC crossing unloaded boundaries**
   - risk: stuck/teleporting actors;
   - mitigation: local ownership + abstract off-section state.

6. **Legacy tactical coordinate contamination**
   - risk: old Region-01 spatial graph is offset blindly into compact current world;
   - mitigation: #26 explicit redesign/adapter.

7. **Untraceable APK**
   - risk: working APK cannot be linked to source;
   - mitigation: #5 BuildIdentity.

8. **Save schema coupled to transient UI**
   - risk: brittle saves and migration failures;
   - mitigation: #7 before #17.

9. **Visual drift**
   - risk: assets become Minecraft-like, Pixel Gun-like or glossy realism;
   - mitigation: visual standard + #22.

10. **Phone-only regressions**
    - risk: CI passes while touch/camera/performance fails on device;
    - mitigation: #24.

## 14. Verification policy

For every implementation slice:

1. fetch/freeze current branch HEAD;
2. identify exact owning files;
3. define rollback boundary;
4. implement the smallest bounded change;
5. parse/import;
6. run focused runtime gate;
7. run preserved regression gates;
8. Android export only if game/workflow files changed;
9. record workflow/job/artifact evidence;
10. keep documentation HEAD distinct from last build-verified source;
11. do not claim phone/performance/visual acceptance without device evidence.

A prepared patch is not implemented.
A committed change is not runtime verified.
A successful Android export is not phone acceptance.

## 15. Bob delegation protocol

Bob is used aggressively for parallel evidence and bounded implementation work, but output must be held to the same proof standard.

Every Bob task must include:
- exact objective;
- exact branch/ref if known;
- read-only vs write permission;
- bounded files/systems;
- required evidence;
- acceptance criteria;
- explicit UNKNOWN for unverified claims;
- diff/commit/test identifiers for implementation;
- no claim of application if only a patch was prepared.

Weak or ambiguous results are returned for correction rather than promoted to authority.

## 16. Abandoned-project firewall

Non-authoritative unless the current Pixel RPG repository explicitly imports a bounded reusable element:
- Monster Choice RPG;
- WorldLife RPG;
- Shooter RPG.

Do not revive their UI, coordinates, save assumptions or presentation architecture as current truth.

## 17. Cost/tooling constraint

Prefer local/free tooling and existing repository/Drive infrastructure. Do not introduce paid runtime services or tools that create billing without explicit user approval.

## 18. Deferred items

- Bag/inventory button remains deferred (#19).
- full smith economy/crafting remains later (#20).
- tactical movement/attack integration waits for current-world spatial design (#26).
- final phone camera feel, sustained performance and installed footprint require #24 evidence.
