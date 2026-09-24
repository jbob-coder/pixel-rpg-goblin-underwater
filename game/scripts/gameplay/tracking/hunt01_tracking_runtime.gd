extends Node

const TRACKING_DATA_PATH := "res://content/regions/region_01/hunt01_tracking_evidence.json"
const EXPECTED_SCHEMA := "uhr.hunt01.tracking_evidence.v1"
const TOTAL_EVIDENCE := 7

const EV01 := "R01_H01_EV01_OUTER_PRINTS"
const EV02 := "R01_H01_EV02_BANK_REEDS"
const EV03 := "R01_H01_EV03_FRESH_WALLOW"
const EV04 := "R01_H01_EV04_WATER_EXIT"
const EV05 := "R01_H01_EV05_OLD_ROOT_SCRAPE"
const EV06 := "R01_H01_EV06_FEEDING_REMAINS"
const EV07 := "R01_H01_EV07_FLATTENED_GRASS_AUDIO"

var _data: Dictionary = {}
var _profiles: Dictionary = {}
var _collected: Dictionary = {}
var _history: Array[String] = []
var _current_inference: Dictionary = {}
var _hunter: CharacterBody3D = null
var _objective_label: Label = null
var _status_label: Label = null
var _evidence_panel: PanelContainer = null
var _bound := false

func _ready() -> void:
	_load_tracking_data()
	call_deferred("_bind_runtime")

func _load_tracking_data() -> void:
	var file := FileAccess.open(TRACKING_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Missing Hunt-01 tracking evidence data: %s" % TRACKING_DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Hunt-01 tracking evidence data is not a JSON object.")
		return
	_data = parsed as Dictionary
	if String(_data.get("schema", "")) != EXPECTED_SCHEMA:
		push_error("Unsupported Hunt-01 tracking schema: %s" % String(_data.get("schema", "")))
		return
	for entry_variant in _data.get("evidence", []):
		var entry: Dictionary = entry_variant
		_profiles[String(entry.get("id", ""))] = entry
	if _profiles.size() != TOTAL_EVIDENCE:
		push_error("Hunt-01 tracking evidence profile count must be %d, got %d." % [TOTAL_EVIDENCE, _profiles.size()])
	_refresh_inference()

func _bind_runtime() -> void:
	var parent := get_parent()
	_hunter = parent.get_node_or_null("Hunter") as CharacterBody3D
	_objective_label = parent.get_node_or_null("HUD/MetricsPanel/Metrics/Objective") as Label
	_status_label = parent.get_node_or_null("HUD/EvidencePanel/EvidenceStatus") as Label
	_evidence_panel = parent.get_node_or_null("HUD/EvidencePanel") as PanelContainer
	if _evidence_panel != null:
		_evidence_panel.offset_bottom = maxf(_evidence_panel.offset_bottom, 178.0)

	var areas := get_tree().get_nodes_in_group("hunt01_evidence")
	for area_variant in areas:
		var area := area_variant as Area3D
		if area == null:
			continue
		var build_id := String(area.get_meta("build_id", area.name))
		area.body_entered.connect(_on_evidence_body_entered.bind(build_id))

	for marker_variant in get_tree().get_nodes_in_group("hunt01_tactical_nodes"):
		var marker := marker_variant as Node3D
		if marker != null:
			marker.visible = false

	_bound = true
	_refresh_presentation()

func _on_evidence_body_entered(body: Node3D, build_id: String) -> void:
	if _hunter != null and body == _hunter:
		_record_evidence(build_id)

func _record_evidence(build_id: String) -> bool:
	if _collected.has(build_id):
		return false
	if not _profiles.has(build_id):
		return false
	_collected[build_id] = true
	_history.append(build_id)
	_refresh_inference()
	_present_latest(_profiles[build_id] as Dictionary)
	return true

