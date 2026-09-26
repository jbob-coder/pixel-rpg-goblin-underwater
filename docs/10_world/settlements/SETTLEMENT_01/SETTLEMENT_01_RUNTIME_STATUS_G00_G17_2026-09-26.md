# Settlement 01 — Runtime Status G00–G17

Status: CURRENT PRODUCTION EVIDENCE / ISOLATED SETTLEMENT FOUNDATION COMPLETE THROUGH G17  
Reconciled: 2026-09-26

Production repository: `jbob-coder/pixel-rpg-goblin-underwater`  
Production branch: `main`

Current production HEAD:

`abeeda02568a4e7b9a36d9dd9ee381d1539cdc67`

## Current implementation state

Settlement 01 now has an isolated, tested runtime foundation through G17.

Implemented production passes:

- G00 — locked five-section / twelve-area layout authority and stable IDs;
- G01 — continuous settlement floor + Main Spine;
- G02 — Central Plaza;
- G03 — locked Smith graybox;
- G04 — Community Hall;
- G05 — residences;
- G06 — work-support structures;
- G07 — east worker/frontage passage;
- G08 — South Arrival Gate;
- G09 — Gate Barracks & Security;
- G10 — Caravan / logistics staging;
- G11 — North Hunter Staging;
- G12 — North Watch Gate / trail exit;
- G13 — perimeter + streetscape;
- G14 — authored NPC anchors and deterministic simple schedules;
- G15 — minimap derivation from G00 layout authority;
- G16 — conservative section lifecycle / streaming intent;
- G17 — versioned Settlement 01 durable-world persistence hooks.

## G15 evidence

Canonical CI:

`36267898515` — SUCCESS

Verification job:

`108475980140` — SUCCESS

Android export job:

`108476104561` — SUCCESS

## G16 evidence

Canonical CI:

`36268405826` — SUCCESS

Verification job:

`108477547212` — SUCCESS

Android export job:

`108477674650` — SUCCESS

Verification artifact:
- ID `10914721682`
- archive digest `sha256:33212c025711b0da2de6c1c7a346717a49dcab8aa3f9d4f6ebf7ca7a14c7d90b`

Android artifact:
- ID `10914796552`
- archive digest `sha256:fe1be1caec78004769f878dc266816d884c272530d5de10af1c9627c109db60f`

## G17 evidence

Initial G17 CI found one real defect in canonical JSON round-trip representation.

Failed run:
`36268703882`

Failure:
- generated snapshot was semantically valid;
- Godot JSON parsing normalized integer-looking JSON numbers through float representation;
- canonical JSON string changed after round-trip.

Fix:
`1edecbc3f84ba519d419dcabfeb4f6f4ba3cdfd6`

The canonicalizer now normalizes mathematically integral JSON floats back to integers before deterministic serialization.

Corrected canonical CI:

`36268786947` — SUCCESS

Verification job:

`108478620585` — SUCCESS

Android export job:

`108478756850` — SUCCESS

Verification artifact:
- ID `10915175361`
- archive size `142,807` bytes
- archive digest `sha256:f9c9e8d1fbab34c0a1e4f7c9b819e94951447b5163e1fd7095ae4e39134c69f1`

Android artifact:
- ID `10913984750`
- archive size `58,034,538` bytes
- archive digest `sha256:54835d3c24a6d358bbc1e81c429eccf459dbf47ad9e1b28be376e7997c0bcfb4`

Artifact archive size/digest is not the same thing as internal APK byte size/hash.

## G16 boundary

`settlement_01_streaming_manager.gd` is a conservative lifecycle manager.

It proves:
- one lifecycle instance per durable section;
- current section + direct neighbors;
- bounded probable-next preload;
- Area 04 shared Main Spine always available;
- protected interaction-target sections;
- pending unload rather than immediate removal;
- explicit delayed unload commit;
- deterministic transient lifecycle snapshot/restore.

It does **not** yet:
- delete/load actual scene nodes;
- prove visible pop-free traversal;
- prove device memory/performance;
- own durable save state;
- cut Settlement 01 into the player-facing world.

## G17 boundary

`settlement_01_persistence_contract.gd` defines a versioned durable-world snapshot boundary.

It owns only the future `durable.world_state` Settlement 01 envelope:
- settlement flags;
- five stable section records;
- twelve stable building records.

It validates:
- stable IDs against G00;
- layout schema compatibility;
- JSON-safe data;
- exact snapshot namespaces;
- deterministic canonical JSON;
- current-version migration hook;
- rejection of unknown IDs and transient/runtime objects.

It explicitly excludes:
- camera/input/HUD/targeting;
- G16 loaded/pending section lifecycle;
- player state;
- combat state;
- NPC relationship state;
- inventory/equipment;
- economy.

G17 does **not** write to `user://`, create a global save system, autosave, or prove mobile lifecycle recovery.

## Current player-facing boundary

The existing first-person compact-world prototype remains the current application boot/player-facing world.

Settlement 01 has **not** been made the default world.

Therefore these are separate facts:

`SETTLEMENT_01_ISOLATED_RUNTIME_G00_G17 = VERIFIED`

`SETTLEMENT_01_PLAYER_FACING_CUTOVER = NOT PERFORMED`

## Visual-art boundary

Creator final visual approvals:

**0 / 12**

The 12 spatial/technical references and model contracts can support graybox engineering, but final:
- facades;
- roofs;
- materials;
- prop composition;
- visual polish

remain blocked on creator approval.

## Physical-device boundary

Not yet proven for the rebuilt settlement:
- install/launch with Settlement 01 active;
- first-person readability;
- section-transition pop;
- current-world touch ergonomics inside the rebuilt settlement;
- sustained FPS;
- heat;
- memory;
- lifecycle behavior;
- installed footprint.

## Next phase

G00–G17 completes the isolated foundation described by the current implementation plan.

The next phase is **production cutover**, but it must be incremental and reversible.

See:

`SETTLEMENT_01_PRODUCTION_CUTOVER_PLAN_2026-09-26.md`

No one-step replacement of the current prototype world is authorized by this status document.
