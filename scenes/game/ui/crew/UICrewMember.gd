class_name UICrewMember
extends MarginContainer

onready var name_label := $HBoxContainer/HBoxContainer2/Name/Label as Label
var crew = null

func set_crew_member(my_crew: CrewMember) -> void:
	crew = my_crew
	print(crew)
	$HBoxContainer/HBoxContainer2/Name/Label.text = crew.crew_name
