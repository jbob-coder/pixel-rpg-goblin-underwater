#!/usr/bin/env python3
"""Engine-independent static validator for the Region 01 Hunt-01 graybox manifest.

This tool validates only MANIFEST_STATIC rules from the owning Region 01
validation contract. It must never be used to claim scene/runtime/phone PASS.
"""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import sys
from collections import Counter
from pathlib import Path
from typing import Any

RESULT_SCHEMA = "uhr_hunt01_graybox_manifest_validation_result@1"
EXPECTED_MANIFEST_SCHEMA = "uhr_hunt01_graybox_build_manifest@1"
EXPECTED_IDENTITY = {
    "scenario": "R01_HUNT01_M01_TRACK_TO_MEADOW",
    "hunt": "hunt_r01_m01_proof_01",
    "monster": "monster_r01_m01_0001",
    "encounter": "enc_r01_ef02_m01_0001",
    "footprint": "R01_EF02",
}
EXPECTED_SPACE = {
    "id": "space_region_01",
    "units": "m",
    "axes": {"x": "east", "y": "up", "z_negative": "north_outbound"},
}
EXPECTED_TERRAIN = {
    "STABLE_GROUND",
    "ROUGH_GROUND",
    "SHALLOW_WATER",
    "MUD",
    "BRUSH",
    "HIGH_GROUND",
}
STATIC_RULES = [
    "H01VAL001",
    "H01VAL002",
    "H01VAL003",
    "H01VAL004",
    "H01VAL012",
    "H01VAL013",
    "H01VAL014",
    "H01VAL021",
    "H01VAL024",
    "H01VAL025",
    "H01VAL026",
    "H01VAL027",
    "H01VAL030",
]
ALL_RULES = [f"H01VAL{i:03d}" for i in range(1, 31)]
REQUIRED_GROUPS = {
    "gb_h01_root",
    "gb_h01_s00",
    "gb_h01_s00_s01",
    "gb_h01_s01",
    "gb_h01_s01_s03",
    "gb_h01_ef02",
    "gb_h01_escape",
    "gb_h01_debug_evidence",
    "gb_h01_debug_nodes",
    "gb_h01_debug_monster",
    "gb_h01_debug_camera",
    "gb_h01_debug_stream",
}
REQUIRED_GEOMETRY_IDS = {
    "H01_GB_S00_DEPART_PAD",
    "H01_GB_S00_CHOICE_CLEARING",
    "H01_GB_S00_S01_BRANCH_MOUTH",
    "H01_GB_S00_S02_BRANCH_MOUTH",
    "H01_GB_S00_TO_S01_REQUIRED_CORRIDOR",
    "H01_GB_S01_FORD_BASIN",
    "H01_GB_S01_SHALLOW_WATER_MAIN",
    "H01_GB_S01_WALLOW_MUD",
    "H01_GB_S01_EXIT_MUD",
    "H01_GB_S01_REQUIRED_DRY_BANK",
    "H01_GB_S01_REED_BELT",
    "H01_GB_S01_TO_S03_REQUIRED_CORRIDOR",
    "H01_GB_VIS01_BANK_RISE",
    "H01_GB_VIS02_MEADOW_EDGE_SCREEN",
    "H01_GB_EF02_MEADOW_FLOOR",
    "H01_GB_EF02_OPEN_CORE",
    "H01_GB_EF02_WEST_BRUSH_BELT",
    "H01_GB_EF02_FEED_SITE",
    "H01_GB_OBSERVATION_SHELF_W",
    "H01_GB_OBS_TO_N01_RAMP",
    "R01_EF02_COV01_BOULDER_W",
    "R01_EF02_COV02_SCARRED_TREE_NW",
}
PROHIBITED_DEBUG_KEYS = {
    "gameplay_collision",
    "blocking_collision",
    "state_mutation",
    "save_authority",
    "player_detection_radius",
}


