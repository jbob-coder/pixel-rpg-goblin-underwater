# MONSTER_01 — First-Slice Harvest Capacity Packet

Status: SELECTED FIRST-SLICE CONTENT TARGETS / NO HARVEST IMPLEMENTATION
Last reconciled: 2026-09-03

Species: `species_r01_mudcrest_raker`
Technical package: `MONSTER_01`

## Purpose

Apply the generic harvest-capacity contract to the Mudcrest Raker so combat anatomy damage produces concrete finite material quantities rather than a generic loot table.

Generic owner:
`/docs/20_gameplay/harvest/FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`.

This packet owns Monster 01 prototype source/material IDs and capacity targets. It does not redefine generic harvest math, combat damage, recipes, inventory or economy.

## Capacity-unit rule

All capacities below are **prototype harvest units**, not kilograms. Final physical mass remains open.

A unit represents one recipe/inventory quantity of that material source. Later mass calibration may assign weight without changing finite-capacity/depletion rules.

## First-slice material set

- `material_m01_horn` — dense mineralized horn/crest material;
- `material_m01_dorsal_plate` — mineralized dorsal armor material;
- `material_m01_hide` — heavy treated hide source;
- `material_m01_tail_ridge` — dense distal-tail ridge material;
- `material_m01_tail_tendon` — strong distal-tail tendon/fiber source;
- `material_m01_dense_bone` — dense structural bone source from limbs/carcass.

This is deliberately small. Meat, organs, fluids and Crystal-core harvesting remain outside the first slice unless a later gameplay consumer requires them.

## Prototype source capacities

| Harvest source ID | Physical source | Material | Type | Original capacity |
|---|---|---|---|---:|
| `harvest_m01_horn_l` | `HORN_L` | `material_m01_horn` | continuous units on one unique lineage | 4 |
| `harvest_m01_horn_r` | `HORN_R` | `material_m01_horn` | continuous units on one unique lineage | 4 |
| `harvest_m01_dorsal_plate_group` | `DORSAL_PLATE_GROUP` | `material_m01_dorsal_plate` | continuous units | 8 |
| `harvest_m01_torso_hide` | torso/major hide surface | `material_m01_hide` | continuous units | 12 |
| `harvest_m01_tail_ridge` | `TAIL_DISTAL` ridge | `material_m01_tail_ridge` | continuous units | 5 |
| `harvest_m01_tail_tendon` | `TAIL_DISTAL` musculotendon | `material_m01_tail_tendon` | continuous units | 4 |
| `harvest_m01_dense_bone` | four major limbs + carcass structural access | `material_m01_dense_bone` | continuous units | 8 |

Prototype total authored capacity across all selected first-slice sources: `45` material units.

This number is not guaranteed yield. Final source condition and extraction efficiency reduce it.

## Horn source condition mapping

Each horn has an independent stable source lineage.

Suggested final condition mapping:
- intact/minor superficial damage -> `PRISTINE` or `GOOD`;
- clean structural break leaving substantial horn body -> `DAMAGED`;
- heavy shatter/pulverization -> `POOR`;
- near-total destructive loss -> `RUINED`/`DESTROYED`.

Important:
- breaking a horn does not create a second horn;
- detached horn fragments transfer the same lineage/capacity;
- one horn's 4 original units can never produce more than 4 total recovered units across all containers/extractions.

## Dorsal plate mapping

The group has `8` original plate-material units.

Guidance:
- intact plates at death -> high preservation;
- cracked/opened plates -> `GOOD`/`DAMAGED` depending destructive extent;
- blunt shattering -> `DAMAGED`/`POOR`;
- fragments may remain recoverable but quality drops;
- exposed hide under a broken plate does not generate additional plate capacity.

Plate visual fragments and harvest units are not required to map one-to-one.

## Hide mapping

Torso hide source has `12` original units.

Guidance:
- normal combat wounds usually reduce local quality/capacity rather than deleting the entire source;
- repeated cutting through the same hide region can move the aggregate source from `GOOD` toward `DAMAGED/POOR`;
- severe crushing alone does not automatically erase hide but can lower quality if tissue contamination/damage is physically relevant;
- no generic global quality penalty from one small wound.

