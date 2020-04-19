class_name HumanCrew
extends CrewMember

export(bool) var wearing_mask := false

func productivity() -> float:
	var health_ratio = current_health_state.productivity()
	return health_ratio
#	if is_infected:
#		var day_infected = ceil((hour - infected_since) / 24.0)
#		match day_infected:
#			1: return 1.0
#			2: return .9
#			3: return .7
#			4: return .3
#			_: return .2
#	else:

func exposed_to_virus(factor: float) -> void:
	factor = factor if not wearing_mask else factor / 2.0
	if current_health_state.exposed_to_virus(factor):
		change_contagion_state($ContagionStates/Sick)

func infectiousness() -> float:
	var factor = current_health_state.get_factor()
	return factor if not wearing_mask else factor / 2.0

func is_alive() -> bool:
	return current_health_state.is_dead()
