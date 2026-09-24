# First-Slice One-Recipe Craft / Equip Linkage Pass — 2026-09-03

Status: BOUNDED GAMEPLAY-DESIGN PASS COMPLETE / NO CRAFTING IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT`

The game remains the objective. This pass advances the first hunt loop from conserved Monster 01 materials into one concrete equipment refinement while the Galaxy A03s phone gate remains deferred.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- `PROJECT_HANDOFF.md`;
- `START_HERE_NEW_CHAT.md`;
- `DOCUMENTATION_INDEX.md`;
- latest Inventory handoff;
- Inventory material ownership contract;
- Harvest capacity/condition owner;
- Monster 01 harvest packet;
- Field Poleblade contract;
- Stamina contract;
- player progression/equipment system;
- Settlement 01 blueprint;
- current build-readiness state.

## New package

Front door:
`docs/20_gameplay/crafting/README.md`.

Authority:
`docs/20_gameplay/crafting/FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_CONTRACT.md`.

## Selected recipe

`recipe_field_poleblade_raker_tendon_grip`

Requirements:
- 2 x `material_m01_tail_tendon` at HIGH;
- 2 x `material_m01_hide` at STANDARD or better;
- compatible Field Poleblade;
- logical `CRAFT_STATION_WEAPON_WORKBENCH` context.

No currency, random craft-quality roll or broad recipe tree is added.

## Output/effect

Refinement:
`refinement_field_poleblade_raker_tendon_grip`.

Effect:
`effect_field_poleblade_raker_tendon_grip_placed_hew_stamina`.

Typed operation:
`COST_MODIFIER`, flat `-2 Stamina` to `POLEBLADE_PLACED_HEW`.

Existing prototype cost:
`18 -> 16` with only this refinement.

The refinement does not change AP, raw damage, selected-part legality, hit-quality ceiling, sever thresholds, Initiative, reactions, Guard or Max Stamina.

## Why this closes the first progression proof

The material requirement directly rewards the existing anatomy/harvest loop:
- preserve the distal tail;
- recover HIGH-quality tendon;
- preserve usable hide;
- transfer material into authoritative inventory;
- consume exact inventory lots;
- apply a bounded Poleblade handling refinement;
- use the refinement on the next hunt.

This proves progression without an item-level treadmill or random loot shower.

## Craft transaction law

Inputs are selected deterministically from `PLAYER_FIELD_INVENTORY`.

Before consumption the domain reserves exact stack/provenance-lot quantities and validates:
- recipe;
- workbench/service context;
- compatible weapon;
- empty grip-refinement state;
- exact material/quality availability;
- fresh transaction ID/version.

Successful commit is atomic:
`CONSUME 2 TENDON + 2 HIDE <-> APPLY ONE REFINEMENT`.

No legal saved state may expose only one side of that commit.

Stable craft transaction IDs make duplicate UI/callback/save-load submissions idempotent.

## Future verification

The contract records 30 minimum implementation checks covering:
- material/quality eligibility;
- deterministic stack/provenance selection;
- reservation staleness;
- exact consumption;
- output uniqueness;
- atomic interruption recovery;
- save/load anti-replay;
- effect calculation 18 -> 16;
- non-effects on AP/damage/other techniques.

No runtime PASS is claimed.

## Saved visual concept artifact

The finished-game visual concept generated during the user-directed visual pass was saved to the connected Google Drive project folder `Unnamed Hunt RPG`.

Drive file name:
`Unnamed Hunt RPG - Finished Game Visual Concept 2026-09-03.png`.

Drive file ID:
`1JSCDYW8A1JvW9Xht535uvcnRFbru44_U`.

This image is a visual-intent/reference artifact only. It does not override repository mechanics, dimensions, collision, performance or stable IDs.

## Verification boundary

`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_RECORDED = YES`
`CRAFTING_RUNTIME_IMPLEMENTED = NO`
`CRAFTING_RUNTIME_VERIFIED = NO`.

Phone truth remains:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next independent non-phone action

`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_CONTRACT`

That pass should map the logical weapon-workbench requirement into the existing walkable Settlement 01 Smith/Workshop and Hunter Service Loop, including return-from-hunt interaction ownership, without adding broad shops/economy/NPC systems.