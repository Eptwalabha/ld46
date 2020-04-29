class_name ContagionStateSick
extends ContagionState

export(int) var hours_before_death = 30

var remaining_hours := 0.0
var viral_test_made := false

func enter() -> void:
	remaining_hours = hours_before_death
	viral_test_made = false

func update() -> String:
	remaining_hours -= 1
	if remaining_hours <= 0:
		return "death"
	return ""

func state_name() -> String:
	return "sick"

func get_factor() -> float:
	var level = _level()
	return 0.2 + level * .6

func exposed_to_virus(_contamination_factor: float) -> void:
	pass

func productivity() -> float:
	match _level():
		0: return 1.0
		1: return 1.0
		2: return .9
		_: return .7

func is_infected() -> bool:
	return true

func update_crew_aspect() -> void:
	crew.sick_particle.visible = _level() > 1
	crew.heal_particle.visible = false

func _level() -> int:
	if remaining_hours < 5:
		return 3
	elif remaining_hours < 15:
		return 2
	elif remaining_hours < 22:
		return 1
	return 0

func make_a_viral_test() -> void:
	viral_test_made = true

func menus() -> Array:
	if viral_test_made or _level() > 1:
		return ["move", "heal", "mask", "water", "food"]
	return ["move", "test", "mask", "water", "food"]
