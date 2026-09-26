class_name PixelRPGAvatarFootRig001
extends RefCounted

const SCHEMA := "pixel_rpg.avatar_foot_rig_001.v1"

const SIDE_LEFT := "left"
const SIDE_RIGHT := "right"

const MODE_WALK := "walk"
const MODE_RUN := "run"
const MODE_CROUCH_WALK := "crouch_walk"

const JOINT_ANKLE := "ankle"
const JOINT_SUBTALAR := "subtalar"
const JOINT_MIDFOOT := "midfoot"
const JOINT_BALL := "ball"
const JOINT_TOE := "toe"

const JOINT_ORDER := [
	JOINT_ANKLE,
	JOINT_SUBTALAR,
	JOINT_MIDFOOT,
	JOINT_BALL,
	JOINT_TOE,
]

# These are conservative game-animation limits, not clinical ROM measurements.
# Positive pitch = dorsiflexion. Negative pitch = plantarflexion.
# Positive subtalar roll = inversion before side mirroring.
const JOINT_SPECS := {
	JOINT_ANKLE: {
		"anatomy": "talocrural",
		"role": "primary dorsiflexion / plantarflexion",
		"pitch_min_deg": -30.0,
		"pitch_max_deg": 20.0,
	},
	JOINT_SUBTALAR: {
		"anatomy": "subtalar",
		"role": "small inversion / eversion contribution",
		"roll_min_deg": -12.0,
		"roll_max_deg": 12.0,
	},
	JOINT_MIDFOOT: {
		"anatomy": "transverse_tarsal_proxy",
		"role": "controlled arch / midfoot compliance",
		"pitch_min_deg": -10.0,
		"pitch_max_deg": 15.0,
	},
	JOINT_BALL: {
		"anatomy": "metatarsophalangeal_proxy",
		"role": "forefoot rocker and toe-off pivot",
		"pitch_min_deg": -10.0,
		"pitch_max_deg": 55.0,
	},
	JOINT_TOE: {
		"anatomy": "interphalangeal_proxy",
		"role": "secondary toe curl / extension",
		"pitch_min_deg": -15.0,
		"pitch_max_deg": 35.0,
	},
}

# Heel contact is deliberately a helper pivot, not an anatomical joint.
const HELPER_HEEL_CONTACT := "heel_contact"

static func get_schema() -> String:
	return SCHEMA

static func get_joint_specs() -> Dictionary:
	return JOINT_SPECS.duplicate(true)

static func get_joint_order() -> Array:
	return JOINT_ORDER.duplicate()

static func get_supported_modes() -> Array:
	return [MODE_WALK, MODE_RUN, MODE_CROUCH_WALK]

static func bone_name(side: String, joint_name: String) -> String:
	var side_token := "l" if side == SIDE_LEFT else "r"
	return "avatar_foot_%s_%s" % [side_token, joint_name]

static func ensure_joint_chain(
	skeleton: Skeleton3D,
	side: String,
	ankle_bone_name: String,
	foot_length_m: float = 0.27,
	foot_height_m: float = 0.09
) -> Dictionary:
	if skeleton == null:
		return {"success": false, "errors": ["skeleton is null"], "created": [], "indices": {}}
	if side != SIDE_LEFT and side != SIDE_RIGHT:
		return {"success": false, "errors": ["unsupported side: %s" % side], "created": [], "indices": {}}
	if foot_length_m <= 0.0 or foot_height_m <= 0.0:
		return {"success": false, "errors": ["foot dimensions must be positive"], "created": [], "indices": {}}

	var ankle_index := skeleton.find_bone(ankle_bone_name)
	if ankle_index < 0:
		return {
			"success": false,
			"errors": ["missing ankle bone: %s" % ankle_bone_name],
			"created": [],
			"indices": {},
		}

	var indices := {JOINT_ANKLE: ankle_index}
	var created: Array[String] = []
	var errors: Array[String] = []
	var parent_index := ankle_index

	# Forward is local -Z. Offsets are relative to each parent bone.
	# The final imported avatar must weight-paint the visible mesh to these bones;
	# adding a Skeleton3D bone alone does not alter skin weights.
	var offsets := {
		JOINT_SUBTALAR: Vector3(0.0, -foot_height_m * 0.22, -foot_length_m * 0.05),
		JOINT_MIDFOOT: Vector3(0.0, -foot_height_m * 0.08, -foot_length_m * 0.28),
		JOINT_BALL: Vector3(0.0, -foot_height_m * 0.03, -foot_length_m * 0.32),
		JOINT_TOE: Vector3(0.0, 0.0, -foot_length_m * 0.20),
	}

	for joint_name in [JOINT_SUBTALAR, JOINT_MIDFOOT, JOINT_BALL, JOINT_TOE]:
		var target_name := bone_name(side, joint_name)
		var bone_index := skeleton.find_bone(target_name)
		if bone_index < 0:
			bone_index = skeleton.add_bone(target_name)
			if bone_index < 0:
				errors.append("failed to add bone: %s" % target_name)
				continue
			skeleton.set_bone_parent(bone_index, parent_index)
			var rest_offset: Vector3 = offsets[joint_name]
			skeleton.set_bone_rest(
				bone_index,
				Transform3D(Basis.IDENTITY, rest_offset)
			)
			created.append(target_name)
		elif skeleton.get_bone_parent(bone_index) != parent_index:
			errors.append(
				"existing bone %s has unexpected parent index %d (expected %d)"
				% [target_name, skeleton.get_bone_parent(bone_index), parent_index]
			)
		indices[joint_name] = bone_index
		parent_index = bone_index

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"created": created,
		"indices": indices,
	}