class Validation:
    def __init__(self) -> None:
        self.findings: list[dict[str, Any]] = []
        self.info: dict[str, Any] = {}

    def add(self, rule: str, severity: str, reference: str, measured: Any, expected: Any, explanation: str) -> None:
        self.findings.append({"rule": rule, "severity": severity, "reference": reference, "measured": measured, "expected": expected, "explanation": explanation})

    def error(self, rule: str, reference: str, measured: Any, expected: Any, explanation: str) -> None:
        self.add(rule, "ERROR", reference, measured, expected, explanation)

    def pass_rule(self, rule: str, reference: str, measured: Any, expected: Any, explanation: str) -> None:
        self.add(rule, "PASS", reference, measured, expected, explanation)


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def git_blob_sha(path: Path) -> str:
    data = path.read_bytes()
    header = f"blob {len(data)}\0".encode("utf-8")
    return hashlib.sha1(header + data).hexdigest()


def exact_vec(a: Any, b: Any) -> bool:
    if not (isinstance(a, list) and isinstance(b, list) and len(a) == len(b)):
        return False
    return all(float(x) == float(y) for x, y in zip(a, b))


def horiz_dist(a: list[float], b: list[float]) -> float:
    return math.hypot(float(b[0]) - float(a[0]), float(b[2]) - float(a[2]))


def dist3(a: list[float], b: list[float]) -> float:
    return math.dist([float(x) for x in a], [float(x) for x in b])


def grade_pct(a: list[float], b: list[float]) -> float:
    horizontal = horiz_dist(a, b)
    if horizontal == 0:
        return math.inf if float(a[1]) != float(b[1]) else 0.0
    return abs(float(b[1]) - float(a[1])) / horizontal * 100.0


def contains_xz(center: list[float], size_xz: list[float], point: list[float]) -> bool:
    return abs(float(point[0]) - float(center[0])) <= float(size_xz[0]) / 2.0 and abs(float(point[2]) - float(center[2])) <= float(size_xz[1]) / 2.0


def recursively_has_prohibited_key(value: Any) -> list[str]:
    found: list[str] = []
    if isinstance(value, dict):
        for key, child in value.items():
            if key in PROHIBITED_DEBUG_KEYS:
                found.append(key)
            found.extend(recursively_has_prohibited_key(child))
    elif isinstance(value, list):
        for child in value:
            found.extend(recursively_has_prohibited_key(child))
    return found


def entry_maps(manifest: dict[str, Any]) -> tuple[dict[str, list[Any]], dict[str, list[Any]]]:
    by_build: dict[str, list[Any]] = {}
    by_geometry: dict[str, list[Any]] = {}
    for entry in manifest.get("entries", []):
        if isinstance(entry, list) and len(entry) >= 8:
            by_build[str(entry[0])] = entry
            by_geometry[str(entry[1])] = entry
    return by_build, by_geometry


def rule001(v: Validation, m: dict[str, Any]) -> None:
    errors = []
    if m.get("schema") != EXPECTED_MANIFEST_SCHEMA:
        errors.append(("schema", m.get("schema"), EXPECTED_MANIFEST_SCHEMA))
    for key, expected in EXPECTED_IDENTITY.items():
        if m.get(key) != expected:
            errors.append((key, m.get(key), expected))
    if errors:
        for key, measured, expected in errors:
            v.error("H01VAL001", key, measured, expected, "Proof identity/schema mismatch.")
    else:
        v.pass_rule("H01VAL001", "manifest", EXPECTED_MANIFEST_SCHEMA, EXPECTED_MANIFEST_SCHEMA, "Schema and proof identity match.")


def rule002(v: Validation, m: dict[str, Any]) -> None:
    ids: list[str] = []
    ids.extend(str(group[0]) for group in m.get("groups", []) if isinstance(group, list) and group)
    ids.extend(str(entry[0]) for entry in m.get("entries", []) if isinstance(entry, list) and entry)
    dup = sorted(key for key, count in Counter(ids).items() if count > 1)
    if dup:
        v.error("H01VAL002", "build_ids", dup, "all unique", "Duplicate group/build entry IDs found.")
    else:
        v.pass_rule("H01VAL002", "build_ids", len(ids), "all unique", "Group and build entry IDs are unique.")


