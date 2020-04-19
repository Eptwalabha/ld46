class_name ContagionStateSick
extends ContagionState

var hour_in_state = 0

func enter() -> void:
	hour_in_state = 0

func update() -> String:
	hour_in_state = 0
	if hour_in_state > 5 * 24:
		return "death"
	return ""

func state_name() -> String:
	return "sick"

func get_factor() -> float:
	if hour_in_state == 0:
		return 0.0

	var days_sick = ceil(hour_in_state / 24)
	match days_sick:
		1: return .1
		2: return .3
		3: return .7
		4: return 1.0
		_: pass
	return 1.0

func exposed_to_virus(_contamination_factor: float) -> void:
	pass

func productivity() -> float:
	if hour_in_state == 0.0:
		return 1.0

	var days_sick = ceil(hour_in_state / 24)
	match days_sick:
		1: return 1.0
		2: return 1.0
		3: return .7
		4: return .3
		_: pass
	return .1
