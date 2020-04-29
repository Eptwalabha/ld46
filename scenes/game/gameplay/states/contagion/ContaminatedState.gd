class_name ContagionStateContaminated
extends ContagionState

export(int) var max_amount := 10
var contamination_amount : int = 5
var viral_test_made := false

func enter() -> void:
	contamination_amount = 5
	viral_test_made = false

func update() -> String:
	contamination_amount -= 1
	if contamination_amount <= 0:
		return "healthy"
	return ""

func state_name() -> String:
	return "contaminated"

func get_factor() -> float:
	match int(ceil(contamination_amount / 2.0)):
		1: return .1
		2: return .3
		3: return .7
		4: return 1.0
		_: pass
	return 1.0

func exposed_to_virus(_contamination_factor: float) -> void:
	pass

func is_infected() -> bool:
	return true

func make_a_viral_test() -> void:
	viral_test_made = true
