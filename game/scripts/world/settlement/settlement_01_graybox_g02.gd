extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_graybox.g02.v1"

const Layout := preload("res://scripts/world/settlement/settlement_01_layout_g00.gd")
const G01 := preload("res://scripts/world/settlement/settlement_01_graybox_g01.gd")

const PLAZA_ROOT_NAME := "CentralMarketPlazaG02"
const AREA_ID := "SET01_A05_CENTRAL_MARKET_PLAZA"
const STALL_FOOTPRINT_COLOR := Color(0.34, 0.23, 0.13)
const WATER_PLACEHOLDER_COLOR := Color(0.24, 0.48, 0.56)
const NOTICE_PLACEHOLDER_COLOR := Color(0.48, 0.34, 0.18)

const STALL_SPECS := {
	"StallSocket_SW": {
		"center_x": -11.0,
		"center_z": 8.5,
		"width_m": 4.0,
		"depth_m": 3.0,
		"role": "GENERAL_GOODS",
	},
	"StallSocket_SE": {
		"center_x": 11.0,
		"center_z": 8.5,
		"width_m": 4.0,
		"depth_m": 3.0,
		"role": "FOOD_BASIC_SUPPLY",
	},
	"StallSocket_NW": {
		"center_x": -11.0,
		"center_z": -8.5,
		"width_m": 4.0,
		"depth_m": 3.0,
		"role": "CIVIC_LOCAL_ROTATING",
	},
	"StallSocket_NE": {
		"center_x": 11.0,
		"center_z": -8.5,
		"width_m": 4.0,
		"depth_m": 3.0,
		"role": "HUNTER_MATERIAL",
	},
}

const WATER_SPEC := {
	"id": "SET01_A05_CIVIC_WATER_PLACEHOLDER",
	"center_x": -7.0,
	"center_z": -5.5,
	"diameter_m": 2.5,
}

const NOTICE_SPEC := {
	"id": "SET01_A05_NOTICE_BOARD_SOCKET",
	"center_x": 7.7,
	"center_z": -5.8,
	"width_m": 2.0,
	"depth_m": 0.5,
}

const SOCIAL_ANCHOR_SPECS := {
	"SocialAnchor_01": {"x": -7.0, "z": 4.8},
	"SocialAnchor_02": {"x": 7.0, "z": 4.8},
	"SocialAnchor_03": {"x": -6.6, "z": -11.2},
	"SocialAnchor_04": {"x": 6.6, "z": 11.2},
	"NoticeReadAnchor": {"x": 6.3, "z": -5.8},
	"WaterSocialAnchor": {"x": -5.2, "z": -5.5},
}

static func get_schema() -> String:
	return SCHEMA

static func get_stall_specs() -> Dictionary:
	return STALL_SPECS.duplicate(true)

static func get_water_spec() -> Dictionary:
	return WATER_SPEC.duplicate(true)

static func get_notice_spec() -> Dictionary:
	return NOTICE_SPEC.duplicate(true)

static func get_social_anchor_specs() -> Dictionary:
	return SOCIAL_ANCHOR_SPECS.duplicate(true)

static func build(parent: Node3D, include_debug_markers := false) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G02 graybox requires a valid parent.")
		return {}

	var base: Dictionary = G01.build(parent, include_debug_markers)
	var graybox_root := base.get("root") as Node3D
	if graybox_root == null:
		push_error("Settlement 01 G02 failed to build G01 base.")
		return {}

	var plaza := Node3D.new()
	plaza.name = PLAZA_ROOT_NAME
	plaza.set_meta("area_id", AREA_ID)
	plaza.set_meta("schema", SCHEMA)
	plaza.set_meta("presentation_only", true)
	graybox_root.add_child(plaza)

	var stall_sockets: Dictionary = {}
	for socket_variant in STALL_SPECS.keys():
		var socket_name := String(socket_variant)
		var socket := _add_stall_socket(plaza, socket_name, STALL_SPECS[socket_name] as Dictionary)
		stall_sockets[socket_name] = socket

	var civic_water := _add_civic_water_placeholder(plaza)
	var notice_socket := _add_notice_board_socket(plaza)

	var social_anchors: Dictionary = {}
	for anchor_variant in SOCIAL_ANCHOR_SPECS.keys():
		var anchor_name := String(anchor_variant)
		var anchor := _add_marker(
			plaza,
			anchor_name,
			SOCIAL_ANCHOR_SPECS[anchor_name] as Dictionary
		)
		anchor.set_meta("anchor_kind", "SOCIAL")
		social_anchors[anchor_name] = anchor

	base["plaza_root"] = plaza
	base["stall_sockets"] = stall_sockets
	base["civic_water"] = civic_water
	base["notice_socket"] = notice_socket
	base["social_anchors"] = social_anchors
	return base

