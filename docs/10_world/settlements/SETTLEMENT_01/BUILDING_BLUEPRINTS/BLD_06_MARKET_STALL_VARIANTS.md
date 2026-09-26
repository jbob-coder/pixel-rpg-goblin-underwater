# BLD-06 — Market Stall Variant Family

Status: PROVISIONAL REUSABLE PROP/BUILDING BLUEPRINT  
Section: `SET01_S02`

Family ID:
`SET01_MARKET_STALL_A`

## Base footprint

Target:
- 4×3 m

Primary open side:
- faces plaza/circulation

No enclosed interior required.

## Fixed sockets

Planned:
- SW (-11,+8.5)
- SE (+11,+8.5)
- NW (-11,-8.5)
- NE (+11,-8.5)

## Variant roles

A:
- general goods / produce

B:
- food/basic supply

C:
- civic/local rotating vendor

D:
- hunter/material/equipment display

All variants should share:
- footprint
- support-post collision contract
- vendor anchor
- customer anchor
- display sockets

## Anchors

- VendorAnchor
- CustomerAnchor
- DisplaySocket_01..04
- SignSocket
- LanternSocket optional

## Collision

Minimal:
- support posts
- substantial counter if necessary

No full stall-volume collider.

## Visual variation

Allowed:
- canopy color/material
- sign
- hanging goods
- counter arrangement
- display props

Do not create four completely unique heavy scenes if variants can share structure.

## Plaza law

Stall props must remain outside:
- Main Hunter Spine
- Central Cross Street

No stall may reduce clear plaza cross widths.

## Tests

- footprint/socket positions
- no main/cross street intrusion
- anchors exist
- variant contract compatibility
