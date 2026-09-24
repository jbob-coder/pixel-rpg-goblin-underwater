# First-Slice Settlement Smith Service Interaction Pass — 2026-09-03

Status: BOUNDED GAMEPLAY/WORLD-DESIGN PASS COMPLETE / NO SETTLEMENT SERVICE IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT`

The game remains the objective. This pass connects the already-recorded one-recipe crafting proof to a real physical Settlement 01 Smith/Workshop interaction while direct Galaxy A03s evidence remains deferred.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- `FIRST_SETTLEMENT_BLUEPRINT.md`;
- `docs/10_world/README.md`;
- `GAME_EXPERIENCE_BIBLE.md`;
- `SYSTEM_ARCHITECTURE_BLUEPRINT.md`;
- one-recipe crafting contract;
- Inventory/Progression/Field Poleblade/Stamina authorities;
- current readiness/handoff/index state.

## New world package

Settlement package map:
`docs/10_world/settlements/README.md`.

Settlement 01 local front door:
`docs/10_world/settlements/SETTLEMENT_01/README.md`.

New authority:
`docs/10_world/settlements/SETTLEMENT_01/FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT.md`.

## Selected service model

Settlement:
`SETTLEMENT_01`.

Service:
`service_settlement01_smith_weapon_workbench`.

Interaction anchor:
`interact_settlement01_smith_weapon_workbench`.

Capability:
`CRAFT_STATION_WEAPON_WORKBENCH`.

Placement:
Smith/Workshop in the Craft/Processing Quarter on the Hunter Service Loop, intentionally close to the Hunter Gate/processing route.

Return-path graybox target:
`Hunter Gate return threshold -> Smith workbench <= 25 seconds normal walking`.

This target is design-recorded only and must be measured in the future settlement graybox.

## Service availability

The essential first-slice weapon workbench remains available in normal Settlement 01 state.

A specific Smith NPC does not own the crafting capability. NPC schedules may change presentation/dialogue but cannot silently lock the required progression loop.

Future emergency/story/facility-damage service states may disable it only through explicit SettlementState reasons.

## Interaction/data ownership

Settlement/world interaction owns:
- physical workbench anchor;
- proximity/context eligibility;
- settlement service availability.

Crafting owns:
- recipe legality;
- exact material selection/consumption;
- atomic craft transaction;
- transaction anti-replay.

Inventory owns:
- quantities/qualities/provenance.

Equipment/progression owns:
- target Poleblade instance/refinement state/modifier effect.

Presentation/UI:
- requests;
- previews;
- displays result.

UI/NPC/Settlement code may not directly consume material or write the refinement.

## One-recipe service scope

Exposes only:
`recipe_field_poleblade_raker_tendon_grip`.

Input truth remains:
- 2 HIGH `material_m01_tail_tendon`;
- 2 STANDARD-or-better `material_m01_hide`.

Output remains:
`refinement_field_poleblade_raker_tendon_grip`.

Effect remains:
Placed Hew Stamina `18 -> 16` through typed equipment `COST_MODIFIER` only.

## Interaction flow

`APPROACH PHYSICAL WORKBENCH -> USE WEAPON WORKBENCH -> OPEN READ-ONLY PREVIEW -> SELECT/VERIFY FIELD POLEBLADE -> CONFIRM DOMAIN CRAFT REQUEST -> AUTHORITATIVE RESULT -> PRESENTATION FEEDBACK -> CLOSE -> SAME SETTLEMENT LOCATION`.

Preview/open/close consumes nothing.

Confirm revalidates service, weapon and Inventory state.

Crafting remains atomic/idempotent.

## Save/re-entry

First-slice overlay is transient and reopens closed after load.

Save before Confirm leaves all material/refinement untouched.

Save after authoritative commit but before animation completion reloads the already-consumed/already-refined authoritative result exactly once.

Re-entering the service cannot replay a previous craft transaction.

## Future verification

New contract records 36 future graybox/runtime checks, including:
- proximity/service availability;
- no NPC-schedule lockout;
- preview/cancel no mutation;
- stable weapon-instance selection;
- no direct recovery-bundle crafting;
- exact material consumption/refinement once;
- anti-double-tap/reload replay;
- <=25-second return-route measurement;
- mobile interaction readability;
- no UI/NPC/Settlement direct inventory/equipment mutation.

No runtime verification is claimed.

## Verification boundary

`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_RECORDED = YES`
`SETTLEMENT_SMITH_RUNTIME_IMPLEMENTED = NO`
`SETTLEMENT_SMITH_RUNTIME_VERIFIED = NO`.

Phone truth remains:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Next-action selection rule

After this pass is reconciled into the readiness/front-door state, reread the remaining vertical-slice blockers and select the smallest dependency that closes more of the actual playable loop. Do not expand broad content breadth.
