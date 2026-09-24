# First-Slice Persistence / Save-Reload Contract

Status: SELECTED FIRST-SLICE PROTOTYPE DESIGN / NO PERSISTENCE IMPLEMENTATION
Last reconciled: 2026-09-03

Technical owner: `docs/50_technical/persistence/`

## Purpose

Define the smallest authoritative save/reload boundary needed to preserve the complete first-slice loop across Settlement 01, Region 01, Monster 01, tactical combat, harvest, Inventory, one crafting transaction and the physical Smith service.

Primary law:

**A save captures authoritative domain state at a stable boundary. Reload restores that committed state directly; it never replays presentation callbacks or already-committed gameplay transactions to recreate it.**

This contract owns:
- first-slice save envelope/schema identity;
- one prototype save-slot boundary;
- persistence-safe snapshot timing;
- active-encounter save policy;
- minimum player/world/Monster/encounter/harvest/Inventory/crafting/Settlement state;
- stable sequence/transaction continuity;
- atomic write/read-validation requirements;
- session/presentation reconstruction after load;
- first-slice duplicate/replay prevention;
- future persistence tests.

It does not own:
- broad migration history;
- cloud synchronization;
- multiple player profiles;
- final autosave UX/frequency;
- platform-specific file APIs before final engine selection;
- broad corruption-repair tooling;
- Stage-14 save-system hardening;
- exact world coordinates/dimensions;
- production implementation.

Supporting authorities:
- `/SYSTEM_ARCHITECTURE_BLUEPRINT.md`;
- `/WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- `/docs/20_gameplay/combat/INITIATIVE_AND_TURN_ORDER_PROTOTYPE_CONTRACT.md`;
- `/docs/20_gameplay/combat/DEFEAT_RETREAT_BASELINE_CONTRACT.md`;
- `/docs/10_world/regions/REGION_01/TRACKING_AND_ESCAPE.md`;
- `/docs/30_content/monsters/MONSTER_01/ANATOMY_AND_DAMAGE.md`;
- `/docs/30_content/monsters/MONSTER_01/CRYSTAL_AND_MUTATION.md`;
- `/docs/30_content/monsters/MONSTER_01/BEHAVIOR_AND_REGION.md`;
- `/docs/20_gameplay/harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`;
- `/docs/20_gameplay/inventory/FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT.md`;
- `/docs/20_gameplay/crafting/FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT.md`;
- `/docs/10_world/settlements/SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.

---

# 1. First-slice save identity

Selected prototype save-envelope identity:

`save_schema_id = UHR_SAVE_SCHEMA_1`

`schema_version = 1`

Selected first-slice player slot:

`save_slot_id = save_slot_01`

The first vertical slice needs one authoritative player slot, not a full profile/save-slot management product.

A committed snapshot also stores:
- monotonically increasing `save_generation`;
- unique `snapshot_id`;
- authoritative `domain_sequence_id` watermark;
- content/schema compatibility marker;
- snapshot checkpoint kind;
- non-authoritative human-readable save timestamp metadata if desired.

Wall-clock timestamp must never decide gameplay legality, Initiative, harvest yield, transaction identity or Monster behavior.

---

# 2. Snapshot model

The first slice uses a **state snapshot**, not event sourcing.

Persist authoritative mutable state and the terminal transaction/sequence records needed to prevent replay.

Do not persist giant copies of immutable content definitions such as complete species/recipe/status definitions. Persist their stable IDs plus mutable instance state.

Domain events may be saved only where needed for debugging/continuation metadata; they are not replayed as the primary way to rebuild already committed state.

---

# 3. Persistence-safe boundary

Selected rule:

`SNAPSHOT_COMMIT_REQUIRES_PERSISTENCE_SAFE_POINT`

A save may be requested at any time, including mobile lifecycle/suspend pressure, but a new snapshot commits only when no authoritative resolver/transaction is in an ambiguous partial-mutation state.

Valid first-slice safe-point categories:
- `WORLD_DECISION_POINT` — exploration/settlement state stable after the previous world action/transition;
- `COMBAT_DECISION_POINT` — current activation/reaction state is stable and awaiting a domain command;
- `POST_COMBAT_OUTCOME` — terminal encounter outcome fully committed and world handoff state stable;
- `HARVEST_DECISION_POINT` — no extraction transaction is mid-commit;
- `INVENTORY_DECISION_POINT` — no transfer transaction is mid-commit;
- `SMITH_DECISION_POINT` — Smith overlay may be open/closed, but no Craft mutation is mid-commit;
- `POST_TRANSACTION_COMMIT` — a harvest/inventory/craft transaction has reached a terminal recorded result.

