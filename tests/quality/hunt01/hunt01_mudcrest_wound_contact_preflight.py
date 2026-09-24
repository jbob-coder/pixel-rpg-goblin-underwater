#!/usr/bin/env python3
"""Static/source gate for Mudcrest Head Sweep wound/contact classification."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
CLASSIFIER = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd"
ATTACK = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd"
TEST = ROOT / "game/tests/hunt01_mudcrest_wound_contact_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME.md"
WORKFLOW = ROOT / ".github/workflows/production-hunt01-graybox-android.yml"


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool) -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition:
            failures.append(label)

    print("Hunt-01 Mudcrest wound/contact source preflight")
    for path in (CLASSIFIER, ATTACK, TEST, DOC, WORKFLOW):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_MUDCREST_WOUND_CONTACT_SOURCE_STATIC_FAILED")
        return 1

    classifier = CLASSIFIER.read_text(encoding="utf-8")
    attack = ATTACK.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")
    workflow = WORKFLOW.read_text(encoding="utf-8")

    check("schema explicit", 'SCHEMA := "uhr.hunt01.mudcrest_wound_contact.v1"' in classifier)
    check("classification fixture explicitly provisional", "PROVISIONAL_FIRST_SLICE_HEAD_SWEEP_WOUND_CONTACT_CLASSIFICATION_FIXTURE" in classifier)
    check("stable resolution replay map exists", "_resolutions" in classifier and "if _resolutions.has(resolution_id)" in classifier)
    check("only Head Sweep is accepted", 'HEAD_SWEEP_ATTACK_ID := "M01_HEAD_SWEEP_GORE"' in classifier and "UNSUPPORTED_ATTACK_ID" in classifier)
    check("mixed channels alone do not automatically request both statuses", "HORN_PENETRATION_PROVISIONAL" in classifier and "IMPACT_DOMINANT_GUARD_FAILURE_PROVISIONAL" in classifier and "deliberately assigned to penetration rather than also claiming impact" in classifier)
    check("Bleeding request requires unguarded SOLID/CLEAN wound fixture", 'defense_outcome == "NO_ACTIVE_GUARD"' in classifier and '(hit_quality == "SOLID" or hit_quality == "CLEAN")' in classifier and "_build_bleeding_request" in classifier)
    check("Off-Balance request requires CLEAN partial/broken guard fixture", 'hit_quality == "CLEAN"' in classifier and 'block_outcome == "BLOCK_PARTIAL" or block_outcome == "BLOCK_BROKEN"' in classifier and "_build_off_balance_request" in classifier)
    check("Bleeding request is exactly +1", '"status_id": STATUS_BLEEDING' in classifier and '"intensity_delta": 1' in classifier)
    check("request consumer remains pending generic status runtime", "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME" in classifier)
    check("classifier applies no status", all(token not in classifier for token in ("apply_status(", "StatusInstance", "ROUND_END", "TURN_START_PRE_RECOVERY")))
    check("classifier mutates no health/resources/anatomy/position", all(token not in classifier for token in ("health -=", "_current_health", "try_commit_cost", "try_commit_reaction_cost", "apply_damage_handoff", "global_position =")))
    check("classifier uses no RNG", all(token not in classifier for token in ("randf(", "randi(", "RandomNumberGenerator", "randomize(")))
    check("attack preloads species classifier", 'preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd")' in attack)
    check("attack resolves classifier after defense", 'resolve_head_sweep_consequence", damage_handoff, defense_consequence' in attack and attack.index('resolve_hostile_handoff", damage_handoff') < attack.index('resolve_head_sweep_consequence", damage_handoff, defense_consequence'))
    check("attack attaches classification to stable resolution", '"wound_contact_classification": wound_contact.duplicate(true)' in attack)
    check("attack exposes classifier getter", "get_wound_contact_runtime" in attack)
    check("real production test verifies strong Block no-request", "SOLID strong Block makes no status request" in test)
    check("real production test verifies unguarded Bleeding request", "real unguarded wound emits one valid Bleeding +1 request" in test)
    check("test verifies CLEAN impact-dominant Off-Balance request", "impact-dominant CLEAN emits one Off-Balance request" in test)
    check("test verifies replay cannot mutate Hunter health", "classification replay still cannot mutate Hunter health" in test)
    check("runtime doc keeps status application downstream", "PENDING_GENERIC_STATUS_APPLICATION_RUNTIME" in doc and "does not apply" in doc.lower())
    check("workflow runs classifier static gate", "hunt01_mudcrest_wound_contact_preflight.py" in workflow and "HUNT01_MUDCREST_WOUND_CONTACT_SOURCE_STATIC_VERIFIED" in workflow)
    check("workflow runs classifier headless gate", "hunt01_mudcrest_wound_contact_runtime_test.gd" in workflow and "HUNT01_MUDCREST_WOUND_CONTACT_RUNTIME_VERIFIED" in workflow)

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_MUDCREST_WOUND_CONTACT_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_MUDCREST_WOUND_CONTACT_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim final contact/wound balance, status application/timing, defeat, structural break/sever, other Mudcrest attacks, phone acceptance or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
