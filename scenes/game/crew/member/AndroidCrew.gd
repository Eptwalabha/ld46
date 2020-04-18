extends "res://scenes/game/crew/CrewMember.gd"

var need_maintenance := false
var in_maintenance := false
var last_maintenance := 0

func update_crew_state(hour) -> void:
	if need_maintenance:
		return
	if hour - last_maintenance > 10 * 24:
		need_maintenance = true
	emit_signal("crew_state_update")

func productivity(_hour: int) -> float:
	if in_maintenance:
		return 0.0
	return 1.0