An in-flight resolver cannot serialize half of its state mutation as a valid new save.

If the application is terminated before a requested snapshot reaches a safe committed write, the previous fully committed snapshot remains authoritative.

---

# 4. Presentation is never a save boundary

Presentation state is disposable.

Do not persist as authoritative truth:
- animation frame;
- current particle lifetime;
- transient hit flash;
- camera interpolation percentage;
- Smith panel animation;
- floating damage text;
- duplicated button/callback state;
- temporary render-node existence.

If the domain already committed an action/craft/transfer and animation is still playing, save/reload restores the committed domain result and reconstructs presentation from it.

If the domain has not committed, animation/UI cannot cause the save to pretend that it did.

---

# 5. Player/Hunter state

Persist the minimum durable Hunter state required to resume the loop:
- stable player Hunter instance ID;
- current Health and other persistent actor resources;
- current Stamina;
- persistent statuses/injuries with exact owner-defined state;
- current party composition/companion instance references where applicable;
- current equipment/loadout instance IDs;
- Field Poleblade instance ID;
- active refinement IDs, including `refinement_field_poleblade_raker_tendon_grip` if present;
- progression/knowledge state required by first-slice interactions;
- current spatial context and position fields from section 6.

Do not persist derived final action costs such as Placed Hew `16` as an independent mutable value. Reload recomputes it from the base technique plus saved equipment/refinement through the shared effect pipeline.

---

# 6. Spatial position interface

The persistence interface stores position without preempting the next coordinate-authority pass.

Minimum fields:
- `spatial_context_id` — e.g. Settlement 01, transition corridor, Region 01 or active encounter source context;
- `sector_or_local_area_id` where applicable;
- `position_m = [x, y, z]` in the project meter convention;
- orientation/heading in a deterministic serialized representation;
- stable nearby transition/entry/escape/service anchor ID where needed for continuity/validation;
- source/destination transition state only if an authoritative area transition is already committed.

`WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md` establishes preferred `1 world unit = 1 meter`.

The next bounded spatial contract owns:
- axis convention;
- major-area origins;
- Settlement 01 bounds and service coordinates;
- hunter-gate/transition coordinates;
- Region 01 sector bounds/centers/anchors;
- encounter-footprint coordinates.

Persistence must consume that future authority, not invent competing coordinates.

---

# 7. World / Region 01 state

Persist first-slice world state needed for hunt continuity:
- current major area/context;
- current Region 01 sector when applicable;
- player discovery/field-camp flags required by the slice;
- active hunt ID/state;
- persistent Monster 01 instance reference;
- bounded tracking/evidence record references that survive by Region rules;
- legal selected Monster route intent/handoff state;
- persistent detached-part/recovery-bundle world references;
- area-transition checkpoint state if a transition had authoritatively committed.

Streaming/render residency is not saved as gameplay truth. On reload, presentation/streaming determines what sectors/assets to load from the authoritative spatial/world state.

---

# 8. Monster 01 state

The same Monster instance must survive save/reload.

Persist at least:
- stable Monster instance ID;
- species/content definition ID;
- current spatial context/Region sector and route intent;
- current behavior/activity state required for deterministic continuation;
- relevant behavior memory/cooldown/sequence state;
- anatomy part-state map including horn/plate/leg/tail damage;
- attachment/sever state and detached-part IDs;
- current capabilities when they are stored, or enough source state to recompute them deterministically;
- persistent statuses/injuries;
- Crystal Core current Energy;
- Core Strain;
- Berserk active flag;
- Berserk episode-used flag;
- critical/exhausted state where applicable;
- emitted evidence references required for reacquisition;
- alive/dead/terminal state;
- encounter/hunt handoff state.

Reload may never:
- repair broken horns;
- regrow a severed distal tail;
- restore damaged legs/plates;
- refill Core Energy because a scene reloaded;
- reset Core Strain;
- clear Berserk episode-used;
- spawn a fresh uninjured replacement after escape.

---

# 9. Active encounter save policy

Selected first-slice policy:

`ACTIVE_ENCOUNTER_SAVE = ALLOWED_AT_STABLE_COMBAT_DECISION_POINTS`

This supports mobile lifecycle resilience without serializing an action halfway through authoritative mutation.

Persist when combat is active:
- encounter ID;
- source world/Region/footprint context;
- participant IDs and participation states;
- exact tactical positions/nodes/bearings needed by combat;
- participant current Health/Stamina/AP/RP and persistent status state;
- `round_id`;
- InitiativeSnapshots;
- current RoundRoster order;
- every slot state (`PENDING/ACTED/SKIPPED_INELIGIBLE/REMOVED`);
- current acting combatant;
- whether that normal activation has started;
- late entrants + `first_eligible_round`;
- current explicit reaction window/telegraph decision state when that state is stable and awaiting player/behavior input;
- action/encounter sequence counters;
- terminal/outcome state if already committed.

