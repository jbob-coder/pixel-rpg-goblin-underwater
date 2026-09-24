#!/usr/bin/env python3
"""Static regression guard for Stage-1 outer world-boundary containment.

The arena was deliberately enlarged after direct phone feedback that the prior
20 x 20 m probe was too small for sustained adaptive-steering tests. A PASS here
checks source geometry/bounds only; it does not replace current-APK phone testing.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT_PATH = ROOT / "scripts" / "probe_world.gd"
SCENE_PATH = ROOT / "scenes" / "probe_world.tscn"

EXPECTED_BOUND_M = 56.0
EXPECTED_FLOOR_M = 120.0

BOUND_RE = re.compile(r"^const PROBE_BOUNDS := (?P<value>\d+(?:\.\d+)?)$", re.MULTILINE)
FLOOR_SIZE_RE = re.compile(
    r'\[sub_resource type="BoxMesh" id="Mesh_floor"\]\s+material = SubResource\("Mat_floor"\)\s+size = Vector3\((?P<x>\d+(?:\.\d+)?),\s*(?P<y>\d+(?:\.\d+)?),\s*(?P<z>\d+(?:\.\d+)?)\)',
    re.MULTILINE,
)
FLOOR_COLLIDER_RE = re.compile(
    r'\[sub_resource type="BoxShape3D" id="Shape_floor"\]\s+size = Vector3\((?P<x>\d+(?:\.\d+)?),\s*(?P<y>\d+(?:\.\d+)?),\s*(?P<z>\d+(?:\.\d+)?)\)',
    re.MULTILINE,
)
HUNTER_RADIUS_RE = re.compile(
    r'\[sub_resource type="CapsuleShape3D" id="Shape_hunter"\]\s+radius = (?P<radius>\d+(?:\.\d+)?)',
    re.MULTILINE,
)

REQUIRED_SCRIPT_LINES = (
    "hunter.move_and_slide()",
    "var bounded_position := hunter.global_position",
    "bounded_position.x = clampf(bounded_position.x, -PROBE_BOUNDS, PROBE_BOUNDS)",
    "bounded_position.z = clampf(bounded_position.z, -PROBE_BOUNDS, PROBE_BOUNDS)",
    "hunter.global_position = bounded_position",
)


def report(label: str, ok: bool, detail: str, failures: list[str]) -> None:
    print(f"[{'PASS' if ok else 'FAIL'}] {label} :: {detail}")
    if not ok:
        failures.append(label)


def main() -> int:
    script = SCRIPT_PATH.read_text(encoding="utf-8")
    scene = SCENE_PATH.read_text(encoding="utf-8")
    failures: list[str] = []

    print("Stage 1 enlarged-arena world-boundary static regression guard")

    bound_match = BOUND_RE.search(script)
    report("PROBE_BOUNDS constant exists", bound_match is not None, bound_match.group(0) if bound_match else "missing", failures)
    bound = float(bound_match.group("value")) if bound_match else float("nan")
    report("enlarged movement bound is 56 m", bound == EXPECTED_BOUND_M, f"value={bound}", failures)

    positions: list[int] = []
    for line in REQUIRED_SCRIPT_LINES:
        index = script.find(line)
        report(f"boundary source line present: {line}", index >= 0, f"index={index}", failures)
        positions.append(index)

    order_ok = all(index >= 0 for index in positions) and positions == sorted(positions)
    report("boundary clamp executes after move_and_slide", order_ok, f"indices={positions}", failures)
    report("boundary remains horizontal-only", "bounded_position.y = clampf" not in script, "Y not hard-clamped", failures)

    floor_match = FLOOR_SIZE_RE.search(scene)
    collider_match = FLOOR_COLLIDER_RE.search(scene)
    radius_match = HUNTER_RADIUS_RE.search(scene)
    report("probe floor dimensions are parseable", floor_match is not None, floor_match.group(0) if floor_match else "missing", failures)
    report("probe floor collider dimensions are parseable", collider_match is not None, collider_match.group(0) if collider_match else "missing", failures)
    report("Hunter collision radius is parseable", radius_match is not None, radius_match.group(0) if radius_match else "missing", failures)

    if floor_match and collider_match:
        floor_x = float(floor_match.group("x"))
        floor_z = float(floor_match.group("z"))
        collider_x = float(collider_match.group("x"))
        collider_z = float(collider_match.group("z"))
        report("visual floor enlarged to 120 x 120 m", floor_x == EXPECTED_FLOOR_M and floor_z == EXPECTED_FLOOR_M, f"floor={floor_x}x{floor_z}", failures)
        report("floor collider matches visual floor", collider_x == floor_x and collider_z == floor_z, f"collider={collider_x}x{collider_z}", failures)

    if floor_match and radius_match and bound_match:
        floor_x = float(floor_match.group("x"))
        floor_z = float(floor_match.group("z"))
        hunter_radius = float(radius_match.group("radius"))
        margin_x = floor_x * 0.5 - bound
        margin_z = floor_z * 0.5 - bound
        fits = margin_x >= hunter_radius and margin_z >= hunter_radius
        report("boundary keeps Hunter safely inside floor", fits, f"margin_x={margin_x:.3f}, margin_z={margin_z:.3f}, hunter_radius={hunter_radius:.3f}", failures)
        report("usable bounded span is at least 110 m per axis", bound * 2.0 >= 110.0, f"span={bound * 2.0:.1f} m", failures)

    print()
    print(f"Failed: {len(failures)}")
    print("Gate: WORLD_BOUNDARY_STATIC_VERIFIED" if not failures else "Gate: WORLD_BOUNDARY_STATIC_FAILED")
    print("This result does NOT imply current-APK phone containment verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