func _refresh_inference() -> void:
	var phase := "SEARCHING"
	var confidence := "UNKNOWN"
	var primary_route_id := ""
	var alternate_route_id := ""
	var lead := "Search the outer trail for physical signs."

	if _collected.has(EV07):
		phase = "OBSERVATION_READY"
		confidence = "STRONG"
		primary_route_id = "R01_S03"
		lead = "The trail is extremely recent at the meadow edge. Move carefully and observe before committing to contact."
	elif _collected.has(EV06):
		phase = "MEADOW_CONFIRMATION"
		confidence = "STRONG"
		primary_route_id = "R01_S03"
		lead = "Fresh feeding activity confirms the current trail inside Feeding Meadow. Search the nearby grass line for the newest movement sign."
	elif _collected.has(EV04):
		phase = "FRESH_S03_LEAD"
		confidence = "STRONG"
		primary_route_id = "R01_S03"
		if _collected.has(EV05):
			alternate_route_id = "R01_S02"
			lead = "Fresh water-exit prints toward Feeding Meadow outweigh the old Rootwood scrape. Rootwood remains valid history, not the best current lead."
		else:
			lead = "Fresh water-exit prints strongly favor Feeding Meadow. Follow the physical trail rather than an exact map marker."
	elif _collected.has(EV05):
		phase = "WEAK_S02_HISTORY"
		confidence = "WEAK"
		alternate_route_id = "R01_S02"
		lead = "The Rootwood scrape is real but old. Treat it as territory history and search the River Ford exits for fresher evidence before committing."
	elif _collected.has(EV03):
		phase = "FORD_ACTIVITY"
		confidence = "STRONG"
		lead = "The wallow confirms recent Mudcrest activity at River Ford. Search both exit banks; activity evidence alone does not prove the departure route."
	elif _collected.has(EV02):
		phase = "RIVER_APPROACH"
		confidence = "STRONG"
		primary_route_id = "R01_S01"
		lead = "Fresh bank damage confirms the River Ford lead. Continue through the ford and compare exit signs."
	elif _collected.has(EV01):
		phase = "OUTER_TRAIL"
		confidence = "STRONG"
		primary_route_id = "R01_S01"
		lead = "Heavy fresh prints favor the western/downhill route toward River Ford."

	_current_inference = {
		"phase": phase,
		"confidence": confidence,
		"primary_route_id": primary_route_id,
		"alternate_route_id": alternate_route_id,
		"lead": lead,
	}
	if _bound:
		_refresh_presentation()

func _present_latest(profile: Dictionary) -> void:
	if _status_label == null:
		return
	var title := String(profile.get("display_name", "Evidence"))
	var freshness := String(profile.get("freshness", "UNKNOWN"))
	var confidence := String(profile.get("confidence", "UNKNOWN"))
	var activity := String(profile.get("activity", "UNKNOWN"))
	var summary := String(profile.get("summary", "Evidence investigated."))
	var lead := String(_current_inference.get("lead", ""))
	_status_label.text = "%s • %s / %s • %s\n%s\nTrail read: %s" % [title, freshness, confidence, activity, summary, lead]
	_refresh_objective()

func _refresh_presentation() -> void:
	_refresh_objective()
	if _status_label != null and _history.is_empty():
		_status_label.text = "Investigate physical signs by walking across them. The trail read compares freshness, confidence and activity. Audio is optional."

func _refresh_objective() -> void:
	if _objective_label == null:
		return
	var phase := String(_current_inference.get("phase", "SEARCHING"))
	var confidence := String(_current_inference.get("confidence", "UNKNOWN"))
	var primary_route := String(_current_inference.get("primary_route_id", ""))
	var route_text := _route_display_name(primary_route) if not primary_route.is_empty() else "NO COMMITTED ROUTE"
	_objective_label.text = "Trail Read • %s • %s • Lead: %s" % [phase.replace("_", " "), confidence, route_text]

func _route_display_name(route_id: String) -> String:
	match route_id:
		"R01_S01":
			return "RIVER FORD"
		"R01_S02":
			return "ROOTWOOD THICKET"
		"R01_S03":
			return "FEEDING MEADOW"
		_:
			return "UNRESOLVED"

func get_schema() -> String:
	return String(_data.get("schema", ""))

func is_audio_required() -> bool:
	return bool(_data.get("audio_required", true))

func is_no_gps_enabled() -> bool:
	return bool(_data.get("no_gps", false))

func get_collected_count() -> int:
	return _collected.size()

func get_history() -> Array[String]:
	return _history.duplicate()

func get_current_inference() -> Dictionary:
	return _current_inference.duplicate(true)

func get_profile(build_id: String) -> Dictionary:
	if not _profiles.has(build_id):
		return {}
	return (_profiles[build_id] as Dictionary).duplicate(true)

func record_evidence_for_test(build_id: String) -> bool:
	return _record_evidence(build_id)
