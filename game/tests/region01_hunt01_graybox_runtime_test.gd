extends SceneTree

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _has_collision_descendant(node: Node) -> bool:
	if node is CollisionObject3D:
		return true
	for child in node.get_children():
		if _has_collision_descendant(child):
			return true
	return false

func _has_audio_descendant(node: Node) -> bool:
	if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
		return true
	for child in node.get_children():
		if _has_audio_descendant(child):
			return true
	return false

func _ray_hit_name(world: Node3D, from: Vector3, to: Vector3, exclude: Array[RID] = []) -> String:
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = exclude
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result := world.get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return ""
	var collider: Object = result.get("collider")
	return "" if collider == null else String(collider.get("name"))

func _move_hunter_to_and_wait(hunter: CharacterBody3D, position: Vector3, world: Node3D, expected_count: int) -> bool:
	hunter.global_position = position
	hunter.velocity = Vector3.ZERO
	for _frame in range(8):
		await physics_frame
		await process_frame
		if int(world.call("get_collected_evidence_count")) >= expected_count:
			# Evidence collection and encounter-zone overlap are separate physics consumers.
			# Allow both to settle before the caller inspects derived encounter state.
			await physics_frame
			await process_frame
			await physics_frame
			await process_frame
			return true
	return int(world.call("get_collected_evidence_count")) >= expected_count

func _move_hunter_and_settle(hunter: CharacterBody3D, position: Vector3) -> void:
	hunter.global_position = position
	hunter.velocity = Vector3.ZERO
	for _frame in range(8):
		await physics_frame
		await process_frame

func _all_tactical_nodes_visible() -> bool:
	for marker_variant in get_nodes_in_group("hunt01_tactical_nodes"):
		var marker := marker_variant as Node3D
		if marker != null and not marker.visible:
			return false
	return get_nodes_in_group("hunt01_tactical_nodes").size() == 10

func _all_tactical_nodes_hidden() -> bool:
	for marker_variant in get_nodes_in_group("hunt01_tactical_nodes"):
		var marker := marker_variant as Node3D
		if marker != null and marker.visible:
			return false
	return get_nodes_in_group("hunt01_tactical_nodes").size() == 10

