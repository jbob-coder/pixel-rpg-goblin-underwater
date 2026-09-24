extends RefCounted

const SCHEMA := "pixel_rpg.state_ownership.v1"
const MODEL := "MULTI_OWNER_EXPLICIT_BOUNDARIES"

const PERSIST_NEVER := "NEVER_GAMEPLAY_SAVE"
const PERSIST_DURABLE_ELIGIBLE := "DURABLE_ELIGIBLE_NOT_IMPLEMENTED"
const PERSIST_CHECKPOINTABLE := "CHECKPOINTABLE_ACTIVE_DOMAIN_NOT_IMPLEMENTED"
const PERSIST_LOCAL_PREFERENCE := "LOCAL_PREFERENCE_NOT_GAMEPLAY_SAVE"
const PERSIST_DURABLE_PLANNED := "DURABLE_GAMEPLAY_PLANNED"

const OWNER_SPECS := {
	"world.hunter_body": {
		"kind": "WORLD_RUNTIME",
		"implementation": "ACTIVE",
		"runtime_path": "WorldDisplay/WorldViewport/World/Hunter",
		"source_path": "res://scenes/prototypes/pixel_rpg_prototype_001.tscn",
	},
	"world.mudcrest_proxy": {
		"kind": "WORLD_RUNTIME",
		"implementation": "ACTIVE",
		"runtime_path": "WorldDisplay/WorldViewport/World/WorldGeometry/MonsterProxy",
		"source_path": "res://scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd",
	},
	"domain.combat_turn_shell": {
		"kind": "COMBAT_DOMAIN",
		"implementation": "ACTIVE",
		"runtime_path": "WorldDisplay/WorldViewport/World/CombatTurnShellRuntime",
		"source_path": "res://scripts/gameplay/combat/hunt01_combat_turn_shell_runtime.gd",
	},
	"domain.mudcrest_anatomy": {
		"kind": "COMBAT_DOMAIN",
		"implementation": "ACTIVE",
		"runtime_path": "WorldDisplay/WorldViewport/World/MudcrestAnatomyRuntime",
		"source_path": "res://scripts/gameplay/monsters/monster_01/hunt01_mudcrest_anatomy_runtime.gd",
	},
	"control.exploration_input": {
		"kind": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"runtime_path": "PixelRPGPrototype001",
		"source_path": "res://scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd",
	},
	"control.first_person_camera": {
		"kind": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"runtime_path": "WorldDisplay/WorldViewport/World/Hunter/CameraYaw",
		"source_path": "res://scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd",
	},
	"control.targeting": {
		"kind": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"runtime_path": "PixelRPGPrototype001",
		"source_path": "res://scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd",
	},
	"control.interaction_context": {
		"kind": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"runtime_path": "PixelRPGPrototype001",
		"source_path": "res://scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd",
	},
	"orchestration.combat_bootstrap": {
		"kind": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"runtime_path": "PixelRPGPrototype001",
		"source_path": "res://scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd",
	},
	"orchestration.scene_boot": {
		"kind": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"runtime_path": "PixelRPGPrototype001",
		"source_path": "res://scripts/presentation/pixel_rpg/pixel_rpg_prototype_001.gd",
	},
	"presentation.hud": {
		"kind": "PRESENTATION",
		"implementation": "ACTIVE",
		"runtime_path": "HUD",
		"source_path": "res://scenes/prototypes/pixel_rpg_prototype_001.tscn",
	},
	"settings.local_preferences": {
		"kind": "SETTINGS",
		"implementation": "PLANNED",
		"runtime_path": "",
		"source_path": "",
	},
	"durable.player_state": {
		"kind": "PLANNED_DURABLE_STATE",
		"implementation": "PLANNED",
		"runtime_path": "",
		"source_path": "",
	},
	"durable.world_state": {
		"kind": "PLANNED_DURABLE_STATE",
		"implementation": "PLANNED",
		"runtime_path": "",
		"source_path": "",
	},
	"durable.inventory_equipment": {
		"kind": "PLANNED_DURABLE_STATE",
		"implementation": "PLANNED",
		"runtime_path": "",
		"source_path": "",
	},
	"durable.npc_relationships": {
		"kind": "PLANNED_DURABLE_STATE",
		"implementation": "PLANNED",
		"runtime_path": "",
		"source_path": "",
	},
	"durable.economy_state": {
		"kind": "PLANNED_DURABLE_STATE",
		"implementation": "PLANNED",
		"runtime_path": "",
		"source_path": "",
	},
}

