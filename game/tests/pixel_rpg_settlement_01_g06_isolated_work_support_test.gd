extends SceneTree

const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_base.gd")
const G02 := preload("res://scripts/world/settlement/settlement_01_plaza_graybox.gd")
const G03 := preload("res://scripts/world/settlement/settlement_01_smith_graybox.gd")
const G04 := preload("res://scripts/world/settlement/settlement_01_community_hall_graybox.gd")
const G05 := preload("res://scripts/world/settlement/settlement_01_residential_graybox.gd")
const G06 := preload("res://scripts/world/settlement/settlement_01_work_support_graybox.gd")
const LAYOUT := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")
const PROTOTYPE_SCENE: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")

var failures: Array[String] = []
var checks := 0

func _init() -> void:
	call_deferred("_run")

func _check(label: String, condition: bool, detail: String = "") -> void:
	checks += 1
	print("[%s] %s%s" % ["PASS" if condition else "FAIL", label, " :: " + detail if not detail.is_empty() else ""])
	if not condition:
		failures.append(label)

func _vec3_equal(left: Vector3, right: Vector3, epsilon := 0.0001) -> bool:
	return left.distance_to(right) <= epsilon

func _shape_size(body: StaticBody3D) -> Vector3:
	if body == null:
		return Vector3.ZERO
	var collision := body.get_node_or_null("Shape") as CollisionShape3D
	if collision == null or not (collision.shape is BoxShape3D):
		return Vector3.ZERO
	return (collision.shape as BoxShape3D).size

