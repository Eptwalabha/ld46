class_name ContagionStateHealed
extends ContagionState

func update() -> String:
	return ""

func get_factor() -> float:
	return 0.0

func exposed_to_virus(_contamination_factor: float) -> void:
	pass

func productivity() -> float:
	return 1.0
