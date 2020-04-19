extends ContagionState

var contaminated = false

func get_factor() -> float:
	return 0.0

func update() -> String:
	if contaminated:
		return "contaminated"
	return ""

func exposed_to_virus(contamination_factor: float) -> void:
	contaminated = contaminated or randf() < contamination_factor

func productivity() -> float:
	return 1.0

func is_contaminated() -> bool:
	return contaminated
