tool
class_name UICrewMember
extends MarginContainer

onready var name_label := $Container/Stats/Name/Label as Label

var crew : CrewMember = null

func _ready() -> void:
	pass

func set_crew_member(my_crew: CrewMember) -> void:
	crew = my_crew
	name_label.text = crew.crew_name

func refresh() -> void:
	pass
