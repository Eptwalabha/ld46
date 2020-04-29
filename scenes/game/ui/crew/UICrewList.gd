tool
class_name UICrewList
extends UIWindow

signal on_crew_selected(crew_id)

onready var list_container := $MarginContainer/Content/Body/VBoxContainer as VBoxContainer
var CrewLine = load("res://scenes/game/ui/crew/stats/UICrewLine.tscn")

func set_crew_members(crew_members: Dictionary) -> void:
	for crew_name in crew_members:
		var crew = crew_members[crew_name]
		var line = CrewLine.instance()
		list_container.add_child(line)
		line.init(crew)
		line.connect("crew_member_selected", self, "_on_crew_clicked")

func _on_crew_clicked(crew) -> void:
	emit_signal("on_crew_selected", crew)

func refresh() -> void:
	pass

func select_crew(crew_name: String) -> void:
	for line in list_container.get_children():
		line.selected(line.crew.crew_name == crew_name)