static func sample_cycle(mode: String, phase: float) -> Dictionary:
	var normalized_phase := fposmod(phase, 1.0)
	var keys := _keys_for_mode(mode)
	if keys.is_empty():
		return {}

	var sample := _interpolate_keys(keys, normalized_phase)
	sample["mode"] = mode
	sample["phase"] = normalized_phase
	sample["phase_name"] = _phase_name(mode, normalized_phase)
	sample["stance_fraction"] = _stance_fraction(mode)
	sample["is_grounded"] = normalized_phase < float(sample["stance_fraction"])
	return _clamp_sample(sample)

static func apply_sample(
	skeleton: Skeleton3D,
	side: String,
	ankle_bone_name: String,
	sample: Dictionary
) -> Dictionary:
	if skeleton == null:
		return {"success": false, "errors": ["skeleton is null"]}

	var names := {
		JOINT_ANKLE: ankle_bone_name,
		JOINT_SUBTALAR: bone_name(side, JOINT_SUBTALAR),
		JOINT_MIDFOOT: bone_name(side, JOINT_MIDFOOT),
		JOINT_BALL: bone_name(side, JOINT_BALL),
		JOINT_TOE: bone_name(side, JOINT_TOE),
	}
	var indices := {}
	var errors: Array[String] = []

	for joint_name in JOINT_ORDER:
		var idx := skeleton.find_bone(String(names[joint_name]))
		if idx < 0:
			errors.append("missing bone for %s: %s" % [joint_name, names[joint_name]])
		else:
			indices[joint_name] = idx

	if not errors.is_empty():
		return {"success": false, "errors": errors}

	var ankle_pitch := deg_to_rad(float(sample.get("ankle_pitch_deg", 0.0)))
	var subtalar_roll := deg_to_rad(float(sample.get("subtalar_roll_deg", 0.0)))
	var midfoot_pitch := deg_to_rad(float(sample.get("midfoot_pitch_deg", 0.0)))
	var ball_pitch := deg_to_rad(float(sample.get("ball_pitch_deg", 0.0)))
	var toe_pitch := deg_to_rad(float(sample.get("toe_pitch_deg", 0.0)))

	# Inversion/eversion must mirror across left and right feet.
	var side_roll_sign := 1.0 if side == SIDE_LEFT else -1.0

	skeleton.set_bone_pose_rotation(indices[JOINT_ANKLE], Quaternion(Vector3.RIGHT, ankle_pitch))
	skeleton.set_bone_pose_rotation(
		indices[JOINT_SUBTALAR],
		Quaternion(Vector3.FORWARD, subtalar_roll * side_roll_sign)
	)
	skeleton.set_bone_pose_rotation(indices[JOINT_MIDFOOT], Quaternion(Vector3.RIGHT, midfoot_pitch))
	skeleton.set_bone_pose_rotation(indices[JOINT_BALL], Quaternion(Vector3.RIGHT, ball_pitch))
	skeleton.set_bone_pose_rotation(indices[JOINT_TOE], Quaternion(Vector3.RIGHT, toe_pitch))

	return {"success": true, "errors": [], "indices": indices}