func _run() -> void:
	print("Hunt-01 production integration + tracking + observation/encounter trigger layer")
	var packed := load("res://scenes/regions/region_01_hunt01_graybox.tscn") as PackedScene
	if packed == null:
		_check("production Region-01 scene loads", false, "PackedScene load returned null")
		_finish()
		return

	var world := packed.instantiate() as Node3D
	root.add_child(world)
	await process_frame
	await physics_frame
	await physics_frame
	await process_frame

	_check("world reports built", bool(world.call("is_world_built")))
	var identity: Dictionary = world.call("get_manifest_identity")
	_check("scenario identity", identity.get("scenario") == "R01_HUNT01_M01_TRACK_TO_MEADOW", str(identity))
	_check("hunt identity", identity.get("hunt") == "hunt_r01_m01_proof_01", str(identity))
	_check("monster identity", identity.get("monster") == "monster_r01_m01_0001", str(identity))
	_check("encounter identity", identity.get("encounter") == "enc_r01_ef02_m01_0001", str(identity))

	var route_length := float(world.call("get_required_route_length_m"))
	_check("raw manifest route retains authoritative 3D planning length", route_length >= 279.0 and route_length <= 315.0, "%.3f m" % route_length)
	_check("13 required route visual lanes exist", get_nodes_in_group("hunt01_required_route").size() == 13)
	_check("3 escape route visual lanes exist", get_nodes_in_group("hunt01_escape_route").size() == 3)
	_check("one continuous world foundation exists", get_nodes_in_group("hunt01_foundation").size() == 1)
	_check("foundation covers 440 x 440 m", world.call("get_foundation_size_m") == Vector2(440.0, 440.0), str(world.call("get_foundation_size_m")))
	_check("Hunter movement speed remains 6.25 m/s", is_equal_approx(float(world.call("get_move_speed_mps")), 6.25))

	_check("7 evidence areas exist initially", get_nodes_in_group("hunt01_evidence").size() == 7)
	var all_evidence_are_areas := true
	for evidence in get_nodes_in_group("hunt01_evidence"):
		if not (evidence is Area3D):
			all_evidence_are_areas = false
	_check("all evidence uses walk-over Area3D triggers", all_evidence_are_areas)
	_check("10 tactical nodes exist", get_nodes_in_group("hunt01_tactical_nodes").size() == 10)
	_check("future tactical nodes begin hidden", _all_tactical_nodes_hidden())
	_check("3 streaming proxies exist", get_nodes_in_group("hunt01_stream_proxy").size() == 3)
	_check("one Monster exists", get_nodes_in_group("hunt01_monster").size() == 1)
	_check("two physical cover objects exist", get_nodes_in_group("hunt01_cover").size() == 2)
	_check("environment uses reusable stylized asset instances", get_nodes_in_group("hunt01_environment_asset").size() >= 40)

	var stream_collision_free := true
	for proxy in get_nodes_in_group("hunt01_stream_proxy"):
		if _has_collision_descendant(proxy):
			stream_collision_free = false
	_check("streaming proxies are non-colliding", stream_collision_free)
	_check("normal Region scene has no audio-player dependency", not _has_audio_descendant(world))

	var hunter := world.get_node("Hunter") as CharacterBody3D
	var hunter_exclude: Array[RID] = [hunter.get_rid()]
	_check("S00 has continuous physical ground", _ray_hit_name(world, Vector3(0, 8, -45), Vector3(0, -5, -45), hunter_exclude) == "H01_WORLD_FOUNDATION")
	_check("EF02 Meadow has continuous physical ground", _ray_hit_name(world, Vector3(-45, 8, -250), Vector3(-45, -5, -250), hunter_exclude) == "H01_WORLD_FOUNDATION")
	_check("off-route map area still has physical ground", _ray_hit_name(world, Vector3(80, 8, -100), Vector3(80, -5, -100), hunter_exclude) == "H01_WORLD_FOUNDATION")
	_check("Mudcrest Raker remains solid", _ray_hit_name(world, Vector3(-25, 1.6, -252), Vector3(-10, 1.6, -252), hunter_exclude) == "monster_r01_m01_0001")
	var monster := world.get_node("WorldGeometry/monster_r01_m01_0001") as Node3D
	_check("Mudcrest Raker themed visual exists", monster.get_node_or_null("MudcrestRakerVisual") != null)
	_check("Hunter themed visual exists", world.get_node_or_null("Hunter/Visual") != null)

	var tracking := world.get_node_or_null("TrackingRuntime")
	var encounter := world.get_node_or_null("EncounterRuntime")
	var engage_button := world.get_node("HUD/Touch/EngageEncounter") as Button
	_check("tracking runtime node exists", tracking != null)
	_check("encounter trigger runtime node exists", encounter != null)
	_check("physical observation zone exists", get_nodes_in_group("hunt01_observation_zone").size() == 1)
	_check("physical engagement zone exists", get_nodes_in_group("hunt01_engagement_zone").size() == 1)
	_check("ENGAGE begins hidden and disabled", not engage_button.visible and engage_button.disabled)
	if tracking != null:
		_check("tracking schema v1 loaded", String(tracking.call("get_schema")) == "uhr.hunt01.tracking_evidence.v1")
		_check("tracking does not require audio", not bool(tracking.call("is_audio_required")))
		_check("tracking enforces no-GPS presentation", bool(tracking.call("is_no_gps_enabled")))
		_check("tracking begins unresolved", String((tracking.call("get_current_inference") as Dictionary).get("phase", "")) == "SEARCHING")
	if encounter != null:
		_check("encounter begins SEARCHING", String(encounter.call("get_state")) == "SEARCHING")
		_check("combat does not auto-start before clues", not bool(encounter.call("has_encounter_started")))
		_check("explicit engage is illegal before clues", not bool(encounter.call("engage_for_test")))

	_check("EV01 synchronization completed", await _move_hunter_to_and_wait(hunter, Vector3(-24, 0.875, -68), world, 1))
	_check("EV01 walk-over collected", int(world.call("get_collected_evidence_count")) == 1)
	_check("EV01 disappears", world.get_node_or_null("WorldGeometry/R01_H01_EV01_OUTER_PRINTS") == null)
	if tracking != null:
		var inference: Dictionary = tracking.call("get_current_inference")
		_check("EV01 points toward River Ford", inference.get("phase") == "OUTER_TRAIL" and inference.get("primary_route_id") == "R01_S01", str(inference))

	_check("EV02 synchronization completed", await _move_hunter_to_and_wait(hunter, Vector3(-70, 0.875, -110), world, 2))
	_check("EV02 walk-over collected", int(world.call("get_collected_evidence_count")) == 2)
	if tracking != null:
		_check("EV02 confirms River Ford approach", String((tracking.call("get_current_inference") as Dictionary).get("phase", "")) == "RIVER_APPROACH")

	_check("EV03 synchronization completed", await _move_hunter_to_and_wait(hunter, Vector3(-100, 0.875, -140), world, 3))
	_check("EV03 walk-over collected", int(world.call("get_collected_evidence_count")) == 3)
	if tracking != null:
		var inference: Dictionary = tracking.call("get_current_inference")
		_check("EV03 is activity evidence, not a forced route", inference.get("phase") == "FORD_ACTIVITY" and inference.get("primary_route_id") == "", str(inference))

	_check("EV05 synchronization completed", await _move_hunter_to_and_wait(hunter, Vector3(-35, 0.875, -145), world, 4))
	_check("EV05 old Rootwood clue can be investigated", int(world.call("get_collected_evidence_count")) == 4)
	if tracking != null:
		var inference: Dictionary = tracking.call("get_current_inference")
		_check("old S02 clue remains legal but weak", inference.get("phase") == "WEAK_S02_HISTORY" and inference.get("alternate_route_id") == "R01_S02" and inference.get("confidence") == "WEAK", str(inference))

	_check("EV04 synchronization completed", await _move_hunter_to_and_wait(hunter, Vector3(-78, 0.875, -168), world, 5))
	_check("EV04 fresh water-exit clue can be investigated", int(world.call("get_collected_evidence_count")) == 5)
	if tracking != null:
		var inference: Dictionary = tracking.call("get_current_inference")
		_check("fresh S03 clue outweighs old S02 clue", inference.get("phase") == "FRESH_S03_LEAD" and inference.get("primary_route_id") == "R01_S03" and inference.get("alternate_route_id") == "R01_S02", str(inference))
		_check("route comparison explains confidence instead of GPS", String(inference.get("lead", "")).contains("outweigh") and not String(inference.get("lead", "")).contains("-252"))

	_check("EV06 synchronization completed", await _move_hunter_to_and_wait(hunter, Vector3(-59, 0.875, -220), world, 6))
	_check("EV06 feeding evidence collected", int(world.call("get_collected_evidence_count")) == 6)
	if tracking != null:
		_check("feeding remains confirm Meadow activity", String((tracking.call("get_current_inference") as Dictionary).get("phase", "")) == "MEADOW_CONFIRMATION")

	_check("EV07 synchronization completed", await _move_hunter_to_and_wait(hunter, Vector3(-67, 0.875, -232), world, 7))
	_check("EV07 final pre-contact sign collected", int(world.call("get_collected_evidence_count")) == 7)
	_check("all collected physical evidence disappears", get_nodes_in_group("hunt01_evidence").size() == 0)
	if tracking != null:
		var final_inference: Dictionary = tracking.call("get_current_inference")
		_check("final tracking phase reaches observation-ready", final_inference.get("phase") == "OBSERVATION_READY" and final_inference.get("primary_route_id") == "R01_S03", str(final_inference))
		var history: Array = tracking.call("get_history")
		_check("tracking keeps deterministic seven-clue history", history.size() == 7, str(history))
		_check("tracking count agrees with world evidence state", int(tracking.call("get_collected_count")) == 7)
		var ev05_profile: Dictionary = tracking.call("get_profile", "R01_H01_EV05_OLD_ROOT_SCRAPE")
		_check("old Rootwood profile remains explicitly OLD / WEAK", ev05_profile.get("freshness") == "OLD" and ev05_profile.get("confidence") == "WEAK")
		var ev07_profile: Dictionary = tracking.call("get_profile", "R01_H01_EV07_FLATTENED_GRASS_AUDIO")
		_check("final visual clue explicitly works without audio", String(ev07_profile.get("summary", "")).contains("audio is optional"))

	_check("same evidence cannot be collected twice", not bool(world.call("collect_evidence_for_test", "R01_H01_EV01_OUTER_PRINTS")))
	if encounter != null:
		_check("clue completion alone still does not auto-start combat", not bool(encounter.call("has_encounter_started")))
		_check("EV07 position reaches observation but not engagement", String(encounter.call("get_state")) == "OBSERVATION_AVAILABLE", String(encounter.call("get_state")))
		_check("ENGAGE stays hidden until physical engagement position", not engage_button.visible and engage_button.disabled)

	var first_person_camera := world.get_node("Hunter/FirstPersonCamera") as Camera3D
	var aerial_camera := world.get_node("AerialCamera") as Camera3D
	_check("first-person FOV remains 115 degrees", is_equal_approx(first_person_camera.fov, 115.0))
	world.call("_on_toggle_view_pressed")
	_check("manual view toggle enters first person before combat", first_person_camera.current and not aerial_camera.current)
	world.call("_on_toggle_view_pressed")
	_check("manual view toggle returns to aerial before combat", aerial_camera.current and not first_person_camera.current)

	world.call("_on_reset_to_start_pressed")
	_check("reset returns Hunter to S00 before encounter", hunter.global_position.distance_to(Vector3(0, 0.875, -45)) < 0.001)
	_check("reset does not create a duplicate world", root.get_children().size() == 1)

	await _move_hunter_and_settle(hunter, Vector3(-72, 0.875, -236))
	if encounter != null:
		_check("Hunter physically enters observation zone", bool(encounter.call("is_inside_observation_zone")))
		_check("Hunter physically enters engagement zone near N01", bool(encounter.call("is_inside_engagement_zone")))
		_check("engagement becomes explicitly available", String(encounter.call("get_state")) == "ENGAGEMENT_AVAILABLE", String(encounter.call("get_state")))
		_check("ENGAGE becomes visible and enabled", engage_button.visible and not engage_button.disabled)

	var hunter_before := hunter.global_transform
	var monster_before := monster.global_transform
	if encounter != null:
		_check("explicit ENGAGE succeeds", bool(encounter.call("engage_for_test")))
		_check("encounter starts exactly once", bool(encounter.call("has_encounter_started")))
		_check("encounter state is first-person staged", String(encounter.call("get_state")) == "ENCOUNTER_STAGED_FIRST_PERSON")
		var record: Dictionary = encounter.call("get_encounter_record")
		_check("stable encounter ID preserved", record.get("encounter_id") == "enc_r01_ef02_m01_0001", str(record))
		_check("stable footprint and entry node preserved", record.get("footprint_id") == "R01_EF02" and record.get("player_tactical_node") == "R01_EF02_N01", str(record))
		_check("same Monster identity preserved", record.get("monster_id") == "monster_r01_m01_0001", str(record))
		_check("source sector preserved", record.get("source_sector_id") == "R01_S03", str(record))
		_check("duplicate ENGAGE rejected", not bool(encounter.call("engage_for_test")))

	_check("engagement does not teleport Hunter", hunter.global_transform.is_equal_approx(hunter_before), str(hunter.global_position))
	_check("engagement does not teleport Monster", monster.global_transform.is_equal_approx(monster_before), str(monster.global_position))
	_check("engagement enters first-person at same world location", first_person_camera.current and not aerial_camera.current)
	_check("tactical nodes become visible only after encounter entry", _all_tactical_nodes_visible())
	_check("view toggle button locks during staged encounter", (world.get_node("HUD/Touch/ToggleView") as Button).disabled)
	_check("escape corridor remains physically represented after encounter staging", get_nodes_in_group("hunt01_escape_route").size() == 3)
	_check("no attack runtime was introduced by encounter staging", world.get_node_or_null("AttackRuntime") == null and world.get_node_or_null("CombatResolutionRuntime") == null)

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: HUNT01_PRODUCTION_GRAYBOX_HEADLESS_INTEGRATION_VERIFIED")
		print("Gate: HUNT01_TRACKING_EVIDENCE_RUNTIME_VERIFIED")
		print("Gate: HUNT01_OBSERVATION_ENCOUNTER_TRIGGER_RUNTIME_VERIFIED")
	else:
		print("Gate: HUNT01_PRODUCTION_GRAYBOX_HEADLESS_INTEGRATION_FAILED")
		print("Gate: HUNT01_TRACKING_EVIDENCE_RUNTIME_FAILED")
		print("Gate: HUNT01_OBSERVATION_ENCOUNTER_TRIGGER_RUNTIME_FAILED")
	print("H01VAL005_FINAL_SMOOTHED_ROUTE_LENGTH=NOT_EXECUTED")
	print("Phone/user acceptance is intentionally deferred and does not block independent layer development.")
	quit(0 if failures.is_empty() else 1)