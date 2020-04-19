tool
class_name UITaskDetail
extends UIWindow

signal assignment_requested(task_id, crew_name)

onready var task_title := $MarginContainer/Content/Body/Task/Title as Label
onready var task_description := $MarginContainer/Content/Body/Task/Description/Text as RichTextLabel
onready var crew_list := $MarginContainer/Content/Body/Task/Crew as HBoxContainer

var task: Task

func open(the_task: Task) -> void:
	if not task is Task or task.task_id != the_task.task_id:
		task = the_task
		task_title.text = tr(task.title)
		task_description.bbcode_text = tr(task.description)
	refresh()
	show()

func refresh() -> void:
	if not task is Task:
		return
	for child in crew_list.get_children():
		crew_list.remove_child(child)
		child.queue_free()
	var crew_members = task.assigned_crew
	for i in range(task.max_crew):
		var assign_button = Button.new()
		var crew_name = ""
		if i < crew_members.size():
			crew_name = crew_members[i]
		assign_button.text = crew_name if crew_name != "" else " - "
		crew_list.add_child(assign_button)
		if assign_button.connect("pressed", self, "_on_assignment_requested"):
			hide()
	emit_signal("on_window_opened", self)

func _on_assignment_requested() -> void:
	emit_signal("assignment_requested", task.task_id)
