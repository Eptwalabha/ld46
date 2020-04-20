class_name ContagionStateDead
extends ContagionState

export(int) var max_amount := 10
var contamination_amount : int = 10

func enter() -> void:
	contamination_amount = 10
	crew.is_dead = true
	crew.modulate = Color.gray

func update() -> String:
	if contamination_amount > 0:
		contamination_amount -= 1
	return ""

func state_name() -> String:
	return "death"

func get_factor() -> float:
	match int(ceil(contamination_amount / 2.0)):
		1: return .1
		2: return .3
		3: return .7
		4: return 1.0
		_: pass
	return 1.0

func productivity() -> float:
	return 0.0

func is_dead() -> bool:
	return true

func is_infected() -> bool:
	return contamination_amount > 0

func update_crew_aspect() -> void:
	crew.modulate = Color.red

