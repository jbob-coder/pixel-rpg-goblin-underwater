#!/usr/bin/env python3
"""Static regression guard for the Stage-1 Monster placeholder collision repair.

This validates only source structure. It does not prove Godot runtime collision or
Galaxy A03s behavior.
"""

from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SCENE = ROOT / "scenes" / "probe_world.tscn"

EXPECTED = {
    '[sub_resource type="BoxShape3D" id="Shape_monster"]': "Monster collision BoxShape3D exists",
    'size = Vector3(2.5, 2.4, 5.8)': "Monster collider uses the representative Monster volume",
    '[node name="Monster" type="MeshInstance3D" parent="."]': "existing visual Monster node remains intact",
    '[node name="MonsterCollider" type="StaticBody3D" parent="."]': "solid physics body exists",
    'position = Vector3(0, 1.2, -5.5)': "visual/collider base position remains aligned",
    '[node name="CollisionShape3D" type="CollisionShape3D" parent="MonsterCollider"]': "Monster collider owns a collision shape",
    'shape = SubResource("Shape_monster")': "Monster collision shape is assigned",
}


def main() -> int:
    text = SCENE.read_text(encoding="utf-8")
    failures: list[str] = []

    print("Stage 1 Monster placeholder collision static preflight")
    for needle, label in EXPECTED.items():
        ok = needle in text
        print(f"[{'PASS' if ok else 'FAIL'}] {label} :: {needle}")
        if not ok:
            failures.append(label)

    monster_size_count = text.count('size = Vector3(2.5, 2.4, 5.8)')
    size_ok = monster_size_count >= 2
    print(f"[{'PASS' if size_ok else 'FAIL'}] visual/collision Monster volumes match :: count={monster_size_count}")
    if not size_ok:
        failures.append("visual/collision Monster volumes match")

    print()
    print(f"Checks: {len(EXPECTED) + 1} | Failed: {len(failures)}")
    print("Gate: MONSTER_COLLISION_STATIC_VERIFIED" if not failures else "Gate: MONSTER_COLLISION_STATIC_FAILED")
    print("This result does NOT imply Godot parse/APK/phone collision verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