const DATUM_SPECS := {
	"player.world_transform": {
		"owner_id": "world.hunter_body",
		"authority": "WORLD_GAMEPLAY",
		"implementation": "ACTIVE",
		"persistence": PERSIST_DURABLE_ELIGIBLE,
	},
	"player.velocity": {
		"owner_id": "world.hunter_body",
		"authority": "RUNTIME_PHYSICS",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
	},
	"monster.live_transform": {
		"owner_id": "world.mudcrest_proxy",
		"authority": "WORLD_GAMEPLAY",
		"implementation": "ACTIVE",
		"persistence": PERSIST_DURABLE_ELIGIBLE,
	},
	"combat.round_scheduler": {
		"owner_id": "domain.combat_turn_shell",
		"authority": "DOMAIN",
		"implementation": "ACTIVE",
		"persistence": PERSIST_CHECKPOINTABLE,
	},
	"combat.resources": {
		"owner_id": "domain.combat_turn_shell",
		"authority": "DOMAIN",
		"implementation": "ACTIVE",
		"persistence": PERSIST_CHECKPOINTABLE,
	},
	"combat.terminal_outcome": {
		"owner_id": "domain.combat_turn_shell",
		"authority": "DOMAIN",
		"implementation": "ACTIVE",
		"persistence": PERSIST_CHECKPOINTABLE,
	},
	"monster.anatomy_integrity": {
		"owner_id": "domain.mudcrest_anatomy",
		"authority": "DOMAIN",
		"implementation": "ACTIVE",
		"persistence": PERSIST_CHECKPOINTABLE,
	},
	"monster.anatomy_resolution_dedupe": {
		"owner_id": "domain.mudcrest_anatomy",
		"authority": "DOMAIN",
		"implementation": "ACTIVE",
		"persistence": PERSIST_CHECKPOINTABLE,
	},
	"input.joystick_vector": {
		"owner_id": "control.exploration_input",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_joystick_vector",
	},
	"input.touch_capture": {
		"owner_id": "control.exploration_input",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_properties": ["_joystick_touch_id", "_look_touch_id", "_look_last_position"],
	},
	"camera.yaw_pitch": {
		"owner_id": "control.first_person_camera",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_properties": ["_camera_yaw_rad", "_camera_pitch_rad"],
	},
	"camera.look_sensitivity_runtime": {
		"owner_id": "control.first_person_camera",
		"future_owner_id": "settings.local_preferences",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_LOCAL_PREFERENCE,
		"runtime_property": "_look_degrees_per_pixel",
	},
	"targeting.open": {
		"owner_id": "control.targeting",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_targeting_open",
	},
	"targeting.selected_group": {
		"owner_id": "control.targeting",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_selected_target_group",
	},
	"targeting.locked_group": {
		"owner_id": "control.targeting",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_locked_target_group",
	},
	"interaction.current_context": {
		"owner_id": "control.interaction_context",
		"authority": "TRANSIENT_CONTROL",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_current_context",
	},
	"combat.bootstrap_started_latch": {
		"owner_id": "orchestration.combat_bootstrap",
		"authority": "ORCHESTRATION",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_combat_domain_started",
	},
	"presentation.world_ready_latch": {
		"owner_id": "orchestration.scene_boot",
		"authority": "ORCHESTRATION",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_world_ready",
	},
	"presentation.elapsed_time": {
		"owner_id": "presentation.hud",
		"authority": "PRESENTATION_DERIVED",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_elapsed",
	},
	"presentation.target_highlight": {
		"owner_id": "presentation.hud",
		"authority": "PRESENTATION_DERIVED",
		"implementation": "ACTIVE",
		"persistence": PERSIST_NEVER,
		"runtime_property": "_target_highlight_material",
	},
	"player.progression": {
		"owner_id": "durable.player_state",
		"authority": "DURABLE_GAMEPLAY",
		"implementation": "PLANNED",
		"persistence": PERSIST_DURABLE_PLANNED,
	},
	"world.section_state": {
		"owner_id": "durable.world_state",
		"authority": "DURABLE_GAMEPLAY",
		"implementation": "PLANNED",
		"persistence": PERSIST_DURABLE_PLANNED,
	},
	"world.quest_decision_flags": {
		"owner_id": "durable.world_state",
		"authority": "DURABLE_GAMEPLAY",
		"implementation": "PLANNED",
		"persistence": PERSIST_DURABLE_PLANNED,
	},
	"inventory.ownership": {
		"owner_id": "durable.inventory_equipment",
		"authority": "DURABLE_GAMEPLAY",
		"implementation": "PLANNED",
		"persistence": PERSIST_DURABLE_PLANNED,
	},
	"npc.relationship_state": {
		"owner_id": "durable.npc_relationships",
		"authority": "DURABLE_GAMEPLAY",
		"implementation": "PLANNED",
		"persistence": PERSIST_DURABLE_PLANNED,
	},
	"economy.wallet": {
		"owner_id": "durable.economy_state",
		"authority": "DURABLE_GAMEPLAY",
		"implementation": "PLANNED",
		"persistence": PERSIST_DURABLE_PLANNED,
	},
}

