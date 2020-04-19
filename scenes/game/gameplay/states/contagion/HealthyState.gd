class_name ContagionStateHealthy
extends ContagionState

var contaminated = false

func update() -> String:
	crew.contagion_detected = false
	if contaminated:
		return "sick"
	return ""

func state_name() -> String:
	return "healthy"

func get_factor() -> float:
	return 0.0

func exposed_to_virus(contamination_factor: float) -> void:
	contaminated = contaminated or randf() < contamination_factor

func productivity() -> float:
	return 1.0

func is_contaminated() -> bool:
	return contaminated
