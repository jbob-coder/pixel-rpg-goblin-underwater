# Layer 12 — Migration and Implementation Sequence

Status: SAFE MIGRATION PLAN / NO RUNTIME CHANGE FROM THIS DOCUMENT

## Current → future mapping

### Current Street
Maps conceptually to:
- Main Hunter Spine
- Central Plaza approach

Do not move it until section definitions exist.

### Current Market
Maps to:
- S02 Central Plaza market socket

### Current Enterable Smith
Maps to:
- S04 East Work District

Preserve:
- real doorway
- interior
- segmented collision
- anchors
- roof behavior

### Current Generic Building A
Use only as temporary visual/scale reference for:
- S03 local/residential development

Do not promote its solid-box collision to final Community Hall.

### Current Generic Building B
Use only as temporary visual/scale reference for:
- S04 storage/work development

### Current Gate + Gate Warden
Maps conceptually to:
- S05 North Hunter Exit

Current position is not final.

### Current Trail
Maps to:
- S05 north connector
- external hunt route beyond settlement

### Current trees/rocks/vegetation
Reuse primarily:
- S05
- exterior trail transition

## Implementation phases

### Phase A — section data only
Issue #3.

Create SectionDefinition/SectionInstance records over the current world without moving visible objects.

Gate:
- graph/connectors valid
- current runtime unchanged

### Phase B — reusable building contract
Issue #6.

Adapt current smith.
Build one second real enterable building.

Gate:
- no fake door
- collision/anchors pass

### Phase C — S04 Work District anchor
Move/adapt smith and create storage/work canopy in a bounded test world or controlled migration slice.

Gate:
- smith still enterable
- service anchor preserved
- no collision regression

### Phase D — S02 Central Plaza
Migrate market/street layout.
Create plaza sockets and cross street.

Gate:
- main spine remains clear
- minimap mapping updated

### Phase E — S03 Local District
Build Community Hall + two residences.
Add local NPC anchors.

Gate:
- all doors traversable
- anchors stable

### Phase F — S01 South Arrival
Build new South Gate/gatehouse/logistics area.

Gate:
- arrival path readable
- main spine connector open

### Phase G — S05 North Hunter Exit
Move/adapt current gate/Warden identity.
Connect to current/future trail.

Gate:
- current-world hunt transition preserved
- no accidental combat teleport behavior

### Phase H — perimeter/walls/props
Add modular walls/corners and streetscape props.

Gate:
- no primary route obstruction
- collision ownership remains explicit

### Phase I — conservative streaming
Issue #5.

Enable section lifecycle only after static five-section layout passes.

Gate:
- no visible broken transitions
- no state duplication/loss
- device memory/performance evidence

### Phase J — services/persistence
Add interaction event boundary, persistence, inventory/crafting incrementally.

## Rollback law

Each phase should be independently revertible.

Do not replace the entire current world in one commit.

## Test progression

For each phase:
1. static owner/schema test
2. focused headless/runtime test
3. broad first-person regressions
4. canonical CI
5. Android export when relevant
6. physical-device check when layout/controls/performance materially change

## Completion definition

Settlement 01 is not “complete” because all five sections exist visually.

Completion requires:
- traversable layout
- real important interiors
- stable connectors
- explicit collision
- NPC/service anchors
- minimap/wayfinding
- persistence hooks
- mobile performance evidence
- no stale duplicate world ownership
