class_name ActivityStateHealing
extends ActivityState

var hours_left_to_heal := 12

func enter() -> void:
	hours_left_to_heal = 12

func update() -> String:
	crew.thirst -= 1
	crew.hunger -= 1
	crew.exhaustion -= 1
	crew.consecutive_hours_of_work = 0
	hours_left_to_heal -= 1
	if hours_left_to_heal == 0:
		crew.healed()
		return _next_state()
	return ""

func _next_state() -> String:
	if crew.scheduled_tasks.size() > 0:
		return "working"
	return "no-activity"

func state_name() -> String:
	return "cleaning"

func productivity() -> float:
	return 0.0

func next_location() -> String:
	return "medical"
