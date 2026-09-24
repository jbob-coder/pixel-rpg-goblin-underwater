# First-Slice Persistence Save/Reload Pass — 2026-09-03

Status: BOUNDED TECHNICAL/GAME-CONTINUITY DESIGN PASS COMPLETE / NO PERSISTENCE IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT`

The game remains the objective. This pass closes the minimum save/reload continuity required by the already-recorded first-slice hunt loop while the Galaxy A03s phone gate remains deferred.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- latest Smith-service handoff;
- `docs/README.md` + `docs/50_technical/README.md` placement rules;
- `SYSTEM_ARCHITECTURE_BLUEPRINT.md`;
- `WORLD_SCALE_STREAMING_TRANSITION_GUIDE.md`;
- Initiative/Turn Order and Defeat/Retreat persistence requirements;
- Region 01 tracking/escape continuity;
- Monster 01 anatomy/Crystal/behavior state;
- Harvest, Inventory and Crafting transaction persistence requirements;
- Settlement 01 Smith service save/re-entry rules.

## New persistence package

Front door:
`docs/50_technical/persistence/README.md`.

Authority:
`docs/50_technical/persistence/FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_CONTRACT.md`.

## Selected save model

- schema identity `UHR_SAVE_SCHEMA_1`;
- `schema_version = 1`;
- first-slice slot `save_slot_01`;
- monotonically increasing committed save generation;
- state-snapshot model, not event sourcing;
- static content remains definitions referenced by stable IDs;
- transaction/sequence ledgers persist only as needed to prevent replay and ID reuse.

## Safe-point law

A save request may occur at any time, including lifecycle/suspend pressure.

A new snapshot commits only at a persistence-safe domain boundary:
- stable world decision point;
- stable combat decision/reaction point;
- post-outcome;
- harvest/inventory/Smith decision point;
- terminal transaction result.

No half-mutated resolver/transaction state becomes a valid snapshot.

If the app dies before the new generation commits, the previous committed generation remains authoritative.

## Active combat policy

`ACTIVE_ENCOUNTER_SAVE = ALLOWED_AT_STABLE_COMBAT_DECISION_POINTS`.

Persist exact:
- encounter/round IDs;
- InitiativeSnapshots;
- RoundRoster order/slot states;
- current actor/activation-start state;
- participant resources/status/positions;
- late-entry timing;
- stable reaction/telegraph decision state when awaiting input;
- action/sequence counters.

Reload does not reroll Initiative, rerun turn-start hooks, duplicate Stamina recovery/AP/RP refresh, recreate consumed slots or reopen resolved reactions.

## Persistent game-state chain

The snapshot preserves:
- player Hunter/loadout/equipment/refinement;
- world/spatial context + meter-based position interface;
- active hunt/Region 01 sector/evidence/route state;
- same Monster 01 instance/anatomy/Crystal/Strain/Berserk/status/behavior state;
- encounter outcome/withdrawal state;
- carcass/detached harvest lineage and capacity/depletion;
- Recovery Bundles;
- Inventory stacks/quality/provenance/transfer ledgers;
- Craft transaction ledger and Raker-Tendon Grip ownership;
- Settlement 01 Smith service state required for re-entry;
- monotonically advancing transaction/ID sequence state.

## Presentation boundary

Presentation is disposable.

Animation frame, camera interpolation, particles, Smith-panel animation and callback state are not authoritative save truth.

The Smith overlay reopens closed after reload. If Craft already committed, the consumed materials/refinement remain committed exactly once regardless of unfinished presentation.

## Write/load semantics

Required engine-neutral write flow:
`request -> safe point -> immutable snapshot -> validate -> write new/temp generation -> validate -> promote -> mark success`.

A partial new write may not invalidate the previous committed generation.

Load validates schema/IDs/numeric bounds, Monster uniqueness, harvest lineage ownership, Inventory/provenance sums, transaction consistency, refinement/material consistency, scheduler uniqueness and sequence watermarks before activating state.

Broad migration/repair remains Stage-14 work.

## Spatial interface and user's dimension/coordinate direction

Persistence stores:
- spatial context ID;
- sector/local-area ID;
- position `[x,y,z]` in meters;
- orientation;
- stable nearby transition/service/escape anchor references where needed.

Current world authority already says preferred `1 world unit = 1 meter`.

Exact axes/origins/Settlement bounds/Region sector coordinates/encounter coordinates are intentionally not invented here.

The user's new direction to begin building/documenting game dimensions and coordinates is therefore selected as the exact next bounded world-design pass:
`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT`.

## Future verification

The contract records 50 future persistence/integration checks spanning atomic generations, safe-point behavior, active combat scheduler continuity, Monster anatomy/Core/Berserk continuity, harvest/Inventory/crafting anti-replay, Smith re-entry, sequence IDs, position units and deterministic reconstruction.

No runtime verification is claimed.

## Verification boundary

`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_RECORDED = YES`
`PERSISTENCE_RUNTIME_IMPLEMENTED = NO`
`PERSISTENCE_RUNTIME_VERIFIED = NO`.

Phone truth remains:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next bounded action

`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_CONTRACT`

It must establish a documented meter-based coordinate convention and a coherent prototype spatial layout for Settlement 01, Hunter Gate/transition, Region 01 sectors and first combat-footprint anchors using current world scale/topology authorities. It must distinguish prototype coordinates from production-final measurements and keep performance/graybox validation open.