func _run() -> void:
	print("Pixel RPG Settlement 01 G06 — isolated Work Support gate")

	_check("G06 work-support schema is stable", String(G06.get_schema()) == "pixel_rpg.settlement_01_work_support_graybox.v1")
	var layout_validation: Dictionary = LAYOUT.validate_contract()
	_check("G00 layout contract remains valid", bool(layout_validation.get("success", false)), str(layout_validation.get("errors", [])))

	var host := Node3D.new()
	host.name = "G06IsolatedHost"
	root.add_child(host)

	var g01: Dictionary = G01.add_graybox_base(host)
	var base_root := g01.get("root") as Node3D
	_check("G01 isolated base still builds", base_root != null)
	_check("G02 isolated plaza still builds", G02.add_plaza(base_root).get("root") != null)
	var g03: Dictionary = G03.add_smith(base_root)
	var smith := g03.get("smith") as Node3D
	_check("G03 isolated Smith still builds", smith != null)
	_check("G04 isolated Community Hall still builds", G04.add_community_hall(base_root).get("hall") != null)
	var g05: Dictionary = G05.add_residences(base_root)
	_check("G05 isolated residences still build", g05.get("residence_w02") != null and g05.get("residence_w01") != null)

	var g06: Dictionary = G06.add_work_support(base_root)
	var g06_root := g06.get("root") as Node3D
	var canopy := g06.get("canopy") as Node3D
	var storage := g06.get("storage") as Node3D

	_check("G06 work-support root is created", g06_root != null and g06_root.name == "StorageWorkshopYardGraybox")
	_check("G06 canopy exists at locked north pocket", canopy != null and _vec3_equal(canopy.position, Vector3(24.5, 0.0, -9.5)), str(canopy.position) if canopy != null else "missing")
	_check("G06 storage exists at locked south pocket", storage != null and _vec3_equal(storage.position, Vector3(24.5, 0.0, 9.5)), str(storage.position) if storage != null else "missing")

	if canopy != null:
		_check("canopy carries stable ID", String(canopy.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_WORK_CANOPY")
		_check("canopy carries S04/A10 ownership", String(canopy.get_meta("pixel_rpg_section_id", "")) == "SET01_S04" and String(canopy.get_meta("pixel_rpg_area_id", "")) == "SET01_A10_STORAGE_WORKSHOP_YARD")
		_check("canopy final art remains unlocked", not bool(canopy.get_meta("pixel_rpg_final_art_locked", true)))
		_check("canopy is open-sided with no wall collision nodes",
			canopy.get_node_or_null("Collision/WestWallCollision") == null
			and canopy.get_node_or_null("Collision/EastWallCollision") == null
			and canopy.get_node_or_null("Collision/NorthWallCollision") == null
			and canopy.get_node_or_null("Collision/SouthWallCollision") == null
		)
		_check("canopy has exactly four structural post colliders",
			canopy.has_node("Collision/PostCollision01")
			and canopy.has_node("Collision/PostCollision02")
			and canopy.has_node("Collision/PostCollision03")
			and canopy.has_node("Collision/PostCollision04")
		)
		_check("canopy exposes work/load/service anchors",
			canopy.has_node("WorkAnchor_01")
			and canopy.has_node("WorkAnchor_02")
			and canopy.has_node("MaterialRackAnchor")
			and canopy.has_node("CartAnchor")
			and canopy.has_node("WorkerIdleAnchor")
			and canopy.has_node("ServiceLaneAnchor")
		)

	if storage != null:
		_check("storage carries stable ID", String(storage.get_meta("pixel_rpg_building_id", "")) == "SET01_BLD_WORK_STORAGE")
		_check("storage carries S04/A10 ownership", String(storage.get_meta("pixel_rpg_section_id", "")) == "SET01_S04" and String(storage.get_meta("pixel_rpg_area_id", "")) == "SET01_A10_STORAGE_WORKSHOP_YARD")
		_check("storage final art remains unlocked", not bool(storage.get_meta("pixel_rpg_final_art_locked", true)))
		var entrance := storage.get_node_or_null("EntranceAnchor") as Marker3D
		_check("storage has west-facing EntranceAnchor", entrance != null and entrance.global_position.x < storage.global_position.x, str(entrance.global_position) if entrance != null else "missing")
		_check("storage exposes Exit/Use/Worker/Loading anchors",
			storage.has_node("ExitAnchor")
			and storage.has_node("StorageUseAnchor")
			and storage.has_node("WorkerIdleAnchor")
			and storage.has_node("LoadingAnchor")
		)
		var west_north := storage.get_node_or_null("Collision/WestNorthCollision") as StaticBody3D
		var west_south := storage.get_node_or_null("Collision/WestSouthCollision") as StaticBody3D
		var west_lintel := storage.get_node_or_null("Collision/WestLintelCollision") as StaticBody3D
		_check("storage west facade collision is segmented", west_north != null and west_south != null and west_lintel != null)
		_check("storage has no monolithic StorageCollision", storage.get_node_or_null("StorageCollision") == null)

		if west_north != null and west_south != null and west_lintel != null:
			var north_size: Vector3 = _shape_size(west_north)
			var south_size: Vector3 = _shape_size(west_south)
			var lintel_size: Vector3 = _shape_size(west_lintel)
			var north_inner_z: float = west_north.position.z + north_size.z * 0.5
			var south_inner_z: float = west_south.position.z - south_size.z * 0.5
			var doorway_gap: float = south_inner_z - north_inner_z
			var lintel_bottom: float = west_lintel.position.y - lintel_size.y * 0.5
			_check("storage doorway width remains 1.8 m", absf(doorway_gap - 1.8) <= 0.02, "gap=%.3f" % doorway_gap)
			_check("storage doorway height remains 2.3 m", lintel_bottom >= 2.3 - 0.02, "lintel_bottom=%.3f" % lintel_bottom)

	if smith != null and canopy != null and storage != null:
		_check("Smith stays between north canopy and south storage", canopy.position.z < smith.position.z and smith.position.z < storage.position.z)
		var smith_half_depth: float = 6.4 * 0.5
		var support_half_depth: float = 6.0 * 0.5
		var north_gap: float = (smith.position.z - smith_half_depth) - (canopy.position.z + support_half_depth)
		var south_gap: float = (storage.position.z - support_half_depth) - (smith.position.z + smith_half_depth)
		_check("canopy keeps >3 m gap from Smith", north_gap >= 3.0, "gap=%.3f" % north_gap)
		_check("storage keeps >3 m gap from Smith", south_gap >= 3.0, "gap=%.3f" % south_gap)

	await physics_frame
	var space_state := host.get_world_3d().direct_space_state

	if storage != null:
		var storage_door_query := PhysicsRayQueryParameters3D.create(
			storage.to_global(Vector3(-4.4, 0.9, 0.8)),
			storage.to_global(Vector3(-3.0, 0.9, 0.8))
		)
		storage_door_query.collision_mask = 1
		var storage_door_hit := space_state.intersect_ray(storage_door_query)
		_check("storage physics ray passes through real west doorway", storage_door_hit.is_empty(), str(storage_door_hit))

		var storage_wall_query := PhysicsRayQueryParameters3D.create(
			storage.to_global(Vector3(-4.4, 0.9, -1.5)),
			storage.to_global(Vector3(-3.0, 0.9, -1.5))
		)
		storage_wall_query.collision_mask = 1
		var storage_wall_hit := space_state.intersect_ray(storage_wall_query)
		_check("storage adjacent west wall blocks physics", not storage_wall_hit.is_empty(), str(storage_wall_hit))

	if canopy != null:
		var canopy_open_query := PhysicsRayQueryParameters3D.create(
			canopy.to_global(Vector3(-4.2, 0.9, 0.0)),
			canopy.to_global(Vector3(4.2, 0.9, 0.0))
		)
		canopy_open_query.collision_mask = 1
		var canopy_open_hit := space_state.intersect_ray(canopy_open_query)
		_check("canopy center remains traversable west-to-east", canopy_open_hit.is_empty(), str(canopy_open_hit))

	var east_frontage_lane_max_x: float = 16.25 + 4.5 * 0.5
	for support_variant in [canopy, storage]:
		var support := support_variant as Node3D
		if support == null:
			continue
		var support_min_x: float = support.position.x - 7.0 * 0.5
		_check("%s footprint keeps 2.5 m frontage clearance" % support.name, support_min_x - east_frontage_lane_max_x >= 2.5 - 0.001, "support_min_x=%.3f lane_max_x=%.3f" % [support_min_x, east_frontage_lane_max_x])

	var prototype := PROTOTYPE_SCENE.instantiate()
	_check("current prototype still instantiates", prototype != null)
	if prototype != null:
		root.add_child(prototype)
		var current_smith := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack004EnterableSmith") as Node3D
		var current_market := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Market") as Node3D
		var current_gate := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/WorldPack001Gate") as Node3D
		_check("current production Smith remains unchanged", current_smith != null and _vec3_equal(current_smith.position, Vector3(-7.4, 0.0, -1.5)), str(current_smith.position) if current_smith != null else "missing")
		_check("current production Market remains unchanged", current_market != null and _vec3_equal(current_market.position, Vector3(7.0, 0.0, 6.0)), str(current_market.position) if current_market != null else "missing")
		_check("current production Gate remains unchanged", current_gate != null and _vec3_equal(current_gate.position, Vector3(0.0, 0.0, -10.0)), str(current_gate.position) if current_gate != null else "missing")
		_check("current production world has no isolated G06 canopy", prototype.find_child("Settlement01WorkCanopy", true, false) == null)
		_check("current production world has no isolated G06 storage", prototype.find_child("Settlement01WorkStorage", true, false) == null)

	if prototype != null:
		prototype.queue_free()
	host.queue_free()
	await process_frame
	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G06_ISOLATED_WORK_SUPPORT_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_SETTLEMENT_01_G06_ISOLATED_WORK_SUPPORT_FAILED")
	print("This gate verifies the locked A10 storage/canopy support around the Smith, including a real storage doorway, open canopy traversal, stable work/load anchors and frontage/Smith clearances while proving current app-boot settlement placement remains unchanged. Final work-district art, crafting/economy integration, streaming, persistence, world cutover and device acceptance remain outside G06.")
	quit(0 if failures.is_empty() else 1)
