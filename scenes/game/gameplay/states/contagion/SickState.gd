class_name ContagionStateSick
extends ContagionState

export(float) var day_before_death := 4.0

var hours_before_death := 0.0
var hours_in_state := 0.0

func enter() -> void:
	hours_before_death = ceil(day_before_death * 24)
	hours_in_state = 0.0

func update() -> String:
	hours_in_state += 1
	if hours_in_state >= hours_before_death:
		return "death"
	return ""

func state_name() -> String:
	return "sick"

func get_factor() -> float:
	if hours_in_state == 0:
		return 0.2
	return 0.2 + (hours_in_state / hours_before_death) * .6

func exposed_to_virus(_contamination_factor: float) -> void:
	pass

func productivity() -> float:
	if hours_in_state == 0.0:
		return 1.0
	var days_sick = ceil(hours_in_state / 24)
	match days_sick:
		1: return 1.0
		2: return .9
		3: return .7
		4: return .3
		_: pass
	return .1

func is_infected() -> bool:
	return true

func update_crew_aspect() -> void:
	if hours_in_state < 20:
		crew.modulate = Color(0.8, 1, 0.8)
	else:
		crew.modulate = Color(0.5, 1, 0.5)
