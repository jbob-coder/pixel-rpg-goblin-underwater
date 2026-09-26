# Layer 04 — Interiors and Anchors

Status: PROVISIONAL INTERIOR/ANCHOR CONTRACT

## General building anchor set

Important enterable buildings should expose:

- `EntranceAnchor`
- `ExitAnchor`
- `UseAnchor` or service-specific anchors
- `NPCIdleAnchor_*`
- `NPCWorkAnchor_*`
- `PropSocket_*`
- `InteriorCameraZone`
- `RoofVisibilityGroup`

Anchors are stable gameplay connectors; visible props are replaceable.

## Community Hall

Required anchors:
- entrance east side
- central conversation anchor
- notice/event anchor
- 3–5 local NPC idle sockets
- rear service/meeting socket
- future event trigger socket

Interior target:
- simple central room
- one side/rear room maximum in first pass
- avoid maze-like floor plan

## Residences W01/W02

Required:
- EntranceAnchor
- resident idle anchor
- sleeping/private anchor
- small storage/prop sockets

First implementation may use a single-room + rear/private-zone pattern.

Do not create expensive full-life simulation inside every house initially.

## Smith

Existing current pattern already provides:
- EntranceAnchor
- UseAnchor
- interior detection
- roof visibility handling

Future additions:
- SmithNPCWorkAnchor
- CustomerAnchor
- MaterialDropAnchor
- EquipmentDisplay sockets
- ServiceTransactionAnchor

Service logic must live outside building presentation.

## Work storage

Anchors:
- entrance
- loading point
- storage interaction
- worker idle
- material rack sockets

## South Gatehouse

Anchors:
- arrival guard
- gate control
- visitor interaction
- guard idle
- wall/watch access visual socket

## Hunter Watch

Anchors:
- GateWarden/HunterWarden
- bounty/route board
- preparation interaction
- lookout position
- emergency-return interaction

## Supply cache

Anchors:
- entrance
- supply interaction
- emergency item socket
- quartermaster future anchor

## Interior scale law

First-person movement requires:
- uncluttered doorway landing
- at least 1.1–1.3 m clear walking channel in simple rooms
- wider 1.5–2 m around service interaction fronts when possible

Collision is authoritative; visual clutter must not narrow a planned navigation channel unexpectedly.

## Roof behavior

Enterable buildings need explicit first-person roof/ceiling strategy:
- normal interior ceiling where camera remains inside;
- hide/split roof pieces only where current presentation requires it;
- never hide wall collision just because roof presentation is hidden.
