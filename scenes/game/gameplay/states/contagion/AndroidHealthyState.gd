extends ContagionState

var is_contaminated = false

func get_factor() -> float:
	return 0.0

func enter() -> void:
	is_contaminated = false

func update() -> String:
	if is_contaminated:
		return "contaminated"
	return ""

func state_name() -> String:
	return "healthy"

func exposed_to_virus(contamination_factor: float) -> void:
	is_contaminated = is_contaminated or randf() < contamination_factor

func productivity() -> float:
	return 1.0

func is_infected() -> bool:
	return is_contaminated
