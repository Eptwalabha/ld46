class_name ContagionStateHealthy
extends ContagionState

var is_infencted = false

func update() -> String:
	crew.contagion_detected = false
	if is_infencted:
		return "sick"
	return ""

func state_name() -> String:
	return "healthy"

func get_factor() -> float:
	return 0.0

func exposed_to_virus(contamination_factor: float) -> void:
	is_infencted = is_infencted or randf() < contamination_factor

func productivity() -> float:
	return 1.0

func is_infected() -> bool:
	return is_infencted
