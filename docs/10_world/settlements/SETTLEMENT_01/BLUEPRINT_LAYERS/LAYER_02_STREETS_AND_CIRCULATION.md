# Layer 02 — Streets and Circulation

Status: PROVISIONAL STREET BLUEPRINT

## Main Hunter Spine

ID:
`SET01_STREET_MAIN`

Center:
- X 0

Width:
- 8 m
- edges X -4..+4

Run:
- south gate at Z +33
- through S01
- through Central Plaza
- north gate at Z -35

Purpose:
- strongest navigation line
- cart/loadout movement
- hunt departure
- long first-person landmark sightline

Keep this corridor visually readable and avoid permanent clutter.

## Central Cross Street

ID:
`SET01_STREET_CROSS`

Center:
- Z 0

Width:
- 5 m
- edges Z -2.5..+2.5

Run:
- X -20..+20 m
- connects the west/east frontage lanes through the plaza
- deliberately stops before the Community Hall and smith building footprints

Purpose:
- direct local/work connection
- plaza crossroads

## West Residential Frontage Lane

ID:
`SET01_LANE_WEST`

Center:
- X -16.25

Width:
- 4.5 m

Run:
- Z -13..+13

Purpose:
- Community Hall/residence frontage
- local pedestrian movement
- creates about 2 m clearance between the lane edge and Community Hall frontage

## East Work Frontage Lane

ID:
`SET01_LANE_EAST`

Center:
- X +16.25

Width:
- 4.5 m

Run:
- Z -13..+13

Purpose:
- smith/storage/work frontage
- cart/material circulation
- creates about 2.5–2.7 m clearance to the current planned work-building front edges

## Rear service alleys

West:
- center X -28.5
- target width 2.5 m

East:
- center X +28.5
- target width 2.5 m

Use:
- deliveries
- firewood/ore/material handling
- low-priority NPC circulation
- maintenance access

These alleys may be discontinuous around buildings.

## Plaza circulation

Core plaza:
- 28 × 24 m

Keep clear:
- Main Spine X -4..+4
- Cross Street Z -2.5..+2.5

This creates a central plus-shaped clear circulation corridor.

Market/bench props live outside the clear cross.

## Movement rules

- No critical doorway may open directly into the 8 m spine without frontage clearance.
- No market stall may block the central cross.
- No decorative prop may reduce an 8 m connector below 6 m usable width.
- No 5 m connector should drop below 3.5 m usable width.
- Service alleys are not required to support full cart turning.

## Surface language

S01:
- compacted arrival dirt/stone mix

S02:
- strongest hard-packed/stone identity

S03:
- softer local lane / compacted earth + edge stones

S04:
- heavier work-worn dirt/stone, material scuffs

S05:
- packed hunter route transitioning into trail

Art changes must not alter collision authority without an explicit collision change.


## Geometric conflict check

The parcel/street geometry was checked against the provisional building rectangles.

Result after correction:
- no planned building overlaps the 8 m Main Hunter Spine;
- no planned building-to-building footprint overlaps were found;
- the Central Cross Street terminates at X ±20 m so it does not cut through Community Hall or Smith;
- west frontage lane edge is approximately X -18.5 m, leaving about 2 m to Community Hall east wall;
- east frontage lane edge is approximately X +18.5 m, leaving about 2.7 m to Smith west wall.

These are documentation geometry checks only, not physics/runtime verification.
