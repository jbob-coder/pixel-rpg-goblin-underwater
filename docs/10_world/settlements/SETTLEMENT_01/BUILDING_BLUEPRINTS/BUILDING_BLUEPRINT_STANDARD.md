# Settlement 01 — Reusable Building Blueprint Standard

Status: PROVISIONAL STANDARD / INPUT TO ISSUE #6

## Required identity

Every building definition must declare:
- stable building ID
- family/type ID
- owning section ID
- world parcel center
- footprint
- primary facade direction
- implementation state

## Required geometry

Important buildings:
- real wall geometry
- real doorway opening
- explicit interior floor
- explicit roof/ceiling
- segmented collision

No important building may rely on a sealed box collider plus a painted/visual door.

## Required anchors

Minimum:
- EntranceAnchor
- ExitAnchor
- InteriorCenterAnchor

Service building:
- Use/ServiceAnchor
- NPCWorkAnchor

NPC/home building:
- NPCIdleAnchor
- resident/rest anchor where applicable

All anchors need stable names.

## Required presentation groups

Recommended:
- ExteriorVisuals
- InteriorVisuals
- RoofVisibilityGroup
- PropSockets

Presentation nodes do not own gameplay state.

## Required collision groups

Recommended:
- FloorCollision
- WallCollision_*
- Doorway boundary pieces
- explicit large-prop collision only where needed

## Required data contract

A building should expose/read:
- building ID
- section ID
- building family/type
- entrance transform
- service availability reference if any
- interior bounds
- optional roof-visibility bounds

Do not put economy/crafting/NPC durable state inside the building scene.

## Reuse law

A family can have visual variants if:
- footprint contract remains compatible
- doorway/anchor contract remains compatible
- collision remains compatible or variant explicitly versioned

## First-person acceptance

Before promotion:
- doorway traversable
- camera does not clip through expected movement route
- interior navigation readable
- roof/ceiling presentation acceptable
- important interaction visible at phone scale

## Automated gates

At minimum:
- correct stable IDs
- footprint/parcels match blueprint
- doorway clear
- adjacent wall blocks
- anchors exist
- no monolithic sealed collision
- section ownership correct

## Promotion states

BLUEPRINT_DRAFT
→ GRAYBOX_IMPLEMENTED
→ COLLISION_VERIFIED
→ ANCHORS_VERIFIED
→ VISUAL_INTEGRATED
→ HEADLESS_VERIFIED
→ ANDROID_BUILD_VERIFIED
→ DEVICE_VISUAL_VERIFIED.