def rule003(v: Validation, m: dict[str, Any]) -> None:
    groups = m.get("groups", [])
    group_map: dict[str, tuple[Any, str]] = {}
    malformed = []
    for row in groups:
        if not (isinstance(row, list) and len(row) == 3):
            malformed.append(row)
            continue
        group_map[str(row[0])] = (row[1], str(row[2]))
    if malformed:
        v.error("H01VAL003", "groups", malformed, "[id,parent,kind]", "Malformed group row.")
        return
    for group_id, (parent, _kind) in group_map.items():
        if group_id == "gb_h01_root":
            if parent is not None:
                v.error("H01VAL003", group_id, parent, None, "Root group must have no parent.")
        elif parent not in group_map:
            v.error("H01VAL003", group_id, parent, "existing group", "Group parent does not exist.")
    for start in group_map:
        seen: set[str] = set()
        cursor: str | None = start
        while cursor is not None and cursor in group_map:
            if cursor in seen:
                v.error("H01VAL003", start, cursor, "acyclic parent chain", "Group parent cycle detected.")
                break
            seen.add(cursor)
            parent = group_map[cursor][0]
            cursor = str(parent) if parent is not None else None
    for entry in m.get("entries", []):
        if not (isinstance(entry, list) and len(entry) >= 3):
            v.error("H01VAL003", "entry", entry, "entry with group reference", "Malformed entry.")
            continue
        if entry[2] not in group_map:
            v.error("H01VAL003", str(entry[0]), entry[2], "existing group", "Entry references missing group.")
    if not any(f["rule"] == "H01VAL003" and f["severity"] == "ERROR" for f in v.findings):
        v.pass_rule("H01VAL003", "group_graph", len(group_map), "valid acyclic references", "Group hierarchy and entry group references are valid.")


def rule004(v: Validation, m: dict[str, Any]) -> None:
    space = m.get("space")
    if space != EXPECTED_SPACE:
        v.error("H01VAL004", "space", space, EXPECTED_SPACE, "Coordinate frame mismatch.")
    else:
        v.pass_rule("H01VAL004", "space", space, EXPECTED_SPACE, "Coordinate frame matches Region 01 authority.")


def rule012(v: Validation, m: dict[str, Any], fixture: dict[str, Any]) -> None:
    evidence = m.get("evidence", [])
    expected = fixture.get("evidence", {})
    malformed = []
    for row in evidence:
        if not (isinstance(row, list) and len(row) == 3):
            malformed.append(row)
            continue
        ev_id, pos, dims = row
        if ev_id not in expected:
            v.error("H01VAL012", ev_id, pos, "known fixture evidence ID", "Evidence ID missing from stable-coordinate fixture.")
            continue
        if not exact_vec(pos, expected[ev_id]):
            v.error("H01VAL012", ev_id, pos, expected[ev_id], "Evidence coordinate drifted from stable source.")
        if not (isinstance(dims, list) and len(dims) == 3 and all(float(x) > 0 for x in dims)):
            v.error("H01VAL012", ev_id, dims, "positive 3D authoring volume", "Evidence authoring volume is invalid.")
    if malformed:
        v.error("H01VAL012", "evidence", malformed, "[id,pos,dims]", "Malformed evidence row.")
    _, by_geom = entry_maps(m)
    physical_containment = {
        "R01_H01_EV03_FRESH_WALLOW": "H01_GB_S01_WALLOW_MUD",
        "R01_H01_EV04_WATER_EXIT": "H01_GB_S01_EXIT_MUD",
    }
    evidence_map = {row[0]: row for row in evidence if isinstance(row, list) and len(row) == 3}
    for ev_id, geom_id in physical_containment.items():
        if ev_id not in evidence_map or geom_id not in by_geom:
            v.error("H01VAL012", ev_id, geom_id, "matching physical patch", "Required evidence/patch relation missing.")
            continue
        point = evidence_map[ev_id][1]
        entry = by_geom[geom_id]
        center, dims = entry[4], entry[5]
        if center is None or "size_xz" not in dims or not contains_xz(center, dims["size_xz"], point):
            v.error("H01VAL012", ev_id, point, f"inside {geom_id}", "Evidence falls outside its physical authoring patch.")
    if len(evidence) != 7:
        v.error("H01VAL012", "evidence_count", len(evidence), 7, "First proof requires seven evidence anchors.")
    if not any(f["rule"] == "H01VAL012" and f["severity"] == "ERROR" for f in v.findings):
        v.pass_rule("H01VAL012", "evidence", len(evidence), 7, "All evidence coordinates/volumes are present and contained.")


