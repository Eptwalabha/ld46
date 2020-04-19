tool
class_name UITaskDetail
extends UIWindow

signal assignment_requested(task_id, crew_name)

onready var task_title := $MarginContainer/Content/Body/Task/Title as Label
onready var task_description := $MarginContainer/Content/Body/Task/Description/Text as RichTextLabel
onready var crew_list := $MarginContainer/Content/Body/Task/Crew as HBoxContainer

var task_id

func open(task: Task, crew_members: Array) -> void:
	if task_id != task.task_id:
		task_id = task.task_id
		task_title.text = tr(task.title)
		print(task.description)
		task_description.bbcode_text = tr(task.description)

	for child in crew_list.get_children():
		crew_list.remove_child(child)
		child.queue_free()
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
	show()

func _on_assignment_requested() -> void:
	emit_signal("assignment_requested", task_id)
