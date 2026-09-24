#!/usr/bin/env python3
"""Static/source gate for the first Hunter reaction-window runtime slice."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
README = ROOT / "game/scripts/gameplay/combat/README.md"
SHELL = ROOT / "game/scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd"
REACTION = ROOT / "game/scripts/gameplay/combat/hunt01_reaction_window_runtime.gd"
ENCOUNTER = ROOT / "game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd"
TEST = ROOT / "game/tests/hunt01_reaction_window_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_HUNTER_REACTION_WINDOW_RUNTIME.md"


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool) -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition:
            failures.append(label)

    print("Hunt-01 Hunter reaction-window source preflight")
    for path in (README, SHELL, REACTION, ENCOUNTER, TEST, DOC):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_HUNTER_REACTION_WINDOW_SOURCE_STATIC_FAILED")
        return 1

    readme = README.read_text(encoding="utf-8")
    shell = SHELL.read_text(encoding="utf-8")
    reaction = REACTION.read_text(encoding="utf-8")
    encounter = ENCOUNTER.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")

    check("reaction schema explicit", 'SCHEMA := "uhr.hunt01.reaction_window.v1"' in reaction)
    check("stable encounter/Hunter/Monster identities explicit", all(token in reaction for token in ('EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"', 'HUNTER_COMBATANT_ID := "hunter_player_0001"', 'MONSTER_COMBATANT_ID := "monster_r01_m01_0001"')))
    check("first supported reaction is Field Poleblade Block", 'REACTION_POLEBLADE_BLOCK := "POLEBLADE_BLOCK"' in reaction)
    check("Block commitment is exactly 1 RP + 6 Stamina", "BLOCK_RP_COST := 1" in reaction and "BLOCK_STAMINA_COST := 6" in reaction)
    check("Block cost authority remains explicit", "MONSTER_01_COMBAT_ATTACK_PACKET_RECORDED_FIELD_POLEBLADE_BLOCK_COMMITMENT" in reaction)
    check("window identity includes encounter/round/source/action/sequence", 'var window_id := "%s|R%d|%s|%s|A%d"' in reaction)
    check("overlapping reaction windows reject", "REACTION_WINDOW_ALREADY_ACTIVE" in reaction)
    check("closed-window readback is idempotent", "_closed_windows.has(window_id)" in reaction and 'closed["duplicate"] = true' in reaction)
    check("reaction commitment waits for hostile action resolution", "PENDING_ATTACK_DEFENSE_RESOLUTION" in reaction)
    check("decline path is explicit and free", 'REACTION_DECLINE := "DECLINE_REACTION"' in reaction and '"rp_cost"] = 0' in reaction and '"stamina_cost"] = 0' in reaction)
    check("shell exposes out-of-turn reaction resource commitment", "func try_commit_reaction_cost" in shell and "REACTION_RESOURCE_COMMITTED" in shell)
    check("reaction shell spend touches RP/Stamina but not AP", 'state["rp"] = int(state["rp"]) - rp_cost' in shell and 'state["stamina"] = int(state["stamina"]) - stamina_cost' in shell and 'state["ap"] = int(state["ap"]) - rp_cost' not in shell)
    check("shell validates source actor is current and reactor is out-of-turn", "_current_actor_id != source_actor_id or combatant_id == source_actor_id" in shell)
    check("shell makes per-window reaction resource commitment idempotent", 'var commit_key := "%s|%s" % [window_id, combatant_id]' in shell and "_reaction_commits.has(commit_key)" in shell)
    check("Monster activation driver handshake is explicit", "register_monster_activation_driver" in shell and "MONSTER_ACTIVATION_DELEGATED" in shell and "complete_external_activation" in shell)
    check("legacy Monster wait remains when no driver exists", "WAIT_NO_ATTACK_RUNTIME" in shell and "MONSTER_PLACEHOLDER_WAIT" in shell)
    check("encounter preloads reaction runtime", 'preload("res://scripts/gameplay/combat/hunt01_reaction_window_runtime.gd")' in encounter)
    check("encounter initializes reaction against same shell/record", 'reaction.call("initialize", _world, shell, _encounter_record)' in encounter)
    check("encounter exposes reaction runtime getter", "has_reaction_window_started" in encounter and "get_reaction_window_runtime" in encounter)
    check("reaction runtime uses no random source", all(token not in reaction for token in ("randf(", "randi(", "RandomNumberGenerator", "randomize(")))
    check("reaction prerequisite applies no health/anatomy damage", all(token not in reaction for token in ("apply_damage", "apply_damage_handoff", "health -=", "break_part(", "sever_part(", "apply_status(")))
    check("test holds a real Monster activation through shell driver", "MockMonsterActivationDriver" in test and "Monster remains current while external driver owns activation" in test)
    check("test verifies one RP + six Stamina exact spend", "out-of-turn Block leaves RP 0 and Stamina 94" in test)
    check("test verifies duplicate reaction does not double spend", "duplicate Block does not spend resources twice" in test)
    check("test verifies overlapping window rejection", "recursive/overlapping normal reaction window is rejected" in test)
    check("test verifies exhausted RP rejection and free decline", "Block is rejected when Hunter RP is exhausted" in test and "decline costs 0 RP / 0 Stamina" in test)
    check("test verifies anatomy is unchanged", "reaction prerequisite does not alter Mudcrest anatomy" in test)
    check("runtime README records reaction ownership", "hunt01_reaction_window_runtime.gd" in readme and "out-of-turn" in readme)
    check(
        "runtime doc keeps Monster damage outside reaction ownership",
        all(token in doc for token in ("This layer does not resolve:", "- Monster attack damage.", "hostile-action resolver and subsequent Hunter-damage owner")),
    )

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_HUNTER_REACTION_WINDOW_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_HUNTER_REACTION_WINDOW_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim Monster attack resolution, Hunter damage, phone acceptance or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
