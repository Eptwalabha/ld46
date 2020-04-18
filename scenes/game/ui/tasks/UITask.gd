tool
class_name UITask
extends MarginContainer

signal task_infos_requested(task_id)

onready var progress := $VBoxContainer/Progress as ProgressBar
onready var task_title := $VBoxContainer/HBoxContainer/TaskName as Label
onready var crew_nbr := $VBoxContainer/HBoxContainer/CrewCount as Label
var task_id
var max_crew

func set_task(the_task: Task) -> void:
	task_id = the_task.task_id
	max_crew = the_task.max_crew
	progress.max_value = the_task.hour_cost
	progress.value = the_task.hour_spent

func refresh(hour_spent: float, crew_count: int) -> void:
	progress.value = hour_spent
	crew_nbr.text = "%s/%s" % [crew_count, max_crew]

func _on_Task_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("task_infos_requested", task_id)
