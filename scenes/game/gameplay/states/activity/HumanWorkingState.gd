class_name ActivityStateHumanWorking
extends ActivityState

func update() -> String:
	if crew.wake_up_since > 30:
		return "sleeping"
	return ""

func productivity() -> float:
	return 1.0

func work_on(task) -> void:
	if crew.is_dead():
		return
	crew.current_task = task.task_id
	crew.exhaustion += 1
	task.worked_on(crew.crew_name, crew.efficiency)
