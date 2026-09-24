# First-Slice Harvest Capacity and Condition Pass — 2026-09-03

Status: BOUNDED GAMEPLAY-DESIGN PASS COMPLETE / NO HARVEST IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT`

The game remains the objective. This pass advances the hunt loop from combat anatomy consequences into finite recoverable materials while direct Galaxy A03s Stage-1 evidence remains deferred.

## Authorities reread

Current repository copies were reread for:
- `EVOLVE_ALIGNMENT.md`;
- current handoff/new-chat/index/front doors;
- `DEFEAT_RETREAT_BASELINE_PASS_2026-09-03.md`;
- `MECHANICAL_SYSTEMS_GUIDE.md`;
- `CONTENT_DATA_GUIDE.md`;
- Monster 01 `ANATOMY_AND_DAMAGE.md`;
- Defeat/Retreat outcome ownership;
- current gameplay/readiness maps.

## New reusable authority

`docs/20_gameplay/harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`.

Local package front door:
`docs/20_gameplay/harvest/README.md`.

Supporting worked example:
`docs/20_gameplay/harvest/HARVEST_TRANSACTION_EXAMPLE.md`.

Selected generic laws:
- finite authored capacity per physical source;
- material-specific capacity units for first slice, not fake final kilograms;
- condition bands determine surviving quantity/quality ceiling;
- clean sever transfers capacity rather than adding matter;
- break/shatter can preserve reduced fragments;
- carcass/detached-part containers use stable source lineage;
- extraction recovery is deterministic and capped at `1.00`;
- partial harvest depletes only recovered quantity;
- no separate harvest RNG;
- escape creates no carcass;
- death creates one carcass state from final anatomy;
- mutual-terminal preserves carcass but does not auto-credit material;
- save/load cannot restore/de-duplicate incorrectly.

Condition targets:
PRISTINE/GOOD/DAMAGED/POOR/RUINED/DESTROYED = `1.00/0.90/0.70/0.40/0.10/0.00` preservation.

## Monster 01 application

Authority:
`docs/30_content/monsters/MONSTER_01/HARVEST_CAPACITY_PACKET.md`.

Prototype pristine capacities:
- left horn 4;
- right horn 4;
- dorsal plates 8;
- torso hide 12;
- distal-tail ridge 5;
- distal-tail tendon 4;
- dense bone 8.

Total selected pristine source capacity:
`45` units.

This is not guaranteed yield. Combat condition and extraction efficiency reduce actual recovered quantity.

The user's core gameplay rule is now explicit in project authority:
**how much usable material the player can recover depends on how the anatomy survived the hunt.**

## Anti-duplication

A clean distal-tail sever transfers the same ridge/tendon source lineages to the detached tail. Later Monster death cannot recreate them on the carcass.

One horn lineage cannot become multiple physical horns or exceed its authored lifetime capacity.

Save/load/region reload cannot regenerate depleted source quantity.

## Future verification

Generic authority records 28 minimum runtime tests.
Monster 01 packet records 16 content-specific tests.

No runtime verification is claimed because harvest/inventory source does not yet exist.

## Repository-write audit

During this pass, an accidental temporary `docs/20_gameplay/harvest/README.pending.md` placeholder was created while switching write paths. It was immediately deleted in the next repository commit before pass closure.

Final-state requirement:
- placeholder must not exist in the live tree;
- final comparison against the pre-harvest baseline must contain only durable harvest/navigation changes.

No force push was used.

## Verification boundary

`FIRST_SLICE_HARVEST_BASELINE_RECORDED = YES`
`MONSTER_01_HARVEST_PACKET_RECORDED = YES`
`HARVEST_RUNTIME_IMPLEMENTED = NO`
`HARVEST_RUNTIME_VERIFIED = NO`.

Stage-1 truth remains:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

Implementation blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next independent non-phone action

`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_CONTRACT`

That next pass must consume committed harvest-transfer results and define authoritative material container/stack/quality/provenance/save-load ownership before one-recipe crafting linkage. Do not bundle broad economy, many recipes or production implementation.