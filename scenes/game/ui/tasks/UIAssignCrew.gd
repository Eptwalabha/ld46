tool
class_name UIAssignCrew
extends UIWindow

signal assign_crew_members(task_id, crew_members)

onready var crew_list := $MarginContainer/Content/Body/Crew/List as VBoxContainer
var task_id
var max_crew
var crew_selection = []

func open(task: Task, crew_members: Dictionary, assigned_crew: Array) -> void:
	task_id = task.task_id
	max_crew = task.max_crew
	crew_selection = assigned_crew
	var CrewVignette = load("res://scenes/game/ui/crew/UICrewVignette.tscn")
	for vignette in crew_list.get_children():
		crew_list.remove_child(vignette)
		vignette.queue_free()

	for crew_name in crew_members:
		var vignette = CrewVignette.instance()
		crew_list.add_child(vignette)
		vignette.set_crew(crew_members[crew_name])
		vignette.set_selected(assigned_crew.has(crew_name))
		if vignette.connect("selection_changed", self, "_on_vignette_selection_changed", [crew_name]):
			crew_list.remove_child(vignette)
			vignette.queue_free()
	show()

func _on_vignette_selection_changed(is_selected, crew_name) -> void:
	var crew_was_selected = crew_selection.has(crew_name)
	if is_selected and not crew_was_selected:
		crew_selection.push_back(crew_name)
	if not is_selected and crew_was_selected:
		crew_selection.remove(crew_selection.find(crew_name))
	if crew_selection.size() > max_crew:
		crew_selection.pop_front()
		for vignette in crew_list.get_children():
			vignette.set_selected(crew_selection.has(vignette.crew_name))

func _on_Confirm_pressed() -> void:
	var crew_members = []
	for item in crew_list.get_children():
		if item.selected:
			crew_members.push_back(item.crew_name)
	emit_signal("assign_crew_members", task_id, crew_members)
	hide()