static func validate_contract() -> Dictionary:
	var errors: Array[String] = []

	if JOINT_ORDER.size() != 5:
		errors.append("expected exactly five deform/control joints per foot")
	if not JOINT_SPECS.has(JOINT_ANKLE):
		errors.append("ankle spec missing")
	if not JOINT_SPECS.has(JOINT_SUBTALAR):
		errors.append("subtalar spec missing")
	if not JOINT_SPECS.has(JOINT_MIDFOOT):
		errors.append("midfoot spec missing")
	if not JOINT_SPECS.has(JOINT_BALL):
		errors.append("ball/MTP spec missing")
	if not JOINT_SPECS.has(JOINT_TOE):
		errors.append("toe/IP spec missing")

	for mode in get_supported_modes():
		for i in range(101):
			var sample := sample_cycle(mode, float(i) / 100.0)
			if sample.is_empty():
				errors.append("empty sample for mode %s" % mode)
				break
			if not _sample_within_limits(sample):
				errors.append("joint limit violation in mode %s at phase %.2f" % [mode, float(i) / 100.0])
				break

	return {
		"success": errors.is_empty(),
		"errors": errors,
		"joint_count": JOINT_ORDER.size(),
		"mode_count": get_supported_modes().size(),
	}

static func _keys_for_mode(mode: String) -> Array:
	match mode:
		MODE_WALK:
			return [
				_k(0.00, -2.0, 4.0, 0.0, 0.0, 0.0, 0.000, -0.50),
				_k(0.08, -6.0, -1.0, 2.0, 0.0, 0.0, 0.000, -0.38),
				_k(0.45, 10.0, -5.0, 5.0, 8.0, 2.0, 0.000, 0.00),
				_k(0.58, -14.0, 3.0, -3.0, 40.0, 8.0, 0.015, 0.22),
				_k(0.60, -12.0, 2.0, -2.0, 32.0, 6.0, 0.030, 0.28),
				_k(0.78, 2.0, 0.0, 0.0, 5.0, 0.0, 0.070, 0.40),
			]
		MODE_RUN:
			return [
				_k(0.00, -8.0, 5.0, 1.0, 8.0, 2.0, 0.000, -0.55),
				_k(0.12, 10.0, -5.0, 5.0, 18.0, 4.0, 0.000, -0.28),
				_k(0.32, -18.0, 4.0, -4.0, 45.0, 10.0, 0.020, 0.18),
				_k(0.40, -14.0, 2.0, -2.0, 32.0, 6.0, 0.060, 0.34),
				_k(0.62, 4.0, 0.0, 0.0, 6.0, 0.0, 0.120, 0.55),
				_k(0.82, 2.0, 1.0, 0.0, 2.0, 0.0, 0.085, 0.35),
			]
		MODE_CROUCH_WALK:
			return [
				_k(0.00, 5.0, 3.0, 1.0, 0.0, 0.0, 0.000, -0.34),
				_k(0.12, 9.0, -2.0, 4.0, 2.0, 0.0, 0.000, -0.26),
				_k(0.52, 16.0, -4.0, 7.0, 10.0, 2.0, 0.000, 0.02),
				_k(0.68, -10.0, 3.0, -2.0, 30.0, 7.0, 0.012, 0.20),
				_k(0.70, -8.0, 2.0, -1.0, 24.0, 5.0, 0.020, 0.24),
				_k(0.86, 8.0, 0.0, 2.0, 4.0, 0.0, 0.040, 0.30),
			]
		_:
			return []

static func _k(
	phase: float,
	ankle_pitch_deg: float,
	subtalar_roll_deg: float,
	midfoot_pitch_deg: float,
	ball_pitch_deg: float,
	toe_pitch_deg: float,
	lift_m: float,
	stride_norm: float
) -> Dictionary:
	return {
		"phase": phase,
		"ankle_pitch_deg": ankle_pitch_deg,
		"subtalar_roll_deg": subtalar_roll_deg,
		"midfoot_pitch_deg": midfoot_pitch_deg,
		"ball_pitch_deg": ball_pitch_deg,
		"toe_pitch_deg": toe_pitch_deg,
		"lift_m": lift_m,
		"stride_norm": stride_norm,
	}

static func _interpolate_keys(keys: Array, phase: float) -> Dictionary:
	for i in range(keys.size()):
		var a := keys[i] as Dictionary
		var b := keys[(i + 1) % keys.size()] as Dictionary
		var phase_a := float(a["phase"])
		var phase_b := float(b["phase"])
		var sample_phase := phase

		if i == keys.size() - 1:
			phase_b += 1.0
			if sample_phase < phase_a:
				sample_phase += 1.0

		if sample_phase >= phase_a and sample_phase <= phase_b:
			var weight := inverse_lerp(phase_a, phase_b, sample_phase)
			return {
				"ankle_pitch_deg": lerpf(float(a["ankle_pitch_deg"]), float(b["ankle_pitch_deg"]), weight),
				"subtalar_roll_deg": lerpf(float(a["subtalar_roll_deg"]), float(b["subtalar_roll_deg"]), weight),
				"midfoot_pitch_deg": lerpf(float(a["midfoot_pitch_deg"]), float(b["midfoot_pitch_deg"]), weight),
				"ball_pitch_deg": lerpf(float(a["ball_pitch_deg"]), float(b["ball_pitch_deg"]), weight),
				"toe_pitch_deg": lerpf(float(a["toe_pitch_deg"]), float(b["toe_pitch_deg"]), weight),
				"lift_m": lerpf(float(a["lift_m"]), float(b["lift_m"]), weight),
				"stride_norm": lerpf(float(a["stride_norm"]), float(b["stride_norm"]), weight),
			}
	return {}

