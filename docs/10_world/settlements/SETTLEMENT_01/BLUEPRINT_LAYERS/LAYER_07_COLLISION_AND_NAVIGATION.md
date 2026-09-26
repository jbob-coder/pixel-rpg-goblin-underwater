# Layer 07 — Collision and Navigation

Status: PROVISIONAL PHYSICS/NAVIGATION BLUEPRINT

## Ownership law

Visible art and gameplay collision remain separate unless an explicit building/prop contract combines them.

## Ground

Settlement floor:
- one or more bounded static floor owners
- no dependence on Street/Trail decorative meshes for collision

Section conversion may later split floor ownership, but player-visible height must remain continuous across connectors.

## Streets

Street surfaces:
- presentation

Walkability:
- ground/floor collision

Do not create thin duplicate colliders on top of the ground unless a real step/curb is intended.

## Important buildings

Required:
- segmented wall collision
- real doorway gap
- explicit floor collision
- explicit interior walkable space
- simple roof/ceiling strategy

Forbidden:
- visual doorway on a sealed box collider

## Generic buildings

Current generic buildings are migration placeholders only.

Before becoming important/enterable:
- replace solid-box collision
- define doorway
- define interior
- define anchors
- add focused test

## Wall/perimeter

Use modular collision:
- straight segments
- corner segments
- gate-side segments

Do not use one giant settlement-wall collision object.

## Gate openings

South:
- target clear width 8 m

North:
- target clear width 8 m

Tests must prove:
- center path is open
- wall immediately beside opening still blocks

## Walking clearances

Primary spine:
- 8 m design
- do not reduce below 6 m usable through permanent placement

Secondary:
- 5 m design
- target >=3.5 m usable

Interior:
- >=1.1–1.3 m clear simple walking lane
- >=1.5–2 m near service fronts where practical

## Prop collision classes

### NONE
Use for:
- banners
- small signs where clipping is harmless
- small decorative bundles
- minor foliage

### SIMPLE
Use for:
- large crates
- carts
- benches
- substantial racks
- large rocks

### BUILDING
Use authored segmented collision.

### GAMEPLAY_SPECIFIC
Use only where interaction/combat requires it.

## Navigation tests

Future settlement tests should cover:
- South Gate → Plaza
- Plaza → Community Hall
- Plaza → Smith
- Plaza → North Hunter Gate
- North Gate → trail
- every enterable building doorway
- no sealed visual doors
- no section-boundary step/gap
- no prop blocking primary connectors

## Respawn/recovery

Player fallback spawn should use stable anchors, not raw magic coordinates.

Candidate anchors:
- S01 arrival
- S02 plaza
- S05 hunter gate inner

Exact checkpoint policy remains future gameplay design.
