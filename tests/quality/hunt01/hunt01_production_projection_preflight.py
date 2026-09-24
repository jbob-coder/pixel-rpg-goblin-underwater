#!/usr/bin/env python3
"""Production Hunt-01 projection/source preflight.

This gate verifies repository/source invariants only. It does not imply Godot
runtime, Android APK, Galaxy A03s traversal/visual acceptance, or sustained
performance verification.
"""

from __future__ import annotations

import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
DOC_MANIFEST = ROOT / "docs/10_world/regions/REGION_01/FIRST_SLICE_HUNT01_GRAYBOX_BUILD_MANIFEST.json"
RUNTIME_MANIFEST = ROOT / "game/content/regions/region_01/hunt01_graybox_build_manifest.json"
TRACKING_DATA = ROOT / "game/content/regions/region_01/hunt01_tracking_evidence.json"

REQUIRED = (
    "game/project.godot",
    "game/export_presets.cfg",
    "game/README.md",
    "game/scenes/app_shell.tscn",
    "game/scenes/regions/region_01_hunt01_graybox.tscn",
    "game/scripts/app_shell.gd",
    "game/scripts/presentation/exploration/region_01_hunt01_graybox.gd",
    "game/scripts/gameplay/tracking/README.md",
    "game/scripts/gameplay/tracking/hunt01_tracking_runtime.gd",
    "game/scripts/gameplay/encounter/README.md",
    "game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd",
    "game/content/regions/region_01/hunt01_graybox_build_manifest.json",
    "game/content/regions/region_01/hunt01_tracking_evidence.json",
    "game/content/regions/region_01/README.md",
    "game/tests/region01_hunt01_graybox_runtime_test.gd",
    "game/assets/README.md",
    "game/assets/environment/stylized_pine.tscn",
    "game/assets/environment/stylized_rock_cluster.tscn",
    "game/assets/characters/hunter_visual.tscn",
    "game/assets/creatures/mudcrest_raker_visual.tscn",
)


def route_length(anchors: list[list[float]]) -> float:
    return sum(math.dist(a, b) for a, b in zip(anchors, anchors[1:]))


