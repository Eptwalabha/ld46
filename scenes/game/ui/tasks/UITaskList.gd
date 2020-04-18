tool
class_name UITaskList
extends UIWindow

signal task_infos_requested(task_id)

onready var list_container := $MarginContainer/Content/Body/VBoxContainer as VBoxContainer
var UITaskResource = load("res://scenes/game/ui/tasks/UITask.tscn")

func set_tasks_list(tasks: Array) -> void:
	for task in tasks:
		add_task_to_list(task)

func add_task_to_list(task) -> void:
	var t = UITaskResource.instance()
	list_container.add_child(t)
	t.set_task(task)
	t.connect("task_infos_requested", self, "_on_task_infos_requested")

func refresh(update: Dictionary) -> void:
	for line in list_container.get_children():
		var task_id = line.task_id
		if update.has(task_id):
#			line.refresh(update[task_id].hour_spent, update[task_id].crew_assigned)
			line.refresh(update[task_id].hour_spent, 0)

func _on_task_infos_requested(task_id: int) -> void:
	emit_signal("task_infos_requested", task_id)
