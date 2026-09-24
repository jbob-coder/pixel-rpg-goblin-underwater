#!/usr/bin/env python3
"""Static Stage-1 Android probe preflight.

This is intentionally NOT a Godot parser. It verifies repository-level invariants
that can be checked before Godot/editor/APK/device execution is available.

A PASS here means STATIC_PREFLIGHT_VERIFIED only.
It must never be used to claim GODOT_PARSE_VERIFIED, EDITOR_RUN_VERIFIED,
APK_BUILD_VERIFIED, PHONE_RUNTIME_VERIFIED, or PERFORMANCE_VERIFIED.
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FILES = (
    "project.godot",
    "scenes/boot.tscn",
    "scenes/probe_world.tscn",
    "scripts/boot.gd",
    "scripts/probe_world.gd",
    "docs/ANDROID_EXPORT_SETUP.md",
    "docs/PROBE_TEST_PROTOCOL.md",
    "docs/CONTROL_CAMERA_FOUNDATION_README.md",
    "README.md",
)

EXPECTED_GDSCRIPT_SOURCES = {
    "scripts/boot.gd",
    "scripts/probe_world.gd",
}

EXPECTED_PROJECT_TEXT = {
    'run/main_scene="res://scenes/boot.tscn"': "Boot is the configured main scene",
    'config/features=PackedStringArray("4.7", "GL Compatibility")': "Godot 4.7 + GL Compatibility feature request",
    "window/size/viewport_width=1600": "1600 logical viewport width",
    "window/size/viewport_height=720": "720 logical viewport height",
    "window/handheld/orientation=0": "landscape handheld orientation candidate",
    "window/frame_pacing/android/enable_frame_pacing=true": "Android frame pacing enabled",
    'renderer/rendering_method="gl_compatibility"': "desktop GL Compatibility renderer",
    'renderer/rendering_method.mobile="gl_compatibility"': "mobile GL Compatibility renderer",
}

EXPECTED_ROOT_EXTENDS = {
    "scenes/boot.tscn": ("Control", "scripts/boot.gd", "Control"),
    "scenes/probe_world.tscn": ("Node3D", "scripts/probe_world.gd", "Node3D"),
}

# User-directed Stage-1 control/camera foundation. These checks intentionally
# make silent reversion to the old arrow controls or removal of Look Speed fail
# static preflight. See docs/CONTROL_CAMERA_FOUNDATION_README.md.
EXPECTED_CONTROL_SCENE_TEXT = {
    '[node name="MoveJoystick" type="ColorRect" parent="HUD/Touch"]': "analog movement joystick exists",
    '[node name="Knob" type="ColorRect" parent="HUD/Touch/MoveJoystick"]': "joystick knob exists",
    '[node name="SettingsButton" type="Button" parent="HUD/Touch"]': "Settings button exists",
    '[node name="SettingsOverlay" type="PanelContainer" parent="HUD"]': "Settings overlay exists",
    '[node name="Tabs" type="TabContainer" parent="HUD/SettingsOverlay/Layout"]': "tabbed Settings structure exists",
    '[node name="Controls" type="VBoxContainer" parent="HUD/SettingsOverlay/Layout/Tabs"]': "Controls tab exists",
    '[node name="LookSpeed" type="HSlider" parent="HUD/SettingsOverlay/Layout/Tabs/Controls"]': "Look Speed slider exists",
    'method="_on_look_speed_changed"': "Look Speed signal remains connected",
}

FORBIDDEN_CONTROL_SCENE_TEXT = {
    '[node name="Up" type="Button" parent="HUD/Touch"]': "old Up arrow button must not return",
    '[node name="Down" type="Button" parent="HUD/Touch"]': "old Down arrow button must not return",
    '[node name="Left" type="Button" parent="HUD/Touch"]': "old Left arrow button must not return",
    '[node name="Right" type="Button" parent="HUD/Touch"]': "old Right arrow button must not return",
}

EXPECTED_CONTROL_SCRIPT_TEXT = {
    'const SETTINGS_PATH := "user://stage1_settings.cfg"': "settings persistence path remains stable",
    "const LOOK_SPEED_DEFAULT := 0.35": "calmer Look Speed default remains 35%",
    'config.set_value("controls", "look_speed", _look_speed)': "Look Speed persistence write remains present",
    'config.get_value("controls", "look_speed", LOOK_SPEED_DEFAULT)': "Look Speed persistence read remains present",
    "func _update_joystick_from_screen_position": "analog joystick processing remains present",
    "func _reset_joystick": "joystick release/reset path remains present",
    "func _capture_joystick_reference_heading": "per-touch heading reference capture remains present",
    "func _joystick_world_vector": "heading-relative joystick world mapping remains present",
    "_joystick_reference_forward * -_joystick_vector.y": "joystick forward intent uses captured Hunter heading",
    "_capture_joystick_reference_heading()": "joystick reference capture is invoked",
    "func _on_settings_pressed": "Settings open/close handler remains present",
    "func _on_look_speed_changed": "Look Speed handler remains present",
    "_update_aerial_camera(delta)": "aerial camera stays synchronized during both view modes",
}

RES_PATH_RE = re.compile(r'res://[A-Za-z0-9_./-]+')
EXT_RESOURCE_RE = re.compile(
    r'^\[ext_resource\s+type="(?P<type>[^"]+)"\s+path="(?P<path>res://[^"]+)"\s+id="(?P<id>[^"]+)"\]$',
    re.MULTILINE,
)
SUB_RESOURCE_DECL_RE = re.compile(
    r'^\[sub_resource\s+type="[^"]+"\s+id="(?P<id>[^"]+)"\]$',
    re.MULTILINE,
)
EXT_RESOURCE_USE_RE = re.compile(r'ExtResource\("([^"]+)"\)')
SUB_RESOURCE_USE_RE = re.compile(r'SubResource\("([^"]+)"\)')
NODE_RE = re.compile(
    r'^\[node\s+name="(?P<name>[^"]+)"\s+type="(?P<type>[^"]+)"(?:\s+parent="(?P<parent>[^"]+)")?\]$',
    re.MULTILINE,
)
CONNECTION_RE = re.compile(
    r'^\[connection\s+signal="(?P<signal>[^"]+)"\s+from="(?P<from>[^"]+)"\s+to="(?P<to>[^"]+)"\s+method="(?P<method>[^"]+)"\]$',
    re.MULTILINE,
)
ONREADY_PATH_RE = re.compile(r'@onready\s+var\s+\w+[^=]*=\s*\$([A-Za-z0-9_./-]+)')
FUNC_RE = re.compile(r'^func\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(', re.MULTILINE)
EXTENDS_RE = re.compile(r'^extends\s+([A-Za-z_][A-Za-z0-9_]*)\s*$', re.MULTILINE)


@dataclass
class Check:
    name: str
    ok: bool
    detail: str


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def res_to_rel(res_path: str) -> str:
    if not res_path.startswith("res://"):
        raise ValueError(res_path)
    return res_path[len("res://"):]


def duplicate_values(values: list[str]) -> list[str]:
    seen: set[str] = set()
    dupes: set[str] = set()
    for value in values:
        if value in seen:
            dupes.add(value)
        seen.add(value)
    return sorted(dupes)


def scene_nodes(text: str) -> tuple[str, dict[str, str]]:
    matches = list(NODE_RE.finditer(text))
    if not matches:
        return "", {}

    root_name = matches[0].group("name")
    nodes: dict[str, str] = {"": matches[0].group("type")}

    for match in matches[1:]:
        name = match.group("name")
        parent = match.group("parent")
        if parent is None:
            continue
        if parent == ".":
            path = name
        else:
            path = f"{parent}/{name}"
        nodes[path] = match.group("type")

    return root_name, nodes


def root_script_rel(scene_text: str) -> str | None:
    ext = {m.group("id"): m.group("path") for m in EXT_RESOURCE_RE.finditer(scene_text)}
    root_match = NODE_RE.search(scene_text)
    if not root_match:
        return None

    root_block_start = root_match.end()
    next_section = re.search(r'^\[', scene_text[root_block_start:], re.MULTILINE)
    root_block_end = root_block_start + (
        next_section.start() if next_section else len(scene_text) - root_block_start
    )
    root_block = scene_text[root_block_start:root_block_end]
    script_use = re.search(r'script\s*=\s*ExtResource\("([^"]+)"\)', root_block)
    if not script_use:
        return None

    path = ext.get(script_use.group(1))
    return res_to_rel(path) if path else None


def check_required_files(checks: list[Check]) -> None:
    for rel in REQUIRED_FILES:
        exists = (ROOT / rel).is_file()
        checks.append(Check(f"required:{rel}", exists, "exists" if exists else "missing"))


def check_project(checks: list[Check]) -> None:
    text = read("project.godot")
    for needle, label in EXPECTED_PROJECT_TEXT.items():
        checks.append(Check(f"project:{label}", needle in text, needle))

    for res_path in sorted(set(RES_PATH_RE.findall(text))):
        rel = res_to_rel(res_path)
        checks.append(Check(f"project-res:{res_path}", (ROOT / rel).is_file(), rel))


def check_scene(rel: str, checks: list[Check]) -> None:
    text = read(rel)

    node_matches = list(NODE_RE.finditer(text))
    root_matches = [m for m in node_matches if m.group("parent") is None]
    checks.append(
        Check(
            f"{rel}:single-root-node",
            len(root_matches) == 1,
            f"root-count={len(root_matches)}",
        )
    )

    root_name, nodes = scene_nodes(text)
    checks.append(Check(f"{rel}:root-node", bool(root_name), root_name or "no root node"))

    node_paths: list[str] = []
    for index, match in enumerate(node_matches):
        if index == 0 and match.group("parent") is None:
            path = ""
        else:
            parent = match.group("parent")
            if parent is None:
                path = f"<extra-root>/{match.group('name')}"
            elif parent == ".":
                path = match.group("name")
            else:
                path = f"{parent}/{match.group('name')}"
        node_paths.append(path)

    duplicate_node_paths = duplicate_values(node_paths)
    checks.append(
        Check(
            f"{rel}:duplicate-node-paths",
            not duplicate_node_paths,
            "none" if not duplicate_node_paths else ", ".join(duplicate_node_paths),
        )
    )

    all_node_paths = set(node_paths)
    for match in node_matches[1:]:
        parent = match.group("parent")
        parent_ok = parent == "." or (parent is not None and parent in all_node_paths)
        checks.append(
            Check(
                f"{rel}:parent:{parent}->{match.group('name')}",
                parent_ok,
                "parent exists" if parent_ok else "missing/invalid parent",
            )
        )

    ext_matches = list(EXT_RESOURCE_RE.finditer(text))
    ext_ids = [m.group("id") for m in ext_matches]
    duplicate_ext_ids = duplicate_values(ext_ids)
    checks.append(
        Check(
            f"{rel}:duplicate-ext-resource-ids",
            not duplicate_ext_ids,
            "none" if not duplicate_ext_ids else ", ".join(duplicate_ext_ids),
        )
    )
    ext_resources = {m.group("id"): m.group("path") for m in ext_matches}

    sub_matches = list(SUB_RESOURCE_DECL_RE.finditer(text))
    sub_ids = [m.group("id") for m in sub_matches]
    duplicate_sub_ids = duplicate_values(sub_ids)
    checks.append(
        Check(
            f"{rel}:duplicate-sub-resource-ids",
            not duplicate_sub_ids,
            "none" if not duplicate_sub_ids else ", ".join(duplicate_sub_ids),
        )
    )
    sub_resources = set(sub_ids)

    for ext_id, res_path in sorted(ext_resources.items()):
        target_rel = res_to_rel(res_path)
        checks.append(
            Check(
                f"{rel}:ext-resource:{ext_id}",
                (ROOT / target_rel).is_file(),
                f"{res_path} -> {target_rel}",
            )
        )

    for used_id in sorted(set(EXT_RESOURCE_USE_RE.findall(text))):
        checks.append(
            Check(
                f"{rel}:ext-use:{used_id}",
                used_id in ext_resources,
                "declared" if used_id in ext_resources else "missing declaration",
            )
        )

    for used_id in sorted(set(SUB_RESOURCE_USE_RE.findall(text))):
        checks.append(
            Check(
                f"{rel}:sub-use:{used_id}",
                used_id in sub_resources,
                "declared" if used_id in sub_resources else "missing declaration",
            )
        )

    script_rel = root_script_rel(text)
    checks.append(Check(f"{rel}:root-script", script_rel is not None, script_rel or "root script not found"))
    if script_rel is None or not (ROOT / script_rel).is_file():
        return

    script = read(script_rel)
    methods = set(FUNC_RE.findall(script))

    for match in CONNECTION_RE.finditer(text):
        from_path = match.group("from")
        to_path = match.group("to")
        method = match.group("method")
        from_ok = from_path == "." or from_path in nodes
        to_ok = to_path == "." or to_path in nodes
        method_ok = method in methods

        checks.append(Check(f"{rel}:connection-from:{from_path}", from_ok, match.group(0)))
        checks.append(Check(f"{rel}:connection-to:{to_path}", to_ok, match.group(0)))
        checks.append(Check(f"{rel}:connection-method:{method}", method_ok, script_rel))

    for node_path in sorted(set(ONREADY_PATH_RE.findall(script))):
        checks.append(
            Check(
                f"{script_rel}:onready:${node_path}",
                node_path in nodes,
                f"scene={rel}",
            )
        )

    for res_path in sorted(set(RES_PATH_RE.findall(script))):
        target_rel = res_to_rel(res_path)
        checks.append(
            Check(
                f"{script_rel}:res:{res_path}",
                (ROOT / target_rel).is_file(),
                target_rel,
            )
        )

    expected = EXPECTED_ROOT_EXTENDS.get(rel)
    if expected:
        expected_root_type, expected_script_rel, expected_extends = expected
        root_type = nodes.get("")
        actual_extends_match = EXTENDS_RE.search(script)
        actual_extends = actual_extends_match.group(1) if actual_extends_match else None

        checks.append(
            Check(
                f"{rel}:expected-root-type",
                root_type == expected_root_type,
                f"actual={root_type} expected={expected_root_type}",
            )
        )
        checks.append(
            Check(
                f"{rel}:expected-root-script",
                script_rel == expected_script_rel,
                f"actual={script_rel} expected={expected_script_rel}",
            )
        )
        checks.append(
            Check(
                f"{script_rel}:extends",
                actual_extends == expected_extends,
                f"actual={actual_extends} expected={expected_extends}",
            )
        )


def check_control_foundation(checks: list[Check]) -> None:
    scene = read("scenes/probe_world.tscn")
    script = read("scripts/probe_world.gd")

    for needle, label in EXPECTED_CONTROL_SCENE_TEXT.items():
        checks.append(Check(f"control-foundation:scene:{label}", needle in scene, needle))

    for needle, label in FORBIDDEN_CONTROL_SCENE_TEXT.items():
        checks.append(Check(f"control-foundation:no-legacy:{label}", needle not in scene, needle))

    for needle, label in EXPECTED_CONTROL_SCRIPT_TEXT.items():
        checks.append(Check(f"control-foundation:script:{label}", needle in script, needle))


def check_source_boundary(checks: list[Check]) -> None:
    gd_files = {
        path.relative_to(ROOT).as_posix()
        for path in ROOT.rglob("*.gd")
        if ".godot" not in path.parts
    }
    unexpected = sorted(gd_files - EXPECTED_GDSCRIPT_SOURCES)
    missing = sorted(EXPECTED_GDSCRIPT_SOURCES - gd_files)

    checks.append(
        Check(
            "probe-source-boundary:unexpected-gdscript",
            not unexpected,
            "none" if not unexpected else ", ".join(unexpected),
        )
    )
    checks.append(
        Check(
            "probe-source-boundary:expected-gdscript-present",
            not missing,
            "all present" if not missing else ", ".join(missing),
        )
    )


def main() -> int:
    checks: list[Check] = []

    try:
        check_required_files(checks)
        if not all((ROOT / rel).is_file() for rel in REQUIRED_FILES):
            raise FileNotFoundError("required file missing; dependent checks skipped")

        check_project(checks)
        check_scene("scenes/boot.tscn", checks)
        check_scene("scenes/probe_world.tscn", checks)
        check_control_foundation(checks)
        check_source_boundary(checks)
    except Exception as exc:
        checks.append(Check("preflight-internal", False, f"{type(exc).__name__}: {exc}"))

    failed = [check for check in checks if not check.ok]

    print("Stage 1 Android probe static preflight")
    print(f"Root: {ROOT}")
    for check in checks:
        status = "PASS" if check.ok else "FAIL"
        print(f"[{status}] {check.name} :: {check.detail}")

    print()
    print(f"Checks: {len(checks)} | Passed: {len(checks) - len(failed)} | Failed: {len(failed)}")
    print("Gate: STATIC_PREFLIGHT_VERIFIED" if not failed else "Gate: STATIC_PREFLIGHT_FAILED")
    print("This result does NOT imply Godot parse/editor/APK/phone/performance verification.")

    return 0 if not failed else 1


if __name__ == "__main__":
    raise SystemExit(main())
