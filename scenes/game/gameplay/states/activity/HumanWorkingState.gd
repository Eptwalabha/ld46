class_name ActivityStateHumanWorking
extends ActivityState

func update() -> String:
	crew.thirst += 1
	crew.hunger += 1
	crew.wake_up_since += 1
	if crew.wake_up_since > 30:
		return "sleeping"
	if crew.scheduled_tasks.size() == 0:
		return "no-activity"
	return ""

func state_name() -> String:
	return "working"

func productivity() -> float:
	var sleep_ratio = 1.0 if crew.wake_up_since < 24 else .8
	if crew.consecutive_hours_of_work < 7:
		return sleep_ratio
	var work_ratio = 0
	if crew.consecutive_hours_of_work < 5:
		work_ratio = .9
	elif crew.consecutive_hours_of_work < 7:
		work_ratio = .7
	else:
		work_ratio = .6
	return sleep_ratio * work_ratio

func work_on(task) -> void:
	crew.current_task = task.task_id
	crew.exhaustion += 1
	task.worked_on(crew.crew_name, crew.efficiency)

func next_location() -> String:
	return "work"
