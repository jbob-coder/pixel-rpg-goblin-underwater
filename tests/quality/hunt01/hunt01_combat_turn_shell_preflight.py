#!/usr/bin/env python3
"""Static/source gate for the Hunt-01 combat turn shell + adjacent tactical movement.

This verifies ownership/invariant source structure only. It does not imply Godot
runtime, Android device acceptance, attack/damage correctness or performance.
"""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
COMBAT_README = ROOT / "game/scripts/gameplay/combat/README.md"
COMBAT_RUNTIME = ROOT / "game/scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd"
MOVEMENT_RUNTIME = ROOT / "game/scripts/gameplay/combat/hunt01_tactical_movement_runtime.gd"
COMBAT_TEST = ROOT / "game/tests/hunt01_combat_turn_shell_runtime_test.gd"
ENCOUNTER_RUNTIME = ROOT / "game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd"


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool, detail: str = "") -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}{' :: ' + detail if detail else ''}")
        if not condition:
            failures.append(label)

    print("Hunt-01 combat turn-shell + tactical-movement source preflight")
    for path in (COMBAT_README, COMBAT_RUNTIME, MOVEMENT_RUNTIME, COMBAT_TEST, ENCOUNTER_RUNTIME):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())

    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_COMBAT_TURN_SHELL_SOURCE_STATIC_FAILED")
        return 1

    readme = COMBAT_README.read_text(encoding="utf-8")
    combat = COMBAT_RUNTIME.read_text(encoding="utf-8")
    movement = MOVEMENT_RUNTIME.read_text(encoding="utf-8")
    test = COMBAT_TEST.read_text(encoding="utf-8")
    encounter = ENCOUNTER_RUNTIME.read_text(encoding="utf-8")

    check("combat owner delegates species anatomy and defers structural/behavior layers", all(token in readme for token in ("game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd", "final damage/health arithmetic", "crack/break/sever", "status consequences", "Monster normal attack runtime")))
    check("adjacent tactical movement is explicitly owned now", "adjacent tactical-node movement" in readme)
    check("initiative fixture is explicitly provisional", "PROVISIONAL_CONTRACT_EXAMPLE_FIXTURE" in readme and "PROVISIONAL_CONTRACT_EXAMPLE_FIXTURE" in combat)
    check("encounter preloads combat shell", 'preload("res://scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd")' in encounter)
    check("encounter preloads tactical movement", 'preload("res://scripts/gameplay/combat/hunt01_tactical_movement_runtime.gd")' in encounter)
    check("encounter initializes combat shell after ENGAGE", "_start_combat_turn_shell" in encounter and 'shell.call("initialize", _world, _encounter_record)' in encounter)
    check("encounter initializes movement against same shell/record", 'movement.call("initialize", _world, shell, _encounter_record)' in encounter)
    check("stable encounter identity preserved", 'EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"' in combat and 'EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"' in movement)
    check("combat turn-shell schema explicit", 'SCHEMA := "uhr.hunt01.combat_turn_shell.v1"' in combat)
    check("tactical movement schema explicit", 'SCHEMA := "uhr.hunt01.tactical_movement.v1"' in movement)
    check("Hunter baseline is 4 AP / 1 RP", "HUNTER_MAX_AP := 4" in combat and "HUNTER_MAX_RP := 1" in combat)
    check("Hunter normalized Stamina reference is 100", "HUNTER_MAX_STAMINA := 100" in combat)
    check("Hunter passive recovery is +10", "HUNTER_PASSIVE_STAMINA_RECOVERY := 10" in combat)
    check("Monster normal activation budget is 4 AP", "MONSTER_MAX_AP := 4" in combat)
    check("initiative formula uses 2x Agility + Perception + modifier", '"initiative_rating": (2 * agility) + perception + modifier' in combat)
    check("contract-example tie fixture is explicit", all(token in combat for token in ("HUNTER_AGILITY_FIXTURE := 50", "HUNTER_PERCEPTION_FIXTURE := 40", "MONSTER_AGILITY_FIXTURE := 45", "MONSTER_PERCEPTION_FIXTURE := 50")))
    check("deterministic comparator uses rating/agility/perception/stable ID", all(token in combat for token in ("left_rating", "left_agility", "left_perception", "return a < b")))
    check("one-normal-activation invariant keys actor by round", 'var activation_key := "%d|%s" % [_round_id, combatant_id]' in combat and "INVARIANT_REJECTED_DUPLICATE_ACTIVATION" in combat)
    check("unused AP is discarded before next round", "UNUSED_AP_DISCARDED" in combat and 'state["ap"] = 0' in combat)
    check("Monster placeholder remains explicit until a real driver registers", "WAIT_NO_ATTACK_RUNTIME" in combat and "MONSTER_PLACEHOLDER_WAIT" in combat)
    check("external Monster activation path is bounded", "register_monster_activation_driver" in combat and "complete_external_activation" in combat)
    check("free exploration physics is locked after combat entry", "_world.set_physics_process(false)" in combat)
    check("exploration joystick is hidden in combat", 'get_node_or_null("HUD/Touch/MoveJoystick")' in combat and "joystick.visible = false" in combat)
    check("debug reset is disabled in combat", 'get_node_or_null("HUD/Touch/ResetToStart")' in combat and "reset_button.disabled = true" in combat)
    check("player-facing END TURN control exists", 'text = "END TURN"' in combat and "end_player_turn" in combat)
    check("resource commitment rejects unaffordable costs without negative resources", 'if int(state["ap"]) < ap_cost or int(state["stamina"]) < stamina_cost' in combat and "RESOURCE_COMMIT_REJECTED" in combat)

    check("movement reads the authoritative Hunt-01 manifest projection", 'MANIFEST_PATH := "res://content/regions/region_01/hunt01_graybox_build_manifest.json"' in movement)
    check("movement starts from authored N01 entry node", 'ENTRY_NODE_ID := "R01_EF02_N01"' in movement)
    check("adjacent move costs one AP", 'MOVE_AP_COST := 1' in movement)
    check("terrain movement surcharge table matches first-slice contract", all(token in movement for token in ('"STABLE_GROUND": 0', '"ROUGH_GROUND": 1', '"SHALLOW_WATER": 2', '"MUD": 3')))
    check("terrain footing map is explicit", all(token in movement for token in ("FOOTING_STABLE", "FOOTING_UNSTEADY", "FOOTING_COMPROMISED")))
    check("movement graph makes authored links bidirectional", '(_links[a] as Array).append(b)' in movement and '(_links[b] as Array).append(a)' in movement)
    check("non-adjacent destinations are a hard legality rejection", "NON_ADJACENT_DESTINATION" in movement)
    check("movement spends through combat shell resource authority", '_shell.call("try_commit_cost"' in movement)
    check("movement updates only Hunter X/Z to authored destination", 'Vector3(authored_position.x, previous_position.y, authored_position.z)' in movement)
    check("movement trace records terrain surcharge and footing", "terrain_stamina_surcharge" in movement and '"footing"' in movement and "TACTICAL_MOVE_COMMITTED" in movement)
    check("movement contains no independent random slip roll", all(token not in movement for token in ("randf", "randi", "RandomNumberGenerator", "slip_roll")))
    check("movement UI exposes authored adjacent destinations", "TacticalMovementPanel" in movement and "get_available_destinations" in movement)

    check("combat test covers duplicate activation and Round-2 refresh", "duplicate normal activation is rejected" in test and "Round 2 returns to Hunter" in test)
    check("combat test covers 10 nodes / 14 links", "10 authored tactical nodes" in test and "14 authored undirected links" in test)
    check("combat test covers stable and rough movement costs", "stable adjacent move costs exactly 1 AP + 0 Stamina" in test and "rough adjacent move adds +1 terrain Stamina" in test)
    check("combat test covers hard non-adjacent rejection", "non-adjacent N06 -> N10 move is rejected" in test)
    check("turn shell contains no attack/damage resolution", all(token not in combat for token in ("apply_damage", "resolve_attack", "damage_roll", "critical_roll", "sever_part", "break_part")))
    check("movement contains no attack/damage resolution", all(token not in movement for token in ("apply_damage", "resolve_attack", "damage_roll", "critical_roll", "sever_part", "break_part")))

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_COMBAT_TURN_SHELL_SOURCE_STATIC_FAILED")
        print("Gate: HUNT01_TACTICAL_MOVEMENT_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_COMBAT_TURN_SHELL_SOURCE_STATIC_VERIFIED")
        print("Gate: HUNT01_TACTICAL_MOVEMENT_SOURCE_STATIC_VERIFIED")
    print("This result does NOT imply headless runtime, Android APK, phone acceptance, attack resolution, or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
