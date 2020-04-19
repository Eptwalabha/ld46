class_name ActivityStateCleaned
extends ActivityState

var hours_left_to_clean := 6

func enter() -> void:
	hours_left_to_clean = 6

func update() -> String:
	hours_left_to_clean -= 1
	if hours_left_to_clean == 0:
		return _next_state()
	return ""

func _next_state() -> String:
	if crew.current_tasks.size() > 0:
		return "working"
	return "idle"

func state_name() -> String:
	return "cleaning"

func productivity() -> float:
	return 0.0
