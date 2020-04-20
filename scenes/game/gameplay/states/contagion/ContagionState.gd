class_name ContagionState
extends Node

var crew

func _ready() -> void:
	crew = get_parent().get_parent()

func enter() -> void:
	pass

func update() -> String:
	return ""

func get_factor() -> float:
	return 0.0

func state_name() -> String:
	return ""

func exposed_to_virus(_contamination_factor: float) -> void:
	pass

func productivity() -> float:
	return 1.0

func is_infected() -> bool:
	return false

func is_dead() -> bool:
	return false

func update_crew_aspect() -> void:
	pass

func make_a_viral_test() -> void:
	pass
