# Hunt-01 Basic Runtime Autorun Handoff — 2026-09-13

Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED THROUGH HUNTER DEFEAT TERMINAL
Last reconciled: 2026-09-14

CURRENT_OBJECTIVE: keep the already-implemented basic Hunt-01 runtime automatically repeatable and regression-gated without creating player-facing autoplay.

CURRENT_STATE: complete through one deterministic Monster combat exchange, one Hunter attack/anatomy exchange, one real hostile Bleeding lifecycle and one real Hunter defeat-terminal chain. The production Region-01 scene executes two fresh boot/run/teardown cycles and reproduces the same integrated signature.

LAST_VERIFIED_STATE: revision `01a19b2811cfc5e3f9c0edb0e9264bc997161c7c` passed workflow `34880096112`, job `104096962757`.

COMPLETED_WORK:
- fresh world identity, zeroed tracking/encounter, seven-clue `OBSERVATION_READY`, physical ENGAGE and combat-owner attachment;
- initial out-of-range Monster idle proof;
- authored N01→N02→N05→N08→N10 movement and real Tail Sweep→Poleblade Block exchange;
- deterministic SOLID / `BLOCK_STRONG`, Hunter Health 100→98 and no strong-Block status request;
- authored N10→N08→N05→N07→N09 reposition through normal AP economy;
- real Head Sweep/Block bridge and Round-4 Dorsal `POLEBLADE_MEASURED_CUT`, CLEAN selected contact and anatomy 100→95;
- real Round-4 unguarded Head Sweep produces Bleeding through wound/contact→generic application; Health 96→84;
- Round-5 strong Block leaves Health 82 and Round-5 `ROUND_END` emits one pending Bleeding consequence with no selected HP magnitude or direct Health mutation;
- Round 6 begins normally at 4 AP / 1 RP;
- Hunter defeat-terminal extension uses test-only existing health handoffs only to prepare 82→10 without committing outcome;
- real Round-6 Head Sweep action sequence 5, existing decline path and deterministic CLEAN result provide the final 10→0 Health transition;
- existing health owner emits pending defeat handoff; outcome owner commits Hunter `DOWNED`, living Mudcrest remains `ACTIVE`, `HUNTERS_DEFEATED` commits, scheduler freezes in Round 6 with current actor empty;
- post-terminal Hunter turn/end and external Monster completion are rejected;
- no synthetic Round-6 Bleeding round-end tick occurs after terminal commitment;
- defeat replay remains idempotent and preserved Mudcrest anatomy remains unchanged;
- teardown rejects group leakage; second fresh instance matches first;
- protected player movement/look behavior remains untouched;
- run 84 passed full current static/headless/build regression and Android export.

IN_PROGRESS: none for the Hunter defeat-terminal autorun slice.

NEXT_ACTION: `FIRST_SLICE_ANDROID_PACKAGE_2GB_STORAGE_CAP_CI_GATE` — enforce the user-selected 2,000,000,000-byte ceiling at the exported Android package layer.

BLOCKERS: none for the package gate. Installed-footprint verification remains separate. Forced recovery/respawn remains downstream and blocked because destination/time/cost authority is open.

OPEN_QUESTIONS: full installed-footprint measurement; Bleeding periodic HP magnitude; Braced/Guarded runtime; structural thresholds; Hunter escape geometry; recovery destination/time/costs; Monster escape/death; harvest/inventory/crafting/persistence.

IMPORTANT_DECISIONS:
- autorun is CI/development verification, not player-facing autoplay;
- no synthesized normal gameplay input or automatic locomotion;
- no new gameplay RNG or balance values;
- defeat final transition comes from a real hostile production attack;
- recovery/respawn remains excluded;
- total player-required game footprint hard cap is 2,000,000,000 bytes;
- package-size verification and installed-footprint verification are separate evidence layers.

KNOWN_RISKS: full hunt loop remains partial; Android export is not phone acceptance; no sustained-performance or installed-footprint evidence exists; structural/withdrawal/harvest/inventory/crafting remain incomplete.

FILES_CHANGED for defeat-terminal implementation:
- `game/tests/hunt01_basic_runtime_autorun_test.gd`;
- `tests/quality/hunt01/hunt01_basic_runtime_autorun_preflight.py`;
- `game/docs/HUNT01_BASIC_RUNTIME_AUTORUN_REGRESSION.md`.

STORAGE_POLICY_COMMIT: `f3b5dfb672127fa90303e689466f41a3cbe439ff`.
DEFEAT_TERMINAL_IMPLEMENTATION_SOURCE: `01a19b2811cfc5e3f9c0edb0e9264bc997161c7c`.

TESTS_RUN / TEST_RESULTS: run 84 `34880096112` SUCCESS verified authoritative/static gates, Godot 4.7.2 parse/import, production smokes/integration, both fresh-instance integrated cycles through terminal defeat, all current combat/anatomy/status/outcome regressions, Android debug export and artifact upload.

REPOSITORY_HEAD_AT_VERIFICATION: `01a19b2811cfc5e3f9c0edb0e9264bc997161c7c`.

ARTIFACT: ID `10362706279`; `UnnamedHuntRPG-Hunt01-MudcrestTailSweep-debug`; 57,536,941 bytes; SHA-256 `ba02d634d1435ed294f42bf5db8e2c55470265da4026aa1488e4b2ce30792917`.

EXTERNAL_REFERENCES: none required.

ASSUMPTIONS: no new gameplay semantics; current provisional runtime fixtures remain owned by existing production systems.

UNKNOWNS: phone acceptance, sustained performance, installed footprint, Bleeding periodic HP magnitude and post-defeat recovery.

READ_FIRST_NEXT_SLICE:
- `PERFORMANCE_BUDGETS_AND_CAPS.md`;
- `.github/workflows/production-hunt01-graybox-android.yml`;
- `game/export_presets.cfg`;
- run-84 APK size evidence;
- current build-readiness authority.
