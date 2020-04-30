extends Control

signal crew_member_selected(crew)

onready var color_rect := $Margin/Container/Selection as ColorRect
onready var health_state := $Margin/Container/Infos/VBoxContainer/Virus/State as Label
onready var picture := $Margin/Container/Infos/CenterContainer/Picture as TextureRect
onready var mourning_ribbon := $Margin/Container/Infos/CenterContainer/MourningRibbon as TextureRect

var is_selected
var crew

func init(the_crew) -> void:
	if crew != null:
		crew.disconnect("crew_updated", self, "_on_crew_updated")
	crew = the_crew
	crew.connect("crew_updated", self, "_on_crew_updated")
	if not the_crew.is_human():
		return
	picture.texture = crew.portrait

func refresh() -> void:
	pass

func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("crew_member_selected", crew)

func selected(selected: bool) -> void:
	is_selected = selected
	color_rect.color.a = 1.0 if is_selected else 0.0

func _on_crew_updated() -> void:
	_update_contagion_state()

func _update_contagion_state() -> void:
	mourning_ribbon.visible = not crew.is_alive()
	if not crew.is_alive():
		picture.modulate = Color(.8, .8, .8)
		health_state.text = tr("ui_health_state_dead")
	elif crew.is_healing():
		health_state.text = tr("ui_healing")
	elif crew.tested:
		if crew.is_test_positive:
			health_state.text = tr("ui_viral_test_positive")
		else:
			health_state.text = tr("ui_viral_test_negative")
	else:
		if crew.is_visibly_contaminated:
			health_state.text = tr("ui_viral_test_positive")
		else:
			health_state.text = tr("ui_no_diagnosis")