Reload laws:
- do not rebuild the current round from scratch;
- do not reroll Initiative/ties;
- do not rerun turn-start status transitions;
- do not rerun passive Stamina recovery;
- do not refresh AP/RP again if the activation already started;
- do not recreate consumed slots;
- do not reopen resolved reaction windows;
- do not grant another activation because presentation restarted.

---

# 10. Encounter outcome / retreat persistence

Persist:
- `encounter_terminal`;
- committed encounter outcome if any;
- hunt state;
- player/companion participation states;
- `party_retreat_intent`;
- already withdrawn actors;
- current escape/route context;
- Monster route/sector intent;
- sequence ID that committed the terminal outcome.

Reload may not:
- revive a Downed Hunter inside the same encounter;
- reopen a terminal encounter;
- rerun a withdrawal AP cost;
- recreate a withdrawn actor's slot;
- reroll terminal outcome;
- replay zero-Core death;
- create a second carcass.

---

# 11. Harvest / carcass / detached-part state

Persist every first-slice harvest owner needed to conserve matter:
- Monster/death/carcass IDs;
- harvest-container IDs;
- harvest source instance + lineage IDs;
- original/surviving/remaining/extracted capacities;
- condition and quality bands;
- attached/detached ownership;
- depletion/terminal flags;
- extraction transaction IDs/results;
- world references for detached pieces/carcass where applicable.

Reload may not:
- reroll source condition;
- restore depleted capacity;
- duplicate a clean-sever lineage between carcass and detached part;
- replay a committed extraction;
- create a second carcass for the same Monster death.

---

# 12. Recovery bundle / Inventory state

Persist:
- every material container ID/type/owner;
- Inventory stack IDs;
- material IDs;
- quality bands;
- exact quantities;
- provenance lots/lot quantities;
- non-empty recovery bundles and world/container references;
- transfer ledger IDs/results;
- last mutation transaction IDs;
- Inventory capacity/version data required by the first slice.

Reload must preserve:
`SOURCE_LOSS == DESTINATION_GAIN`
for every committed transfer.

It may not:
- recreate an emptied Recovery Bundle;
- delete an unaccepted bundle remainder;
- duplicate a committed transfer;
- restore source quantity after destination gain;
- merge incompatible quality bands;
- erase provenance quantity.

---

# 13. Crafting / equipment transaction state

Persist:
- craft transaction ledger/results;
- recipe ID;
- target Field Poleblade instance ID;
- consumed source stack/provenance references;
- refinement ID on the target weapon;
- effect source identity/reference;
- post-commit Inventory version/quantities.

For `recipe_field_poleblade_raker_tendon_grip`, reload must preserve the exact committed result:
- 2 HIGH tail-tendon units remain consumed;
- 2 STANDARD-or-better hide units remain consumed;
- exactly one Raker-Tendon Grip refinement remains on the target weapon;
- the effect pipeline derives Placed Hew 18 -> 16 once.

Reload may not refund ingredients, consume them again, duplicate the refinement or register the same effect twice.

---

# 14. Settlement 01 Smith state

Persist only settlement state that is actual domain/world truth:
- current Settlement 01 state relevant to service availability;
- Smith workbench service enabled/disabled reason when non-default;
- player position/context near the service if saved there;
- transaction/refinement state through their actual owners.

Do not persist the Smith overlay as an authoritative open modal.

Selected first-slice reload presentation:
`SMITH_OVERLAY_RELOAD_STATE = CLOSED`

The player returns to the authoritative saved settlement position and may interact with the physical workbench again.

Re-entry cannot replay a prior craft.

---

# 15. Deterministic sequence continuity

Save every monotonically advancing sequence/ID allocator state required to avoid post-load ID reuse.

At minimum where used:
- domain event/action sequence watermark;
- encounter action/activation sequence;
- harvest transaction sequence;
- Inventory transfer sequence;
- craft transaction sequence;
- evidence/harvest-container/bundle creation sequence where IDs derive from local counters;
- deterministic RNG stream state/seed only for systems that actually use approved seeded variation.

No new transaction may receive an ID that collides with a previously committed transaction after reload.

---

# 16. Write transaction

Engine-neutral required semantic sequence:

