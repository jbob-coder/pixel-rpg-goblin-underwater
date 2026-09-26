# Model Sheet — A02 Barracks / Duty Building

Status: MODEL_SHEET_READY  
Asset ID: `SET01_A02_BARRACKS_DUTY`

## Target dimensions

Footprint:
- 7×6 m (locked to master Arrival Guard/Barracks parcel)

Wall height:
- about 3.2–3.6 m

Door:
- 1.6–1.8 m clear width
- 2.3–2.4 m height

## Interior

Single duty room with:
- duty desk;
- equipment/storage wall;
- guard rest/briefing nook;
- clear center path.

## Modules

- foundation
- solid wall
- window wall
- door wall pair
- corner posts
- roof halves
- ridge
- door
- simple duty sign bracket

## Anchors

- EntranceAnchor
- ExitAnchor
- GuardDutyAnchor
- PatrolStartAnchor
- EquipmentStorageAnchor
- GuardIdleAnchor
- InteriorCenterAnchor

## Collision

Segmented building collision.
No sealed-box fake doorway.

## Visual relationship

Use settlement timber/stone language.
More utilitarian than Community Hall.
Less imposing than gatehouse/watch.

## Graybox readiness

`READY`


## Parcel authority

Fixed world parcel:
- center X -20 / Z +23
- footprint 7×6 m
- bounds X -23.5..-16.5 / Z +20..+26

This supersedes the earlier approximate 8×6 m note. Final references and runtime graybox must use the 7×6 m locked parcel.
