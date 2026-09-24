# Harvest Transaction Example

Status: SUPPORTING EXAMPLE / NOT A SEPARATE RULE OWNER

This file exists only to make the first-slice capacity contract easier to inspect.

Example source:
- source: `harvest_m01_dorsal_plate_group`;
- original capacity: 8;
- final condition: DAMAGED;
- preservation multiplier: 0.70;
- surviving capacity: floor(8 x 0.70) = 5;
- remaining before extraction: 5;
- requested amount: 4;
- legal tool/skill recovery efficiency: 0.90;
- recovered: floor(4 x 0.90) = 3;
- remaining after extraction: 2.

The source can never later yield more than the remaining 2 units. Reopening UI, reloading the region or reloading the save does not restore the 3 already extracted units.

Owning authority:
`FIRST_SLICE_HARVEST_CAPACITY_AND_CONDITION_CONTRACT.md`.