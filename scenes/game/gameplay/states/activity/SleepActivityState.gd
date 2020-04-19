class_name ActivityStateSleeping
extends ActivityState

func update() -> String:
	crew.consecutive_hours_of_work = 0
	crew.exhaustion -= 2
	if crew.exhaustion < 0:
		crew.exhaustion = 0
		crew.wake_up_since = 0
		return "no-activity"
	return ""

func state_name() -> String:
	return "sleeping"
