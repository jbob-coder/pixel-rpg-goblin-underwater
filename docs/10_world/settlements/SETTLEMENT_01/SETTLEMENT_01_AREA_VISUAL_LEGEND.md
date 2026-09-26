# Settlement 01 — Canonical A01–A12 Visual Legend

Status: CANONICAL VISUAL-AREA REFERENCE
Last reconciled: 2026-09-26

## Authority

This legend is derived from the live runtime layout contract:

`game/scripts/world/settlement/settlement_01_layout_contract.gd`

For area identity, the stable `SET01_Axx_*` ID, its geometry, and its parent section are authoritative. Colors are not authoritative identifiers.

## Critical rule: areas, sections, and colors are different things

Settlement 01 has:

- **12 visual/design areas:** `A01` through `A12`.
- **5 runtime/streaming sections:** `S01` through `S05`.
- **Optional presentation colors:** visual aids only; they must never redefine an area ID, number, geometry, or section membership.

Do not infer an area number from a color. Do not renumber areas to match section colors. Do not treat the five runtime sections as the twelve visual areas.

`A04` is intentionally special: it is the shared Main Central Spine and has no single parent section.

## Canonical area legend

| Area | Stable ID | Human name | Parent section | Runtime kind | Canonical X/Z bounds |
|---|---|---|---|---|---|
| A01 | `SET01_A01_SOUTH_ARRIVAL_GATE` | South Arrival Gate | S01 | SECTION_AREA | X -14..14, Z 25..34 |
| A02 | `SET01_A02_GATE_BARRACKS_SECURITY` | Gate Barracks & Security | S01 | SECTION_AREA | X -30..-12, Z 14..29 |
| A03 | `SET01_A03_CARAVAN_VISITOR_STAGING` | Caravan / Visitor Staging | S01 | SECTION_AREA | X 12..30, Z 14..29 |
| A04 | `SET01_A04_MAIN_CENTRAL_SPINE` | Main Central Spine | shared / none | SHARED_CONNECTOR | X -4..4, Z -35..33 |
| A05 | `SET01_A05_CENTRAL_MARKET_PLAZA` | Central Market Plaza | S02 | SECTION_AREA | X -14..14, Z -14..14 |
| A06 | `SET01_A06_COMMUNITY_HALL_CIVIC_CORE` | Community Hall / Civic Core | S03 | SECTION_AREA | X -30..-14, Z -6..6 |
| A07 | `SET01_A07_WEST_RESIDENTIAL_CLUSTER` | West Residential Cluster | S03 | SECTION_AREA | X -30..-18, Z -14..-6 AND Z 6..14 |
| A08 | `SET01_A08_EAST_WORK_FRONTAGE` | East Work Frontage | S04 | SECTION_AREA | X 14..20.5, Z -14..14 |
| A09 | `SET01_A09_SMITHY_CRAFT_QUARTER` | Smithy / Craft Quarter | S04 | SECTION_AREA | X 20.5..30, Z -5..5 |
| A10 | `SET01_A10_STORAGE_WORKSHOP_YARD` | Storage / Workshop Yard | S04 | SECTION_AREA | X 20.5..30, Z -14..-6 AND Z 6..14 |
| A11 | `SET01_A11_NORTH_HUNTER_STAGING` | North Hunter Staging | S05 | SECTION_AREA | X -30..30, Z -23..-14 |
| A12 | `SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT` | North Watch Gate / Trail Exit | S05 | SECTION_AREA | X -30..30, Z -36..-23 |

## Canonical section grouping

- **S01 — South arrival:** A01, A02, A03.
- **S02 — Central core:** A05.
- **S03 — West civic/residential:** A06, A07.
- **S04 — East work/craft:** A08, A09, A10.
- **S05 — North hunter/exit:** A11, A12.
- **Shared connector:** A04 crosses the settlement and is not owned by one section.

## Orientation

In the current layout contract:

- South is toward positive Z.
- North is toward negative Z.
- West is negative X.
- East is positive X.

The total active layout spans approximately X `-30..30` and Z `-36..34`.

## Rules for the 12 settlement reference images

Every future area reference image must obey all of the following:

1. One image represents exactly one `Axx` area.
2. The image's identity comes from the stable `SET01_Axx_*` ID, not from its color.
3. Do not show the complete settlement overview when producing an individual area image.
4. Preserve the area's canonical neighbors, orientation, entrances, roads, and footprint relationships.
5. A section color may be used as an overlay or planning aid, but the same image must still be valid if the color is removed.
6. Do not embed generated area numbers as the sole source of identity; keep the authoritative ID in the filename/metadata/documentation.
7. A04 must be treated as the shared central circulation spine, not as a normal colored district.
8. New images must remain consistent with the project's approved pixel-art direction when they are intended as pixel-art visual references.

Recommended filename pattern:

`settlement01_Axx_<short_name>_r001.png`

Examples:

- `settlement01_A01_south_arrival_gate_r001.png`
- `settlement01_A02_gate_barracks_security_r001.png`
- `settlement01_A09_smithy_craft_quarter_r001.png`
- `settlement01_A12_north_watch_gate_trail_exit_r001.png`

## Color policy

There is currently **no canonical A01–A12 color assignment** in the runtime layout contract.

Therefore:

`COLOR != AREA ID`

If a planning palette is introduced later, it must be recorded in a separate legend and must never change the A01–A12 numbering or geometry.

## Previous-image correction rule

Any earlier generated settlement image that conflicts with this document in numbering, area geometry, section grouping, or the one-area-per-image rule is **reference-only / superseded** and must not be promoted into production assets without correction and explicit approval.

This document does not itself approve any generated image for production.
