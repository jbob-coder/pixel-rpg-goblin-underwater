# First-Slice Inventory Material Ownership Pass — 2026-09-03

Status: BOUNDED GAMEPLAY-DESIGN PASS COMPLETE / NO INVENTORY IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT`

The game remains the objective. This pass advances the hunt loop from deterministic harvest output into persistent player-owned material state while direct Galaxy A03s Stage-1 evidence remains deferred.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- latest Harvest handoff;
- `FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`;
- `CONTENT_DATA_GUIDE.md`;
- `MECHANICAL_SYSTEMS_GUIDE.md`;
- `GAME_EXPERIENCE_BIBLE.md` and `VISUAL_WORLD_BEHAVIOR_BIBLE.md` for downstream player-facing continuity.

## New authorities

Package front door:
`docs/20_gameplay/inventory/README.md`.

Reusable contract:
`docs/20_gameplay/inventory/FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT.md`.

## Selected first-slice model

Primary material destination:
`PLAYER_FIELD_INVENTORY`.

Prototype targets:
- maximum 20 material stack entries;
- maximum 99 units per material stack;
- stack key = `material_id + quality_band`;
- provenance stored internally as conserved lots.

## Recovery-bundle ownership

Every successful committed harvest extraction first creates/updates exactly one persistent `RECOVERY_BUNDLE` owner before inventory transfer.

Flow:
`HARVEST DEPLETION -> RECOVERY BUNDLE OWNS MATERIAL -> INVENTORY TRANSFER -> ACCEPTED QUANTITY MOVES -> REMAINDER STAYS IN BUNDLE`.

This means full inventory never deletes material and rejection never restores depleted anatomy.

## Quantity conservation

For every committed transfer:
`SOURCE_LOSS == DESTINATION_GAIN`.

Partial acceptance is allowed. Unaccepted quantity remains in the source recovery bundle.

Compatible inventory stacks fill deterministically by stable stack ID before new stacks are created.

## Quality/provenance

Only identical material + quality may merge.

Quality does not average or change to simplify stacking.

Visible stacks may aggregate several internal provenance lots, but lot quantities must sum exactly to stack quantity and preserve Monster/source/harvest lineage.

## Transaction anti-replay

Stable `inventory_transfer_id` makes transfer idempotent.

Reload/UI reopen/repeated callback returns the recorded committed result rather than moving quantity twice.

## Future verification

The contract records 30 future runtime checks covering recovery-bundle creation, quantity conservation, capacity/full-inventory behavior, partial transfer, deterministic merge/split, quality boundaries, provenance, world reload, save/load and transaction anti-replay.

No runtime verification is claimed because production inventory source does not yet exist.

## Verification boundary

`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_RECORDED = YES`
`INVENTORY_RUNTIME_IMPLEMENTED = NO`
`INVENTORY_RUNTIME_VERIFIED = NO`.

Stage-1 phone truth remains unchanged:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next independent game action

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT`

That next pass should select exactly one Monster-01-derived recipe/equipment improvement and define deterministic material consumption, output ownership/equip effect, save/load anti-replay, and the reason the upgrade creates for another hunt.

Do not build a broad recipe tree, market economy or production implementation in the same pass.
