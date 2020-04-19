extends Control

signal selection_changed(crew_name)

onready var color_rect := $ColorRect as ColorRect
onready var crew_label := $VBoxContainer/CrewName as Label

var dead := false
var selected := false
var crew_name = ""

func set_crew(crew) -> void:
	crew_name = crew.crew_name
	crew_label.text = crew_name

func set_selected(is_selected: bool) -> void:
	selected = is_selected
	update_color()

func update_color() -> void:
#	if selected:
#		color_rect.color = Color(0.0, 0.5, 0.0, 0.3)
#	else:
#		color_rect.color = Color(0, 0, 0, 0.3)
	color_rect.color.g = 0.5 if selected else 0.0

func _on_CrewVignette_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		selected = not selected
		update_color()
		emit_signal("selection_changed", selected)
