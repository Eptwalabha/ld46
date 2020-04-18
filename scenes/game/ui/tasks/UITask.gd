tool
class_name UITask
extends MarginContainer

onready var progress := $VBoxContainer/Progress as ProgressBar
onready var task_title := $VBoxContainer/HBoxContainer/TaskName as Label
onready var nbr := $VBoxContainer/HBoxContainer/Nbr as Label
var task : Task = null

func _ready() -> void:
	refresh()

func set_task(the_task: Task) -> void:
	task = the_task

func refresh() -> void:
	task_title.text = task.title
	nbr.text = "%s/%s" % ['0', task.max_crew]
	progress.max_value = task.hour_cost
	progress.value = task.hour_spent

func _on_Detail_pressed() -> void:
	pass

func _on_Task_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("click on %s" % task.title)
