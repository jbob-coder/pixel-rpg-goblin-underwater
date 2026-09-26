# Model Sheet — A01 Gatehouse West

Status: MODEL_SHEET_READY  
Asset ID: `SET01_A01_GATEHOUSE_W`  
Building ID: `SET01_BLD_SOUTH_GATEHOUSE_W`

## Dimensions

World footprint:
- 8.0 m X
- 7.0 m Z

Wall height:
- target 3.4–3.8 m

Roof ridge:
- target 5.2–5.8 m

Primary doorway:
- clear width 1.8 m
- clear height 2.4 m

Primary facade:
- inward/east-northeast side toward arrival court.

## Modular pieces

Required:
- foundation/base
- wall solid A
- wall window
- wall doorway left
- wall doorway right
- corner post
- roof half L
- roof half R
- ridge
- door
- small awning/canopy optional
- sign bracket
- window frame

## Interior

Single compact room:
- guard/admin work zone
- visitor conversation zone
- wall storage
- clear path from door to center

No hallway maze.

## Anchors

- EntranceAnchor
- ExitAnchor
- ArrivalGuardWorkAnchor
- VisitorConversationAnchor
- GateControlAnchor
- NoticeAnchor
- GuardIdleAnchor
- RoofVisibilityGroup

## Collision

Segmented:
- four wall sides split around doorway/windows where needed
- floor
- simple desk/storage boxes only if they affect movement

No monolithic sealed box collider.

## Art groups

- stone/base
- timber frame
- infill/wall
- roof
- dark metal hardware
- optional banner/sign accent

## Reuse targets

May reuse/adapt:
- Pack 010 stone/wood/roof/metal materials
- lantern_post_01
- banner_post_01
- service_clutter_01

## First-person test

From arrival road:
- usable doorway clearly visible;
- gatehouse does not visually close the 8 m gate;
- roof silhouette does not dominate beyond planned scale.

## Graybox readiness

`READY`
