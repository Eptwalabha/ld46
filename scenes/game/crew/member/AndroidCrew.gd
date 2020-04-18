extends "res://scenes/game/crew/CrewMember.gd"

var in_maintenance := false

func update_crew_state(hour) -> void:
	emit_signal("crew_state_update")

func productivity(_hour: int) -> float:
	if in_maintenance:
		return 0.0
	return 1.0
