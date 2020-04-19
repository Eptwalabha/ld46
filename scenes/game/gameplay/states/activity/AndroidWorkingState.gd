class_name ActivityStateAndroidWorking
extends ActivityState

func update() -> String:
	return ""

func productivity() -> float:
	return 1.0

func work_on(task) -> void:
	crew.current_task = task.task_id
	task.worked_on(crew.crew_name, crew.efficiency)
