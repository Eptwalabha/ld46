extends ActivityState

func update() -> String:
	crew.wake_up_since += 1
	crew.consecutive_hours_of_work = 0
	if crew.scheduled_tasks.size() > 0:
		return "working"
	return ""

func state_name() -> String:
	return "no-activity"

func next_location() -> String:
	if crew.next_location != null:
		var next = crew.next_location
		crew.next_location = null
		return next
	return "my-quarter"
	var r = randf()
	if r > .7:
		return ""
	if r > .5:
		return "my-quarter"
	if r > .2:
		return "living"
	return "random"
