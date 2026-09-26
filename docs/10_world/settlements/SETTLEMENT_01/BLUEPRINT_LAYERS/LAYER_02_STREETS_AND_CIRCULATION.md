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
- west residential frontage to east work frontage

Purpose:
- direct local/work connection
- plaza crossroads

## West Residential Frontage Lane

ID:
`SET01_LANE_WEST`

Center:
- X -17.5

Width:
- 4.5 m

Run:
- Z -13..+13

Purpose:
- Community Hall/residence frontage
- local pedestrian movement
- separates buildings from central plaza boundary

## East Work Frontage Lane

ID:
`SET01_LANE_EAST`

Center:
- X +17.5

Width:
- 4.5 m

Run:
- Z -13..+13

Purpose:
- smith/storage/work frontage
- cart/material circulation

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