def rule013(v: Validation, m: dict[str, Any]) -> None:
    bad = []
    for row in m.get("nodes", []):
        if not (isinstance(row, list) and len(row) >= 2):
            bad.append(("malformed", row))
            continue
        node_id, pos = row[0], row[1]
        if not (-83 <= float(pos[0]) <= -7 and -280 <= float(pos[2]) <= -220):
            bad.append((node_id, pos))
    if bad:
        v.error("H01VAL013", "nodes", bad, "X -83..-7 and Z -280..-220", "One or more tactical nodes are outside EF02.")
    else:
        v.pass_rule("H01VAL013", "nodes", len(m.get("nodes", [])), "all inside EF02", "All tactical nodes remain inside the EF02 planning envelope.")


def rule014(v: Validation, m: dict[str, Any]) -> None:
    nodes = {row[0]: row[1] for row in m.get("nodes", []) if isinstance(row, list) and len(row) >= 2}
    reports = []
    seen_links = set()
    for row in m.get("links", []):
        if not (isinstance(row, list) and len(row) >= 5):
            v.error("H01VAL014", "link", row, "[a,b,recorded,tolerance,min_clear]", "Malformed link row.")
            continue
        a, b, recorded, tolerance, min_clear = row[:5]
        key = tuple(sorted((a, b)))
        if key in seen_links:
            v.error("H01VAL014", f"{a}<->{b}", "duplicate", "unique undirected link", "Duplicate tactical link.")
            continue
        seen_links.add(key)
        if a not in nodes or b not in nodes:
            v.error("H01VAL014", f"{a}<->{b}", [a in nodes, b in nodes], "both node IDs exist", "Link references missing node.")
            continue
        measured = dist3(nodes[a], nodes[b])
        delta = abs(measured - float(recorded))
        reports.append({"link": f"{a}<->{b}", "computed_m": round(measured, 3), "recorded_m": float(recorded), "delta_m": round(delta, 3), "tolerance_m": float(tolerance), "clearance_target_m": float(min_clear)})
        if delta > float(tolerance) + 1e-9:
            v.error("H01VAL014", f"{a}<->{b}", round(measured, 3), f"{recorded} ± {tolerance}", "Link distance is outside tolerance.")
    v.info["tactical_link_distances"] = reports
    if len(m.get("links", [])) != 14:
        v.error("H01VAL014", "link_count", len(m.get("links", [])), 14, "First proof link graph must contain 14 links.")
    if not any(f["rule"] == "H01VAL014" and f["severity"] == "ERROR" for f in v.findings):
        v.pass_rule("H01VAL014", "links", len(reports), 14, "All tactical-link distances recompute within tolerance.")


def rule021(v: Validation, m: dict[str, Any]) -> None:
    stream = m.get("stream", [])
    _, by_geom = entry_maps(m)
    physical_ids = set(by_geom)
    bad = []
    for row in stream:
        if not (isinstance(row, list) and len(row) == 3):
            bad.append(("malformed", row))
            continue
        proxy_id, _pos, dims = row
        if proxy_id in physical_ids:
            bad.append((proxy_id, "also appears as physical entry"))
        if not (isinstance(dims, list) and len(dims) == 3 and all(float(x) > 0 for x in dims)):
            bad.append((proxy_id, "invalid debug volume"))
    groups = {row[0]: row[2] for row in m.get("groups", []) if isinstance(row, list) and len(row) == 3}
    if groups.get("gb_h01_debug_stream") != "debug":
        bad.append(("gb_h01_debug_stream", groups.get("gb_h01_debug_stream")))
    if bad:
        v.error("H01VAL021", "stream_proxies", bad, "debug-only, non-physical entries", "Streaming proxy static classification is invalid.")
    else:
        v.pass_rule("H01VAL021", "stream_proxies", len(stream), 3, "Streaming proxies are isolated from physical collision entries.")


