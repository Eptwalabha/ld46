class_name AndroidCrew
extends CrewMember

var need_maintenance := false
var in_maintenance := false
var last_maintenance := 0
var hour_without_maintenance := 0

func is_human() -> bool:
	return false

func update_state(hour) -> void:
	if need_maintenance:
		return
	hour_without_maintenance = hour - last_maintenance
	need_maintenance = hour_without_maintenance > 5 * 24
	emit_signal("crew_state_update")

func productivity() -> float:
	if in_maintenance:
		return 0.0
	return 1.0

func exposed_to_virus(factor: float) -> void:
	if current_health_state.exposed_to_virus(factor):
		change_contagion_state($ContagionStates/Contagious)

