extends Control

signal crew_member_selected(crew)

#var HumanStats = load("res://scenes/game/ui/crew/stats/UIHumanLineStats.tscn")
#var AndroidStats = load("res://scenes/game/ui/crew/stats/UIAndroidLineStats.tscn")
onready var stats : UIHumanLineStats = $Margin/Container/Infos/HumanLineStats as UIHumanLineStats
onready var color_rect := $Margin/Container/Selection as ColorRect

var is_selected
var crew

func prepare(the_crew) -> void:
	if crew != null:
		crew.disconnect("crew_updated", self, "_on_crew_updated")
	crew = the_crew
	crew.connect("crew_updated", self, "_on_crew_updated")
	if not the_crew.is_human():
		return
	stats.prepare(crew)
	$Margin/Container/Infos/Picture.texture = crew.get_texture()

func refresh() -> void:
	stats.refresh()

func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("crew_member_selected", crew)

func selected(selected: bool) -> void:
	is_selected = selected
	color_rect.color.a = 1.0 if is_selected else 0.0

func _on_crew_updated() -> void:
	print("update of %s" % crew.crew_name)
