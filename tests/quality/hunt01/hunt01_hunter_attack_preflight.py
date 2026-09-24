#!/usr/bin/env python3
"""Static/source gate for the first Hunt-01 Hunter Measured Cut runtime."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ATTACK = ROOT / "game/scripts/gameplay/combat/hunt01_hunter_attack_runtime.gd"
ENCOUNTER = ROOT / "game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd"
TEST = ROOT / "game/tests/hunt01_hunter_attack_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_FIRST_HUNTER_ATTACK_RUNTIME.md"


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool) -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition:
            failures.append(label)

    print("Hunt-01 first Hunter attack source preflight")
    for path in (ATTACK, ENCOUNTER, TEST, DOC):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_FIRST_HUNTER_ATTACK_SOURCE_STATIC_FAILED")
        return 1

    attack = ATTACK.read_text(encoding="utf-8")
    encounter = ENCOUNTER.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")

    check("attack schema explicit", 'SCHEMA := "uhr.hunt01.hunter_attack.v1"' in attack)
    check("Measured Cut technique identity explicit", 'TECHNIQUE_ID := "POLEBLADE_MEASURED_CUT"' in attack)
    check("Measured Cut spends 2 AP", "AP_COST := 2" in attack)
    check("Measured Cut spends 12 Stamina", "STAMINA_COST := 12" in attack)
    check("damage channel is CUTTING", 'DAMAGE_CHANNEL := "CUTTING"' in attack)
    check("body fallback is explicit", 'BODY_FALLBACK_POLICY := "ALLOW_BODY_FALLBACK"' in attack)
    check("hit-quality ceiling is CLEAN", 'HIT_QUALITY_CEILING := "CLEAN"' in attack)
    check("working-melee envelope is bounded at 3.5 m", "WORKING_MELEE_MAX_BODY_ENVELOPE_DISTANCE_M := 3.5" in attack)
    check("manifest body-force envelope is consumed", 'body_force: Dictionary = clearance["body_force"]' in attack)
    check("exact eight Mudcrest target groups are encoded", all(token in attack for token in ('"HEAD"', '"HORN_CREST"', '"FORELEG_L"', '"FORELEG_R"', '"HINDLEG_L"', '"HINDLEG_R"', '"DORSAL_PLATES"', '"TAIL"')))
    check("target penalties are explicit and bounded", "TARGET_CONTROL_PENALTY" in attack)
    check("local protection routing is explicit", "TARGET_PROTECTION" in attack and "MINERALIZED_DORSAL_PLATE" in attack and "HARD_HORN_STRUCTURE" in attack)
    check("Hunter activation ownership is validated", 'String(state.get("current_actor_id", "")) == HUNTER_COMBATANT_ID' in attack)
    check("range is hard legality before commitment", "OUT_OF_WORKING_MELEE" in attack)
    check("line of effect is physics-validated", "PhysicsRayQueryParameters3D.create" in attack and "FULL_COVER_OR_BLOCKED_LINE_OF_EFFECT" in attack)
    check("AP insufficiency is hard rejection", "INSUFFICIENT_AP" in attack)
    check("Stamina insufficiency is hard rejection", "INSUFFICIENT_STAMINA" in attack)
    check("combat shell remains resource authority", '_shell.call("try_commit_cost"' in attack)
    check("one stable FNV-1a bounded variance source exists", "FNV-1a" in attack and "2166136261" in attack and "16777619" in attack and "variance_sample" in attack)
    check("no engine/global RNG is used", all(token not in attack for token in ("randf(", "randi(", "RandomNumberGenerator", "randomize(")))
    check("contact classes distinguish miss/part/fallback", all(token in attack for token in ("NO_CONTACT", "SELECTED_PART_CONTACT", "BODY_CONTACT_OFF_TARGET")))
    check("hit-quality set is bounded to MISS/GRAZE/SOLID/CLEAN", all(token in attack for token in ('return "MISS"', 'return "GRAZE"', 'return "SOLID"', 'return "CLEAN"')) and 'return "PRECISION"' not in attack)
    check("control fixture is explicitly provisional", "PROVISIONAL_FIRST_SLICE_CONTROL_FIXTURE" in attack)
    check("pending anatomy handoff is built before species consequence", '"status": "PENDING_ANATOMY_DAMAGE_RUNTIME"' in attack)
    check("stable anatomy transaction identity is emitted", all(token in attack for token in ('"resolution_id"', '"encounter_id"', '"round_id"', '"action_sequence"', '"attacker_id"', '"defender_id"', '"technique_id"')))
    check("attack delegates consequence to injected anatomy owner", '_anatomy.call("apply_damage_handoff", damage_handoff)' in attack and '"anatomy_result"' in attack)
    check("attack runtime applies no direct health/anatomy arithmetic", all(token not in attack for token in ("health -=", "integrity -=", "break_part(", "sever_part(")))
    check("encounter preloads Hunter attack runtime", 'preload("res://scripts/gameplay/combat/hunt01_hunter_attack_runtime.gd")' in encounter)
    check("encounter initializes attack with same shell/movement/anatomy/record", 'attack.call("initialize", _world, shell, movement, anatomy, _encounter_record)' in encounter)
    check("test verifies range rejection", "Measured Cut is hard-illegal from N01" in test)
    check("test verifies three-step tactical approach to N09", "N01 -> N04 move succeeds" in test and "N07 -> N09 move succeeds" in test)
    check("test verifies 2 AP / 12 Stamina spend", "first attack spends exactly 2 AP / 12 Stamina" in test)
    check("test verifies selected-part contact", "Dorsal target acquires selected-part contact" in test)
    check("test verifies body fallback", "difficult Tail acquisition demonstrates body fallback" in test)
    check("test verifies no reroll on readback", "readback does not reroll committed attack/anatomy" in test)
    check("test verifies integrated Dorsal anatomy consequence", "Dorsal provisional integrity changes 100 -> 95" in test)
    check("test verifies anatomy replay does not double-apply", "replaying committed Dorsal handoff does not apply twice" in test)
    check("runtime doc records anatomy consumer integration", "Mudcrest anatomy integrity runtime" in doc and "PENDING_ANATOMY_DAMAGE_RUNTIME" in doc)

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_FIRST_HUNTER_ATTACK_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_FIRST_HUNTER_ATTACK_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim final damage balance, break/sever/status, Monster behavior, phone acceptance or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