```text
SAVE REQUEST
-> WAIT/ADVANCE TO PERSISTENCE SAFE POINT
-> BUILD IMMUTABLE AUTHORITATIVE SNAPSHOT
-> VALIDATE SNAPSHOT INVARIANTS
-> SERIALIZE TO TEMPORARY/NEW GENERATION
-> COMPLETE WRITE
-> VALIDATE WRITTEN GENERATION WHEN PRACTICAL
-> ATOMICALLY/PREDICTABLY PROMOTE NEW GENERATION
-> UPDATE SLOT POINTER/METADATA
-> ONLY THEN MARK SAVE SUCCESS
```

Exact file API/fsync/rename behavior is engine/platform implementation work.

Hard law:
**a partially written new generation never invalidates the last fully committed generation.**

---

# 17. Load validation

Before a snapshot becomes active state, validate at least:
- `save_schema_id` + schema version;
- required stable content/instance IDs;
- finite/bounded numeric values;
- valid major-area/spatial-context references;
- no duplicate player/Monster unique instance IDs;
- one current owner for each unique detached harvest lineage;
- harvest remaining/extracted capacity invariants;
- Inventory stack quantity/capacity and provenance-sum invariants;
- Recovery Bundle uniqueness;
- transaction ledger terminal-result consistency;
- crafted refinement/consumed-material consistency;
- encounter roster uniqueness/slot states;
- current actor/round/activation consistency;
- Monster death/escape/hunt-state consistency;
- sequence watermarks not below already persisted transaction IDs.

If validation fails, do not invent missing Monster parts, materials, equipment or progression to make the save look plausible.

First-slice fallback may load the previous fully committed valid generation if one exists. Broader repair/migration belongs to Stage 14.

---

# 18. Reconstruction order after load

Recommended authoritative reconstruction order:

```text
READ + VALIDATE SAVE ENVELOPE
-> RESOLVE STATIC CONTENT DEFINITIONS BY STABLE ID
-> RESTORE PLAYER/PARTY + INVENTORY/EQUIPMENT STATE
-> RESTORE WORLD/SETTLEMENT/REGION STATE
-> RESTORE MONSTER + ANATOMY/CRYSTAL/BEHAVIOR STATE
-> RESTORE HARVEST/DETACHED/BUNDLE OWNERS
-> RESTORE ACTIVE HUNT/ENCOUNTER/SCHEDULER IF PRESENT
-> RESTORE TRANSACTION/SEQUENCE LEDGERS
-> RECOMPUTE DERIVED STATS/EFFECTS
-> LOAD/STREAM REQUIRED PRESENTATION AREA
-> REBUILD UI/CAMERA/ANIMATION FROM AUTHORITATIVE STATE
-> ACCEPT PLAYER INPUT ONLY AFTER DOMAIN STATE IS READY
```

Presentation never runs gameplay transactions during reconstruction.

---

# 19. Derived versus persisted state

Persist source truth; recompute safely derived values.

Examples to recompute:
- Field Poleblade final Placed-Hew Stamina cost from base + refinement/effects;
- anatomy-derived capability flags when they are pure functions of persisted part state;
- current UI labels;
- render visibility/LOD;
- normal camera interpolation;
- route/debug overlays.

Examples that must be persisted because recomputation could replay history or change outcomes:
- transaction terminal results;
- InitiativeSnapshots/current RoundRoster consumed slots;
- Monster anatomy part condition;
- Core Energy/Strain/Berserk episode-used;
- harvest depletion;
- Inventory provenance lots;
- craft refinement ownership;
- terminal encounter outcome.

---

# 20. Save-point UX boundary

This contract defines correctness, not final UX.

First-slice UI may expose one Save/Continue surface and may request lifecycle checkpoints.

UI receives explicit save state:
- `SAVE_REQUESTED`;
- `WAITING_FOR_SAFE_POINT`;
- `WRITING`;
- `COMMITTED`;
- `FAILED`.

UI may not display success before the new generation is authoritative.

Opening menus does not itself mutate gameplay or refresh combat resources.

---

# 21. Trace requirements

Development persistence trace should include:
- save slot ID;
- schema/version;
- generation/snapshot ID;
- safe-point kind;
- domain sequence watermark;
- major area/spatial context;
- active hunt/encounter IDs;
- Monster instance/sector/anatomy/Core/Berserk summary;
- encounter round/current actor/slot summary;
- carcass/detached/source/bundle counts;
- Inventory stack/provenance totals;
- latest harvest/transfer/craft transaction IDs;
- equipped/refinement IDs;
- validation PASS/FAIL reasons;
- load reconstruction phase;
- previous-generation fallback reason if used.

Trace is developer evidence, not player-facing authority.

---

# 22. First-slice save invariants

