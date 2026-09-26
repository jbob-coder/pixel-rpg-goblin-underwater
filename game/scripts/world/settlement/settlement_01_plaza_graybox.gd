class_name PixelRPGSettlement01PlazaGraybox
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_plaza_graybox.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const ROOT_NAME := "CentralMarketPlazaGraybox"
const PLAZA_SURFACE_NAME := "PlazaSurface"
const STALL_SOCKETS_NAME := "MarketStallSockets"
const SOCIAL_ANCHORS_NAME := "SocialAnchors"
const WATER_PLACEHOLDER_NAME := "CivicWaterPlaceholder"
const NOTICE_PLACEHOLDER_NAME := "CivicNoticePlaceholder"

const PLAZA_SURFACE_HEIGHT := 0.02
const PLAZA_SURFACE_CENTER_Y := 0.01
const SOCKET_SURFACE_HEIGHT := 0.02
const SOCKET_SURFACE_CENTER_Y := 0.045

const PLAZA_COLOR := Color(0.42, 0.35, 0.23)
const STALL_SOCKET_COLOR := Color(0.62, 0.46, 0.24, 0.72)
const WATER_COLOR := Color(0.20, 0.48, 0.58, 0.80)
const NOTICE_COLOR := Color(0.48, 0.32, 0.18, 0.86)

const STALL_FOOTPRINT_XZ := Vector2(4.0, 3.0)

const STALL_SOCKET_SPECS := {
	"SET01_A05_STALL_SW": Vector2(-11.0, 8.5),
	"SET01_A05_STALL_SE": Vector2(11.0, 8.5),
	"SET01_A05_STALL_NW": Vector2(-11.0, -8.5),
	"SET01_A05_STALL_NE": Vector2(11.0, -8.5),
}

# These are G02 placeholder positions only. They intentionally remain outside
# the locked Main Spine and Central Cross Street and can be refined in a later
# authored-prop pass without changing A05 bounds or route ownership.
const WATER_PLACEHOLDER_XZ := Vector2(-7.0, -5.5)
const NOTICE_PLACEHOLDER_XZ := Vector2(7.0, -5.5)

const SOCIAL_ANCHOR_SPECS := {
	"SET01_A05_SOCIAL_01": Vector2(-7.0, 4.5),
	"SET01_A05_SOCIAL_02": Vector2(7.0, 4.5),
	"SET01_A05_SOCIAL_03": Vector2(-7.0, -4.5),
	"SET01_A05_SOCIAL_04": Vector2(7.0, -4.5),
}

static func get_schema() -> String:
	return SCHEMA

static func get_stall_socket_specs() -> Dictionary:
	return STALL_SOCKET_SPECS.duplicate(true)

static func get_social_anchor_specs() -> Dictionary:
	return SOCIAL_ANCHOR_SPECS.duplicate(true)

static func get_water_placeholder_xz() -> Vector2:
	return WATER_PLACEHOLDER_XZ

static func get_notice_placeholder_xz() -> Vector2:
	return NOTICE_PLACEHOLDER_XZ

