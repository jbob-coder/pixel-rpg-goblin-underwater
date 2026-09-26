# Model Sheet — A03 Cargo Cart Family

Status: MODEL_SHEET_READY  
Family ID: `SET01_PROP_CARGO_CART_A`

## Base chassis target

Approximate game-scale envelope:
- length 2.8–3.4 m
- width 1.4–1.8 m
- bed height around 0.8–1.1 m

Exact art proportions require first-person graybox validation.

## Shared modules

- chassis
- two/four wheel set
- tow shafts
- cargo bed
- side rails
- load sockets
- optional canopy frame

## Variants

A. Open Cargo Cart  
B. Covered Traveler Wagon  
C. Supply Cart

Visual load variants should reuse the chassis.

## Collision

Use one simple chassis/body collision plus wheel approximation if necessary.

Do not make every spoke/canopy element collide.

Canvas:
`NONE`

Cargo:
`NONE` unless oversized and gameplay-relevant.

## Sockets

- LoadSocket_01..04
- Driver/HandlerAnchor optional
- TowAnchor
- ParkAnchor

## Reuse target

Area 01, Area 03, Area 10.

## Graybox readiness

`READY`
