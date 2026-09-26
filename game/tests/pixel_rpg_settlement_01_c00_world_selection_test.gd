extends SceneTree

const WORLD_SELECTION := preload("res://scripts/startup/pixel_rpg_world_selection_001.gd")
const APP_SHELL_SCENE: PackedScene = preload("res://scenes/app_shell.tscn")
const CANDIDATE_SCENE: PackedScene = preload("res://scenes/prototypes/settlement_01_candidate_c00.tscn")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _run() -> void:
	print("Pixel RPG Settlement 01 C00 — parallel world-selection seam gate")

	_check("world-selection schema is stable", WORLD_SELECTION.get_schema() == "pixel_rpg.world_selection_001.v1")
	_check("legacy compact world remains the default mode", WORLD_SELECTION.get_default_mode() == WORLD_SELECTION.MODE_LEGACY_COMPACT_WORLD)
	_check("exactly two internal world modes are supported", WORLD_SELECTION.get_supported_modes() == [
		WORLD_SELECTION.MODE_LEGACY_COMPACT_WORLD,
		WORLD_SELECTION.MODE_SETTLEMENT_01_CANDIDATE,
	])

	var legacy: Dictionary = WORLD_SELECTION.resolve_mode(WORLD_SELECTION.MODE_LEGACY_COMPACT_WORLD)
	_check("legacy mode resolves successfully", bool(legacy.get("success", false)), str(legacy))
	_check("legacy mode resolves the existing prototype scene",
		String(legacy.get("scene_path", "")) == "res://scenes/prototypes/pixel_rpg_prototype_001.tscn",
		str(legacy)
	)
	_check("legacy mode uses no fallback", not bool(legacy.get("fallback_used", true)))

	var candidate: Dictionary = WORLD_SELECTION.resolve_mode(WORLD_SELECTION.MODE_SETTLEMENT_01_CANDIDATE)
	_check("Settlement 01 candidate mode resolves successfully", bool(candidate.get("success", false)), str(candidate))
	_check("candidate mode resolves only the C00 candidate shell",
		String(candidate.get("scene_path", "")) == "res://scenes/prototypes/settlement_01_candidate_c00.tscn",
		str(candidate)
	)

	var invalid: Dictionary = WORLD_SELECTION.resolve_mode("BAD_WORLD_MODE")
	_check("invalid mode fails closed", not bool(invalid.get("success", true)), str(invalid))
	_check("invalid mode falls back to legacy compact world",
		bool(invalid.get("fallback_used", false))
		and String(invalid.get("selected_mode", "")) == WORLD_SELECTION.MODE_LEGACY_COMPACT_WORLD
		and String(invalid.get("scene_path", "")) == WORLD_SELECTION.LEGACY_SCENE_PATH,
		str(invalid)
	)

	var had_setting := ProjectSettings.has_setting(WORLD_SELECTION.PROJECT_SETTING_KEY)
	var previous_setting: Variant = null
	if had_setting:
		previous_setting = ProjectSettings.get_setting(WORLD_SELECTION.PROJECT_SETTING_KEY)

	if had_setting:
		ProjectSettings.set_setting(WORLD_SELECTION.PROJECT_SETTING_KEY, null)
	_check("unset project setting resolves legacy default",
		WORLD_SELECTION.get_configured_mode() == WORLD_SELECTION.MODE_LEGACY_COMPACT_WORLD,
		WORLD_SELECTION.get_configured_mode()
	)

	ProjectSettings.set_setting(
		WORLD_SELECTION.PROJECT_SETTING_KEY,
		WORLD_SELECTION.MODE_SETTLEMENT_01_CANDIDATE
	)
	var configured_candidate := WORLD_SELECTION.resolve_configured_selection()
	_check("explicit internal candidate setting resolves candidate path",
		bool(configured_candidate.get("success", false))
		and String(configured_candidate.get("selected_mode", "")) == WORLD_SELECTION.MODE_SETTLEMENT_01_CANDIDATE,
		str(configured_candidate)
	)

	var shell := APP_SHELL_SCENE.instantiate()
	_check("AppShell scene instantiates without entering tree", shell != null)
	if shell != null:
		var shell_target: Dictionary = shell.call("resolve_startup_target")
		_check("AppShell resolves startup through the shared world-selection contract",
			String(shell_target.get("selected_mode", "")) == WORLD_SELECTION.MODE_SETTLEMENT_01_CANDIDATE,
			str(shell_target)
		)
		shell.free()

	if had_setting:
		ProjectSettings.set_setting(WORLD_SELECTION.PROJECT_SETTING_KEY, previous_setting)
	else:
		ProjectSettings.set_setting(WORLD_SELECTION.PROJECT_SETTING_KEY, null)

	var candidate_root := CANDIDATE_SCENE.instantiate()
	_check("C00 candidate scene instantiates", candidate_root != null)
	if candidate_root != null:
		var status: Dictionary = candidate_root.call("get_candidate_status")
		_check("C00 candidate shell validates G00/G14/G15/G16/G17 dependencies",
			bool(status.get("success", false)),
			str(status.get("errors", []))
		)
		_check("candidate shell explicitly reports no player owner yet", not bool(status.get("player_owner_present", true)))
		_check("candidate shell explicitly reports no camera owner yet", not bool(status.get("camera_owner_present", true)))
		_check("candidate shell explicitly reports no production cutover", not bool(status.get("production_cutover", true)))
		_check("candidate shell exposes locked five-section/twelve-area identity",
			int(status.get("settlement_section_count", 0)) == 5
			and int(status.get("settlement_area_count", 0)) == 12,
			str(status)
		)
		_check("candidate shell contains no CharacterBody3D duplicate",
			candidate_root.find_children("*", "CharacterBody3D", true, false).is_empty()
		)
		_check("candidate shell contains no Camera3D duplicate",
			candidate_root.find_children("*", "Camera3D", true, false).is_empty()
		)
		candidate_root.free()

	_check("C00 does not alter production project.godot world mode",
		not ProjectSettings.has_setting(WORLD_SELECTION.PROJECT_SETTING_KEY)
		or String(ProjectSettings.get_setting(WORLD_SELECTION.PROJECT_SETTING_KEY, WORLD_SELECTION.DEFAULT_MODE)) == WORLD_SELECTION.DEFAULT_MODE
	)

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_C00_WORLD_SELECTION_SEAM_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_C00_WORLD_SELECTION_SEAM_FAILED")
	print("This gate verifies a reversible startup selection seam with legacy compact world as default and a non-default Settlement 01 C00 candidate shell. It does not add a candidate player/camera, cut over production, alter project.godot defaults, enable final art, or prove device behavior.")
	quit(0 if failures.is_empty() else 1)
