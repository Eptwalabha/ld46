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

var current_room_state: RoomState
var states = {}

func _ready() -> void:
	states = {
		"cleaned": $States/Cleaned,
		"cleaning": $States/Cleaning,
		"contaminated": $States/Contaminated,
	}
	_change_state("cleaned")
	label.text = tr(room_name)
	ship = get_parent().get_parent()
	var positions = $Positions.get_children()
	for index in range(positions.size()):
		spaces[index] = ""

func update_state() -> void:
	var next_state = current_room_state.update_state()
	_change_state(next_state)
	current_room_state.update_visual()

func is_contaminated() -> bool:
	return current_room_state.is_contaminated()

func get_contamination_factor() -> float:
	return current_room_state.get_contamination_factor()

func visited_by(crew) -> void:
	current_room_state.visited_by(crew)

func contaminated_by_crew(crew) -> void:
	current_room_state.contaminated_by_crew(crew)

func is_available() -> bool:
	return current_room_state.is_available() and not is_full()

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

func _change_state(new_state: String) -> void:
	if new_state == "":
		return
	if current_room_state is RoomState and current_room_state.state_name() == new_state:
		return
	current_room_state = states[new_state]
	current_room_state.enter()
