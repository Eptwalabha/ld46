class_name ContagionStateHealed
extends ContagionState

var hour_in_state = 0

func enter() -> void:
	hour_in_state = 0

func update() -> String:
	hour_in_state += 1
	if hour_in_state >= 16:
		return "healthy"
	return ""

func get_factor() -> float:
	return 0.0

func exposed_to_virus(_contamination_factor: float) -> void:
	pass

func productivity() -> float:
	return 1.0

func state_name() -> String:
	return "healed"

func is_infected() -> bool:
	return false

func update_crew_aspect() -> void:
	crew.sick_particle.visible = hour_in_state < 8
	crew.heal_particle.visible = true

func menus() -> Array:
	return ["move", "water", "food"]