static func get_schema() -> String:
	return SCHEMA

static func get_model() -> String:
	return MODEL

static func get_owner_specs() -> Dictionary:
	return OWNER_SPECS.duplicate(true)

static func get_datum_specs() -> Dictionary:
	return DATUM_SPECS.duplicate(true)

static func get_datum_spec(datum_id: String) -> Dictionary:
	if not DATUM_SPECS.has(datum_id):
		return {}
	return (DATUM_SPECS[datum_id] as Dictionary).duplicate(true)

static func get_owner_spec(owner_id: String) -> Dictionary:
	if not OWNER_SPECS.has(owner_id):
		return {}
	return (OWNER_SPECS[owner_id] as Dictionary).duplicate(true)

static func validate_contract() -> Dictionary:
	var errors: Array[String] = []
	var durable_policies := [PERSIST_DURABLE_ELIGIBLE, PERSIST_CHECKPOINTABLE, PERSIST_DURABLE_PLANNED]

	for datum_variant in DATUM_SPECS.keys():
		var datum_id := String(datum_variant)
		var spec := DATUM_SPECS[datum_id] as Dictionary
		var owner_id := String(spec.get("owner_id", ""))
		if owner_id.is_empty():
			errors.append("%s has no owner_id" % datum_id)
			continue
		if not OWNER_SPECS.has(owner_id):
			errors.append("%s references unknown owner %s" % [datum_id, owner_id])
			continue

		var owner := OWNER_SPECS[owner_id] as Dictionary
		var owner_kind := String(owner.get("kind", ""))
		var implementation := String(spec.get("implementation", ""))
		var persistence := String(spec.get("persistence", ""))
		var authority := String(spec.get("authority", ""))

		if implementation == "ACTIVE" and String(owner.get("implementation", "")) != "ACTIVE":
			errors.append("%s is active but owner %s is not active" % [datum_id, owner_id])

		if owner_kind in ["TRANSIENT_CONTROL", "PRESENTATION"] and persistence in durable_policies:
			errors.append("%s lets transient/presentation owner %s hold durable state" % [datum_id, owner_id])

		if authority == "DOMAIN" and owner_kind != "COMBAT_DOMAIN":
			errors.append("%s domain datum is not owned by COMBAT_DOMAIN" % datum_id)

		if datum_id.begins_with("input.") or datum_id.begins_with("targeting."):
			if persistence != PERSIST_NEVER:
				errors.append("%s transient input/targeting datum is persistence-eligible" % datum_id)

		if datum_id.begins_with("camera.") and persistence not in [PERSIST_NEVER, PERSIST_LOCAL_PREFERENCE]:
			errors.append("%s camera datum crosses gameplay persistence boundary" % datum_id)

		var future_owner_id := String(spec.get("future_owner_id", ""))
		if not future_owner_id.is_empty() and not OWNER_SPECS.has(future_owner_id):
			errors.append("%s references unknown future owner %s" % [datum_id, future_owner_id])

	for owner_variant in OWNER_SPECS.keys():
		var owner_id := String(owner_variant).to_lower()
		for banned in ["worldlife", "shooter", "monster_choice", "monster choice"]:
			if banned in owner_id:
				errors.append("owner id imports abandoned project authority: %s" % owner_variant)

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"schema": SCHEMA,
		"model": MODEL,
		"owner_count": OWNER_SPECS.size(),
		"datum_count": DATUM_SPECS.size(),
	}
