#!/usr/bin/env python3
"""Static/source gate for the first Mudcrest Tail Sweep hostile attack slice."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ATTACK = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_attack_runtime.gd"
ANATOMY = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd"
HEALTH = ROOT / "game/scripts/gameplay/combat/hunt01_hunter_health_injury_runtime.gd"
CLASSIFIER = ROOT / "game/scripts/gameplay/monsters/monster_01/hunt01_mudcrest_wound_contact_runtime.gd"
REACTION = ROOT / "game/scripts/gameplay/combat/hunt01_reaction_window_runtime.gd"
TELEGRAPH = ROOT / "game/assets/effects/mudcrest_tail_sweep_telegraph.tscn"
TEST = ROOT / "game/tests/hunt01_mudcrest_tail_sweep_runtime_test.gd"
DOC = ROOT / "game/docs/HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME.md"
WORKFLOW = ROOT / ".github/workflows/pixel-rpg-ci.yml"
MONSTER_README = ROOT / "game/scripts/gameplay/monsters/monster_01/README.md"


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool) -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}")
        if not condition:
            failures.append(label)

    print("Hunt-01 Mudcrest Tail Sweep attack source preflight")
    for path in (ATTACK, ANATOMY, HEALTH, CLASSIFIER, REACTION, TELEGRAPH, TEST, DOC, WORKFLOW, MONSTER_README):
        check(f"required:{path.relative_to(ROOT)}", path.is_file())
    if failures:
        print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
        print("Gate: HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_SOURCE_STATIC_FAILED")
        return 1

    attack = ATTACK.read_text(encoding="utf-8")
    anatomy = ANATOMY.read_text(encoding="utf-8")
    health = HEALTH.read_text(encoding="utf-8")
    classifier = CLASSIFIER.read_text(encoding="utf-8")
    telegraph = TELEGRAPH.read_text(encoding="utf-8")
    test = TEST.read_text(encoding="utf-8")
    doc = DOC.read_text(encoding="utf-8")
    workflow = WORKFLOW.read_text(encoding="utf-8")
    monster_readme = MONSTER_README.read_text(encoding="utf-8")

    check("Tail Sweep identity exact", 'TAIL_SWEEP_ATTACK_ID := "M01_TAIL_SWEEP"' in attack and 'TAIL_SWEEP_CAPABILITY_ID := "CAP_M01_TAIL_SWEEP"' in attack)
    check("Tail Sweep exact economy is 3 AP / 18 Stamina", "TAIL_SWEEP_AP_COST := 3" in attack and "TAIL_SWEEP_STAMINA_COST := 18" in attack)
    check("Tail Sweep successful Block impact profile is 14 Stamina", "TAIL_SWEEP_STANDARD_BLOCK_IMPACT_DRAIN_STAMINA := 14" in attack)
    check("Tail Sweep is pure Impact", '"damage_channels": ["IMPACT"]' in attack and '"attack_profile": "TAIL_SWEEP_IMPACT"' in attack)
    check("Tail capability reads current anatomy without inventing sever threshold", 'get_target_state", "TAIL"' in attack and "PROVISIONAL_BASELINE_TAIL_DISTAL_ATTACHED_NO_SEVER_STATE_RUNTIME" in attack and "structural_threshold" not in attack)
    check("authored body/pivot/charge context is consumed", 'clearance["body_force"]' in attack and 'clearance["pivot"]' in attack and 'clearance["charge"]' in attack)
    check("N10-derived range and rear/flank fixtures are explicit", "TAIL_SWEEP_MAX_BODY_ENVELOPE_DISTANCE_M := 6.0" in attack and "TAIL_SWEEP_MAX_FORWARD_DOT := 0.25" in attack and "PROVISIONAL_AUTHORED_N10_FLANK_REACH_AND_BEARING_FIXTURE" in attack)
    check("pivot clearance uses real physics probes", "_tail_pivot_clearance" in attack and "CLEAR_AUTHORED_PIVOT_RADIUS" in attack and "PhysicsRayQueryParameters3D.create" in attack)
    check("Tail arc/full cover is a hard legality gate", "FULL_COVER_OR_BLOCKED_TAIL_SWEEP_ARC" in attack and "_line_of_effect()" in attack)
    check("Tail Sweep has deterministic priority before Head Sweep fallback", attack.find("var tail_legality := get_tail_sweep_legality()") >= 0 and attack.find("return _begin_tail_sweep(round_id, tail_legality)") < attack.find("return _begin_head_sweep(round_id)"))
    check("existing attack owner remains the only Monster activation driver", attack.count('register_monster_activation_driver", self') == 1)
    check("Tail cost commits through shell authority", '_shell.call("try_commit_cost", MONSTER_COMBATANT_ID, action_source_id, TAIL_SWEEP_AP_COST, TAIL_SWEEP_STAMINA_COST)' in attack)
    check("Tail Sweep opens the shared reaction window with Poleblade Block", 'open_window", MONSTER_COMBATANT_ID, TAIL_SWEEP_ATTACK_ID' in attack and 'allowed_reactions: Array[String] = [REACTION_POLEBLADE_BLOCK]' in attack)
    check("Tail Sweep uses the existing one FNV-1a variance boundary", "2166136261" in attack and "16777619" in attack and "_stable_variance(seed_key)" in attack)
    check("no engine/global RNG is added", all(token not in attack for token in ("randf(", "randi(", "RandomNumberGenerator", "randomize(")))
    check("Tail damage flows through existing defense owner", 'resolve_hostile_handoff", damage_handoff' in attack and "TAIL_SWEEP_STANDARD_BLOCK_IMPACT_DRAIN_STAMINA" in attack)
    check("Hunter health accepts both current Monster attacks without new balance constants", 'TAIL_SWEEP_ATTACK_ID := "M01_TAIL_SWEEP"' in health and "attack_id != HEAD_SWEEP_ATTACK_ID and attack_id != TAIL_SWEEP_ATTACK_ID" in health and "SOLID_BASE_LOAD := 8" in health)
    check("species classifier owns Tail Sweep status qualification", "resolve_tail_sweep_consequence" in classifier and "TAIL_SWEEP_SOLID_IMPACT_PROVISIONAL" in classifier)
    check("SOLID Tail Sweep may request only existing Off-Balance", "TAIL_SWEEP_SOLID_IMPACT_WITH_RESOLVED_INJURY" in classifier and '"status_id": STATUS_OFF_BALANCE' in classifier)
    check("CLEAN Tail Sweep emits exactly one generic Staggered request boundary", 'STATUS_STAGGERED := "status_staggered"' in classifier and "TAIL_SWEEP_CLEAN_IMPACT_STAGGERED_PROVISIONAL" in classifier and "_build_tail_staggered_request" in classifier and '"status_id": STATUS_STAGGERED' in classifier and '"application_mode": "APPLY_OR_REFRESH"' in classifier and '"intensity_delta": 0' in classifier and "staggered_request_pending_unimplemented" not in classifier)
    check("Tail Sweep emits no Bleeding path", '"source_action_id": TAIL_SWEEP_ATTACK_ID' in classifier and "TAIL_SWEEP_PROFILE" in classifier)
    check("classifier and attack contain no structural mutation", all(token not in attack + classifier for token in ("sever_part(", "break_part(", "detach_tail(", "apply_status(")))
    check("Tail telegraph is presentation-only/non-colliding", "QuadMesh" in telegraph and "CollisionShape3D" not in telegraph and "StaticBody3D" not in telegraph and "Area3D" not in telegraph)
    check("dedicated test reaches N10 through authored links", all(label in test for label in ("N01 -> N02 move succeeds", "N02 -> N05 move succeeds", "N05 -> N08 move succeeds", "N08 -> N10 move succeeds")))
    check("dedicated test verifies exact Tail economy and geometry", "Tail Sweep spends exactly 3 AP / 18 Stamina" in test and "Tail Sweep passes rear/flank bearing gate" in test and "real authored 8 m pivot clearance" in test)
    check("dedicated test verifies 14-Stamina impact drain", "Tail Sweep records and applies 14-Stamina Block impact drain" in test)
    check("dedicated test verifies Off-Balance and Staggered producer integration", "SOLID Tail Sweep emits exactly one Off-Balance request" in test and "CLEAN Tail Sweep emits one Staggered producer request" in test and "CLEAN replay does not refresh Staggered twice" in test)
    check("runtime doc records verified evidence and preserves provisional/sever/Staggered boundaries", "Status: IMPLEMENTED / STATIC VERIFIED / HEADLESS VERIFIED / ANDROID BUILD VERIFIED" in doc and "HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_SOURCE_STATIC_VERIFIED" in doc and "HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_RUNTIME_VERIFIED" in doc and "TAIL_DISTAL" in doc and "Staggered" in doc and "provisional" in doc.lower())
    check("Monster README records Tail Sweep verified ownership", "M01_TAIL_SWEEP" in monster_readme and "3 AP / 18 Stamina" in monster_readme and "TAIL SWEEP STATIC/HEADLESS/ANDROID BUILD VERIFIED" in monster_readme)
    check("canonical workflow discovers Tail Sweep static gate", 'find tests/quality/hunt01 -maxdepth 1 -type f -name "*_preflight.py"' in workflow and 'python3 "$test_file"' in workflow)
    check("canonical workflow discovers Tail Sweep headless gate", 'find game/tests -maxdepth 1 -type f -name "*_test.gd"' in workflow and 'godot --headless --path "$PROJECT_PATH" --script "$GITHUB_WORKSPACE/$test_file"' in workflow)
    check("workflow exports Pixel RPG Android artifact", "PixelRPG-debug-${{ github.sha }}" in workflow)

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    if failures:
        print("Gate: HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_SOURCE_STATIC_FAILED")
    else:
        print("Gate: HUNT01_MUDCREST_TAIL_SWEEP_ATTACK_SOURCE_STATIC_VERIFIED")
    print("This gate does not claim final Tail range/control balance, sever thresholds, forced displacement, phone acceptance or performance.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
