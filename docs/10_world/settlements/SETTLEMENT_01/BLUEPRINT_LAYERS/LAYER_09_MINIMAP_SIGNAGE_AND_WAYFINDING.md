# Layer 09 — Minimap, Signage and Wayfinding

Status: PROVISIONAL WAYFINDING BLUEPRINT

## Goal

A player should understand settlement structure from first-person landmarks without relying entirely on the minimap.

## Minimap geometry

Render five logical section shapes:
- S01 South Gate
- S02 Central Plaza
- S03 West Local
- S04 East Work
- S05 North Hunter Exit

Show:
- main spine
- cross street
- major enterable buildings
- north/south gates
- current player
- objective markers only when relevant

Do not show every decorative prop.

## Landmark hierarchy

### Tier 1 — global settlement
- South Gate silhouette
- Central Plaza
- Community Hall
- Smith
- North Hunter Gate/watch

### Tier 2 — local navigation
- market stalls
- storage/work canopy
- residences
- notice/bounty boards

### Tier 3 — decoration
- benches
- crates
- minor racks
- vegetation

## Signs

Stable sign destinations:
- SOUTH GATE / ARRIVAL
- PLAZA / MARKET
- LOCAL HALL / HOMES
- SMITH / WORK YARD
- HUNTER GATE / TRAIL

In-world text must remain readable and should not depend on AI-generated text baked into source imagery.

## Signpost locations

Recommended:
- S01 inner arrival near Z +19
- S02 plaza south approach
- S02 plaza north approach
- S03/S04 cross-street intersection
- S05 hunter gate inner approach

## First-person sightlines

From South Gate:
- player should see central spine/plaza landmark

From Plaza:
- player should read west local identity
- east smith/work identity
- north hunter-gate direction
- south arrival direction

From North Gate:
- player should clearly read trail departure

## Minimap ownership

Minimap is presentation.

Section IDs/world transforms are authoritative elsewhere.

Minimap may derive:
- player marker
- NPC/service markers
- objective markers

but must not own their gameplay state.

## Discovery

Future optional rule:
- section becomes labeled after first physical entry

Do not require discovery mechanics for initial settlement implementation.
