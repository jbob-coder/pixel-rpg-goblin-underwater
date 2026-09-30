class_name PixelRPGFootBiomechanics
extends RefCounted

const SCHEMA := "pixel_rpg.avatar_foot_biomechanics.v1"

const SIDE_LEFT := "left"
const SIDE_RIGHT := "right"

const MODE_WALK := "walk"
const MODE_RUN := "run"
const MODE_CROUCH := "crouch"

# Anatomical sign convention used by this presentation-only rig:
# +ankle_pitch_deg = dorsiflexion, - = plantarflexion.
# +subtalar_roll_deg = eversion, - = inversion.
# +midfoot_pitch_deg = arch/midfoot dorsiflexion.
# +mtp_pitch_deg = toe-base dorsiflexion/extension.
# +toe_pitch_deg = additional distal toe extension.
#
# The values below are intentionally conservative animation limits, not a
# medical model. The locomotion tracks encode the verified heel -> ankle ->
# forefoot rocker sequence while remaining stylized and Android-friendly.

const JOINT_ANKLE := "ankle"
const JOINT_SUBTALAR := "subtalar"
const JOINT_MIDFOOT := "midfoot"
const JOINT_MTP := "mtp"
const JOINT_TOE := "toe"
const JOINT_BIG_TOE := "big_toe"
const JOINT_LESSER_TOES := "lesser_toes"

const JOINT_ORDER: Array[String] = [
	JOINT_ANKLE,
	JOINT_SUBTALAR,
	JOINT_MIDFOOT,
	JOINT_MTP,
	JOINT_TOE,
	JOINT_BIG_TOE,
	JOINT_LESSER_TOES,
]

const JOINT_LIMITS_DEG := {
	"ankle_pitch_deg": Vector2(-35.0, 25.0),
	"subtalar_roll_deg": Vector2(-15.0, 15.0),
	"midfoot_pitch_deg": Vector2(-12.0, 12.0),
	"mtp_pitch_deg": Vector2(0.0, 65.0),
	"toe_pitch_deg": Vector2(-10.0, 30.0),
	"big_toe_pitch_deg": Vector2(0.0, 20.0),
	"lesser_toes_pitch_deg": Vector2(0.0, 16.0),
}

# Gameplay/animation timing targets. Walk uses the commonly reported ~60/40
# stance/swing split. Run and crouch values are authored targets for readable
# game motion, not claims of universal human timing.
const MODE_METADATA := {
	MODE_WALK: {
		"stance_end": 0.60,
		"stride_scale": 1.0,
		"clearance_scale": 1.0,
	},
	MODE_RUN: {
		"stance_end": 0.40,
		"stride_scale": 1.42,
		"clearance_scale": 1.55,
	},
	MODE_CROUCH: {
		"stance_end": 0.68,
		"stride_scale": 0.68,
		"clearance_scale": 0.62,
	},
}

static func get_schema() -> String:
	return SCHEMA

static func get_joint_order() -> Array[String]:
	return JOINT_ORDER.duplicate()

static func get_joint_limits_deg() -> Dictionary:
	return JOINT_LIMITS_DEG.duplicate(true)

static func get_mode_metadata(mode: String) -> Dictionary:
	return (MODE_METADATA.get(mode, {}) as Dictionary).duplicate(true)

static func is_supported_mode(mode: String) -> bool:
	return mode == MODE_WALK or mode == MODE_RUN or mode == MODE_CROUCH

static func is_supported_side(side: String) -> bool:
	return side == SIDE_LEFT or side == SIDE_RIGHT

static func create_joint_chain(parent: Node3D, side: String) -> Dictionary:
	if parent == null:
		push_error("Foot biomechanics rig requires a valid parent.")
		return {}
	if not is_supported_side(side):
		push_error("Foot biomechanics rig requires side 'left' or 'right'.")
		return {}

	var root := Node3D.new()
	root.name = "FootRigLeft" if side == SIDE_LEFT else "FootRigRight"
	parent.add_child(root)

	var ankle := _make_pivot(root, "AnklePivot", Vector3.ZERO)
	var subtalar := _make_pivot(ankle, "SubtalarPivot", Vector3(0.0, -0.065, 0.035))
	var midfoot := _make_pivot(subtalar, "MidfootPivot", Vector3(0.0, -0.015, -0.075))
	var mtp := _make_pivot(midfoot, "MTPPivot", Vector3(0.0, 0.0, -0.115))
	var toe := _make_pivot(mtp, "ToePivot", Vector3(0.0, 0.0, -0.075))

	var medial_sign := -1.0 if side == SIDE_LEFT else 1.0
	var big_toe := _make_pivot(toe, "BigToePivot", Vector3(0.036 * medial_sign, 0.0, -0.052))
	var lesser_toes := _make_pivot(toe, "LesserToesPivot", Vector3(-0.020 * medial_sign, 0.0, -0.048))

	root.set_meta("pixel_rpg_schema", SCHEMA)
	root.set_meta("pixel_rpg_side", side)
	root.set_meta("pixel_rpg_presentation_only", true)

	return {
		"root": root,
		JOINT_ANKLE: ankle,
		JOINT_SUBTALAR: subtalar,
		JOINT_MIDFOOT: midfoot,
		JOINT_MTP: mtp,
		JOINT_TOE: toe,
		JOINT_BIG_TOE: big_toe,
		JOINT_LESSER_TOES: lesser_toes,
		"side": side,
	}

