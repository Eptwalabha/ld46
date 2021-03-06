tool
class_name UITaskList
extends UIWindow

signal task_infos_requested(task_id)

onready var list_container := $MarginContainer/Content/Body/VBoxContainer as VBoxContainer
var UITaskResource = load("res://scenes/game/ui/tasks/UITask.tscn")

func set_tasks_list(tasks: Dictionary) -> void:
	for task_id in tasks:
		add_task_to_list(tasks[task_id])

func select_task(task_id: int) -> void:
	for line in list_container.get_children():
		line.selected(line.task.task_id == task_id)

func deselect_all() -> void:
	for line in list_container.get_children():
		line.selected(false)

func add_task_to_list(task) -> void:
	var t = UITaskResource.instance()
	list_container.add_child(t)
	t.set_task(task)
	t.connect("task_infos_requested", self, "_on_task_infos_requested")

func refresh() -> void:
	for line in list_container.get_children():
		line.refresh()

func _on_task_infos_requested(task_id: int) -> void:
	emit_signal("task_infos_requested", task_id)