def rule024(v: Validation, m: dict[str, Any]) -> None:
    manifest_allowed = set(m.get("allowed_terrain", []))
    unknown = set()
    for entry in m.get("entries", []):
        if isinstance(entry, list) and len(entry) >= 9:
            unknown.update(tag for tag in entry[8] if tag not in EXPECTED_TERRAIN)
    for node in m.get("nodes", []):
        if isinstance(node, list) and len(node) >= 4:
            if node[2] not in EXPECTED_TERRAIN:
                unknown.add(node[2])
            unknown.update(tag for tag in node[3] if tag not in EXPECTED_TERRAIN)
    if manifest_allowed != EXPECTED_TERRAIN:
        v.error("H01VAL024", "allowed_terrain", sorted(manifest_allowed), sorted(EXPECTED_TERRAIN), "Terrain allowlist differs from first-slice terrain authority.")
    if unknown:
        v.error("H01VAL024", "terrain_references", sorted(unknown), sorted(EXPECTED_TERRAIN), "Unknown terrain tag referenced.")
    if not any(f["rule"] == "H01VAL024" and f["severity"] == "ERROR" for f in v.findings):
        v.pass_rule("H01VAL024", "terrain", sorted(manifest_allowed), sorted(EXPECTED_TERRAIN), "All terrain references use the allowed first-slice set.")


def rule025(v: Validation, m: dict[str, Any]) -> None:
    groups = {row[0]: row[2] for row in m.get("groups", []) if isinstance(row, list) and len(row) == 3}
    debug_groups = {gid for gid, kind in groups.items() if kind == "debug"}
    expected_debug = {"gb_h01_debug_evidence", "gb_h01_debug_nodes", "gb_h01_debug_monster", "gb_h01_debug_camera", "gb_h01_debug_stream"}
    errors = []
    if not expected_debug.issubset(debug_groups):
        errors.append(("missing_debug_groups", sorted(expected_debug - debug_groups)))
    physical_entries_in_debug = [entry[0] for entry in m.get("entries", []) if isinstance(entry, list) and len(entry) >= 3 and entry[2] in debug_groups]
    if physical_entries_in_debug:
        errors.append(("physical_entries_in_debug_groups", physical_entries_in_debug))
    debug_payload = {"evidence": m.get("evidence"), "nodes": m.get("nodes"), "monster_clearance": m.get("monster_clearance"), "camera": m.get("camera"), "stream": m.get("stream")}
    prohibited = recursively_has_prohibited_key(debug_payload)
    if prohibited:
        errors.append(("prohibited_debug_authority_keys", sorted(set(prohibited))))
    physical_identity = set()
    for entry in m.get("entries", []):
        if isinstance(entry, list) and len(entry) >= 2:
            physical_identity.update([str(entry[0]), str(entry[1])])
    debug_ids = {row[0] for row in m.get("evidence", []) if isinstance(row, list) and row}
    debug_ids |= {row[0] for row in m.get("nodes", []) if isinstance(row, list) and row}
    debug_ids |= {row[0] for row in m.get("stream", []) if isinstance(row, list) and row}
    overlap = sorted(debug_ids & physical_identity)
    if overlap:
        errors.append(("debug_physical_id_overlap", overlap))
    if errors:
        v.error("H01VAL025", "debug_semantics", errors, "debug-only non-authoritative families", "Debug data owns gameplay collision/state or is ambiguously classified.")
    else:
        v.pass_rule("H01VAL025", "debug_semantics", sorted(debug_groups), sorted(expected_debug), "Debug families are isolated from physical/gameplay ownership.")


