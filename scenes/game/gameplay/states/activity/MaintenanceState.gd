class_name ActivityStateMaintenance
extends ActivityState

var hours_left_in_maintenance := 12

func enter() -> void:
	hours_left_in_maintenance = 12

func update() -> String:
	hours_left_in_maintenance -= 1
	if hours_left_in_maintenance == 0:
		return "working"
	return ""

func productivity() -> float:
	return 0.0
