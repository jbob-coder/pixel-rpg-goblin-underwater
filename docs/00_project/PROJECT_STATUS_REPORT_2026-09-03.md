# Unnamed Hunt RPG — Project Status Report — 2026-09-03

Status: SAVED PROJECT SNAPSHOT / REPORT ONLY / CURRENT OPERATING AUTHORITY REMAINS `EVOLVE_ALIGNMENT.md`

## Purpose

Preserve a durable project-level status report requested by the user.

This file is a snapshot for review/navigation. It does **not** replace:
- `EVOLVE_ALIGNMENT.md` for exact current/next action;
- `PROJECT_HANDOFF.md` for reconstruction;
- owning package contracts for mechanics/coordinates;
- source/build/device evidence for verification claims.

## Repository

Repository:
`jbob-coder/Chatgptjuegolpcal`.

Branch:
`worldlife-reference-docs`.

Snapshot source baseline before the current geometry-specification publication:
`eebea9a1b4aa9601ce932c19f5513021d3bdc1ea`.

## Project goal

Build an Android-targeted monster-hunting tactical RPG with:
1. walkable Settlement 01;
2. aerial wilderness exploration/tracking;
3. first-person turn-based tactical combat at the same physical world location;
4. anatomy break/sever consequences;
5. persistent Monster escape/reacquisition;
6. finite condition-based harvesting;
7. Inventory/material conservation;
8. crafting/equipment progression;
9. save/reload continuity;
10. a repeated hunt loop.

The game is the objective. Documentation is the control/ownership/continuity system.

## Engine / Android state

Current candidate:
- Godot 4.7 family;
- CI/build Godot 4.7.2 stable;
- GDScript;
- GL Compatibility/OpenGL3;
- Galaxy A03s baseline;
- stable 30 FPS representative-scene minimum target.

Verified automated Stage-1 lineage includes:
- static preflight `154/154`;
- Monster collision `8/8`;
- world boundary `12/12`;
- aerial/first-person state continuity `17/17`;
- lifecycle transient-input `47/47`;
- performance telemetry calculations `20/20`;
- Godot parse/smoke PASS;
- Android debug export/APK integrity/artifact upload PASS.

Current inner APK:
`57,570,361 bytes`.

SHA-256:
`f9cc00019f31fc7942c309b7178db3967cc1ecc726e6cc2a07d6b3d5ec32af59`.

