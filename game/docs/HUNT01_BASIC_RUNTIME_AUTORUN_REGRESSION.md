# Hunt-01 Basic Runtime Autorun Regression

Status: IMPLEMENTED / HUNTER DEFEAT TERMINAL STATIC+HEADLESS+ANDROID BUILD VERIFIED
Last reconciled: 2026-09-14

## Purpose

Provide a deterministic development/CI fresh-instance repeatability gate around already-implemented Hunt-01 basics. This is not player-facing autoplay and does not alter normal movement, camera control, combat decisions or runtime ownership.

## Covered path

Each fresh-instance cycle uses the real production `region_01_hunt01_graybox.tscn` and existing owners to prove:
- zero tracking state → seven clues → `OBSERVATION_READY` → physical same-location ENGAGE;
- initial out-of-range Monster idle without fabricated attack;
- authored N01→N02→N05→N08→N10 movement and real `M01_TAIL_SWEEP` combat exchange;
- existing Poleblade Block cost/consequence, deterministic SOLID / `BLOCK_STRONG`, Hunter Health 100→98 and no strong-Block status request;
- authored N10→N08→N05→N07→N09 reposition through normal AP economy;
- real Head Sweep/Block bridge then Round-4 `POLEBLADE_MEASURED_CUT` against `DORSAL_PLATES`, CLEAN selected contact, `MINERALIZED_DORSAL_PLATE`, anatomy 100→95 and idempotent handoff;
- real Round-4 unguarded CLEAN Head Sweep produces one Bleeding +1 through wound/contact→generic status application and Health 96→84;
- real Round-5 strong Block leaves Health 82 and the Round-5 status-timing hook emits one `PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE` with `NOT_SELECTED_PENDING_AUTHORITY` and no `damage_amount`;
- pending Bleeding event does not mutate Health and Round 6 starts normally on Hunter with 4 AP / 1 RP;
- test-only existing Health handoffs prepare 82→10 while outcome remains ACTIVE/nonterminal;
- real Round-6 Head Sweep action sequence 5 with explicit decline resolves deterministic CLEAN and supplies the final 10→0 hostile Health transition;
- existing Health owner emits `PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME`;
- existing encounter-outcome owner commits Hunter `ACTIVE → DOWNED`, living Mudcrest remains `ACTIVE`, outcome becomes `HUNTERS_DEFEATED` and scheduler freezes in Round 6 with no current actor;
- reaction/telegraph are closed, post-terminal Hunter turn and external Monster completion are rejected, no synthetic Round-6 Bleeding round-end event is emitted, preserved anatomy remains unchanged and defeat replay is idempotent;
- teardown removes world and Hunt-01 groups before the next cycle.

The test executes two fresh scene lifecycles in one Godot process and compares one stable signature containing the Monster combat exchange, Hunter attack/anatomy exchange, real status lifecycle and Hunter defeat terminal chain.

## Safety boundary

Test helpers position the Hunter only at the existing pre-combat engagement boundary. Once combat starts, existing test APIs drive authored tactical movement, reaction decisions, attacks and scheduler progression.

The defeat extension uses test-only Health preparation solely to approach the already-verified zero-Health boundary. It stops at 10 Health. The final zero-Health transition, `DOWNED` state and `HUNTERS_DEFEATED` terminal commit come from a real hostile production Head Sweep through existing defense, health, outcome and scheduler owners.

Normal production input is not synthesized. Protected analog left-stick/right-look controls are unchanged. No player-facing autoplay, new RNG, final balance, Bleeding HP magnitude, structural threshold, withdrawal rule, forced recovery/respawn rule or Monster terminal semantic is introduced.

`PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE` remains a downstream handoff only. Forced recovery after Hunter defeat remains undefined and is not executed by this gate.

## Verification gates

- `HUNT01_BASIC_RUNTIME_AUTORUN_SOURCE_STATIC_VERIFIED`
- `HUNT01_BASIC_RUNTIME_AUTORUN_VERIFIED`
- `HUNT01_BASIC_RUNTIME_AUTORUN_COMBAT_EXCHANGE_VERIFIED`
- `HUNT01_BASIC_RUNTIME_AUTORUN_HUNTER_ATTACK_EXCHANGE_VERIFIED`
- `HUNT01_BASIC_RUNTIME_AUTORUN_REAL_STATUS_LIFECYCLE_VERIFIED`
- `HUNT01_BASIC_RUNTIME_AUTORUN_HUNTER_DEFEAT_TERMINAL_VERIFIED`

## Verified evidence

Storage policy commit: `f3b5dfb672127fa90303e689466f41a3cbe439ff`.
Hunter defeat-terminal implementation / latest fully tested source: `01a19b2811cfc5e3f9c0edb0e9264bc997161c7c`.
Production workflow `34880096112`: SUCCESS.
Job `104096962757`: SUCCESS.
Artifact `10362706279`: `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`, 57,536,941 bytes, SHA-256 `ba02d634d1435ed294f42bf5db8e2c55470265da4026aa1488e4b2ce30792917`.

Run 84 passed static/manifest gates, Godot 4.7.2 import/parse, production smokes, both fresh-instance integrated cycles through Hunter defeat terminal, every current combat/anatomy/status/outcome regression, Android debug export and artifact upload.

## Next bounded verification extension

`FIRST_SLICE_ANDROID_PACKAGE_2GB_STORAGE_CAP_CI_GATE`.

Next, enforce the user-selected `2,000,000,000`-byte ceiling on the exported production Android package. Add the check after successful APK export and before artifact upload, preserve measured bytes/cap as evidence, fail above the ceiling, and explicitly avoid claiming that compressed APK size proves installed-footprint compliance. No gameplay/runtime/content changes belong in that slice.