def rule026(v: Validation, m: dict[str, Any], fixture: dict[str, Any], repo_root: Path) -> None:
    errors = []
    source_rel = fixture.get("source_spatial_registry_path")
    source_sha = fixture.get("source_spatial_registry_git_blob_sha")
    if not source_rel or not source_sha:
        errors.append(("fixture_source", [source_rel, source_sha], "path + git blob sha"))
    else:
        source_path = repo_root / source_rel
        if not source_path.exists():
            errors.append(("fixture_source_path", str(source_path), "existing spatial registry"))
        else:
            measured_sha = git_blob_sha(source_path)
            if measured_sha != source_sha:
                errors.append(("fixture_source_sha", measured_sha, source_sha))
    evidence = {row[0]: row[1] for row in m.get("evidence", []) if isinstance(row, list) and len(row) >= 2}
    nodes = {row[0]: row[1] for row in m.get("nodes", []) if isinstance(row, list) and len(row) >= 2}
    for ev_id, expected in fixture.get("evidence", {}).items():
        if ev_id not in evidence or not exact_vec(evidence[ev_id], expected):
            errors.append((ev_id, evidence.get(ev_id), expected))
    for node_id, expected in fixture.get("nodes", {}).items():
        if node_id not in nodes or not exact_vec(nodes[node_id], expected):
            errors.append((node_id, nodes.get(node_id), expected))
    ma01 = fixture.get("monster", {}).get("ma01")
    mc = m.get("monster_clearance", {})
    for ref, measured in [("pivot.center", mc.get("pivot", {}).get("center")), ("body_force.center", mc.get("body_force", {}).get("center")), ("charge.start", mc.get("charge", {}).get("start"))]:
        if not exact_vec(measured, ma01):
            errors.append((ref, measured, ma01))
    expected_escape = fixture.get("monster", {}).get("escape")
    if m.get("escape", {}).get("polyline") != expected_escape:
        errors.append(("escape.polyline", m.get("escape", {}).get("polyline"), expected_escape))
    route_anchors = m.get("route", {}).get("anchors", [])
    canon = fixture.get("canonical_route_anchors", {})
    if canon.get("s00_s01") not in route_anchors:
        errors.append(("canonical.s00_s01", "missing", canon.get("s00_s01")))
    if canon.get("s01_s03") not in route_anchors:
        errors.append(("canonical.s01_s03", "missing", canon.get("s01_s03")))
    stream = {row[0]: row[1] for row in m.get("stream", []) if isinstance(row, list) and len(row) >= 2}
    expected_stream = {"H01_GB_STREAM_S00_S01_PROXY": canon.get("s00_s01"), "H01_GB_STREAM_S01_S03_PROXY": canon.get("s01_s03"), "H01_GB_STREAM_S03_S05_PROXY": canon.get("s03_s05")}
    for proxy_id, expected in expected_stream.items():
        if proxy_id not in stream or not exact_vec(stream[proxy_id], expected):
            errors.append((proxy_id, stream.get(proxy_id), expected))
    if errors:
        v.error("H01VAL026", "stable_coordinates", errors, "exact source-registry copies", "Stable coordinate copies differ from the fixture/source registry.")
    else:
        v.pass_rule("H01VAL026", "stable_coordinates", "exact", "exact", "Stable coordinate copies and source fixture SHA match.")


def rule027(v: Validation, m: dict[str, Any], fixture: dict[str, Any]) -> None:
    errors = []
    controls = fixture.get("non_authoritative_build_controls", {})
    ramp_expected = controls.get("ramp_mid")
    brush_expected = controls.get("west_brush")
    ramp = m.get("route", {}).get("ramp_control", {})
    if ramp.get("id") != "build_ctrl_h01_obs_ramp_mid":
        errors.append(("ramp.id", ramp.get("id"), "build_ctrl_h01_obs_ramp_mid"))
    if ramp.get("status") != "BUILD_ONLY_NOT_GAMEPLAY_ANCHOR":
        errors.append(("ramp.status", ramp.get("status"), "BUILD_ONLY_NOT_GAMEPLAY_ANCHOR"))
    if not exact_vec(ramp.get("pos"), ramp_expected):
        errors.append(("ramp.pos", ramp.get("pos"), ramp_expected))
    by_build, _ = entry_maps(m)
    brush = by_build.get("gb_h01_ef02_west_brush")
    if brush is None:
        errors.append(("west_brush", None, "gb_h01_ef02_west_brush"))
    else:
        if not exact_vec(brush[4], brush_expected):
            errors.append(("west_brush.pos", brush[4], brush_expected))
        if brush[5].get("status") != "NOMINAL_BUILD_PLACEMENT":
            errors.append(("west_brush.status", brush[5].get("status"), "NOMINAL_BUILD_PLACEMENT"))
    stable_positions = []
    stable_positions.extend(fixture.get("evidence", {}).values())
    stable_positions.extend(fixture.get("nodes", {}).values())
    stable_positions.append(fixture.get("monster", {}).get("ma01"))
    stable_positions.extend(fixture.get("monster", {}).get("escape", []))
    for name, pos in [("ramp_mid", ramp_expected), ("west_brush", brush_expected)]:
        if any(exact_vec(pos, stable) for stable in stable_positions if stable is not None):
            errors.append((name, pos, "must not equal a stable gameplay coordinate"))
    if errors:
        v.error("H01VAL027", "build_controls", errors, "non-authoritative build controls", "Build-only controls were promoted or misclassified.")
    else:
        v.pass_rule("H01VAL027", "build_controls", controls, "non-authoritative", "Build-only coordinates remain explicitly non-authoritative.")