Still not verified:
`PERFORMANCE_VERIFIED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`FINAL_ENGINE_SELECTED = NO`.

Phone blocker:
`GALAXY_A03S_DEVICE_EVIDENCE_REQUIRED_FOR_STAGE1_PHONE_GATE`.

## Recorded gameplay design chain

Recorded at design level:
- nine reusable combat/outcome contracts through Defeat/Retreat;
- Monster 01 Mudcrest Raker anatomy, attacks, Berserk, deterministic behavior and escape;
- finite Harvest capacity/condition/quality;
- Recovery Bundles + player Inventory conservation;
- one Raker-Tendon Grip recipe/refinement;
- physical Settlement 01 Smith service;
- Persistence schema `UHR_SAVE_SCHEMA_1`;
- shared world coordinates/dimensions;
- first Region 01 Hunt-01 physical tracking->encounter->escape/reacquisition integration;
- Hunt-01 graybox geometry specification/primitive registry.

No production runtime implementation is claimed for these gameplay domains.

## Core combat direction

First-slice combat uses:
- 4 AP baseline;
- 1 RP baseline;
- persistent Stamina;
- one normal activation max per eligible actor/round;
- deterministic Initiative;
- explicit Dodge/Block/Parry/Brace legality;
- anatomy targeting;
- deterministic terrain/status consequences;
- no unrelated critical-hit/status-proc/slip rolls.

## Monster 01

Stable species:
`species_r01_mudcrest_raker`.

Prototype dimensions:
- ~6.6 m nose-to-tail;
- ~3.0 m shoulder/body height.

Normal attacks:
- Horn Charge;
- Head Sweep/Gore;
- Shoulder Ram;
- Foreleg Stomp;
- Tail Sweep.

Anatomy loss changes/removes attacks. Berserk cannot restore destroyed anatomy or add hidden turns.

## Harvest / Inventory / Craft

Current selected harvest-capacity total across first-slice sources:
`45 prototype capacity units` before damage/extraction loss.

Inventory:
- 20-stack prototype player field cap;
- 99-unit per-stack cap;
- Recovery Bundle preserves material that cannot enter Inventory.

First recipe:
`recipe_field_poleblade_raker_tendon_grip`.

Consumes:
- 2 HIGH Mudcrest Raker Tail Tendon;
- 2 STANDARD-or-better Mudcrest Raker Hide.

Applies:
`refinement_field_poleblade_raker_tendon_grip`.

Prototype effect:
Placed Hew Stamina `18 -> 16` only.

## Settlement / world scale

Measurement:
`1 world unit = 1 meter`.

Axes:
+X East / +Y Up / -Z North / +Z South.

Settlement 01 prototype envelope:
`200 × 260 m`.

Settlement origin:
Hunter Gate inner `(0,0,0)`.

Smith workbench:
`(-22,3,40)`.

Frontier:
~80 m centerline.

Region 01:
seven sectors with canonical linked centers ~117–165 m apart; deepest center ~402 m from Region entry.

Hunter Base 01:
`1.75 m` tall `LOCKED/CURRENT`.

## First Hunt-01 physical proof

Scenario:
`R01_HUNT01_M01_TRACK_TO_MEADOW`.

Hunt:
`hunt_r01_m01_proof_01`.

Persistent Monster:
`monster_r01_m01_0001`.

Encounter:
`enc_r01_ef02_m01_0001`.

Route:
`S00 -> S01 River Ford -> S03 Feeding Meadow -> EF02 -> Monster escape toward S05 -> reacquisition`.

Recorded before geometry specification:
- seven evidence anchors;
- ~253 m clue-chain cumulative planning distance;
- ~260–340 m broad future navigable target;
- observation `(-72,5,-236)`;
- N01 `(-70,4,-238)`;
- initial Monster `(-18,4,-252)`;
- ~54 m initial separation;
- ten tactical nodes;
- boulder/tree physical cover;
- Charge/pivot/body-force clearances;
- same-Monster escape/reacquisition anchors;
- six Persistence checkpoint applications.

## Hunt-01 graybox geometry now specified

New Region authorities:
- `docs/10_world/regions/REGION_01/FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION.md`;
- `docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_GEOMETRY_REGISTRY.md`.

Selected build targets include:
- smoothed S00 departure->N01 navigable route `285–315 m`;
- normal required-route sustained grade `<=15%`;
- short transition `<=18%`;
- required step/ledge `<=0.25 m`;
- S00->S01 primary route >=7 m / Raker corridor >=9 m;
- Monster-route overhead >=4.5 m;
- S01 ford working envelope 58×54 m;
- shallow-water patch 34×18 m;
- required water depth 0.15–0.55 m;
- wallow mud 16×12 m;
- exit mud 20×12 m;
- S01->S03 hunter corridor >=6 m / Raker corridor >=9 m;
- EF02 Meadow working patch 70×54 m;
- observation shelf 16×12 m;
- curved observation->N01 ramp 6–7 m long / >=3.5 m wide;
- tactical-node markers + >=3.5 m legal-link corridors;
- boulder 5×4×3 m;
- scarred tree trunk 1.4 m diameter + 4×3 m root base;
- Charge lane ~48 m × >=9 m clear;
- Monster pivot clear radius 8 m;
- escape/S05 staging corridor >=9 m;
- camera descent/debug sight volumes;
- three streaming/grace debug proxy bands.

These remain prototype build targets, not runtime/phone verification.

## Persistence

Schema:
`UHR_SAVE_SCHEMA_1`, version 1.

One prototype slot:
`save_slot_01`.

Active encounter saves are allowed only at stable authoritative decision points.

Reload must preserve stable Monster/anatomy/Crystal/encounter/harvest/Inventory/craft identities and cannot replay already-committed transactions or turn-start hooks.

## Current verification boundary

Recorded:
`COMBAT_DESIGN_BASELINE_COMPLETE = YES`
`FIRST_SLICE_HARVEST_BASELINE_RECORDED = YES`
`FIRST_SLICE_INVENTORY_MATERIAL_OWNERSHIP_RECORDED = YES`
`FIRST_SLICE_ONE_RECIPE_CRAFT_EQUIP_LINKAGE_RECORDED = YES`
`FIRST_SLICE_SETTLEMENT_SMITH_SERVICE_INTERACTION_RECORDED = YES`
`FIRST_SLICE_PERSISTENCE_SAVE_RELOAD_RECORDED = YES`
`FIRST_SLICE_WORLD_COORDINATE_DIMENSION_FRAMEWORK_RECORDED = YES`
`FIRST_SLICE_REGION01_TRACKING_TO_ENCOUNTER_INTEGRATION_RECORDED = YES`
`REGION01_HUNT01_TACTICAL_NODES_RECORDED = YES`
`FIRST_SLICE_REGION01_HUNT01_GRAYBOX_GEOMETRY_SPECIFICATION_RECORDED = YES`.

Not implemented/verified:
`REGION01_HUNT01_GRAYBOX_IMPLEMENTED = NO`
`REGION01_HUNT01_RUNTIME_VERIFIED = NO`
`WORLD_SPATIAL_RUNTIME_VERIFIED = NO`
`PERSISTENCE_RUNTIME_IMPLEMENTED = NO`
`ENGINE_PHONE_PROBE_VERIFIED = NO`
`PERFORMANCE_VERIFIED = NO`.

## Saved visual concept

Google Drive folder:
`Unnamed Hunt RPG`.

File:
`Unnamed Hunt RPG - Finished Game Visual Concept 2026-09-03.png`.

Drive ID:
`1JSCDYW8A1JvW9Xht535uvcnRFbru44_U`.

Visual intent only.

## Current development direction

The project is now past broad concept-only planning.

Current physical construction chain is:
`major world dimensions -> Hunt-01 coordinates -> tracking/encounter integration -> graybox geometry dimensions -> build manifest/validation -> later verified engine graybox when gate permits`.

For exact next action always read the current `EVOLVE_ALIGNMENT.md` rather than treating this dated report as live operating state.
