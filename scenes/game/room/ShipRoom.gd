class_name ShipRoom
extends Node2D

export(String) var room_name := ""
export(bool) var closed := false
export(int) var max_people := 3
export(bool) var contaminated := false
export(bool) var contaminable := true

var room_id : int
var ship

func _init() -> void:
	room_id = GameData.get_id()

func _ready() -> void:
	ship = get_parent().get_parent()

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
