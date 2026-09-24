#!/usr/bin/env python3
"""Static/source gate for the first real Mudcrest Head Sweep hostile attack slice."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
MONSTER_README = ROOT / "game/scripts/gameplay/monsters/monster_01/README.md"
COMBAT_README = ROOT / "game/scripts/gameplay/combat/README.md"
ATTACK = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd"
ANATOMY = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd"
REACTION = ROOT / "game/scripts/gameplay/combat/hunt01_reaction_window_runtime.gd"
SHELL = ROOT / "game/scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd"
ENCOUNTER = ROOT / "game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd"
TELEGRAPH = ROOT / "game/assets/effects/mudcrest_head_sweep_telegraph.tscn"
TEST = ROOT / "game/tests/hunt01_mudcrest_head_sweep_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_RUNTIME.md"


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool) -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition:
            failures.append(label)

    print("Hunt-01 Mudcrest Head Sweep attack source preflight")
    for path in (MONSTER_README, COMBAT_README, ATTACK, ANATOMY, REACTION, SHELL, ENCOUNTER, TELEGRAPH, TEST, DOC):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_SOURCE_STATIC_FAILED")
        return 1

    monster_readme = MONSTER_README.read_text(encoding="utf-8")
    combat_readme = COMBAT_README.read_text(encoding="utf-8")
    attack = ATTACK.read_text(encoding="utf-8")
    encounter = ENCOUNTER.read_text(encoding="utf-8")
    telegraph = TELEGRAPH.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")

    check("Mudcrest attack schema explicit", 'SCHEMA := "uhr.hunt01.mudcrest_attack.v1"' in attack)
    check("Head Sweep identity exact", 'ATTACK_ID := "M01_HEAD_SWEEP_GORE"' in attack and 'CAPABILITY_ID := "CAP_M01_HEAD_ATTACK"' in attack)
    check("Head Sweep exact economy is 2 AP / 14 Stamina", "AP_COST := 2" in attack and "STAMINA_COST := 14" in attack)
    check("Field Poleblade Block is the first executable reaction", 'REACTION_POLEBLADE_BLOCK := "POLEBLADE_BLOCK"' in attack)
    check("selected Block impact profile records 10 Stamina", "STANDARD_BLOCK_IMPACT_DRAIN_STAMINA := 10" in attack)
    check("working-melee geometry boundary is explicit/provisional", "WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M := 3.5" in attack and "PROVISIONAL_FIRST_SLICE_MUDCREST_HEAD_SWEEP_CONTROL_FIXTURE" in attack)
    check("structural capability does not invent horn break from integrity", "PROVISIONAL_BASELINE_HEAD_HORNS_USABLE_NO_BREAK_STATE_RUNTIME" in attack and "get_target_state\", \"HORN_CREST" in attack)
    check("manifest body-force and authored charge forward reference are consumed", 'clearance["body_force"]' in attack and 'clearance["charge"]' in attack and "_authored_forward_xz" in attack)
    check("front/front-flank is a hard legality gate", "OUTSIDE_FRONT_OR_FRONT_FLANK" in attack and "bearing_dot < 0.0" in attack)
    check("full cover/blocked sweep path is a hard legality gate", "FULL_COVER_OR_BLOCKED_SWEEP_PATH" in attack and "PhysicsRayQueryParameters3D.create" in attack)
    check("Monster resources commit through shell authority", '_shell.call("try_commit_cost", MONSTER_COMBATANT_ID' in attack)
    check("one real Monster activation driver is registered", 'register_monster_activation_driver\", self' in attack and "begin_monster_activation" in attack)
    check("driver registration is deferred until stack wiring settles", 'call_deferred("_register_activation_driver")' in attack)
    check("out-of-range first-slice driver completes rather than inventing another attack", "MUDCREST_HEAD_SWEEP_SKIPPED" in attack and "WAIT_NO_ATTACK_RUNTIME" in attack)
    check("authoritative telegraph opens shared reaction window", '_reaction.call(' in attack and '"open_window"' in attack and "MUDCREST_HEAD_SWEEP_TELEGRAPH_EMITTED" in attack)
    check("telegraph visual is a non-colliding presentation asset", "QuadMesh" in telegraph and "CollisionShape3D" not in telegraph and "StaticBody3D" not in telegraph)
    check("telegraph visual is lifecycle-owned by hostile transaction", "hunt01_monster_attack_telegraph" in attack and "_hide_telegraph_visual" in attack)
    check("one stable FNV-1a bounded variance sample exists", "2166136261" in attack and "16777619" in attack and "FNV-1a" in attack)
    check("no engine/global RNG is used", all(token not in attack for token in ("randf(", "randi(", "RandomNumberGenerator", "randomize(")))
    check("bounded hit-quality set is MISS/GRAZE/SOLID/CLEAN", all(token in attack for token in ('return "MISS"', 'return "GRAZE"', 'return "SOLID"', 'return "CLEAN"')) and 'return "PRECISION"' not in attack)
    check("Block affects provisional DefenseControl without fabricating final guard class", "PROVISIONAL_BLOCK_DEFENSE_CONTROL_BONUS" in attack and "PENDING_FINAL_BLOCK_OUTCOME_RUNTIME" in attack)
    check("hostile contact routes through guard or pending Hunter body protection", "FIELD_POLEBLADE_DIRECTIONAL_GUARD" in attack and "HUNTER_BODY_PROTECTION_PENDING_RUNTIME" in attack)
    check("stable pending Hunter-damage handoff is emitted", '"status": "PENDING_HUNTER_DAMAGE_RUNTIME"' in attack and '"resolution_id"' in attack and '"attacker_id": MONSTER_COMBATANT_ID' in attack)
    check("final Hunter HP arithmetic is absent", all(token not in attack for token in ("health -=", "hp -=", '"damage_amount":', "apply_damage(")))
    check("structural/status/defeat/harvest consequences remain absent", all(token not in attack for token in ("break_part(", "sever_part(", "apply_status(", "defeat_monster", "harvest_part")))
    check("encounter preloads species attack owner", 'preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd")' in encounter)
    check("encounter initializes attack with shell/reaction/anatomy/record", 'mudcrest_attack.call("initialize", _world, shell, reaction, anatomy, _encounter_record)' in encounter)
    check("encounter exposes Mudcrest attack runtime", "has_mudcrest_attack_started" in encounter and "get_mudcrest_attack_runtime" in encounter)
    check("test verifies real out-of-range no-attack path", "out-of-range Head Sweep does not stall scheduler" in test)
    check("test reaches N09 through authored tactical movement", "N01 -> N04 move succeeds" in test and "N07 -> N09 move succeeds" in test)
    check("test verifies exact 2 AP / 14 Stamina spend", "Head Sweep spends exactly 2 AP / 14 Stamina" in test)
    check("test verifies physical range/bearing/cover legality", "body-envelope gate" in test and "front/front-flank bearing gate" in test and "physical line/cover gate" in test)
    check("test verifies visual telegraph lifecycle", "authoritative visual telegraph is present during reaction" in test and "telegraph visual disappears after resolution" in test)
    check("test verifies Block and explicit decline", "Field Poleblade Block commits against Head Sweep" in test and "explicit decline is accepted" in test)
    check("test verifies pending damage rather than invented HP", "stable pending Hunter-damage handoff is emitted" in test and "final Hunter damage amount is not invented" in test)
    check("Monster package README records attack ownership", "hunt01_mudcrest_attack_runtime.gd" in monster_readme and "M01_HEAD_SWEEP_GORE" in monster_readme)
    check("generic combat README keeps reaction ownership separate", "hunt01_reaction_window_runtime.gd" in combat_readme and "species-owned" in combat_readme)
    check("runtime doc names pending damage boundary", "PENDING_HUNTER_DAMAGE_RUNTIME" in doc and "2 AP / 14 Stamina" in doc)

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_MUDCREST_HEAD_SWEEP_ATTACK_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim final Hunter HP damage, final Block outcome, break/sever/status, other Mudcrest attacks, behavior, phone acceptance or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