static func _add_stall_socket(parent: Node3D, socket_name: String, spec: Dictionary) -> Marker3D:
	var socket := Marker3D.new()
	socket.name = socket_name
	socket.position = Vector3(
		float(spec.get("center_x", 0.0)),
		0.045,
		float(spec.get("center_z", 0.0))
	)
	socket.set_meta("socket_kind", "MARKET_STALL")
	socket.set_meta("role", String(spec.get("role", "")))
	socket.set_meta("width_m", float(spec.get("width_m", 0.0)))
	socket.set_meta("depth_m", float(spec.get("depth_m", 0.0)))
	socket.set_meta("presentation_only", true)
	parent.add_child(socket)

	var footprint := MeshInstance3D.new()
	footprint.name = "Footprint"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(
		float(spec.get("width_m", 0.0)),
		0.04,
		float(spec.get("depth_m", 0.0))
	)
	footprint.mesh = mesh
	footprint.material_override = _material(STALL_FOOTPRINT_COLOR)
	footprint.set_meta("presentation_only", true)
	socket.add_child(footprint)
	return socket

static func _add_civic_water_placeholder(parent: Node3D) -> MeshInstance3D:
	var water := MeshInstance3D.new()
	water.name = "CivicWaterPlaceholder"
	water.position = Vector3(
		float(WATER_SPEC.get("center_x", 0.0)),
		0.07,
		float(WATER_SPEC.get("center_z", 0.0))
	)
	water.set_meta("placeholder_id", String(WATER_SPEC.get("id", "")))
	water.set_meta("presentation_only", true)

	var mesh := CylinderMesh.new()
	var radius := float(WATER_SPEC.get("diameter_m", 0.0)) * 0.5
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = 0.14
	water.mesh = mesh
	water.material_override = _material(WATER_PLACEHOLDER_COLOR)
	parent.add_child(water)
	return water

static func _add_notice_board_socket(parent: Node3D) -> Marker3D:
	var socket := Marker3D.new()
	socket.name = "NoticeBoardSocket"
	socket.position = Vector3(
		float(NOTICE_SPEC.get("center_x", 0.0)),
		0.9,
		float(NOTICE_SPEC.get("center_z", 0.0))
	)
	socket.set_meta("socket_kind", "CIVIC_NOTICE_BOARD")
	socket.set_meta("placeholder_id", String(NOTICE_SPEC.get("id", "")))
	socket.set_meta("width_m", float(NOTICE_SPEC.get("width_m", 0.0)))
	socket.set_meta("depth_m", float(NOTICE_SPEC.get("depth_m", 0.0)))
	socket.set_meta("presentation_only", true)
	parent.add_child(socket)

	var board := MeshInstance3D.new()
	board.name = "BoardPlaceholder"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(
		float(NOTICE_SPEC.get("width_m", 0.0)),
		1.2,
		float(NOTICE_SPEC.get("depth_m", 0.0))
	)
	board.mesh = mesh
	board.material_override = _material(NOTICE_PLACEHOLDER_COLOR)
	board.set_meta("presentation_only", true)
	socket.add_child(board)
	return socket

static func _add_marker(parent: Node3D, marker_name: String, spec: Dictionary) -> Marker3D:
	var marker := Marker3D.new()
	marker.name = marker_name
	marker.position = Vector3(
		float(spec.get("x", 0.0)),
		0.05,
		float(spec.get("z", 0.0))
	)
	marker.set_meta("presentation_only", true)
	parent.add_child(marker)
	return marker

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return material
