class_name Ship
extends Node2D

var speed_ua : float = 2.0 / 24.0
var distance_covered : float = 0.0
var food : int = 10
var watter : int = 10

func _ready() -> void:
	pass

func get_crew_members() -> Array:
	var crew_members = []
	for crew in $Crew.get_children():
		if crew is CrewMember:
			if crew.is_alive():
				crew_members.push_back(crew)
	return crew_members

func update_covered_distance(hour: int = 1) -> void:
	distance_covered += hour * speed_ua
