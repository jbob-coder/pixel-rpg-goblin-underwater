# Inventory Transfer Example

Status: SUPPORTING EXAMPLE / NOT A SEPARATE OWNER

A harvest transaction recovers 8 units of `material_raker_plate` at `STANDARD` quality.

The harvest owner commits source depletion and creates a `RECOVERY_BUNDLE` holding all 8 units.

Player inventory state:
- one compatible `STANDARD` Raker Plate stack at `96/99`;
- 20/20 material stack entries already occupied.

Inventory transfer result:
- existing compatible stack accepts `3` units;
- destination becomes `99/99`;
- no free stack slot exists;
- `5` units remain in the original recovery bundle;
- result = `PARTIAL_ACCEPT`.

Conservation:

`8 bundle-before = 3 inventory-gain + 5 bundle-after`.

No anatomy capacity is restored, no material is deleted, and retry cannot replay the already committed 3-unit transfer.
