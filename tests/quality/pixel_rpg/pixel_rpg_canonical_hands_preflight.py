#!/usr/bin/env python3
from pathlib import Path
import hashlib
import struct

ROOT = Path(__file__).resolve().parents[3]
ASSET_DIR = ROOT / "game/assets/characters/first_person"
PNG = ASSET_DIR / "pixel_rpg_hunter_fp_hands_neutral_r001.png"
HASH_FILE = ASSET_DIR / "CANONICAL_HANDS_SOURCE.sha256"
RULE = ASSET_DIR / "CANONICAL_HANDS_RUNTIME_RULE.md"
LEGACY_SVG = ASSET_DIR / "pixel_rpg_hunter_fp_hands_neutral_r001_runtime.svg"
VIEWMODEL = ROOT / "game/assets/characters/first_person_viewmodel_01.tscn"
RUNTIME_TEST = ROOT / "game/tests/pixel_rpg_visual_pack_009_first_person_viewmodel_test.gd"

EXPECTED_SHA256 = "7c310f85978f300a0be4f2fe4ab6a9e0439bbf2daf1c0883e014f6179ff509a4"
EXPECTED_SIZE = 28113

failures = []
checks = 0

def check(label, condition, detail=""):
    global checks
    checks += 1
    suffix = f" :: {detail}" if detail else ""
    print(f"[{'PASS' if condition else 'FAIL'}] {label}{suffix}")
    if not condition:
        failures.append(label)

print("Pixel RPG canonical first-person hands preflight")

for path in (PNG, HASH_FILE, RULE, VIEWMODEL, RUNTIME_TEST):
    check(f"required:{path.relative_to(ROOT)}", path.is_file())

if PNG.is_file():
    raw = PNG.read_bytes()
    digest = hashlib.sha256(raw).hexdigest()
    check("canonical PNG byte size is exact", len(raw) == EXPECTED_SIZE, str(len(raw)))
    check("canonical PNG SHA-256 is exact", digest == EXPECTED_SHA256, digest)
    signature = bytes([137, 80, 78, 71, 13, 10, 26, 10])
    check("canonical source has PNG signature", raw[:8] == signature)
    if len(raw) >= 26 and raw[12:16] == b"IHDR":
        width, height = struct.unpack(">II", raw[16:24])
        color_type = raw[25]
        check("canonical PNG dimensions are 640x360", (width, height) == (640, 360), f"{width}x{height}")
        check("canonical PNG uses RGBA color type", color_type == 6, str(color_type))
    else:
        check("canonical PNG IHDR is readable", False)

if HASH_FILE.is_file():
    manifest = HASH_FILE.read_text(encoding="utf-8").strip()
    check("hash manifest records exact SHA-256", manifest.startswith(EXPECTED_SHA256), manifest)
    check("hash manifest names canonical PNG", manifest.endswith("pixel_rpg_hunter_fp_hands_neutral_r001.png"), manifest)

if VIEWMODEL.is_file():
    viewmodel = VIEWMODEL.read_text(encoding="utf-8")
    check("viewmodel references exact canonical PNG", "res://assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png" in viewmodel)
    check("viewmodel does not reference superseded SVG", "pixel_rpg_hunter_fp_hands_neutral_r001_runtime.svg" not in viewmodel)
    check("viewmodel keeps nearest texture filtering", "texture_filter = 0" in viewmodel)
    check("procedural hand placeholders are absent", all(name not in viewmodel for name in ("LeftForearm", "LeftBracer", "LeftHand", "RightForearm", "RightBracer", "RightHand")))

if RUNTIME_TEST.is_file():
    runtime_test = RUNTIME_TEST.read_text(encoding="utf-8")
    check("runtime test requires canonical PNG path", 'HANDS_TEXTURE_PATH := "res://assets/characters/first_person/pixel_rpg_hunter_fp_hands_neutral_r001.png"' in runtime_test)
    check("runtime test does not authorize superseded SVG", "pixel_rpg_hunter_fp_hands_neutral_r001_runtime.svg" not in runtime_test)

check("superseded runtime SVG is absent", not LEGACY_SVG.exists())

print()
print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
print("Gate: " + ("PIXEL_RPG_CANONICAL_HANDS_SOURCE_STATIC_VERIFIED" if not failures else "PIXEL_RPG_CANONICAL_HANDS_SOURCE_STATIC_FAILED"))
raise SystemExit(0 if not failures else 1)
