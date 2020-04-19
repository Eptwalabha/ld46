class_name ShipRoom
extends Node2D

export(String) var room_name := ""
export(bool) var closed := false
export(int) var max_people := 3

var room_id : int
var contaminated : bool = false
var ship

func _init() -> void:
	room_id = GameData.get_id()

func _ready() -> void:
	ship = get_parent().get_parent()

func update_state() -> void:
	pass

func is_contaminated() -> bool:
	return contaminated

func get_contamination_factor() -> float:
	return 0.0

func exposed_to_virus(factor: float) -> void:
	if contaminated:
		return
	factor *= (1 - ship.air_filter_efficiency())
	contaminated = randf() < factor
