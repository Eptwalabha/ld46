extends ContagionState

func get_factor() -> float:
	return 0.0

func exposed_to_virus(contamination_factor: float) -> bool:
	return randf() < contamination_factor

func productivity() -> float:
	return 1.0
