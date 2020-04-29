class_name ContagionStateHealthy
extends ContagionState

var is_infected = false

func enter() -> void:
	is_infected = false

func update() -> String:
	if is_infected:
		return "sick"
	return ""

func state_name() -> String:
	return "healthy"

func get_factor() -> float:
	return 0.0

func exposed_to_virus(contamination_factor: float) -> void:
	is_infected = is_infected or randf() < contamination_factor

func productivity() -> float:
	return 1.0

func is_infected() -> bool:
	return is_infected

func update_crew_aspect() -> void:
	crew.sick_particle.visible = false
	crew.heal_particle.visible = false

func menus() -> Array:
	return ["move", "test", "mask", "water", "food"]
