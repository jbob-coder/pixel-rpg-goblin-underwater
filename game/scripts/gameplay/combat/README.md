> **CURRENT PIXEL RPG COMBAT RUNTIME STATUS — 2026-09-25**
>
> This README's `BASIC RUNTIME AUTORUN NEXT` / `Current production slice` statement is historical. Basic runtime autorun and additional Hunter-attack/status/defeat regressions exist in current `game/tests/` and are executed by canonical CI.
>
> The deterministic Hunt-01 combat package remains a live domain owner. Current first-person Pixel RPG does not yet expose the entire stack; current-world player integration stops at targeting + Combat Bridge 002 no-attack bootstrap. Use current source/tests for exact implemented behaviors and the current-world relationship map for integration boundaries.

# Hunt-01 Combat Runtime

Status: STACK THROUGH TAIL SWEEP CLEAN→GENERIC STAGGERED STATIC/HEADLESS/ANDROID BUILD VERIFIED / BASIC RUNTIME AUTORUN NEXT
Last reconciled: 2026-09-13

Purpose: own the generic production combat-domain runtime after same-location ENGAGE while delegating species anatomy and Monster attack packets to the Monster package.

## Runtime ownership

- `hunt01_combat_turn_shell_runtime.gd` — initiative/round/slot state, AP/RP/Stamina, Monster activation handshake and terminal scheduler authority.
- `hunt01_tactical_movement_runtime.gd` — authored-link tactical movement.
- `hunt01_reaction_window_runtime.gd` — out-of-turn reaction lifecycle.
- `hunt01_hunter_attack_runtime.gd` — Hunter Field Poleblade Measured Cut.
- `hunt01_hunter_defense_consequence_runtime.gd` — Block/no-contact consequence and impact drain.
- `hunt01_hunter_health_injury_runtime.gd` — normalized first-slice Hunter health/injury and pending defeat boundary.
- `hunt01_status_application_runtime.gd` — generic Bleeding/Staggered/Off-Balance application, refresh/stack/idempotency/persistence and Staggered timing-transition mutation owner.
- `hunt01_status_timing_runtime.gd` — `TURN_START_PRE_RECOVERY` / `TURN_END` / `ROUND_END` lifecycle, exact-once Staggered→Off-Balance conversion, Off-Balance recovery and pending Bleeding periodic cadence.
- `hunt01_encounter_outcome_runtime.gd` — Hunter zero-Health Downed/defeat and terminal handoff.
- Monster anatomy/attacks remain species-owned under `game/scripts/gameplay/monsters/monster_01/`.

Stable combatants: encounter `enc_r01_ef02_m01_0001`; Hunter `hunter_player_0001`; Monster `monster_r01_m01_0001`.

## Ownership boundaries preserved

Species anatomy remains delegated to `game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd`.

The generic turn shell does not own final damage/health arithmetic, species crack/break/sever transitions, status consequences, or the Monster normal attack runtime. Species/content owners remain responsible for those layers.

`adjacent tactical-node movement` remains explicitly owned by `hunt01_tactical_movement_runtime.gd`: each adjacent move costs `1 AP`; authored terrain may add a `terrain surcharge`; movement records deterministic `footing`, including `POOR`, and spends resources through the combat shell.

Current initiative attributes remain the reversible `PROVISIONAL_CONTRACT_EXAMPLE_FIXTURE`; they are executable deterministic fixtures, not final character/Monster balance.

## Verified Generic Staggered + Tail Sweep producer boundary

`status_staggered` is implemented in the existing generic status application/timing owners as one `TRANSIENT_PHYSICAL_DISRUPTION` instance with `REFRESH_DURATION`, intensity fixed to 1 and no hidden skipped activation. At the target's next `TURN_START_PRE_RECOVERY`, Staggered is removed exactly once, existing Off-Balance is applied/refreshed exactly once, Off-Balance is armed for that same activation's `TURN_END`, and normal shell Stamina/AP/RP refresh continues.

The species-owned Tail Sweep CLEAN consequence now builds exactly one valid generic Staggered request. The request dispatches synchronously through `PENDING_GENERIC_STATUS_APPLICATION_RUNTIME`; repeat resolution readback is idempotent and does not refresh Staggered twice. SOLID Tail Sweep still emits Off-Balance and Strong Block still emits no Tail Sweep status.

Verified source head `fbfd30fde0ad74bdb73d384533287b884341cd93`; workflow `34762775881` SUCCESS; job `103738398857` SUCCESS; artifact `10319377979` `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`.

## Explicitly not implemented yet

Forced recovery/respawn; voluntary Hunter withdrawal; Monster escape/death; Bleeding periodic Health magnitude; Braced/Guarded runtime coverage; final health/damage/armor balance; forced movement/final Block balance; structural crack/break/sever/tail detachment; Dodge/Parry/Brace resolution; remaining Mudcrest attacks; Berserk; harvest/inventory/crafting/settlement/persistence; sustained performance.

## Current production slice

`FIRST_SLICE_HUNT01_BASIC_RUNTIME_AUTORUN_REGRESSION`.

This next piece adds repeatable headless verification around the already-implemented basics. It does not change player-facing movement, combat automation or domain ownership.
