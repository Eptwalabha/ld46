tool
class_name UICrewList
extends UIWindow

onready var list_container := $MarginContainer/Content/Body/VBoxContainer as VBoxContainer
#var CrewHumanResource = load("res://scenes/game/ui/crew/UICrewHuman.tscn")
#var CrewAndroidResource = load("res://scenes/game/ui/crew/UICrewAndroid.tscn")
var CrewLine = load("res://scenes/game/ui/crew/stats/UICrewLine.tscn")

func set_crew_members(crew_members: Dictionary) -> void:
	for crew_name in crew_members:
		var crew = crew_members[crew_name]
		var line = CrewLine.instance()
#		var line = get_line(crew.is_human())
		list_container.add_child(line)
		line.prepare(crew)
#		line.set_crew_member(crew)

#func get_line(is_human: bool) -> UICrewMember:
#	if is_human:
#		return CrewHumanResource.instance()
#	return CrewAndroidResource.instance()

func refresh() -> void:
	for line in list_container.get_children():
		line.refresh()

func select_crew(crew_name: String) -> void:
	for line in list_container.get_children():
		line.selected(line.crew.crew_name == crew_name)
