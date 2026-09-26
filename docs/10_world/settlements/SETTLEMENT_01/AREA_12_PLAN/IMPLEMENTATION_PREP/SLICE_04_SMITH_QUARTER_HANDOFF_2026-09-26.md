# Settlement 01 — Runtime Slice 04 Handoff

Status: READY AFTER SLICE 03 VERIFICATION / SMITH QUARTER ADAPTATION  
Created: 2026-09-26

## Objective

Adapt/migrate the existing proven enterable smith into the locked Area 09 parcel while preserving its working doorway, interior, collision ownership and anchors.

This is the first slice that intentionally reuses an existing important runtime building inside the future Settlement 01 coordinate plan.

## Dependency

Required:
- Slice 01 section data verified;
- Slice 02 Main Spine scaffold verified;
- Slice 03 Plaza/cross scaffold verified.

## Area identity

Area:
`SET01_A09_SMITHY_CRAFT_QUARTER`

Parent:
`SET01_S04`

Frame:
- X `+20.5..+30`
- Z `-5..+5`

Smith center:
- `(+24.5, 0)`

Smith footprint:
- `6.6×6.4 m`

Locked bounds:
- X `+21.2..+27.8`
- Z `-3.2..+3.2`

Primary entrance:
- WEST-facing toward Area 08 / East Frontage Lane.

## Existing runtime source to preserve

Primary reference:
`game/scripts/presentation/pixel_rpg/world_pack_004_enterable_smith.gd`

Preserve:
- real doorway;
- segmented wall collision;
- interior floor;
- EntranceAnchor;
- UseAnchor;
- split roof handling;
- current first-person interior compatibility.

Do not rewrite the smith from scratch merely to change settlement coordinates.

## Allowed runtime work

- instance/reposition the smith through an explicit migration/placement owner;
- add/update stable settlement building ID;
- map current anchors to Settlement 01 IDs;
- add Area 09 frontage graybox/support anchors;
- add simple exterior craft placeholder props if they are non-authoritative presentation;
- focused tests.

## Forbidden

- duplicating the smith as two authoritative buildings;
- changing crafting/economy state ownership;
- adding final crafting implementation;
- sealing the doorway;
- replacing segmented collision with one box;
- changing camera/input;
- moving Area 08/10 parcels;
- enabling streaming in this slice.

## Anchor mapping

Required settlement-facing aliases/records:
- `A09_SmithEntrance`
- `A09_SmithServiceAnchor`
- `A09_SmithWorkAnchor`
- `A09_CustomerAnchor`
- `A09_ForgeAnchor`
- `A09_EquipmentDisplayAnchor`

Existing runtime anchors may be wrapped/adapted rather than renamed destructively if compatibility requires it.

## Frontage clearance

Keep west entrance/service approach clear.

No Area 09 prop/collision may block:
- doorway;
- Area 08 frontage approach;
- connector to Area 10.

## Required tests

1. exactly one authoritative smith instance/owner.
2. smith center/parcel matches locked placement.
3. footprint remains 6.6×6.4 m.
4. west doorway path is open.
5. adjacent wall segments block.
6. monolithic SmithCollision remains absent.
7. EntranceAnchor exists.
8. UseAnchor/service mapping exists.
9. Area 09 building ID/section ID are stable.
10. Area 08 approach remains clear.
11. Area 10 connector relation remains valid.
12. current first-person interior/roof behavior remains green.
13. existing smith regression remains green.
14. no crafting/economy authority introduced.

## Visual binding

Current creator-review target:
`AREA_09_SMITHY_CRAFT_QUARTER_F002_LOCKED.png`

Use only for:
- exterior work-apron composition;
- tool/anvil/rack silhouette;
- craft identity.

Do not infer:
- damage/fire gameplay;
- exact prop collision;
- recipe/service state.

## Completion evidence

Slice 04 completes when:
- smith exists in locked settlement parcel through explicit placement/migration;
- doorway/interior/collision tests pass;
- no duplicate smith owner exists;
- first-person regressions pass;
- canonical CI/build evidence recorded.

## Next slice

Slice 05 — West local district:
- Community Hall graybox;
- W01/W02 residence grayboxes;
- West Frontage Lane.

Do not begin Slice 05 before Slice 04 is verified.