static func apply_pose(joints: Dictionary, pose: Dictionary) -> void:
	if joints.is_empty() or pose.is_empty():
		return

	var side := String(joints.get("side", SIDE_RIGHT))
	var roll_mirror := -1.0 if side == SIDE_LEFT else 1.0

	var ankle := joints.get(JOINT_ANKLE) as Node3D
	var subtalar := joints.get(JOINT_SUBTALAR) as Node3D
	var midfoot := joints.get(JOINT_MIDFOOT) as Node3D
	var mtp := joints.get(JOINT_MTP) as Node3D
	var toe := joints.get(JOINT_TOE) as Node3D
	var big_toe := joints.get(JOINT_BIG_TOE) as Node3D
	var lesser_toes := joints.get(JOINT_LESSER_TOES) as Node3D

	if ankle != null:
		ankle.rotation_degrees.x = float(pose.get("ankle_pitch_deg", 0.0))
	if subtalar != null:
		subtalar.rotation_degrees.z = float(pose.get("subtalar_roll_deg", 0.0)) * roll_mirror
	if midfoot != null:
		midfoot.rotation_degrees.x = float(pose.get("midfoot_pitch_deg", 0.0))
	if mtp != null:
		mtp.rotation_degrees.x = float(pose.get("mtp_pitch_deg", 0.0))
	if toe != null:
		toe.rotation_degrees.x = float(pose.get("toe_pitch_deg", 0.0))
	if big_toe != null:
		big_toe.rotation_degrees.x = float(pose.get("big_toe_pitch_deg", 0.0))
	if lesser_toes != null:
		lesser_toes.rotation_degrees.x = float(pose.get("lesser_toes_pitch_deg", 0.0))

static func sample_pose(mode: String, phase: float) -> Dictionary:
	if not is_supported_mode(mode):
		push_error("Unsupported foot locomotion mode: %s" % mode)
		return {}

	var wrapped_phase := fposmod(phase, 1.0)
	var track := _get_track(mode)
	return _sample_track(track, wrapped_phase)

static func validate_pose(pose: Dictionary) -> Dictionary:
	var errors: Array[String] = []
	for key in JOINT_LIMITS_DEG.keys():
		var limits := JOINT_LIMITS_DEG[key] as Vector2
		var value := float(pose.get(key, 0.0))
		if value < limits.x - 0.001 or value > limits.y + 0.001:
			errors.append("%s=%.3f outside [%.3f, %.3f]" % [key, value, limits.x, limits.y])
	return {
		"success": errors.is_empty(),
		"errors": errors,
	}

static func _make_pivot(parent: Node3D, node_name: String, offset: Vector3) -> Node3D:
	var pivot := Node3D.new()
	pivot.name = node_name
	pivot.position = offset
	parent.add_child(pivot)
	return pivot

static func _get_track(mode: String) -> Array[Dictionary]:
	if mode == MODE_RUN:
		return _run_track()
	if mode == MODE_CROUCH:
		return _crouch_track()
	return _walk_track()

static func _walk_track() -> Array[Dictionary]:
	return [
		_pose_key(0.00, -2.0, -3.0, 0.0, 0.0, 0.0, 0.0, 0.0, "heel_strike"),
		_pose_key(0.10, -6.0,  3.0, -1.0, 0.0, 0.0, 0.0, 0.0, "foot_flat"),
		_pose_key(0.34,  8.0,  5.0,  2.0, 4.0, 0.0, 1.0, 1.0, "midstance"),
		_pose_key(0.50, 10.0,  1.0,  3.0, 28.0, 4.0, 4.0, 3.0, "heel_rise"),
		_pose_key(0.60, -14.0, -2.0, -2.0, 48.0, 10.0, 10.0, 7.0, "toe_off"),
		_pose_key(0.76,  6.0, -1.0,  0.0, 20.0, 4.0, 3.0, 2.0, "mid_swing"),
		_pose_key(0.92,  2.0, -2.0,  0.0, 6.0, 0.0, 0.0, 0.0, "terminal_swing"),
	]

