class_name ActivityStateSleeping
extends ActivityState

var room_setup = false

func enter() -> void:
	room_setup = false

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

func next_location() -> String:
	if not room_setup:
		room_setup = true
		return "my-quarter"
	return ""
