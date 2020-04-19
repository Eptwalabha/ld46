class_name ActivityStateHumanWorking
extends ActivityState

func update() -> String:
	if crew.wake_up_since > 30:
		return "sleeping"
	if crew.scheduled_tasks.size() == 0:
		return "no-activity"
	return ""

func state_name() -> String:
	return "working"

func productivity() -> float:
	return 1.0

func work_on(task) -> void:
	crew.current_task = task.task_id
	crew.exhaustion += 1
	task.worked_on(crew.crew_name, crew.efficiency)
