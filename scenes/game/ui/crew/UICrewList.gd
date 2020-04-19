tool
class_name UICrewList
extends UIWindow

onready var list_container := $MarginContainer/Content/Body/VBoxContainer as VBoxContainer
var CrewHumanResource = load("res://scenes/game/ui/crew/UICrewHuman.tscn")
var CrewAndroidResource = load("res://scenes/game/ui/crew/UICrewAndroid.tscn")

func set_crew_members(crew_members: Array) -> void:
	for crew in crew_members:
		if not crew is CrewMember:
			continue
		var line = get_line(crew.is_human())
		list_container.add_child(line)
		line.set_crew_member(crew)

func get_line(is_human: bool) -> UICrewMember:
	if is_human:
		return CrewHumanResource.instance()
	return CrewAndroidResource.instance()

func refresh() -> void:
	for line in list_container.get_children():
		line.refresh()