def main() -> int:
    failures: list[str] = []
    checks = 0

    def check(label: str, condition: bool, detail: str = "") -> None:
        nonlocal checks
        checks += 1
        print(f"[{'PASS' if condition else 'FAIL'}] {label}{' :: ' + detail if detail else ''}")
        if not condition:
            failures.append(label)

    print("Hunt-01 production foundation/tracking/encounter-trigger source preflight")
    for rel in REQUIRED:
        check(f"required:{rel}", (ROOT / rel).is_file())

    if not DOC_MANIFEST.is_file() or not RUNTIME_MANIFEST.is_file() or not TRACKING_DATA.is_file():
        print("Gate: HUNT01_PRODUCTION_GRAYBOX_STATIC_FAILED")
        return 1

    docs = json.loads(DOC_MANIFEST.read_text(encoding="utf-8"))
    runtime = json.loads(RUNTIME_MANIFEST.read_text(encoding="utf-8"))
    tracking_data = json.loads(TRACKING_DATA.read_text(encoding="utf-8"))
    check("runtime projection equals docs authority", runtime == docs)
    check("manifest schema", runtime.get("schema") == "uhr_hunt01_graybox_build_manifest@1", str(runtime.get("schema")))
    check("scenario identity", runtime.get("scenario") == "R01_HUNT01_M01_TRACK_TO_MEADOW")
    check("space is meters", runtime.get("space", {}).get("units") == "m")

    length = route_length(runtime["route"]["anchors"])
    planning_reference = float(runtime["route"]["planning_before_ramp_m"])
    target_lo, target_hi = runtime["route"]["target_m"]
    check(
        "raw authority route remains consistent with planning geometry",
        planning_reference <= length <= float(target_hi),
        f"raw={length:.3f} m; planning_ref={planning_reference:.3f} m; future_smoothed_target={target_lo}-{target_hi} m",
    )
    check("evidence count", len(runtime.get("evidence", [])) == 7, str(len(runtime.get("evidence", []))))
    check("tactical-node count", len(runtime.get("nodes", [])) == 10, str(len(runtime.get("nodes", []))))
    check("tactical-link count", len(runtime.get("links", [])) == 14, str(len(runtime.get("links", []))))
    check("stream proxy count", len(runtime.get("stream", [])) == 3, str(len(runtime.get("stream", []))))

    project_text = (ROOT / "game/project.godot").read_text(encoding="utf-8")
    export_text = (ROOT / "game/export_presets.cfg").read_text(encoding="utf-8")
    region_text = (ROOT / "game/scripts/presentation/exploration/region_01_hunt01_graybox.gd").read_text(encoding="utf-8")
    tracking_text = (ROOT / "game/scripts/gameplay/tracking/hunt01_tracking_runtime.gd").read_text(encoding="utf-8")
    encounter_text = (ROOT / "game/scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd").read_text(encoding="utf-8")
    scene_text = (ROOT / "game/scenes/regions/region_01_hunt01_graybox.tscn").read_text(encoding="utf-8")
    hunter_asset = (ROOT / "game/assets/characters/hunter_visual.tscn").read_text(encoding="utf-8")
    monster_asset = (ROOT / "game/assets/creatures/mudcrest_raker_visual.tscn").read_text(encoding="utf-8")

    check("production GL Compatibility renderer", 'renderer/rendering_method="gl_compatibility"' in project_text)
    check("Android ETC2/ASTC import enabled", 'textures/vram_compression/import_etc2_astc=true' in project_text)
    check("production daylight clear color defined", "environment/defaults/default_clear_color" in project_text)
    check("production package ID is not probe ID", 'package/unique_name="org.unnamedhuntrpg.game"' in export_text and "stage1probe" not in export_text)
    check("production source does not import probe tree", "probes/android_stage1" not in region_text and "probes/android_stage1" not in scene_text)
    check("accepted 115 degree first-person FOV", "FIRST_PERSON_FOV_DEG := 115.0" in region_text and "fov = 115.0" in scene_text)
    check("shooter-style independent look path", "_look_touch_id" in region_text and "_camera_relative_movement" in region_text and "_apply_look_delta" in region_text)
    check("no adaptive steering variables returned", all(token not in region_text for token in ("JOYSTICK_ADAPT_HOLD_SECONDS", "JOYSTICK_ADAPT_ALIGNMENT_DOT", "_joystick_adaptive_latched", "_joystick_reference_forward")))
    check("production settings path is non-probe", 'SETTINGS_PATH := "user://unnamed_hunt_settings.cfg"' in region_text)
    check("no invisible Region boundary clamp", "PROBE_BOUNDS" not in region_text and "bounded_position.x" not in region_text)

    check("single flat map foundation configured", 'FULL_MAP_SIZE_M := Vector2(440.0, 440.0)' in region_text and 'H01_WORLD_FOUNDATION' in region_text)
    check("Hunter speed increased from rejected 3.5 m/s", "MOVE_SPEED_MPS := 6.25" in region_text and "MOVE_SPEED_MPS := 3.5" not in region_text)
    check("route is visual overlay rather than isolated collision slabs", "_create_flat_visual_lane" in region_text and "_create_route_segment" not in region_text)
    check("walk-over evidence uses Area3D", "Area3D.new()" in region_text and "body_entered.connect" in region_text)
    check("collected evidence disappears", "node.queue_free()" in region_text and "remove_from_group(\"hunt01_evidence\")" in region_text)
    check("old floating evidence sphere helper removed", "func _create_marker" not in region_text and "SphereMesh.new()" not in region_text)
    check("evidence interaction does not require audio", "AudioStreamPlayer" not in region_text and "AudioStreamPlayer" not in scene_text and "No audio required" in region_text)
    check("stream proxies remain non-rendering/non-physical holders", 'holder.add_to_group("hunt01_stream_proxy")' in region_text and "holder.visible = false" in region_text)

    check("stylized pine asset is consumed", 'preload("res://assets/environment/stylized_pine.tscn")' in region_text)
    check("stylized rock asset is consumed", 'preload("res://assets/environment/stylized_rock_cluster.tscn")' in region_text)
    check("Mudcrest Raker visual asset is consumed", 'preload("res://assets/creatures/mudcrest_raker_visual.tscn")' in region_text)
    check("Hunter scene consumes themed Hunter visual", 'res://assets/characters/hunter_visual.tscn' in scene_text)
    check("Hunter visual has poleblade silhouette", "PolebladeShaft" in hunter_asset and "PolebladeHead" in hunter_asset)
    check("Monster visual has attack anatomy", all(token in monster_asset for token in ("HornL", "HornR", "ForeLegL", "ForeLegR", "TailTip", "Plate01")))
    check("normal scene does not use neon magenta debug color", "0.70, 0.18, 0.52" not in region_text and "0.95, 0.22, 0.72" not in region_text)

    check("tracking schema is explicit", tracking_data.get("schema") == "uhr.hunt01.tracking_evidence.v1")
    check("tracking is no-GPS and audio-optional", tracking_data.get("no_gps") is True and tracking_data.get("audio_required") is False)
    check("seven tracking profiles exist", len(tracking_data.get("evidence", [])) == 7)
    check("old Rootwood evidence is OLD / WEAK", any(e.get("id") == "R01_H01_EV05_OLD_ROOT_SCRAPE" and e.get("freshness") == "OLD" and e.get("confidence") == "WEAK" for e in tracking_data.get("evidence", [])))
    check("tracking reaches observation-ready state", "OBSERVATION_READY" in tracking_text)
    check("tactical nodes hidden by tracking before encounter", 'marker.visible = false' in tracking_text)

    check("scene consumes encounter trigger runtime", 'res://scripts/gameplay/encounter/hunt01_encounter_trigger_runtime.gd' in scene_text and 'name="EncounterRuntime"' in scene_text)
    check("explicit ENGAGE control exists hidden by default", 'name="EngageEncounter"' in scene_text and 'text = "ENGAGE"' in scene_text and 'visible = false' in scene_text)
    check("encounter consumes observation-ready rather than clue count", '== "OBSERVATION_READY"' in encounter_text)
    check("encounter requires physical engagement state", "ENGAGEMENT_AVAILABLE" in encounter_text and "_inside_engagement" in encounter_text)
    check("stable encounter identity is preserved", all(token in encounter_text for token in ("enc_r01_ef02_m01_0001", "R01_EF02", "monster_r01_m01_0001", "R01_EF02_N01")))
    check("encounter staging does not assign Hunter world position", "_hunter.global_position =" not in encounter_text)
    check("encounter staging does not assign Monster world position", "_monster.global_position =" not in encounter_text)
    check("tactical nodes activate only in encounter runtime", 'marker.visible = true' in encounter_text)
    check("encounter layer contains no attack-resolution runtime", all(token not in encounter_text for token in ("apply_damage", "resolve_attack", "damage_roll", "critical_roll")))

    print()
    print(f"Checks: {checks} | Passed: {checks - len(failures)} | Failed: {len(failures)}")
    print("Gate: HUNT01_PRODUCTION_GRAYBOX_STATIC_VERIFIED" if not failures else "Gate: HUNT01_PRODUCTION_GRAYBOX_STATIC_FAILED")
    print("Gate: HUNT01_TRACKING_ENCOUNTER_SOURCE_STATIC_VERIFIED" if not failures else "Gate: HUNT01_TRACKING_ENCOUNTER_SOURCE_STATIC_FAILED")
    print("H01VAL005_FINAL_SMOOTHED_ROUTE_LENGTH=NOT_EXECUTED")
    print("This result does NOT imply Godot runtime, APK, phone visual acceptance, or performance verification.")
    return 0 if not failures else 1


if __name__ == "__main__":
    raise SystemExit(main())