1. one saved Monster ID never reloads as two active Monster instances;
2. one severed tail lineage never reloads attached and detached simultaneously;
3. one committed harvest extraction never becomes spendable twice;
4. one committed Inventory transfer never increases total conserved material on reload;
5. one committed Craft transaction never consumes or applies twice;
6. one combat actor never gains a second activation because reload reran turn-start hooks;
7. one terminal encounter never reopens after reload;
8. presentation/UI/animation cannot become the source of domain recovery;
9. failed/incomplete new save generation cannot destroy the last committed snapshot;
10. same valid snapshot + same content definitions reconstruct the same authoritative mutable state.

---

# 23. Explicitly deferred

Not selected here:
- cloud save/sync;
- cross-device conflict resolution;
- many player profiles/slots;
- final autosave cadence;
- manual quicksave abuse rules beyond safe-point correctness;
- complete schema migration history;
- encryption/anti-cheat;
- large rolling backup history;
- advanced journal repair;
- save compression;
- final serialization format;
- platform-specific Android filesystem API;
- broad replay system;
- production telemetry/privacy policy;
- final Hunter-defeat recovery penalties.

---

# 24. Required future implementation tests

Before persistence can be runtime verified, test at least:
1. schema ID/version validate;
2. save generation increments monotonically;
3. incomplete new write leaves prior committed generation loadable;
4. save request during domain mutation waits for a safe point;
5. save during presentation after domain commit restores committed domain state;
6. load closes transient Smith overlay;
7. Settlement position/workbench context restores without replaying interaction;
8. player Hunter instance/loadout restores;
9. Field Poleblade instance ID restores;
10. Raker-Tendon Grip refinement restores exactly once;
11. Placed Hew derives 16 from saved refinement without persisted ad-hoc final cost;
12. same Monster instance ID restores in Region 01;
13. broken horn remains broken;
14. severed tail remains severed;
15. detached tail ID/source lineage restores once;
16. Core Energy restores exactly;
17. Core Strain restores exactly;
18. Berserk episode-used does not reset;
19. Monster route/sector intent restores;
20. evidence references do not duplicate;
21. active encounter round ID restores;
22. InitiativeSnapshots restore without reroll;
23. consumed RoundRoster slots stay consumed;
24. mid-activation reload does not rerun passive Stamina recovery/AP/RP refresh;
25. stable reaction decision state can restore without reopening resolved reactions;
26. terminal encounter remains terminal;
27. withdrawn actor remains withdrawn;
28. zero-Core Monster does not replay death/carcass creation;
29. one dead Monster restores one carcass state;
30. harvest remaining/extracted capacity restores exactly;
31. committed extraction cannot replay;
32. Recovery Bundle remainder restores exactly once;
33. emptied bundle does not respawn;
34. Inventory material quantities restore exactly;
35. provenance lot sums equal stack quantities after load;
36. committed Inventory transfer cannot replay;
37. craft inputs remain consumed after committed craft reload;
38. craft transaction cannot replay after double-submit/reload;
39. no effect source duplicate appears after load;
40. sequence counters advance beyond all persisted transaction IDs;
41. invalid duplicate unique lineage rejects validation;
42. invalid duplicate Monster instance rejects validation;
43. invalid Inventory quantity/provenance mismatch rejects validation;
44. previous valid generation can be selected after current-generation validation failure;
45. streaming/LOD/UI reconstruction does not mutate domain state;
46. save/load in Settlement 01 resumes correct major-area context;
47. save/load in Region 01 resumes correct sector/context;
48. active-hunt escape/reacquisition state survives load;
49. snapshot position is serialized in meter-based spatial interface without unit conversion drift;
50. repeated load of the same valid snapshot produces the same authoritative state checksum/normalized comparison.

These are future implementation/integration tests. This document itself is design-recorded only.

---

# 25. Acceptance

This design pass is complete when:
- [x] schema-1 save identity selected;
- [x] one first-slice slot selected;
- [x] safe-point policy selected;
- [x] active-encounter policy selected;
- [x] player/world/Monster state boundary selected;
- [x] harvest/Inventory/crafting continuity selected;
- [x] Smith service re-entry selected;
- [x] transaction/sequence anti-replay selected;
- [x] atomic generation semantics selected;
- [x] load validation selected;
- [x] presentation reconstruction boundary selected;
- [x] future implementation tests recorded;
- [x] exact world coordinates kept for the next spatial owner;
- [x] Stage-14 hardening kept outside scope.

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_RECORDED = YES`
`PERSISTENCE_RUNTIME_IMPLEMENTED = NO`
`PERSISTENCE_RUNTIME_VERIFIED = NO`.