static func _run_track() -> Array[Dictionary]:
	return [
		# Faster running often reduces or removes the heel-rocker emphasis.
		_pose_key(0.00,  1.0, -2.0, 1.0, 10.0, 1.0, 1.0, 1.0, "forefoot_contact"),
		_pose_key(0.10, 10.0,  5.0, 5.0, 14.0, 2.0, 2.0, 2.0, "load"),
		_pose_key(0.24, 14.0,  3.0, 6.0, 34.0, 5.0, 5.0, 4.0, "midstance"),
		_pose_key(0.38, -22.0, -2.0, -4.0, 55.0, 13.0, 13.0, 9.0, "push_off"),
		_pose_key(0.52,  8.0, -1.0, 0.0, 28.0, 5.0, 4.0, 3.0, "early_flight"),
		_pose_key(0.74, 10.0, -1.0, 0.0, 14.0, 2.0, 1.0, 1.0, "swing_clearance"),
		_pose_key(0.92,  3.0, -2.0, 0.0, 8.0, 0.0, 0.0, 0.0, "pre_contact"),
	]

static func _crouch_track() -> Array[Dictionary]:
	return [
		# Game crouch-walk keeps the body low, shortens stride, keeps contact
		# longer, and uses more ankle dorsiflexion through loaded stance.
		_pose_key(0.00,  2.0, -2.0, 1.0, 2.0, 0.0, 0.0, 0.0, "soft_contact"),
		_pose_key(0.14,  9.0,  5.0, 4.0, 4.0, 0.0, 1.0, 1.0, "loaded_flat"),
		_pose_key(0.38, 16.0,  6.0, 6.0, 10.0, 1.0, 2.0, 2.0, "low_midstance"),
		_pose_key(0.58, 13.0,  2.0, 5.0, 31.0, 5.0, 5.0, 4.0, "low_heel_rise"),
		_pose_key(0.68, -10.0, -1.0, -2.0, 44.0, 9.0, 9.0, 6.0, "low_toe_off"),
		_pose_key(0.82, 10.0, -1.0, 1.0, 20.0, 3.0, 3.0, 2.0, "low_swing"),
		_pose_key(0.94,  5.0, -2.0, 1.0, 7.0, 0.0, 0.0, 0.0, "pre_contact"),
	]

static func _pose_key(
	phase: float,
	ankle: float,
	subtalar: float,
	midfoot: float,
	mtp: float,
	toe: float,
	big_toe: float,
	lesser_toes: float,
	label: String
) -> Dictionary:
	return {
		"phase": phase,
		"label": label,
		"ankle_pitch_deg": ankle,
		"subtalar_roll_deg": subtalar,
		"midfoot_pitch_deg": midfoot,
		"mtp_pitch_deg": mtp,
		"toe_pitch_deg": toe,
		"big_toe_pitch_deg": big_toe,
		"lesser_toes_pitch_deg": lesser_toes,
	}

static func _sample_track(track: Array[Dictionary], phase: float) -> Dictionary:
	if track.is_empty():
		return {}

	var a := track[0]
	var b := track[0]
	for index in range(track.size()):
		var current := track[index]
		var next := track[(index + 1) % track.size()]
		var p0 := float(current["phase"])
		var p1 := float(next["phase"])
		var sample_phase := phase

		if index == track.size() - 1:
			p1 += 1.0
			if sample_phase < p0:
				sample_phase += 1.0

		if sample_phase >= p0 and sample_phase <= p1:
			a = current
			b = next
			var span := maxf(p1 - p0, 0.0001)
			var t := clampf((sample_phase - p0) / span, 0.0, 1.0)
			var eased := t * t * (3.0 - 2.0 * t)
			return {
				"phase": phase,
				"label": String(a["label"]) if eased < 0.5 else String(b["label"]),
				"ankle_pitch_deg": lerpf(float(a["ankle_pitch_deg"]), float(b["ankle_pitch_deg"]), eased),
				"subtalar_roll_deg": lerpf(float(a["subtalar_roll_deg"]), float(b["subtalar_roll_deg"]), eased),
				"midfoot_pitch_deg": lerpf(float(a["midfoot_pitch_deg"]), float(b["midfoot_pitch_deg"]), eased),
				"mtp_pitch_deg": lerpf(float(a["mtp_pitch_deg"]), float(b["mtp_pitch_deg"]), eased),
				"toe_pitch_deg": lerpf(float(a["toe_pitch_deg"]), float(b["toe_pitch_deg"]), eased),
				"big_toe_pitch_deg": lerpf(float(a["big_toe_pitch_deg"]), float(b["big_toe_pitch_deg"]), eased),
				"lesser_toes_pitch_deg": lerpf(float(a["lesser_toes_pitch_deg"]), float(b["lesser_toes_pitch_deg"]), eased),
			}

	return a.duplicate(true)
