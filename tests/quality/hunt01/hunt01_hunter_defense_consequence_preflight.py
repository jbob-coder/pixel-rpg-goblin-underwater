#!/usr/bin/env python3
"""Static/source gate for the first Hunter defense-consequence slice."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
DEFENSE = ROOT / "game/scripts/gameplay/combat/hunt01_hunter_defense_consequence_runtime.gd"
ATTACK = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd"
TEST = ROOT / "game/tests/hunt01_hunter_defense_consequence_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME.md"
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

    print("Hunt-01 Hunter defense consequence source preflight")
    for path in (DEFENSE, ATTACK, TEST, DOC, WORKFLOW):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_HUNTER_DEFENSE_CONSEQUENCE_SOURCE_STATIC_FAILED")
        return 1

    defense = DEFENSE.read_text(encoding="utf-8")
    attack = ATTACK.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")
    workflow = WORKFLOW.read_text(encoding="utf-8")

    check("schema explicit", 'SCHEMA := "uhr.hunt01.hunter_defense_consequence.v1"' in defense)
    check("provisional Block fixture is named", "PROVISIONAL_FIRST_SLICE_POLEBLADE_BLOCK_OUTCOME_FIXTURE" in defense)
    check("stable hostile handoff is required", '"PENDING_HUNTER_DAMAGE_RUNTIME"' in defense and '"resolution_id"' in defense)
    check("stable resolution replay map exists", "_resolutions" in defense and "if _resolutions.has(resolution_id)" in defense)
    check("no-contact path is explicit", "HUNTER_DEFENSE_NO_CONTACT_RESOLVED" in defense and "NO_HUNTER_HEALTH_INJURY_CONSEQUENCE" in defense)
    check("Field Poleblade directional guard is exact", "FIELD_POLEBLADE_DIRECTIONAL_GUARD" in defense and "POLEBLADE_BLOCK" in defense)
    check("impact drain uses separate zero-RP shell transaction", "POLEBLADE_BLOCK_IMPACT_DRAIN" in defense and '"try_commit_reaction_cost"' in defense and "0," in defense)
    check("impact drain clamps to available Stamina", "mini(stamina_before, requested_drain)" in defense)
    check("all three generic Block outcomes are represented", all(token in defense for token in ('"BLOCK_STRONG"', '"BLOCK_PARTIAL"', '"BLOCK_BROKEN"')))
    check("CLEAN contact maps only through reversible fixture", 'hit_quality == "CLEAN"' in defense and "BLOCK_FIXTURE_STATUS" in defense)
    check("final health remains downstream", "PENDING_HUNTER_HEALTH_INJURY_RUNTIME" in defense and "NOT_SELECTED_PENDING_HUNTER_HEALTH_INJURY_RUNTIME" in defense)
    check("defense source contains no direct health arithmetic", all(token not in defense for token in ("health -=", "hp -=", "apply_damage(", '"damage_amount":')))
    check("defense source contains no status/forced movement/break-sever owner", all(token not in defense for token in ("apply_status(", "global_position =", "break_part(", "sever_part(")))
    check("Mudcrest attack instantiates generic defense owner", 'preload("res://scripts/gameplay/combat/hunt01_hunter_defense_consequence_runtime.gd")' in attack and "HunterDefenseConsequenceRuntime" in attack)
    resolve_index = attack.find('_hunter_defense.call("resolve_hostile_handoff", damage_handoff)')
    complete_index = attack.find('_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "HEAD_SWEEP_DEFENSE_CONSEQUENCE_COMMITTED")')
    check("Head Sweep consumes pending handoff before activation completion", resolve_index >= 0 and complete_index > resolve_index)
    check("Head Sweep exposes integrated defense runtime", "get_hunter_defense_runtime" in attack)
    check("dedicated headless test verifies 6+10 Stamina separation", "impact drain is separate from Block commitment" in test and "Round-3 passive recovery follows 6+10 Stamina defense spend" in test)
    check("dedicated test verifies idempotent replay", "replay cannot drain Stamina twice" in test)
    check("dedicated test verifies no-contact zero consequence", "no-contact hostile handoff resolves with zero consequence" in test)
    check("runtime doc preserves HP boundary", "PENDING_HUNTER_HEALTH_INJURY_RUNTIME" in doc and "final Hunter" in doc)
    check("workflow runs new static gate", "hunt01_hunter_defense_consequence_preflight.py" in workflow and "HUNT01_HUNTER_DEFENSE_CONSEQUENCE_SOURCE_STATIC_VERIFIED" in workflow)
    check("workflow runs new headless gate", "hunt01_hunter_defense_consequence_runtime_test.gd" in workflow and "HUNT01_HUNTER_DEFENSE_CONSEQUENCE_RUNTIME_VERIFIED" in workflow)

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_HUNTER_DEFENSE_CONSEQUENCE_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_HUNTER_DEFENSE_CONSEQUENCE_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim final Hunter HP/injury arithmetic, final balance, forced movement/status, other reactions, other Mudcrest attacks, phone acceptance or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