static func _stance_fraction(mode: String) -> float:
	match mode:
		MODE_WALK:
			return 0.60
		MODE_RUN:
			return 0.40
		MODE_CROUCH_WALK:
			return 0.70
		_:
			return 0.0

static func _phase_name(mode: String, phase: float) -> String:
	match mode:
		MODE_WALK:
			if phase < 0.08:
				return "heel_rocker"
			if phase < 0.50:
				return "ankle_rocker"
			if phase < 0.60:
				return "forefoot_rocker"
			return "swing"
		MODE_RUN:
			if phase < 0.12:
				return "contact"
			if phase < 0.32:
				return "loading"
			if phase < 0.40:
				return "propulsion"
			return "flight"
		MODE_CROUCH_WALK:
			if phase < 0.12:
				return "soft_contact"
			if phase < 0.52:
				return "low_support"
			if phase < 0.70:
				return "low_push_off"
			return "low_swing"
		_:
			return "unknown"

static func _clamp_sample(sample: Dictionary) -> Dictionary:
	var result := sample.duplicate(true)
	result["ankle_pitch_deg"] = clampf(
		float(result.get("ankle_pitch_deg", 0.0)),
		float(JOINT_SPECS[JOINT_ANKLE]["pitch_min_deg"]),
		float(JOINT_SPECS[JOINT_ANKLE]["pitch_max_deg"])
	)
	result["subtalar_roll_deg"] = clampf(
		float(result.get("subtalar_roll_deg", 0.0)),
		float(JOINT_SPECS[JOINT_SUBTALAR]["roll_min_deg"]),
		float(JOINT_SPECS[JOINT_SUBTALAR]["roll_max_deg"])
	)
	result["midfoot_pitch_deg"] = clampf(
		float(result.get("midfoot_pitch_deg", 0.0)),
		float(JOINT_SPECS[JOINT_MIDFOOT]["pitch_min_deg"]),
		float(JOINT_SPECS[JOINT_MIDFOOT]["pitch_max_deg"])
	)
	result["ball_pitch_deg"] = clampf(
		float(result.get("ball_pitch_deg", 0.0)),
		float(JOINT_SPECS[JOINT_BALL]["pitch_min_deg"]),
		float(JOINT_SPECS[JOINT_BALL]["pitch_max_deg"])
	)
	result["toe_pitch_deg"] = clampf(
		float(result.get("toe_pitch_deg", 0.0)),
		float(JOINT_SPECS[JOINT_TOE]["pitch_min_deg"]),
		float(JOINT_SPECS[JOINT_TOE]["pitch_max_deg"])
	)
	return result

static func _sample_within_limits(sample: Dictionary) -> bool:
	return (
		float(sample["ankle_pitch_deg"]) >= float(JOINT_SPECS[JOINT_ANKLE]["pitch_min_deg"])
		and float(sample["ankle_pitch_deg"]) <= float(JOINT_SPECS[JOINT_ANKLE]["pitch_max_deg"])
		and float(sample["subtalar_roll_deg"]) >= float(JOINT_SPECS[JOINT_SUBTALAR]["roll_min_deg"])
		and float(sample["subtalar_roll_deg"]) <= float(JOINT_SPECS[JOINT_SUBTALAR]["roll_max_deg"])
		and float(sample["midfoot_pitch_deg"]) >= float(JOINT_SPECS[JOINT_MIDFOOT]["pitch_min_deg"])
		and float(sample["midfoot_pitch_deg"]) <= float(JOINT_SPECS[JOINT_MIDFOOT]["pitch_max_deg"])
		and float(sample["ball_pitch_deg"]) >= float(JOINT_SPECS[JOINT_BALL]["pitch_min_deg"])
		and float(sample["ball_pitch_deg"]) <= float(JOINT_SPECS[JOINT_BALL]["pitch_max_deg"])
		and float(sample["toe_pitch_deg"]) >= float(JOINT_SPECS[JOINT_TOE]["pitch_min_deg"])
		and float(sample["toe_pitch_deg"]) <= float(JOINT_SPECS[JOINT_TOE]["pitch_max_deg"])
	)
