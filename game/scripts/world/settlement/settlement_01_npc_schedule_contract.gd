class_name PixelRPGSettlement01NPCScheduleContract
extends RefCounted

const SCHEMA := "pixel_rpg.settlement_01_npc_schedule_contract.v1"

const LayoutContract := preload("res://scripts/world/settlement/settlement_01_layout_contract.gd")

const MODE_ANCHORED := "ANCHORED"
const MODE_ABSTRACT := "ABSTRACT"
const UNLOADED_POLICY := "ABSTRACT_SCHEDULE_STATE"

const NPC_SPECS := {
	"SET01_NPC_HALL_KEEPER_01": {
		"npc_id": "SET01_NPC_HALL_KEEPER_01",
		"role": "HALL_KEEPER",
		"home_section_id": "SET01_S03",
		"home_area_id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
		"presentation_owns_durable_state": false,
		"unloaded_policy": UNLOADED_POLICY,
		"anchors": {
			"work": {
				"anchor_id": "SET01_ANCHOR_HALL_KEEPER_WORK",
				"area_id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
				"building_id": "SET01_BLD_COMMUNITY_HALL",
				"node_name": "KeeperWorkAnchor",
			},
			"hall_center": {
				"anchor_id": "SET01_ANCHOR_HALL_KEEPER_CENTER",
				"area_id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
				"building_id": "SET01_BLD_COMMUNITY_HALL",
				"node_name": "HallCenterAnchor",
			},
			"hall_idle": {
				"anchor_id": "SET01_ANCHOR_HALL_KEEPER_IDLE",
				"area_id": "SET01_A06_COMMUNITY_HALL_CIVIC_CORE",
				"building_id": "SET01_BLD_COMMUNITY_HALL",
				"node_name": "NPCIdleAnchor_01",
			},
			"plaza": {
				"anchor_id": "SET01_ANCHOR_HALL_KEEPER_PLAZA",
				"area_id": "SET01_A05_CENTRAL_MARKET_PLAZA",
				"building_id": "",
				"node_name": "SET01_A05_SOCIAL_03",
			},
		},
		"schedule": [
			{"start_minute": 0, "end_minute": 420, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
			{"start_minute": 420, "end_minute": 480, "state": "OPEN_HALL", "mode": MODE_ANCHORED, "anchor_key": "hall_center"},
			{"start_minute": 480, "end_minute": 720, "state": "WORK", "mode": MODE_ANCHORED, "anchor_key": "work"},
			{"start_minute": 720, "end_minute": 780, "state": "PLAZA", "mode": MODE_ANCHORED, "anchor_key": "plaza"},
			{"start_minute": 780, "end_minute": 1080, "state": "WORK", "mode": MODE_ANCHORED, "anchor_key": "work"},
			{"start_minute": 1080, "end_minute": 1260, "state": "LOCAL_SOCIAL", "mode": MODE_ANCHORED, "anchor_key": "hall_idle"},
			{"start_minute": 1260, "end_minute": 1440, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
		],
	},
	"SET01_NPC_RESIDENT_W01_01": {
		"npc_id": "SET01_NPC_RESIDENT_W01_01",
		"role": "RESIDENT",
		"home_section_id": "SET01_S03",
		"home_area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"presentation_owns_durable_state": false,
		"unloaded_policy": UNLOADED_POLICY,
		"anchors": {
			"rest": {
				"anchor_id": "SET01_ANCHOR_RES_W01_REST",
				"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
				"building_id": "SET01_BLD_RES_W01",
				"node_name": "ResidentRestAnchor",
			},
			"home": {
				"anchor_id": "SET01_ANCHOR_RES_W01_HOME",
				"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
				"building_id": "SET01_BLD_RES_W01",
				"node_name": "ResidentIdleAnchor",
			},
			"yard": {
				"anchor_id": "SET01_ANCHOR_RES_W01_YARD",
				"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
				"building_id": "SET01_BLD_RES_W01",
				"node_name": "YardAnchor",
			},
			"plaza": {
				"anchor_id": "SET01_ANCHOR_RES_W01_PLAZA",
				"area_id": "SET01_A05_CENTRAL_MARKET_PLAZA",
				"building_id": "",
				"node_name": "SET01_A05_SOCIAL_01",
			},
		},
		"schedule": [
			{"start_minute": 0, "end_minute": 420, "state": "REST", "mode": MODE_ANCHORED, "anchor_key": "rest"},
			{"start_minute": 420, "end_minute": 540, "state": "YARD", "mode": MODE_ANCHORED, "anchor_key": "yard"},
			{"start_minute": 540, "end_minute": 720, "state": "PLAZA", "mode": MODE_ANCHORED, "anchor_key": "plaza"},
			{"start_minute": 720, "end_minute": 1080, "state": "HOME", "mode": MODE_ANCHORED, "anchor_key": "home"},
			{"start_minute": 1080, "end_minute": 1260, "state": "PLAZA", "mode": MODE_ANCHORED, "anchor_key": "plaza"},
			{"start_minute": 1260, "end_minute": 1440, "state": "REST", "mode": MODE_ANCHORED, "anchor_key": "rest"},
		],
	},
	"SET01_NPC_RESIDENT_W02_01": {
		"npc_id": "SET01_NPC_RESIDENT_W02_01",
		"role": "RESIDENT",
		"home_section_id": "SET01_S03",
		"home_area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
		"presentation_owns_durable_state": false,
		"unloaded_policy": UNLOADED_POLICY,
		"anchors": {
			"rest": {
				"anchor_id": "SET01_ANCHOR_RES_W02_REST",
				"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
				"building_id": "SET01_BLD_RES_W02",
				"node_name": "ResidentRestAnchor",
			},
			"home": {
				"anchor_id": "SET01_ANCHOR_RES_W02_HOME",
				"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
				"building_id": "SET01_BLD_RES_W02",
				"node_name": "ResidentIdleAnchor",
			},
			"yard": {
				"anchor_id": "SET01_ANCHOR_RES_W02_YARD",
				"area_id": "SET01_A07_WEST_RESIDENTIAL_CLUSTER",
				"building_id": "SET01_BLD_RES_W02",
				"node_name": "YardAnchor",
			},
			"plaza": {
				"anchor_id": "SET01_ANCHOR_RES_W02_PLAZA",
				"area_id": "SET01_A05_CENTRAL_MARKET_PLAZA",
				"building_id": "",
				"node_name": "SET01_A05_SOCIAL_02",
			},
		},
		"schedule": [
			{"start_minute": 0, "end_minute": 450, "state": "REST", "mode": MODE_ANCHORED, "anchor_key": "rest"},
			{"start_minute": 450, "end_minute": 600, "state": "HOME", "mode": MODE_ANCHORED, "anchor_key": "home"},
			{"start_minute": 600, "end_minute": 780, "state": "PLAZA", "mode": MODE_ANCHORED, "anchor_key": "plaza"},
			{"start_minute": 780, "end_minute": 1080, "state": "YARD", "mode": MODE_ANCHORED, "anchor_key": "yard"},
			{"start_minute": 1080, "end_minute": 1260, "state": "HOME", "mode": MODE_ANCHORED, "anchor_key": "home"},
			{"start_minute": 1260, "end_minute": 1440, "state": "REST", "mode": MODE_ANCHORED, "anchor_key": "rest"},
		],
	},
	"SET01_NPC_SECURITY_GUARD_01": {
		"npc_id": "SET01_NPC_SECURITY_GUARD_01",
		"role": "ARRIVAL_SECURITY",
		"home_section_id": "SET01_S01",
		"home_area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
		"presentation_owns_durable_state": false,
		"unloaded_policy": UNLOADED_POLICY,
		"anchors": {
			"duty": {
				"anchor_id": "SET01_ANCHOR_SECURITY_DUTY",
				"area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
				"building_id": "",
				"node_name": "A02_GuardDutyAnchor",
			},
			"patrol": {
				"anchor_id": "SET01_ANCHOR_SECURITY_PATROL",
				"area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
				"building_id": "",
				"node_name": "A02_PatrolStartAnchor",
			},
			"briefing": {
				"anchor_id": "SET01_ANCHOR_SECURITY_BRIEFING",
				"area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
				"building_id": "",
				"node_name": "A02_BriefingAnchor",
			},
			"idle": {
				"anchor_id": "SET01_ANCHOR_SECURITY_IDLE",
				"area_id": "SET01_A02_GATE_BARRACKS_SECURITY",
				"building_id": "",
				"node_name": "A02_GuardIdleAnchor_01",
			},
		},
		"schedule": [
			{"start_minute": 0, "end_minute": 360, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
			{"start_minute": 360, "end_minute": 420, "state": "BRIEFING", "mode": MODE_ANCHORED, "anchor_key": "briefing"},
			{"start_minute": 420, "end_minute": 720, "state": "DUTY", "mode": MODE_ANCHORED, "anchor_key": "duty"},
			{"start_minute": 720, "end_minute": 840, "state": "PATROL", "mode": MODE_ANCHORED, "anchor_key": "patrol"},
			{"start_minute": 840, "end_minute": 1080, "state": "DUTY", "mode": MODE_ANCHORED, "anchor_key": "duty"},
			{"start_minute": 1080, "end_minute": 1200, "state": "IDLE", "mode": MODE_ANCHORED, "anchor_key": "idle"},
			{"start_minute": 1200, "end_minute": 1440, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
		],
	},
	"SET01_NPC_LOGISTICS_CLERK_01": {
		"npc_id": "SET01_NPC_LOGISTICS_CLERK_01",
		"role": "LOGISTICS_CLERK",
		"home_section_id": "SET01_S01",
		"home_area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
		"presentation_owns_durable_state": false,
		"unloaded_policy": UNLOADED_POLICY,
		"anchors": {
			"clerk": {
				"anchor_id": "SET01_ANCHOR_LOGISTICS_CLERK",
				"area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
				"building_id": "SET01_BLD_ARRIVAL_STORAGE",
				"node_name": "ClerkAnchor",
			},
			"storage": {
				"anchor_id": "SET01_ANCHOR_LOGISTICS_STORAGE",
				"area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
				"building_id": "SET01_BLD_ARRIVAL_STORAGE",
				"node_name": "StorageUseAnchor",
			},
			"loading": {
				"anchor_id": "SET01_ANCHOR_LOGISTICS_LOADING",
				"area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
				"building_id": "",
				"node_name": "A03_LoadingAnchor",
			},
			"visitor": {
				"anchor_id": "SET01_ANCHOR_LOGISTICS_VISITOR",
				"area_id": "SET01_A03_CARAVAN_VISITOR_STAGING",
				"building_id": "",
				"node_name": "A03_VisitorIdleAnchor_01",
			},
		},
		"schedule": [
			{"start_minute": 0, "end_minute": 420, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
			{"start_minute": 420, "end_minute": 540, "state": "OPEN_STORAGE", "mode": MODE_ANCHORED, "anchor_key": "storage"},
			{"start_minute": 540, "end_minute": 780, "state": "CLERK", "mode": MODE_ANCHORED, "anchor_key": "clerk"},
			{"start_minute": 780, "end_minute": 900, "state": "LOADING", "mode": MODE_ANCHORED, "anchor_key": "loading"},
			{"start_minute": 900, "end_minute": 1080, "state": "CLERK", "mode": MODE_ANCHORED, "anchor_key": "clerk"},
			{"start_minute": 1080, "end_minute": 1200, "state": "VISITOR_SUPPORT", "mode": MODE_ANCHORED, "anchor_key": "visitor"},
			{"start_minute": 1200, "end_minute": 1440, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
		],
	},
	"SET01_NPC_HUNTER_WARDEN_01": {
		"npc_id": "SET01_NPC_HUNTER_WARDEN_01",
		"role": "HUNTER_WARDEN",
		"home_section_id": "SET01_S05",
		"home_area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"presentation_owns_durable_state": false,
		"unloaded_policy": UNLOADED_POLICY,
		"anchors": {
			"gate": {
				"anchor_id": "SET01_ANCHOR_HUNTER_WARDEN_GATE",
				"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
				"building_id": "",
				"node_name": "A12_WardenAnchor",
			},
			"work": {
				"anchor_id": "SET01_ANCHOR_HUNTER_WARDEN_WORK",
				"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
				"building_id": "SET01_BLD_HUNTER_WATCH",
				"node_name": "WardenWorkAnchor",
			},
			"lookout": {
				"anchor_id": "SET01_ANCHOR_HUNTER_WARDEN_LOOKOUT",
				"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
				"building_id": "SET01_BLD_HUNTER_WATCH",
				"node_name": "LookoutAnchor",
			},
			"bounty": {
				"anchor_id": "SET01_ANCHOR_HUNTER_WARDEN_BOUNTY",
				"area_id": "SET01_A11_NORTH_HUNTER_STAGING",
				"building_id": "",
				"node_name": "A11_BountyBoardAnchor",
			},
		},
		"schedule": [
			{"start_minute": 0, "end_minute": 300, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
			{"start_minute": 300, "end_minute": 480, "state": "LOOKOUT", "mode": MODE_ANCHORED, "anchor_key": "lookout"},
			{"start_minute": 480, "end_minute": 720, "state": "GATE_DUTY", "mode": MODE_ANCHORED, "anchor_key": "gate"},
			{"start_minute": 720, "end_minute": 840, "state": "BOUNTY_CHECK", "mode": MODE_ANCHORED, "anchor_key": "bounty"},
			{"start_minute": 840, "end_minute": 1140, "state": "WORK", "mode": MODE_ANCHORED, "anchor_key": "work"},
			{"start_minute": 1140, "end_minute": 1260, "state": "GATE_DUTY", "mode": MODE_ANCHORED, "anchor_key": "gate"},
			{"start_minute": 1260, "end_minute": 1440, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
		],
	},
	"SET01_NPC_QUARTERMASTER_01": {
		"npc_id": "SET01_NPC_QUARTERMASTER_01",
		"role": "HUNTER_QUARTERMASTER",
		"home_section_id": "SET01_S05",
		"home_area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
		"presentation_owns_durable_state": false,
		"unloaded_policy": UNLOADED_POLICY,
		"anchors": {
			"counter": {
				"anchor_id": "SET01_ANCHOR_QUARTERMASTER_COUNTER",
				"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
				"building_id": "SET01_BLD_SUPPLY_CACHE",
				"node_name": "QuartermasterAnchor",
			},
			"supply": {
				"anchor_id": "SET01_ANCHOR_QUARTERMASTER_SUPPLY",
				"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
				"building_id": "SET01_BLD_SUPPLY_CACHE",
				"node_name": "SupplyUseAnchor",
			},
			"cache": {
				"anchor_id": "SET01_ANCHOR_QUARTERMASTER_CACHE",
				"area_id": "SET01_A12_NORTH_WATCH_GATE_TRAIL_EXIT",
				"building_id": "SET01_BLD_SUPPLY_CACHE",
				"node_name": "EmergencyCacheAnchor",
			},
		},
		"schedule": [
			{"start_minute": 0, "end_minute": 420, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
			{"start_minute": 420, "end_minute": 600, "state": "OPEN_CACHE", "mode": MODE_ANCHORED, "anchor_key": "supply"},
			{"start_minute": 600, "end_minute": 1020, "state": "COUNTER", "mode": MODE_ANCHORED, "anchor_key": "counter"},
			{"start_minute": 1020, "end_minute": 1140, "state": "CACHE_CHECK", "mode": MODE_ANCHORED, "anchor_key": "cache"},
			{"start_minute": 1140, "end_minute": 1260, "state": "COUNTER", "mode": MODE_ANCHORED, "anchor_key": "counter"},
			{"start_minute": 1260, "end_minute": 1440, "state": "OFF_DUTY", "mode": MODE_ABSTRACT, "anchor_key": ""},
		],
	},
}

static func get_schema() -> String:
	return SCHEMA

static func get_npc_specs() -> Dictionary:
	return NPC_SPECS.duplicate(true)

static func get_npc_ids() -> Array[String]:
	var ids: Array[String] = []
	for npc_variant in NPC_SPECS.keys():
		ids.append(String(npc_variant))
	ids.sort()
	return ids

static func validate_contract() -> Dictionary:
	var errors: Array[String] = []
	var layout_validation: Dictionary = LayoutContract.validate_contract()
	if not bool(layout_validation.get("success", false)):
		errors.append("G14 requires a valid Settlement 01 layout contract")

	var section_specs: Dictionary = LayoutContract.get_section_specs()
	var area_specs: Dictionary = LayoutContract.get_area_specs()
	var building_specs: Dictionary = LayoutContract.get_building_specs()
	var anchor_ids: Dictionary = {}

	for npc_variant in NPC_SPECS.keys():
		var npc_id := String(npc_variant)
		var npc := NPC_SPECS[npc_id] as Dictionary
		if String(npc.get("npc_id", "")) != npc_id:
			errors.append("NPC registry key mismatch for %s" % npc_id)
		if not npc_id.begins_with("SET01_NPC_"):
			errors.append("NPC ID is not stable Settlement 01 format: %s" % npc_id)
		if bool(npc.get("presentation_owns_durable_state", true)):
			errors.append("NPC %s incorrectly gives durable state to presentation" % npc_id)
		if String(npc.get("unloaded_policy", "")) != UNLOADED_POLICY:
			errors.append("NPC %s does not use abstract unloaded schedule state" % npc_id)

		var home_section_id := String(npc.get("home_section_id", ""))
		var home_area_id := String(npc.get("home_area_id", ""))
		if not section_specs.has(home_section_id):
			errors.append("NPC %s references unknown home section %s" % [npc_id, home_section_id])
		if not area_specs.has(home_area_id):
			errors.append("NPC %s references unknown home area %s" % [npc_id, home_area_id])
		elif String((area_specs[home_area_id] as Dictionary).get("parent_section_id", "")) != home_section_id:
			errors.append("NPC %s home area/section ownership disagrees" % npc_id)

		var anchors := npc.get("anchors", {}) as Dictionary
		if anchors.is_empty():
			errors.append("NPC %s has no authored anchors" % npc_id)

		for anchor_key_variant in anchors.keys():
			var anchor_key := String(anchor_key_variant)
			var binding := anchors[anchor_key] as Dictionary
			var anchor_id := String(binding.get("anchor_id", ""))
			var area_id := String(binding.get("area_id", ""))
			var building_id := String(binding.get("building_id", ""))
			var node_name := String(binding.get("node_name", ""))

			if anchor_id.is_empty() or not anchor_id.begins_with("SET01_ANCHOR_"):
				errors.append("NPC %s anchor %s has invalid stable anchor ID" % [npc_id, anchor_key])
			elif anchor_ids.has(anchor_id):
				errors.append("duplicate stable anchor ID %s" % anchor_id)
			else:
				anchor_ids[anchor_id] = true

			if not area_specs.has(area_id):
				errors.append("NPC %s anchor %s references unknown area %s" % [npc_id, anchor_key, area_id])
			if node_name.is_empty():
				errors.append("NPC %s anchor %s has no node name" % [npc_id, anchor_key])

			if not building_id.is_empty():
				if not building_specs.has(building_id):
					errors.append("NPC %s anchor %s references unknown building %s" % [npc_id, anchor_key, building_id])
				else:
					var building := building_specs[building_id] as Dictionary
					if String(building.get("area_id", "")) != area_id:
						errors.append("NPC %s anchor %s building/area ownership disagrees" % [npc_id, anchor_key])

		errors.append_array(_validate_schedule(npc_id, npc))

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"schema": SCHEMA,
		"npc_count": NPC_SPECS.size(),
		"anchor_id_count": anchor_ids.size(),
		"unloaded_policy": UNLOADED_POLICY,
	}

static func validate_runtime_anchors(root: Node) -> Dictionary:
	var errors: Array[String] = []
	var resolved := 0
	if root == null:
		return {
			"success": false,
			"errors": ["runtime anchor validation requires a root"],
			"resolved_anchor_count": 0,
		}

	for npc_variant in NPC_SPECS.keys():
		var npc_id := String(npc_variant)
		var npc := NPC_SPECS[npc_id] as Dictionary
		var anchors := npc.get("anchors", {}) as Dictionary
		for anchor_key_variant in anchors.keys():
			var anchor_key := String(anchor_key_variant)
			var binding := anchors[anchor_key] as Dictionary
			var marker := resolve_anchor(root, npc_id, anchor_key)
			if marker == null:
				errors.append("NPC %s anchor %s could not resolve node %s" % [npc_id, anchor_key, binding.get("node_name", "")])
				continue
			resolved += 1

			var area_id := String(binding.get("area_id", ""))
			var point := Vector2(marker.global_position.x, marker.global_position.z)
			if not _point_inside_area(area_id, point):
				errors.append("NPC %s anchor %s resolves outside area %s at %s" % [npc_id, anchor_key, area_id, str(point)])

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"resolved_anchor_count": resolved,
	}

static func resolve_anchor(root: Node, npc_id: String, anchor_key: String) -> Marker3D:
	if root == null or not NPC_SPECS.has(npc_id):
		return null
	var npc := NPC_SPECS[npc_id] as Dictionary
	var anchors := npc.get("anchors", {}) as Dictionary
	if not anchors.has(anchor_key):
		return null

	var binding := anchors[anchor_key] as Dictionary
	var node_name := String(binding.get("node_name", ""))
	var building_id := String(binding.get("building_id", ""))
	var matches := root.find_children(node_name, "Marker3D", true, false)
	for match_variant in matches:
		var marker := match_variant as Marker3D
		if marker == null:
			continue
		if building_id.is_empty() or _has_building_ancestor(marker, building_id):
			return marker
	return null

static func get_schedule_segment(npc_id: String, minute_of_day: int) -> Dictionary:
	if not NPC_SPECS.has(npc_id):
		return {}
	var minute := posmod(minute_of_day, 1440)
	var npc := NPC_SPECS[npc_id] as Dictionary
	for segment_variant in npc.get("schedule", []):
		var segment := segment_variant as Dictionary
		if minute >= int(segment.get("start_minute", -1)) and minute < int(segment.get("end_minute", -1)):
			return segment.duplicate(true)
	return {}

static func _validate_schedule(npc_id: String, npc: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	var anchors := npc.get("anchors", {}) as Dictionary
	var schedule := npc.get("schedule", []) as Array
	if schedule.is_empty():
		errors.append("NPC %s has no schedule" % npc_id)
		return errors

	var expected_start := 0
	for segment_variant in schedule:
		var segment := segment_variant as Dictionary
		var start_minute := int(segment.get("start_minute", -1))
		var end_minute := int(segment.get("end_minute", -1))
		var mode := String(segment.get("mode", ""))
		var anchor_key := String(segment.get("anchor_key", ""))
		var state := String(segment.get("state", ""))

		if start_minute != expected_start:
			errors.append("NPC %s schedule is not contiguous at minute %d" % [npc_id, expected_start])
		if end_minute <= start_minute or end_minute > 1440:
			errors.append("NPC %s has invalid schedule interval %d..%d" % [npc_id, start_minute, end_minute])
		if state.is_empty():
			errors.append("NPC %s has schedule segment without state" % npc_id)

		if mode == MODE_ANCHORED:
			if anchor_key.is_empty() or not anchors.has(anchor_key):
				errors.append("NPC %s anchored schedule references unknown anchor %s" % [npc_id, anchor_key])
		elif mode == MODE_ABSTRACT:
			if not anchor_key.is_empty():
				errors.append("NPC %s abstract schedule must not reference a scene anchor" % npc_id)
		else:
			errors.append("NPC %s has unknown schedule mode %s" % [npc_id, mode])

		expected_start = end_minute

	if expected_start != 1440:
		errors.append("NPC %s schedule does not cover full day" % npc_id)
	return errors

static func _has_building_ancestor(node: Node, building_id: String) -> bool:
	var cursor: Node = node
	while cursor != null:
		if String(cursor.get_meta("pixel_rpg_building_id", "")) == building_id:
			return true
		cursor = cursor.get_parent()
	return false

static func _point_inside_area(area_id: String, point: Vector2, epsilon := 0.01) -> bool:
	var area_specs: Dictionary = LayoutContract.get_area_specs()
	if not area_specs.has(area_id):
		return false
	var area := area_specs[area_id] as Dictionary
	for bounds_variant in area.get("bounds_parts", []):
		var bounds := bounds_variant as Dictionary
		if (
			point.x >= float(bounds.get("min_x", 0.0)) - epsilon
			and point.x <= float(bounds.get("max_x", 0.0)) + epsilon
			and point.y >= float(bounds.get("min_z", 0.0)) - epsilon
			and point.y <= float(bounds.get("max_z", 0.0)) + epsilon
		):
			return true
	return false
