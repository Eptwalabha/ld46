class_name ContagionStateDead
extends ContagionState

export(int) var max_amount := 10
var contamination_amount : int = 5

func enter() -> void:
	contamination_amount = 5

func update() -> String:
	contamination_amount -= 1
	if contamination_amount <= 0:
		return "healthy"
	return ""

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
