# First-Slice Region 01 Tracking → Encounter Graybox Integration Pass — 2026-09-03

Status: BOUNDED WORLD/GRAYBOX-INTEGRATION DESIGN PASS COMPLETE / NO RUNTIME GRAYBOX IMPLEMENTATION

## Bounded piece

`FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_CONTRACT`

The game remains the objective. This pass consumes the previously recorded meter-based world coordinates and binds one actual pursuit, Monster movement path, engagement footprint, tactical-node graph and escape/reacquisition route into Region 01.

## New authorities

Rules/integration:
`docs/10_world/regions/REGION_01/FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_GRAYBOX_INTEGRATION_CONTRACT.md`.

Concrete Hunt-01 layout registry:
`docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_SPATIAL_LAYOUT_REGISTRY.md`.

## Stable proof identities

Scenario:
`R01_HUNT01_M01_TRACK_TO_MEADOW`.

Hunt:
`hunt_r01_m01_proof_01`.

Monster:
`monster_r01_m01_0001`.

Encounter:
`enc_r01_ef02_m01_0001`.

Footprint:
`R01_EF02` Meadow Edge.

Same Monster instance persists through tracking, engagement, escape and reacquisition.

## Selected physical chain

`S00 departure -> outer heavy prints -> S01 River Ford -> fresh wallow -> fresh S03 water-exit prints vs old weak S02 scrape -> S03 feeding evidence -> observation -> EF02 combat -> Monster escape east -> canonical S03->S05 route -> reacquisition evidence -> same Monster in S05`.

Tracking coordinates are developer/authoring truth only. Normal player UI does not reveal them as GPS.

## Evidence anchors

Seven pre-engagement evidence anchors were selected with exact Region-space coordinates:
- outer heavy prints;
- bank/reed passage;
- fresh wallow;
- fresh water-exit prints;
- old weak S02 root scrape;
- feeding remains;
- flattened grass + audio.

Intended clue-chain straight cumulative planning distance is ~253 m. Future actual navigable graybox target is ~260–340 m before optional wrong-route detours.

## Route-choice proof

S00 preserves both S01 and S02 paths.

S01 deliberately presents a stronger fresh S03 clue and a weaker old S02 clue. The wrong S02 inference remains physically playable and can recover to S03 through canonical topology; it is not an invisible failure wall.

## First encounter geometry

Observation anchor:
`(-72,5,-236)`.

Entry node:
`R01_EF02_N01 = (-70,4,-238)`.

Monster anchor:
`R01_EF02_MA01 = (-18,4,-252)`.

Approx initial range:
~54 m.

Approx facing:
Hunter ~75° toward Monster; Monster ~255° toward Hunter.

The aerial-to-first-person handoff preserves those world positions rather than relocating actors to a generic arena.

## Tactical nodes

Ten nodes `R01_EF02_N01..N10` are recorded.

Legal link distances are ~14.0–18.5 m.

Selected surfaces/tags use Stable/Rough Ground plus Brush/High Ground where physically justified.

No Mud/Water is forced into the Meadow footprint; River Ford remains that terrain proof.

## Physical cover

Two substantial objects:
- west boulder ~5×4×3 m;
- scarred tree/root mass with ~1.4 m trunk and ~4×3 m root base.

Brush remains visibility context unless real trunk/root geometry blocks the line.

## Monster clearance

Monster prototype remains ~6.6 m long / ~3.0 m shoulder-body height.

First-proof environment clearance targets:
- west Charge lane ~48 m long / ~9 m clear width;
- initial Monster pivot clear radius ~8 m;
- ~12 m local body-force clearance around initial Monster placement.

These are graybox clearance targets, not final attack ranges/collision dimensions.

## Escape/reacquisition

Selected test branch:
`MONSTER_ESCAPED`.

Escape boundary:
`(-8,4,-258)`.

Canonical S03↔S05 route remains `(23,0,-255)`.

Reacquisition evidence is placed along that real route and the same Monster staging anchor is `(58,-3,-268)` in S05.

Blood/altered-gait evidence remains conditional on authoritative wound/anatomy state.

## Persistence checkpoints

Six checkpoint applications were recorded:
- S00 route choice;
- S01 post-wallow choice;
- Meadow observation;
- stable EF02 combat decision;
- post-Monster-escape outcome;
- S05 reacquisition.

Save/reload must preserve the same Monster/evidence/encounter IDs and cannot duplicate scheduler actions or replay escape.

## Verification boundary

Design consistency was checked against:
- canonical Region topology;
- current spatial registry;
- Monster 01 body/attack requirements;
- terrain rules;
- encounter-footprint requirements;
- persistence safe-point rules.

No graybox/runtime/device verification is claimed.

`FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_INTEGRATION_RECORDED = YES`
`REGION01_HUNT01_TACTICAL_NODES_RECORDED = YES`
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`REGION01_HUNT01_PHONE_VERIFIED = NO`.

Phone blocker remains:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Exact next bounded action

`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION`

Next should convert only S00→S01→S03 + EF02 into build-ready primitive geometry dimensions: route widths/grades, terrain patch dimensions, evidence marker volumes, cover primitives, Monster-clearance volumes, camera-clearance markers and streaming-boundary proxies. Do not expand to all seven sectors/final art.