class_name ActivityStateMaintenance
extends ActivityState

var hours_left_in_maintenance := 12

func enter() -> void:
	hours_left_in_maintenance = 12

func update() -> String:
	hours_left_in_maintenance -= 1
	if hours_left_in_maintenance == 0:
		crew.corruption_level = 0
		return _next_state()
	return ""

func _next_state() -> String:
	if crew.current_tasks.size() > 0:
		return "working"
	return "idle"

func state_name() -> String:
	return "maintenance"

func productivity() -> float:
	return 0.0

func next_location() -> String:
	return "technical"
