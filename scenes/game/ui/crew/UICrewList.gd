tool
class_name UICrewList
extends UIWindow

onready var list_container := $MarginContainer/Content/Body/VBoxContainer as VBoxContainer
var CrewMemberResource = load("res://scenes/game/ui/crew/UICrew.tscn")

func set_crew_members(crew_members: Array) -> void:
	for crew in crew_members:
		var c = CrewMemberResource.instance()
		c.set_crew_member(crew)
		list_container.add_child(c)
