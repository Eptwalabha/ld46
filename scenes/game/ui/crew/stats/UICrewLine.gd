extends Control

signal crew_member_selected(crew_name)

#var HumanStats = load("res://scenes/game/ui/crew/stats/UIHumanLineStats.tscn")
#var AndroidStats = load("res://scenes/game/ui/crew/stats/UIAndroidLineStats.tscn")
onready var stats : UIHumanLineStats = $Margin/Container/Infos/HumanLineStats as UIHumanLineStats
onready var color_rect := $Margin/Container/Selection as ColorRect

var is_selected
var crew

func prepare(the_crew) -> void:
	crew = the_crew
	if not the_crew.is_human():
		return
	stats.prepare(crew)
	$Margin/Container/Infos/Picture.texture = crew.get_texture()

func refresh() -> void:
	stats.refresh()

func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("crew_member_selected", crew.crew_name)

func selected(selected: bool) -> void:
	is_selected = selected
	color_rect.color.a = 1.0 if is_selected else 0.0
