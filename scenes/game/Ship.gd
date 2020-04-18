class_name Ship
extends Node2D

var speed_ua : float = 2 / 24

func _ready() -> void:
	pass

func get_crew_members() -> Array:
	var crew_members = []
	for crew in $Crew.get_children():
		if crew is CrewMember:
			if crew.is_alive():
				crew_members.push_back(crew)
	return crew_members