static func add_plaza(parent: Node3D) -> Dictionary:
	if parent == null:
		push_error("Settlement 01 G02 plaza requires a valid parent.")
		return {}

	var validation: Dictionary = LayoutContract.validate_contract()
	if not bool(validation.get("success", false)):
		push_error("Settlement 01 G02 plaza requires a valid G00 layout contract: %s" % str(validation.get("errors", [])))
		return {}

	var area_specs: Dictionary = LayoutContract.get_area_specs()
	var area: Dictionary = area_specs.get("SET01_A05_CENTRAL_MARKET_PLAZA", {}) as Dictionary
	var bounds_parts: Array = area.get("bounds_parts", [])
	if bounds_parts.size() != 1:
		push_error("Settlement 01 G02 plaza requires exactly one A05 bounds part.")
		return {}
	var plaza_bounds := bounds_parts[0] as Dictionary

	var root_node := Node3D.new()
	root_node.name = ROOT_NAME
	parent.add_child(root_node)

	var plaza_surface := _add_plaza_surface(root_node, plaza_bounds)
	var stall_sockets := _add_stall_sockets(root_node)
	var water_placeholder := _add_placeholder_box(
		root_node,
		WATER_PLACEHOLDER_NAME,
		WATER_PLACEHOLDER_XZ,
		Vector3(2.5, 0.12, 2.5),
		WATER_COLOR,
		0.08
	)
	var notice_placeholder := _add_placeholder_box(
		root_node,
		NOTICE_PLACEHOLDER_NAME,
		NOTICE_PLACEHOLDER_XZ,
		Vector3(1.8, 1.2, 0.18),
		NOTICE_COLOR,
		0.62
	)
	var social_anchors := _add_social_anchors(root_node)

	return {
		"root": root_node,
		"plaza_surface": plaza_surface,
		"stall_sockets": stall_sockets,
		"water_placeholder": water_placeholder,
		"notice_placeholder": notice_placeholder,
		"social_anchors": social_anchors,
	}

static func _add_plaza_surface(parent: Node3D, bounds: Dictionary) -> Node3D:
	var holder := Node3D.new()
	holder.name = PLAZA_SURFACE_NAME
	holder.position = Vector3(
		(float(bounds.get("min_x", 0.0)) + float(bounds.get("max_x", 0.0))) * 0.5,
		PLAZA_SURFACE_CENTER_Y,
		(float(bounds.get("min_z", 0.0)) + float(bounds.get("max_z", 0.0))) * 0.5
	)
	parent.add_child(holder)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = Vector3(
		float(bounds.get("max_x", 0.0)) - float(bounds.get("min_x", 0.0)),
		PLAZA_SURFACE_HEIGHT,
		float(bounds.get("max_z", 0.0)) - float(bounds.get("min_z", 0.0))
	)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(PLAZA_COLOR)
	holder.add_child(mesh_instance)
	return holder

static func _add_stall_sockets(parent: Node3D) -> Node3D:
	var holder := Node3D.new()
	holder.name = STALL_SOCKETS_NAME
	parent.add_child(holder)

	for socket_variant in STALL_SOCKET_SPECS.keys():
		var socket_id := String(socket_variant)
		var center: Vector2 = STALL_SOCKET_SPECS[socket_id]
		var socket := Marker3D.new()
		socket.name = socket_id
		socket.position = Vector3(center.x, SOCKET_SURFACE_CENTER_Y, center.y)
		holder.add_child(socket)

		var footprint := MeshInstance3D.new()
		footprint.name = "Footprint"
		var mesh := BoxMesh.new()
		mesh.size = Vector3(STALL_FOOTPRINT_XZ.x, SOCKET_SURFACE_HEIGHT, STALL_FOOTPRINT_XZ.y)
		footprint.mesh = mesh
		footprint.material_override = _material(STALL_SOCKET_COLOR)
		socket.add_child(footprint)

	return holder

static func _add_placeholder_box(
	parent: Node3D,
	node_name: String,
	center_xz: Vector2,
	size: Vector3,
	color: Color,
	center_y: float
) -> Node3D:
	var holder := Node3D.new()
	holder.name = node_name
	holder.position = Vector3(center_xz.x, center_y, center_xz.y)
	parent.add_child(holder)

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "Mesh"
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material(color)
	holder.add_child(mesh_instance)
	return holder

static func _add_social_anchors(parent: Node3D) -> Node3D:
	var holder := Node3D.new()
	holder.name = SOCIAL_ANCHORS_NAME
	parent.add_child(holder)

	for anchor_variant in SOCIAL_ANCHOR_SPECS.keys():
		var anchor_id := String(anchor_variant)
		var center: Vector2 = SOCIAL_ANCHOR_SPECS[anchor_id]
		var anchor := Marker3D.new()
		anchor.name = anchor_id
		anchor.position = Vector3(center.x, 0.08, center.y)
		holder.add_child(anchor)
	return holder

static func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.95
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	if color.a < 1.0:
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return material
