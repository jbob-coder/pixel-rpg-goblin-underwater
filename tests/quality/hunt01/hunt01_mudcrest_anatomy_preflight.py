#!/usr/bin/env python3
"""Static/source gate for the first Mudcrest anatomy-integrity runtime slice."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ANATOMY = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd"
PACKAGE_README = ROOT / "game/scripts/gameplay/monsters/monster_01/README.md"
ENCOUNTER = ROOT / "game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd"
ATTACK = ROOT / "game/scripts/gameplay/combat/hunt01_hunter_attack_runtime.gd"
TEST = ROOT / "game/tests/hunt01_mudcrest_anatomy_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_MUDCREST_ANATOMY_INTEGRITY_RUNTIME.md"


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool) -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition:
            failures.append(label)

    print("Hunt-01 Mudcrest anatomy-integrity source preflight")
    for path in (ANATOMY, PACKAGE_README, ENCOUNTER, ATTACK, TEST, DOC):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_MUDCREST_ANATOMY_INTEGRITY_SOURCE_STATIC_FAILED")
        return 1

    anatomy = ANATOMY.read_text(encoding="utf-8")
    package_readme = PACKAGE_README.read_text(encoding="utf-8")
    encounter = ENCOUNTER.read_text(encoding="utf-8")
    attack = ATTACK.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")

    check("anatomy schema explicit", 'SCHEMA := "uhr.hunt01.mudcrest_anatomy.v1"' in anatomy)
    check("stable encounter and Monster identities explicit", 'EXPECTED_ENCOUNTER_ID := "enc_r01_ef02_m01_0001"' in anatomy and 'MONSTER_ID := "monster_r01_m01_0001"' in anatomy)
    check("normalized integrity fixture is explicit", "NORMALIZED_MAX_INTEGRITY := 100" in anatomy and "PROVISIONAL_FIRST_SLICE_ANATOMY_INTEGRITY_FIXTURE" in anatomy)
    check("exact eight player groups plus torso fallback are encoded", all(token in anatomy for token in ('"HEAD"', '"HORN_CREST"', '"FORELEG_L"', '"FORELEG_R"', '"HINDLEG_L"', '"HINDLEG_R"', '"DORSAL_PLATES"', '"TAIL"', '"GENERAL_TORSO"')))
    check("local protection must match resolved anatomy target", "EXPECTED_PROTECTION" in anatomy and "PROTECTION_PROFILE_MISMATCH" in anatomy)
    check("cutting fixture distinguishes hard protection from hide", "CUTTING_PROTECTION_REDUCTION_FIXTURE" in anatomy and '"HARD_HORN_STRUCTURE": 8' in anatomy and '"MINERALIZED_DORSAL_PLATE": 7' in anatomy and '"HIDE_TORSO": 1' in anatomy)
    check("one stable resolution ID guards application", "resolution_id" in anatomy and "DUPLICATE_RESOLUTION_NO_REAPPLY" in anatomy)
    check("resolution-ID collisions are rejected", "RESOLUTION_ID_COLLISION" in anatomy and "source_fingerprint" in anatomy)
    check("anatomy consumes only pending committed handoff", '"PENDING_ANATOMY_DAMAGE_RUNTIME"' in anatomy and "HANDOFF_STATUS_NOT_PENDING" in anatomy)
    check("anatomy does not reroll contact", all(token not in anatomy for token in ("randf(", "randi(", "RandomNumberGenerator", "randomize(", "control_margin", "PART_ACQUISITION_MARGIN")))
    check("runtime has no global health/death arithmetic", all(token not in anatomy for token in ("health -=", "max_health", "death_state", "kill_monster")))
    check("runtime has no break/sever/status implementation", all(token not in anatomy for token in ("break_part(", "sever_part(", "apply_bleed(", "apply_status(")))
    check(
        "structural thresholds remain explicitly deferred",
        "NOT_EVALUATED_BREAK_SEVER_DEFERRED" in anatomy
        and "does not yet own crack/break/sever structural states" in package_readme
        and "numeric sever thresholds remain open" in package_readme
        and "structural crack/break/sever thresholds" in package_readme,
    )
    check("encounter preloads species anatomy runtime", 'preload("res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd")' in encounter)
    check("encounter initializes anatomy before Hunter attack", 'anatomy.call("initialize", _world, _encounter_record)' in encounter and 'attack.call("initialize", _world, shell, movement, anatomy, _encounter_record)' in encounter)
    check("Hunter attack emits stable anatomy transaction identity", all(token in attack for token in ('"resolution_id"', '"encounter_id"', '"round_id"', '"action_sequence"', '"attacker_id"', '"defender_id"', '"technique_id"')))
    check("Hunter attack delegates integrity consequence once", '_anatomy.call("apply_damage_handoff", damage_handoff)' in attack)
    check("Hunter attack retains anatomy result in committed resolution", '"anatomy_result"' in attack and "ANATOMY_APPLICATION_FAILED" in attack)
    check("unit test covers 100 -> 95 Dorsal fixture", "Dorsal integrity becomes 95 only" in test)
    check("unit test covers duplicate idempotence", "duplicate resolution is idempotent" in test and "does not reduce Dorsal integrity twice" in test)
    check("unit test covers torso body fallback integrity", "body-fallback torso contact is a first-class integrity target" in test)
    check("unit test covers protection mismatch rejection", "mismatched local protection is rejected" in test)
    check("runtime doc labels fixture provisional", "PROVISIONAL_FIRST_SLICE_ANATOMY_INTEGRITY_FIXTURE" in doc and "not final" in doc.lower())

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_MUDCREST_ANATOMY_INTEGRITY_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_MUDCREST_ANATOMY_INTEGRITY_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim final damage balance, break/sever/status, Monster behavior, phone acceptance or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
