class_name ActivityStateSleep
extends ActivityState

func update() -> String:
	crew.exhaustion -= 2
	if crew.exhaustion < 0:
		crew.exhaustion = 0
		crew.wake_up_since = 0
		return "no-activity"
	return ""

func state_name() -> String:
	return "sleeping"
