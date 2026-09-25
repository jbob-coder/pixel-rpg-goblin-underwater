class_name PixelRPGTouchInputState001
extends RefCounted

const SCHEMA := "pixel_rpg.touch_input_state_001.v1"

var _joystick_touch_id := -1
var _look_touch_id := -1
var _look_last_position := Vector2.ZERO
var _joystick_vector := Vector2.ZERO

func get_schema() -> String:
	return SCHEMA

func is_joystick_free() -> bool:
	return _joystick_touch_id == -1

func is_look_free() -> bool:
	return _look_touch_id == -1

func is_joystick_touch(touch_id: int) -> bool:
	return touch_id == _joystick_touch_id

func is_look_touch(touch_id: int) -> bool:
	return touch_id == _look_touch_id

func claim_joystick(touch_id: int) -> bool:
	if not is_joystick_free():
		return false
	_joystick_touch_id = touch_id
	return true

func claim_look(touch_id: int, position: Vector2) -> bool:
	if not is_look_free():
		return false
	_look_touch_id = touch_id
	_look_last_position = position
	return true

func update_look_drag(touch_id: int, position: Vector2) -> Dictionary:
	if not is_look_touch(touch_id):
		return {"handled": false, "delta": Vector2.ZERO}
	var delta := position - _look_last_position
	_look_last_position = position
	return {"handled": true, "delta": delta}

func set_joystick_vector(value: Vector2) -> void:
	_joystick_vector = value

func get_joystick_vector() -> Vector2:
	return _joystick_vector

func reset_joystick() -> void:
	_joystick_touch_id = -1
	_joystick_vector = Vector2.ZERO

func reset_look() -> void:
	_look_touch_id = -1
	_look_last_position = Vector2.ZERO

func reset_all() -> void:
	reset_joystick()
	reset_look()
