#!/usr/bin/env python3
"""Static/source gate for the first Hunter health/injury slice."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
HEALTH = ROOT / "game/scripts/gameplay/combat/hunt01_hunter_health_injury_runtime.gd"
DEFENSE = ROOT / "game/scripts/gameplay/combat/hunt01_hunter_defense_consequence_runtime.gd"
TEST = ROOT / "game/tests/hunt01_hunter_health_injury_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_HUNTER_HEALTH_INJURY_RUNTIME.md"
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

    print("Hunt-01 Hunter health/injury source preflight")
    for path in (HEALTH, DEFENSE, TEST, DOC, WORKFLOW):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_HUNTER_HEALTH_INJURY_SOURCE_STATIC_FAILED")
        return 1

    health = HEALTH.read_text(encoding="utf-8")
    defense = DEFENSE.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")
    workflow = WORKFLOW.read_text(encoding="utf-8")

    check("schema explicit", 'SCHEMA := "uhr.hunt01.hunter_health_injury.v1"' in health)
    check("normalized max-health fixture is explicit", "NORMALIZED_MAX_HEALTH := 100" in health and "PROVISIONAL_FIRST_SLICE_HUNTER_HEALTH_INJURY_FIXTURE" in health)
    check("missing authored Hunter armor is explicit", "PROVISIONAL_NO_AUTHORED_HUNTER_GAMEPLAY_ARMOR_PROFILE_RESIDUAL_FORCE_BASELINE" in health)
    check("stable pending health handoff is consumed", '"PENDING_HUNTER_HEALTH_INJURY_RUNTIME"' in health and '"resolution_id"' in health)
    check("resolution replay is idempotent", "_resolutions" in health and "if _resolutions.has(resolution_id)" in health)
    check("no-injury path is explicit", "NO_HUNTER_HEALTH_INJURY_CONSEQUENCE" in health and "HUNTER_HEALTH_NO_INJURY_RESOLVED" in health)
    check("hit-quality loads are bounded provisional values", all(token in health for token in ("GRAZE_BASE_LOAD := 4", "SOLID_BASE_LOAD := 8", "CLEAN_BASE_LOAD := 12")))
    check("defense residual mapping is bounded and explicit", all(token in health for token in ("BLOCK_STRONG_RESIDUAL_PERCENT := 25", "BLOCK_PARTIAL_RESIDUAL_PERCENT := 60", "BLOCK_BROKEN_RESIDUAL_PERCENT := 90", "NO_ACTIVE_GUARD_RESIDUAL_PERCENT := 100")))
    check("health clamps at zero", "_current_health = maxi(0, health_before - applied_load)" in health and "mini(health_before, requested_load)" in health)
    check("status application remains deferred", '"status_requests": []' in health and "DEFERRED_PENDING_DOMINANT_CHANNEL_AND_WOUND_CLASSIFICATION" in health)
    check("authorized status possibilities remain candidate-only", "status_bleeding" in health and "status_off_balance" in health and "BLOCKED_PENDING_" in health)
    check("zero health emits pending defeat handoff", "PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME" in health)
    check("health runtime contains no direct status application or defeat resolution", all(token not in health for token in ("apply_status(", "defeat_hunter(", "end_encounter(", "queue_free()")))
    check("health runtime contains no random source", all(token not in health for token in ("randf(", "randi(", "RandomNumberGenerator", "randomize(")))
    check("defense owner preloads health owner", 'preload("res://scripts/gameplay/combat/hunt01_hunter_health_injury_runtime.gd")' in defense)
    check("defense owner resolves health before returning hostile consequence", 'resolve_health_handoff", health_handoff' in defense and '"health_injury_consequence"' in defense)
    check("defense owner exposes health runtime", "get_hunter_health_runtime" in defense)
    check("dedicated test uses real production Head Sweep", "real Head Sweep resolves health before Monster activation completion" in test and "first real blocked Head Sweep applies 2 normalized injury" in test)
    check("dedicated test verifies replay/no-double injury", "health replay cannot apply injury twice" in test)
    check("dedicated test verifies zero clamp and pending defeat", "health clamps exactly at zero" in test and "pending defeat/outcome" in test)
    check("runtime doc preserves provisional balance boundary", "PROVISIONAL_FIRST_SLICE_HUNTER_HEALTH_INJURY_FIXTURE" in doc and "not final" in doc.lower())
    check("workflow runs new static gate", "hunt01_hunter_health_injury_preflight.py" in workflow and "HUNT01_HUNTER_HEALTH_INJURY_SOURCE_STATIC_VERIFIED" in workflow)
    check("workflow runs new headless gate", "hunt01_hunter_health_injury_runtime_test.gd" in workflow and "HUNT01_HUNTER_HEALTH_INJURY_RUNTIME_VERIFIED" in workflow)

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_HUNTER_HEALTH_INJURY_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_HUNTER_HEALTH_INJURY_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim final Max Health/damage/armor balance, status application, defeat resolution, other Mudcrest attacks, phone acceptance or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
