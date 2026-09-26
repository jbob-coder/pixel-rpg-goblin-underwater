# Model Sheet — A01 South Gate Frame

Status: MODEL_SHEET_READY  
Asset ID: `SET01_A01_SOUTH_GATE_FRAME`

## Critical gameplay dimension

Clear passage:
- 8.0 m minimum

Gate center:
- settlement plan X 0 / Z +33

The opening is gameplay authority.

## Modules

- GatePost_L
- GatePost_R
- Header/frame optional
- GateLeaf_L
- GateLeaf_R
- hinge hardware
- banner/lantern sockets

## Open-state contract

Default planning state:
- leaves parked against side posts/walls;
- no collision intruding into central 8 m passage.

Closed-state gameplay:
- future only;
- requires explicit world-state owner and collision update contract.

## Collision

Posts:
- simple blocking collision.

Leaves:
- no blocking collision in normal open state, or collision follows exact open leaf pose outside passage.

Do not use one collider across the opening.

## Visual size

Frame should visually connect to:
- gatehouse west
- east watch
- modular perimeter walls

Do not exceed watch/gatehouse silhouette unnecessarily.

## Tests

Future:
- 8 m center corridor ray/path clear;
- side posts block;
- leaf open-state does not block;
- wall connectors align.

## Graybox readiness

`READY`
