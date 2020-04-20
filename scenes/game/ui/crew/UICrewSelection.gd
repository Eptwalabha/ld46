class_name UICrewSelection
extends Control

signal crew_selection_confirmed(action, selected_crew, data)

onready var crew_list := $Control/Window/Margin/Container/Crew/Center/Lines as VBoxContainer

var action : String = ""
var data
var crew_members := {}
var vignettes := {}
var crew_selection := []
var max_crew_selected := 10

func prepare(the_crew_members: Dictionary) -> void:
	crew_members = the_crew_members
	vignettes = {}
	var CrewVignette = load("res://scenes/game/ui/crew/UICrewVignette.tscn")

	var crew_names = crew_members.keys()
	for line in range(0, 3):
		var node_line = crew_list.get_child(line)
		for column in range(0, 3):
			var index = line * 3 + column
			if index >= crew_names.size():
				return
			var crew_name = crew_names[index]
			var crew = crew_members[crew_name]
			var vignette = CrewVignette.instance()
			vignettes[crew_name] = vignette
			node_line.add_child(vignette)
			vignette.set_crew(crew)
			vignette.connect("selection_changed", self, "_on_vignette_selection_changed", [crew_name])

func open(the_action: String, selected: Array, the_data, max_selection: int = 10, details: String = "") -> void:
	$Control/Window/Margin/Container/Details.visible = details != ""
	$Control/Window/Margin/Container/Details/Description.text = tr(details)
	data = the_data
	action = the_action
	crew_selection = selected
	max_crew_selected = max_selection
	for crew_name in vignettes:
		vignettes[crew_name].set_selected(crew_selection.has(crew_name))
	$Control/Window.show()
	show()


func _on_Window_on_window_closed(_window) -> void:
	print("ici")
	hide()

func _on_Confirm_pressed() -> void:
	emit_signal("crew_selection_confirmed", action, crew_selection, data)
	hide()

func _on_Cancel_pressed() -> void:
	hide()

func _on_vignette_selection_changed(is_selected: bool, selected_crew_name: String) -> void:
	var crew_was_selected = crew_selection.has(selected_crew_name)
	if is_selected and not crew_was_selected:
		crew_selection.push_back(selected_crew_name)
	if not is_selected and crew_was_selected:
		crew_selection.remove(crew_selection.find(selected_crew_name))
	if crew_selection.size() > max_crew_selected:
		var removed_crew_name = crew_selection.pop_front()
		for crew_name in vignettes:
			vignettes[removed_crew_name].set_selected(crew_selection.has(crew_name))


func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		hide()
