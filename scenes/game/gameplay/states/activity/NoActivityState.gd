extends ActivityState

func update() -> String:
	crew.consecutive_hours_of_work = 0
	if crew.scheduled_tasks.size() > 0:
		return "working"
	return ""

func state_name() -> String:
	return "no-activity"
