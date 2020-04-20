class_name ActivityStateAndroidWorking
extends ActivityState

func update() -> String:
	if crew.scheduled_tasks.size() == 0:
		return "idle"
	return ""

func state_name() -> String:
	return "working"

func productivity() -> float:
	match crew.corruption_level:
		0: return 1.0
		1: return .9
		2: return .7
		_: pass
	return .5

func work_on(task) -> void:
	crew.hours_before_next_maintenance -= 1
	crew.current_task = task.task_id
	task.worked_on(crew.crew_name, crew.efficiency)

func next_location() -> String:
	return "work"