def rule030(v: Validation, m: dict[str, Any]) -> None:
    errors = []
    groups = {row[0] for row in m.get("groups", []) if isinstance(row, list) and row}
    missing_groups = sorted(REQUIRED_GROUPS - groups)
    if missing_groups:
        errors.append(("groups", missing_groups))
    _, by_geom = entry_maps(m)
    missing_geometry = sorted(REQUIRED_GEOMETRY_IDS - set(by_geom))
    if missing_geometry:
        errors.append(("geometry", missing_geometry))
    counts = {"groups": len(m.get("groups", [])), "entries": len(m.get("entries", [])), "evidence": len(m.get("evidence", [])), "nodes": len(m.get("nodes", [])), "links": len(m.get("links", [])), "stream": len(m.get("stream", []))}
    if counts["evidence"] != 7:
        errors.append(("evidence_count", counts["evidence"]))
    if counts["nodes"] != 10:
        errors.append(("node_count", counts["nodes"]))
    if counts["links"] != 14:
        errors.append(("link_count", counts["links"]))
    if counts["stream"] != 3:
        errors.append(("stream_count", counts["stream"]))
    monster = m.get("monster_clearance", {})
    if set(monster) != {"pivot", "body_force", "charge"}:
        errors.append(("monster_clearance", sorted(monster)))
    if "polyline" not in m.get("escape", {}):
        errors.append(("escape", "missing polyline"))
    camera = m.get("camera", {})
    if not {"descent", "sight"}.issubset(camera):
        errors.append(("camera", sorted(camera)))
    rules = m.get("validation_rules", [])
    if rules != ALL_RULES:
        errors.append(("validation_rules", rules, ALL_RULES))
    v.info["counts"] = counts
    if errors:
        v.error("H01VAL030", "required_families", errors, "all required first-slice families", "Required manifest family/count is missing or malformed.")
    else:
        v.pass_rule("H01VAL030", "required_families", counts, "complete", "All required first-slice manifest families are present.")


def calculate_ramp_info(v: Validation, m: dict[str, Any]) -> None:
    by_build, _ = entry_maps(m)
    ramp = by_build.get("gb_h01_obs_to_n01_ramp")
    if not ramp:
        v.info["observation_ramp"] = {"status": "missing"}
        return
    polyline = ramp[5].get("polyline", [])
    segments = []
    total = 0.0
    for i in range(len(polyline) - 1):
        a, b = polyline[i], polyline[i + 1]
        length = dist3(a, b)
        grade = grade_pct(a, b)
        total += length
        segments.append({"from_index": i, "to_index": i + 1, "length_m": round(length, 3), "grade_pct": round(grade, 3)})
    v.info["observation_ramp"] = {"path_length_m": round(total, 3), "declared_target_m": ramp[5].get("length"), "declared_grade_max_pct": ramp[5].get("grade_max"), "segments": segments}


def calculate_counts(v: Validation, m: dict[str, Any]) -> None:
    group_kind = {row[0]: row[2] for row in m.get("groups", []) if isinstance(row, list) and len(row) == 3}
    by_group = Counter()
    by_kind = Counter()
    for entry in m.get("entries", []):
        if isinstance(entry, list) and len(entry) >= 4:
            by_group[str(entry[2])] += 1
            by_kind[str(entry[3])] += 1
    v.info["entry_counts_by_group"] = dict(sorted(by_group.items()))
    v.info["entry_counts_by_kind"] = dict(sorted(by_kind.items()))
    v.info["group_kinds"] = dict(sorted(group_kind.items()))
    v.info["route_metadata"] = {"planning_before_ramp_m": m.get("route", {}).get("planning_before_ramp_m"), "target_m": m.get("route", {}).get("target_m"), "grade_pct": m.get("route", {}).get("grade_pct"), "step_max_m": m.get("route", {}).get("step_max_m"), "cross_slope_pct_max": m.get("route", {}).get("cross_slope_pct_max")}


