extends SceneTree

const Contract: Script = preload("res://scripts/state/pixel_rpg_state_ownership_contract.gd")
const PrototypeScene: PackedScene = preload("res://scenes/prototypes/pixel_rpg_prototype_001.tscn")

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
	print("Pixel RPG state ownership contract gate")

	var validation: Dictionary = Contract.call("validate_contract")
	_check("contract schema is current", String(Contract.call("get_schema")) == "pixel_rpg.state_ownership.v1")
	_check("contract uses bounded multi-owner model", String(Contract.call("get_model")) == "MULTI_OWNER_EXPLICIT_BOUNDARIES")
	_check("contract self-validation passes", bool(validation.get("success", false)), str(validation.get("errors", [])))
	_check("contract covers bounded owner set", int(validation.get("owner_count", 0)) >= 12, str(validation))
	_check("contract covers current and planned mutable data", int(validation.get("datum_count", 0)) >= 24, str(validation))

	var owners: Dictionary = Contract.call("get_owner_specs")
	var data: Dictionary = Contract.call("get_datum_specs")

	_check("Hunter world transform owner is the live Hunter body", String((data["player.world_transform"] as Dictionary).get("owner_id", "")) == "world.hunter_body")
	_check("Mudcrest live transform owner is the current-world proxy", String((data["monster.live_transform"] as Dictionary).get("owner_id", "")) == "world.mudcrest_proxy")
	_check("combat resources stay in deterministic turn shell", String((data["combat.resources"] as Dictionary).get("owner_id", "")) == "domain.combat_turn_shell")
	_check("anatomy integrity stays in Mudcrest anatomy domain", String((data["monster.anatomy_integrity"] as Dictionary).get("owner_id", "")) == "domain.mudcrest_anatomy")
	_check("combat bootstrap latch is orchestration, not combat truth", String((data["combat.bootstrap_started_latch"] as Dictionary).get("authority", "")) == "ORCHESTRATION")
	_check("target lock is transient and never gameplay-saved", String((data["targeting.locked_group"] as Dictionary).get("persistence", "")) == "NEVER_GAMEPLAY_SAVE")
	_check("camera yaw/pitch is transient and never gameplay-saved", String((data["camera.yaw_pitch"] as Dictionary).get("persistence", "")) == "NEVER_GAMEPLAY_SAVE")
	_check("exploration input authority moved to explicit transient owner", String((owners["control.exploration_input"] as Dictionary).get("source_path", "")) == "res://scripts/presentation/pixel_rpg/touch_input_state_001.gd" and String((owners["control.exploration_input"] as Dictionary).get("property_audit", "")) == "SOURCE_INSTANCE")
	_check("camera sensitivity is preference-only, not gameplay save", String((data["camera.look_sensitivity_runtime"] as Dictionary).get("persistence", "")) == "LOCAL_PREFERENCE_NOT_GAMEPLAY_SAVE")
	_check("future durable state is split across bounded owners", owners.has("durable.player_state") and owners.has("durable.world_state") and owners.has("durable.inventory_equipment") and owners.has("durable.npc_relationships"))

	for datum_variant in data.keys():
		var datum_id := String(datum_variant)
		var spec := data[datum_id] as Dictionary
		var owner_id := String(spec.get("owner_id", ""))
		_check("single declared owner: %s" % datum_id, not owner_id.is_empty() and owners.has(owner_id), owner_id)

	var prototype := PrototypeScene.instantiate()
	_check("prototype scene instantiates for ownership audit", prototype != null)
	if prototype != null:
		var prototype_property_names: Dictionary = {}
		for property_variant in prototype.get_property_list():
			var property_entry := property_variant as Dictionary
			prototype_property_names[String(property_entry.get("name", ""))] = true

		var owner_property_names: Dictionary = {}
		owner_property_names["__prototype__"] = prototype_property_names

		for datum_variant in data.keys():
			var datum_id := String(datum_variant)
			var spec := data[datum_id] as Dictionary
			if String(spec.get("implementation", "")) != "ACTIVE":
				continue

			var owner_id := String(spec.get("owner_id", ""))
			var owner := owners.get(owner_id, {}) as Dictionary
			var property_audit := String(owner.get("property_audit", "PROTOTYPE"))
			var property_names := prototype_property_names

			if property_audit == "SOURCE_INSTANCE":
				if not owner_property_names.has(owner_id):
					var source_path := String(owner.get("source_path", ""))
					var source_script := load(source_path) as Script if ResourceLoader.exists(source_path) else null
					var owner_instance: Object = source_script.new() if source_script != null else null
					var source_property_names: Dictionary = {}
					if owner_instance != null:
						for property_variant in owner_instance.get_property_list():
							var property_entry := property_variant as Dictionary
							source_property_names[String(property_entry.get("name", ""))] = true
					owner_property_names[owner_id] = source_property_names
					_check(
						"source-instance owner is constructible: %s" % owner_id,
						owner_instance != null,
						source_path
					)
				property_names = owner_property_names.get(owner_id, {}) as Dictionary

			var runtime_property := String(spec.get("runtime_property", ""))
			if not runtime_property.is_empty():
				_check("runtime property exists for %s" % datum_id, property_names.has(runtime_property), runtime_property)
			for property_name_variant in spec.get("runtime_properties", []):
				var property_name := String(property_name_variant)
				_check("runtime property exists for %s" % datum_id, property_names.has(property_name), property_name)

		root.add_child(prototype)
		await process_frame
		var hunter := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter") as CharacterBody3D
		var mudcrest_proxy := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/WorldGeometry/MonsterProxy") as Node3D
		var camera := prototype.get_node_or_null("WorldDisplay/WorldViewport/World/Hunter/CameraYaw/CameraPitch/Camera3D") as Camera3D
		_check("declared Hunter runtime owner exists", hunter != null)
		_check("declared Mudcrest world owner exists", mudcrest_proxy != null)
		_check("first-person camera remains presentation/control state", camera != null and camera.current and camera.get_parent().name == "CameraPitch")

		prototype.queue_free()
		await process_frame

	for owner_variant in owners.keys():
		var owner_id := String(owner_variant)
		var owner := owners[owner_id] as Dictionary
		var source_path := String(owner.get("source_path", ""))
		if String(owner.get("implementation", "")) == "ACTIVE" and source_path.begins_with("res://"):
			_check("active owner source exists: %s" % owner_id, ResourceLoader.exists(source_path), source_path)

	_finish()

func _finish() -> void:
	print()
	print("Checks: %d | Passed: %d | Failed: %d" % [checks, checks - failures.size(), failures.size()])
	if failures.is_empty():
		print("Gate: PIXEL_RPG_STATE_OWNERSHIP_CONTRACT_001_VERIFIED")
	else:
		print("Gate: PIXEL_RPG_STATE_OWNERSHIP_CONTRACT_001_FAILED")
	print("This gate verifies explicit multi-owner runtime/property and persistence boundaries, including the extracted transient touch-state owner. It does not implement broad save/load or prove phone runtime.")
	quit(0 if failures.is_empty() else 1)
