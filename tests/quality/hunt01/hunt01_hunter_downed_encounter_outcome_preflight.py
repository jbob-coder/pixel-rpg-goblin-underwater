#!/usr/bin/env python3
"""Static/source gate for first Hunter Downed encounter-outcome runtime."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OUTCOME = ROOT / "game/scripts/gameplay/combat/hunt01_encounter_outcome_runtime.gd"
SHELL = ROOT / "game/scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd"
ATTACK = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd"
TEST = ROOT / "game/tests/hunt01_hunter_downed_encounter_outcome_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME.md"
README = ROOT / "game/scripts/gameplay/combat/README.md"
WORKFLOW = ROOT / ".github/workflows/production-hunt01-graybox-android.yml"


def main() -> int:
    failures=[]; checks=0
    def check(label, condition):
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition: failures.append(label)

    print("Hunt-01 Hunter Downed encounter-outcome source preflight")
    for path in (OUTCOME, SHELL, ATTACK, TEST, DOC, README, WORKFLOW):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        return 1

    outcome=OUTCOME.read_text(); shell=SHELL.read_text(); attack=ATTACK.read_text(); test=TEST.read_text(); doc=DOC.read_text(); readme=README.read_text(); workflow=WORKFLOW.read_text()
    check("outcome schema explicit", 'SCHEMA := "uhr.hunt01.encounter_outcome.v1"' in outcome)
    check("stable encounter Hunter Monster identities explicit", all(token in outcome for token in ('EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"', 'HUNTER_COMBATANT_ID := "hunter_player_0001"', 'MONSTER_COMBATANT_ID := "monster_r01_m01_0001"')))
    check("only pending Hunter defeat handoff accepted", 'PENDING_HUNTER_DEFEAT_OUTCOME_RUNTIME' in outcome and 'UNEXPECTED_HANDOFF_STATUS' in outcome and 'UNEXPECTED_ACTOR_ID' in outcome)
    check("selected DOWNED/HUNTERS_DEFEATED states explicit", 'PARTICIPATION_DOWNED := "DOWNED"' in outcome and 'OUTCOME_HUNTERS_DEFEATED := "HUNTERS_DEFEATED"' in outcome)
    check("living Monster explicitly preserved", 'LIVING_MONSTER_INSTANCE_PRESERVED' in outcome and '_participation_states[MONSTER_COMBATANT_ID] = PARTICIPATION_ACTIVE' in outcome)
    check("outcome owns no Health arithmetic, respawn, harvest or structural mutation", all(token not in outcome for token in ('health -=', 'apply_damage', 'respawn(', 'grant_harvest', 'sever_part', 'break_part')))
    check("shell exposes one terminal commit authority", 'func commit_terminal_outcome(' in shell and 'ENCOUNTER_TERMINAL_COMMITTED' in shell)
    check("shell removes remaining pending slots on termination", '"REMOVED"' in shell and '"ENCOUNTER_TERMINATED"' in shell and 'ROUND_SLOT_REMOVED' in shell)
    check("shell blocks scheduler and resource paths after terminal", all(token in shell for token in ('if _encounter_terminal:', 'func is_encounter_terminal()', 'func get_terminal_state()')))
    check("attack binds one generic outcome owner under shell", 'ENCOUNTER_OUTCOME_SCRIPT' in attack and 'outcome.name = "EncounterOutcomeRuntime"' in attack and '_shell.add_child(outcome)' in attack)
    wound_index = attack.find('_wound_contact.call("resolve_head_sweep_consequence"')
    close_index = attack.find('_reaction.call("close_window"')
    outcome_index = attack.find('_encounter_outcome.call("resolve_hunter_defeat_handoff"')
    complete_index = attack.find('_shell.call("complete_external_activation", MONSTER_COMBATANT_ID, "HEAD_SWEEP_DEFENSE_CONSEQUENCE_COMMITTED")')
    check("outcome waits for wound classification and reaction close", wound_index >= 0 and close_index > wound_index and outcome_index > close_index)
    check("outcome resolves before normal Monster completion", outcome_index >= 0 and complete_index > outcome_index)
    check("terminal outcome bypasses normal scheduler completion", 'if bool(outcome_consequence.get("encounter_terminal", false)):' in attack and 'return\n\tif not bool(_shell.call("complete_external_activation"' in attack)
    check("test uses real final Head Sweep after health preparation", 'preparation leaves Hunter at exactly 8 Health' in test and 'real Head Sweep supplied final zero-Health consequence' in test)
    check("test proves reaction closes and scheduler freezes", 'reaction window is closed before terminal freeze' in test and 'scheduler cannot advance to Round 3 after defeat' in test)
    check("test proves living Mudcrest anatomy preserved", 'living Mudcrest anatomy is not reset by Hunter defeat' in test)
    check("test proves replay idempotency", 'defeat replay cannot commit twice' in test)
    check("runtime doc records verified evidence and exclusions", 'Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED' in doc and 'HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_SOURCE_STATIC_VERIFIED' in doc and 'HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_VERIFIED' in doc and 'structural' in doc.lower() and 'Bleeding periodic HP' in doc)
    check("combat README records outcome owner", 'hunt01_encounter_outcome_runtime.gd' in readme)
    check("workflow runs outcome source/headless gates", 'hunt01_hunter_downed_encounter_outcome_preflight.py' in workflow and 'HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_SOURCE_STATIC_VERIFIED' in workflow and 'hunt01_hunter_downed_encounter_outcome_runtime_test.gd' in workflow and 'HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_RUNTIME_VERIFIED' in workflow)

    print(); print(f"Checks: {checks} | Passed: {checks-len(failures)} | Failed: {len(failures)}")
    print("Gate: " + ("HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_SOURCE_STATIC_VERIFIED" if not failures else "HUNT01_HUNTER_DOWNED_ENCOUNTER_OUTCOME_SOURCE_STATIC_FAILED"))
    print("This gate does not claim forced recovery/respawn, voluntary withdrawal, Monster escape/death, structural thresholds, harvest, Bleeding periodic HP, phone acceptance or performance.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