First implementation should eventually split local damage contributions enough that one horn hit cannot degrade torso hide.

## Distal-tail sever mapping

`TAIL_DISTAL` owns two harvest sources:
- ridge: 5 units;
- tendon: 4 units.

A legal clean sever:
- transfers both source lineages to the detached tail container;
- preserves current condition and remaining capacity;
- removes those exact lineages from the attached carcass;
- does not duplicate ridge/tendon material when the Monster later dies.

Clean sever target:
- ridge condition ceiling `PRISTINE/GOOD` depending prior damage;
- tendon condition ceiling `PRISTINE/GOOD` depending prior damage.

Destructive crushing before sever can lower either source independently.

## Dense bone mapping

Dense-bone source has `8` original units across the selected major structural-bone source group.

The first slice does not require limb severing.

Bone can be recovered from a dead carcass through legal processing. Severe shattering may reduce usable unit capacity/quality; ordinary leg impairment does not automatically destroy all bone material.

## Example yields

### Example A — clean hunt

Suppose:
- left horn PRISTINE: 4;
- right horn GOOD: floor(4 x .90) = 3;
- dorsal plates GOOD: floor(8 x .90) = 7;
- hide GOOD: floor(12 x .90) = 10;
- distal tail cleanly severed PRISTINE ridge/tendon: 5 + 4;
- dense bone GOOD: floor(8 x .90) = 7.

Surviving capacity = `40` units before extraction efficiency.

If a legal extraction uses efficiency `0.90`, recovered total cannot exceed floor/request-bounded extraction from those 40 surviving units and each source depletes independently.

### Example B — destructive horn/plate hunt

Suppose:
- each horn POOR: floor(4 x .40) = 1 + 1;
- dorsal plates POOR: floor(8 x .40) = 3;
- hide GOOD: 10;
- tail remains attached GOOD: ridge 4, tendon 3;
- bone DAMAGED: floor(8 x .70) = 5.

Surviving capacity = `27` units before extraction efficiency.

The player may have won the fight faster but destroyed 13 potential material units compared with the clean example before tool/skill recovery is considered.

This is the intended core loop consequence.

## Harvest timing/outcome links

- `MONSTER_DEAD` -> carcass sources are created from final attached anatomy plus existing detached-lineage references;
- `MONSTER_ESCAPED` -> no carcass; accessible detached tail/horn sources remain where world rules preserve them;
- `MUTUAL_TERMINAL` -> carcass exists physically but materials are not auto-credited;
- `HUNTERS_WITHDREW` / `HUNTERS_DEFEATED` -> no automatic material award.

## Knowledge/tool targets

Prototype harvest packet assumes later tools/knowledge can affect recovery efficiency, not original capacity.

Useful future categories:
- cutting/field-dressing tool for hide/tendon;
- saw/chisel/heavy processing tool for horn/plate/bone;
- Monster 01 harvest knowledge for identifying source condition and preferred method.

Exact tool IDs are deferred to the inventory/equipment/crafting lane.

## Save/load invariants

Persist:
- each source lineage;
- original/surviving/remaining capacity;
- attached/detached container ownership;
- quality;
- extracted total.

Never:
- regenerate tail materials after sever;
- reset harvested horn capacity after region reload;
- create both attached and detached copies of one source;
- produce more than 45 total selected source units from one pristine Monster 01 instance before preservation/extraction losses.

## Future content tests

1. pristine Monster 01 selected-source authored capacity totals 45;
2. each horn source caps at 4 lifetime units;
3. dorsal plate source caps at 8;
4. hide source caps at 12;
5. tail ridge caps at 5;
6. tail tendon caps at 4;
7. dense bone caps at 8;
8. tail sever transfers both tail sources without duplication;
9. tail sources do not respawn on later carcass creation;
10. horn break condition lowers capacity according to generic band mapping;
11. plate shatter lowers capacity/quality but does not affect hide globally;
12. Monster escape creates no carcass;
13. death creates one carcass and preserves detached lineage links;
14. repeated harvest depletes exact source quantities;
15. total recovered from every selected source never exceeds its surviving capacity;
16. same final anatomy state produces same source capacities.

No runtime verification is claimed.