#!/usr/bin/env python3
"""Static/source gate for first generic status timing/lifecycle runtime."""

from pathlib import Path
ROOT = Path(__file__).resolve().parents[3]
TIMING = ROOT / "game/scripts/gameplay/combat/hunt01_status_timing_runtime.gd"
STATUS = ROOT / "game/scripts/gameplay/combat/hunt01_status_application_runtime.gd"
SHELL = ROOT / "game/scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd"
CLASSIFIER = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd"
TEST = ROOT / "game/tests/hunt01_status_timing_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_GENERIC_STATUS_TIMING_RUNTIME.md"
README = ROOT / "game/scripts/gameplay/combat/README.md"
WORKFLOW = ROOT / ".github/workflows/pixel-rpg-ci.yml"

def main() -> int:
    failures=[]; checks=0
    def check(label, condition):
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition: failures.append(label)
    print("Hunt-01 generic status timing source preflight")
    for path in (TIMING, STATUS, SHELL, CLASSIFIER, TEST, DOC, README, WORKFLOW): check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures: return 1
    timing=TIMING.read_text(); status=STATUS.read_text(); shell=SHELL.read_text(); classifier=CLASSIFIER.read_text(); test=TEST.read_text(); doc=DOC.read_text(); readme=README.read_text(); workflow=WORKFLOW.read_text()
    check("timing schema explicit", 'SCHEMA := "uhr.hunt01.status_timing.v1"' in timing)
    check("three standardized hooks explicit", all(token in timing for token in ("on_turn_start_pre_recovery", "on_turn_end", "on_round_end")))
    check("shell timing driver registration bounded", "register_status_timing_driver" in shell and all(token in shell for token in ("on_turn_start_pre_recovery", "on_turn_end", "on_round_end")))
    check("TURN_START hook appears before passive recovery", shell.index('call("on_turn_start_pre_recovery"') < shell.index('state["stamina"] = mini'))
    check("TURN_END hook appears before slot ACTED", shell.index('call("on_turn_end"') < shell.index('_slot_states[ending_actor] = "ACTED"'))
    check("ROUND_END hook appears before begin next round", shell.index('call("on_round_end"') < shell.index('_begin_round()\n\t\t\treturn'))
    check("Staggered timing constant and transition are explicit", 'STATUS_STAGGERED := "status_staggered"' in timing and "transition_staggered_to_off_balance_for_timing" in timing)
    check("Staggered converts before Off-Balance is armed", timing.index("transition_staggered_to_off_balance_for_timing") < timing.index("arm_off_balance_expiry"))
    check("Staggered transition preserves normal activation", '"activation_policy": "CONTINUE_SAME_NORMAL_ACTIVATION"' in timing and '"transition_status_id": STATUS_OFF_BALANCE' in status)
    check("Off-Balance arms at turn start", "arm_off_balance_expiry" in timing and "expiry_armed_round" in status)
    check("Off-Balance removes only through armed timing mutation", "remove_off_balance_for_timing" in timing and "OFF_BALANCE_EXPIRY_NOT_ARMED_FOR_ROUND" in status)
    check("Bleeding first-tick gate explicit", "first_tick_round" in timing and "round_id < first_tick_round" in timing)
    check("Bleeding periodic event stable and pending", "PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE" in timing and "PERIODIC" in timing)
    check("Bleeding event marks instance round for idempotency", "mark_bleeding_periodic_event_emitted" in timing and "last_periodic_event_round" in status)
    check("periodic magnitude explicitly not selected", "NOT_SELECTED_PENDING_AUTHORITY" in timing)
    check("timing applies no Health damage", all(token not in timing for token in ("health -=", "apply_damage", "damage_amount", "resolve_health_handoff")))
    check("timing owns no resources/initiative/RNG", all(token not in timing for token in ("try_commit_cost", "try_commit_reaction_cost", "state[\"ap\"]", "state[\"rp\"]", "initiative_rating", "randf(", "randi(", "RandomNumberGenerator")))
    check("classifier boots one timing owner under shell", "STATUS_TIMING_SCRIPT" in classifier and 'timing_runtime.name = "StatusTimingRuntime"' in classifier and "shell.add_child(timing_runtime)" in classifier)
    check("classifier still contains no timing hook execution", all(token not in classifier for token in ("ROUND_END", "TURN_START_PRE_RECOVERY", 'call("on_turn_end"')))
    check("Tail Sweep CLEAN producer targets Staggered while timing remains generic", 'STATUS_STAGGERED := "status_staggered"' in classifier and "_build_tail_staggered_request" in classifier and "TAIL_SWEEP_CLEAN_IMPACT_STAGGERED_PROVISIONAL" in classifier and "staggered_request_pending_unimplemented" not in classifier)
    check("test proves real pending Bleeding event", "Round-4 emits exactly one pending Bleeding periodic consequence" in test)
    check("test proves no periodic Health mutation", "timing event does not mutate Hunter Health" in test)
    check("test proves Staggered exact-once conversion without turn skip", "Round 5 Hunter activation starts instead of being skipped" in test and "Round-5 TURN_START removes Staggered exactly once" in test and "duplicate Round-5 TURN_START is idempotent" in test)
    check("test proves converted Off-Balance uses same activation lifetime", "converted Off-Balance is armed for this same activation TURN_END" in test and "Off-Balance removed at armed TURN_END" in test)
    check("test proves hook ordering", all(token in test for token in ("TURN_START_PRE_RECOVERY timing precedes", "TURN_END timing precedes", "ROUND_END timing precedes")))
    check("test proves duplicate round-end idempotency", "duplicate Round-4 hook is idempotent" in test)
    check("runtime doc keeps Bleeding HP downstream", "PENDING_BLEEDING_PERIODIC_HEALTH_CONSEQUENCE" in doc and "not select" in doc.lower())
    check("combat README records timing owner", "hunt01_status_timing_runtime.gd" in readme)
    check("canonical workflow discovers timing source/headless gates", 'find tests/quality/hunt01 -maxdepth 1 -type f -name "*_preflight.py"' in workflow and 'python3 "$test_file"' in workflow and 'find game/tests -maxdepth 1 -type f -name "*_test.gd"' in workflow and 'godot --headless --path "$PROJECT_PATH" --script "$GITHUB_WORKSPACE/$test_file"' in workflow)
    print(); print(f"Checks: {checks} | Passed: {checks-len(failures)} | Failed: {len(failures)}")
    print("Gate: " + ("HUNT01_GENERIC_STATUS_TIMING_SOURCE_STATIC_VERIFIED" if not failures else "HUNT01_GENERIC_STATUS_TIMING_SOURCE_STATIC_FAILED"))
    print("This gate covers generic Staggered conversion plus existing Bleeding/Off-Balance timing and accepts the Tail Sweep CLEAN producer route; it does not claim Bleeding HP magnitude, Braced/Guarded runtime, structural damage, phone acceptance or performance verification.")
    return 0 if not failures else 1

if __name__ == "__main__": raise SystemExit(main())
