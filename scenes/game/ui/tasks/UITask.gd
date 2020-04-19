tool
class_name UITask
extends MarginContainer

signal task_infos_requested(task_id)

onready var progress := $Line/Infos/Progress as ProgressBar
onready var task_title := $Line/Infos/Infos/Name as Label
onready var crew_nbr := $Line/Infos/Infos/CrewCount as Label
onready var color_rect := $Line/ColorRect as ColorRect

var task: Task
var is_selected := false setget selected

func set_task(the_task: Task) -> void:
	task = the_task
	progress.max_value = the_task.time_to_complete
	progress.value = the_task.hour_spent

func selected(selected: bool) -> void:
	is_selected = selected
	color_rect.color.a = 1.0 if is_selected else 0.0

func refresh() -> void:
	progress.value = task.hour_spent
	crew_nbr.text = "%s/%s" % [task.crew_count, task.max_crew]

func _on_Task_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("task_infos_requested", task.task_id)