def validate(manifest: dict[str, Any], fixture: dict[str, Any], repo_root: Path) -> dict[str, Any]:
    v = Validation()
    rule001(v, manifest)
    rule002(v, manifest)
    rule003(v, manifest)
    rule004(v, manifest)
    rule012(v, manifest, fixture)
    rule013(v, manifest)
    rule014(v, manifest)
    rule021(v, manifest)
    rule024(v, manifest)
    rule025(v, manifest)
    rule026(v, manifest, fixture, repo_root)
    rule027(v, manifest, fixture)
    rule030(v, manifest)
    calculate_ramp_info(v, manifest)
    calculate_counts(v, manifest)
    errors = [f for f in v.findings if f["severity"] == "ERROR"]
    warnings = [f for f in v.findings if f["severity"] == "WARNING"]
    passed_rules = sorted({f["rule"] for f in v.findings if f["severity"] == "PASS"})
    return {
        "schema": RESULT_SCHEMA,
        "manifest_schema": manifest.get("schema"),
        "scenario": manifest.get("scenario"),
        "implemented_level": "MANIFEST_STATIC",
        "static_rules_required": STATIC_RULES,
        "static_rules_passed": passed_rules,
        "checks_total": len(STATIC_RULES),
        "errors": len(errors),
        "warnings": len(warnings),
        "result": "FAIL" if errors else "PASS",
        "higher_levels": {"SCENE_STATIC_FUTURE": "NOT_EXECUTED", "RUNTIME_FUTURE": "NOT_EXECUTED", "PHONE_FUTURE": "NOT_EXECUTED"},
        "findings": v.findings,
        "info": v.info,
    }


def print_human(result: dict[str, Any]) -> None:
    print("HUNT01_GRAYBOX_VALIDATION")
    print(f"manifest_schema={result.get('manifest_schema')}")
    print(f"scenario={result.get('scenario')}")
    print(f"checks_total={result.get('checks_total')}")
    print(f"errors={result.get('errors')}")
    print(f"warnings={result.get('warnings')}")
    print(f"result={result.get('result')}")
    for finding in result.get("findings", []):
        measured = json.dumps(finding["measured"], sort_keys=True, separators=(",", ":"))
        expected = json.dumps(finding["expected"], sort_keys=True, separators=(",", ":"))
        print(f"{finding['rule']} | {finding['severity']} | {finding['reference']} | measured={measured} | expected={expected} | {finding['explanation']}")
    ramp = result.get("info", {}).get("observation_ramp", {})
    if ramp:
        print(f"INFO | observation_ramp | {json.dumps(ramp, sort_keys=True, separators=(',', ':'))}")
    print("SCENE_STATIC_FUTURE=NOT_EXECUTED")
    print("RUNTIME_FUTURE=NOT_EXECUTED")
    print("PHONE_FUTURE=NOT_EXECUTED")


def write_json(path: Path, result: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--fixture", type=Path, required=True)
    parser.add_argument("--repo-root", type=Path, default=Path("."))
    parser.add_argument("--json-out", type=Path)
    parser.add_argument("--self-test-invalid", action="store_true", help="Mutate a copy of the manifest and PASS only if the validator rejects it.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        manifest = load_json(args.manifest)
        fixture = load_json(args.fixture)
    except (OSError, json.JSONDecodeError) as exc:
        print(f"HUNT01_GRAYBOX_VALIDATION_FATAL={exc}", file=sys.stderr)
        return 2
    if args.self_test_invalid:
        manifest = copy.deepcopy(manifest)
        manifest["nodes"][0][1][0] = -999
        manifest["nodes"][0][3].append("PRIVATE_INVALID_TERRAIN")
    result = validate(manifest, fixture, args.repo_root)
    print_human(result)
    if args.json_out:
        write_json(args.json_out, result)
    if args.self_test_invalid:
        if result["result"] == "FAIL" and result["errors"] >= 2:
            print("NEGATIVE_SELF_TEST=PASS")
            return 0
        print("NEGATIVE_SELF_TEST=FAIL")
        return 1
    return 0 if result["result"] == "PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())
