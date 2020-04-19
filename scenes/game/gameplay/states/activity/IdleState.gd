class_name ActivityStateIdle
extends ActivityState

func update() -> String:
	if crew.scheduled_tasks.size() > 0:
		return "working"
	return ""

func state_name() -> String:
	return "idle"
