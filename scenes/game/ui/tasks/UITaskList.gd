tool
class_name UITaskList
extends UIWindow

onready var list_container := $MarginContainer/Content/Body/VBoxContainer as VBoxContainer
var UITaskResource = load("res://scenes/game/ui/tasks/UITask.tscn")

func set_tasks_list(tasks: Array) -> void:
	for task in tasks:
		add_task_to_list(task)

func add_task_to_list(task) -> void:
	var t = UITaskResource.instance()
	t.set_task(task)
	list_container.add_child(t)

func refresh() -> void:
	for line in list_container.get_children():
		line.refresh()
