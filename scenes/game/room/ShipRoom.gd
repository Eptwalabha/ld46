tool
class_name ShipRoom
extends Node2D

onready var label := $Label/Label as Label

export(String) var room_name := ""
export(String) var room_id := ""
export(bool) var closed := false
export(int) var max_people := 3
export(bool) var contaminated := false
export(bool) var contaminable := true

var ship
var spaces := {}

func _ready() -> void:
	label.text = tr(room_name)
	ship = get_parent().get_parent()
	var positions = $Positions.get_children()
	for index in range(positions.size()):
		spaces[index] = ""

func update_state() -> void:
	if is_contaminated():
		modulate = Color.green

func is_contaminated() -> bool:
	return contaminable and contaminated

func get_contamination_factor() -> float:
	return 0.3 if is_contaminated() else 0.0

func contaminated_by_crew(crew) -> void:
	if not contaminable or contaminated:
		return
	var factor = ship.air_filter_efficiency() * crew.infectiousness()
	contaminated = randf() < factor

func is_available() -> bool:
	return not closed and not is_full()

func is_full() -> bool:
	for index in spaces:
		if spaces[index] == "":
			return false
	return true

func crew_moves_in(crew_name) -> Vector2:
	for index in spaces:
		if spaces[index] == "":
			spaces[index] = crew_name
			return $Positions.get_child(index).position + position
	return Vector2() + position

func crew_leaves(crew_name) -> void:
	for index in spaces:
		if spaces[index] == crew_name:
			spaces[index] = ""
			break

func get_current_occupants() -> Array:
	var occupants = []
	for index in spaces:
		if spaces[index] != "":
			occupants.push_back(spaces[index])
	return occupants

func is_crew_an_occupant(crew_name) -> bool:
	for index in spaces:
		if spaces[index] == crew_name:
			return true
	return false
