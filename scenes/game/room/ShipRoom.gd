tool
class_name ShipRoom
extends Node2D

onready var label := $Label/Label as Label

export(String) var room_name := ""
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
		spaces[index] = false

func update_state() -> void:
	if is_contaminated():
		modulate = Color.green

func is_contaminated() -> bool:
	return contaminable and contaminated

func get_contamination_factor() -> float:
	return 0.0

func exposed_to_virus(factor: float) -> void:
	if not contaminable or contaminated:
		return
	factor *= (1 - ship.air_filter_efficiency())
	contaminated = randf() < factor

func is_full() -> bool:
	for index in spaces:
		if spaces[index] == "":
			return false
	return true

func move_in(crew_name) -> Vector2:
	for index in spaces:
		if spaces[index] == "":
			spaces[index] = crew_name
			return $Positions.get_child(index).position
	return Vector2()

func leave_out(crew_name) -> void:
	for index in spaces:
		if spaces[index] == crew_name:
			spaces[index] == ""
			break
